theme = grub.getenv ("theme")
if (theme == nil) then	
grub.exportenv ("theme", "slack/f2.txt")
else
grub.exportenv ("theme", theme)	
end

net_efinet0_dhcp_ip = grub.getenv ("net_efinet0_dhcp_ip")
net_default_ip = grub.getenv ("net_default_ip")
net_default_server = grub.getenv ("net_default_server")
net_efinet0_next_server = grub.getenv ("net_efinet0_next_server")
net_pxe_next_server = grub.getenv ("net_pxe_next_server") 
platform = grub.getenv ("grub_platform")


function check_file (name, name_extn)
    if (name == nil) then
        return 1
    end
    file_type = "unknown"
    file_icon = "file"
    if (name_extn == nil) then
        return file_type, file_icon
    end
    name_extn = string.lower(name_extn)
    if name_extn == "iso" then
        file_type, file_icon = "iso", "iso_file"
    elseif name_extn == "img" or name_extn == "ima" then
        file_type, file_icon = "disk", "img"
    elseif name_extn == "vhd" or name_extn == "vhdx" then
        file_type, file_icon = "vhd", "img"
    elseif name_extn == "fba" then
        file_type, file_icon = "fba", "img"
    elseif name_extn == "jpg" or name_extn == "png" or name_extn == "tga" then
        file_type, file_icon = "image", "png"
    elseif name_extn == "bmp" or name_extn == "gif" then
        file_icon = "png"
    elseif name_extn == "efi" then
        file_type, file_icon = "efi", "exe"
    elseif name_extn == "lua" then
        file_type, file_icon = "lua", "lua"
    elseif name_extn == "7z" or name_extn == "rar" then
        file_icon = "7z"
    elseif name_extn == "lz" or name_extn == "zip" or name_extn == "lzma" then
        file_icon = "7z"
    elseif name_extn == "tar" or name_extn == "xz" or name_extn == "gz" or name_extn == "cpio" then
        file_type, file_icon = "tar", "7z"
    elseif name_extn == "wim" then
        file_type, file_icon = "wim", "wim"
    elseif name_extn == "is_" or name_extn == "im_" then
        file_type, file_icon = "wpe", "wim"
    elseif name_extn == "exe" then
        file_icon = "exe"
    elseif name_extn == "cfg" then
        file_type, file_icon = "cfg", "cfg"
    elseif name_extn == "pf2" then
        file_type, file_icon = "pf2", "pf2"
    elseif name_extn == "mod" then
        file_type, file_icon = "mod", "mod"
    elseif name_extn == "mbr" then
        file_type, file_icon = "mbr", "bin"
    elseif name_extn == "nsh" then
        file_type, file_icon = "nsh", "sh"
    elseif name_extn == "sh" or name_extn == "bat" then
        file_icon = "sh"
    elseif name_extn == "lst" then
        file_type, file_icon = "lst", "cfg"
    elseif name_extn == "ipxe" then
        file_type, file_icon = "ipxe", "net"
    elseif name_extn == "c" or name_extn == "cpp" or name_extn == "h" or name_extn == "hpp" or name_extn == "s" or name_extn == "asm" then
        file_icon = "c"
    elseif name_extn == "mp3" or name_extn == "wav" or name_extn == "cda" or name_extn == "ogg" then
        file_icon = "mp3"
    elseif name_extn == "mp4" or name_extn == "mpeg" or name_extn == "avi" or name_extn == "rmvb" or name_extn == "3gp" or name_extn == "flv" then
        file_icon = "mp4"
    elseif name_extn == "doc" or name_extn == "docx" or name_extn == "wps" or name_extn == "pptx" or name_extn == "pptx" or name_extn == "xls" or name_extn == "xlsx" then
        file_icon = "doc"
    elseif name_extn == "txt" or name_extn == "ini" or name_extn == "log" then
        file_icon = "txt"
    elseif name_extn == "crt" or name_extn == "cer" or name_extn == "der" then
        file_icon = "crt"
    elseif name_extn == "py" or name_extn == "pyc" then
        file_type, file_icon = "py", "py"
    end
    return file_type, file_icon
end

local listtxt = "(pxe)/dir.txt"
encoding = grub.getenv ("encoding")
if (encoding == nil) then
	encoding = "utf8"
end
enable_sort = grub.getenv ("enable_sort")
if (enable_sort == nil) then
	enable_sort = "1"
end

if (path == nil) then
	path = ""
end

icon = "go-previous"
command = "clear_menu; grubfm_set --boot 1; grubfm; configfile $prefix/netboot.sh"
grub.add_icon_menu (icon, command, "[back] http://" .. net_default_server .. "/dir.txt")		
--netboot menu
if (listtxt== nil) then
        return 1
else
        data = grub.file_open(listtxt)
        while (grub.file_eof(data) == false)
        do
		line = grub.file_getline (data)
		file = "(http)/" .. line
		name_extn = string.match (file, ".*%.(.*)$")
        file_type, file_icon = check_file (file, name_extn)
		
		
		command = "export file_type=" .. file_type .. "; grubfm_open " .. file .. "; "
		line = gbk.toutf8(line)
		grub.add_icon_menu (file_icon ,command, line)
end		
		 return 0
	
end
