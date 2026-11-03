{ config, pkgs, lib, ... }:

let
  # Neovim for vscode-neovim only, with its plugins built in (versions are
  # pinned by flake.lock). The terminal `nvim` (EDITOR) stays plain.
  # wrapRc = false keeps the wrapper from passing its own generated config,
  # so vscode-neovim's init.lua still loads.
  vscodeNeovim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
    plugins = [ pkgs.vimPlugins.nvim-surround ];
    wrapRc = false;
  };
in
{
  # Set once, on first install. Like system.stateVersion, don't bump it
  # casually: it keeps defaults stable, it doesn't pick the version.
  home.stateVersion = "26.11";

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
    };
  };

  # `--cmd cd` makes zoxide define `cd` (and `cdi`) itself, with completion,
  # instead of `z` plus an alias.
  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

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
  # ssh (writes ~/.ssh/config)
  # ---------------------------------------------------------------------------
  # enableDefaultConfig = false drops home-manager's old built-in defaults
  # (it warns that they're going away); openssh's own defaults apply instead.
  # The "*" block is always written last, after the specific hosts.
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "pve proxmox".User = "root";
      # Unlock keys with the passphrase saved by `ssh-add --apple-use-keychain`
      # and load them into the agent on first use, so nothing needs
      # re-adding after a reboot.
      "*" = {
        UseKeychain = "yes";
        AddKeysToAgent = "yes";
      };
    };
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

    # Rust. rustup and its proxies (cargo, rustc, rust-analyzer...) come from
    # Nix; the toolchains themselves still live in ~/.rustup and are managed
    # with rustup commands. Projects pin theirs with per-project flakes.
    # rust-analyzer is a rustup component, not a package here: the rustup
    # package ships a rust-analyzer proxy that would collide with it.
    bacon
    rustup

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
  # so edits to init.lua apply immediately, without a rebuild. Plugins come
  # from vscodeNeovim (top of this file), not a plugin manager.
  xdg.configFile."vscode-neovim-config/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/vscode-neovim-config/init.lua";

  # VS Code settings for vscode-neovim. VS Code itself is the Homebrew cask
  # (package = null). mutableUserSettings merges these keys into the
  # existing settings.json on every switch (these win on conflict) instead
  # of replacing it with a read-only store link, so VS Code can still save
  # its own settings. The nvim path follows the Nix package (vscodeNeovim),
  # so it can't go stale the way /opt/homebrew/bin/nvim did.
  programs.vscode = {
    enable = true;
    package = null;
    profiles.default = {
      mutableUserSettings = true;
      userSettings = {
        "vscode-neovim.neovimExecutablePaths.darwin" = lib.getExe vscodeNeovim;
        "vscode-neovim.neovimInitVimPaths.darwin" =
          "${config.xdg.configHome}/vscode-neovim-config/init.lua";
      };
    };
  };

  # ---------------------------------------------------------------------------
  # Shell environment (used by every shell home-manager manages)
  # ---------------------------------------------------------------------------
  # Prepended to PATH in this order. ~/.cargo/bin holds `cargo install`
  # tools only; rustup itself comes from home.packages.
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
    "$HOME/.opencode/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    COLORTERM = "truecolor";
    LANG = "en_US.UTF-8";
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
      vi = "nvim";
      cat = "bat";
      ssh = "env TERM=xterm-256color ssh";
    };

    interactiveShellInit = ''
      set -g fish_greeting   # no greeting
    '';
  };
}
