unset theme;
background_image (loop)/splash.png

set kernel_img="(loop)/vmlinuz";
set initrd_img="(loop)/initrd.gz";

menuentry "Start veket 20.0" {
  export enable_progress_indicator=1;
  echo "Loading Veket kernel ...";
  set kcmdline="pfix=fsck pmedia=usbhd";
  linux ${kernel_img} ${kcmdline} ${linux_extra};
  echo "Loading initial ramdisk ...";
  mkinitrd -c md_initrd "${initrd_img}";
  echo "Patching initial ramdisk ...";
  mkinitrd -r md_initrd init FUCK;
  mkinitrd -a md_initrd "${prefix}/distro/init/veket" init;
  initrd (md_initrd);
}

menuentry "Start veket 20.0 - Don't copy SFS files to RAM" {
  export enable_progress_indicator=1;
  echo "Loading Veket kernel ...";
  set kcmdline="pfix=nocopy,fsck pmedia=usbhd";
  linux ${kernel_img} ${kcmdline} ${linux_extra};
  echo "Loading initial ramdisk ...";
  mkinitrd -c md_initrd "${initrd_img}";
  echo "Patching initial ramdisk ...";
  mkinitrd -r md_initrd init FUCK;
  mkinitrd -a md_initrd "${prefix}/distro/init/veket" init;
  initrd (md_initrd);
}

menuentry "Start veket 20.0 - RAM only" {
  export enable_progress_indicator=1;
  echo "Loading Veket kernel ...";
  set kcmdline="pfix=ram,fsck pmedia=usbhd";
  linux ${kernel_img} ${kcmdline} ${linux_extra};
  echo "Loading initial ramdisk ...";
  mkinitrd -c md_initrd "${initrd_img}";
  echo "Patching initial ramdisk ...";
  mkinitrd -r md_initrd init FUCK;
  mkinitrd -a md_initrd "${prefix}/distro/init/veket" init;
  initrd (md_initrd);
}

menuentry "Start veket 20.0 - No X" {
  export enable_progress_indicator=1;
  echo "Loading Veket kernel ...";
  set kcmdline="pfix=nox,fsck pmedia=usbhd";
  linux ${kernel_img} ${kcmdline} ${linux_extra};
  echo "Loading initial ramdisk ...";
  mkinitrd -c md_initrd "${initrd_img}";
  echo "Patching initial ramdisk ...";
  mkinitrd -r md_initrd init FUCK;
  mkinitrd -a md_initrd "${prefix}/distro/init/veket" init;
  initrd (md_initrd);
}

menuentry "Start veket 20.0 - No KMS (Kernel mode setting)" {
  export enable_progress_indicator=1;
  echo "Loading Veket kernel ...";
  set kcmdline="nomodeset pfix=fsck pmedia=usbhd";
  linux ${kernel_img} ${kcmdline} ${linux_extra};
  echo "Loading initial ramdisk ...";
  mkinitrd -c md_initrd "${initrd_img}";
  echo "Patching initial ramdisk ...";
  mkinitrd -r md_initrd init FUCK;
  mkinitrd -a md_initrd "${prefix}/distro/init/veket" init;
  initrd (md_initrd);
}

menuentry "Start veket 20.0 - Ram Disk SHell" {
  export enable_progress_indicator=1;
  echo "Loading Veket kernel ...";
  set kcmdline="pfix=rdsh pmedia=usbhd";
  linux ${kernel_img} ${kcmdline} ${linux_extra};
  echo "Loading initial ramdisk ...";
  mkinitrd -c md_initrd "${initrd_img}";
  echo "Patching initial ramdisk ...";
  mkinitrd -r md_initrd init FUCK;
  mkinitrd -a md_initrd "${prefix}/distro/init/veket" init;
  initrd (md_initrd);
}
