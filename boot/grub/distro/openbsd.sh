set icon="openbsd";
set bsd_kernel=(loop)/*/*/bsd.rd;
menuentry $"Boot OpenBSD From ISO" --class $icon{
	terminal_output console;
	echo "Loading kernel";
	kopenbsd ${bsd_kernel};
	echo "Starting OpenBSD";
}
