include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-drcom-auth
PKG_VERSION:=1.0.0
PKG_RELEASE:=1
PKG_LICENSE:=GPL-2.0-or-later
PKG_MAINTAINER:=Chaos Julien

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-drcom-auth
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Drcom 校园网自动认证 LuCI 应用
  PKGARCH:=all
  DEPENDS:=+luci-compat +curl
endef

define Package/luci-app-drcom-auth/description
  面向 OpenWrt/iStoreOS 的校园网 Drcom/ePortal 自动认证插件。
  提供自动重连、UCI 配置和 LuCI 状态页面。
endef

define Build/Compile
endef

define Package/luci-app-drcom-auth/conffiles
/etc/config/drcom-auth
endef

define Package/luci-app-drcom-auth/install
	$(CP) ./root/* $(1)/
endef

$(eval $(call BuildPackage,luci-app-drcom-auth))
