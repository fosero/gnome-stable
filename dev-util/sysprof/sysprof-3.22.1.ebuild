# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit gnome2 eutils linux-info vala

DESCRIPTION="System-wide Linux Profiler"
HOMEPAGE="http://sysprof.com/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"
IUSE="dbus introspection gtk vala"

RDEPEND=">=dev-libs/glib-2.44:2
	dbus? ( >=sys-apps/systemd-222
		sys-auth/polkit )
	gtk? ( >=x11-libs/gtk+-3.21.3:3 )
	vala? ( $(vala_depend) )"

DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.32
	introspection? ( >=dev-libs/gobject-introspection-1.42 )
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig"

pkg_pretend() {

	kernel_is -ge 2 6 31 && return
	die "Sysprof will not work with a kernel version less than 2.6.31"

}

src_prepare() {

	use vala && vala_src_prepare
	gnome2_src_prepare

}

src_configure() {

	gnome2_src_configure \
		$(use_enable dbus sysprofd) \
		$(use_enable introspection) \
		$(use_enable gtk) \
		$(use_enable vala)

}

pkg_postinst() {

	gnome2_pkg_postinst

	elog "On many systems, especially amd64, it is typical that with a modern"
	elog "toolchain -fomit-frame-pointer for gcc is the default, because"
	elog "debugging is still possible thanks to gcc4/gdb location list feature."
	elog "However sysprof is not able to construct call trees if frame pointers"
	elog "are not present. Therefore -fno-omit-frame-pointer CFLAGS is suggested"
	elog "for the libraries and applications involved in the profiling. That"
	elog "means a CPU register is used for the frame pointer instead of other"
	elog "purposes, which means a very minimal performance loss when there is"
	elog "register pressure."

}
