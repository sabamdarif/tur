TERMUX_PKG_HOMEPAGE=https://github.com/mjakeman/extension-manager
TERMUX_PKG_DESCRIPTION="A utility for browsing and installing GNOME Shell extensions"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6.3
TERMUX_PKG_SRCURL=https://github.com/mjakeman/extension-manager/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e5af7a2dbb7ba28c33c027e9d761d56c8b4aa92ca39940c71351a3af40e74fae
TERMUX_PKG_DEPENDS="gtk4, libadwaita, json-glib, libsoup3, libxml2"
TERMUX_PKG_BUILD_DEPENDS="blueprint-compiler, gettext, glib-cross, g-ir-scanner"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	-Dbacktrace=false
"

termux_step_pre_configure() {
	termux_setup_meson
	termux_setup_glib_cross_pkg_config_wrapper
	export TERMUX_MESON_ENABLE_SOVERSION=1
	sed -i 's/&> *\/dev\/stderr/> &2/g' /data/data/com.termux/files/home/termux-packages/scripts/build/termux_step_update_alternatives.sh
}

termux_step_post_make_install() {
	rm -rf $TERMUX_PREFIX/lib/python*/__pycache__
}
