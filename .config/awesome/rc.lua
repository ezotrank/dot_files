-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- additional libs
require("vicious")

local home   = os.getenv("HOME")
local exec   = awful.util.spawn
local sexec  = awful.util.spawn_with_shell
local scount = screen.count()

if scount == 2 then
   main_monitor = 2
else
   main_monitor = 1
end

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(home .. "/.config/awesome/themes/zenburn/zenburn.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

local r = require("runonce")
r.run("syndaemon -i 0.5 -t -d")
r.run("mount ~/.yandex/disk")
r.run("if [[ -z $(pidof gnome-screensaver) ]]; then gnome-screensaver; fi")

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,        --1
    awful.layout.suit.tile,            --2
    awful.layout.suit.tile.left,       --3
    awful.layout.suit.tile.bottom,     --4
    awful.layout.suit.tile.top,        --5
    awful.layout.suit.fair,            --6
    awful.layout.suit.fair.horizontal, --7
    awful.layout.suit.spiral,          --8
    awful.layout.suit.spiral.dwindle,  --9
    awful.layout.suit.max,             --10
    awful.layout.suit.max.fullscreen,  --11
    awful.layout.suit.magnifier        --12
}

tags = {}
main_monitor_tags = {"1 Chorme Dev", "2 Chrome", "3 Tmux", "4 Im", "5 Evolution", "6", "7", "8 DevSceen", "9 Emacs"}

if scount == 2 then
   tags[1] = awful.tag({1, 2}, 1, layouts[3])
   tags[2] = awful.tag(main_monitor_tags, 2, layouts[3])
else
   tags[1] = awful.tag(main_monitor_tags, 1, layouts[3])
end

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
--
-- {{{ Widgets configuration
--
-- {{{ Reusable separator
separator = widget({ type = "imagebox" })
separator.image = image(beautiful.widget_sep)
-- }}}

-- {{{ CPU usage and temperature
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)
-- Initialize widgets
cpugraph  = awful.widget.graph()
tzswidget = widget({ type = "textbox" })
-- Graph properties
cpugraph:set_width(40):set_height(14)
cpugraph:set_background_color(beautiful.fg_off_widget)
cpugraph:set_gradient_angle(0):set_gradient_colors({
   beautiful.fg_end_widget, beautiful.fg_center_widget, beautiful.fg_widget
}) -- Register widgets
vicious.register(cpugraph,  vicious.widgets.cpu,      "$1")
vicious.register(tzswidget, vicious.widgets.thermal, " $1C", 19, "thermal_zone0")
-- }}}

-- {{{ Battery state
baticon = widget({ type = "imagebox" })
baticon.image = image(beautiful.widget_bat)
-- Initialize widget
batwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT0")
-- }}}

-- {{{ Memory usage
memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)
-- Initialize widget
membar = awful.widget.progressbar()
-- Pogressbar properties
membar:set_vertical(true):set_ticks(true)
membar:set_height(12):set_width(8):set_ticks_size(2)
membar:set_background_color(beautiful.fg_off_widget)
membar:set_gradient_colors({ beautiful.fg_widget,
   beautiful.fg_center_widget, beautiful.fg_end_widget
}) -- Register widget
vicious.register(membar, vicious.widgets.mem, "$1", 13)
-- }}}

-- {{{ File system usage
fsicon = widget({ type = "imagebox" })
fsicon.image = image(beautiful.widget_fs)
-- Initialize widgets
fs = {
  b = awful.widget.progressbar(), r = awful.widget.progressbar(),
  h = awful.widget.progressbar(), s = awful.widget.progressbar()
}
-- Progressbar properties
for _, w in pairs(fs) do
  w:set_vertical(true):set_ticks(true)
  w:set_height(14):set_width(5):set_ticks_size(2)
  w:set_border_color(beautiful.border_widget)
  w:set_background_color(beautiful.fg_off_widget)
  w:set_gradient_colors({ beautiful.fg_widget,
     beautiful.fg_center_widget, beautiful.fg_end_widget
  }) -- Register buttons
end -- Enable caching
vicious.cache(vicious.widgets.fs)
-- Register widgets
vicious.register(fs.b, vicious.widgets.fs, "${/home used_p}", 599)
vicious.register(fs.r, vicious.widgets.fs, "${/ used_p}",     599)
-- }}}

-- {{{ Network usage
dnicon = widget({ type = "imagebox" })
upicon = widget({ type = "imagebox" })
wifiicon = widget({ type = "imagebox" })

dnicon.image = image(beautiful.widget_net)
upicon.image = image(beautiful.widget_netup)
wifiicon.image = image(beautiful.widget_wifi)
-- Initialize widget
netwidget = widget({ type = "textbox" })
eth_net = widget({ type = "textbox" })
-- Register widget
vicious.register(netwidget, vicious.widgets.net, '<span color="'
  .. beautiful.fg_netdn_widget ..'">${wlan0 down_kb}</span> <span color="'
  .. beautiful.fg_netup_widget ..'">${wlan0 up_kb}</span>', 3)
		 
vicious.register(eth_net, vicious.widgets.net, '<span color="'
  .. beautiful.fg_netdn_widget ..'">${eth0 down_kb}</span> <span color="'
  .. beautiful.fg_netup_widget ..'">${eth0 up_kb}</span>', 3)
-- }}}

-- {{{ Volume level
volicon = widget({ type = "imagebox" })
volicon.image = image(beautiful.widget_vol)
-- Initialize widgets
volbar    = awful.widget.progressbar()
volwidget = widget({ type = "textbox" })
-- Progressbar properties
volbar:set_vertical(true):set_ticks(true)
volbar:set_height(12):set_width(8):set_ticks_size(2)
volbar:set_background_color(beautiful.fg_off_widget)
volbar:set_gradient_colors({ beautiful.fg_widget,
   beautiful.fg_center_widget, beautiful.fg_end_widget
}) -- Enable caching
vicious.cache(vicious.widgets.volume)
-- Register widgets
vicious.register(volbar,    vicious.widgets.volume,  "$1",  2, "Master")
vicious.register(volwidget, vicious.widgets.volume, " $1%", 2, "Master")
-- }}}

-- {{{ Date and time
local datewidget = widget({ type = "textbox" })
vicious.register(datewidget, vicious.widgets.date, "<span foreground='green'>%a, %d.%m.%y - %H:%M</span>", 5)
-- }}}

-- {{{ System tray
systray = widget({ type = "systray" })
-- }}}
-- }}}

