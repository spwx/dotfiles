# Handoff: migrate user config to home-manager

Written 2026-11-02, at the end of the nix-darwin migration. The next job is to
bring in **home-manager** (as a nix-darwin module) and move the user's CLI
tools, fish shell and dotfiles into it. Delete this file when the migration
is done.

## How the user wants to work (read this first)

- **For system setup, explain the steps and let the user run them.** Don't
  write files, build, or run commands unless they explicitly ask you to do a
  step. Read-only inspection (`ls`, `cat`, `defaults read`, `brew list`,
  `nix eval`) is fine for tailoring advice. When they do ask you to do it,
  finish with a list of every file you changed.
- **You can't use `sudo`** (it needs a password). Hand every `sudo` command
  to the user. Touch ID now works for sudo, including inside tmux.
- **Split changes into logical commits** with short messages in the repo's
  style (`fish: …`, `darwin: …`, or a plain sentence). End each message with
  `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`. Push only when
  asked. Check `git fetch` first, since the repo also gets commits from
  another machine.
- The user is learning Nix. Explain *why* briefly, and give a recommendation
  rather than a survey of options.

## Current state

**Machine:** `Seans-MacBook-Pro`, Apple Silicon (`aarch64-darwin`), user
`spw`, home `/Users/spw`.

**Nix:** upstream Nix installed with `github.com/NixOS/nix-installer` (not
Determinate). nix-darwin manages it now: `nix.package =
pkgs.nixVersions.latest`, flakes on, weekly GC, auto-optimise.

**Repo:** `~/.dotfiles` (`git@github.com:spwx/dotfiles.git`, branch `main`),
pushed and clean as of the commit that added this note.

```
flake.nix                    # inputs: nixpkgs (unstable), nix-darwin (master, follows nixpkgs)
flake.lock
nix/darwin.nix               # Nix settings, Touch ID sudo, allowUnfree, Homebrew lists
nix/macos-defaults.nix       # system.defaults copied from the current settings
nix/window-management.nix    # services.jankyborders + launchd.user.agents.rift
fish/config.fish             # symlinked to ~/.config/fish/config.fish
fish/fish_variables          # symlinked to ~/.config/fish/fish_variables
starship/starship.toml       # symlinked to ~/.config/starship.toml
tmux/.tmux.conf              # symlinked to ~/.tmux.conf (+ xterm-24bit.terminfo)
vscode-neovim-config/init.lua  # symlinked into ~/.config/vscode-neovim-config/
*/setup.sh, mac_setup.sh     # the ln -s scripts that home-manager will replace
macos_install.org, kali_*    # old install notes and the Kali (Linux) setup
```

**Apply:** `sudo /run/current-system/sw/bin/darwin-rebuild switch --flake
~/.dotfiles`. The full path is needed because of the fish PATH problem below.

### Homebrew: `cleanup = "uninstall"` is ON

`nix/darwin.nix` is the source of truth for Homebrew. **Any formula, cask or
tap missing from `homebrew.brews` / `casks` / `taps` gets uninstalled on the
next switch.** So when you move a tool to home-manager, add it to
home-manager first, switch, check it resolves to the Nix copy, and only then
remove it from `brews`. Never remove something from `brews` while anything
still needs the Homebrew copy (above all, `fish` while it's the login shell).

Current `brews`: rift (from the `acsandmann/tap` tap), bacon, bat, cargo-deny,
eza, fd, fish, fzf, gh, git-delta, gitu, helix, herdr, imagemagick, neovim,
node, ocrmypdf, pandoc, pkgconf, pngpaste, podman, poppler, postgresql@18,
ripgrep, rust-analyzer, starship, tmux, tree, tuios, uv, vivid, yazi, zig,
zoxide.

Casks (stay in Homebrew): 8bitdo-ultimate-software-v2, claude-code,
font-victor-mono-nerd-font, mactex, meld, moonlight, raycast, signal,
visual-studio-code, wezterm.

**Stay in Homebrew:** `rift` (not in nixpkgs; nix-darwin runs its launchd
agent at `/opt/homebrew/bin/rift`), all casks, and probably `postgresql@18`
and `podman` (services and VM tooling; ask the user). Check every other
formula's nixpkgs name before moving it. For example, `git-delta` is `delta`
in nixpkgs, and some (`herdr`, `tuios`, `gitu`) may be missing or named
differently. Use `nix eval .#darwinConfigurations.Seans-MacBook-Pro.pkgs.<name>.version`.

### Fish: the main problem to solve

- The login shell is **Homebrew fish** (`/opt/homebrew/bin/fish`, listed in
  `/etc/shells`).
- Homebrew fish reads `/opt/homebrew/etc/fish`, **not** `/etc/fish`, so
  nix-darwin's shell setup never runs. That's why `/run/current-system/sw/bin`
  (and so `darwin-rebuild`) isn't on PATH in fish. zsh and bash are fine;
  nix-darwin owns `/etc/zshrc` and `/etc/bashrc`.
- `config.fish` works around this by sourcing
  `/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish` (adds
  `~/.nix-profile/bin` and the default profile), and ends with
  `direnv hook fish | source`. Both are temporary and go away once fish comes
  from Nix.
- `config.fish` also: puts `~/go/bin`, `~/.toolbox/bin`, `~/.local/bin` and
  `~/.cargo/bin` on PATH (some of them twice), runs `brew shellenv`, sets up
  starship, zoxide (`alias cd z`), fzf, eza, bat and vivid (`LS_COLORS`), sets
  `EDITOR=nvim` and `alias vi nvim`, and SSH/tmux tweaks. Everything runs inside
  `if status --is-interactive`.
- `~/.config/fish/conf.d/` holds `rustup.fish`, plus
  `fish_frozen_key_bindings.fish` and `fish_frozen_theme.fish`, which fish
  itself created. None of these are in the repo.
- `fish_variables` is symlinked from the repo. Fish rewrites that file
  itself, so it doesn't suit home-manager. Leave it alone, or stop tracking it.

**Plan:** in nix-darwin, set `programs.fish.enable = true;` and
`environment.shells = [ pkgs.fish ];`. The user then runs
`chsh -s /run/current-system/sw/bin/fish` themselves. Don't manage the login
shell with `users.knownUsers` / `users.users.spw.shell`, because that makes
nix-darwin own the user account. Then port `config.fish` into home-manager's
`programs.fish` (`interactiveShellInit`, `shellAliases`, `functions`), and
drop the `nix-daemon.fish` and direnv-hook lines. Once nothing uses Homebrew
fish, remove `fish` from `brews` and the Homebrew path from `/etc/shells`.

### Other loose ends home-manager should absorb

- **direnv:** `direnv` and `nix-direnv` are in the imperative `nix profile`
  (`nix profile list`). `~/.config/direnv/direnvrc` is a hand-written file
  containing `source $HOME/.nix-profile/share/nix-direnv/direnvrc`. Replace
  all of it with `programs.direnv = { enable = true; nix-direnv.enable =
  true; };`, then `nix profile remove direnv nix-direnv`. **Order matters:**
  remove the profile packages *after* the switch. Otherwise direnv breaks in
  `~/projects/site` (a Rust project whose dev shell is loaded by `.envrc` with
  `use flake`). Optional: `hide_env_diff = true` in `programs.direnv.config`.
- **Rust:** rustup lives in `~/.cargo/bin` (with cargo-nextest, sqlx,
  espflash and others installed through cargo). Projects use per-project
  flakes with rust-overlay instead. Leave rustup alone unless the user asks.
- **git:** `~/.gitconfig` (14 lines, delta as pager) and
  `~/.config/git/ignore` aren't in the repo. They're good candidates for
  `programs.git` plus `programs.delta`. The user's email is `sean@wall.ninja`.
- **neovim:** the binary stays (it's `EDITOR` and backs vscode-neovim), but
  there's deliberately **no** standalone `~/.config/nvim` on the Mac. Don't add
  one, and don't use `programs.neovim` to generate a config.
- **tmux, starship, vscode-neovim:** replace their `setup.sh` symlinks with
  `xdg.configFile` / `home.file`. Use
  `config.lib.file.mkOutOfStoreSymlink` if the user wants to keep editing the
  files in place without a rebuild.
- **Already removed, don't bring back:** atuin, pnpm, Emacs, AeroSpace,
  Bambu Studio and the macOS nvim setup.
- **`.gitignore`** still has `lazy-lock.json`, `spell` and `snippets/` from
  the old `nvim/` folder. They're harmless and can go during cleanup.
- **Linux:** the repo also holds Kali setup (`kali_setup.sh`,
  `kali_install.org`). The user wants one `home.nix` shared across macOS and
  Linux, so keep `home.nix` platform-neutral (`lib.optionals
  pkgs.stdenv.isDarwin`) and leave room for a standalone
  `homeConfigurations."spw@<host>"` output later.

## Suggested order

1. Add the `home-manager` input (`inputs.nixpkgs.follows = "nixpkgs"`) and
   `home-manager.darwinModules.home-manager`, with `useGlobalPkgs = true`,
   `useUserPackages = true` and `backupFileExtension = "before-home-manager"`.
   Use a minimal `nix/home.nix` (`home.stateVersion`; check the home-manager
   docs for the current release). Switch, then confirm
   `/etc/profiles/per-user/spw/bin` exists.
2. Move direnv and nix-direnv into home-manager. Switch, then remove them
   from `nix profile`, then check direnv in `~/projects/site`.
3. Move fish to Nix (nix-darwin `programs.fish`, then `chsh` by the user),
   then port `config.fish` to home-manager `programs.fish`. Remove the PATH
   workarounds. Plain `darwin-rebuild` should then work in fish.
4. Move CLI tools from `brews` to `home.packages` / `programs.*` a few at a
   time (add, switch, verify `which`, remove from `brews`, switch).
5. Replace the `setup.sh` symlink scripts with home-manager file management,
   and remove the scripts and `mac_setup.sh` lines.
6. Update `macos_install.org` and delete this file.

Build before every switch:
`nix build .#darwinConfigurations.Seans-MacBook-Pro.system --no-link`.
New files must be `git add`ed before Nix can see them.
