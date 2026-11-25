{
  enable = true;
  settings = {
    general = {
      lock_cmd = "pgrep -x hyprlock > /dev/null || hyprlock";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms(\"on\")'";
    };

    listener = [
      # Lock screen after 5 minutes
      {
        timeout = 300;
        on-timeout = "pgrep -x hyprlock > /dev/null || hyprlock";
      }
      # Turn off display after 5.5 minutes
      {
        timeout = 330;
        on-timeout = "hyprctl dispatch 'hl.dsp.dpms(\"off\")'";
        on-resume = "hyprctl dispatch 'hl.dsp.dpms(\"on\")'";
      }
      # Sleep 10 minutes after the lock screen comes up. ignore_inhibit with a
      # hyprlock condition means media can hold the screen awake without also
      # deferring sleep once we are actually locked.
      {
        timeout = 900;
        on-timeout = "systemctl suspend";
        ignore_inhibit = true;
        condition_cmd = "pgrep -x hyprlock > /dev/null";
        condition_retry = 60;
      }
    ];
  };
}
