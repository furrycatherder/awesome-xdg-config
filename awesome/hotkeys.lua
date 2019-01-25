local awful = require "awful"
local lain = require "lain"
local hotkeys_popup = require "awful.hotkeys_popup.widget".new {
	width = 3 * screen.primary.geometry.width / 5,
	height = 4 * screen.primary.geometry.height / 5,
}

local terminal = "urxvt" or "xterm"
local browser = "firefox"
local spotlight = "dmenu_run"

root_hotkeys = awful.util.table.join(
	-- Hotkeys
	awful.key({"Mod4"}, "s", function() hotkeys_popup:show_help() end,
		{description = "show help", group = "awesome"}),

	-- Standard programs
	awful.key({"Mod1"}, "space", function() awful.spawn(spotlight) end,
		{description = "run dmenu", group = "launcher"}),
	awful.key({"Mod1"}, "Return", function() awful.spawn(terminal) end,
		{description = "open a terminal", group = "launcher"}),
	awful.key({"Mod4"}, "b", function() awful.spawn(browser) end,
		{description = "open a browser", group = "launcher"}),
	awful.key({"Mod4"}, "z", function() awful.screen.focused().quake:toggle() end,
		{description = "toggle quake", group = "launcher"}),

	awful.key({"Mod4", "Control"}, "r", awesome.restart,
		{description = "reload awesome", group = "awesome"}),
	awful.key({"Mod4", "Shift"}, "q", awesome.quit,
		{description = "quit awesome", group = "awesome"}),

	-- Tag browsing
	awful.key({"Mod4"}, "Left", awful.tag.viewprev,
			{description = "view previous", group = "tag"}),
	awful.key({"Mod4"}, "Right", awful.tag.viewnext,
			{description = "view next", group = "tag"}),
	awful.key({"Mod4"}, "Escape", awful.tag.history.restore,
			{description = "go back", group = "tag"}),

	-- Navigation
	awful.key({"Mod1"}, "j", function() awful.client.focus.byidx(1) end,
		{description = "focus next by index", group = "client"}),
	awful.key({"Mod1"}, "k", function() awful.client.focus.byidx(-1) end,
		{description = "focus previous by index", group = "client"}),

	awful.key({"Mod4", "Control"}, "j", function()
		awful.screen.focus_relative(1)
	end, {description = "focus the next screen", group = "screen"}),
	awful.key({"Mod4", "Control"}, "k", function()
		awful.screen.focus_relative(-1)
	end, {description = "focus the previous screen", group = "screen"}),

	awful.key({"Mod1"}, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, {description = "go back", group = "client"}),

	awful.key({"Mod4", "Shift"}, "n", function()
		local c = awful.client.restore()
		if c then -- Focus restored client.
			client.focus = c
			c:raise()
		end
	end, {description = "restore minimized", group = "client"}),

	-- Layout manipulation
	awful.key({"Mod4"}, "k", function() awful.layout.inc(1) end,
		{description = "select next", group = "layout"}),
	awful.key({"Mod4"}, "j", function() awful.layout.inc(-1) end,
		{description = "select previous", group = "layout"}),

	awful.key({"Mod4", "Shift"}, "j", function() awful.client.swap.byidx(1) end,
		{description = "swap with next client by index", group = "client"}),
	awful.key({"Mod4", "Shift"}, "k", function() awful.client.swap.byidx(-1) end,
		{description = "swap with previous client by index", group = "client"}),

	awful.key({"Mod4", "Shift"}, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, {description = "increase the number of master clients", group = "layout"}),
	awful.key({"Mod4", "Shift"}, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, {description = "decrease the number of master clients", group = "layout"}),

	awful.key({"Mod4", "Control"}, "h", function()
		awful.tag.incncol(1, nil, true)
	end, {description = "increase the number of columns", group = "layout"}),
	awful.key({"Mod4", "Control"}, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, {description = "decrease the number of columns", group = "layout"})
)

client_hotkeys = awful.util.table.join(
	awful.key({"Mod4"}, "q", function(c) c:kill() end,
		{description = "close", group = "client"}),
	awful.key({"Mod4"}, "t", function(c) c.ontop = not c.ontop end,
		{description = "toggle keep on top", group = "client"}),
	awful.key({"Mod4"}, "m", function(c) c.minimized = true end,
		{description = "minimize", group = "client"}),
	awful.key({"Mod4", "Shift"}, "m", function(c)
		c.maximized = not c.maximized
	end, {description = "maximize", group = "client"}),
	awful.key({"Mod4"}, "f", lain.util.magnify_client,
		{description = "magnify", group = "client"}),
	awful.key({"Mod4", "Shift"}, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, {description = "toggle fullscreen", group = "client"}),
	awful.key({"Mod4", "Control"}, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, {description = "move to master", group = "client"}),
	awful.key({"Mod4"}, "o", function(c)
		c:move_to_screen()
	end, {description = "move to screen", group = "client"})
)
    
for i = 1, tag:instances() do
	root_hotkeys = awful.util.table.join(root_hotkeys,
		awful.key({"Mod4"}, i, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, {description = "view tag #" .. i, group = "tag"}),

		awful.key({"Mod4", "Shift"}, i, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, {description = "toggle tag #" .. i, group = "tag"}),

		awful.key({"Mod4", "Control"}, i, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, {description = "move focused client to tag #" .. i, group = "tag"}),

		awful.key({"Mod4", "Control", "Shift"}, i, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, {description = "toggle focused client on tag #" .. i, group = "tag"})
	)
end

return {
	root = root_hotkeys,
	client = client_hotkeys,
}

-- vim: set ts=2 sw=2 noet:
