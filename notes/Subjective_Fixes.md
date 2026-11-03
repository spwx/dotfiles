# Subjective Fixes

Items from the 2026-11-02 code review that are judgement calls rather than
clear bugs. None of these were changed; each needs a decision.

## Security

- **Blank SSH passphrase advice** (`macos_install.org`, "Create An SSH Key").
  The guide notes a blank passphrase skips the keychain step. With
  `ssh-add --apple-use-keychain` the passphrase costs nothing day to day, so
  consider recommending one outright.
- **Third-party Homebrew tap** (`nix/darwin.nix`, `acsandmann/tap`). Needed
  for rift, and `upgrade = false` limits surprise updates, but the tap is
  unpinned. Worth keeping in mind; packaging rift in a local overlay would
  pin it via `flake.lock`.

## Correctness (verify)

- **`Nice = -20` on a user launchd agent** (`nix/window-management.nix`).
  Lowering nice below 0 normally needs root, so launchd may ignore it for a
  per-user agent. `ProcessType = "Interactive"` already gives rift priority.
  Check with `ps -o nice -p $(pgrep rift)`; drop the line if it shows 0.
- **`nix.settings.extra-nix-path = "nixpkgs=flake:nixpkgs"`** (`nix/darwin.nix`).
  `flake:nixpkgs` resolves through the flake registry, which points at the
  latest nixpkgs-unstable, not the revision in `flake.lock`. So
  `nix shell nixpkgs#foo` and `<nixpkgs>` may differ from the system's
  nixpkgs and download a second copy. Consider pinning the registry to the
  flake input (`nix.registry.nixpkgs.flake = nixpkgs;`, passing `nixpkgs`
  via `specialArgs`), or check whether nix-darwin's `nixpkgs.flake.*`
  options already do this.
- **`LANGUAGE = "en_US.UTF-8"`** (`nix/home.nix`). `LANGUAGE` is a
  colon-separated priority list of language names (e.g. `en_US:en`); the
  encoding suffix is usually ignored. Harmless, but `en_US:en` is the
  conventional value, or drop it since `LANG` already covers it.
- **Homebrew env in fish** (`nix/home.nix`, `shellInit`). Only adds
  `/opt/homebrew/{bin,sbin}` to PATH; `brew shellenv` also sets
  `HOMEBREW_PREFIX`, `MANPATH` and `INFOPATH`. Only matters if brew man pages
  or tools that read `HOMEBREW_PREFIX` are needed.

## Maintainability

- **Hard-coded `/opt/homebrew`** in `nix/window-management.nix` (rift path and
  PATH) and `nix/home.nix` (fish `shellInit`). Could come from nix-darwin's
  Homebrew prefix option instead of repeating the literal. Only Apple Silicon
  is targeted (`aarch64-darwin`), so this is tidiness, not a bug.
- **iTerm2 sections** (`macos_install.org`, "Downloads" and "iTerm2
  Configuration"). WezTerm is now installed and configured by home-manager;
  if iTerm2 is no longer used, these sections are stale.
- **`#+HTML_HEAD` points at `css/style.css`** (`macos_install.org`), which
  isn't in the repo. Remove or add the file if HTML export is used.
- **Commented-out starship option** (`nix/home.nix`,
  `# hostname.ssh_symbol = "";`). Delete or enable.
- **Empty `environment.systemPackages = with pkgs; [ ];`** (`nix/darwin.nix`).
  Kept as a placeholder per its comment; the `with pkgs;` is unused until
  something is added.
- **vscode-neovim keymaps that shadow defaults**
  (`vscode-neovim-config/init.lua`): `gh` replaces vscode-neovim's hover,
  `gf` (go to file) becomes format document, and `H`/`L` replace
  top/bottom-of-screen. Intentional choices, noted so they're deliberate.
