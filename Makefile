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
  TITLE:=Drcom campus network auto authentication LuCI app
  PKGARCH:=all
  DEPENDS:=+luci-compat +curl
endef

define Package/luci-app-drcom-auth/description
  Drcom/ePortal auto authentication app for OpenWrt and iStoreOS.
  Provides UCI configuration, LuCI pages, and reconnect automation.
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
