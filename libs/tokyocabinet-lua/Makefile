# 
# Copyright (C) 2007-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tokyocabinet-lua
PKG_VERSION:=1.10
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/FomaD-95/tokyocabinet-lua-1.10.git
PKG_MIRROR_HASH:=28ddc70bec3affbb978dec631bf14960a83816d4a1453a8c816437c14337fcf0
PKG_SOURCE_VERSION:=bd1d1ebee6f704247192d56fdfea9fedc3df4503
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/tokyocabinet-lua
  SUBMENU:=database
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=A library of routines to manage databases
  URL:=http://fallabs.com/tokyocabinet/
  DEPENDS:=+zlib +bzip2 +libpthread +librt +tokyocabinet
  MAINTAINER:=Obinou <obconseil@gmail.com>
endef

define Package/tokyocabinet-lua/description
 Tokyo Cabinet is a library of routines for managing a database.
 The database is a simple data file containing records, each
 is a pair of a key and a value. Every key and value is serial bytes
 with variable length. Both binary data and character string can be
 used as a key and a value. There is neither concept of data tables
 nor data types. Records are organized in hash table, B+ tree,
 or fixed-length array.

 Tokyo Cabinet is developed as the successor of GDBM and QDBM on the
 following purposes. They are achieved and Tokyo Cabinet replaces
 conventional DBM products.
endef

PKG_FIXUP:=autoreconf
    
define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(TAR) -xzf $(DL_DIR)/$(PKG_SOURCE) --strip=1 -C $(PKG_BUILD_DIR)
	/usr/bin/autoreconf -fiv $(PKG_BUILD_DIR)
endef

define Build/Configure
  $(call Build/Configure/Default,--with-linux-headers=$(LINUX_DIR))
endef

define Build/Compile
    $(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -fPIC" \
		LDFLAGS="$(TARGET_LDFLAGS)"
endef

define Package/tokyocabinet-lua/install
	$(INSTALL_DIR)  $(1)/usr/lib
	$(CP)  $(PKG_INSTALL_DIR)/usr/lib/libtokyocabinet-lua.so*  $(1)/usr/lib
	$(INSTALL_DIR)   $(1)/usr/share/tokyocabinet-lua
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/share/tokyocabinet/tokyocabinet-lua.idl $(1)/usr/share/tokyocabinet-lua
endef

$(eval $(call BuildPackage,tokyocabinet-lua))
