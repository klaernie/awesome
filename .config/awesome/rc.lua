-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
naughty.init_dbus()

require("widget_fun")
local widget_fun = widget_fun

-- Vicious widgets
vicious = require("vicious")

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

-- determine hostname from environment variable - remember to export it explicitly in ~/.Xsession
hostname = os.getenv("HOSTNAME")
naughty.notify ( { text = "awesome running on " .. hostname } )

if hostname == "sapdeb2" then
  autorunsapdeb = true
  systrayscreen = 1
  primaryscreen = 1
  auxscreen	= math.max(screen.count(),1) ,
  awful.util.spawn( os.getenv("HOME") .. "/bin/enable-DP4.sh" )
elseif hostname == "mainframe" and screen.count() == 3 then
  systrayscreen = 2
  primaryscreen = 1
  auxscreen     = 3
else
  autorunsapdeb = false
  systrayscreen = math.max(screen.count(), 1)
  primaryscreen = 1
  auxscreen     = 1
end

-- write out workarea hints for every screen
local wa_primary = io.open(awful.util.getdir("cache").."workarea"..hostname..".primary", "w")
wa_primary:write(screen[primaryscreen].workarea["width"].."x"..screen[primaryscreen].workarea["height"])
wa_primary:close()

local wa_systray = io.open(awful.util.getdir("cache").."workarea"..hostname..".systray", "w")
wa_systray:write(screen[systrayscreen].workarea["width"].."x"..screen[systrayscreen].workarea["height"])
wa_systray:close()

local wa_aux = io.open(awful.util.getdir("cache").."workarea"..hostname..".aux", "w")
wa_aux:write(screen[auxscreen].workarea["width"].."x"..screen[auxscreen].workarea["height"])
wa_aux:close()


-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
--  awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
--  awful.layout.suit.tile.top,
--  awful.layout.suit.fair,
--  awful.layout.suit.fair.horizontal,
--  awful.layout.suit.spiral,
--  awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
--  awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}

