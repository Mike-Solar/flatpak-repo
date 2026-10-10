#!/bin/sh
# Flatpak launcher for NipaPlay (Flutter)
export LD_LIBRARY_PATH="/app/opt/nipaplay/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
exec /app/opt/nipaplay/NipaPlay "$@"
