set icon="netbsd";
set bsd_kernel=(loop)/*/binary/kernel/netbsd-INSTALL.gz;
menuentry $"Boot NetBSD From ISO" --class $icon{
	terminal_output console;
	echo "Loading kernel";
	knetbsd ${bsd_kernel};
	echo "Starting NetBSD";
}
