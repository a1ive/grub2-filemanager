# Grub2-FileManager
# Copyright (C) 2016,2017  A1ive.
#
# Grub2-FileManager is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Grub2-FileManager is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Grub2-FileManager.  If not, see <http://www.gnu.org/licenses/>.
function SyslinuxBoot {
	if test -f (loop)/isolinux/isolinux.cfg; then
		set cfgpath=(loop)/isolinux/isolinux.cfg;
	elif test -f (loop)/boot/isolinux/isolinux.cfg; then
		set cfgpath=(loop)/boot/isolinux/isolinux.cfg;
	elif test -f (loop)/isolinux.cfg; then
		set cfgpath=(loop)/isolinux.cfg;
	else
		return 1;
	fi;
	menuentry $"Boot ISO (ISOLINUX)" --class gnu-linux{
		root=loop;
		set theme=${prefix}/themes/slack/extern.txt; export theme;
		export linux_extra;
		syslinux_configfile $cfgpath;
	}
}
function CheckLinuxType {
	set icon="iso";
	set distro="Linux";
	set isofile=;
	set devname=;
	set devuuid=;
	regexp --set=isofile '(\/.*$)' "$file_name";
	regexp --set=devname '^(\([0-9a-zA-Z,]+\)).*$' "$file_name";
	probe -u "$devname" --set=devuuid;
	probe -q --set=devlbl --label (loop);
	probe -u (loop) --set=loopuuid;
	if test -f (loop)/casper/vmlinuz*; then
		source $prefix/distro/ubuntu.sh;
	elif test -d (loop)/arch; then
		source $prefix/distro/arch.sh;
	elif test -d (loop)/parabola; then
		source $prefix/distro/parabola.sh;
	elif test -d (loop)/blackarch; then
		source $prefix/distro/blackarch.sh;
	elif test -d (loop)/kdeos; then
		source $prefix/distro/kaos.sh;
	elif test -d (loop)/LiveOS -o -f (loop)/images/pxeboot/vmlinuz*; then
		source $prefix/distro/fedora.sh;
	elif test -f (loop)/live/vmlinuz* -a -f (loop)/live/initrd.*; then
		source $prefix/distro/debian.sh;
	elif test -f (loop)/isolinux/gentoo*; then
		source $prefix/distro/gentoo.sh;
	elif test -f (loop)/isolinux/pentoo; then
		source $prefix/distro/pentoo.sh;
	elif test -f (loop)/boot/sabayon; then
		source $prefix/distro/sabayon.sh;
	elif test -f (loop)/sysrcd.dat; then
		source $prefix/distro/sysrcd.sh;
	elif test -f (loop)/boot/x86_64/loader/linux; then
		source $prefix/distro/suse64.sh;
	elif test -d (loop)/porteus; then
		source $prefix/distro/porteus.sh;
	elif test -d (loop)/slax; then
		source $prefix/distro/slax.sh;
	elif test -d (loop)/wifislax* -o -d (loop)/wifiway; then
		source $prefix/distro/wifislax.sh;
	elif test -f (loop)/dat*.dat; then
		source $prefix/distro/acronis.sh;
	elif test -f (loop)/kernels/huge.s/bzImage; then
		source $prefix/distro/slackware.sh;
	elif test -d (loop)/manjaro; then
		source $prefix/distro/manjaro.sh;
	elif test -f (loop)/pmagic/bzImage -a -f (loop)/pmagic/initrd*; then
		source $prefix/distro/pmagic.sh;
	elif test -f (loop)/antiX/vmlinuz -a -f (loop)/antiX/initrd.gz; then
		source $prefix/distro/antix.sh;
	elif test -f (loop)/boot/core.gz -a -f (loop)/boot/vmlinuz; then
		source $prefix/distro/tinycore.sh;
	elif test -f (loop)/casper/tinycore.gz; then
		source $prefix/distro/minitool.sh;
	elif test -f (loop)/boot/bzImage -a -f (loop)/boot/rootfs4.gz; then
		source $prefix/distro/slitaz.sh;
	elif test -f (loop)/isolinux/vmlinuz -a -f (loop)/isolinux/initrd.gz -a -f (loop)/livecd.sqfs; then
		source $prefix/distro/pclinuxos.sh;
	elif test -f (loop)/boot/bzImage -a -f (loop)/boot/initrd.gz; then
		source $prefix/distro/4m.sh;
	elif test -f (loop)/boot/isolinux/linux -a -f (loop)/boot/isolinux/minirt.gz; then
		source $prefix/distro/knoppix.sh;
	elif test -f (loop)/kernel -a -f (loop)/initrd.img -a -f (loop)/system.sfs; then
		source $prefix/distro/android.sh;
	elif test -f (loop)/boot/kernel/kernel -o -f (loop)/boot/kernel/kernel.*; then
		source $prefix/distro/freebsd.sh;
	elif test -f (loop)/*/*/bsd.rd; then
		source $prefix/distro/openbsd.sh;
	elif test -d (loop)/CDlinux; then
		source $prefix/distro/cdlinux.sh;
	fi;
	if test -f (loop)/boot/grub/loopback.cfg; then
		menuentry $"Boot ISO (Loopback)" "$isofile" --class gnu-linux{
			set iso_path="$2"; export iso_path;
			root=loop;
			set theme=${prefix}/themes/slack/extern.txt; export theme;
			configfile /boot/grub/loopback.cfg
		}
	fi;
	SyslinuxBoot;
}