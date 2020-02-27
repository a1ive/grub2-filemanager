# Grub2-FileManager
# Copyright (C) 2020  A1ive.
#
# Grub2-FileManager is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Grub2-FileManager is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Grub2-FileManager.  If not, see <http://www.gnu.org/licenses/>.

menuentry "en_US" --class lang {
  export lang=en_US;
  configfile ${prefix}/settings.sh;
}

for mo_file in ${secondary_locale_dir}/*.mo;
do
  regexp --set=mo '^.*/([0-9a-zA-Z_]+)\.mo$' "${mo_file}";
  menuentry "${mo}" --class lang {
    export lang="${1}";
    configfile ${prefix}/settings.sh;
  }
done;
source ${prefix}/global.sh;
