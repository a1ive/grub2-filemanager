set icon="netbsd";
set bsd_kernel=(loop)/*/binary/kernel/netbsd-INSTALL.gz;
menuentry $"Boot NetBSD From ISO" --class $icon{
	terminal_output console;
	enable_progress_indicator=1;
	echo "Loading kernel";
	knetbsd ${bsd_kernel};
	echo "Starting NetBSD";
}
