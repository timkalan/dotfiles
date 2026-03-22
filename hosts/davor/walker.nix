{ colors }:
{
  enable = true;
  runAsService = true;

  config = {
    close_when_open = true;
    click_to_close = true;
    force_keyboard_focus = true;
    theme = "gruvbox";

    placeholders.default = {
      input = "Search...";
      list = "Start typing...";
    };

    keybinds = {
      next = [ "ctrl j" "Down" ];
      previous = [ "ctrl k" "Up" ];
      close = [ "Escape" ];
    };

    providers = {
      default = [
        "desktopapplications"
        "calc"
        "websearch"
      ];
      empty = [
        "desktopapplications"
      ];
      prefixes = [
        { prefix = "="; provider = "calc"; }
        { prefix = "@"; provider = "websearch"; }
        { prefix = ":"; provider = "clipboard"; }
        { prefix = "."; provider = "emojis"; }
        { prefix = "/"; provider = "files"; }
        { prefix = ";"; provider = "providerlist"; }
        { prefix = ">"; provider = "runner"; }
      ];
    };
  };

  themes."gruvbox" = {
    style = ''
      @define-color window_bg_color ${colors.bg};
      @define-color accent_bg_color ${colors.bg1};
      @define-color theme_fg_color ${colors.fg};
      @define-color error_bg_color ${colors.bright_red};
      @define-color error_fg_color ${colors.fg};

      * {
        all: unset;
        font-family: '${colors.font}', monospace;
        font-size: 16px;
      }

      .normal-icons { -gtk-icon-size: 16px; }
      .large-icons { -gtk-icon-size: 32px; }

      scrollbar { opacity: 0; }

      .box-wrapper {
        background: ${colors.bg};
        padding: 20px;
        border: 2px solid ${colors.border};
        border-radius: 0;
      }

      .search-container {
        border-radius: 0;
      }

      .input placeholder {
        opacity: 0.5;
      }

      .input selection {
        background: ${colors.bg2};
      }

      .input {
        caret-color: ${colors.accent};
        background: ${colors.bg};
        padding: 10px;
        border-bottom: 1px solid ${colors.bg2};
        color: ${colors.fg};
      }

      .list {
        color: ${colors.fg};
      }

      .item-box {
        padding: 10px;
        border-radius: 0;
      }

      child:selected .item-box,
      row:selected .item-box {
        background: ${colors.bg1};
      }

      child:selected .item-box label,
      row:selected .item-box label {
        color: ${colors.accent};
      }

      .item-subtext {
        font-size: 12px;
        opacity: 0.5;
      }

      .item-image-text {
        font-size: 28px;
      }

      .preview {
        border: 1px solid ${colors.bg2};
        color: ${colors.fg};
      }

      .preview-box,
      .elephant-hint,
      .placeholder {
        color: ${colors.fg};
      }

      .calc .item-text {
        font-size: 24px;
        color: ${colors.bright_green};
      }

      .symbols .item-image {
        font-size: 24px;
      }

      .bluetooth.disconnected {
        opacity: 0.5;
      }

      .keybinds {
        padding-top: 10px;
        border-top: 1px solid ${colors.bg2};
        font-size: 12px;
        color: ${colors.fg_dim};
      }

      .keybind-button {
        opacity: 0.5;
      }

      .keybind-bind {
        text-transform: lowercase;
        opacity: 0.35;
      }

      .keybind-label {
        padding: 2px 4px;
        border: 1px solid ${colors.bg3};
        color: ${colors.fg_dim};
      }

      .error {
        padding: 10px;
        background: ${colors.bright_red};
        color: ${colors.fg};
      }

      .preview-content.archlinuxpkgs,
      .preview-content.dnfpackages {
        font-family: monospace;
      }
    '';
  };
}
