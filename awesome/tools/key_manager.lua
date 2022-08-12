---------------
-- Libraries --
---------------

local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")

local utilities = require("tools.utils")

---------------------
-- Terminal_modkey --
---------------------

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"


-- Key bindings
globalkeys = gears.table.join(
    awful.key(
        { modkey }, "h", 
        hotkeys_popup.show_help,
        { description="Show help", group="awesome" }
    ),
    
    awful.key(
        { modkey, "Control" }, "r",
        function()
            utilities.create_stop_flag()
            awesome.restart()
         end,
        { description = "Reload awesome", group = "awesome" }
    ),
    
    awful.key(
        { modkey, "Control" }, "q", 
        awesome.quit,
        { description = "Log out", group = "awesome" }
    ),



    awful.key(
        { modkey }, "Tab",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "Focus next by index", group = "client" }
    ),

    awful.key(
        { modkey, "Shift" }, "Tab",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "Focus previous by index", group = "client" }
    ),

    awful.key(
        { modkey }, "u", 
        awful.client.urgent.jumpto,
        { description = "Jump to urgent client", group = "client" }
    ),

    awful.key(
        { modkey, "Control" }, "Down",
        function()
            local client = awful.client.restore()
            -- Focus restored client
            if client then
                client : emit_signal(
                    "request : activate", 
                    "key.unminimize", 
                    { raise = true }
                )
            end
        end,
        { description = "Restore minimized", group = "client" }
    ),



    awful.key(
        { modkey }, "space", 
        function()
            require("tools.utils").show_rufi()
        end,
        { description = "Show rofi (drun mode)", group = "launcher" }
    ),

    awful.key(
        { modkey }, "Return", 
        function()
            awful.spawn(terminal)
        end,
        { description = "Open a terminal", group = "launcher" }
    ),


    
    awful.key(
        { modkey }, "Left",
        awful.tag.viewprev,
        { description = "View previous", group = "tag" }
    ),

    awful.key(
        { modkey }, "Right",  
        awful.tag.viewnext,
        { description = "View next", group = "tag" }
    )
)

clientkeys = gears.table.join(
    awful.key(
        { modkey }, "f",
        function(client)
            client.fullscreen = not client.fullscreen
            client : raise()
        end,
        { description = "Toggle fullscreen", group = "client" }
    ),
    
    awful.key(
        { modkey }, "q", 
        function(client)
            client : kill()
        end,
        { description = "Close", group = "client" }
    ),
    
    awful.key(
        { modkey }, "t", 
        function(client)
            client.ontop = not client.ontop
        end,
        { description = "Toggle keep on top", group = "client" }
    ),
    
    awful.key(
        { modkey }, "Down",
        function(client)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            client.minimized = true
        end ,
        { description = "Minimize", group = "client" }
    ),
    
    awful.key(
        { modkey }, "Up",
        function(client)
            client.maximized = not client.maximized
            client : raise()
        end ,
        { description = "(un)maximize", group = "client" }
    )
)

-- Bind all key numbers to tags.
-- Be careful :  we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local tags = 9
for i = 1, tags do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key(
            { modkey }, "#" .. i + tags,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag : view_only()
                end
            end,
            { description = "View tag #" .. i, group = "tag" }
        ),
        
        -- Toggle tag display.
        awful.key(
            { modkey, "Control" }, "#" .. i + tags,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "Toggle tag #" .. i, group = "tag" }
        ),

        -- Move client to tag.
        awful.key(
            { modkey, "Shift" }, "#" .. i + tags,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus : move_to_tag(tag)
                    end
                end
            end,
            { description = "Move focused client to tag #" .. i, group = "tag" }
        ),
        
        -- Toggle tag on focused client.
        awful.key(
            { modkey, "Control", "Shift" }, "#" .. i + tags,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus : toggle_tag(tag)
                    end
                end
            end,
            { description = "Toggle focused client on tag #" .. i, group = "tag" }
        )
    )
end

clientbuttons = gears.table.join(
    awful.button(
        { }, 
        1, 
        function(client)
            client : emit_signal(
                "request : activate", 
                "mouse_click", 
                { raise = true }
            )
        end
    ),
    
    awful.button(
        { modkey }, 
        1, 
        function(client)
            client : emit_signal(
                "request : activate", 
                "mouse_click", 
                { raise = true }
            )
            awful.mouse.client.move(client)
        end
    ),
    
    awful.button(
        { modkey }, 
        3, 
        function(client)
            client : emit_signal(
                "request : activate", 
                "mouse_click", 
                { raise = true }
            )
            awful.mouse.client.resize(client)
        end
    )
)

-- Set keys
root.keys(globalkeys)
