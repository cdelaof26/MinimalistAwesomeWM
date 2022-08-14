pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Theme handling library
local beautiful = require("beautiful")

require("awful.autofocus")


-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"

local wibox = require("wibox")

local utilities = require("tools.utils")
local ui = require("ui.tools.ui_manager")
local hotkeys_popup = require("awful.hotkeys_popup")

local theme = require("ui.tools.theme_manager")

function set_wallpaper()
    gears.wallpaper.maximized(theme.wallpaper)
    collectgarbage("collect")
end


beautiful.init(theme)


local tool_box = {
    awful         = awful,
    gears         = gears,
    wibox         = wibox,
    hotkeys_popup = hotkeys_popup,
    ui            = ui,
    theme         = theme,
    utilities     = utilities,
}


require("tools.key_manager")

local testing_screen = awful.screen.focused()

local ColorButton = require("ui.modular.color_button")
local Bar = require("ui.menu_bar")
local Menu = require("ui.menu")
local Dock = require("ui.dock")
local ControlPanel = require("ui.control_panel")


ColorButton : set_tool_box(tool_box)
Bar : set_tool_box(tool_box)
Menu : set_tool_box(tool_box)
Dock : set_tool_box(tool_box)
ControlPanel : set_tool_box(tool_box)


utilities.delete_stop_flag()


local b1 = Bar.new()
local m1 = Menu.new()
local d1 = Dock.new()
local cp1 = ControlPanel.new()



local function update_theme()
    theme : toggle_theme()
    theme : update()
    beautiful.init(theme)
    
    set_wallpaper()

    b1 : toggle_theme()
    b1 : toggle_colors()

    m1 : toggle_theme()
    m1 : toggle_colors()

    d1 : toggle_theme()

    cp1 : toggle_theme()
    cp1 : toggle_colors()

    -- For some reason, tags do not update their colors
    -- In order to update them, a little move is performed as workaround for now

    -- Multple selected tags will be unselected
    awful.tag.viewprev()
    awful.tag.viewnext()
end



m1 : init_ui(testing_screen, ColorButton)
m1 : resize_ui()
m1 : toggle_theme()
m1 : toggle_colors()
m1 : update_ui()


b1 : init_ui(testing_screen, ColorButton, m1, cp1)
b1 : resize_ui()
b1 : toggle_theme()
b1 : toggle_colors()
b1 : update_ui()


d1 : init_ui(testing_screen)
d1 : resize_ui()
d1 : toggle_theme()
d1 : update_ui()


cp1 : init_ui(testing_screen, ColorButton, update_theme)
cp1 : resize_ui()
cp1 : toggle_theme()
cp1 : toggle_colors()
cp1 : update_ui()


set_wallpaper()



-- Restart awesome if display resolution is changed
function restart_wm()
    utilities.create_stop_flag()
    awesome.restart()
end
screen.connect_signal("property::geometry", restart_wm)

-- Add close, minimize and maximize buttons to each client
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

        local titlebar = awful.titlebar(
            client,
            {
                size = 30,
            }
        )

        titlebar : setup {
            layout = wibox.layout.align.horizontal,

            {
                layout = wibox.layout.fixed.horizontal,
                wibox.layout.margin(awful.titlebar.widget.closebutton(client),     8, 8, 8, 8),
                wibox.layout.margin(awful.titlebar.widget.minimizebutton(client),  0, 0, 8, 8),
                wibox.layout.margin(awful.titlebar.widget.maximizedbutton(client), 8, 8, 8, 8)
            },
            {
                layout  = wibox.layout.flex.horizontal,
                buttons = buttons
            }
        }
    end
)

-- Change client shape and prevent clients from being unreachable after screen count changes
client.connect_signal(
    "manage", 
    function(client)
        if awesome.startup and not client.size_hints.user_position and not client.size_hints.program_position then
            awful.placement.no_offscreen(client)
        end

        client.shape = ui.ROUNDED_RECT
    end
)


-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = { },
        properties = { 
            border_width = 0,
--             border_color = beautiful.border_normal,
--             focus = awful.client.focus.filter,
--             raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
--             screen = awful.screen.preferred,
--             placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",  -- Firefox addon DownThemAll.
                "copyq",  -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester",  -- xev.
            },
            role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            }
        }, 
        properties = { floating = true }
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = {
            type = {
                "normal", 
                "dialog"
            }
        }, 
        properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}



-- Unused code (WIP)


-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
-- local hotkeys_popup = require("awful.hotkeys_popup")
-- require("awful.hotkeys_popup.keys")



-- Notification library
-- local naughty = require("naughty")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
-- if awesome.startup_errors then
--     naughty.notify({ preset = naughty.config.presets.critical,
--                      title = "Oops, there were errors during startup!",
--                      text = awesome.startup_errors })
-- end

-- Handle runtime errors after startup
-- do
--     local in_error = false
--     awesome.connect_signal("debug::error", function (err)
--         -- Make sure we don't go into an endless error loop
--         if in_error then return end
--         in_error = true
-- 
--         naughty.notify({ preset = naughty.config.presets.critical,
--                          title = "Oops, an error happened!",
--                          text = tostring(err) })
--         in_error = false
--     end)
-- end

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
