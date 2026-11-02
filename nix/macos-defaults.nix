# macOS settings, applied with `defaults write` on every switch.
#
# These mirror what was already set on this Mac (read with `defaults read`),
# so adding this file changed nothing. Anything not listed here keeps
# whatever value System Settings gives it.
#
# Full option list: https://nix-darwin.github.io/nix-darwin/manual/
# (search for "system.defaults").
{ ... }:

{
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      NSAutomaticCapitalizationEnabled = true;
      NSAutomaticPeriodSubstitutionEnabled = true;
    };

    dock = {
      autohide = true;
      wvous-br-corner = 1; # bottom-right hot corner: disabled
    };

    finder = {
      FXPreferredViewStyle = "Nlsv"; # list view
      NewWindowTarget = "Recents";
      ShowPathbar = true;
      ShowStatusBar = true;
      ShowExternalHardDrivesOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
    };

    trackpad = {
      Clicking = true; # tap to click
      TrackpadRightClick = true;
      Dragging = true;
      TrackpadThreeFingerDrag = false;
    };

    WindowManager = {
      GloballyEnabled = false; # Stage Manager off
      EnableTiledWindowMargins = false;
    };
  };
}
