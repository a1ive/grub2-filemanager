source ${prefix}/func.sh;
set lang=en_US;
terminal_output console;

if [ "$grub_platform" = "efi" ];
then
    map --mem --type=FD "${grubfm_file}";

elif [ "$grub_platform" = "pc" ];
then
    linux16 $prefix/memdisk raw;
    initrd16 "${grubfm_file}";
fi;
    boot;
