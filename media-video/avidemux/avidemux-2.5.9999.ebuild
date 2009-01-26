# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/avidemux/avidemux-2.0.38_rc2-r1.ebuild,v 1.1 2005/04/18 15:44:32 flameeyes Exp $

EAPI="1"

inherit git flag-o-matic qt4 cmake-utils

DESCRIPTION="Great Video editing/encoding tool"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
EGIT_REPO_URI="git://git.berlios.de/avidemux"
EGIT_PATCHES="${P}-*.diff"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~x86 ~amd64"
IUSE="
	a52 aac alsa arts esd mmx nls vorbis sdl truetype xvid xv oss x264
	dts qt4 fontconfig lame aften gtk jack debug libsamplerate amrnb
	verbose-build
"

RDEPEND="
	virtual/libiconv
	dev-libs/libxml2
	media-libs/libpng
	>=dev-lang/spidermonkey-1.5-r2
	gtk? ( >=x11-libs/gtk+-2.6.0 )
	qt4? ( x11-libs/qt:4 )
	x264? ( media-libs/x264 )
	xvid? ( media-libs/xvid )
	aften? ( media-libs/aften )
	amrnb? ( media-libs/amrnb )
	lame? ( media-sound/lame )
	dts? ( media-libs/libdca )
	aac? ( media-libs/faad2 media-libs/faac )
	vorbis? ( media-libs/libvorbis )
	alsa? ( >=media-libs/alsa-lib-1.0.3b-r2 )
	arts? ( >=kde-base/arts-1.2.3 )
	esd? ( media-sound/esound )
	jack? (
		media-sound/jack-audio-connection-kit
		libsamplerate? ( media-libs/libsamplerate )
	)
	truetype? ( >=media-libs/freetype-2.1.5 )
	fontconfig? ( media-libs/fontconfig )
	sdl? ( media-libs/libsdl )
	xv? ( x11-libs/libXv )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
"
DEPEND="
	$RDEPEND
	oss? ( virtual/os-headers )
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )
"

pick() {
	local CMAKE_VAR="$(echo ${2:-${1}} | tr [:lower:] [:upper:])"
	mycmakeargs+=" -D${CMAKE_VAR}=$(use $1 && echo ON || echo OFF)"
}

pkg_setup() {
	filter-flags \
		-fno-default-inline -funroll-loops -funroll-all-loops -fforce-addr
	use verbose-build && CMAKE_COMPILER_VERBOSE=y
}

src_compile() {
	mkdir -p "${S}/avidemux/ADM_outputs"
	local mycmakeargs

	for x in \
		gtk qt4 x264 xvid aften amrnb lame vorbis alsa arts esd jack oss \
		fontconfig sdl
	do
		pick $x
	done
	pick dts libdca
	pick aac faac
	pick aac faad
	pick truetype freetype2
	pick nls gettext
	pick xv xvideo

	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS
}
