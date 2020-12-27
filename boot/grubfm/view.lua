#!lua
-- Grub2-FileManager
-- Copyright (C) 2018, 2019, 2020  A1ive.
--
-- Grub2-FileManager is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- Grub2-FileManager is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Grub2-FileManager.  If not, see <http://www.gnu.org/licenses/>.

function display_bmp (filename)
  scr_w, scr_h = video.get_info ();
  if (scr_w == 0 or scr_h == 0) then
    print ("Not available.")
    return
  end
  video.fill_rect ({r=0, g=0, b=0}, 0, 0, scr_w, scr_h)
  grub.refresh()
  bitmap = video.bitmap_load (filename)
  if (bitmap == nil) then
    print ("failed to load " .. filename)
    return
  end
  w, h = video.bitmap_info (bitmap)
  if (w > scr_w or h > scr_h) then
    new_bitmap = video.bitmap_rescale (bitmap, scr_w, scr_h)
    video.bitmap_blit (new_bitmap, 0, 0, 0, 0, scr_w, scr_h)
    video.bitmap_close (new_bitmap)
  else
    video.bitmap_blit (bitmap, (scr_w - w) / 2, (scr_h - h) / 2, 0, 0, scr_w, scr_h)
  end
  video.draw_string (grub.gettext ("Press any key to exit."), "Unifont Regular 16", {r=255, g=255, b=255}, 0, scr_h - 16)
  grub.refresh ()
  video.bitmap_close (bitmap)
  input.getkey ()
end

file = grub.getenv ("bmp_path")
if (file ~= nil) then
  display_bmp (file)
end
