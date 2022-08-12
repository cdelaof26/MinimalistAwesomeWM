-----------------------------------------
-- Quick settings menu (control panel) --
-----------------------------------------

local tool_box = nil

local ControlPanel = {
	-- Widgets
	panel             = nil,
	uptime_label      = nil,
	light_mode_button = nil,
	dark_mode_button  = nil,
	theme_schedule    = nil,
	timer             = nil, -- Timer is a widget, but it is not placed
	cpu_usage_graph   = nil,
	cpu_usage_icon    = nil,
	cpu_usage_label   = nil,
	mem_usage_graph   = nil,
	mem_usage_icon    = nil,
	mem_usage_label   = nil
}
ControlPanel.__index = ControlPanel

function ControlPanel : set_tool_box(tb)
    tool_box = tb
end

function ControlPanel : toggle_visibility()
    self.panel.visible = not self.panel.visible
    
    if (self.panel.width + mouse.current_widget_geometry.x) <= (self.screen.geometry.width - (tool_box.ui.top_bar_spacing / 2)) then
        self.panel.x = mouse.current_widget_geometry.x
    end
end

function ControlPanel : init_ui(screen, ColorButton, update_theme)
	self.screen = screen

    self.panel = tool_box.wibox {
        shape   = tool_box.ui.ROUNDED_RECT,
        expand  = true,
        visible = false,
        ontop   = true
    }

    self.uptime_label = tool_box.wibox.widget {
    	{
    		tool_box.awful.widget.watch(
		    	"uptime --pretty",
		    	60,
		    	function(widget, stdout)
		    		stdout = string.gsub(stdout, "up", "Up")
					widget : set_text(stdout)
				end,
				tool_box.wibox.widget {
					align  = "center",
				    valign = "center",
				    -- Somehow it refuses to align itself to the center if 
				    -- forced_width is default or under 100
				    -- This is a little workaround
				    forced_width = 1000,
				    widget = tool_box.wibox.widget.textbox
				}
			),
			layout = tool_box.wibox.layout.align.horizontal
		},
    	widget = tool_box.wibox.container.background
	}


	local use_light_mode = function()
		if tool_box.theme.dark_mode_active then
			update_theme()
		end
	end

	local use_dark_mode = function()
		if not tool_box.theme.dark_mode_active then
			update_theme()
		end
	end


    self.light_mode_button = ColorButton.new()
    self.light_mode_button : init_ui(true, nil, 10)
    self.light_mode_button : assemble_button(use_light_mode)
    self.light_mode_button : update_ui()
	self.light_mode_button : round_corners()

    self.dark_mode_button = ColorButton.new()
    self.dark_mode_button : init_ui(true, nil, 10)
    self.dark_mode_button : assemble_button(use_dark_mode)
    self.dark_mode_button : update_ui()
	self.dark_mode_button : round_corners()

	self.theme_schedule = tool_box.wibox.widget {
        {
            widget = tool_box.wibox.widget.textbox,
		},
        widget = tool_box.wibox.container.background
    }

    self.timer = tool_box.awful.widget.watch(
		"date +\"%H:%M\"",
    	15,
    	function(widget, stdout)
    		stdout = string.gsub(tostring(stdout), "\n", "")
    		
    		if stdout == tool_box.theme.change_to_dark_at then
    			use_dark_mode()
    		end
    		if stdout == tool_box.theme.change_to_light_at then
    			use_light_mode()
    		end
		end,
		nil
	)


    self.cpu_usage_graph = tool_box.wibox.widget {
	    {
	        max_value = 100,
	        value     = 0,
	        widget    = tool_box.wibox.widget.progressbar
	    },
	    direction = "east",
	    layout    = tool_box.wibox.container.rotate
	}
	self.cpu_usage_graph.widget.shape = tool_box.ui.new_button_shape

	self.cpu_usage_icon = ColorButton.new()
    self.cpu_usage_icon : init_ui(true, nil, 10)
    self.cpu_usage_icon : assemble_button(nil)
    self.cpu_usage_icon : update_ui()


    local previous_total = 0
	local previous_idle  = 0
    
    self.cpu_usage_label = tool_box.wibox.widget {
    	{
    		tool_box.awful.widget.watch(
	    		-- Original from https://github.com/pcolby/scripts/blob/master/cpu.sh

	    		-- Get the total CPU statistics, discarding the 'cpu ' prefix.
		    	"sed -n 's/^cpu\\s//p' /proc/stat",
		    	1,
		    	function(widget, stdout)
		    		if self.panel.visible then
			    		local tmp_cpu = string.gmatch(tostring(stdout), "%d+")
			    		
			    		local total = 0

			    		local idle = 0
			    		local i = 1
			    		for value in tmp_cpu do
			    			if i == 4 then
			    				idle = value
			    			end
	    					
	    					total = total + value

	    					i = i + 1
						end

			    		-- Calculate the CPU usage since we last checked.
			    		local difference_idle  = idle - previous_idle
	  					local difference_total = total - previous_total
	  					local difference_usage = ((1000 * (difference_total - difference_idle)) / (difference_total + 5)) / 10 

	  					-- Remember the total and idle CPU times for the next check.
	  					previous_total = total
	  					previous_idle  = idle

	  					self.cpu_usage_graph.widget.value = difference_usage
	  					widget : set_text(string.format("%.2f", tostring(difference_usage)) .. "%")
	  				end
				end,
				tool_box.wibox.widget {
					align  = "center",
				    valign = "center",
				    forced_width = 1000,
				    widget = tool_box.wibox.widget.textbox
				}
			),
			layout = tool_box.wibox.layout.align.horizontal
    	},
    	widget = tool_box.wibox.container.background
	}


	self.mem_usage_graph = tool_box.wibox.widget {
	    {
	        max_value = tonumber(tool_box.utilities.sys_memory.memory),
	        value     = 0,
	        widget    = tool_box.wibox.widget.progressbar
	    },
	    direction = "east",
	    layout    = tool_box.wibox.container.rotate
	}
	self.mem_usage_graph.widget.shape = tool_box.ui.new_button_shape


	self.mem_usage_label = tool_box.wibox.widget {
    	{
    		tool_box.awful.widget.watch(
		    	"grep MemAvailable /proc/meminfo",
		    	1,
		    	function(widget, stdout)
		    		if self.panel.visible then
			    		local used_memory_in_kB = tool_box.utilities.system_memory - tonumber(string.match(stdout, "%d+"))
			    		
			    		local used_memory = tool_box.utilities.convert_units(used_memory_in_kB)

			    		self.mem_usage_graph.widget.value = tool_box.utilities.convert_units_sys(used_memory_in_kB)

			    		widget : set_text(used_memory.memory .. used_memory.prefix)
			    	end
				end,
				tool_box.wibox.widget {
					align  = "center",
				    valign = "center",
				    forced_width = 1000,
				    widget = tool_box.wibox.widget.textbox
				}
			),
			layout = tool_box.wibox.layout.align.horizontal
    	},
    	widget = tool_box.wibox.container.background
	}

	self.mem_usage_icon = ColorButton.new()
    self.mem_usage_icon : init_ui(true, nil, 10)
    self.mem_usage_icon : assemble_button(nil)
    self.mem_usage_icon : update_ui()
