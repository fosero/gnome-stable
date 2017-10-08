# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 meson vala

DESCRIPTION="The libdazzle library is a companion library to GObject and Gtk+"
HOMEPAGE="https://git.gnome.org/browse/libdazzle/"

LICENSE="GPL-3"
SLOT="0"
IUSE="introspection doc vala"

KEYWORDS="amd64"


RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:3
	sys-devel/gettext
"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	vala? ( dev-lang/vala )
"


src_prepare() {

	default
	use vala && vala_src_prepare

}

src_configure() {

	local emesonargs=(
		-Denable_gtk_doc=$(usex doc true false)
		-Denable_tests=false
		-Denable_tools=false
		-Dwith_introspection=$(usex introspection true false)
		-Dwith_vapi=$(usex vala true false)
	)

	meson_src_configure
}
