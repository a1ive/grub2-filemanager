set icon="manjaro";
set vmlinuz_img="(loop)/manjaro/boot/*/vmlinuz*";
set initrd_img="(loop)/manjaro/boot/*/initramfs*";
set imgdevpath="/dev/disk/by-uuid/$devuuid";
set loopiso="img_dev=$imgdevpath img_loop=$isofile misolabel=$devlbl";
menuentry "作为 Manjaro LiveCD 启动" --class $icon{
	set kcmdline="earlymodules=loop misobasedir=manjaro nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 logo.nologo overlay=free splash showopts";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
menuentry "作为 Manjaro LiveCD 启动 (加载闭源驱动)" --class $icon{
	set kcmdline="earlymodules=loop misobasedir=manjaro nouveau.modeset=0 i915.modeset=1 radeon.modeset=0 nonfree=yes logo.nologo overlay=nonfree splash showopts";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}