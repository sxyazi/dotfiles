local msg = require('mp.msg')

function reveal_file()
	local path = mp.get_property("path")
	if not path then
		return msg.debug("no media has been loaded.")
	end

	if path:sub(1, 4) == "http" then
		mp.commandv("run", "open", path)
	else
		mp.commandv("run", "open", "-a", "Finder", "-R", path)
	end
end

mp.add_key_binding("o", "reveal-file", reveal_file)
