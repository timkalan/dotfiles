{ colors }:
{
  enable = true;
  settings = [
    {
      layer = "top";
      position = "top";
      spacing = 0;
      height = 26;

      modules-left = [
        "hyprland/workspaces"
      ];
      modules-center = [
        "clock"
      ];
      modules-right = [
        "bluetooth"
        "network"
        "wireplumber"
        "cpu"
        "custom/notification"
      ];

      "hyprland/workspaces" = {
        on-click = "activate";
        format = "{icon}";
        format-icons = {
          default = "";
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          active = "󱓻";
        };
        persistent-workspaces = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = [ ];
          "5" = [ ];
        };
      };

      clock = {
        format = "{:%d %B %H:%M}";
        format-alt = "{:%A W%V %Y}";
        tooltip = true;
        tooltip-format = "{calendar}";
        calendar = {
          format = {
            today = "<b><u>{}</u></b>";
          };
        };
      };

      cpu = {
        interval = 5;
        format = "󰍛";
        on-click = "ghostty -e btop";
      };

      network = {
        format-icons = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        format = "{icon}";
        format-wifi = "{icon}";
        format-ethernet = "󰀂";
        format-disconnected = "󰖪";
        tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-disconnected = "Disconnected";
        interval = 3;
        on-click = "ghostty -e nmtui";
      };

      "custom/notification" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          notification = "󰂚";
          none = "󰂜";
          dnd-notification = "󰂛";
          dnd-none = "󰪑";
        };
        exec = "swaync-client -swb";
        exec-if = "which swaync-client";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -C -sw";
        return-type = "json";
        escape = true;
      };

      bluetooth = {
        format = "󰂯";
        format-off = "󰂲";
        format-disabled = "󰂲";
        format-connected = "";
        tooltip-format = "Devices connected: {num_connections}";
        on-click = "ghostty -e bluetuith";
      };

      wireplumber = {
        format = "󰕾";
        format-muted = "󰝟";
        scroll-step = 5;
        on-click = "pavucontrol";
        tooltip-format = "Playing at {volume}%";
        on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        max-volume = 150;
      };

    }
  ];

  style = ''
    @define-color bg ${colors.bg};
    @define-color bg1 ${colors.bg1};
    @define-color fg ${colors.fg};
    @define-color fg_dim ${colors.fg_dim};
    @define-color accent ${colors.accent};
    @define-color border ${colors.border};
    @define-color red ${colors.red};

    * {
      font-family: "${colors.font}", monospace;
      font-size: 14px;
      min-height: 0;
      border: none;
      border-radius: 0;
    }

    window#waybar {
      background-color: alpha(@bg, 0.85);
      color: @fg_dim;
    }

    tooltip {
      background-color: @bg1;
      color: @fg;
      border: 1px solid @border;
      border-radius: 0;
    }

    /* ── Workspaces ─────────────────────────────────────── */
    #workspaces button {
      padding: 0 6px;
      color: @fg_dim;
      background: transparent;
    }

    #workspaces button.active {
      color: @accent;
    }

    #workspaces button.urgent {
      color: @red;
    }

    #workspaces button:hover {
      background: transparent;
      color: @fg;
    }

    /* ── Clock ──────────────────────────────────────────── */
    #clock {
      color: @fg;
    }

    /* ── Right modules ──────────────────────────────────── */
    #custom-notification,
    #bluetooth,
    #network,
    #wireplumber,
    #cpu {
      margin: 0 8px;
      min-width: 16px;
      color: @fg_dim;
    }

    #wireplumber.muted {
      color: @border;
    }

    #bluetooth.connected {
      color: @accent;
    }

    #network.disconnected {
      color: @border;
    }
  '';
}
