TERMUX_PKG_HOMEPAGE=https://www.libreoffice.org/
TERMUX_PKG_DESCRIPTION="Private, free and open source office suite"
TERMUX_PKG_LICENSE="MPL-2.0, LGPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux-user-repository"
TERMUX_PKG_VERSION="25.8.4.2"
TERMUX_PKG_SRCURL="https://download.documentfoundation.org/libreoffice/src/${TERMUX_PKG_VERSION%.*}/libreoffice-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=1a33dd5888e0b5db648f608e1c6ed7581ec1784f565f38e5c537efa09eacf419
TERMUX_PKG_DEPENDS="argon2, bison, boost, clucene, cups, curl, dbus, desktop-file-utils, fontconfig, freetype, g-ir-scanner, glm, gobject-introspection, gpgme, harfbuzz-icu, hicolor-icon-theme, hunspell, libabw, libatomic-ops, libcairo, libcdr, libcmis, libcurl, libe-book, libeot, libepoxy, libepubgen, libetonyek, libexpat, libexttextcat, libfreehand, libglvnd, libgraphite, libhyphen, libicu, libjpeg-turbo, liblangtag, libmspub, libmwaw, libneon, libnspr, libnss, libnumbertext, libodfgen, liborcus, libpagemaker, libpng, libqxp, libraptor2, librevenge, libstaroffice, libtiff, libtommath, libtommath-static, libvisio, libwebp, libwpd, libwpg, libwps, libx11, libxext, libxinerama, libxml2, libxml2-utils, libxrandr, libxslt, libzmf, libzxing-cpp, littlecms, lpsolve, mdds, openjpeg, openldap, openssl, pango, poppler, python, redland, shared-mime-info, which, xmlsec, xsltproc, zlib"
TERMUX_PKG_BUILD_DEPENDS="ant, boost-headers, cppunit, gtk3, gtk4, icu-devtools, mariadb, openjdk-21, openjdk-21-x, postgresql, qt6-qtmultimedia, unixodbc"
TERMUX_PKG_RECOMMENDS="gtk3, gtk4, openjdk-21, openjdk-21-x, qt6-qtmultimedia"
TERMUX_PKG_BUILD_IN_SRC=true
# TERMUX_PKG_EXTRA_MAKE_ARGS="DESTDIR=$TERMUX_PKG_TMPDIR"
# TERMUX_PKG_EXTRA_MAKE_ARGS="dbglevel=2"
TERMUX_PKG_MAKE_INSTALL_TARGET="distro-pack-install"
# Ref: https://gitlab.archlinux.org/archlinux/packaging/packages/libreoffice-fresh/-/blob/06b81628d9fd65a1ba42a7e2bd52e7ff2f57cc2d/PKGBUILD

# TODO (of knyipab): remove --disable-skia, vulkan-related compilation error
# TODO (of knyipab): possibly add junit pacakge for java unit test and remove --without-junit
# TODO: replace --enable-debug with --enable-release-build

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-avahi
--disable-breakpad
--disable-coinmp
--disable-dconf
--disable-dependency-tracking
--disable-firebird-sdbc
--disable-gstreamer-1-0
--disable-odk
--disable-online-update
--disable-report-builder
--disable-sdremote
--disable-sdremote-bluetooth
--disable-skia
--enable-curl
--enable-dbus
--enable-debug
--enable-ext-nlpsolver
--enable-ext-wiki-publisher
--enable-gtk3
--enable-gtk4
--enable-introspection
--enable-openssl
--enable-python=system
--enable-qt6
--enable-scripting-beanshell
--enable-scripting-javascript
--enable-split-app-modules
--host=$TERMUX_ARCH-linux
--with-ant-home=$TERMUX_PREFIX/opt/ant
--with-boost=$TERMUX_PREFIX
--with-external-dict-dir=$TERMUX_PREFIX/share/hunspell
--with-external-hyph-dir=$TERMUX_PREFIX/share/hyphen
--with-jdk-home=$TERMUX_PREFIX/lib/jvm/java-21-openjdk
--with-parallelism=$TERMUX_PKG_MAKE_PROCESSES
--with-system-boost
--with-system-cairo
--with-system-clucene
--with-system-cppunit
--with-system-dicts
--with-system-glm
--with-system-gpgmepp
--with-system-graphite
--with-system-headers
--with-system-icu
--with-system-libabw
--with-system-libcdr
--with-system-libcmis
--with-system-libebook
--with-system-libepubgen
--with-system-libetonyek
--with-system-libexttextcat
--with-system-libfreehand
--with-system-liblangtag
--with-system-libmspub
--with-system-libmwaw
--with-system-libnumbertext
--with-system-libodfgen
--with-system-libpagemaker
--with-system-libqxp
--with-system-librevenge
--with-system-libs
--with-system-libstaroffice
--with-system-libtommath
--with-system-libvisio
--with-system-libwpd
--with-system-libwpg
--with-system-libwps
--with-system-libxml
--with-system-libzmf
--with-system-mdds
--with-system-orcus
--with-system-redland
--with-system-xmlsec
--with-system-zxing
--with-vendor=Termux
--without-fonts
--without-junit
--without-myspell-dicts
--without-system-beanshell
--without-system-box2d
--without-system-dragonbox
--without-system-firebird
--without-system-frozen
--without-system-hsqldb
--without-system-java-websocket
--without-system-libfixmath
--without-system-mythes
--without-system-rhino
--without-system-sane
--without-system-zxcvbn
--without-webdav
boost_cv_lib_tag=
ac_cv_header_CLucene_analysis_cjk_CJKAnalyzer_h=yes
"

termux_step_pre_configure() {
	find "$TERMUX_PKG_SRCDIR" -type f ! -name '*.mk' ! -name '*.fetch' -print0 | \
		xargs -0 sed -i \
		-e "s|/tmp|$TERMUX_PREFIX/tmp|g"

	rm setup.cfg

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		termux-fix-shebang ./solenv/bin/*
	fi

	export qt6_libexec_dirs="$TERMUX_PREFIX/lib/qt6"
	CXXFLAGS+=" -I$TERMUX_PKG_SRCDIR/include"
	CXXFLAGS+=" -I$TERMUX_PKG_SRCDIR/helpcompiler/inc"
	CXXFLAGS+=" -I$TERMUX_PKG_SRCDIR/xmlhelp/source/cxxhelp/inc"
	# LDFLAGS+=" -Wl,--undefined-version"

	NOCONFIGURE=1 ./autogen.sh
}
