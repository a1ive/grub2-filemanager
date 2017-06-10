# grub2-filemanager 
## Preview 
[![preview.png](https://s29.postimg.org/udhuu37nr/preview.png)](https://postimg.org/image/tnz2hq743/)
## Download 
https://github.com/a1ive/grub2-filemanager/releases 
## Build
	git clone https://github.com/a1ive/grub2-filemanager.git
	cd grub2-filemanager
	./build.sh
## Boot 
### i386-pc 
#### GRUB4DOS 
	map --mem /grubfm.iso (0xff)
	map --hook
	chainloader (0xff)
#### GRUB Legacy 
	kernel /memdisk
	initrd /grubfm.iso
#### GRUB 2/BURG 
	linux16 /memdisk iso raw
	initrd16 /grubfm.iso
#### Syslinux 
	LINUX memdisk
	INITRD grubfm.iso
	APPEND iso raw
### x86_64-efi, i386-efi 
#### GRUB 2 
	chainloader /grubfm.efi
#### rEFInd 
	loader /grubfm.efi
#### Systemd-boot 
	efi /grubfm.efi
