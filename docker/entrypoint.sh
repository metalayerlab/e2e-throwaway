#!/bin/sh
# Entrypoint and `docker exec` wrapper for e2e-throwaway. Template-owned.
#
# Installed as /opt/e2e-throwaway/bin/e2e-throwaway, ahead of the real one in
# /opt/venv/bin on PATH, so both container start and `docker exec <c> e2e-throwaway ...`
# come through here.
#
# Started as root (the image default): give the state directory to PUID:PGID
# (default 1000:1000, the image's e2e-throwaway user) and drop to that user.
# Started as anyone else (`--user`, Kubernetes runAsUser): run as-is, and leave
# ownership to whoever chose that user.
set -e

BIN=/opt/venv/bin/e2e-throwaway

if [ "$(id -u)" != "0" ]; then
    exec "$BIN" "$@"
fi

PUID="${PUID:-1000}"
PGID="${PGID:-1000}"
case "$PUID$PGID" in
    *[!0-9]*) echo "ERROR: PUID and PGID must be numeric (got PUID=$PUID PGID=$PGID)" >&2; exit 1 ;;
esac

STATE_DIR="${E2E_THROWAWAY_STATE_DIR:-/var/lib/e2e-throwaway}"
mkdir -p "$STATE_DIR"
if [ "$(stat -c %u:%g "$STATE_DIR")" != "$PUID:$PGID" ]; then
    echo "INFO: setting ownership of $STATE_DIR to $PUID:$PGID" >&2
    chown -R "$PUID:$PGID" "$STATE_DIR"
fi

# setpriv leaves HOME at /root, unreadable after the drop: use the uid's home
# from /etc/passwd if it is writable, otherwise /tmp
HOME_DIR="$(getent passwd "$PUID" | cut -d: -f6)"
if [ -n "$HOME_DIR" ] && [ -d "$HOME_DIR" ] && \
        setpriv --reuid="$PUID" --regid="$PGID" --clear-groups -- test -w "$HOME_DIR"; then
    export HOME="$HOME_DIR"
else
    export HOME=/tmp
fi

exec setpriv --reuid="$PUID" --regid="$PGID" --clear-groups -- "$BIN" "$@"
