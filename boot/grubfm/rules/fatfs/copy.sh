source ${prefix}/func.sh;

function fatfs_opt {
  if [ -z "${dest}" ];
  then
    echo "return ...";
  fi;
  echo "DEST: ${dest}";
  regexp --set=1:dest_dev '^\(([0-9a-zA-Z,]+)\)/.*' "${dest}";
  regexp --set=1:dest_path '(/.*)$' "${dest}";
  echo "DESTDEV: ${dest_dev}";
  echo "DESTDIR: ${dest_path}";
  echo $"Enter the name";
  read name;
  echo "";
  if regexp '[/\\:\*\?\$]' "${name}";
  then
    echo $"Bad file name.";
    echo $"Press any key to exit.";
  else
    set path="${dest_path}${name}";
    umount 9;
    mount (${dest_dev}) 9;
    echo $"Please wait ...";
    cp "${grubfm_file}" "9:/${path}";
    umount 9;
  fi;
  grubfm_open "${grubfm_file}";
}

source ${prefix}/rules/fatfs/list.sh;

unset dest;
list_main;

