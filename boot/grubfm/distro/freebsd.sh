if test -f (loop)/boot/kernel/kernel*; then
    set bsd_kernel=(loop)/boot/kernel/kernel*;
else
    set bsd_kernel=(loop)/boot/kernel/kfreebsd.gz;
fi;
set bsd_mfsroot=(loop)/boot/mfsroot.gz;
enable_progress_indicator=1;
echo $"Loading kernel";
kfreebsd ${bsd_kernel};
echo $"Loading ISO";
if test -f ${bsd_mfsroot}; then
    kfreebsd_module "${bsd_mfsroot}" type=mfs_root;
else
    kfreebsd_module "${linux_extra}" type=mfs_root;
    set kFreeBSD.vfs.root.mountfrom=cd9660:/dev/md0;
    set kFreeBSD.vfs.root.mountfrom.options=ro;
    set kFreeBSD.grub.platform=$grub_platform;
fi;
echo $"Starting FreeBSD";
