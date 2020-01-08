loopback -d loop;
loopback loop "${grubfm_file}";
regexp --set=1:iso_path '(/.*)$' "${grubfm_file}";
regexp --set=1:iso_device '^(\([0-9a-zA-Z,]+\))/.*' "${grubfm_file}";
probe --set=rootuuid -u "${iso_device}";
export iso_path;
export rootuuid;
set root=loop;
configfile /boot/grub/loopback.cfg;
