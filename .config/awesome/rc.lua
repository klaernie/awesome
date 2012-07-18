-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- shifty
require("shifty")

-- Load Debian menu entries
require("debian.menu")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config") .. "/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Determine hostname (stolen from https://github.com/xtaran )
local io = { popen = io.popen }
local f = io.popen("hostname")
local hostname = f:read("*all")
f:close()
hostname = string.gsub(hostname, '[\n\r]+', '')
naughty.notify ( { text = "awesome running on " .. hostname } )

if hostname == "sapdeb2" then
  autorunsapdeb = true
else
  autorunsapdeb = false
end

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.max,
    awful.layout.suit.magnifier
}

-- {{{ Shifty

shifty.config.tags = {
	web = {
		layout	= awful.layout.suit.tile,
		mwfact	= 0.55,
		exclusive	= true,
		position	= 1,
		init	= true,
		screen	= 1,
	--	spawn	= "chromium"
	},
	saplogon = {
		layout	= awful.layout.suit.tile,
		mwfact	= 0.5,
		exclusive	= true,
		position	= 2,
		init	= autorunsapdeb,
		screen	= 1,
	--	spawn	= "css"
	},
	remmina = {
		layout	= awful.layout.suit.max,
		mwfact	= 0.5,
		exclusive	= true,
		position	= 3,
		init	= autorunsapdeb,
		screen	= 1,
	--	spawn	= "remmina"
	},
	LTS = {
		layout	= awful.layout.suit.tile,
		mwfact	= 0.5,
		exclusive	= false,
		position	= 4,
		init	= autorunsapdeb,
		screen	= 1,
	--	spawn	= terminal .. " --window-with-profile ls2621 -e master\:ls2621 -t ls2621:master",
	},
	citrix = {
		layout	= awful.layout.suit.max,
		mwfact	= 0.5,
		exclusive	= true,
		position	= 5,
		init	= autorunsapdeb,
		screen	= 1,
	},
	util = {
		layout	= awful.layout.suit.tile,
		mwfact	= 0.5,
		exclusive	= false,
		position	= 8,
		init	= true,
		screen	= 1,
	--	spawn	= "synS",
	},
	chat = {
		layout	= awful.layout.suit.tile,
		mwfact	= 0.80,
		exclusive	= true,
		position	= 9,
		init	= true,
		screen	= math.max(screen.count(), 1),
	--	spawn	= "pidgin"
	},
	mutt = {
		layout	= awful.layout.suit.tile,
		mwfact	= 0.50,
		position	= 7,
		exclusive	= true,
		spawn	= "run-mutt.sh"
	},
	wdevdev = {
		layout	= awful.layout.suit.tile,
		mwfact	= 0.50,
		position	= 7,
		exclusive	= true,
		spawn	= terminal .. " -t wdev0 -e run-wdev0.sh",
	},
	wdevlog = {
		layout	= awful.layout.suit.tile,
		mwfact	= 0.50,
		position	= 7,
		exclusive	= true,
		spawn	= terminal .. " -t wdev1 -e run-wdev1.sh",
	}
}


shifty.config.apps = {
	{
		match = {"chromium"},
		tag	= "web",
		screen	= 1
	},
	{
		match = {"Buddy-Liste"},
		tag	= "chat",
		slave	= true,
		screen	= 1
	},
	{
		match = {"pidgin", "Pidgin" },
		tag	= "chat",
		screen	= 1
	},
	{
		match = { "SAPGUI", "CSN", "com-sap-platin-Gui" },
		tag	= "saplogon",
		screen	= 1
	},
	{
		match = { "Remmina", "remmina" },
		tag	= "remmina",
		screen	= 1
	},
	{
		match = { "ls2621" },
		tag	= "LTS",
		screen	= 1
	},
	{
		match = { "Wfica" },
		tag	= "citrix",
		screen	= 1
	},
	{
		match = { "synergys" },
		tag	= "util",
		screen	= 1
	},
	{
		match = { "mutt" },
		tag	= "mutt",
	},
	{
		match = { "wdev0" },
		tag	= "wdevdev",
	},
	{
		match = { "wdev1" },
		tag	= "wdevlog",
	},
	{
		match = { "urxvt" },
		honorsizehints = false,
	},
	{
		match = { "gnome-terminal" },
		honorsizehints = false,
	},
	{
		match = { "gcalctool" },
		intrusive = true,
		float	= true,
		skip_taskbar	= true,
	},
	{
		match = { "nm-applet" },
		intrusive = true,
		float	= true,
		skip_taskbar	= false,
	},
	{
		match = { "jd-Main" },
		tag   =  "JDownloader",
	},
	{
		match = { "JDownloader" },
		tag   =  "JDownloader",
	},
	{
		match = { "gnome-keyring-prompt-3" },
		intrusive = true,
		float	= true,
		skip_taskbar	= true,
	},
	{
		match = {""},   -- Matches all clients to provide button behaviors.
		buttons = awful.util.table.join(
		    awful.button({}, 1, function (c) client.focus = c; c:raise() end),
		    awful.button({modkey}, 1, function(c)
			client.focus = c
			c:raise()
			awful.mouse.client.move(c)
			end),
		    awful.button({modkey}, 3, awful.mouse.client.resize)
		    )
	},
}

shifty.config.defaults = {
	layout	= awful.layout.suit.tile,
	ncol	= 1,
	mwfact	= 0.5,
	floatBars	= true,
	guess_name	= true,
	guess_position	= true,
}

-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "edit config - terminal edition", terminal .. " --working-directory=" .. awful.util.getdir("config") },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" }, " %a %b %d, %H:%M:%S ", 1 )

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewprev),
                    awful.button({ }, 5, awful.tag.viewnext),
                    awful.button({ }, 6, awful.tag.viewprev),
                    awful.button({ }, 7, awful.tag.viewnext)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        s == math.max(screen.count(), 1) and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ shifty init
shifty.taglist	= mytaglist
shifty.init()
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
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
    --awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

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

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),


    -- make a screenshot
    awful.key({                   }, "Print", function () awful.util.spawn("gnome-screenshot") end),

    -- run screensaver
    awful.key({ modkey,           }, "Pause", function () awful.util.spawn("xscreensaver-command -lock") end),
    awful.key({                   }, "XF86Launch1", function () awful.util.spawn("xscreensaver-command -lock") end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey },            "x",     function ()
						  awful.prompt.run({ prompt = "Run Lua code: " },
						  mypromptbox[mouse.screen].widget,
						  awful.util.eval, nil,
						  awful.util.getdir("cache") .. "/history_eval")
					      end),

    -- shifty
    awful.key({modkey}, "t", function() shifty.add({ rel_index = 1 }) end),
    awful.key({modkey}, "c", shifty.rename),
    awful.key({modkey}, "w", shifty.del)

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

--shifty.config.globalkeys = globalkeys
shifty.config.clientkeys = clientkeys
shifty.config.modkey	= modkey


-- shifty keycode-tag-jumper
-- Compute the maximum number of digit we need, limited to 9
for i = 1, (shifty.config.maxtags or 9) do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({modkey}, i, function()
            local t =  awful.tag.viewonly(shifty.getpos(i))
            end),
        awful.key({modkey, "Control"}, i, function()
            local t = shifty.getpos(i)
            t.selected = not t.selected
            end),
        awful.key({modkey, "Control", "Shift"}, i, function()
            if client.focus then
                awful.client.toggletag(shifty.getpos(i))
            end
            end),
        -- move clients to other tags
        awful.key({modkey, "Shift"}, i, function()
            if client.focus then
                t = shifty.getpos(i)
                awful.client.movetotag(t)
                awful.tag.viewonly(t)
            end
        end))
    end


-- Set keys
root.keys(globalkeys)

-- Hook function to execute when focusing a client.
client.add_signal("focus", function(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
client.add_signal("unfocus", function(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- vim: set ai: set tabstop=10:
