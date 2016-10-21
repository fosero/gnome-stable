# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2

DESCRIPTION="An IRC client for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Polari"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

COMMON_DEPEND="
	dev-libs/gjs
	>=dev-libs/glib-2.43.4:2
	>=dev-libs/gobject-introspection-0.9.6
	net-libs/telepathy-glib[introspection]
	>=x11-libs/gtk+-3.21.5:3[introspection]
"
RDEPEND="${COMMON_DEPEND}
	>=net-irc/telepathy-idle-0.2
	net-im/telepathy-logger[introspection]
	net-libs/libsoup:2.4
	x11-libs/gdk-pixbuf
	x11-libs/pango
	app-crypt/libsecret
	net-im/telepathy-logger
	net-libs/telepathy-glib
"
DEPEND="${COMMON_DEPEND}
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.6
	app-text/yelp-tools
	virtual/pkgconfig
"
