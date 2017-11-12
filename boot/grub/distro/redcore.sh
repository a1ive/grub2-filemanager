set icon="gentoo";
set vmlinuz_img="(loop)/boot/vmlinuz";
set initrd_img="(loop)/boot/initrd";
set linux_extra="iso-scan/filename=$isofile root=live:CDLABEL=$devlbl";
menuentry $"Boot Redcore Linux From ISO" --class $icon{
	set kcmdline="rd.live.image rootfstype=auto vconsole.keymap=us rd.locale.LANG=en_US.utf8 loglevel=1 console=tty0 rd.luks=0 rd.lvm=0 rd.md=0 rd.dm=0";
	linux $vmlinuz_img $kcmdline $linux_extra;
	initrd $initrd_img;
}
