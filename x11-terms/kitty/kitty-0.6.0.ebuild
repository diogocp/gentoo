# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1 flag-o-matic gnome2-utils xdg-utils

DESCRIPTION="A cross-platform, fast, feature full, GPU based terminal emulator"
HOMEPAGE="https://github.com/kovidgoyal/kitty"
SRC_URI="https://github.com/kovidgoyal/kitty/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="wayland"

RDEPEND="dev-libs/libunistring
	media-libs/harfbuzz
	media-libs/libpng:0
	media-libs/fontconfig
	media-libs/freetype
	sys-libs/zlib
	wayland? ( dev-libs/wayland-protocols )" # maybe just DEPEND?
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	local opt="$(get-flag -O)"
	sed -i -e "s/-O3/${opt}/g" -e 's/-Werror//g' setup.py || die
}

src_install() {
	esetup.py linux-package --prefix "${ED}/usr"
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
