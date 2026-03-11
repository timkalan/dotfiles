{
  enable = true;
  settings = {
    general = {
      lock_cmd = "pidof hyprlock || hyprlock";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch dpms on";
    };

    listener = [
      # Lock screen after 5 minutes
      {
        timeout = 300;
        on-timeout = "loginctl lock-session";
      }
      # Turn off display after 5.5 minutes
      {
        timeout = 330;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
      # Sleep after 10 minutes of being locked (15 min total idle)
      {
        timeout = 900;
        on-timeout = "systemctl suspend";
      }
    ];
  };
}
