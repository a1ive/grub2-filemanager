set icon="gnu-linux";
set vmlinuz_img="(loop)/isolinux/vmlinuz";
set initrd_img="(loop)/isolinux/initrd.gz";
set loopiso="root=UUID=$devuuid bootfromiso=$isofile";
menuentry "作为 PCLinuxOS LiveCD 启动" --class $icon{
	set kcmdline="keyb=us splash=verbose livecd=livecd";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
