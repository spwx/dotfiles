# Window management: rift (tiling) and JankyBorders (focus borders).
{ ... }:

{
  # JankyBorders from nixpkgs, run as a launchd agent by nix-darwin.
  # Replaces the Homebrew `borders` service and borders/bordersrc.
  services.jankyborders = {
    enable = true;
    style = "round";
    width = 9.0;
    active_color = "0xFF30C489";
    inactive_color = "0xff504945";
  };

  # rift isn't in nixpkgs, so the binary still comes from Homebrew
  # (acsandmann/tap/rift); nix-darwin only owns the launchd agent.
  # Replaces the agent `rift service install` created
  # (~/Library/LaunchAgents/git.acsandmann.rift.plist).
  launchd.user.agents.rift = {
    serviceConfig = {
      ProgramArguments = [ "/opt/homebrew/bin/rift" ];
      RunAtLoad = true;
      KeepAlive = {
        Crashed = true;
        SuccessfulExit = false;
      };
      LimitLoadToSessionType = "Aqua";
      ProcessType = "Interactive";
      Nice = -20;
      EnvironmentVariables = {
        RUST_LOG = "error,warn,info";
        # So commands run from rift's config can find your tools.
        PATH = builtins.concatStringsSep ":" [
          "/Users/spw/.nix-profile/bin"
          "/etc/profiles/per-user/spw/bin"
          "/run/current-system/sw/bin"
          "/nix/var/nix/profiles/default/bin"
          "/opt/homebrew/bin"
          "/opt/homebrew/sbin"
          "/usr/local/bin"
          "/usr/bin"
          "/bin"
          "/usr/sbin"
          "/sbin"
        ];
      };
      StandardOutPath = "/tmp/rift_spw.out.log";
      StandardErrorPath = "/tmp/rift_spw.err.log";
    };
  };
}
