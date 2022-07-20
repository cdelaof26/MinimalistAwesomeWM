
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local hotkeys_popup = require("awful.hotkeys_popup")

local ui = require("tools.ui_manager")
local theme = require("tools.theme_manager")
local utilities = require("tools.utils")

local button_factory = require("ui.menu_button")

local screen = awful.screen.focused()


local menu = wibox {
    screen       = screen,
    shape        = ui.ROUNDED_RECT,
    expand       = true,
    visible      = false,
    ontop        = true,
    x            = ui.top_bar_position.x, 
    y            = ui.invisible_top_bar_height,
    width        = ui.main_menu_dimension.width,
    height       = ui.main_menu_dimension.height,
    border_width = ui.top_bar_border,
    border_color = theme.t_foreground_color
}

local function show_menu()
    menu.visible = not menu.visible
end

menu : connect_signal(
    "mouse::leave", 
    function()
        if menu.visible then
            menu.visible = false
        end
    end
)


local integrated_menu = {
    create_function = function(button_function)
        return function()
            show_menu()
            button_function()
        end
    end
}

local awesome_shortcuts_fun = function() show_menu() hotkeys_popup.show_help(nil, awful.screen.focused()) end
local awesome_shortcuts     = button_factory.create_button(theme.key_icon, theme.d_key_icon, "Awesome shortcuts", awesome_shortcuts_fun)

local awesome_settings_fun = integrated_menu.create_function(ui.show_notification)
local awesome_settings     = button_factory.create_button(theme.settings_icon, theme.d_settings_icon, "Awesome settings", awesome_settings_fun)

local toggle_theme_fun = integrated_menu.create_function(theme.toggle_theme)
local toggle_theme     = button_factory.create_button(theme.toggle_theme_icon, theme.d_toggle_theme_icon, "Toggle theme", toggle_theme_fun)

local restart_fun = integrated_menu.create_function(utilities.restart)
local restart     = button_factory.create_button(theme.restart_icon, theme.d_restart_icon, "Restart", restart_fun)

local poweroff_fun = integrated_menu.create_function(utilities.poweroff)
local poweroff     = button_factory.create_button(theme.power_icon, theme.d_power_icon, "Power off", poweroff_fun)

local logout_fun = integrated_menu.create_function(awesome.quit)
local logout     = button_factory.create_button(theme.account_icon, theme.d_account_icon, "Log out", logout_fun)


menu : setup {
    layout = wibox.layout.align.vertical,
    
    {
        layout = wibox.layout.align.vertical,
        awesome_shortcuts,
        awesome_settings,
        toggle_theme
    },
    
    {
        layout = wibox.layout.align.vertical,
        restart,
        poweroff,
        logout
    },
    nil
}




return { show_menu = show_menu }


-- local awful = require("awful")
-- local wibox = require("wibox")
-- local gears = require("gears")
-- local menubar = require("menubar")
-- local hotkeys_popup = require("awful.hotkeys_popup")
-- 
-- -- local icons = require("icons")
-- local theme = require("tools.theme_manager")
-- local ui = require("tools.ui_manager")
-- 
-- local utilities = require("tools.utils")
-- 
-- myawesomemenu = {
--    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
--    { "manual", terminal .. " -e man awesome" },
--    { "restart", awesome.restart },
--    { "quit", function() awesome.quit() end },
-- }
-- 
-- local menu_awesome = { "awesome", myawesomemenu, theme.main_icon }
-- local menu_terminal = { "open terminal", terminal }
-- 
-- -- mymainmenu = awful.menu({
-- --     items = {
-- --         menu_awesome,
-- --         -- { "Debian", debian.menu.Debian_menu.Debian },
-- --         menu_terminal,
-- --     }
-- -- })
-- 
-- local awesome_shortcuts = {
--     "Awesome shortcuts",
--     function()
--         hotkeys_popup.show_help(nil, awful.screen.focused())
--     end 
-- }
-- 
-- local awesome_settings = {
--     "Awesome settings",
--     terminal,
--     theme.settings_icon
-- }
-- 
-- local toggle_theme = {
--     "Toggle theme",
--     terminal,
--     theme.toggle_theme_icon
-- }
-- 
-- local restart = {
--     "Restart",
--     function()
--         utilities.restart()
--     end,
--     theme.restart_icon
-- }
-- 
-- local poweroff = {
--     "Power off",
--     function()
--         utilities.poweroff()
--     end,
--     theme.power_icon
-- }
-- 
-- local logout = {
--     "Log out " .. utilities.whoami,
--     function()
--         awesome.quit()
--     end
-- }
-- 
-- 
-- local search_button = {
--     "Search",
--     function()
--         utilities.show_rufi()
--     end,
--     wibox.widget {
--         layout = wibox.container.margin(self, ui.main_menu_icon_margin, ui.main_menu_icon_margin, ui.main_menu_icon_margin, ui.main_menu_icon_margin),
--         {
--             widget        = wibox.widget.imagebox,
--             forced_width  = ui.main_menu_icon_dimension,
--             forced_height = ui.main_menu_icon_dimension,
--             resize        = true,
--             image         = theme.search_icon
--         }
--     }
-- }
-- 
-- 
-- local mymainmenu = awful.menu(
--     {
--         items = {
--             search_button,
--             awesome_shortcuts,
--             awesome_settings,
--             toggle_theme,
--             restart,
--             poweroff,
--             logout
--         }
--     }
-- ) 
-- 
-- menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- 
-- local function show_menu()
--     mymainmenu : toggle(
--         { 
--             coords = { x = ui.top_bar_position.x, y = ui.invisible_top_bar_height } 
--         }
--     )
-- end
-- 
-- return { show_menu = show_menu }
