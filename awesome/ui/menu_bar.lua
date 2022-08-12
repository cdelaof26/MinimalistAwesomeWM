--------------------
-- Menu bar (top) --
--------------------

local tool_box = nil

local Bar = {
    screen          = nil,
    -- Widgets
    bar                  = nil,
    taglist              = nil,
    invisible_bar        = nil,
    launcher_button      = nil,
    search_button        = nil,
    taglist_buttons      = nil,
    control_panel_button = nil,
    current_user         = nil,
    current_time         = nil
}
Bar.__index = Bar

function Bar : set_tool_box(tb)
    tool_box = tb
end

function Bar : init_ui(screen, ColorButton, menu, control_panel)
    self.screen = screen

    self.invisible_bar = tool_box.awful.wibar(
        {
            position = "top",
            height   = tool_box.ui.invisible_top_bar_height,
            bg       = tool_box.theme.transparent_color
        }
    )

    self.bar = tool_box.wibox {
        shape        = tool_box.ui.ROUNDED_RECT,
        expand       = true,
        visible      = true
    }


    local show_menu = function()
        menu : toggle_visibility()
    end

    self.launcher_button = ColorButton.new()
    self.launcher_button : init_ui(true, nil, 0)
    self.launcher_button : assemble_button(show_menu)
    self.launcher_button : update_ui()


    self.search_button = ColorButton.new()
    self.search_button : init_ui(true, nil, tool_box.ui.search_icon_margin)
    self.search_button : assemble_button(tool_box.utilities.show_rufi)
    self.search_button : update_ui()


    self.taglist_buttons = tool_box.gears.table.join(
        tool_box.awful.button(
            { }, 
            1, 
            function(tag) 
                tag : view_only()
            end
        ),

        tool_box.awful.button(
            {
                modkey
            }, 
            1, 
            function(tag)
                if client.focus then
                    client.focus : move_to_tag(tag)
                end
            end
        ),

        tool_box.awful.button(
            { }, 
            3, 
            tool_box.awful.tag.viewtoggle
        ),

        tool_box.awful.button(
            {
                modkey
            }, 
            3, 
            function(tag)
                if client.focus then
                    client.focus : toggle_tag(tag)
                end
            end
        ),

        tool_box.awful.button(
            { }, 
            4, 
            function(tag)
                tool_box.awful.tag.viewnext(tag.screen)
            end
        ),

        tool_box.awful.button(
            { }, 
            5, 
            function(tag)
                tool_box.awful.tag.viewprev(tag.screen)
            end
        )
    )

    tool_box.awful.tag(
        {
            "  1  ",
            "  2  ",
            "  3  ",
            "  4  "
        },
        self.screen, 
        tool_box.awful.layout.layouts[0]
    )

    self.taglist = tool_box.awful.widget.taglist {
        screen  = self.screen,
        filter  = tool_box.awful.widget.taglist.filter.all,
        buttons = self.taglist_buttons
    }


    local show_control_panel = function()
        control_panel : toggle_visibility()
    end

    self.control_panel_button = ColorButton.new()
    self.control_panel_button : init_ui(true, nil, 8)
    self.control_panel_button : assemble_button(show_control_panel)
    self.control_panel_button : update_ui()

    self.current_user = tool_box.wibox.widget {
        {
            {
                widget = tool_box.wibox.widget.textbox,
                text   = tool_box.utilities.whoami
            },
            layout = tool_box.wibox.container.margin(self.current_user, tool_box.ui.right_bar_widgets_margin, tool_box.ui.right_bar_widgets_margin, 0, 0)
        },
        widget = tool_box.wibox.container.background
    }

    self.current_time = tool_box.wibox.widget {
        {
            {
                widget = tool_box.wibox.widget.textclock,
                format = "%A %b %d   %H:%M"
            },
            layout = tool_box.wibox.container.margin(self.current_time, tool_box.ui.right_bar_widgets_margin, tool_box.ui.right_bar_widgets_margin, 0, 0)
        },
        widget = tool_box.wibox.container.background
    }
end

function Bar : resize_ui()
    self.launcher_button : resize_ui(tool_box.ui.top_bar_height, tool_box.ui.top_bar_height)
    self.search_button : resize_ui(tool_box.ui.search_icon_dimension, tool_box.ui.search_icon_dimension)
    self.control_panel_button : resize_ui(25, 25)

    self.invisible_bar.height = tool_box.ui.invisible_top_bar_height

    self.bar.x      = tool_box.ui.top_bar_position.x
    self.bar.y      = tool_box.ui.top_bar_position.y
    self.bar.width  = (self.screen.geometry.width - tool_box.ui.top_bar_spacing)
    self.bar.height = tool_box.ui.top_bar_height
end

function Bar : toggle_theme()
    self.launcher_button : toggle_theme(tool_box.theme.main_icon, tool_box.theme.main_icon)

    self.search_button : toggle_theme(tool_box.theme.search_icon, tool_box.theme.d_search_icon)

    self.bar.bg = tool_box.theme.s_background_color

    self.control_panel_button : toggle_theme(tool_box.theme.control_panel_icon, tool_box.theme.control_panel_icon)
end

function Bar : toggle_colors()
    self.search_button : toggle_colors(tool_box.theme.transparent_color, tool_box.theme.s_accent_color, tool_box.theme.t_foreground_color, tool_box.theme.t_foreground_accent_color)

    self.current_user.bg = tool_box.theme.p_accent_color
    self.current_user.fg = tool_box.theme.t_foreground_accent_color
    self.current_time.fg = tool_box.theme.t_foreground_color
end

function Bar : update_ui()
    self.bar : setup {
        layout = tool_box.wibox.layout.align.horizontal,
        
        {
            layout = tool_box.wibox.layout.fixed.horizontal,
            self.launcher_button.button,
            self.search_button.button,
            self.taglist
        },
        
        nil,
        
        {
            layout = tool_box.wibox.layout.fixed.horizontal,
            self.control_panel_button.button,
            self.current_user,
            self.current_time
        }
    }

    self.bar.screen     = self.screen
    self.taglist.screen = self.screen

    self.invisible_bar.screen = self.screen
    self.invisible_bar.width  = self.screen.geometry.width
end

function Bar.new()
    local bar = setmetatable({}, Bar)
    return bar
end

return Bar
