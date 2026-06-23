# devon — host-side launcher for the devon NixOS VM (vfkit + gvproxy).
# Wraps scripts/devon-vfkit.sh as a closure-correct package: vfkit/gvproxy come
# from runtimeInputs (no per-start `nix build`), shellcheck runs at build time,
# and the VM shape (cpus/memory/ssh_port/mac) is declared here, not in bash.
{
  writeShellApplication,
  vfkit,
  gvproxy,
  sshPort ? 2223,
}:

let
  cpus = 4;
  memory = 6144; # MiB
  # gvproxy hands the guest NIC this fixed MAC over the vfkit unix socket; the
  # vfkit virtio-net mac= must match it or DHCP/forwarding silently break.
  mac = "5a:94:ef:e4:0c:ee";
in
writeShellApplication {
  name = "devon";
  runtimeInputs = [
    vfkit
    gvproxy
  ];
  text = ''
    cpus=${toString cpus}
    memory=${toString memory}
    ssh_port=${toString sshPort}
    mac="${mac}"
  ''
  + builtins.readFile ./devon-vfkit.sh;
}
