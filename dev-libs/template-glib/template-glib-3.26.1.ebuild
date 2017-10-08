# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 meson vala

DESCRIPTION="Template-GLib is a library to generate text based on a template and user defined state."
HOMEPAGE="https://git.gnome.org/browse/template-glib/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc introspection vala"

KEYWORDS="amd64"

# meson 0.42 needed for gentoo vala fixes
COMMON_DEPEND="
	dev-libs/glib:2
	dev-libs/gobject-introspection
	sys-devel/gettext
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/meson-0.42
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
		-Dwith_introspection=$(usex introspection true false)
		-Dwith_vapi=$(usex vala true false)
	)

	meson_src_configure
}
