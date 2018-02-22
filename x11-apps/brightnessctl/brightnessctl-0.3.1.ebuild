# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit udev user

DESCRIPTION="Controls the brightness of backlights and LEDs"
HOMEPAGE="https://github.com/Hummer12007/brightnessctl"
SRC_URI="https://github.com/Hummer12007/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="suid udev"

src_install() {
	dobin brightnessctl
#	doman brightnessctl.1
	use suid && fperms 4711 brightnessctl
	use udev && udev_dorules 90-brightnessctl.rules
}

pkg_postinst() {
	if use udev ; then
		enewgroup video
		enewgroup input

		udev_reload

		elog "Please add your user to the video group to control backlights"
		elog "Please add your user to the input group to control LEDs"
	fi
}
