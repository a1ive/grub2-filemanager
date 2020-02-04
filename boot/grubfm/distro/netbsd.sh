set bsd_kernel=(loop)/netbsd;
set bsd_module=(loop)/*/installation/miniroot/miniroot.kmod
terminal_output console;
enable_progress_indicator=1;
echo "Loading kernel";
knetbsd ${bsd_kernel};
echo "Loading modules";
knetbsd_module_elf ${bsd_module};
echo "Starting NetBSD";
