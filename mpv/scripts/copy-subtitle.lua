function copy_subtitle()
	local subtitle = mp.get_property("sub-text")
	if not subtitle then
		return
	end

	local last = ""
	for w in string.gmatch(subtitle .. "\n", "(.-)[\r\n]+") do
		if w:find("%S") then
			last = w:gsub("^%s+", ""):gsub("%s+$", "")
		end
	end

	mp.commandv("run", "sh", "-c", 'printf "%s" "$1" | LANG=en_US.UTF-8 pbcopy', "", last)
	mp.osd_message("Subtitle line copied!")
end

mp.add_key_binding("Meta+c", "copy-subtitle", copy_subtitle)
