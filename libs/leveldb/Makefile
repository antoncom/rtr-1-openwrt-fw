include $(TOPDIR)/rules.mk

PKG_NAME:=leveldb
PKG_VERSION:=1.23
PKG_RELEASE:=1
PKG_INSTALL:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/google/leveldb.git
PKG_MIRROR_HASH:=f00db96e81a001d6a619c681e91181abfbc3dc83ccb9593cf4e5104a7ca4fe47
PKG_SOURCE_VERSION:=99b3c03b3284f5886f9ef9a4ef703d57373e61be
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/leveldb/Default
	TITLE:=(leveldb)A key/value database library
	URL:=https://code.google.com/p/leveldb/
	MAINTAINER:=code.google.com
endef

define Package/leveldb
	SECTION:=libs
	CATEGORY:=Libraries
	SUBMENU:=Database
	TITLE:=A fast and lightweight key/value database library
	URL:=https://code.google.com/p/leveldb/
	DEPENDS:=+libstdcpp +libpthread +snappy
	DEFAULT:=y
	ABI_VERSION:=1.23
endef

CMAKE_OPTIONS += \
		-DCMAKE_BUILD_TYPE=Release \
		-DBUILD_SHARED_LIBS=ON \
		-DLEVELDB_BUILD_BENCHMARKS=OFF \
		-DLEVELDB_BUILD_TESTS=OFF

TARGET_CFLAGS += \
		-D_GLIBCXX_USE_C99

define Package/leveldb/Default/description
		A fast and lightweight key/value database library
endef

define Build/Compile
		$(call Build/Compile/Default)
endef

define Package/leveldb/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/libleveldb.so.$(ABI_VERSION)* $(1)/usr/lib
	ln -s /usr/lib/libleveldb.so.1.23.0 $(1)/usr/lib/libleveldb.so.1
	ln -s /usr/lib/libleveldb.so.1.23.0 $(1)/usr/lib/libleveldb.so
endef

$(eval $(call BuildPackage,leveldb))