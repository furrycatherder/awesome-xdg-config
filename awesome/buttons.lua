local awful = require "awful"
local hotkeys_popup = require "awful.hotkeys_popup".widget

awful.util.tasklist_buttons = awful.util.table.join(
	awful.button({}, 1, function(c)
		c.minimized = false
	end),
	awful.button({}, 3, function()
		awful.menu.clients({theme = {width = 250}})
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

require "menu"
local root_menu = awful.menu {
	items = {
		{"Applications", xdgmenu},
		{"Open terminal", awful.util.terminal},
		{"Hotkeys", function() return false, hotkeys_popup.show_help end}
	}
}

local root_buttons = awful.util.table.join(
	awful.button({}, 3, function()
		root_menu:toggle()
	end)
)

local client_buttons = awful.util.table.join(
	awful.button({}, 1, function(c)
		client.focus = c
		c:raise()
	end),
	awful.button({"Mod4"}, 1, awful.mouse.client.move),
	awful.button({"Mod4"}, 3, awful.mouse.client.resize)
)

local titlebar_buttons = function(c)
	return awful.util.table.join(
		awful.button({}, 1, function()
			client.focus = c
			c:raise()
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			client.focus = c
			c:raise()
			awful.mouse.client.resize(c)
		end)
	)
end

return {
	root = root_buttons,
	client = client_buttons,
	titlebar = titlebar_buttons
}
-- vim: set tabstop=2 shiftwidth=2 noexpandtab:
