local wibox = require("wibox")

local ui = require("tools.ui_manager")
local theme = require("tools.theme_manager")

return { 
    create_button = function(image, hover_image, text, button_function)
        local button_icon = wibox.widget {
            layout = wibox.container.margin(self, ui.main_menu_icon_margin, ui.main_menu_icon_margin, ui.main_menu_icon_margin, ui.main_menu_icon_margin),
            {
                widget        = wibox.widget.imagebox,
                forced_width  = ui.main_menu_icon_dimension,
                forced_height = ui.main_menu_icon_dimension,
                resize        = true,
                image         = image
            }
        }

        local button_text = wibox.widget {
            layout = wibox.container.margin(self, 0, ui.main_menu_icon_margin, ui.main_menu_icon_margin, ui.main_menu_icon_margin),
            {
                widget = wibox.widget.textbox,
                text   = text
            }
        }

        local button = wibox.widget {
            {
                button_icon,
                button_text,
                nil,
                layout = wibox.layout.align.horizontal,
            },
            widget = wibox.container.background,
            fg     = theme.t_foreground_color
        }
        
        button : connect_signal(
            "button::press", 
            function(button)
                button : set_bg(theme.p_accent_color)
                button : set_fg(theme.t_foreground_accent_color)
                button_function()
            end
        )

        button : connect_signal(
            "button::release",
            function(button)
                button : set_bg(theme.transparent_color)
                button : set_fg(theme.t_foreground_color)
            end
        )
        
        button : connect_signal(
            "mouse::enter", 
            function(button)
                button_icon.widget.image = hover_image
                button : set_bg(theme.s_accent_color)
                button : set_fg(theme.t_foreground_accent_color)
            end
        )
        
        button : connect_signal(
            "mouse::leave", 
            function(button)
                button_icon.widget.image = image
                button : set_bg(theme.transparent_color)
                button : set_fg(theme.t_foreground_color)
            end
        )

        return button
    end,

    create_image_button = function(image, hover_image, button_function)
        local button_icon = wibox.widget {
            layout = wibox.container.margin(self, ui.main_menu_icon_margin, ui.main_menu_icon_margin, ui.main_menu_icon_margin, ui.main_menu_icon_margin),
            {
                widget        = wibox.widget.imagebox,
                forced_width  = ui.main_menu_icon_dimension,
                forced_height = ui.main_menu_icon_dimension,
                resize        = true,
                image         = image
            }
        }

        local button = wibox.widget {
            {
                nil,
                button_icon,
                nil,
                layout = wibox.layout.align.horizontal,
            },
            widget = wibox.container.background,
            fg     = theme.t_foreground_color
        }
        
        button : connect_signal(
            "button::press", 
            function(button)
                button : set_bg(theme.p_accent_color)
                button_function()
            end
        )

        button : connect_signal(
            "button::release",
            function(button)
                button_icon.widget.image = image
                button : set_bg(theme.transparent_color)
            end
        )
        
        button : connect_signal(
            "mouse::enter", 
            function(button)
                button_icon.widget.image = hover_image
                button : set_bg(theme.s_accent_color)
            end
        )
        
        button : connect_signal(
            "mouse::leave", 
            function(button)
                button_icon.widget.image = image
                button : set_bg(theme.transparent_color)
            end
        )

        return button
    end
}
