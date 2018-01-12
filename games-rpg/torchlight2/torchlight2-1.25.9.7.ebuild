# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils unpacker

DESCRIPTION="Torchlight II is an action RPG"
HOMEPAGE="https://www.runicgames.com/torchlight2/"
SRC_URI="gog_torchlight_2_2.0.0.2.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs"
RESTRICT="bindist fetch mirror"

DEPEND="app-admin/chrpath
	app-arch/unzip"
RDEPEND="media-libs/fontconfig
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
	!bundled-libs? (
		media-libs/fmod:1
		media-libs/freeimage[png]
		media-libs/freetype
		media-libs/libsdl2[X,opengl,threads]
	)"

QA_PRESTRIPPED="opt/${PN}/lib\(64\)\?/.*"

S="${WORKDIR}/data/noarch/game"

pkg_nofetch() {
	einfo "Please buy and download \"${SRC_URI}\" from"
	einfo "https://www.gog.com/game/torchlight_ii"
	einfo "and copy it to \"${DISTDIR}\""
}

src_unpack() {
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

src_prepare() {
	default

	if ! use bundled-libs; then
		rm lib{,64}/lib{fmodex,freeimage,freetype,SDL2}* || die "rm failed"
	fi

	chrpath -d lib{,64}/* || die "failed to remove rpaths of bundled libs"

	if ! use amd64; then
		rm {Torchlight2,ModLauncher}.bin.x86_64 || die "rm amd64 bins failed"
		rm -r lib64/ || die "rm amd64 libs failed"
	fi
	if ! use x86; then
		rm {Torchlight2,ModLauncher}.bin.x86 || die "rm x86 bins failed"
		rm -r lib/ || die "rm x86 libs failed"
	fi
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	doins -r .

	if use amd64; then
		fperms +x "${dir}/Torchlight2.bin.x86_64" "${dir}/ModLauncher.bin.x86_64"
		make_wrapper "${PN}" "./Torchlight2.bin.x86_64" "${dir}" "${dir}/lib64"
		make_wrapper "${PN}-modlauncher" "./ModLauncher.bin.x86_64" "${dir}" "${dir}/lib64"
	elif use x86; then
		fperms +x "${dir}/Torchlight2.bin.x86" "${dir}/ModLauncher.bin.x86"
		make_wrapper "${PN}" "./Torchlight2.bin.x86" "${dir}" "${dir}/lib"
		make_wrapper "${PN}-modlauncher" "./ModLauncher.bin.x86" "${dir}" "${dir}/lib"
	fi

	newicon "Delvers.png" "${PN}.png"
	make_desktop_entry "${PN}" "Torchlight II" "${PN}" "Game;ActionGame;RolePlaying"
	make_desktop_entry "${PN}-modlauncher" "Torchlight II Mod Launcher" "${PN}" "Game;ActionGame;RolePlaying"
}
