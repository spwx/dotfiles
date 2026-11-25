# Pull Google Calendar iCal feeds into Org files for the Emacs agenda.
# Packaged by writeShellApplication in home.nix (which adds the shebang,
# `set -euo pipefail` and curl/ical2orgpy on PATH); run every 30 min by the
# launchd agent there.
#
# Feeds are listed in ~/.config/org-cal-sync/calendars as "name URL" lines
# (kept out of Nix: the URLs are secret and the store is world-readable).
# Each becomes ~/org/calendars/<name>.org, overwritten every run.
conf="$HOME/.config/org-cal-sync/calendars"
out="$HOME/org/calendars"
mkdir -p "$out"
if [ ! -f "$conf" ]; then
  echo "no config at $conf" >&2
  exit 1
fi

status=0
# `|| [ -n "$name" ]`: read fails on a last line with no trailing newline,
# but still fills in the variables, so don't skip that line.
while read -r name url || [ -n "$name" ]; do
  case "$name" in '' | \#*) continue ;; esac
  tmp=$(mktemp)
  if curl -fsSL --max-time 60 "$url" -o "$tmp.ics" &&
    ical2orgpy --continue-on-error --days 180 "$tmp.ics" "$tmp" &&
    [ -s "$tmp" ]; then
    mv "$tmp" "$out/$name.org"
    echo "$(date '+%F %T') synced $name"
  else
    echo "$(date '+%F %T') FAILED $name (kept previous file)" >&2
    rm -f "$tmp"
    status=1
  fi
  rm -f "$tmp.ics"
done <"$conf"
exit "$status"
