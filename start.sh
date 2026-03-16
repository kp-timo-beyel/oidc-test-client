#!/usr/bin/env bash
set -e

PORT=8080
DIR="$(cd "$(dirname "$0")" && pwd)"

# Build URL (omit port for standard ports 80/443)
if [ "$PORT" = "80" ] || [ "$PORT" = "443" ]; then
    URL="http://localhost"
else
    URL="http://localhost:$PORT"
fi

# Check if port is already in use
if lsof -i ":$PORT" -sTCP:LISTEN -t &>/dev/null; then
    echo "Port $PORT is already in use. Opening browser anyway..."
    open "$URL"
    exit 0
fi

echo "Starting server on $URL ..."
cd "$DIR"

# Open browser after short delay (server needs a moment to start)
(sleep 0.5 && open "$URL") &

python3 -m http.server "$PORT"
