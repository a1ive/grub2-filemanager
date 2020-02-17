source ${prefix}/func.sh;

menuentry $"File Info (${grubfm_name})" --class info {
  stat "${grubfm_file}";
  getkey;
}
