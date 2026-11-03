# Subjective Fixes

Items from the 2026-11-02 code review that are judgement calls rather than
clear bugs. None of these were changed; each needs a decision.

## Security

- **Third-party Homebrew tap** (`nix/darwin.nix`, `acsandmann/tap`). Needed
  for rift, and `upgrade = false` limits surprise updates, but the tap is
  unpinned. Worth keeping in mind; packaging rift in a local overlay would
  pin it via `flake.lock`.

## Maintainability

- **iTerm2 sections** (`macos_install.org`, "Downloads" and "iTerm2
  Configuration"). WezTerm is now installed and configured by home-manager;
  if iTerm2 is no longer used, these sections are stale.
