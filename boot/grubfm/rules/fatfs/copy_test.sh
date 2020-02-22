stat -s size -z "${grubfm_file}";
# 4000000000
if regexp '^[0-9]{0,9}$' "${size}";
then
  # 0 - 999 999 999
  set grubfm_test=1;
elif regexp '^[0-3][0-9]{0,9}$' "${size}";
then
  # 1 000 000 000 - 3 999 999 999
  set grubfm_test=1;
else
  set grubfm_test=0;
fi;
