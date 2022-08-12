local icons_directory = require("awful").util.getdir("config") .. "ui/resources/"

local icons = {
   -- Top bar
   d_logo = icons_directory .. "d_logo.png",
   l_logo = icons_directory .. "l_logo.png",

   d_search = icons_directory .. "d_search.png",
   l_search = icons_directory .. "l_search.png",

   d_toggle = icons_directory .. "d_toggle.png",
   l_toggle = icons_directory .. "l_toggle.png",


   -- Main menu
   d_key = icons_directory .. "d_key.png",
   l_key = icons_directory .. "l_key.png",

   d_settings = icons_directory .. "d_settings.png",
   l_settings = icons_directory .. "l_settings.png",

   d_toggle_theme = icons_directory .. "d_toggle_theme.png",
   l_toggle_theme = icons_directory .. "l_toggle_theme.png",

   d_restart = icons_directory .. "d_restart.png",
   l_restart = icons_directory .. "l_restart.png",

   d_power = icons_directory .. "d_power.png",
   l_power = icons_directory .. "l_power.png",

   d_account = icons_directory .. "d_account.png",
   l_account = icons_directory .. "l_account.png",


   -- Control panel
   d_day = icons_directory .. "d_day.png",
   l_day = icons_directory .. "l_day.png",

   d_night = icons_directory .. "d_night.png",
   l_night = icons_directory .. "l_night.png",

   d_cpu = icons_directory .. "d_processor.png",
   -- l_cpu = icons_directory .. "l_processor.png",

   d_mem = icons_directory .. "d_memory.png",
   -- l_mem = icons_directory .. "l_.png",


   d_ = icons_directory .. "d_.png",
   l_ = icons_directory .. "l_.png",


   -- Client icons
   a_close    = icons_directory .. "a_close.png",
   a_minimize = icons_directory .. "a_minimize.png",
   a_maximize = icons_directory .. "a_maximize.png",
   i_close    = icons_directory .. "i_close.png",
   i_minimize = icons_directory .. "i_minimize.png",
   i_maximize = icons_directory .. "i_maximize.png",
}

return icons
