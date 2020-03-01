source ${prefix}/func.sh;

menuentry $"File Info (${grubfm_name})" --class info {
  configfile ${prefix}/rules/generic/info.sh;
}
