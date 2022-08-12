-------------------------------
-- Multi purposes utilitites --
-------------------------------


local awful = require("awful")


local utilities = {}


local process = io.popen("grep MemTotal /proc/meminfo")
local system_memory = tonumber(string.match((process : read("*a")), "%d+"))
process : close()

local convert_units = function(memory_in_kB)
	local memory = memory_in_kB
	local prefix = "kB"

	if string.len(memory_in_kB) >= 4 or string.len(memory_in_kB) < 7 then
		memory = string.format("%.2f", memory_in_kB / 1000)
		prefix = "MB"
	end
	if string.len(memory_in_kB) >= 7 then
		memory = string.format("%.2f", memory_in_kB / 1000000)
		prefix = "GB"
	end

	return {
		memory = memory,
		prefix = prefix
	}
end

local sys_memory = convert_units(system_memory)
	
local convert_units_sys = function(memory_in_kB)
	if sys_memory.prefix == "MB" then
		return memory_in_kB / 1000
	end
	if sys_memory.prefix == "GB" then
		return memory_in_kB / 1000000
	end
end



process = io.popen("whoami")
local whoami = string.gsub((process : read("*a")), "\n", "")
process : close()


local show_rufi = function()
	awful.spawn(
		"rofi -show drun"
	)
end

local restart = function()
	awful.spawn(
		"systemctl reboot"
	)
end

local poweroff = function()
	awful.spawn(
		"systemctl poweroff"
	)
end

local create_stop_flag = function()
	local flag = io.popen("touch .config/awesome/mini_tools/stop_all; sleep 1")
	flag : close()
end

local delete_stop_flag = function()
	local signal = io.popen("rm .config/awesome/mini_tools/stop_all")
	signal : close()
end

utilities.system_memory     = system_memory
utilities.convert_units     = convert_units
utilities.sys_memory        = sys_memory
utilities.convert_units_sys = convert_units_sys
utilities.whoami            = whoami
utilities.show_rufi         = show_rufi
utilities.restart           = restart
utilities.poweroff          = poweroff
utilities.sleep             = sleep
utilities.delete_stop_flag  = delete_stop_flag
utilities.create_stop_flag  = create_stop_flag

return utilities
