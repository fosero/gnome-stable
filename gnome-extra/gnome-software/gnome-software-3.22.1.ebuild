# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-any-r1 virtualx

DESCRIPTION="Gnome install & update software"
HOMEPAGE="http://wiki.gnome.org/Apps/Software"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+flatpak gnome-desktop spell test gudev webapp"

#	>=app-admin/packagekit-base-1.1

RDEPEND="
	dev-db/sqlite:3
	>=dev-libs/appstream-glib-0.6.1:0
	>=dev-libs/glib-2.45.8:2
	>=dev-libs/json-glib-1.1.1
	spell? ( app-text/gtkspell:3 )
	gnome-desktop? ( >=gnome-base/gnome-desktop-3.17.92:3= )
	>=gnome-base/gsettings-desktop-schemas-3.11.5
	>=net-libs/libsoup-2.51.92:2.4
	sys-auth/polkit
	app-crypt/libsecret
	>=x11-libs/gtk+-3.18.2:3
	>=x11-libs/gdk-pixbuf-2.31.5:2
	flatpak? ( >=sys-apps/flatpak-0.4.14 )
	gudev? ( virtual/libgudev )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	test? ( dev-util/dogtail )
"
# test? ( dev-util/valgrind )

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	# valgrind fails with SIGTRAP
	sed -e 's/TESTS = .*/TESTS =/' \
		-i "${S}"/src/Makefile.{am,in} || die

	gnome2_src_prepare
}

src_configure() {
	# FIXME: investigate limba and firmware update support
	gnome2_src_configure \
		--enable-man \
		--disable-firmware \
		--disable-limba \
		$(use_enable flatpak) \
		$(use_enable gnome-desktop) \
		$(use_enable spell gtkspell) \
		$(use_enable test dogtail) \
		$(use_enable gudev) \
		$(use_enable webapp webapps)
}

src_test() {
	Xemake check TESTS_ENVIRONMENT="dbus-run-session"
}