end

function ControlPanel : resize_ui()
	self.panel.width = 275
	self.panel.height = 120

	self.panel.x = self.screen.geometry.width - (tool_box.ui.top_bar_spacing / 2) - self.panel.width
	self.panel.y = tool_box.ui.invisible_top_bar_height

    self.uptime_label.forced_width  = self.panel.width - 30
	self.uptime_label.forced_height = 20

	self.uptime_label.point = {
		x = 10, 
		y = 10
	}

	self.light_mode_button : resize_ui(30, 30, 50, 50)
	self.light_mode_button.button.point = {
    	x = 15,
    	y = 30
    }

	self.dark_mode_button : resize_ui(30, 30, 50, 50)
    self.dark_mode_button.button.point = {
    	x = 80,
    	y = 30
    }

    self.theme_schedule.point = {
    	x = self.light_mode_button.button.point.x, 
		y = (self.light_mode_button.button.point.y + self.light_mode_button.button.forced_width) + 10
    }



    local cpu_usage_point = {
    	x = 145,
    	y = 30
    }

	self.cpu_usage_graph.forced_width  = 50
	self.cpu_usage_graph.forced_height = 50
	self.cpu_usage_graph.point = cpu_usage_point

	self.cpu_usage_icon : resize_ui(30, 30, 50, 50)
	self.cpu_usage_icon.button.point = cpu_usage_point

	self.cpu_usage_label.forced_width = 60
    self.cpu_usage_label.point = {
		x = (self.cpu_usage_icon.button.point.x - 5), 
		y = (self.cpu_usage_icon.button.point.y + self.cpu_usage_icon.button.forced_width) + 10
	}


	local mem_usage_point = {
    	x = 210,
    	y = 30
    }

	self.mem_usage_graph.forced_width  = 50
	self.mem_usage_graph.forced_height = 50
	self.mem_usage_graph.point = mem_usage_point

	self.mem_usage_icon : resize_ui(30, 30, 50, 50)
	self.mem_usage_icon.button.point = mem_usage_point

	self.mem_usage_label.forced_width = 70
	self.mem_usage_label.point = {
		x = (self.mem_usage_icon.button.point.x - 10), 
		y = (self.mem_usage_icon.button.point.y + self.mem_usage_icon.button.forced_width) + 10
	}
