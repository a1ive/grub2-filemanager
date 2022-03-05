set icon="pmagic";
if test -f (loop)/pmagic/bzImage64;
then
  set vmlinuz_img="(loop)/pmagic/bzImage64";
else
  set vmlinuz_img="(loop)/pmagic/bzImage";
fi;
set initrd_img="(loop)/pmagic/initrd.img (loop)/pmagic/fu.img";
if test -f (loop)/pmagic/m64.img;
then
  set initrd_img="${initrd_img} (loop)/pmagic/m64.img";
else
  set initrd_img="${initrd_img} (loop)/pmagic/m.img";
fi;
set kcmdline="eject=no edd=on vga=normal mem=32G boot=live";
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
