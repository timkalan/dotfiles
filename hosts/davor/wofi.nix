{ colors }:
{
  enable = true;
  settings = {
    width = 600;
    height = 350;
    location = "center";
    show = "drun";
    prompt = "Search...";
    filter_rate = 100;
    allow_markup = true;
    no_actions = true;
    halign = "fill";
    orientation = "vertical";
    content_halign = "fill";
    insensitive = true;
    allow_images = true;
    image_size = 40;
    gtk_dark = true;
  };
  style = ''
    * {
      font-family: '${colors.font}', monospace;
      font-size: 18px;
    }

    window {
      margin: 0px;
      padding: 0px;
      background-color: ${colors.bg};
      opacity: 0.95;
    }

    #inner-box {
      margin: 0;
      padding: 0;
      border: none;
      background-color: ${colors.bg};
    }

    #outer-box {
      margin: 0;
      padding: 20px;
      border: 2px solid ${colors.border};
      background-color: ${colors.bg};
    }

    #scroll {
      margin: 0;
      padding: 0;
      border: none;
      background-color: ${colors.bg};
    }

    #input {
      margin: 0;
      padding: 10px;
      border: none;
      background-color: ${colors.bg};
      color: ${colors.fg};
    }

    #input:focus {
      outline: none;
      box-shadow: none;
      border: none;
    }

    #text {
      margin: 5px;
      border: none;
      color: ${colors.fg_dim};
    }

    #entry {
      background-color: ${colors.bg};
    }

    #entry:selected {
      outline: none;
      border: none;
    }

    #entry:selected #text {
      color: ${colors.accent};
    }

    #entry image {
      -gtk-icon-transform: scale(0.7);
    }
  '';
}