-- {{{ Wibox initialisation
wibox     = {}
promptbox = {}
layoutbox = {}
taglist   = {}
taglist.buttons = awful.util.table.join(
    awful.button({ },        1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ },        3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ },        4, awful.tag.viewnext),
    awful.button({ },        5, awful.tag.viewprev
))

-- OPTIMIZE: bbrr..ugly
if scount == 2 then
   promptbox[1] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
   -- Create a layoutbox
   layoutbox[1] = awful.widget.layoutbox(1)
   layoutbox[1]:buttons(awful.util.table.join(
			   awful.button({ }, 1, function () awful.layout.inc(layouts,  1) end),
			   awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
			   awful.button({ }, 4, function () awful.layout.ipnc(layouts,  1) end),
			   awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
					     ))

   -- Create the taglist
   taglist[1] = awful.widget.taglist(1, awful.widget.taglist.label.all, taglist.buttons)
   -- Create the wibox
   wibox[1] = awful.wibox({      screen = 1,
				 fg = beautiful.fg_normal, height = 12,
				 bg = beautiful.bg_normal, position = "top",
				 border_color = beautiful.border_focus,
				 border_width = beautiful.border_width
			  })
   -- Add widgets to the wibox
   wibox[1].widgets = {
      {   taglist[1], layoutbox[1], separator, promptbox[1],
	  ["layout"] = awful.widget.layout.horizontal.leftright
      }, separator, ["layout"] = awful.widget.layout.horizontal.rightleft }

   -- SCREEN 2
   promptbox[2] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
   -- Create a layoutbox
   layoutbox[2] = awful.widget.layoutbox(2)
   layoutbox[2]:buttons(awful.util.table.join(
			   awful.button({ }, 1, function () awful.layout.inc(layouts,  1) end),
			   awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
			   awful.button({ }, 4, function () awful.layout.ipnc(layouts,  1) end),
			   awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
					     ))

   -- Create the taglist
   taglist[2] = awful.widget.taglist(2, awful.widget.taglist.label.all, taglist.buttons)
   -- Create the wibox
   wibox[2] = awful.wibox({      screen = 2,
				 fg = beautiful.fg_normal, height = 12,
				 bg = beautiful.bg_normal, position = "top",
				 border_color = beautiful.border_focus,
				 border_width = beautiful.border_width
			  })
   -- Add widgets to the wibox
   wibox[2].widgets = {
      {   taglist[2], layoutbox[2], separator, promptbox[2],
	  ["layout"] = awful.widget.layout.horizontal.leftright
      },
      systray,
      separator, datewidget, dateicon,
      separator, volwidget, volbar.widget, volicon,
      separator, upicon, netwidget, dnicon, wifiicon,
      separator, upicon, eth_net, dnicon,
      separator, fs.r.widget, fs.b.widget, fsicon,
      separator, membar.widget, memicon,
      separator, batwidget, baticon,
      separator, tzswidget, cpugraph.widget, cpuicon,
      separator, ["layout"] = awful.widget.layout.horizontal.rightleft }
else
   promptbox[1] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
   -- Create a layoutbox
   layoutbox[1] = awful.widget.layoutbox(1)
   layoutbox[1]:buttons(awful.util.table.join(
			   awful.button({ }, 1, function () awful.layout.inc(layouts,  1) end),
			   awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
			   awful.button({ }, 4, function () awful.layout.ipnc(layouts,  1) end),
			   awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
					     ))

   -- Create the taglist
   taglist[1] = awful.widget.taglist(1, awful.widget.taglist.label.all, taglist.buttons)
   -- Create the wibox
   wibox[1] = awful.wibox({      screen = 1,
				 fg = beautiful.fg_normal, height = 12,
				 bg = beautiful.bg_normal, position = "top",
				 border_color = beautiful.border_focus,
				 border_width = beautiful.border_width
			  })
   -- Add widgets to the wibox
   wibox[1].widgets = {
      {   taglist[1], layoutbox[1], separator, promptbox[1],
	  ["layout"] = awful.widget.layout.horizontal.leftright
      },
      systray,
      separator, datewidget, dateicon,
      separator, volwidget, volbar.widget, volicon,
      separator, upicon, netwidget, dnicon, wifiicon,
      separator, upicon, eth_net, dnicon,
      separator, fs.r.widget, fs.b.widget, fsicon,
      separator, membar.widget, memicon,
      separator, batwidget, baticon,
      separator, tzswidget, cpugraph.widget, cpuicon,
      separator, ["layout"] = awful.widget.layout.horizontal.rightleft }

end

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Ezo keybinds
    awful.key({ modkey }, "l", function () awful.util.spawn("gnome-screensaver-command --lock") end),
    awful.key({ }, "XF86HomePage", function () awful.util.spawn("chromium-browser http://encrypted.google.com") end),
    awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer set Master 2-") end),
    awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer set Master 2+") end),
    awful.key({ }, "XF86AudioMute", function () awful.util.spawn("amixer -q sset Master toggle") end),
    awful.key({ modkey }, "Help", function () awful.util.spawn("sudo hibernate-ram") end),
    awful.key({ modkey }, "p", function () awful.util.spawn("mocp -G") end),
    awful.key({ modkey, "Shift" }, "n", function () awful.util.spawn("mocp -f") end),
    awful.key({ modkey, "Shift" }, "b", function () awful.util.spawn("mocp -r") end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () promptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  promptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
   
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    -- awful.key({ modkey, "Control" }, "o",      function(c) awful.client.movetoscreen(c,c.screen-1) end ),
    -- awful.key({ modkey, "Control" }, "p",      function(c) awful.client.movetoscreen(c,c.screen+1) end ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Use xprop command
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    -- { rule = { class = "MPlayer" },
    --   properties = { floating = true } },
    { rule = { class = "Delicious.com - Discover Yourself!" },
      properties = { floating = true } },
    -- { rule = { class = "Keepassx" },
    --   properties = { floating = true } },
    -- { rule = { class = "Memo - oDesk Team" },
    --   properties = { floating = true } },
    -- { rule = { class = "pinentry" },
    --   properties = { floating = true } },
    -- { rule = { class = "gimp" },
    --   properties = { floating = true } },

    
    { rule = { class = "Evolution" },
      properties = { tag = tags[main_monitor][5] } },
    
    { rule = { name = "EmacsDev", class = "Emacs" }, 
      properties = { tag = tags[main_monitor][9], maximized_vertical = true, maximized_horizontal = true } },

    { rule = { instance = "EmacsDevScreen", class = "URxvt" }, 
      properties = { tag = tags[main_monitor][8] } },
    
    { rule = { class = "Firefox" }, 
      properties = { tag = tags[main_monitor][1] } },

    { rule = { class = "Skype" }, 
      properties = { tag = tags[main_monitor][4] } },

    { rule = { class = "Pidgin" }, 
      properties = { tag = tags[main_monitor][4] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
     end
     c.size_hints_honor = false
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
