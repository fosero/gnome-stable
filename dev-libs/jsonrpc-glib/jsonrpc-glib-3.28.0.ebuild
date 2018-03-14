# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 meson vala

DESCRIPTION="Jsonrpc-GLib is a library to communicate with JSON-RPC based peers in either a synchronous or asynchronous fashion"
HOMEPAGE="https://git.gnome.org/browse/jsonrpc-glib/tree/"

LICENSE="LGPL-2.1"
SLOT="0/1"
IUSE="doc introspection vala"

KEYWORDS="amd64"

# meson 0.42 needed for gentoo vala fixes
COMMON_DEPEND="
	dev-libs/glib
	dev-libs/json-glib
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/meson-0.42
	introspection? ( dev-libs/gobject-introspection )
	vala? ( dev-lang/vala )
	doc? ( dev-util/gtk-doc )
"
RDEPEND="${COMMON_DEPEND}"

src_prepare() {

	default
	use vala && vala_src_prepare

}

src_configure() {

	local emesonargs=(
		-Dwith_introspection=$(usex introspection true false)
		-Dwith_vapi=$(usex vala true false)
		-Denable_gtk_doc=$(usex doc true false)
	)

	meson_src_configure
}
