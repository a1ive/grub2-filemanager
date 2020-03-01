
default=1;
timeout=5;

if [ "$grub_platform" = "efi" ];
then
terminal_output console;
map --mem $grubfm_file;
   
elif [ "$grub_platform" = "pc" ];
then
export g4d_cmd="map --mem (rd)+1 (0xff);map --hook;chainloader (0xff)";

menuentry $"booting using memdisk" --class mem {
terminal_output console;
enable_progress_indicator=1;
linux16 $prefix/memdisk iso raw;
initrd16 "${grubfm_file}";
}

menuentry $"booting using sanboot (ipxe) " --class net {
   terminal_output console;
   linux16 $prefix/ipxe.lkrn dhcp \&\& sanboot --no-describe --keep http://${net_default_server}$grubfm_path \|\| chain http://${net_default_server}/$net_pxe_boot_file
}

menuentry $"booting using grub4dos (grub2-linux) " --class net {
   terminal_output console;
   enable_progress_indicator=1;
   linux $prefix/grub.exe --config-file=$g4d_cmd;
   initrd ${grubfm_file};
}

menuentry $"booting using grub4dos (ipxe-linux16) " --class net {
   terminal_output console;
   enable_progress_indicator=1;
   linux16 $prefix/ipxe.lkrn dhcp \&\& kernel http://${net_default_server}/app/legacy/grub.exe --config-file=$g4d_cmd \&\& initrd http://${net_default_server}$grubfm_path \&\& boot
}
fi;
   boot
