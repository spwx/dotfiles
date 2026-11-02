{ config, pkgs, lib, ... }:

{
  # Set once, on first install. Like system.stateVersion, don't bump it
  # casually: it keeps defaults stable, it doesn't pick the version.
  home.stateVersion = "26.11";

  # Let home-manager manage itself (gives you the `home-manager` CLI/news).
  programs.home-manager.enable = true;
}
