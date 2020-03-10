#!lua

function search_replace (in_file, out_file, search_table, replace_table, dos)
  if (in_file == nil or out_file == nil) then
    print ("file not exist\n")
    return
  end
  local i = 0
  local j = 0
  local t = 0
  local line = ""
  local str = ""
  local line_ending = "\n"
  if (dos ~= nil and dos == true) then
    line_ending = "\r\n"
  end
  grub.file_seek (in_file, 0)
  grub.file_seek (out_file, 0)
  while (grub.file_eof (in_file) ~= true)
  do
    i = i + 1
    line = grub.file_getline (in_file)
    for j, str in ipairs (search_table) do
      line, t = string.gsub (line, str, replace_table[j])
      if (t > 0) then
        print ("line " .. i .. ", string " .. search_table[j] .. " found")
      end
    end
    grub.file_write (out_file, line)
    grub.file_write (out_file, line_ending)
  end
end

search_str = grub.getenv ("search_str")
replace_str = grub.getenv ("replace_str")
finename = grub.getenv ("src_file")
file1 = grub.file_open (finename)
file2 = grub.file_open (finename, "w")
search_replace (file1, file2, {search_str}, {replace_str})
grub.file_close (file1)
grub.file_close (file2)
