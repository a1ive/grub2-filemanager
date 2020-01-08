loopback -d loop;
loopback loop "${grubfm_file}";
if [ -f (loop)/boot/grub/loopback.cfg ];
then
  set grubfm_test=1;
else
  set grubfm_test=0;
fi;
