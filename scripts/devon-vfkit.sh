# devon-vfkit — run the devon NixOS VM under vfkit instead of UTM.
#
# `utmctl start devon` drives UTM.app over Apple Events (TCC) and hangs. vfkit
# talks to Apple's Virtualization.framework directly — no app, no daemon, no
# Apple Events — so `start` is deterministic. gvproxy supplies user-mode
# networking; the guest's sshd is reachable at localhost:2223.
#
# Persistence: vfkit boots a fixed raw disk with no snapshot, so guest state
# survives start/stop — devon stays a pet.
#
# vfkit and gvproxy are provided by this script's Nix wrapper (runtimeInputs);
# cpus, memory, ssh_port and mac are injected by it too.
# Subcommands: start | stop | status | ssh [args…] | logs

data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/devon-vfkit"
# devon.img was seeded once as an APFS copy-on-write clone of the UTM disk:
#   cp -c "$HOME/Library/Containers/com.utmapp.UTM/Data/Documents/devon.utm/Data/"*.img "$disk"
disk="$data_dir/devon.img"
efi_vars="$data_dir/efi_vars.fd"
net_sock="$data_dir/net.sock"
serial_log="$data_dir/serial.log"
gvproxy_log="$data_dir/gvproxy.log"
vfkit_log="$data_dir/vfkit.log"
gvproxy_pid="$data_dir/gvproxy.pid"
vfkit_pid="$data_dir/vfkit.pid"
known_hosts="$data_dir/known_hosts"

rest_host="127.0.0.1:8081"
ssh_user="$USER"

die() {
    echo "devon-vfkit: $*" >&2
    exit 1
}

pid_alive() {
    local f="$1"
    [[ -f "$f" ]] && kill -0 "$(cat "$f")" 2>/dev/null
}
running() { pid_alive "$vfkit_pid"; }

cmd_start() {
    running && {
        echo "already running (vfkit pid $(cat "$vfkit_pid"))"
        return
    }
    [[ -f "$disk" ]] || die "no disk at $disk — see the comment above 'disk=' to seed it"
    mkdir -p "$data_dir"
    rm -f "$net_sock" "$gvproxy_pid" "$vfkit_pid"

    daemonize "$gvproxy_log" gvproxy -mtu 1500 -ssh-port "$ssh_port" \
        -listen-vfkit "unixgram://$net_sock" -pid-file "$gvproxy_pid" -log-file "$gvproxy_log"
    local i
    for ((i = 0; i < 50; i++)); do
        [[ -S "$net_sock" ]] && break
        sleep 0.1
    done
    [[ -S "$net_sock" ]] || die "gvproxy did not create $net_sock (see $gvproxy_log)"

    local gui=()
    [[ "${DEVON_VFKIT_GUI:-0}" == 1 ]] && gui=(--gui)
    daemonize "$vfkit_log" vfkit --cpus "$cpus" --memory "$memory" "${gui[@]+"${gui[@]}"}" \
        --bootloader "efi,variable-store=$efi_vars,create" \
        --device "virtio-blk,path=$disk" \
        --device "virtio-net,unixSocketPath=$net_sock,mac=$mac" \
        --device "rosetta,mountTag=rosetta" \
        --device "virtio-rng" \
        --device "virtio-serial,logFilePath=$serial_log" \
        --restful-uri "tcp://$rest_host" --pidfile "$vfkit_pid"
    for ((i = 0; i < 50; i++)); do
        [[ -f "$vfkit_pid" ]] && break
        sleep 0.1
    done

    # gvproxy's listener answers immediately; poll for the guest's real SSH banner
    # so "started" means "ready to ssh" — otherwise `devon ssh` races the boot.
    local ready=0 banner
    printf 'devon booting'
    for ((i = 0; i < 60; i++)); do
        running || {
            printf '\n'
            die "vfkit exited during boot — try 'devon logs'"
        }
        banner="$(nc -w 2 127.0.0.1 "$ssh_port" </dev/null 2>/dev/null || true)"
        case "$banner" in *SSH-2.0*)
            ready=1
            break
            ;;
        esac
        printf '.'
        sleep 1
    done
    printf '\n'
    if [[ "$ready" == 1 ]]; then
        echo "devon started (cpus=$cpus memory=${memory}M, ssh on localhost:$ssh_port)."
        echo "  devon ssh    # log in   |   devon status   |   devon stop"
    else
        echo "devon-vfkit: vfkit is up but sshd didn't answer on :$ssh_port within 60s — try 'devon logs'." >&2
        return 1
    fi
}

# Background "$@" with SIGHUP ignored, stdio appended to $1. vfkit handles only
# SIGINT/SIGTERM, so SIGHUP keeps its default (terminate) — closing the terminal
# would otherwise hang up vfkit and hard-kill the guest; nohup neutralizes that.
daemonize() {
    local log="$1"
    shift
    nohup "$@" >>"$log" 2>&1 </dev/null &
}

cmd_stop() {
    if running; then
        echo "requesting graceful shutdown…"
        curl -fsS --max-time 5 -X POST "http://$rest_host/vm/state" -d '{"state":"Stop"}' >/dev/null 2>&1 || true
        local i
        for ((i = 0; i < 30; i++)); do
            running || break
            sleep 1
        done
        running && {
            echo "graceful stop timed out — killing vfkit."
            kill -9 "$(cat "$vfkit_pid")" 2>/dev/null || true
        }
    fi
    pid_alive "$gvproxy_pid" && kill "$(cat "$gvproxy_pid")" 2>/dev/null || true
    rm -f "$net_sock" "$vfkit_pid" "$gvproxy_pid"
    echo "devon-vfkit stopped."
}

cmd_status() {
    if running; then
        echo "vfkit:   running (pid $(cat "$vfkit_pid"))"
    else echo "vfkit:   stopped"; fi
    if pid_alive "$gvproxy_pid"; then
        echo "gvproxy: running (pid $(cat "$gvproxy_pid"))"
    else echo "gvproxy: stopped"; fi
    printf 'state:   '
    curl -fsS --max-time 3 "http://$rest_host/vm/state" 2>/dev/null || printf '(vfkit not answering)'
    echo
    echo "disk:    $disk"
    echo "ssh:     ${ssh_user}@localhost:${ssh_port}"
}

cmd_ssh() {
    running || die "not running — 'devon start' first"
    mkdir -p "$data_dir"
    exec ssh -A -p "$ssh_port" \
        -o UserKnownHostsFile="$known_hosts" \
        -o StrictHostKeyChecking=accept-new \
        "$ssh_user@localhost" "$@"
}

cmd_logs() {
    local pair
    for pair in "serial:$serial_log" "vfkit:$vfkit_log" "gvproxy:$gvproxy_log"; do
        echo "== ${pair%%:*} (${pair#*:}) =="
        [[ -f "${pair#*:}" ]] && cat "${pair#*:}" || echo "(none)"
        echo
    done
}

case "${1:-}" in
start) cmd_start ;;
stop) cmd_stop ;;
status) cmd_status ;;
ssh)
    shift
    cmd_ssh "$@"
    ;;
logs) cmd_logs ;;
*)
    echo "usage: devon {start|stop|status|ssh [args…]|logs}" >&2
    exit 2
    ;;
esac
