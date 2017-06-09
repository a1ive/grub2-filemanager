set icon="android";
set vmlinuz_img="(loop)/kernel";
set initrd_img="(loop)/initrd.img";
set kcmdline="androidboot.selinux=permissive";
set linux_extra="iso-scan/filename=${isofile}";
menuentry $"Boot Android-x86 From ISO" --class $icon{
	linux $vmlinuz_img $kcmdline $linux_extra;
	initrd $initrd_img;
}