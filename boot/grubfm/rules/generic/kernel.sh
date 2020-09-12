if file --is-x86-linux "${grubfm_file}";
then
  menuentry $"Boot Linux Kernel" --class exe {
    if [ "$grub_platform" = "efi" ];
    then
      linuxefi "${grubfm_file}";
    else
      linux "${grubfm_file}";
    fi;
  }
fi;

if file --is-x86-multiboot "${grubfm_file}";
then
  menuentry $"Boot Multiboot Kernel" --class exe {
    set root="${grubfm_device}";
    multiboot "${grubfm_file}";
  }
fi;

if file --is-x86-multiboot2 "${grubfm_file}";
then
  menuentry $"Boot Multiboot2 Kernel" --class exe {
    multiboot2 "${grubfm_file}";
  }
fi;

if file --is-x86-bios-bootsector "${grubfm_file}";
then
  menuentry $"Chainload BIOS Boot Sector" --class bin {
    chainloader --force "${grubfm_file}";
  }
fi;
