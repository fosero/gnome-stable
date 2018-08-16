# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

inherit autotools bash-completion-r1 eutils gnome2 linux-info multilib python-any-r1 vala versionator virtualx

DESCRIPTION="A tagging metadata database, search tool and indexer"
HOMEPAGE="https://wiki.gnome.org/Projects/Tracker"

LICENSE="GPL-2+ LGPL-2.1+"
# New binary version (minor ABI change), but not parallel installable
SLOT="0/2.0"
IUSE="networkmanager stemmer test upower"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

RDEPEND="
	>=dev-db/sqlite-3.20:=
	>=dev-libs/glib-2.44:2
	>=dev-libs/gobject-introspection-0.9.5:=
	>=dev-libs/icu-4.8.1.1:=
	>=dev-libs/json-glib-1.0
	>=net-libs/libsoup-2.40:2.4

	upower? ( || ( >=sys-power/upower-0.9 sys-power/upower-pm-utils ) )
	networkmanager? ( >=net-misc/networkmanager-1:= )
	stemmer? ( dev-libs/snowball-stemmer )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	$(vala_depend)
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.8
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	test? (
		>=dev-libs/dbus-glib-0.82-r1
		>=sys-apps/dbus-1.3.1[X] )
"
PDEPEND="app-misc/tracker-miners:${SLOT}"

function inotify_enabled() {
	if linux_config_exists; then
		if ! linux_chkconfig_present INOTIFY_USER; then
			ewarn "You should enable the INOTIFY support in your kernel."
			ewarn "Check the 'Inotify support for userland' under the 'File systems'"
			ewarn "option. It is marked as CONFIG_INOTIFY_USER in the config"
			die 'missing CONFIG_INOTIFY'
		fi
	else
		einfo "Could not check for INOTIFY support in your kernel."
	fi
}

pkg_setup() {
	linux-info_pkg_setup
	inotify_enabled

	python-any-r1_pkg_setup
}

src_prepare() {
	eautoreconf # See bug #367975
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	local myconf=""

	# unicode-support: libunistring vs libicu
	# I chose icu for simplicity
	gnome2_src_configure \
		--disable-static \
		--enable-introspection \
		--enable-miner-user-guides \
		--enable-tracker-fts \
		--with-unicode-support=libicu \
		--with-bash-completion-dir="$(get_bashcompdir)" \
		$(use_enable upower upower) \
		$(use_enable networkmanager network-manager) \
		$(use_enable stemmer libstemmer) \
		$(use_enable test functional-tests) \
		$(use_enable test unit-tests) \
		${myconf}
}

src_test() {
	# G_MESSAGES_DEBUG, upstream bug #699401#c1
	virtx emake check TESTS_ENVIRONMENT="dbus-run-session" G_MESSAGES_DEBUG="all"
}
