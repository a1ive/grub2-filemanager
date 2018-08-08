#!lua
-- Detects the live system type and boots it
function boot_iso (isofile, langcode)
  -- grml
  if (dir_exist ("(loop)/boot/grml64")) then
    boot_linux (
      "(loop)/boot/grml64/linux26",
      "(loop)/boot/grml64/initrd.gz",
      "findiso=" .. isofile .. " apm=power-off quiet boot=live nomce"
    )
  -- Parted Magic
  elseif (dir_exist ("(loop)/pmagic")) then
    boot_linux (
      "(loop)/pmagic/bzImage",
      "(loop)/pmagic/initramfs",
      "iso_filename=" .. isofile ..
        " edd=off noapic load_ramdisk=1 prompt_ramdisk=0 rw" ..
        " sleep=10 loglevel=0 keymap=" .. langcode
    )
  -- Sidux
  elseif (dir_exist ("(loop)/sidux")) then
    boot_linux (
      find_file ("(loop)/boot", "vmlinuz%-.*%-sidux%-.*"),
      find_file ("(loop)/boot", "initrd%.img%-.*%-sidux%-.*"),
      "fromiso=" .. isofile .. " boot=fll quiet"
    )
  -- Slax
  elseif (dir_exist ("(loop)/slax")) then
    boot_linux (
      "(loop)/boot/vmlinuz",
      "(loop)/boot/initrd.gz",
      "from=" .. isofile .. " ramdisk_size=6666 root=/dev/ram0 rw"
    )
  -- SystemRescueCd
  elseif (grub.file_exist ("(loop)/isolinux/rescue64")) then
    boot_linux (
      "(loop)/isolinux/rescue64",
      "(loop)/isolinux/initram.igz",
      "isoloop=" .. isofile .. " docache rootpass=xxxx setkmap=" .. langcode
    )
  -- Tinycore
  elseif (grub.file_exist ("(loop)/boot/tinycore.gz")) then
    boot_linux (
      "(loop)/boot/bzImage",
      "(loop)/boot/tinycore.gz"
    )
  -- Ubuntu and Casper based Distros
  elseif (dir_exist ("(loop)/casper")) then
    boot_linux (
      "(loop)/casper/vmlinuz",
      find_file ("(loop)/casper", "initrd%..z"),
      "boot=casper iso-scan/filename=" .. isofile ..
        " quiet splash noprompt" ..
        " keyb=" .. langcode ..
        " debian-installer/language=" .. langcode ..
        " console-setup/layoutcode?=" .. langcode ..
        " --"
    )
  -- Xpud
  elseif (grub.file_exist ("(loop)/boot/xpud")) then
    boot_linux (
      "(loop)/boot/xpud",
      "(loop)/opt/media"
    )
  else
    print_error ("Unsupported ISO type")
  end
end
-- Help function to show an error
function print_error (msg)
  print ("Error: " .. msg)
  grub.run ("read")
end
-- Help function to search for a file
function find_file (folder, match)
  local filename
  local function enum_file (name)
    if (filename == nil) then
      filename = string.match (name, match)
    end
  end
  grub.enum_file (enum_file, folder)
  if (filename) then
    return folder .. "/" .. filename
  else
    return nil
  end
end
-- Help function to check if a directory exist
function dir_exist (dir)
  return (grub.run("test -d '" .. dir .. "'") == 0)
end
-- Boots a Linux live system
function boot_linux (linux, initrd, params)
  if (linux and grub.file_exist (linux)) then
    if (initrd and grub.file_exist (initrd)) then
      if (params) then
        grub.run ("linux " .. linux .. " " .. params)
      else
        grub.run ("linux " .. linux)
      end
      grub.run ("initrd " .. initrd)
    else
      print_error ("Booting Linux failed: cannot find initrd file '" .. initrd .. "'")
    end
  else
    print_error ("Booting Linux failed: cannot find linux file '" .. initrd .. "'")
  end
end
-- Mounts the iso file
function mount_iso (isofile)
  local result = false
  if (isofile == nil) then
    print_error ("variable 'isofile' is undefined")
  elseif (not grub.file_exist (isofile)) then
    print_error ("Cannot find isofile '" .. isofile .. "'")
  else
    local err_no, err_msg = grub.run ("loopback loop " .. isofile)
    if (err_no ~= 0) then
      print_error ("Cannot load ISO: " .. err_msg)
    else
      result = true
    end
  end
  return result
end
-- Getting the environment parameters
isofile = grub.getenv ("isofile")
langcode = grub.getenv ("isolangcode")
if (langcode == nil) then
  langcode = "us"
end
-- Mounting and booting the live system
if (mount_iso (isofile)) then
  boot_iso (isofile, langcode)
end
