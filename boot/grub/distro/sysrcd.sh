set icon="gnu-linux"
set kcmdline="scandelay=1";
set loopiso="isoloop=$isofile";
set initrd_img="(loop)/isolinux/initram.igz"
menuentry "作为 System Rescue CD 启动 (x86_64)" --class $icon{
	linux (loop)/isolinux/rescue64 $kcmdline $loopiso;
	initrd $initrd_img;
}
menuentry "作为 System Rescue CD 启动 (i686)" --class $icon{
	linux (loop)/isolinux/rescue32 $kcmdline $loopiso;
	initrd $initrd_img;
}