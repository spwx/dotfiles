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

  # ---------------------------------------------------------------------------
  # Shell environment (used by every shell home-manager manages)
  # ---------------------------------------------------------------------------
  # Prepended to PATH in this order. ~/.cargo/bin is also added by rustup's
  # conf.d/rustup.fish; listing it here keeps the order predictable.
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.toolbox/bin"
    "$HOME/go/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    COLORTERM = "truecolor";
    LANG = "en_US.UTF-8";
    LANGUAGE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    BAT_THEME = "gruvbox-dark";
    BAT_STYLE = "plain";
    FZF_DEFAULT_OPTS = "--layout=reverse --cycle --height=40% --color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934";
  };

  # ---------------------------------------------------------------------------
  # fish (the binary and login shell come from nix-darwin; this is the config)
  # ---------------------------------------------------------------
  programs.fish = {
    enable = true;

    # Every fish shell, interactive or not.
    shellInit = ''
      # Homebrew (macOS only). Appended, so a Nix copy of a tool wi
      # a Homebrew copy of the same tool.
      if test -d /opt/homebrew/bin
          fish_add_path --global --append --path /opt/homebrew/bin /opt/homebrew/sbin
      end
    '';

    shellAliases = {
      cd = "z";
      vi = "nvim";
      ls = "eza";
      cat = "bat";
      ssh = "env TERM=xterm-256color ssh";
    };

    interactiveShellInit = ''
      set -g fish_greeting   # no greeting

      starship init fish | source
      zoxide init fish | source
      fzf --fish | source
      set -gx LS_COLORS (vivid generate gruvbox-dark-hard)
    '';
  };
}
