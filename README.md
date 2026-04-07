# luci-app-drcom-auth

[![Build IPK](https://github.com/ChaosJulien/luci-app-drcom-auth/actions/workflows/build-ipk.yml/badge.svg)](https://github.com/ChaosJulien/luci-app-drcom-auth/actions/workflows/build-ipk.yml)
[![Release](https://img.shields.io/github/v/release/ChaosJulien/luci-app-drcom-auth?include_prereleases)](https://github.com/ChaosJulien/luci-app-drcom-auth/releases)
[![License: GPL-2.0-or-later](https://img.shields.io/badge/license-GPL--2.0--or--later-blue.svg)](LICENSE)

基于 OpenWrt / iStoreOS 的校园网 Drcom 自动认证插件，支持掉线自动恢复、LuCI 图形化管理。

## 功能

- 自动检测校园网认证状态并恢复网络
- 支持先解绑再登录，适配 Drcom / ePortal 场景
- LuCI 页面查看状态、日志，执行启动、停止、重启和立即检测
- UCI 配置，适合 OpenWrt 打包与维护

## 一键构建

推送 `v*` 标签或在 GitHub Actions 中手动触发后，会自动构建 `ipk`，并在发布流程中生成 GitHub Release。

## 安装

```bash
opkg install luci-app-drcom-auth_1.0.0-1_all.ipk
/etc/init.d/drcom-auth enable
/etc/init.d/drcom-auth start
```

## LuCI 菜单

```text
服务 -> 校园网认证
```

## 默认配置文件

`/etc/config/drcom-auth`

```uci
config drcom_auth 'main'
	option enabled '1'
	option auth_if 'eth0'
	option gateway_host '10.255.255.1'
	option login_url 'http://10.255.255.1/drcom/login'
	option unbind_url 'http://10.255.255.1:801/eportal/portal/mac/unbind'
	option username ''
	option password ''
	option wan_mac ''
	option mkkey '123456'
	option check_http_url 'http://connect.rom.miui.com/generate_204'
	option success_interval '30'
	option fail_confirm_delay '2'
	option unbind_delay '4'
	option login_delay '5'
	option max_backoff '60'
	option terminal_type '1'
	option js_version '4.1.3'
	option lang_primary 'zh-cn'
	option lang_secondary 'zh'
	option r1 '0'
	option r2 ''
	option r3 '0'
	option r6 '0'
	option para '00'
	option v6ip ''
	option unbind_first '1'
	option log_success '0'
```

## 发布

每次打 `v1.0.0` 这种 tag 时，Actions 会自动产出 Release 并附带 `ipk` 文件。

## 许可证

本项目采用 GPL-2.0-or-later，详见 [LICENSE](LICENSE)。
