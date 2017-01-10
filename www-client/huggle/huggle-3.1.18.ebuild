# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5} )

inherit cmake-utils python-single-r1

MY_PN="huggle3-qt-lx"

DESCRIPTION="An anti-vandalism tool for use on MediaWiki based projects"
HOMEPAGE="https://en.wikipedia.org/wiki/Wikipedia:Huggle"
SRC_URI="https://github.com/huggle/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python qt5"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="python? ( ${PYTHON_DEPS} )
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtwebkit:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwebengine:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}/huggle"

src_configure() {
	local mycmakeargs=(
		-DHUGGLE_EXT=no
		-DPYTHON_BUILD=$(usex python)
		-DQT5_BUILD=$(usex qt5)
		-DWEB_ENGINE=$(usex qt5)
	)
	cmake-utils_src_configure
}
