-------------------------------
-- Multi purposes utilitites --
-------------------------------


local awful = require("awful")


local utilities = {}

local call = io.popen("whoami")
local whoami = string.gsub((call : read("*a")), "\n", "")
call : close()


local function show_rufi()
	awful.spawn.easy_async(
    	"rofi -show drun",
    	function(stdout) end
	)
end

local function restart()
	awful.spawn(
		"systemctl reboot"
	)
end

local function poweroff()
	awful.spawn(
		"systemctl poweroff"
	)
end

local function sleep(seconds)
	-- Linux only
	os.execute("sleep " .. tonumber(seconds))
end

utilities.whoami    = whoami
utilities.show_rufi = show_rufi
utilities.restart   = restart
utilities.poweroff  = poweroff
utilities.sleep     = sleep

return utilities
