set icon="netbsd";
set bsd_kernel=(loop)/*/binary/kernel/netbsd-INSTALL.gz;
set bsd_module=(loop)/*/installation/miniroot/miniroot.kmod
menuentry $"Boot NetBSD From ISO" --class $icon{
	terminal_output console;
	enable_progress_indicator=1;
	echo "Loading kernel";
	knetbsd ${bsd_kernel};
	echo "Loading modules";
	knetbsd_module_elf ${bsd_module};
	echo "Starting NetBSD";
}
