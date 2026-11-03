# Subjective Fixes

Items from the 2026-11-02 code review that are judgement calls rather than
clear bugs. None of these were changed; each needs a decision.

## Security

- **Third-party Homebrew tap** (`nix/darwin.nix`, `acsandmann/tap`). Needed
  for rift, and `upgrade = false` limits surprise updates, but the tap is
  unpinned. Worth keeping in mind; packaging rift in a local overlay would
  pin it via `flake.lock`.

## Correctness (verify)

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
- **Empty `environment.systemPackages = with pkgs; [ ];`** (`nix/darwin.nix`).
  Kept as a placeholder per its comment; the `with pkgs;` is unused until
  something is added.
