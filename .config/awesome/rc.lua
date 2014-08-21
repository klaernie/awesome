-- Standard awesome library
local gears	= require("gears")
local awful	= require("awful")
awful.rules	= require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox	= require("wibox")
-- Theme handling library
local beautiful	= require("beautiful")
-- Notification library
local naughty	= require("naughty")
naughty.init_dbus()
-- Menubar
local menubar	= require("menubar")
-- lain widgets
local lain	= require("lain")


-- require("widget_fun")
-- local widget_fun = widget_fun

-- Vicious widgets
-- vicious = require("vicious")

-- shifty
local shifty = require("shifty")

-- Load Debian menu entries
require("debian.menu")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config") .. "/powerarrow-darker/theme.lua")

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
  systrayscreen = screen["DVI-I-1"].index
  primaryscreen = screen["DP-1"].index
  auxscreen	= screen["DVI-D-0"].index
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

-- setup wallpaper as machine-dependant
beautiful.wallpaper = awful.util.getdir("config") .. "/bg/bg-" .. hostname
if beautiful.wallpaper then
    if hostname == "eliza" then
        gears.wallpaper.centered(beautiful.wallpaper, nil, '#000000')
    else
        for s = 1, screen.count() do
            gears.wallpaper.maximized(beautiful.wallpaper, s, true)
        end
    end

end

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
		match = { role  = {	"browser", },
				  class = {	"Chromium","chromium",
							"Google-chrome", "google-chrome",
							"iceweasel", },
				},
		tag	= "web",
	},
	{
		match = { "exe", },
		tag	= "flash",
		float	= true,
	},
	{
		match = { role = { "buddy_list", }, name = { "Hangouts",}, },
		tag	= "chat",
		slave	= false,
		float   = false,
	},
	{
		match = { role = { "conversation", "log_viewer", }, class = { "crx_nckgahadagoaajjgafhacjanaoiihapd", }, },
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
		match = { "hl2_linux", "portal2_linux", "Steam", "steam" },
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

-- Menu
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

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Create a textclock widget
mytextclock = awful.widget.textclock(" %a %b %d, %H:%M:%S ", 1 )

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

-- Separators
spr = wibox.widget.textbox(' ')
lspr = wibox.widget.background(wibox.widget.textbox(' '), "#313131")
arrl = wibox.widget.imagebox()
arrl:set_image(beautiful.arrl)
arrl_dl = wibox.widget.imagebox()
arrl_dl:set_image(beautiful.arrl_dl)
arrl_ld = wibox.widget.imagebox()
arrl_ld:set_image(beautiful.arrl_ld)
arrr = wibox.widget.imagebox()
arrr:set_image(beautiful.arrr)
arrr_dl = wibox.widget.imagebox()
arrr_dl:set_image(beautiful.arrr_dl)
arrr_ld = wibox.widget.imagebox()
arrr_ld:set_image(beautiful.arrr_ld)

-- CPU
cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
cpuwidget = wibox.widget.background(lain.widgets.cpu({
    settings = function()
        widget:set_text(" " .. cpu_now.usage .. "% ")
    end
}), "#313131")

-- Coretemp
tempicon = wibox.widget.imagebox(beautiful.widget_temp)
tempwidget = lain.widgets.temp({
    settings = function()
        widget:set_text(" " .. coretemp_now .. "°C ")
    end
})

-- filesystem

local homedisk = "/home"
if hostname == "mainframe" then
    homedisk = "/media/Jen"
end

fsicon = wibox.widget.imagebox(beautiful.widget_hdd)
fswidget = lain.widgets.fs({
    settings  = function()
        widget:set_text(" " .. fs_now.used .. "% ")
    end,
    partition=homedisk
})
fswidgetbg = wibox.widget.background(fswidget, "#313131")

-- Battery
baticon = wibox.widget.imagebox(beautiful.widget_battery)
batwidget = lain.widgets.bat({
    settings = function()
        if bat_now.perc == "N/A" then
            bat_now.perc = "AC"
            baticon:set_image(beautiful.widget_ac)
        elseif tonumber(bat_now.perc) <= 5 then
            baticon:set_image(beautiful.widget_battery_empty)
        elseif tonumber(bat_now.perc) <= 15 then
            baticon:set_image(beautiful.widget_battery_low)
        else
            baticon:set_image(beautiful.widget_battery)
        end
        widget:set_markup(" " .. bat_now.perc .. "% ")
    end
})

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
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(wibox.widget.background(mylauncher, "#313131"))
    left_layout:add(arrr_ld)
    left_layout:add(spr)
    left_layout:add(mytaglist[s])
    left_layout:add(spr)
    left_layout:add(arrr_dl)
    left_layout:add(wibox.widget.background(mypromptbox[s], "#313131"))
    left_layout:add(arrr_ld)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(spr)
    right_layout:add(arrl)
    right_layout:add(arrl_ld)
    right_layout:add(fsicon)
    right_layout:add(fswidgetbg)
    right_layout:add(arrl_dl)
    right_layout:add(tempicon)
    right_layout:add(tempwidget)
    right_layout:add(arrl_ld)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(arrl_dl)
    right_layout:add(baticon)
    right_layout:add(batwidget)
    right_layout:add(arrl_ld)
    right_layout:add(lspr)
    if s == systrayscreen then right_layout:add(wibox.widget.systray()) end
    right_layout:add(lspr)
    right_layout:add(arrl_dl)
    right_layout:add(mytextclock)
    right_layout:add(arrl_ld)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
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
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),

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

-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_color = beautiful.border_normal
        else
            if not awful.client.ismarked(c) then
                c.border_color = beautiful.border_focus
            end
        end
    end)

-- Hook function to execute when unfocusing a client.
client.connect_signal("unfocus", function(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
        local clients = awful.client.visible(s)
        local layout  = awful.layout.getname(awful.layout.get(s))

        if #clients > 0 then -- Fine grained borders and floaters control
            for _, c in pairs(clients) do -- Floaters always have borders
                if awful.client.floating.get(c) or layout == "floating" then
                    c.border_width = beautiful.border_width

                -- No borders with only one visible client
                elseif #clients == 1 or layout == "max" then
                    clients[1].border_width = 0
                    -- awful.client.moveresize(0, 0, 2, 2, clients[1])
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
      end)
end
-- }}}

-- vim: set ai tabstop=4 sw=4 expandtab:
