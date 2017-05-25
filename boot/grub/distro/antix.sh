set icon="debian";
set vmlinuz_img="(loop)/antiX/vmlinuz";
set initrd_img="(loop)/antiX/initrd.gz";
set loopiso="fromiso=$isofile from=hd,usb";
menuentry $"Boot antiX From ISO" --class $icon{
	set kcmdline="splash=v disable=lx";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
menuentry $"Boot antiX From ISO (Fail Safe)" --class $icon{
	set kcmdline="splash=v disable=lx nomodeset failsafe";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
