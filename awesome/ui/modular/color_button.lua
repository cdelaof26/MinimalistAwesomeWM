---------------------------------
-- Utility for button creation --
---------------------------------

local tool_box = nil

local ColorButton = {
    -- Widgets
    button      = nil,
    button_icon = nil,
    button_text = nil,
    -- Widgets properties
    button_function  = nil,
    image            = nil,
    hover_image      = nil,
    background       = nil, 
    hover_background = nil, 
    foreground       = nil, 
    hover_foreground = nil
}
ColorButton.__index = ColorButton


function ColorButton : set_tool_box(tb)
    tool_box = tb
end

function ColorButton : init_ui(contains_image, text, button_margin)
    if contains_image then
        self : init_icon_widget(button_margin)
    end

    if text ~= nil then
        self : init_text_widget(text, button_margin)
    end
end

function ColorButton : init_icon_widget(button_margin)
    self.button_icon = tool_box.wibox.widget {
        layout = tool_box.wibox.container.margin(self.button_icon, button_margin, button_margin, button_margin, button_margin),
        {
            widget = tool_box.wibox.widget.imagebox,
            resize = true
        }
    }
end

function ColorButton : init_text_widget(text, button_margin)
    local left_margin = 0
    if self.button_icon == nil then
        left_margin = button_margin
    end

    self.button_text = tool_box.wibox.widget {
        layout = tool_box.wibox.container.margin(self.button_text, left_margin, button_margin, button_margin, button_margin),
        {
            widget = tool_box.wibox.widget.textbox,
            text   = text
        }
    }

    if self.button_icon == nil then
        self.button_text.widget.align = "center"
    end
end

function ColorButton : resize_ui(image_width, image_height, width, height)
    if image_width ~= nil and image_height ~= nil then
        self.button_icon.widget.forced_width  = image_width
        self.button_icon.widget.forced_height = image_height
    end
    
    if width ~= nil and height ~= nil then
        self.button.forced_width  = width
        self.button.forced_height = height
    end
end

function ColorButton : toggle_theme(image, hover_image)
    self.image       = image
    self.hover_image = hover_image

    self.button_icon.widget.image = image
end

function ColorButton : toggle_colors(background, hover_background, foreground, hover_foreground)
    hover_background = hover_background or background
    hover_foreground = hover_foreground or foreground

    self.background       = background
    self.hover_background = hover_background
    self.foreground       = foreground
    self.hover_foreground = hover_foreground
    
    self.button.bg        = self.background
    self.button.fg        = self.foreground
end

function ColorButton : assemble_button(button_function)
    self.button_function = button_function

    self.button = tool_box.wibox.widget {
        {
            self.button_icon,
            self.button_text,
            nil,
            layout = tool_box.wibox.layout.align.horizontal,
        },
        widget = tool_box.wibox.container.background
    }
end

function ColorButton : round_corners()
    self.button.shape = tool_box.ui.new_button_shape
end

function ColorButton : update_ui()
    self.button : connect_signal(
        "mouse::enter", 
        function()
            if self.button_icon ~= nil then
                self.button_icon.widget.image = self.hover_image
            end
            self.button : set_bg(self.hover_background)
            self.button : set_fg(self.hover_foreground)
        end
    )
    
    self.button : connect_signal(
        "mouse::leave", 
        function()
            if self.button_icon ~= nil then
                self.button_icon.widget.image = self.image
            end
            self.button : set_bg(self.background)
            self.button : set_fg(self.foreground)
        end
    )

    self.button : connect_signal(
        "button::press", 
        function()
            self.button : set_bg(self.hover_background)
            self.button : set_fg(self.hover_foreground)
            
            self.button_function()
        end
    )

    self.button : connect_signal(
        "button::release",
        function()
            self.button : set_bg(self.background)
            self.button : set_fg(self.foreground)
        end
    )
end

function ColorButton.new()
    local color_button = setmetatable({}, ColorButton)
    return color_button
end

return ColorButton
