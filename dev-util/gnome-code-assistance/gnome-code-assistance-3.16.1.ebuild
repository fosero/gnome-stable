# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/eog/eog-3.14.3.ebuild,v 1.1 2014/12/23 21:59:07 eva Exp $

EAPI="6"

inherit gnome2

DESCRIPTION=""
HOMEPAGE="https://wiki.gnome.org/Projects/CodeAssistance"

LICENSE="LGPL-3"
SLOT="0"
IUSE="python xml"
KEYWORDS="amd64"

RDEPEND="python? (
		dev-lang/python
		dev-python/dbus-python
		dev-python/pylint
		|| ( dev-python/pep8 dev-python/flake8 ) )
"
DEPEND="${RDEPEND}"

src_configure() {

	gnome2_src_configure \
		$(use_enable python) \
		$(use_enable xml)

}
