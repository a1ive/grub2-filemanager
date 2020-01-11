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

export theme=${prefix}/themes/slack/fm.txt;

hiddenentry "---- HOTKEY MENU ----" {
  echo "";
}

hiddenentry "[F1] HELP" --hotkey f1 {
  echo "help";
  getkey;
}

hiddenentry "[F2] FILE MANAGER" --hotkey f2 {
  grubfm;
}

hiddenentry "[F3] OS DETECT" --hotkey f3 {
  echo "os detect";
  getkey;
}

hiddenentry "[F4] SETTINGS" --hotkey f4 {
  configfile ${prefix}/settings.sh;
}

hiddenentry "[F5] POWER OFF" --hotkey f5 {
  configfile ${prefix}/power.sh;
}
