{
  enable = true;
  settings = {
    general = {
      lock_cmd = "pgrep -x hyprlock > /dev/null || hyprlock";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms(\"on\")'";
    };

    # Only the lock rule is live. Hyprland 0.56.2 / aquamarine 0.15.0 lose
    # track of page flips whenever the output is torn down and brought back,
    # leaving it disabled ("Connector DP-2 enabledState changed true -> false")
    # while dpms-on still reports ok. The screen never returns and only an ssh
    # session can recover it. Both blanking and suspending hit this.
    #
    # Upstream fix is aquamarine "drm: fix uaf in frameIdle" (2026-09-09),
    # not in any tagged release yet. Re-enable the two rules below once
    # `nix eval nixpkgs#aquamarine.version` reports something past 0.15.0.
    listener = [
      # Lock screen after 5 minutes
      {
        timeout = 300;
        on-timeout = "pgrep -x hyprlock > /dev/null || hyprlock";
      }
      # Turn off display after 5.5 minutes
      # {
      #   timeout = 330;
      #   on-timeout = "hyprctl dispatch 'hl.dsp.dpms(\"off\")'";
      #   on-resume = "hyprctl dispatch 'hl.dsp.dpms(\"on\")'";
      # }
      # Sleep 10 minutes after the lock screen comes up. ignore_inhibit with a
      # hyprlock condition means media can hold the screen awake without also
      # deferring sleep once we are actually locked.
      # {
      #   timeout = 900;
      #   on-timeout = "systemctl suspend";
      #   ignore_inhibit = true;
      #   condition_cmd = "pgrep -x hyprlock > /dev/null";
      #   condition_retry = 60;
      # }
    ];
  };
}
