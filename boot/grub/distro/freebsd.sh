set icon="freebsd";
set bsd_kernel=(loop)/boot/kernel/kernel;
menuentry $"Boot FreeBSD From ISO" --class $icon{
	if regexp 'efi' $grub_platform; then
		echo $"Platform: ${grub_platform}";
		echo $"WARNING: HEADLESS MODE ENABLED!";
	fi;
	terminal_output console;
	echo $"Loading kernel";
	kfreebsd ${bsd_kernel} -v;
	echo $"Loading ISO";
	kfreebsd_module "${file_name}" type=mfs_root;
	set kFreeBSD.vfs.root.mountfrom=cd9660:/dev/md0;
	set kFreeBSD.grub.platform=$grub_platform;
	echo $"Starting FreeBSD";
}