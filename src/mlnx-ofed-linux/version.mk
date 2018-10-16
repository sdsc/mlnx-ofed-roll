NAME              = mlnx-ofed-linux
VERSION           = 4.3
RELEASE           = 1.0.1.0
DISTRO            = rhel6.9
EXTRA             = $(DISTRO)-x86_64
PKGROOT           = /opt/mlnx-ofed-linux

SRC_SUBDIR        = mlnx-ofed-linux

SOURCE_NAME       = MLNX_OFED_LINUX
SOURCE_SUFFIX     = tgz
SOURCE_VERSION    = $(VERSION)-$(RELEASE)-$(EXTRA)
SOURCE_PKG        = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_PKG_EXT    = $(SOURCE_NAME)-$(SOURCE_VERSION)-ext.$(SOURCE_SUFFIX)
SOURCE_DIR        = $(SOURCE_NAME)-$(SOURCE_VERSION)
SOURCE_DIR_EXT    = $(SOURCE_NAME)-$(SOURCE_VERSION)-ext

TGZ_PKGS          = $(SOURCE_PKG)

RPM.EXTRAS        = AutoReq:No
