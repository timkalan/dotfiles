{ colors }:

{
  enable = true;
  settings = {
    font = "${colors.font} 11";
    background-color = colors.bg;
    text-color = colors.fg;
    border-color = colors.border;
    progress-color = "over ${colors.accent}";
    border-size = 2;
    border-radius = 0;
    padding = "10";
    margin = "10";
    width = 420;
    height = 110;
    default-timeout = 5000;
    max-visible = 5;
    layer = "overlay";
    anchor = "top-right";
    group-by = "app-name";
    format = "<b>%s</b>\\n%b";
    markup = true;
    actions = true;
    icon-path = "";

    "urgency=low" = {
      border-color = colors.border;
    };
    "urgency=normal" = {
      border-color = colors.accent;
    };
    "urgency=critical" = {
      border-color = colors.red;
      default-timeout = 0;
    };
  };
}
