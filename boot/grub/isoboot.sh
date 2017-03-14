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

function funcISOBoot {
	menuentry "作为 $distro LiveCD 启动" --class $icon{
		set gfxpayload=keep;
		linux $vmlinuz_img $kcmdline $loopiso;
		initrd $initrd_img;
	}
}

function CheckLinuxType {
	set icon="iso";
	set distro="Linux";
	set isofile=;
	set devname=;
	set devuuid=;
	regexp --set=isofile '(\/.*$)' $file_name;
	regexp --set=devname '(^\([hc][d].*\))' $file_name;
	probe -u $devname --set=devuuid;
	probe -q --set=devlbl --label (loop);
	probe -u (loop) --set=loopuuid;
	if test -f (loop)/casper/vmlinuz*; then
		set icon="ubuntu";
		set distro="Ubuntu";
		set vmlinuz_img="(loop)/casper/vmlinuz*";
		set initrd_img="(loop)/casper/initrd*";
		set kcmdline="boot=casper noprompt noeject";
		set loopiso="iso-scan/filename=${isofile}";
		if test -f (loop)/casper/tinycore.gz; then
			set distro="MiniTool";
			set initrd_img="(loop)/casper/tinycore.gz";
			set kcmdline="ramdisk_size=409600 root=/dev/ram0 rw";
			set loopiso=" ";
		fi
		funcISOBoot;
	elif test -f (loop)/arch/boot/x86_64/vmlinuz*; then
		set icon="archlinux";
		set distro="Arch Linux";
		set vmlinuz_img="(loop)/arch/boot/x86_64/vmlinuz*";
		set initrd_img="(loop)/arch/boot/x86_64/archiso.img";
		set imgdevpath="/dev/disk/by-uuid/$devuuid";
		set kcmdline="archisodevice=/dev/loop0";
		set loopiso="img_dev=$imgdevpath img_loop=$isofile";
		funcISOBoot;
	elif test -d (loop)/LiveOS -o -f (loop)/images/pxeboot/vmlinuz*; then
		#Fedora live
		set icon="fedora";
		set distro="Fedora";
		set vmlinuz_img="(loop)/isolinux/vmlinuz*";
		set initrd_img="(loop)/isolinux/initrd*";
		set kcmdline="rd.live.image quiet";
		set loopiso="root=live:CDLABEL=$devlbl iso-scan/filename=$isofile";
		funcISOBoot;
		if test -f (loop)/images/pxeboot/vmlinuz*; then
			menuentry "作为 $distro 安装光盘 启动" --class $icon{
				set gfxpayload=keep;
				linux (loop)/images/pxeboot/vmlinuz* boot=images quiet iso-scan/filename=$isofile inst.stage2=hd:UUID=$loopuuid;
				initrd (loop)/images/pxeboot/initrd*;
			}
		fi
	elif test -f (loop)/live/vmlinuz*; then
		set icon="debian";
		set distro="Debian";
		set vmlinuz_img="(loop)/live/vmlinuz*";
		set initrd_img="(loop)/live/initrd*";
		set kcmdline="boot=live config";
		set loopiso="findiso=${isofile}";
		funcISOBoot;
	elif test -f (loop)/boot/x86_64/loader/linux; then
		set icon="opensuse"
		set distro="OpenSUSE"
		set vmlinuz_img="(loop)/boot/x86_64/loader/linux";
		set initrd_img="(loop)/boot/x86_64/loader/initrd";
		set imgdevpath="/dev/disk/by-uuid/$devuuid";
		set kcmdline=" ";
		set loopiso="isofrom_system=$isofile isofrom_device=$imgdevpath";
		funcISOBoot;
	elif test -d (loop)/porteus; then
		set icon="porteus";
		set distro="Porteus";
		set kcmdline="norootcopy";
		set loopiso="from=${isofile}";
		set vmlinuz_img="(loop)/boot/syslinux/vmlinuz";
		set initrd_img="(loop)/boot/syslinux/initrd*";
		if test -f (loop)/porteus/vmlinuz; then
			set vmlinuz_img="(loop)/porteus/vmlinuz*";
			set initrd_img="(loop)/porteus/initrd*";
		fi
		funcISOBoot;
	elif test -d (loop)/slax; then
		set icon="slax";
		set distro="Slax";
		set kcmdline="load_ramdisk=1 prompt_ramdisk=0 rw printk.time=0 slax.flags=xmode";
		set loopiso="from=${isofile}";
		set vmlinuz_img="(loop)/boot/vmlinuz";
		set initrd_img="(loop)/boot/initrd*";
		funcISOBoot;
	elif test -d (loop)/wifislax; then
		set icon="wifislax";
		set distro="Wifislax";
		set kcmdline="noload=006-Xfce load=English";
		set loopiso="from=${isofile}";
		set vmlinuz_img="(loop)/boot/vmlinuz*";
		set initrd_img="(loop)/boot/initrd*";
		if test -f (loop)/wifislax/vmlinuz; then
			set vmlinuz_img="(loop)/wifislax/vmlinuz*";
			set initrd_img="(loop)/wifislax/initrd*";
		fi
		funcISOBoot;
	elif test -f (loop,msdos1)/dat10.dat -a -f (loop,msdos1)/dat11.dat; then
		set icon="acronis"
		set distro="Acronis"
		set vmlinuz_img="(loop,msdos1)/dat10.dat";
		set initrd_img="(loop,msdos1)/dat11.dat (loop,msdos1)/dat12.dat";
		set kcmdline="lang=zh_CN force_modules=usbhid quiet vga=791";
		set loopiso=" ";
		funcISOBoot;
	elif test -f (loop)/kernels/huge.s/bzImage; then
		set icon="slackware"
		set distro="Slackware"
		set vmlinuz_img="(loop)/kernels/huge.s/bzImage";
		set initrd_img="(loop)/isolinux/initrd.img";
		set kcmdline="vga=normal load_ramdisk=1 prompt_ramdisk=0 ro printk.time=0 nomodeset SLACK_KERNEL=huge.s";
		set loopiso=" ";
		funcISOBoot;
	elif test -f (loop)/manjaro/boot/x86_64/manjaro; then
		#64Bit Only
		set icon="archlinux";
		set distro="Manjaro";
		set vmlinuz_img="(loop)/manjaro/boot/x86_64/manjaro";
		set initrd_img="(loop)/manjaro/boot/x86_64/manjaro.img";
		set imgdevpath="/dev/disk/by-uuid/$devuuid";
		set kcmdline="misobasedir=manjaro nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 logo.nologo overlay=free showopts";
		set loopiso="img_dev=$imgdevpath img_loop=$isofile misolabel=$devlbl";
		funcISOBoot;
	elif test -f (loop)/pmagic/bzImage -a -f (loop)/initramfs; then
		set icon="slackware";
		set distro="Parted Magic";
		set vmlinuz_img="(loop)/pmagic/bzImage";
		set initrd_img="(loop)/pmagic/initrd.img (loop)/pmagic/fu.img (loop)/pmagic/m32.img";
		set kcmdline="eject=no load_ramdisk=1";
		set loopiso="iso_filename=$isofile";
		funcISOBoot;
	elif test -f (loop)/boot/initramfs_*.img -a -f (loop)/boot/vmlinuz_*; then
		set icon="archlinux"
		set distro="Arch Linux"
		set vmlinuz_img="(loop)/boot/vmlinuz_*";
		set initrd_img="(loop)/boot/initramfs_*.img";
		set imgdevpath="/dev/disk/by-uuid/$devuuid";
		set kcmdline=" ";
		set loopiso="iso_loop_dev=$imgdevpath iso_loop_path=$isofile";
		funcISOBoot;
	elif test -f (loop)/antiX/vmlinuz -a -f (loop)/antiX/initrd.*; then
		set icon="debian";
		set distro="antiX";
		set vmlinuz_img="(loop)/antiX/vmlinuz";
		set initrd_img="(loop)/antiX/initrd.*";
		set kcmdline="from=hd splash=v disable=lx";
		set loopiso="from=$isofile root=UUID=$devuuid";
		funcISOBoot;
	elif test -f (loop)/boot/grub/loopback.cfg; then
		menuentry "作为 Linux LiveCD 启动" $isofile --class gnu-linux{
			set iso_path="$2"; export iso_path;
			root=(loop);
			configfile /boot/grub/loopback.cfg
		}
	fi
}