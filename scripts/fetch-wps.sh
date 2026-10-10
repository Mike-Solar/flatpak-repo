#!/bin/bash
# 下载 WPS 国内版 deb（官方 CDN 需要时效签名：k = md5(key + uri + ts)）
# 版本升级：改下面三个变量 + manifest 里的 sha256
set -euo pipefail

WPS_VER="12.1.2.28080"
WPS_BUILD="28080"
WPS_SHA256="2fa999f60a71e21093ab49ef6d7f61d7668c844bfebf30907d2c290e460f9be0"

SECRET="7f8faaaa468174dc1c9cd62e5f218a5b"
URI="/wps/download/ep/Linux2023/${WPS_BUILD}/wps-office_${WPS_VER}.AK.preread.sw.Personal_765474_amd64.deb"
TS=$(date +%s)
SIG=$(echo -n "${SECRET}${URI}${TS}" | md5sum | cut -d' ' -f1)
URL="https://wps-linux-personal.wpscdn.cn${URI}?t=${TS}&k=${SIG}"

mkdir -p downloads
OUT="downloads/wps-office_${WPS_VER}_amd64.deb"
echo "下载 $URL"
curl -sfL --retry 3 -o "$OUT" "$URL"
echo "${WPS_SHA256}  ${OUT}" | sha256sum -c -
