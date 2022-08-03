-------------------------
-- Theme configuration --
-------------------------

local icons = require("ui.resources")

local theme = {}

theme.font = "Liberation Sans 8"

local config_dir = require("awful").util.getdir("config")

-- GUI position
-- GUI Size
-- Fonts
-- Theme
-- Accent

theme.toggle_theme = function()
    local call = io.popen("ls " .. config_dir)
    output = call : read("*a")
    call : close()

    if string.find(("" .. output), "use_dark") then
        -- If file exists, delete it to apply light theme
        call = io.popen("rm " .. config_dir .. "/use_dark")
    else
        -- If file doesn't exists, create to apply dark theme
        call = io.popen("touch " .. config_dir .. "/use_dark")
    end
    
    call : close()

    --awesome.restart()
end


-- Various colors
theme.RED   = "#FF0000"
theme.WHITE = "#FFFFFF"


theme.update = function()
    local file = io.open(config_dir .. "/use_dark", "r")
    if file ~= nil then
        io.close(file)
        -- If exists use dark palette
        theme.main_icon   = icons.d_logo
        theme.search_icon = icons.d_search

        theme.key_icon          = icons.d_key
        theme.settings_icon     = icons.d_settings
        theme.toggle_theme_icon = icons.d_toggle_theme
        theme.restart_icon      = icons.d_restart
        theme.power_icon        = icons.d_power
        theme.account_icon      = icons.d_account

        theme.p_background_color = "#000000"
        theme.s_background_color = "#1E1E1E"
        theme.t_foreground_color = "#FFFFFF"

        theme.wallpaper   = config_dir .. "/wallpaper/Dark.jpg"

        theme.p_accent_color = "#513DC0"
        theme.s_accent_color = "#6F5BDF"

        -- local call = io.popen("xfconf-query -c xsettings -p /Net/ThemeName -s 'Adwaita-dark'")
        -- call : close()
    else
        -- If doesn't exists use light palette
        theme.main_icon   = icons.l_logo
        theme.search_icon = icons.l_search

        theme.key_icon          = icons.l_key
        theme.settings_icon     = icons.l_settings
        theme.toggle_theme_icon = icons.l_toggle_theme
        theme.restart_icon      = icons.l_restart
        theme.power_icon        = icons.l_power
        theme.account_icon      = icons.l_account

        theme.p_background_color = "#FFFFFF"
        theme.s_background_color = "#F5F5F5"
        theme.t_foreground_color = "#000000"

        theme.wallpaper   = config_dir .. "/wallpaper/Light.jpg"

        theme.p_accent_color = "#DE1B58"
        theme.s_accent_color = "#F22F6C"

        -- local call = io.popen("xfconf-query -c xsettings -p /Net/ThemeName -s 'Adwaita'")
        -- call : close()
        -- Maybe lxappearance is a easier way to change this
    end


    theme.d_search_icon = icons.d_search

    theme.d_key_icon          = icons.d_key
    theme.d_settings_icon     = icons.d_settings
    theme.d_toggle_theme_icon = icons.d_toggle_theme
    theme.d_restart_icon      = icons.d_restart
    theme.d_power_icon        = icons.d_power
    theme.d_account_icon      = icons.d_account



    theme.t_foreground_accent_color = "#FFFFFF"

    theme.warning_color = "#FF0000"

    theme.transparent_color = "55"



    theme.bg_normal = theme.s_background_color
    theme.bg_focus  = theme.p_background_color

    theme.tasklist_bg_normal = theme.p_background_color
    theme.tasklist_bg_focus = theme.s_accent_color


    theme.taglist_bg_normal = theme.s_background_color
    theme.taglist_bg_empty  = theme.s_background_color
    theme.taglist_bg_focus  = theme.s_accent_color

    theme.taglist_bg_occupied = theme.p_accent_color
    theme.taglist_fg_occupied = theme.t_foreground_accent_color

    theme.taglist_fg_normal   = theme.t_foreground_color
    theme.taglist_fg_focus    = theme.t_foreground_accent_color
    theme.taglist_fg_urgent   = theme.t_foreground_color
    theme.taglist_fg_empty    = theme.t_foreground_color
    theme.taglist_fg_volatile = theme.t_foreground_color


    -- Title client icons

    theme.titlebar_maximized_button_normal_inactive = icons.i_maximize
    theme.titlebar_maximized_button_focus_inactive  = icons.a_maximize
    theme.titlebar_maximized_button_normal_active   = icons.i_maximize
    theme.titlebar_maximized_button_focus_active    = icons.a_maximize

    theme.titlebar_minimize_button_normal           = icons.i_minimize
    theme.titlebar_minimize_button_focus            = icons.a_minimize

    theme.titlebar_close_button_normal              = icons.i_close
    theme.titlebar_close_button_focus               = icons.a_close



    -- Define the icon theme for application icons. If not set then the icons
    -- from /usr/share/icons and /usr/share/icons/hicolor will be used.
    theme.icon_theme = nil



    theme.border_width = 0
end

theme : update()

return theme
