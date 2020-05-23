set gfxmode=640x400;
set gfxpayload=1024x768;
set theme=(loop)/boot/grub/pvetheme/theme.txt;
terminal_output gfxterm;

set kernel_img="(loop)/boot/linux26";
set initrd_img="(loop)/boot/initrd.img";

menuentry "Install Proxmox VE" --class debian {
  export enable_progress_indicator=1;
  echo "Loading Proxmox VE Installer ...";
  set kcmdline="ro ramdisk_size=16777216 rw quiet splash=silent";
  linux ${kernel_img} ${kcmdline} ${linux_extra};
  echo "Loading initial ramdisk ...";
  mkinitrd -c md_initrd "${initrd_img}";
  echo "Patching initial ramdisk ...";
  mkinitrd -r md_initrd init FUCK;
  mkinitrd -a md_initrd "${prefix}/distro/init/proxmox" init;
  initrd (md_initrd);
}

menuentry "Install Proxmox VE (Debug mode)" --class debian {
  export enable_progress_indicator=1;
  echo "Loading Proxmox VE Installer ...";
  set kcmdline="ro ramdisk_size=16777216 rw quiet splash=verbose proxdebug";
  linux ${kernel_img} ${kcmdline} ${linux_extra};
  echo "Loading initial ramdisk ...";
  mkinitrd -c md_initrd "${initrd_img}";
  echo "Loading Proxmox ISO";
  mkinitrd -r md_initrd init FUCK;
  mkinitrd -a md_initrd "${prefix}/distro/init/proxmox" init;
  initrd (md_initrd);
}
