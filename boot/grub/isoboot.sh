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

function CheckLinuxType {
	set icon="iso";
	set distro="Linux";
	set isofile=;
	set devname=;
	set devuuid=;
	regexp --set=isofile '(\/.*$)' "$file_name";
	regexp --set=devname '(^\([hc][d].*\))' "$file_name";
	probe -u "$devname" --set=devuuid;
	probe -q --set=devlbl --label (loop);
	probe -u (loop) --set=loopuuid;
	if test -f (loop)/boot/grub/loopback.cfg; then
		menuentry "作为 Loopback ISO 启动 (推荐)" "$isofile" --class gnu-linux{
			set iso_path="$2"; export iso_path;
			root=(loop);
			configfile /boot/grub/loopback.cfg
		}
	fi
	if test -f (loop)/casper/tinycore.gz; then
		source $prefix/distro/minitool.sh;
	elif test -f (loop)/casper/vmlinuz*; then
		source $prefix/distro/ubuntu.sh;
	elif test -f (loop)/arch/boot/x86_64/vmlinuz*; then
		source $prefix/distro/arch.sh;
	elif test -d (loop)/LiveOS -o -f (loop)/images/pxeboot/vmlinuz*; then
		source $prefix/distro/fedora.sh;
	elif test -f (loop)/live/vmlinuz*; then
		source $prefix/distro/debian.sh;
	elif test -f (loop)/isolinux/gentoo64; then
		source $prefix/distro/gentoo.sh;
	elif test -f (loop)/sysrcd.dat; then
		source $prefix/distro/sysrcd.sh;
	elif test -f (loop)/boot/x86_64/loader/linux; then
		source $prefix/distro/suse64.sh;
	elif test -d (loop)/porteus; then
		source $prefix/distro/porteus.sh;
	elif test -d (loop)/slax; then
		source $prefix/distro/slax.sh;
	elif test -d (loop)/wifislax*; then
		source $prefix/distro/wifislax.sh;
	elif test -f (loop,msdos1)/dat10.dat -a -f (loop,msdos1)/dat11.dat; then
		source $prefix/distro/acronis.sh;
	elif test -f (loop)/kernels/huge.s/bzImage; then
		source $prefix/distro/slackware.sh;
	elif test -f (loop)/manjaro/boot/*/vmlinuz*; then
		source $prefix/distro/manjaro.sh;
	elif test -f (loop)/pmagic/bzImage -a -f (loop)/initramfs; then
		source $prefix/distro/pmagic.sh;
	elif test -f (loop)/boot/initramfs_*.img -a -f (loop)/boot/vmlinuz_*; then
		source $prefix/distro/archboot.sh;
	elif test -f (loop)/antiX/vmlinuz -a -f (loop)/antiX/initrd.*; then
		source $prefix/distro/antix.sh;
	fi
}