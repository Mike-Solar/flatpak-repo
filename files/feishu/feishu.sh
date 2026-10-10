#!/bin/sh
# Flatpak launcher for Feishu (Electron sandbox disabled — flatpak 内 setuid chrome-sandbox 不可用)
export LD_LIBRARY_PATH="/app/opt/bytedance/feishu:/app/opt/bytedance/feishu/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export GNOME_DISABLE_CRASH_DIALOG=SET_BY_GOOGLE_CHROME
exec /app/opt/bytedance/feishu/feishu --no-sandbox "$@"
