# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="opensans"
FONT_SRCDIR="source"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${MY_PN}.git"
	EGIT_REPO_URI="https://github.com/laerm0/${MY_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="40ce72e"
	SRC_URI="
		mirror://githubcl/googlefonts/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

HOMEPAGE="https://github.com/googlefonts/${MY_PN}"
DESCRIPTION="A clean and modern sans-serif typeface for web, print and mobile"

LICENSE="Apache-2.0"
SLOT="0"
REQUIRED_USE="binary? ( !font_types_otf )"
