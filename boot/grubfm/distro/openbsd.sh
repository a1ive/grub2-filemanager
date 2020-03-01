set bsd_kernel=(loop)/*/*/bsd.rd;
terminal_output console;
enable_progress_indicator=1;
echo "Loading kernel";
kopenbsd ${bsd_kernel};
echo "Starting OpenBSD";
