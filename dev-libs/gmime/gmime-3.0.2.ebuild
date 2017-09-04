# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit mono-env gnome2 vala

DESCRIPTION="Utilities for creating and parsing messages using MIME"
HOMEPAGE="http://spruce.sourceforge.net/gmime/ https://developer.gnome.org/gmime/stable/"

SLOT="3"
LICENSE="LGPL-2.1"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="crypto doc idn static-libs test vala"

RDEPEND="
	>=dev-libs/glib-2.32.0:2
	sys-libs/zlib
	crypto? ( >=app-crypt/gpgme-1.2:1= )
	idn? ( net-dns/libidn )
	vala? (
		$(vala_depend)
		>=dev-libs/gobject-introspection-1.30.0:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.8
	virtual/libiconv
	virtual/pkgconfig
	doc? ( app-text/docbook-sgml-utils )
	test? ( app-crypt/gnupg )
"
# FIXME: is this test optional still needed

src_prepare() {
	gnome2_src_prepare
	use vala && vala_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable crypto) \
		$(use_enable static-libs static) \
		$(use_enable vala) \
		$(use_with idn libidn)
}

src_compile() {
	gnome2_src_compile

	if use doc; then
		emake -C docs/tutorial html
	fi
}

src_install() {
	gnome2_src_install

	if use doc ; then
		docinto tutorial
		dodoc -r docs/tutorial/html/
	fi
}
