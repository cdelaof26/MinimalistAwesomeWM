-------------------
-- Dock (bottom) --
-------------------

local tool_box = nil

local Dock = {
    screen           = nil,
    -- Widgets
    tasklist_buttons = nil,
    tasklist         = nil,
    invisible_bar    = nil,
    dock             = nil,
    -- Other
    do_shrink_dock = true
}
Dock.__index = Dock


function Dock : set_tool_box(tb)
    tool_box = tb
end

function Dock : init_ui(screen)
    self.screen = screen

    self.invisible_bar = tool_box.awful.wibar(
        {
            position = "bottom",
            height   = tool_box.ui.invisible_dock_bar_height,
            bg       = tool_box.theme.transparent_color
        }
    )

    self.dock = tool_box.wibox {
        shape   = tool_box.ui.ROUNDED_RECT,
        expand  = true,
        visible = true
    }

    -- Expand dock if new client
    client.connect_signal(
        "manage", 
        function(client)
            local new_dock_width = self.dock.width + tool_box.ui.dock_width_multiplier
            local screen_width   = self.screen.geometry.width

            if screen_width > new_dock_width then
                -- Screen can fit more dock
                self.dock.width = new_dock_width
                self.dock.x     = (screen_width / 2) - (new_dock_width / 2)
            else
                -- Screen cannot fit more dock
                --ui.show_notification("Oops", "Dock is full, close a client before invoke another one")
                
                -- Avoid shrink dock if a client is killed
                self.do_shrink_dock = false

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
            local new_dock_width = self.dock.width - tool_box.ui.dock_width_multiplier

            if new_dock_width > tool_box.ui.dock_dimension.width and self.do_shrink_dock then
                -- Shrink dock
               self.dock.width = new_dock_width
               self.dock.x     = (self.screen.geometry.width / 2) - (new_dock_width / 2)

            else
                self.do_shrink_dock = true
            end
        end
    )

    self.tasklist_buttons = tool_box.gears.table.join(
        tool_box.awful.button(
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

        tool_box.awful.button(
            { }, 
            3, 
            function()
                tool_box.awful.menu.client_list(
                    {
                        theme = {
                            width = 250 
                        } 
                    }
                )
            end
        ),

        tool_box.awful.button(
            { }, 
            4, 
            function()
                tool_box.awful.client.focus.byidx(1)
            end
        ),

        tool_box.awful.button(
            { }, 
            5, 
            function()
                tool_box.awful.client.focus.byidx(-1)
            end
        )
    )

    -- Original from https://awesomewm.org/doc/api/classes/awful.widget.tasklist.html#beautiful.tasklist_plain_task_name
    self.tasklist = tool_box.awful.widget.tasklist {
        screen   = self.screen,
        filter   = tool_box.awful.widget.tasklist.filter.currenttags,
        buttons  = self.tasklist_buttons,
        layout   = { layout  = tool_box.wibox.layout.fixed.horizontal },
        widget_template = {
            nil,
            {
                {
                    id     = 'clienticon',
                    widget = tool_box.awful.widget.clienticon,
                },
                left   = 5,
                right  = 0,
                top    = 5,
                bottom = 5,
                widget = tool_box.wibox.container.margin
            },
            {
                {
                    tool_box.wibox.widget.base.make_widget(),
                    forced_height = 5,
                    id            = 'background_role',
                    widget        = tool_box.wibox.container.background
                },
                left   = 15,
                right  = 15,
                widget = tool_box.wibox.container.margin
            },
            create_callback = function(self, client, index, objects)
                self : get_children_by_id("clienticon")[1].client = client
            end,
            layout = tool_box.wibox.layout.align.vertical,
        },
    }
end

function Dock : resize_ui()
    self.invisible_bar.height = tool_box.ui.invisible_dock_bar_height

    self.dock.y            = (self.screen.geometry.height - (tool_box.ui.dock_dimension.height + tool_box.ui.dock_total_border)) - tool_box.ui.dock_separation
    self.dock.x            = (self.screen.geometry.width / 2) - (tool_box.ui.dock_dimension.width / 2)
    self.dock.width        = tool_box.ui.dock_dimension.width
    self.dock.height       = tool_box.ui.dock_dimension.height
    self.dock.border_width = tool_box.ui.dock_border_width
end

function Dock : toggle_theme()
    self.dock.border_color = tool_box.theme.p_background_color
    self.dock.bg           = tool_box.theme.p_background_color
end

function Dock : update_ui()
    self.dock : setup {
        expand = "none",
        layout = tool_box.wibox.layout.align.horizontal,
        {
            layout = tool_box.wibox.layout.fixed.horizontal
        },

        self.tasklist,
        
        {
            layout = tool_box.wibox.layout.fixed.horizontal
        }
    }

    self.dock.screen = self.screen

    self.invisible_bar.screen = self.screen
    self.invisible_bar.width  = self.screen.geometry.width
end

function Dock.new()
    local dock = setmetatable({}, Dock)
    return dock
end

return Dock
