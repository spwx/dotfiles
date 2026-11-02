{ config, pkgs, lib, ... }:

{
  # Set once, on first install. Like system.stateVersion, don't bump it
  # casually: it keeps defaults stable, it doesn't pick the version.
  home.stateVersion = "26.11";

  # Let home-manager manage itself (gives you the `home-manager` CLI/news).
  programs.home-manager.enable = true;

  # direnv loads .envrc files per directory; nix-direnv makes `use flake`
  # fast and keeps dev-shell dependencies from being garbage-collected.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
  };
}
