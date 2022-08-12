----------------------------------
-- GUI utilitites and constants --
----------------------------------


local naughty = require("naughty")
local gears   = require("gears")
local awful   = require("awful")
local wibox   = require("wibox")

-- local theme = require("ui.tools.theme_manager")


local gui_utilities = {}


-- General element attributes

local ROUNDED_RECT = gears.shape.rounded_rect
local default_border_width = 10


-- Dimensions
local dock_dimension = {
	width = 50,
	height = 50
}

local dock_separation = 10

local dock_width_multiplier = 44

local dock_border_width = (default_border_width / 2)
local dock_total_border = dock_border_width * 2

local invisible_dock_bar_height = dock_dimension.height + dock_total_border + dock_separation



local top_bar_height  = 40
local top_bar_spacing = 20
local top_bar_border  = 1

local top_bar_position = {
	x = 10,
	y = 10
}

local invisible_top_bar_height = top_bar_height + top_bar_position.y


local search_icon_dimension = 20
local search_icon_margin = 10

local right_bar_widgets_margin = 15

local main_menu_dimension = {
	width  = 200,
    height = 200
}

local main_menu_icon_dimension = 20
local main_menu_icon_margin = 10


local function show_notification(title, msg)
	naughty.notify(
		{
			title = title,
			text = msg,
			shape = ROUNDED_RECT,
			border_width = default_border_width,
			--bg = theme.p_accent_color,
			fg = "#AAAAAA" --theme.t_foreground_accent_color,
			--border_color = theme.p_accent_color
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

local new_button_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 5)
end

gui_utilities.ROUNDED_RECT              = ROUNDED_RECT
gui_utilities.default_border_width      = default_border_width
gui_utilities.dock_dimension            = dock_dimension
gui_utilities.dock_separation           = dock_separation
gui_utilities.dock_width_multiplier     = dock_width_multiplier
gui_utilities.dock_border_width         = dock_border_width
gui_utilities.dock_total_border         = dock_total_border
gui_utilities.invisible_dock_bar_height = invisible_dock_bar_height
gui_utilities.top_bar_height            = top_bar_height
gui_utilities.top_bar_spacing           = top_bar_spacing
gui_utilities.top_bar_border            = top_bar_border
gui_utilities.top_bar_position          = top_bar_position
gui_utilities.invisible_top_bar_height  = invisible_top_bar_height
gui_utilities.search_icon_dimension     = search_icon_dimension
gui_utilities.search_icon_margin        = search_icon_margin
gui_utilities.right_bar_widgets_margin  = right_bar_widgets_margin
gui_utilities.main_menu_dimension       = main_menu_dimension
gui_utilities.main_menu_icon_dimension  = main_menu_icon_dimension
gui_utilities.main_menu_icon_margin     = main_menu_icon_margin
gui_utilities.show_notification         = show_notification
gui_utilities.set_wallpaper             = set_wallpaper
gui_utilities.new_button_shape          = new_button_shape

return gui_utilities
