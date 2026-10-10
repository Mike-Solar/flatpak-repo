#!/bin/bash
# WPS 版本检查：盯 AUR wps-office-cn 的 pkgver（AUR 维护者跟踪官方 12.x），
# 有新版本就用签名 URL 下载并更新 manifest + fetch-wps.sh。
set -euo pipefail

CUR=$(grep -oP '(?<=WPS_VER=")[^"]+' scripts/fetch-wps.sh)
AUR=$(curl -sfL --max-time 30 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=wps-office-cn')
NEW=$(echo "$AUR" | grep -oP '(?<=^pkgver=)[\d.]+' | head -1)

if [ -z "$NEW" ]; then
  echo "无法从 AUR 获取版本号" >&2
  exit 1
fi
if [ "$NEW" = "$CUR" ]; then
  echo "WPS 已是最新: $CUR"
  exit 0
fi
echo "发现新版本: $CUR -> $NEW"

BUILD="${NEW##*.}"
SECRET="7f8faaaa468174dc1c9cd62e5f218a5b"
URI="/wps/download/ep/Linux2023/${BUILD}/wps-office_${NEW}.AK.preread.sw.Personal_765474_amd64.deb"
TS=$(date +%s)
SIG=$(echo -n "${SECRET}${URI}${TS}" | md5sum | cut -d' ' -f1)
URL="https://wps-linux-personal.wpscdn.cn${URI}?t=${TS}&k=${SIG}"

mkdir -p downloads
OUT="downloads/wps-office_${NEW}_amd64.deb"
echo "下载新版本..."
curl -sfL --retry 3 -o "$OUT" "$URL"
SHA=$(sha256sum "$OUT" | cut -d' ' -f1)
echo "sha256: $SHA"

sed -i "s/^WPS_VER=.*/WPS_VER=\"${NEW}\"/; s/^WPS_BUILD=.*/WPS_BUILD=\"${BUILD}\"/; s/^WPS_SHA256=.*/WPS_SHA256=\"${SHA}\"/" scripts/fetch-wps.sh
sed -i "s|path: ../downloads/wps-office_[0-9.]*_amd64.deb|path: ../downloads/wps-office_${NEW}_amd64.deb|; s|sha256: [0-9a-f]\{64\}|sha256: ${SHA}|" manifests/cn.wps.Office.yaml
rm -f "downloads/wps-office_${CUR}_amd64.deb"

[ -n "${GITHUB_OUTPUT:-}" ] && echo "NEW_VER=${NEW}" >> "$GITHUB_OUTPUT"
echo "WPS 更新完成: $NEW"
