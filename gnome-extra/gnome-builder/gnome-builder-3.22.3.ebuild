# Copyright 1999-201 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PYTHON_COMPAT=( python{3_3,3_4,3_5} )
VALA_MIN_API_VERSION="0.30"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils gnome2 python-single-r1 vala virtualx

DESCRIPTION="Builder attempts to be an IDE for writing software for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Builder"

LICENSE="GPL-3+ GPL-2+ LGPL-3+ LGPL-2+ MIT CC-BY-SA-3.0 CC0-1.0"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="cpp debug +gca +introspection python +sysprof vala webkit"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# FIXME: some unittests seem to hang forever

# TODO: builder has a ton of plugins with their own deps
# currently mostly not tracked with use+deps
RDEPEND="
	>=dev-libs/glib-2.49:2[dbus]
	>=x11-libs/pango-1.38
	dev-libs/libgit2[ssh,threads]
	>=dev-libs/libpeas-1.18
	>=dev-libs/libxml2-2.9
	dev-util/uncrustify
	sys-devel/clang
	>x11-libs/gtk+-3.21.6:3[introspection?]
	>=x11-libs/gtksourceview-3.21.2:3.0[introspection?]
	>=dev-libs/json-glib-1.2
	cpp? ( >=dev-cpp/glibmm-2.49.1
		>=dev-cpp/gtkmm-3.19.12 )
	introspection? ( >=dev-libs/gobject-introspection-1.48:= )
	gca? ( >=dev-util/gnome-code-assistance-3.16 )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-3.21.1:3
		dev-python/jedi
		dev-python/lxml )
	sysprof? ( >=dev-util/sysprof-3.22.1[gtk] )
	vala? ( $(vala_depend) )
	webkit? ( >=net-libs/webkit-gtk-2.12:4/37 )
"
DEPEND="${RDEPEND}
	dev-cpp/mm-common
	dev-libs/appstream-glib
	>=dev-util/gtk-doc-am-1.11
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {

	use vala && vala_src_prepare
	gnome2_src_prepare

}

src_configure() {
	use python && export PYTHON3_CONFIG="$(python_get_PYTHON_CONFIG)"
	gnome2_src_configure \
		--disable-static \
		$(use_enable cpp idemm hello-cpp-plugin) \
		$(use_enable debug tracing debug) \
		$(use_enable introspection) \
		$(use_enable gca gnome-code-assistance-plugin) \
		$(use_enable sysprof) \
		$(use_enable python python-pack-plugin jedi python-gi-imports-completion-plugin) \
		$(use_enable vala vala-pack-plugin) \
		$(use_enable webkit)

}

src_test() {
	# FIXME: this should be handled at eclass level
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data/gsettings" || die

	GSETTINGS_SCHEMA_DIR="${S}/data/gsettings" Xemake check
}
