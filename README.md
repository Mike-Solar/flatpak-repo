# flatpak-repo

自托管 Flatpak 源（OSTree 仓库，GPG 签名，托管于 Cloudflare R2）。

## 包含应用

| App ID | 应用 | 来源 |
|---|---|---|
| `cn.feishu.Feishu` | 飞书 | feishu.cn 官方 deb 重打包 |
| `cn.wps.Office` | WPS Office 国内版 | wpscdn 官方 deb 重打包 |
| `io.github.MoeKoeMusic.MoeKoeMusic` | MoeKoeMusic（第三方酷狗客户端） | GitHub Release 重打包 |
| `io.github.MCDFsteve.NipaPlay-Reload` | NipaPlay | AppImage 重打包 |

全部基于 **org.freedesktop.Platform 26.08** 运行时。

## 使用（客户端）

```bash
# 添加源（带 GPG 校验，推荐）
flatpak remote-add mikesolar https://flatpak.rjs04.com/mikesolar.flatpakrepo

# 安装
flatpak install mikesolar cn.feishu.Feishu
flatpak install mikesolar cn.wps.Office
flatpak install mikesolar io.github.MoeKoeMusic.MoeKoeMusic
flatpak install mikesolar io.github.MCDFsteve.NipaPlay-Reload
```

签名公钥指纹：`2EBACB345EEE12989141A60FBE75E703425025BA`
（已内嵌在 .flatpakrepo 文件中，添加源时自动导入，无需手动操作）

## 构建

GitHub Actions：`push` 到 main / **每天 05:00 (CST) 定时** / 手动触发 →
flatpak-builder 构建 manifest → GPG 签名（`build-sign` 每个 ref + `build-update-repo` 签名 summary）
→ `aws s3 sync` 到 R2 bucket 的 `repo/` 前缀。

## 更新应用版本

编辑 `manifests/*.yaml` 中 sources 的 `url` 和 `sha256`，push 即可。
（飞书可查 https://www.feishu.cn/api/downloads ，MoeKoeMusic 查 GitHub Releases，WPS 走 AUR pkgver 轮询脚本。）

## 说明

- 包均为官方二进制重打包（binary repack），未修改程序本体。
- Electron 应用以 `--no-sandbox` 启动：flatpak 容器内 setuid chrome-sandbox 不可用，这是社区重打包的通行做法。
- 相关项目：pacman 源见 [pacman-repo](https://github.com/Mike-Solar/pacman-repo)（pacman.rjs04.com）。
