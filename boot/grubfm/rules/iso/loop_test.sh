source ${prefix}/func.sh;

if ! regexp '^hd.*' "${grubfm_device}";
then
  set grubfm_test=0;
  return;
fi;

loopback -d loop;
loopback loop "${grubfm_file}";
if [ -f (loop)/boot/grub/loopback.cfg ];
then
  set grubfm_test=1;
else
  set grubfm_test=0;
fi;
