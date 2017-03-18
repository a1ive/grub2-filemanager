for dev in (*); do
        test -e ${dev};
        if test "$?" = "1"; then
                continue;
        fi;
        regexp --set=device '\((.*)\)' $dev;
        if regexp 'efi' $grub_platform; then
	        if test -f ($device)/efi/microsoft/boot/bootmgfw.efi; then
        	        menuentry "启动位于${device}的 Windows 操作系统 " $device --class wim{
        	                set root=$2
        	                chainloader ($root)/efi/microsoft/boot/bootmgfw.efi;
        	        }
        	fi;
        	if test -f ($device)/efi/boot/bootx64.efi; then
        	        menuentry "加载位于${device}的启动管理器 " $device --class uefi{
        	                set root=$2
        	                chainloader ($root)/efi/boot/bootx64.efi;
        	        }
        	fi;
        	if test -f ($device)/System/Library/CoreServices/boot.efi; then
        	        menuentry "启动位于${device}的 macOS " $device --class macOS{
        	                set root=$2
        	                chainloader ($root)/System/Library/CoreServices/boot.efi;
        	        }
        	fi;
        else
        	menuentry "启动${device}" $device --class img{
        		set root=$2
        		chainloader +1;
        	}
        fi
done;
menuentry "重启计算机" --class reboot{
	reboot;
}
menuentry "关闭计算机" --class halt{
	halt;
}
menuentry "返回" --class go-previous{
	configfile $prefix/main.sh;
}