set icon="acronis";
set vmlinuz_img="(loop,msdos1)/dat10.dat";
set initrd_img="(loop,msdos1)/dat11.dat (loop,msdos1)/dat12.dat";
set kcmdline="lang=zh_CN force_modules=usbhid quiet vga=791";
set loopiso=" ";
menuentry "作为 Acronis True Image ISO 启动" --class $icon{
	set gfxpayload=keep;
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}