end

function ControlPanel : toggle_theme()
	self.panel.bg = tool_box.theme.s_background_color

	self.uptime_label.fg    = tool_box.theme.t_foreground_color
	self.cpu_usage_label.fg = tool_box.theme.t_foreground_color
	self.mem_usage_label.fg = tool_box.theme.t_foreground_color
	self.theme_schedule.fg  = tool_box.theme.t_foreground_color

	if tool_box.theme.dark_mode_active then
		self.light_mode_button : toggle_theme(tool_box.theme.day_icon, tool_box.theme.d_day_icon)
	else
		self.light_mode_button : toggle_theme(tool_box.theme.d_day_icon, tool_box.theme.d_day_icon)
    end

    if tool_box.theme.dark_mode_active then
		self.dark_mode_button : toggle_theme(tool_box.theme.d_night_icon, tool_box.theme.d_night_icon)
	else
		self.dark_mode_button : toggle_theme(tool_box.theme.night_icon, tool_box.theme.d_night_icon)
    end

    if tool_box.theme.dark_mode_active then
		self.theme_schedule.widget.text = "Dark until " .. tool_box.theme.change_to_light_at
	else
		self.theme_schedule.widget.text = "Light until " .. tool_box.theme.change_to_dark_at
    end


    self.cpu_usage_icon : toggle_theme(tool_box.theme.d_cpu, tool_box.theme.d_cpu)
    self.mem_usage_icon : toggle_theme(tool_box.theme.d_mem, tool_box.theme.d_mem)
end

function ControlPanel : toggle_colors()
	if tool_box.theme.dark_mode_active then
    	self.light_mode_button : toggle_colors(tool_box.theme.p_background_color, tool_box.theme.s_accent_color, tool_box.theme.t_foreground_color, tool_box.theme.t_foreground_accent_color)
	else
		self.light_mode_button : toggle_colors(tool_box.theme.s_accent_color, tool_box.theme.s_accent_color, tool_box.theme.t_foreground_color, tool_box.theme.t_foreground_accent_color)
    end

    if tool_box.theme.dark_mode_active then
		self.dark_mode_button : toggle_colors(tool_box.theme.s_accent_color, tool_box.theme.s_accent_color, tool_box.theme.t_foreground_color, tool_box.theme.t_foreground_accent_color)
	else
    	self.dark_mode_button : toggle_colors(tool_box.theme.p_background_color, tool_box.theme.s_accent_color, tool_box.theme.t_foreground_color, tool_box.theme.t_foreground_accent_color)
    end


    self.cpu_usage_graph.widget.background_color = tool_box.theme.p_accent_color
	self.cpu_usage_graph.widget.color            = tool_box.theme.s_accent_color

	self.mem_usage_graph.widget.background_color = tool_box.theme.p_accent_color
	self.mem_usage_graph.widget.color            = tool_box.theme.s_accent_color
end

function ControlPanel : update_ui()
    self.panel : setup {
        layout = tool_box.wibox.layout.manual,
        self.uptime_label,
        self.light_mode_button.button,
        self.dark_mode_button.button,
        self.theme_schedule,
        self.cpu_usage_graph,
        self.cpu_usage_icon.button,
        self.cpu_usage_label,
        self.mem_usage_graph,
        self.mem_usage_icon.button,
        self.mem_usage_label
    }

    self.panel.screen = self.screen
end

function ControlPanel.new()
	local control_panel = setmetatable({}, ControlPanel)
	return control_panel
end

return ControlPanel
