{ config, pkgs, lib, ... }:

{
  # Set once, on first install. Like system.stateVersion, don't bump it
  # casually: it keeps defaults stable, it doesn't pick the version.
  home.stateVersion = "26.11";

  # Installs the `home-manager` CLI in standalone setups (Linux).
  # No effect under nix-darwin, where darwin-rebuild does the switching.
  programs.home-manager.enable = true;

  # direnv loads .envrc files per directory; nix-direnv makes `use flake`
  # fast and keeps dev-shell dependencies from being garbage-collected.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
  };

  # ---------------------------------------------------------------------------
  # CLI tools with home-manager modules. Each one installs the tool and adds
  # its shell setup to fish (and any other shell home-manager manages).
  # ---------------------------------------------------------------------------
  # Prompt. `settings` is written out as ~/.config/starship.toml.
  programs.starship = {
    enable = true;
    settings = {
      nodejs.disabled = true;
      # hostname.ssh_symbol = "";
    };
  };

  programs.zoxide.enable = true;     # provides `z`; `cd` is aliased to it

  programs.fzf = {
    enable = true;                   # Ctrl-R history, Ctrl-T files, Alt-C dirs
    defaultOptions = [ "--layout=reverse" "--cycle" "--height=40%" ];
    colors = {                       # gruvbox
      bg = "#32302f";     "bg+" = "#3c3836";
      fg = "#ebdbb2";     "fg+" = "#ebdbb2";
      hl = "#928374";     "hl+" = "#fb4934";
      header = "#928374"; info = "#8ec07c";
      prompt = "#fb4934"; pointer = "#fb4934";
      marker = "#fb4934"; spinner = "#fb4934";
    };
  };

  programs.eza.enable = true;        # also adds ll, la, lt, lla aliases

  programs.bat = {
    enable = true;
    config = { theme = "gruvbox-dark"; style = "plain"; };
  };

  # Terminal. No extraConfig yet, so it writes a minimal wezterm.lua.
  programs.wezterm.enable = true;

  programs.vivid = {
    enable = true;
    activeTheme = "gruvbox-dark-hard"; # sets LS_COLORS
  };

  # ---------------------------------------------------------------------------
  # git (writes ~/.config/git/config and ~/.config/git/ignore)
  # ---------------------------------------------------------------------------
  programs.git = {
    enable = true;
    settings = {
      user.name = "Sean Wall";
      user.email = "sean@wall.ninja";
      init.defaultBranch = "main";
      merge.conflictStyle = "zdiff3";
    };
    ignores = [ "**/.claude/settings.local.json" ];
  };

  # ---------------------------------------------------------------------------
  # Plain CLI tools (no config or shell setup needed)
  # ---------------------------------------------------------------------------
  home.packages = with pkgs; [
    # files and search
    fd
    ripgrep
    yazi

    # editor: EDITOR, and the binary behind vscode-neovim. Deliberately no
    # ~/.config/nvim, so it's a plain package rather than programs.neovim.
    neovim

    # git and GitHub
    gh
    gitu

    # Rust (toolchains come from rustup or per-project flakes)
    bacon
    rust-analyzer

    # other languages and tools
    uv
    zig

    # containers (VMs via `podman machine`)
    podman

    # terminal
    herdr
    tuios
  ];

  # ---------------------------------------------------------------------------
  # Dotfiles kept as files in this repo
  # ---------------------------------------------------------------------------
  # vscode-neovim's config (VS Code's settings.json points at this path).
  # mkOutOfStoreSymlink links to the repo checkout instead of a store copy,
  # so edits to init.lua apply immediately, without a rebuild. Only the file
  # is linked: lazy.nvim writes lazy-lock.json next to it.
  xdg.configFile."vscode-neovim-config/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/vscode-neovim-config/init.lua";

  # ---------------------------------------------------------------------------
  # Shell environment (used by every shell home-manager manages)
  # ---------------------------------------------------------------------------
  # Prepended to PATH in this order. ~/.cargo/bin is left to rustup's
  # conf.d/rustup.fish; listing it here too would add it twice.
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.toolbox/bin"
    "$HOME/go/bin"
    "$HOME/.opencode/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    COLORTERM = "truecolor";
    LANG = "en_US.UTF-8";
    LANGUAGE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  # ---------------------------------------------------------------------------
  # fish (the binary and login shell come from nix-darwin; this is the config)
  # ---------------------------------------------------------------------------
  programs.fish = {
    enable = true;

    # Every fish shell, interactive or not.
    shellInit = ''
      # Homebrew (macOS only). Appended, so a Nix copy of a tool wins over
      # a Homebrew copy of the same tool.
      if test -d /opt/homebrew/bin
          fish_add_path --global --append --path /opt/homebrew/bin /opt/homebrew/sbin
      end
    '';

    shellAliases = {
      cd = "z";
      vi = "nvim";
      cat = "bat";
      ssh = "env TERM=xterm-256color ssh";
    };

    interactiveShellInit = ''
      set -g fish_greeting   # no greeting
    '';
  };
}
