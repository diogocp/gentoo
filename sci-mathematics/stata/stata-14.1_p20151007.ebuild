# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils fdo-mime gnome2-utils

DESCRIPTION="Integrated statistics package with everything you need for data analysis"
HOMEPAGE="https://www.stata.com/"
SRC_URI="amd64? ( https://download.stata.com/download/linux64_14/Stata14Linux64.tar.gz -> ${P}-amd64.tar.gz )
	x86? ( https://download.stata.com/download/linux32_14/Stata14Linux32.tar.gz -> ${P}-x86.tar.gz )"

LICENSE="Stata14-EULA"
SLOT="14"
KEYWORDS="~amd64 ~x86"

IUSE="ncurses +system-jre X"
REQUIRED_USE="|| ( ncurses X )"

STATA_EDITION="$(printf 'stata_edition_%s ' ic mp se sm)"
IUSE+=" ${STATA_EDITION}"
REQUIRED_USE+=" ^^ ( ${STATA_EDITION} )"

RESTRICT="bindist fetch preserve-libs strip"
QA_PREBUILT="*"

DEPEND=""
RDEPEND="media-libs/libpng:1.2
	sys-devel/gcc
	sys-libs/glibc
	sys-libs/zlib
	ncurses? ( sys-libs/ncurses:5/5 )
	system-jre? ( virtual/jre:1.8 )
	X? ( app-arch/bzip2
		dev-libs/atk
		dev-libs/expat
		dev-libs/glib:2
		dev-libs/libbsd
		dev-libs/libffi
		dev-libs/libpcre
		media-gfx/graphite2
		media-libs/fontconfig
		media-libs/freetype
		media-libs/harfbuzz
		media-libs/libpng:0/16
		x11-libs/cairo
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:2
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXcomposite
		x11-libs/libXcursor
		x11-libs/libXdamage
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXi
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libxcb
		x11-libs/pango
		x11-libs/pixman )"

MY_PN="${PN}${SLOT}"
S="${WORKDIR}"

src_install() {
	local dir="/opt/${MY_PN}"

	dodir "${dir}"
	cd "${D}/${dir}" || die "cd failed"
	yes | sh "${S}/install" || die "install script failed"

	local edition
	use stata_edition_ic && edition=""
	use stata_edition_mp && edition="-mp"
	use stata_edition_se && edition="-se"
	use stata_edition_sm && edition="-sm"

	if use ncurses; then
		make_wrapper "${MY_PN}" "${dir}/stata${edition}"
	else
		rm stata stata-mp stata-se stata-sm || die "rm failed"
	fi

	if use X; then
		# HACK: manually install libpng16.so.16.2.0
		# in /opt/stata14/lib/ to get the icons to show
		# http://www.statalist.org/forums/forum/general-stata-discussion/general/2199
		make_wrapper "x${MY_PN}" "${dir}/xstata${edition}" "" "${dir}/lib"

		doicon "${MY_PN}.png"
		# TODO: these are unslotted
		for size in 16 24 32 48 128 256; do
			doicon -s $size -c mimetypes "${FILESDIR}/icons/${size}x${size}"/*
		done

		insinto "/usr/share/mime/packages/"
		doins "${FILESDIR}/mime/${PN}.xml"

		make_desktop_entry "x${MY_PN}" "Stata ${SLOT}" "${MY_PN}" \
			"Science;Math;DataVisualization;" \
			"MimeType=application/x-stata-dta;text/x-stata-do;text/x-stata-ado"
	else
		rm xstata xstata-mp xstata-se xstata-sm || die "rm failed"
	fi

	if use system-jre; then
		rm -r "utilities/java/linux-x64/jre1.8.0_31" || die "rm jre failed"
		dosym "/etc/java-config-2/current-system-vm/jre" \
			"${dir}/utilities/java/linux-x64/jre1.8.0_31"
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update

	elog "Run (cd /opt/${MY_PN} && ./stinit) as root to install the license."
}

pkg_postrm() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
