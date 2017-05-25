set icon="manjaro";
set imgdevpath="/dev/disk/by-uuid/$devuuid";
set loopiso="img_dev=$imgdevpath img_loop=$isofile misolabel=$devlbl";
function manjaro_menu {
	menuentry $"Boot Manjaro From ISO" --class $icon{
		set kcmdline="earlymodules=loop misobasedir=manjaro nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 logo.nologo overlay=free splash showopts";
		linux $vmlinuz_img $kcmdline $loopiso;
		initrd $initrd_img;
	}
	menuentry $"Boot Manjaro From ISO (non-free drivers)" --class $icon{
		set kcmdline="earlymodules=loop misobasedir=manjaro nouveau.modeset=0 i915.modeset=1 radeon.modeset=0 nonfree=yes logo.nologo overlay=nonfree splash showopts";
		linux $vmlinuz_img $kcmdline $loopiso;
		initrd $initrd_img;
	}
}
if test -f (loop)/manjaro/boot/*/vmlinuz* -a -f (loop)/manjaro/boot/*/initramfs*; then
	set vmlinuz_img="(loop)/manjaro/boot/*/vmlinuz*";
	set initrd_img="(loop)/manjaro/boot/*/initramfs*";
	manjaro_menu;
elif test -f (loop)/boot/vmlinuz* -a -f (loop)/boot/initramfs*; then
	set vmlinuz_img="(loop)/boot/vmlinuz*";
	set initrd_img="(loop)/boot/initramfs*";
	manjaro_menu;
fi;
	