-- {{{ Shifty

shifty.config.tags = {
	["web"] = {
		layout	= awful.layout.suit.tile,
		mwfact	= 0.55,
		exclusive	= true,
		position	= 1,
		init	= true,
		screen	= primaryscreen,
	},
	["saplogon"] = {
		layout	= awful.layout.suit.tile,
		mwfact	= 0.5,
		exclusive	= true,
		position	= 2,
		init	= false,
		screen	= primaryscreen,
	},
	["remmina"] = {
		layout	= awful.layout.suit.max,
		mwfact	= 0.5,
		exclusive	= true,
		position	= 3,
		init	= autorunsapdeb,
		screen	= primaryscreen,
	},
	["LTS"] = {
		layout	= awful.layout.suit.tile,
		mwfact	= 0.5,
		exclusive	= false,
		position	= 4,
		init	= autorunsapdeb,
		screen	= primaryscreen,
	},
	["citrix"] = {
		layout	= awful.layout.suit.max,
		mwfact	= 0.5,
		exclusive	= true,
		position	= 5,
		screen	= primaryscreen,
	},
	["virtualbox"] = {
		layout	= awful.layout.suit.max,
		mwfact	= 0.5,
		exclusive	= true,
		position	= 6,
		init	= autorunsapdeb,
		screen	= auxscreen,
	},
	["mutt"] = {
		layout	= awful.layout.suit.tile,
		mwfact	= 0.50,
		position	= 7,
		exclusive	= true,
		spawn	= "run-mutt.sh"
	},
	["irssi"] = {
		layout	= awful.layout.suit.tile,
		mwfact	= 0.50,
		position	= 8,
		exclusive	= true,
		spawn	= "run-irssi.sh",
		screen	= ( autorunsapdeb and 1 or systrayscreen ),
	},
	["chat"] = {
		layout	= awful.layout.suit.tile.left,
		mwfact	= 0.20,
		exclusive	= true,
		position	= 9,
		init	= true,
		screen	= ( autorunsapdeb and 1 or systrayscreen ),
	},
	["misc"] = {
		layout	= awful.layout.suit.tile,
		mwfact	= 0.5,
		exclusive	= false,
		position	= 10,
		init	= ( auxscreen ~= systrayscreen ) and ( screen.count() >= 3 ) ,
		screen	= auxscreen,
	},
	["util"] = {
		layout	= awful.layout.suit.tile,
		mwfact	= 0.5,
		exclusive	= false,
		position	= 10,
		init	= true,
		screen	= systrayscreen,
	},
	["sauerbraten"] = {
		layout  = awful.layout.suit.max,
		exclusive	= true,
	},
	["spotify"] = {
		layout  = awful.layout.suit.max,
		exclusive	= true,
		screen  = auxscreen,
	},
	["darktable"] = {
		layout	= awful.layout.suit.max,
		exclusive	= true,
		screen	= primaryscreen,
	},
	["steam"] = {
		layout	= awful.layout.suit.max,
		exclusive	= true,
		screen	= primaryscreen,
	},
	["vlc"]	= {
		exclusive	= true,
		screen 	= auxscreen
	}
}


shifty.config.apps = {
	{
		match = { "chromium",
		          "iceweasel", },
		tag	= "web",
	},
	{
		match = { "exe", },
		tag	= "flash",
		float	= true,
	},
	{
		match = { role = { "buddy_list", } },
		tag	= "chat",
		slave	= false,
		float   = false,
	},
	{
		match = { role = { "conversation", "log_viewer", }, },
		tag	= "chat",
		slave	= true,
		float	= false,
	},
	{
		match = { class = { "Pidgin", }, },
		tag	= "chat",
		border_width = 0,
	},
	{
		match = { "SAPGUI", "CSN", "CSR", "com-sap-platin-Gui", "SAP GUI for Java", },
		tag	= "saplogon",
	},
	{
		match = { "Remmina", "remmina" },
		tag	= "remmina",
		border_width  = 0,
	},
	{
		match = { "rdesktop" },
		tag     = "remmina",
		float	= false,
		border_width  = 0,
	},
	{
		match = { "ls2621" },
		tag	= "LTS",
	},
	{
		match = { class = { "Wfica", }, },
		tag	= "citrix",
		honorsizehints = false,
	},
	{
		match = { "synergys" },
		tag	= "util",
	},
	{
		match = { "mutt" },
		tag	= "mutt",
	},
	{
		match = { "irssi" },
		tag	= "irssi",
	},
	{
		match = { "vlc", },
		tag	= "vlc",
		border_width	= 0,
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
		match = { "Cube 2: Sauerbraten" },
		tag   = "sauerbraten",
	},
	{
		match = { class = { "VirtualBox", } ,
			  name  = { "SAP-Windows", } , },
		tag   = "virtualbox",
	},
	{
		match = { "darktable" },
		tag   = "darktable",
		float = false,
		border_width = 0,
	},
	{
		match = { "spotify" },
		tag   = "spotify",
		float = false,
		border_width = 0,
	},
	{
		match = { "gnome-keyring-prompt-3" },
		intrusive = true,
		float	= true,
		skip_taskbar	= true,
	},
	{
		match = { "hl2_linux", "Steam", "steam" },
		tag	= "steam",
		border_width = 0,
		float	= false,
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

-- battery widget
batterywidget = widget({type = "textbox", name = "batterywidget"})
vicious.register(batterywidget, vicious.widgets.bat, widget_fun.batclosure(), 31, "BAT0")

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

-- make gtk icons brighter via chroma key properties
xprop = assert(io.popen("xprop -root _NET_SUPPORTING_WM_CHECK"))
wid = xprop:read():match("^_NET_SUPPORTING_WM_CHECK.WINDOW.: window id # (0x[%S]+)$")
xprop:close()
if wid then
	wid = tonumber(wid) + 1
	os.execute("xprop -id " .. wid .. " -format _NET_SYSTEM_TRAY_COLORS 32c " ..  "-set _NET_SYSTEM_TRAY_COLORS " ..  "65535,65535,65535,65535,8670,8670,65535,32385,0,8670,65535,8670")
end

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
        s == systrayscreen and mysystray or nil,
	batterywidget,
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
    awful.key({ modkey, "Shift"   }, "Left",   shifty.send_prev), -- client to prev tag
    awful.key({ modkey, "Shift"   }, "Right",  shifty.send_next), -- client to next tag
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
    awful.key({ modkey, "Shift"   }, "q", function () awful.util.spawn("shutdown.sh") end),


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
    awful.key({modkey, "Control"}, "n",
              function()
                  local t = awful.tag.selected()
                  local s = awful.util.cycle(screen.count(), t.screen + 1)
                  awful.tag.history.restore()
                  t = shifty.tagtoscr(s, t)
                  awful.tag.viewonly(t)
                  awful.screen.focus_relative( 1)
              end),

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
for i = 0, (shifty.config.maxtags or 9) do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({modkey}, i, function()
            local t =  awful.tag.viewonly(shifty.getpos( i==0 and 10 or i ))
            end),
        awful.key({modkey, "Control"}, i, function()
            local t = shifty.getpos(i==0 and 10 or i )
            t.selected = not t.selected
            end),
        awful.key({modkey, "Control", "Shift"}, i, function()
            if client.focus then
                awful.client.toggletag(shifty.getpos(i==0 and 10 or i))
            end
            end),
        -- move clients to other tags
        awful.key({modkey, "Shift"}, i, function()
            if client.focus then
                t = shifty.getpos(i==0 and 10 or i)
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
