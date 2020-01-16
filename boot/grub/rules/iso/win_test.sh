if ! regexp '^hd.*' "${grubfm_device}";
then
  set grubfm_test=0;
  return;
fi;

loopback -d loop;
loopback loop "${grubfm_file}";
set win_prefix=(loop)/sources/install;
set w64_prefix=(loop)/x64/sources/install;
set w32_prefix=(loop)/x86/sources/install;
if [ -f ${win_prefix}.wim -o -f ${win_prefix}.esd -o -f ${win_prefix}.swm ];
then
  set grubfm_test=1;
elif [ -f ${w64_prefix}.wim -o -f ${w64_prefix}.esd -o -f ${w64_prefix}.swm ];
then
  set grubfm_test=1;
elif [ -f ${w32_prefix}.wim -o -f ${w32_prefix}.esd -o -f ${w32_prefix}.swm ];
then
  set grubfm_test=1;
else
  set grubfm_test=0;
fi;
