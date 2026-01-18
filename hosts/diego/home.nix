{
  lib,
  ...
}:

{
  imports = [
    ../../shared/home.nix
  ];

  programs.ghostty = {
    # We override 'package' to null because on Mac we use the DMG/Brew version.
    package = lib.mkForce null;

    # Add Mac-specific Keybinds
    settings = {
      keybind = [
        "cmd+t=unbind"
        "cmd+w=unbind"
        "cmd+n=unbind"
        "cmd+d=unbind"
        "cmd+shift+d=unbind"
        "cmd+enter=unbind"
      ];
    };
  };

  xdg.configFile."aerospace/aerospace.toml".source = ../../configs/aerospace/aerospace.toml;
}
