-------------------
-- Dock (bottom) --
-------------------


local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local beautiful = require("beautiful")

local theme = require("tools.theme_manager")
local ui = require("tools.ui_manager")


local tasklist_buttons = gears.table.join(
    awful.button(
        { },
        1,
        function (client)
            if client == client.focus then
                client.minimized = true
            else
                client : emit_signal(
                    "request::activate",
                    "tasklist",
                    { raise = true }
                )
            end
        end
    ),

    awful.button(
        { }, 
        3, 
        function()
            awful.menu.client_list(
                {
                    theme = {
                        width = 250 
                    } 
                }
            )
        end
    ),

    awful.button(
        { }, 
        4, 
        function()
            awful.client.focus.byidx(1)
        end
    ),

    awful.button(
        { }, 
        5, 
        function()
            awful.client.focus.byidx(-1)
        end
    )
)


awful.screen.connect_for_each_screen(
    function(screen)
        -- Original from https://awesomewm.org/doc/api/classes/awful.widget.tasklist.html#beautiful.tasklist_plain_task_name
        screen.tasklist = awful.widget.tasklist {
            screen   = screen,
            filter   = awful.widget.tasklist.filter.currenttags,
            buttons  = tasklist_buttons,
            layout   = { layout  = wibox.layout.fixed.horizontal },
            widget_template = {
                nil,
                {
                    {
                        id     = 'clienticon',
                        widget = awful.widget.clienticon,
                    },
                    left   = 5,
                    right  = 0,
                    top    = 5,
                    bottom = 5,
                    widget = wibox.container.margin
                },
                {
                    {
                        wibox.widget.base.make_widget(),
                        forced_height = 5,
                        id            = 'background_role',
                        widget        = wibox.container.background
                    },
                    left   = 15,
                    right  = 15,
                    widget = wibox.container.margin
                },
                create_callback = function(self, client, index, objects)
                    self : get_children_by_id("clienticon")[1].client = client
                end,
                layout = wibox.layout.align.vertical,
            },
        }

        screen.invisible_bar = awful.wibar(
            {
                screen   = screen,
                position = "bottom",
                width    = screen.geometry.width,
                height   = ui.dock_dimension.height + (ui.DEFAULT_BORDER_WIDTH * 3),
                bg       = theme.transparent_color
            }
        )

        screen.dock = wibox {
            screen  = screen,
            shape   = ui.ROUNDED_RECT,
            expand  = true,
            visible = true,
            y       = (screen.geometry.height - (ui.dock_dimension.height + (ui.DEFAULT_BORDER_WIDTH * 2))) - 10,
            x       = (screen.geometry.width / 2) - (ui.dock_dimension.width / 2),
            width   = ui.dock_dimension.width,
            height  = ui.dock_dimension.height + (ui.DEFAULT_BORDER_WIDTH * 1.5),
            bg      = theme.p_background_color
        }

        screen.dock : setup {
            expand = "none",
            layout = wibox.layout.align.horizontal,
            {
                layout = wibox.layout.fixed.horizontal
            },

            screen.tasklist,
            
            {
                layout = wibox.layout.fixed.horizontal
            }
        }
    end
)

do_shrink_dock = true

-- Expand dock if new client
client.connect_signal(
    "manage", 
    function(client)
        local new_dock_width = awful.screen.focused().dock.width + ui.dock_width_multiplier
        local screen_width   = awful.screen.focused().geometry.width

        if screen_width > new_dock_width then
            -- Screen can fit more dock
            awful.screen.focused().dock.width = new_dock_width
            awful.screen.focused().dock.x = (screen_width / 2) - (new_dock_width / 2)

        else
            -- Screen cannot fit more dock
            ui.show_notification("Oops", "Dock is full, close a client before invoke another one")
            
            -- Avoid shrink dock if a client is killed
            do_shrink_dock = false

            -- Since dock can 'crash' (unresponsive wibar) by overflow
            -- This function will kill any new client
            client : kill()
        end
    end
)

-- Shrink dock if client disconnects
client.connect_signal(
    "unmanage", 
    function(client)
        local new_dock_width = awful.screen.focused().dock.width - ui.dock_width_multiplier

        if new_dock_width > ui.dock_dimension.width and do_shrink_dock then
            -- Shrink dock
           awful.screen.focused().dock.width = new_dock_width
           awful.screen.focused().dock.x = (awful.screen.focused().geometry.width / 2) - (new_dock_width / 2)

        else
            do_shrink_dock = true
        end
    end
)
