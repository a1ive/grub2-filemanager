function Easy2Boot {
	AutoSwap;
	regexp --set=file_name '^\(hd[0-9]+(,[0-9a-zA-Z]+\).*)$' "$file_name";
	file_name="(hd0,${file_name}";
	set g4d_param="cdboot";
	lua $prefix/g4d_path.lua;
	linux $prefix/tools/grub.exe --config-file=$g4dcmd;
}
function AutoSwap {
	if regexp '^hd[0-9a-zA-Z,]+$' $root; then
		regexp -s devnum '^hd([0-9]+).*$' $root;
		if test "devnum" != "0"; then
			drivemap -s (hd0) ($root);
		fi;
	fi;
}
regexp --set=devname '^\(([0-9a-zA-Z,]+)\).*$' "$file_name";
if regexp --set=devnum '^hd([0-9]+),[0-9a-zA-Z,]+' "$devname"; then
	set root="$devname";
	if test -d "(hd${devnum},4)"; then
		echo $"WARNING: Partition table 4 is already in use on this device.";
		echo $"WARNING: Will erase ALL data on (hd0,4).";
		echo $"Press [Y] to continue. Press [N] to quit.";
		getkey key;
		if [ "$key" == "121" ]; then
			Easy2Boot;
		else
			echo $"Canceled.";sleep 3;
		fi;
	else
		Easy2Boot;
	fi;
fi;