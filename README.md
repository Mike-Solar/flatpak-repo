# flatpak-repo

自托管 Flatpak 源（OSTree 仓库，托管于 Cloudflare R2）。

## 包含应用

| App ID | 应用 | 来源 |
|---|---|---|
| `cn.feishu.Feishu` | 飞书 | feishu.cn 官方 deb 重打包 |
| `cn.wps.Office` | WPS Office 国内版 | wpscdn 官方 deb 重打包 |
| `io.github.MoeKoeMusic.MoeKoeMusic` | MoeKoeMusic（第三方酷狗客户端） | GitHub Release 重打包 |

## 使用（客户端）

```bash
flatpak remote-add --no-gpg-verify mikesolar https://pub-d650dee4ae024660b2e2657f6bbbdb3f.r2.dev/repo
flatpak install mikesolar cn.feishu.Feishu
flatpak install mikesolar cn.wps.Office
flatpak install mikesolar io.github.MoeKoeMusic.MoeKoeMusic
```

## 构建

GitHub Actions：`push` 到 main 或手动触发 → flatpak-builder 构建三个 manifest
→ `build-update-repo` 生成 OSTree 仓库 → `aws s3 sync` 到 R2 bucket 的 `repo/` 前缀。

## 更新应用版本

编辑 `manifests/*.yaml` 中 sources 的 `url` 和 `sha256`，push 即可。
（上游无稳定版本 API，飞书可查 https://www.feishu.cn/api/downloads ，
MoeKoeMusic 查 GitHub Releases，WPS 查 linux.wps.cn。）

## 说明

- 三个包均为官方二进制重打包（binary repack），未修改程序本体。
- Electron 应用（飞书、MoeKoeMusic）以 `--no-sandbox` 启动：
  flatpak 容器内 setuid chrome-sandbox 不可用，这是社区重打包的通行做法。
- 仓库当前未做 GPG 签名（`--no-gpg-verify`），自用足够；如分发他人建议补签名。
- WPS 为 11.1.0.11723 国内经典版（12.x CDN 有防盗链，暂未纳入）。
