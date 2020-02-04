set multiboot_kernel=/platform/i86pc/kernel/amd64/unix;
set multiboot_module=/platform/i86pc/amd64/boot_archive;
enable_progress_indicator=1;
echo "Loading multiboot kernel";
multiboot (loop)${multiboot_kernel} ${multiboot_kernel} -B smartos=true;
echo "Loading multiboot modules";
module (loop)${multiboot_module} ${multiboot_module} type=rootfs name=ramdisk
echo "Starting SmartOS";
