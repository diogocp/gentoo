# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit unpacker

DESCRIPTION=""
HOMEPAGE="https://www.wolfram.com/mathematica/"
SRC_URI="Mathematica_${PV}_LINUX.sh"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

QA_PREBUILT="/opt/${PN}/SystemFiles/*"

S="${WORKDIR}/Unix"

src_unpack() {
	local src=$(find_unpackable_file "${A}")
	local skip=$(grep -m1 -a offset=.*head.*wc "${src}" | awk '{print $3}')
	skip=$(head -n ${skip} "${src}" | wc -c)

	unpack_makeself "${src}" ${skip} dd
}

src_install() {
	./Installer/MathInstaller \
		-auto \
		-targetdir="${D}/opt/${PN}" \
		-execdir="${D}/usr/bin" \
		-nodesktop || die "MathInstaller failed"
}
