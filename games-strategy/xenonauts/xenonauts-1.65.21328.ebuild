# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils unpacker

DESCRIPTION="Xenonauts"
HOMEPAGE="https://www.gog.com/game/xenonauts"
SRC_URI="xenonauts_en_$(ver_rs 1- _).sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch"

DEPEND="app-arch/unzip"
RDEPEND="dev-libs/expat[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	media-libs/libsdl2[abi_x86_32(-)]
	sys-libs/zlib[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXau[abi_x86_32(-)]
	x11-libs/libXdamage[abi_x86_32(-)]
	x11-libs/libXdmcp[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libXfixes[abi_x86_32(-)]
	x11-libs/libXinerama[abi_x86_32(-)]
	x11-libs/libXxf86vm[abi_x86_32(-)]
	x11-libs/libdrm[abi_x86_32(-)]
	x11-libs/libxcb[abi_x86_32(-)]
	x11-libs/libxshmfence[abi_x86_32(-)]"

QA_PREBUILT="/opt/${PN}/Xenonauts.bin.x86"

S="${WORKDIR}/data/noarch"

pkg_nofetch() {
	einfo "Please buy and download \"${SRC_URI}\" from"
	einfo "${HOMEPAGE}"
	einfo "and place it in your DISTDIR directory"
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	local ABI="x86"
	local dir="/opt/${PN}"

	dodoc "docs/GameManual.pdf" "docs/QuickstartGuide.pdf"

	insinto "${dir}"
	doins -r "game/."
	fperms +x "${dir}/Xenonauts.bin.x86"

	newicon "support/icon.png" "${PN}.png"
	make_wrapper ${PN} "./Xenonauts.bin.x86" "${dir}" "${dir}/lib"
	make_desktop_entry "${PN}" "Xenonauts" "${PN}"
}
