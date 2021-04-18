-- For the default configuration file, see /etc/xdg/awesome/rc.lua

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
-- local hotkeys_popup = require("awful.hotkeys_popup")
-- -- Enable hotkeys help widget for VIM and other apps
-- -- when client with a matching name is opened:
-- require("awful.hotkeys_popup.keys")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}


-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
}
-- }}}


-- {{{ Wallpaper
local wallpaper_colour = {
   _index = 1,
   _max_index = #beautiful.wallpaper_colours
}
function wallpaper_colour:next()
   new_index = self._index + 1
   if new_index > self._max_index then
      new_index = 1
   end
   self._index = new_index
   return beautiful.wallpaper_colours[new_index]
end

local reset_wallpaper_colour = function()
    gears.wallpaper.set(beautiful.bg_normal)
end

local change_wallpaper_colours = function()
   local colour = wallpaper_colour:next()
   gears.wallpaper.set(colour)
end 

reset_wallpaper_colour()
root.buttons(gears.table.join(
      awful.button({}, 1, change_wallpaper_colours),
      awful.button({}, 3, reset_wallpaper_colour)
   )
)
--}}}


-- {{{ Wibar

-- Create a textclock widget
mytextclock = wibox.widget.textclock("<b>%a %d %b %H:%M</b>")
mytextclock:set_refresh(10)  -- How often the clock is updated, in seconds
local mycalendar = awful.widget.calendar_popup.month { margin = 5, start_sunday = true }
mycalendar:attach( mytextclock, "tc" )

mysystray = wibox.widget {
    {
        wibox.widget.systray(),
        margins = 2,
        widget  = wibox.container.margin,
    },
    widget = wibox.container.background,
}

local indicate_empty_tag = function(widget, tag)
   local textbox = widget:get_children_by_id('text_role')[1]
   if #tag:clients() > 0 then
      textbox.opacity = 1
   else
      textbox.opacity = beautiful.taglist_empty_tag_opacity
   end
end

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag({ "壱", "弐", "参", "肆", "伍", "陸", "漆", "捌", "玖" }, s, awful.layout.layouts[1])

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = gears.table.join(
           -- View a tag with a left click
           awful.button({ }, 1, function(t) t:view_only() end),
           -- Move a client to a tag with a right click
           awful.button({ }, 3, function(t)
                 if client.focus then client.focus:move_to_tag(t) end end)
        ),
        layout   = {
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                wibox.widget.base.make_widget(),
                forced_height = 3,
                id            = 'background_role',
                widget        = wibox.container.background,
            },
            {
                {
                    id     = 'text_role',
                    widget = wibox.widget.textbox,
                },
                margins = 3,
                widget  = wibox.container.margin
            },
            nil,
            create_callback = function(self, tag, _, _) indicate_empty_tag(self, tag) end,
            update_callback = function(self, tag, _, _) indicate_empty_tag(self, tag) end,
            layout = wibox.layout.align.vertical,
        },
    }

    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = gears.table.join(
           -- Focus on a client with a left click
           awful.button({ }, 1, function (c)
                 if c ~= client.focus then c:emit_signal("request::activate", "tasklist", {raise = true}) end end)
        ),
        layout   = {
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                wibox.widget.base.make_widget(),
                forced_height = 3,
                id            = 'background_role',
                widget        = wibox.container.background,
            },
            {
                {
                    id     = 'clienticon',
                    widget = awful.widget.clienticon,
                },
                margins = 3,
                widget  = wibox.container.margin
            },
            nil,
            create_callback = function(self, c, index, objects)
                self:get_children_by_id('clienticon')[1].client = c
            end,
            layout = wibox.layout.align.vertical,
        },
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = beautiful.wibar_height })

    -- Add widgets to the wibox
    s.mywibox:setup {
       layout = wibox.layout.align.horizontal,
       expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            wibox.widget.separator { thickness = 0, forced_width = 5 },
            s.mytasklist,
        },
        { -- Middle widget
            layout = wibox.layout.fixed.horizontal, 
            mytextclock,
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- wibox.widget.systray(),
            mysystray,
        },
    }
end)
-- }}}


-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "Tab",
        function () awful.client.focus.byidx( 1) end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "o",
        function () awful.client.focus.byidx( 1) end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey, "Shift"   }, "Tab",
        function () awful.client.focus.byidx(-1) end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(os.getenv("LOCAL_BIN") .. "/terminal") end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,           }, "space", function () awful.spawn(os.getenv("LOCAL_BIN") .. "/launcher") end,
              {description = "open an application launcher", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    -- Edge snapping
    awful.key(
       { modkey,           }, "Left",
       function ()
          local axis = "vertically"
          local f = awful.placement.scale
             + awful.placement.left
             + (axis and awful.placement["maximize_"..axis] or nil)
          local geo = f(client.focus, {honor_workarea=true, to_percent = 0.5})          
       end,
       {description = "Snap to the left", group = "client"}),
    awful.key(
       { modkey,           }, "Right",
       function ()
          local axis = "vertically"
          local f = awful.placement.scale
             + awful.placement.right
             + (axis and awful.placement["maximize_"..axis] or nil)
          local geo = f(client.focus, {honor_workarea=true, to_percent = 0.5})          
       end,
       {description = "Snap to the right", group = "client"}),
    awful.key(
       { modkey,           }, "Up",
       function ()
          local axis = "horizontally"
          local f = awful.placement.scale
             + awful.placement.top
             + (axis and awful.placement["maximize_"..axis] or nil)
          local geo = f(client.focus, {honor_workarea=true, to_percent = 0.5})          
       end,
       {description = "Maximize", group = "client"}),
    awful.key(
       { modkey,           }, "Down",
       function ()
          local axis = "horizontally"
          local f = awful.placement.scale
             + awful.placement.bottom
             + (axis and awful.placement["maximize_"..axis] or nil)
          local geo = f(client.focus, {honor_workarea=true, to_percent = 0.5})          
       end,
       {description = "Resize the window and move under mouse", group = "client"}),
    awful.key(
       { modkey, "Shift"   }, "Up",
       function ()
          local func = awful.placement.maximize
          local geo = func(client.focus, {honor_workarea=true})
       end,
       {description = "Maximize", group = "client"})

)

clientkeys = gears.table.join(
    awful.key({ modkey, "Shift"   }, "c", function (c) c:kill() end,
              {description = "close", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}


-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     size_hints_honor = false,
                     placement = awful.placement.no_overlap + awful.placement.no_offscreen,
                     floating = true,
                     titlebars_enabled = true
     }
    },
}
-- }}}


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            wibox.widget.separator { thickness = 0, forced_width = 5 },
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "left",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            -- awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
