---------------
-- Main menu --
---------------

local tool_box = nil

local Menu = {
    screen              = nil,
    -- Widgets
    menu                = nil,
    awesome_settings_b  = nil,
    awesome_shortcuts_b = nil,
    restart_b           = nil,
    poweroff_b          = nil,
    logout_b            = nil
}
Menu.__index = Menu


function Menu : set_tool_box(tb)
    tool_box = tb
end

function Menu : toggle_visibility()
    self.menu.visible = not self.menu.visible
end

function Menu : init_ui(screen, ColorButton)
    self.screen = screen

    self.menu = tool_box.wibox {
        shape        = tool_box.ui.ROUNDED_RECT,
        expand       = true,
        visible      = false,
        ontop        = true
    }

    button_margin = tool_box.ui.main_menu_icon_margin

    
    local awesome_settings_fun = function() self : toggle_visibility() end
    self.awesome_settings_b = ColorButton.new()
    
    self.awesome_settings_b : init_ui(true, "Awesome settings", button_margin)
    self.awesome_settings_b : assemble_button(awesome_settings_fun)
    self.awesome_settings_b : update_ui()
    

    local awesome_shortcuts_fun = function() self : toggle_visibility() tool_box.hotkeys_popup.show_help(nil, self.screen) end
    self.awesome_shortcuts_b = ColorButton.new()

    self.awesome_shortcuts_b : init_ui(true, "Awesome shortcuts", button_margin)
    self.awesome_shortcuts_b : assemble_button(awesome_shortcuts_fun)
    self.awesome_shortcuts_b : update_ui()


    local MessagePane = require("ui.modular.message_pane")
    local msg = nil

    local confirmation_fun = function(to_do, confirmation_text)
        return function()
            self : toggle_visibility()

            -- To avoid multiple messages
            -- Older are closed
            if msg ~= nil and msg.frame ~= nil then
                msg : close_pane()
            end

            if client : instances() == 0 then
                -- Do not ask if there are not clients
                to_do()
            else
                -- Ask user if they want to restart
                msg = MessagePane.new()
                msg : set_tool_box(tool_box)
                msg : init_ui(self.screen, 280, 150)
                msg : ask_confirmation(ColorButton, "Are you sure you want to continue?", confirmation_text, to_do)
            end
        end
    end

    local restart_fun = confirmation_fun(tool_box.utilities.restart, "Restart")
    self.restart_b = ColorButton.new()
    
    self.restart_b : init_ui(true, "Restart", button_margin)
    self.restart_b : assemble_button(restart_fun)
    self.restart_b : update_ui()


    local poweroff_fun = confirmation_fun(tool_box.utilities.poweroff, "Power off")
    self.poweroff_b = ColorButton.new()
    
    self.poweroff_b : init_ui(true, "Power off", button_margin)
    self.poweroff_b : assemble_button(poweroff_fun)
    self.poweroff_b : update_ui()


    local logout_fun = confirmation_fun(awesome.quit, "Log out")
    self.logout_b = ColorButton.new()
    
    self.logout_b : init_ui(true, "Log out", button_margin)
    self.logout_b : assemble_button(logout_fun)
    self.logout_b : update_ui()
end

function Menu : resize_ui()
    self.menu.x            = tool_box.ui.top_bar_position.x 
    self.menu.y            = tool_box.ui.invisible_top_bar_height
    self.menu.width        = tool_box.ui.main_menu_dimension.width
    self.menu.height       = tool_box.ui.main_menu_dimension.height

    image_dimension = tool_box.ui.main_menu_icon_dimension

    self.awesome_settings_b : resize_ui(image_dimension, image_dimension)
    self.awesome_shortcuts_b : resize_ui(image_dimension, image_dimension)
    self.restart_b : resize_ui(image_dimension, image_dimension)
    self.poweroff_b : resize_ui(image_dimension, image_dimension)
    self.logout_b : resize_ui(image_dimension, image_dimension)
end

function Menu : toggle_theme()
    self.menu.bg           = tool_box.theme.s_background_color

    self.awesome_settings_b : toggle_theme(tool_box.theme.settings_icon, tool_box.theme.d_settings_icon)
    self.awesome_shortcuts_b : toggle_theme(tool_box.theme.key_icon, tool_box.theme.d_key_icon)
    self.restart_b : toggle_theme(tool_box.theme.restart_icon, tool_box.theme.d_restart_icon)
    self.poweroff_b : toggle_theme(tool_box.theme.power_icon, tool_box.theme.d_power_icon)
    self.logout_b : toggle_theme(tool_box.theme.account_icon, tool_box.theme.d_account_icon)
end

function Menu : toggle_colors()
    self.awesome_settings_b : toggle_colors(tool_box.theme.p_background_color, tool_box.theme.s_accent_color, tool_box.theme.t_foreground_color, tool_box.theme.t_foreground_accent_color)
    self.awesome_shortcuts_b : toggle_colors(tool_box.theme.p_background_color, tool_box.theme.s_accent_color, tool_box.theme.t_foreground_color, tool_box.theme.t_foreground_accent_color)
    self.restart_b : toggle_colors(tool_box.theme.p_background_color, tool_box.theme.s_accent_color, tool_box.theme.t_foreground_color, tool_box.theme.t_foreground_accent_color)
    self.poweroff_b : toggle_colors(tool_box.theme.p_background_color, tool_box.theme.s_accent_color, tool_box.theme.t_foreground_color, tool_box.theme.t_foreground_accent_color)
    self.logout_b : toggle_colors(tool_box.theme.p_background_color, tool_box.theme.s_accent_color, tool_box.theme.t_foreground_color, tool_box.theme.t_foreground_accent_color)
end

function Menu : update_ui()
    self.menu : setup {
        layout = tool_box.wibox.layout.align.vertical,
        
        {
            layout = tool_box.wibox.layout.align.vertical,
            self.awesome_settings_b.button,
            self.awesome_shortcuts_b.button
        },
        
        {
            layout = tool_box.wibox.layout.align.vertical,
            self.restart_b.button,
            self.poweroff_b.button,
            self.logout_b.button
        },
        nil
    }

    self.menu.screen = self.screen
end

function Menu.new()
    local menu = setmetatable({}, Menu)    
    return menu
end

return Menu
