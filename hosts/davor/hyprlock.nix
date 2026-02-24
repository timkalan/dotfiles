{ colors }:

let
  # hyprlock uses rgb(hex)/rgba(hex) format, not #hex
  toRgb = c: "rgb(${builtins.substring 1 6 c})";
in

{
  enable = true;
  settings = {
    general = {
      hide_cursor = true;
      grace = 0;
    };

    background = [
      {
        path = "$HOME/Pictures/Wallpapers/wallpaper.jpg";
        blur_passes = 3;
        blur_size = 8;
      }
    ];

    input-field = [
      {
        size = "600, 60";
        outline_thickness = 2;
        dots_size = 0.2;
        dots_spacing = 0.3;
        dots_center = true;
        rounding = 0;
        outer_color = toRgb colors.border;
        inner_color = toRgb colors.bg1;
        font_color = toRgb colors.fg;
        fade_on_empty = false;
        placeholder_text = "<span foreground=\"##${
          builtins.substring 1 6 colors.fg_dim
        }\">Enter Password</span>";
        hide_input = false;
        check_color = toRgb colors.accent;
        fail_color = toRgb colors.red;
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        position = "0, -50";
        halign = "center";
        valign = "center";
        font_family = colors.font;
      }
    ];

    label = [
      # Time
      {
        text = "cmd[update:1000] echo \"$(date +\"%H:%M\")\"";
        color = toRgb colors.fg;
        font_size = 72;
        font_family = colors.font;
        position = "0, 100";
        halign = "center";
        valign = "center";
      }
      # Date
      {
        text = "cmd[update:60000] echo \"$(date +\"%A, %B %d\")\"";
        color = toRgb colors.fg_dim;
        font_size = 18;
        font_family = colors.font;
        position = "0, 40";
        halign = "center";
        valign = "center";
      }
    ];
  };
}
