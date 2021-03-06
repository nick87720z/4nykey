# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
MY_FONT_TYPES=( otf +ttf )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/typiconman/${PN}.git"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
	MY_PV="5f897fd"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
	binary? (
		http://www.ponomar.net/files/fonts-churchslavonic.zip
	)
	!binary? (
		mirror://githubcl/typiconman/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	)
	"
	KEYWORDS="~amd64 ~x86"
fi
MY_MK="f9edc47e189d8495b647a4feac8ca240-1827636"
SRC_URI+="
!binary? (
	mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
	-> ${MY_MK}.tar.gz
)
"
RESTRICT="primaryuri"
inherit python-any-r1 font-r1

DESCRIPTION="Unicode OpenType fonts for Church Slavonic"
HOMEPAGE="http://sci.ponomar.net/fonts.html"

LICENSE="|| ( GPL-3 OFL-1.1 )"
SLOT="0"
IUSE="+binary"

DEPEND="
	binary? ( app-arch/unzip )
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[${PYTHON_USEDEP}]
		')
		font_types_ttf? ( dev-util/grcompiler )
	)
"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}"
		DOCS="fonts-churchslavonic.pdf"
	else
		python-any-r1_pkg_setup
		PATCHES=( "${FILESDIR}"/${PN}_generate.diff )
	fi

	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary || unpack ${MY_MK}.tar.gz
}

src_compile() {
	use binary && return
	local _s _t

	# for consistency
	sed -e '/Layer:/s:\<TTF\>:&Layer:' -i "${S}"/*/*.sfd

	for _s in */*.sfd; do
		if [[ -n ${_s##Svobodny*} ]]; then
			fontforge -script Ponomar/hp-generate.py ${_s} || die
		fi
	done

	for _s in Svobodny/Svobodny*.sfd; do
		for _t in ${FONT_SUFFIX}; do
			fontforge -script ${MY_MK}/ffgen.py "${_s}" ${_t} || die
		done
	done

	use font_types_ttf || return
	for _s in */*.gdl; do
		grcompiler "${_s}" "$(dirname ${_s})Unicode.ttf" "${_s%.*}.ttf" || die
		mv -f "${_s%.*}.ttf" "$(dirname ${_s})Unicode.ttf"
	done
}
