{ colors }:

{
  enable = true;

  settings = {
    positionX = "right";
    positionY = "top";
    layer = "overlay";
    control-center-layer = "top";
    layer-shell = true;
    cssPriority = "application";

    notification-window-width = 420;
    notification-icon-size = 48;

    timeout = 5;
    timeout-low = 3;
    timeout-critical = 0;

    fit-to-screen = true;
    control-center-margin-top = 10;
    control-center-margin-right = 10;
    control-center-margin-bottom = 10;
    control-center-width = 420;

    notification-2fa-action = true;
    notification-inline-replies = false;

    widgets = [
      "title"
      "notifications"
    ];
  };

  style = ''
    * {
      font-family: "${colors.font}", monospace;
      font-size: 14px;
    }

    .notification-row {
      outline: none;
    }

    .notification {
      border-radius: 0;
      margin: 4px 0;
      padding: 0;
      border: 2px solid ${colors.accent};
      background: ${colors.bg};
      color: ${colors.fg};
    }

    .notification .notification-default-action,
    .notification .notification-action {
      border-radius: 0;
      background: transparent;
      color: ${colors.fg};
    }

    .notification .notification-default-action:hover,
    .notification .notification-action:hover {
      background: ${colors.bg1};
    }

    .notification .notification-content {
      padding: 10px;
    }

    .notification .summary {
      font-weight: bold;
      color: ${colors.fg};
    }

    .notification .body {
      color: ${colors.fg_dim};
    }

    .notification.critical {
      border-color: ${colors.red};
    }

    .notification.low {
      border-color: ${colors.border};
    }

    /* Control center */
    .control-center {
      background: ${colors.bg};
      border: 2px solid ${colors.border};
      border-radius: 0;
      color: ${colors.fg};
    }

    .control-center .widget-title {
      color: ${colors.fg};
      padding: 10px;
      font-weight: bold;
    }

    .control-center .notification-row .notification {
      border: 2px solid ${colors.border};
      margin: 4px 10px;
    }

    /* Buttons */
    .close-button {
      background: ${colors.bg1};
      color: ${colors.fg};
      border-radius: 0;
      border: none;
    }

    .close-button:hover {
      background: ${colors.red};
      color: ${colors.fg};
    }

    /* Waybar indicator */
    .widget-title > button {
      background: ${colors.bg1};
      color: ${colors.fg};
      border-radius: 0;
      border: none;
      padding: 4px 8px;
    }

    .widget-title > button:hover {
      background: ${colors.bg2};
    }
  '';
}
