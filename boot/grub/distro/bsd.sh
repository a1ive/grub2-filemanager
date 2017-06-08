set icon="bsd";
menuentry $"Boot BSD From ISO" --class $icon{
	kfreebsd (loop)/boot/kernel/kernel;
	kfreebsd_module "${file_name}" type=mfs_root
	set kFreeBSD.vfs.root.mountfrom=cd9660:/dev/md0
}