---------------------------------
-- Utility to display messages --
---------------------------------

local tool_box = nil

local MessagePane = {
	screen = nil,
	-- Widgets
	frame        = nil,
	close_button = nil,
	message      = nil
}
MessagePane.__index = MessagePane

function MessagePane : set_tool_box(tb)
	tool_box = tb
end

function MessagePane : init_ui(screen, frame_width, frame_height)
	self.screen = screen

	self.frame = tool_box.wibox {
		shape   = tool_box.ui.ROUNDED_RECT,
        expand  = true,
        visible = false,
        ontop   = true,
        width   = frame_width,
        height  = frame_height,
        -- Since this utility is used in many places
        -- Its colors cannot be changed 
        bg      = tool_box.theme.p_background_color
	}

	self.close_button = tool_box.wibox.widget {
		widget = tool_box.wibox.widget.imagebox,
		resize = true,
		image  = tool_box.theme.titlebar_close_button_focus,
		forced_width = 14,
		forced_height = 14,
		point  = {
			x = 10,
			y = 10
		}
	}

	self.close_button : connect_signal(
		"button::press",
		function()
			self : close_pane()
		end
	)

	self.message = tool_box.wibox.widget {
		widget        = tool_box.wibox.widget.textbox,
		forced_width  = (frame_width - 20),
		forced_height = (frame_height - 80),
		align = "center",
		point = {
			x = 10,
			y = 34
		}
	}

	tool_box.awful.spawn("rm .config/awesome/mini_tools/response_msg")
end

function MessagePane : display_pane()
	self.frame.screen = self.screen

	self.frame.x = (self.screen.geometry.width / 2) - (self.frame.width / 2)
	self.frame.y = (self.screen.geometry.height / 2) - (self.frame.height / 2)

	self.frame.visible = true
end

function MessagePane : close_pane()
	self.frame.visible = false
	self.frame = nil
end

function MessagePane : show_message(ColorButton, msg)
	self.message.markup = "<span foreground='" .. tool_box.theme.t_foreground_color .. "'>" .. msg .. " </span>"

	local close = function()
		self : close_pane()
	end

	local okay_button = ColorButton.new()
	okay_button : init_ui(false, "Okay", 0)
    okay_button : assemble_button(close)
    okay_button : resize_ui(nil, nil, 100, 25)
    okay_button : round_corners()
    okay_button : toggle_colors(tool_box.theme.s_background_color, tool_box.theme.s_accent_color, tool_box.theme.t_foreground_color, tool_box.theme.t_foreground_accent_color)
    okay_button : update_ui()

	okay_button.button.point = {
		x = (self.frame.width / 2) - (okay_button.button.forced_width / 2),
		y = self.frame.height - okay_button.button.forced_height - 10
	}


	self.frame : setup {
		layout = tool_box.wibox.layout.manual,
		self.close_button,
		self.message,
		okay_button.button
	}

	self : display_pane()
end

function MessagePane : ask_confirmation(ColorButton, msg, confirmation_text, do_if_user_agrees)
	self.message.markup = "<span foreground='" .. tool_box.theme.t_foreground_color .. "'>" .. msg .. " </span>"

	local close = function()
		tool_box.awful.spawn.with_shell("echo 'false' > .config/awesome/mini_tools/response_msg")
		self.frame.visible = false
		self = nil
	end

	local continue = function()
		tool_box.awful.spawn.with_shell("echo 'true' > .config/awesome/mini_tools/response_msg")
		self.frame.visible = false
		self = nil
	end

	self.close_button : connect_signal(
		"button::press",
		close
	)

	tool_box.awful.spawn.easy_async(
		"python3 .config/awesome/mini_tools/response.py \"msg\"",
		function(stdout)
			stdout = string.gsub(stdout, "\n", "")
			if stdout == "true" then
				do_if_user_agrees()
			end
		end
	)

	local continue_button = ColorButton.new()
	continue_button : init_ui(false, confirmation_text, 0)
    continue_button : assemble_button(continue)
    continue_button : resize_ui(nil, nil, 100, 25)
    continue_button : round_corners()
    continue_button : toggle_colors(tool_box.theme.s_background_color, tool_box.theme.RED, tool_box.theme.t_foreground_color, tool_box.theme.WHITE)
    continue_button : update_ui()

	continue_button.button.point = {
		x = (self.frame.width / 2) - continue_button.button.forced_width - 10,
		y = self.frame.height - continue_button.button.forced_height - 10
	}


	local cancel_button = ColorButton.new()
	cancel_button : init_ui(false, "Cancel", 0)
    cancel_button : assemble_button(close)
    cancel_button : resize_ui(nil, nil, 100, 25)
    cancel_button : round_corners()
    cancel_button : toggle_colors(tool_box.theme.s_background_color, tool_box.theme.s_accent_color, tool_box.theme.t_foreground_color, tool_box.theme.t_foreground_accent_color)
    cancel_button : update_ui()

	cancel_button.button.point = {
		x = (self.frame.width / 2) + 10,
		y = self.frame.height - cancel_button.button.forced_height - 10
	}


	self.frame : setup {
		layout = tool_box.wibox.layout.manual,
		self.close_button,
		self.message,
		continue_button.button,
		cancel_button.button
	}

	self : display_pane()
end

function MessagePane.new()
	local message_pane = setmetatable({}, MessagePane)
	return message_pane
end

return MessagePane
