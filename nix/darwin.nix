{ pkgs, username, ... }:

{
  imports = [
    ./macos-defaults.nix
    ./window-management.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Allow packages with non-free licenses from nixpkgs.
  nixpkgs.config.allowUnfree = true;

  # Read the nix-darwin changelog before changing this.
  system.stateVersion = 6;

  # The user that Homebrew and per-user macOS settings apply to.
  system.primaryUser = username;
  users.users.${username}.home = "/Users/${username}";

  # ---------------------------------------------------------------------------
  # Nix itself (replaces the installer-generated /etc/nix/nix.conf)
  # ---------------------------------------------------------------------------
  # Track the newest Nix release instead of nixpkgs' default (older) one.
  nix.package = pkgs.nixVersions.latest;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    always-allow-substitutes = true;
    extra-nix-path = "nixpkgs=flake:nixpkgs";
  };

  # Weekly garbage collection: Sundays at 3am, keep the last 30 days.
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 3; Minute = 0; };
    options = "--delete-older-than 30d";
  };

  # Deduplicate identical files in /nix/store.
  nix.optimise.automatic = true;

  # ---------------------------------------------------------------------------
  # Touch ID for sudo (reattach makes it work inside terminal multiplexers)
  # ---------------------------------------------------------------------------
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  # ---------------------------------------------------------------------------
  # System packages (installed for all users from nixpkgs)
  # Empty for now; packages move here or into home-manager later.
  # ---------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [ ];

  # Fonts, installed into /Library/Fonts/Nix Fonts.
  fonts.packages = with pkgs; [
    nerd-fonts.victor-mono
  ];

  # ---------------------------------------------------------------------------
  # Shell: fish from Nix, so it reads nix-darwin's /etc/fish setup.
  # The login shell itself is set by hand: chsh -s /run/current-system/sw/bin/fish
  # ---------------------------------------------------------------------------
  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  # ---------------------------------------------------------------------------
  # Homebrew, declared instead of installed by hand
  #
  # This list is the source of truth: cleanup = "uninstall" removes any
  # formula, cask or tap that isn't listed here on every switch. Install
  # things by adding them here, not with `brew install`.
  # ("zap" would also delete uninstalled casks' app data.)
  # ---------------------------------------------------------------------------
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false; # don't run `brew update` on every switch
      upgrade = false;    # don't upgrade packages on every switch
      cleanup = "uninstall";
    };

    taps = [
      "acsandmann/tap"
    ];

    brews = [
      "acsandmann/tap/rift"
    ];

    casks = [
      "8bitdo-ultimate-software-v2"
      "claude-code"
      "moonlight"
      "raycast"
      "signal"
      "visual-studio-code"
    ];
  };
}
