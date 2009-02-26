# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion cmake-utils

DESCRIPTION="Flake is an open-source FLAC audio encoder"
HOMEPAGE="http://flake-enc.sf.net"
ESVN_REPO_URI="https://flake-enc.svn.sourceforge.net/svnroot/flake-enc"
ESVN_PATCHES="${PN}-*.diff"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug verbose-build"

DEPEND=""
RDEPEND=""

DOCS="Changelog README TODO"

pkg_setup() {
	use verbose-build && CMAKE_COMPILER_VERBOSE=y
}

src_compile() {
	local mycmakeargs="
		-DCMAKE_C_FLAGS_RELEASE=
		-DSHARED=ON
		-DSVN_VERSION=${ESVN_WC_REVISION}
	"
	cmake-utils_src_compile
}
