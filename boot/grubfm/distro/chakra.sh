set icon="chakra";
set vmlinuz_img="(loop)/chakra/boot/x86_64/chakraiso";
set initrd_img="(loop)/chakra/boot/x86_64/chakraiso.img";
menuentry $"Chakra" --class $icon {
  export enable_progress_indicator=1;
  set kcmdline="earlymodules=loop nonfree=no xdriver=no";
  linux $vmlinuz_img $kcmdline $linux_extra;
  initrd $initrd_img;
}
menuentry $"Chakra (non-free drivers)" --class $icon {
  export enable_progress_indicator=1;
  set kcmdline="earlymodules=loop nonfree=yes xdriver=no radeon.modeset=0 nouveau.modeset=0 i915.modeset=1 showopts";
  linux $vmlinuz_img $kcmdline $linux_extra;
  initrd $initrd_img;
}
