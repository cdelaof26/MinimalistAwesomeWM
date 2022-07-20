----------------------------------
-- GUI utilitites and constants --
----------------------------------


local naughty = require("naughty")
local gears   = require("gears")
local awful   = require("awful")
local wibox   = require("wibox")

local theme = require("tools.theme_manager")


local gui_utilities = {}


-- General element attributes

local ROUNDED_RECT = gears.shape.rounded_rect
local DEFAULT_BORDER_WIDTH = 10


-- Dimensions
local dock_dimension = {
	width = 50,
	height = 35
}
local dock_width_multiplier = 44



local top_bar_height  = 40
local top_bar_spacing = 20
local top_bar_border  = 1

local top_bar_position = {
	x = 10,
	y = 10
}

local invisible_top_bar_height = top_bar_height + 12


local search_icon_dimension = 25
local search_icon_margin = ((top_bar_height - search_icon_dimension) / 1.5)

local main_menu_dimension = {
	width  = 200,
    height = 240
}

local main_menu_icon_dimension = 20
local main_menu_icon_margin = 10


local function toggle_theme()
	awful.spawn.easy_async(
		-- Spawm ls at .config/awesome
		"ls .config/awesome", 
		function(stdout)
			-- Search for use_dark file
			if string.find(("" .. stdout), "use_dark") then
				-- If exists, delete it to apply light theme
                awful.spawn.easy_async("rm .config/awesome/use_dark")
            else
                -- If doesn't exists, create to apply dark theme
                awful.spawn.easy_async("touch .config/awesome/use_dark")
            end

            awesome.restart()
        end
    )
end

local function show_notification(title, msg)
	naughty.notify(
		{
			title = title,
			text = msg,
			shape = ROUNDED_RECT,
			border_width = DEFAULT_BORDER_WIDTH,
			bg = theme.p_accent_color,
			fg = theme.t_foreground_accent_color,
			border_color = theme.p_accent_color
		}
	)
end

local function set_wallpaper(screen)
    local wallpaper = require("beautiful").wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(screen)
    end

    gears.wallpaper.maximized(wallpaper, screen, true)
end

local function calculate_client_button_margin(screen_width, screen_height)
	local margins = { }

	-- This is needed since it may look different depending on screen orientation
	if screen_width >= screen_height then
		margins.l = screen_width * 0.003125
		margins.s = screen_width * 0.0015625
	else
		margins.l = screen_height * 0.003125
		margins.s = screen_height * 0.0015625
	end

	-- On 1920x1080 monitor
	-- l is expected to be 6
	-- s is expected to be 3

	-- Doesn't matter the screen orientation

	return margins
end

-- Restart awesome if display resolution is changed
screen.connect_signal("property::geometry", awesome.restart)

-- Add buttons to each client
client.connect_signal(
    "request::titlebars", 
    function(client)
        local buttons = gears.table.join(
            awful.button(
                { }, 
                1, 
                function()
                    client : emit_signal("request::activate", "titlebar", { raise = true })
                    awful.mouse.client.move(client)
                end
            ),

            awful.button(
                { }, 
                3, 
                function()
                    client : emit_signal("request::activate", "titlebar", { raise = true })
                    awful.mouse.client.resize(client)
                end
            )
        )

        local screen_geometry = awful.screen.focused().geometry
        local margins = calculate_client_button_margin(screen_geometry.width, screen_geometry.height)

        awful.titlebar(client) : setup {
            layout = wibox.layout.align.horizontal,

            {
                layout = wibox.layout.fixed.horizontal(),
                wibox.layout.margin(awful.titlebar.widget.closebutton(client),     margins.l, margins.s, margins.l, margins.l),
                wibox.layout.margin(awful.titlebar.widget.minimizebutton(client),  margins.l, margins.s, margins.l, margins.l),
                wibox.layout.margin(awful.titlebar.widget.maximizedbutton(client), margins.l, margins.s, margins.l, margins.l)
            },
            {
                layout  = wibox.layout.flex.horizontal,
                buttons = buttons
            }
        }
    end
)

gui_utilities.ROUNDED_RECT             = ROUNDED_RECT
gui_utilities.DEFAULT_BORDER_WIDTH     = DEFAULT_BORDER_WIDTH
gui_utilities.dock_dimension           = dock_dimension
gui_utilities.dock_width_multiplier    = dock_width_multiplier
gui_utilities.top_bar_height           = top_bar_height
gui_utilities.top_bar_spacing          = top_bar_spacing
gui_utilities.top_bar_border           = top_bar_border
gui_utilities.top_bar_position         = top_bar_position
gui_utilities.invisible_top_bar_height = invisible_top_bar_height
gui_utilities.search_icon_dimension    = search_icon_dimension
gui_utilities.search_icon_margin       = search_icon_margin
gui_utilities.main_menu_dimension      = main_menu_dimension
gui_utilities.main_menu_icon_dimension = main_menu_icon_dimension
gui_utilities.main_menu_icon_margin    = main_menu_icon_margin
gui_utilities.show_notification        = show_notification
gui_utilities.set_wallpaper            = set_wallpaper


return gui_utilities
