# Window management: rift (tiling) and JankyBorders (focus borders).
{ config, username, ... }:

let
  home = config.users.users.${username}.home;
in
{
  # JankyBorders from nixpkgs, run as a launchd agent by nix-darwin.
  # Replaces the Homebrew `borders` service and borders/bordersrc.
  services.jankyborders = {
    enable = true;
    style = "round";
    width = 9.0;
    active_color = "0xFF30C489";
    inactive_color = "0xFF504945";
  };

  # rift isn't in nixpkgs, so the binary still comes from Homebrew
  # (acsandmann/tap/rift); nix-darwin only owns the launchd agent.
  # Replaces the agent `rift service install` created
  # (~/Library/LaunchAgents/git.acsandmann.rift.plist).
  launchd.user.agents.rift = {
    serviceConfig = {
      ProgramArguments = [ "${config.homebrew.prefix}/bin/rift" ];
      RunAtLoad = true;
      KeepAlive = {
        Crashed = true;
        SuccessfulExit = false;
      };
      LimitLoadToSessionType = "Aqua";
      ProcessType = "Interactive";
      Nice = -20;
      EnvironmentVariables = {
        RUST_LOG = "info";
        # So commands run from rift's config can find your tools.
        PATH = builtins.concatStringsSep ":" [
          "${home}/.nix-profile/bin"
          "/etc/profiles/per-user/${username}/bin"
          "/run/current-system/sw/bin"
          "/nix/var/nix/profiles/default/bin"
          "${config.homebrew.prefix}/bin"
          "${config.homebrew.prefix}/sbin"
          "/usr/local/bin"
          "/usr/bin"
          "/bin"
          "/usr/sbin"
          "/sbin"
        ];
      };
      # Logs go in your own Library, not /tmp: /tmp is shared with other
      # users and is wiped on reboot.
      StandardOutPath = "${home}/Library/Logs/rift.out.log";
      StandardErrorPath = "${home}/Library/Logs/rift.err.log";
    };
  };
}
