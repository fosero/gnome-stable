# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_3,3_4,3_5,3_6} )
VALA_MIN_API_VERSION="0.34"
VALA_USE_DEPEND="vapigen"
DISABLE_AUTOFORMATTING=1
FORCE_PRINT_ELOG=1

inherit gnome2 python-single-r1 vala virtualx readme.gentoo-r1 meson

DESCRIPTION="Builder attempts to be an IDE for writing software for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Builder"

# FIXME: Review licenses at some point
LICENSE="GPL-3+ GPL-2+ LGPL-3+ LGPL-2+ MIT CC-BY-SA-3.0 CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="clang debug +devhelp doc flatpak +gca +gdb +git introspection python spell sysprof vala webkit"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# When bumping, pay attention to all the included plugins/*/configure.ac files and the requirements within.
# Most have no extra requirements and default to enabled; we need to handle the ones with extra requirements, which tend to default to auto(magic).
# Look at the last (fourth) argument given to AC_ARG_ENABLE to decide. We don't support any disabling of those that are default-enabled and have no extra deps beyond C/python/introspection.
# FIXME: >=dev-util/devhelp-3.20.0 dependency is automagic for devhelp integration plugin
# FIXME: flatpak-plugin needs flatpak.pc >=0.6.9, libgit2[threads] >=libgit2-glib-0.24.0[ssh] libsoup-2.4.pc
# FIXME: --with-sanitizer configure option
# FIXME: Enable rdtscp based high performance counter usage on suitable architectures for EGG_COUNTER?
# Python is always enabled - the core python plugin support checks are automagic and not worth crippling it by not supporting python plugins
# Relatedly introspection is always required to not have broken python using plugins or have to enable/disable them based on it. This is a full IDE, not a place to be really minimal.
# An introspection USE flag of a dep is required if any introspection based language plugin wants to use it. Last full check at 3.22.4
RDEPEND="
	>=x11-libs/gtk+-3.22.26:3[introspection]
	>=dev-libs/glib-2.56.0:2[dbus]
	>=x11-libs/gtksourceview-3.24.0:3.0[introspection]
	>=dev-libs/gobject-introspection-1.48.0:=
	>=dev-python/pygobject-3.22.0:3
	>=dev-libs/libxml2-2.9
	>=x11-libs/pango-1.38.0
	>=dev-libs/libpeas-1.22
	>=dev-libs/json-glib-1.2.0
	>=dev-libs/libdazzle-${PV}
	>=dev-libs/template-glib-3.28.0
	>=dev-libs/jsonrpc-glib-3.28.0
	devhelp? ( >=dev-util/devhelp-3.25.1 )
	webkit? ( >=net-libs/webkit-gtk-2.12.0:4=[introspection] )
	clang? ( sys-devel/clang )
	flatpak? (  	>=sys-apps/flatpak-0.8
			dev-util/flatpak-builder
			>=net-libs/libsoup-2.52
			>=dev-libs/libgit2-0.25[ssh,threads]
			>=dev-libs/libgit2-glib-0.25[ssh] )
	git? (
		>=dev-libs/libgit2-0.25[ssh,threads]
		>=dev-libs/libgit2-glib-0.25[ssh] )
	>=x11-libs/vte-0.46:2.91
	gca? ( dev-util/gnome-code-assistance )
	python? (	dev-python/jedi
			dev-python/lxml )
	spell? (	>=app-text/gspell-1.2
			>=app-text/enchant-2:0/2 )
	sysprof? ( >=dev-util/sysprof-3.28.0[gtk] )
	dev-libs/libpcre:3
	${PYTHON_DEPS}
	vala? ( $(vala_depend)
		dev-libs/libdazzle[vala] )
"
# desktop-file-utils for desktop-file-validate check in configure for 3.22.4
# mm-common due to not fully clean --disable-idemm behaviour, recheck on bump
DEPEND="${RDEPEND}
	>=dev-util/meson-0.44
	dev-cpp/mm-common
	dev-libs/appstream-glib
	dev-util/desktop-file-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	!<sys-apps/sandbox-2.10-r3
	introspection? ( dev-libs/gobject-introspection
			 dev-libs/libdazzle[introspection] )
	doc? ( dev-python/sphinx )
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	export PYTHON3_CONFIG="$(python_get_PYTHON_CONFIG)"
	# idemm is C++ wrapper for libide. Once that's needed by something, we might want to
	# consider a split package instead of USE flag. Deps are in libidemm/configure.ac

	local emesonargs=(
		-Denable_rdtscp=true
		-Dwith_devhelp=$(usex devhelp true false)
		-Dwith_docs=$(usex doc true false)
		-Dwith_help=$(usex doc true false)
		-Dwith_flatpak=$(usex flatpak true false)
		-Dwith_gdb=$(usex gdb true false)
		-Dwith_git=$(usex git true false)
		-Dwith_gnome_code_assistance=$(usex gca true false)
		-Dwith_introspection=$(usex introspection true false)
		-Dwith_jedi=$(usex python true false)
		-Dwith_python_gi_imports_completion=$(usex python true false)
		-Dwith_python_pack=$(usex python true false)
		-Dwith_spellcheck=$(usex spell true false)
		-Dwith_sysprof=$(usex sysprof true false)
		-Dwith_vala_pack=$(usex vala true false)
		-Dwith_vapi=$(usex vala true false)
		-Dwith_webkit=$(usex webkit true false)
	)

	meson_src_configure
}

src_install() {
	gnome2_src_install
	meson_src_install
}

pkg_postinst() {
	gnome2_pkg_postinst
}
