function copy_subtitle()
	local subtitle = mp.get_property("sub-text")
	if not subtitle then
		return
	end

	mp.commandv(
		"run", "/bin/bash", "-c",
		("echo -n %q | LANG=en_US.UTF-8 pbcopy"):format(subtitle)
	)
	mp.osd_message("Subtitle line copied!")
end

mp.add_key_binding("Meta+c", "copy-subtitle", copy_subtitle)
