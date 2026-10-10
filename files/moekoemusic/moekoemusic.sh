#!/bin/sh
# Flatpak launcher for MoeKoe Music (Electron, --no-sandbox for flatpak)
export LD_LIBRARY_PATH="/app/opt/MoeKoe Music${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
exec "/app/opt/MoeKoe Music/moekoemusic" --no-sandbox "$@"
