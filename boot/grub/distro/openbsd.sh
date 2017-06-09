set icon="openbsd";
set bsd_kernel=(loop)/*/*/bsd.rd;
menuentry $"Boot OpenBSD From ISO" --class $icon{
	if regexp 'efi' $grub_platform; then
		echo $"Platform: ${grub_platform}";
		echo $"WARNING: HEADLESS MODE ENABLED!"
	fi;
	terminal_output console;
	echo $"Loading kernel";
	kopenbsd ${bsd_kernel};
	echo $"Starting OpenBSD";
}
