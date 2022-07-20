----------------------
-- Status bar (top) --
----------------------


local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local beautiful = require("beautiful")

local utilities = require("tools.utils")

local theme = require("tools.theme_manager")
local ui = require("tools.ui_manager")

local button_factory = require("ui.menu_button")

local menu = require("ui.menu")



-- launcher_button = awful.widget.launcher(
--     {
--         image = theme.main_icon,
--         menu = mymainmenu 
--     }
-- )

local launcher_button = wibox.widget {
    widget        = wibox.widget.imagebox,
    forced_width  = ui.top_bar_height,
    forced_height = ui.top_bar_height,
    resize        = true,
    image         = theme.main_icon
}

launcher_button : buttons(
    gears.table.join(
        launcher_button : buttons(),
        awful.button(
            {}, 
            1, 
            function()
                menu.show_menu()
            end
        )
    )
)

local search_button = button_factory.create_image_button(theme.search_icon, theme.d_search_icon, utilities.show_rufi)


local taglist_buttons = gears.table.join(
    awful.button(
        { }, 
        1, 
        function(t) 
            t : view_only()
        end
    ),

    awful.button(
        {
            modkey
        }, 
        1, 
        function(t)
            if client.focus then
                client.focus : move_to_tag(t)
            end
        end
    ),

    awful.button(
        { }, 
        3, 
        awful.tag.viewtoggle
    ),

    awful.button(
        {
            modkey
        }, 
        3, 
        function(t)
            if client.focus then
                client.focus : toggle_tag(t)
            end
        end
    ),

    awful.button(
        { }, 
        4, 
        function(t)
            awful.tag.viewnext(t.screen)
        end
    ),

    awful.button(
        { }, 
        5, 
        function(t)
            awful.tag.viewprev(t.screen)
        end
    )
)


local current_user = wibox.widget.textbox("<span foreground='" .. theme.t_foreground_color .. "' weight='normal'>" .. utilities.whoami .. "    </span>")
local time = wibox.widget.textclock("<span foreground='" .. theme.t_foreground_color .. "' weight='normal'> %A %b %d   %H:%M    </span>")


awful.screen.connect_for_each_screen(
    function(screen)
        ui.set_wallpaper(screen)

        awful.tag(
            {
                "  1  ",
                "  2  ",
                "  3  ",
                "  4  "
            },
            screen, 
            awful.layout.layouts[0]
        )

        -- Create a taglist widget
        screen.taglist = awful.widget.taglist {
            screen  = screen,
            filter  = awful.widget.taglist.filter.all,
            buttons = taglist_buttons
        }

        screen.invisible_bar = awful.wibar(
            {
                screen   = screen,
                position = "top",
                width    = screen.geometry.width,
                height   = ui.invisible_top_bar_height,
                bg       = theme.transparent_color
            }
        )

        screen.bar = wibox {
            screen       = screen,
            shape        = ui.ROUNDED_RECT,
            expand       = true,
            visible      = true,
            x            = ui.top_bar_position.x,
            y            = ui.top_bar_position.y,
            width        = (screen.geometry.width - ui.top_bar_spacing),
            height       = ui.top_bar_height,
            bg           = theme.p_background_color,
            border_width = ui.top_bar_border,
            border_color = theme.t_foreground_color
        }
        
        screen.bar : setup {
            layout = wibox.layout.align.horizontal,
            
            {
                layout = wibox.layout.fixed.horizontal,
                launcher_button,
                search_button,
                screen.taglist,
            },
            
            nil,
            
            {
                layout = wibox.layout.fixed.horizontal,
                current_user,
                time
            }
        }
    end
)
