--   ██████   ███     ██  █████   ██████  ██████  ██████████   █████ 
--  ░░░░░░██ ░░██  █ ░██ ██░░░██ ██░░░░  ██░░░░██░░██░░██░░██ ██░░░██
--   ███████  ░██ ███░██░███████░░█████ ░██   ░██ ░██ ░██ ░██░███████
--  ██░░░░██  ░████░████░██░░░░  ░░░░░██░██   ░██ ░██ ░██ ░██░██░░░░ 
-- ░░████████ ███░ ░░░██░░██████ ██████ ░░██████  ███ ░██ ░██░░██████
--  ░░░░░░░░ ░░░    ░░░  ░░░░░░ ░░░░░░   ░░░░░░  ░░░  ░░  ░░  ░░░░░░ 

-- local awesome, client, screen, tag = awesome, client, screen, tag
-- local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup").widget

local lain = require("lain")
local menu = require("menu")
local hotkeys = require("hotkeys")
require("errors")

local modkey = "Mod4"
local altkey = "Mod1"

local editor = os.getenv("EDITOR") or "nano" or "vi"
local terminal = "st"
local browser = "qutebrowser"

awful.util.tagnames = {"1", "2", "3", "4", "5"}
awful.util.terminal = terminal
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}

awful.spawn("wal -R")

mymainmenu = awful.menu {
	items = {
		{"Applications", xdgmenu},
		{"Open terminal", terminal},
		{"Hotkeys", function()
			return false, hotkeys_popup.show_help
		end}
	}
}

awful.util.tasklist_buttons =
	awful.util.table.join(
	awful.button({}, 1, function(c) c.minimized = false end),
	awful.button({}, 3, function() awful.menu.clients({theme = {width = 250}}) end),
	awful.button({}, 4, function() awful.client.focus.byidx(1) end),
	awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)

beautiful.init(awful.util.get_configuration_dir() .. "theme.lua")
awful.screen.connect_for_each_screen(function(s) beautiful.setup(s) end)

clientbuttons =
	awful.util.table.join(
	awful.button(
		{},
		1,
		function(c)
			client.focus = c
			c:raise()
		end
	),
	awful.button({modkey}, 1, awful.mouse.client.move),
	awful.button({modkey}, 3, awful.mouse.client.resize)
)

-- Set root keys and buttons
root.keys(hotkeys.rootkeys)
root.buttons(
	awful.util.table.join(
		awful.button(
			{},
			3,
			function()
				mymainmenu:toggle()
			end
		)
	)
)
-- }}}

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = hotkeys.clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_offscreen,
			size_hints_honor = false
		}
	},
	{
		rule_any = {type = {"dialog", "normal"}},
		properties = {titlebars_enabled = true}
	},
	{
		rule = {class = "feh"},
		properties = {floating = true}
	},
	{
		rule = {class = "TeamViewer"},
		properties = {floating = true}
	},
	{
		rule = {class = "Pavucontrol"},
		properties = {floating = true}
	},
}
-- }}}

-- Signal function to execute when a new client appears.
client.connect_signal(
	"manage",
	function(c)
		if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
			-- Prevent clients from being unreachable after screen count changes.
			awful.placement.no_offscreen(c)
		end

		-- c.shape = function(cr, w, h)
		-- 	gears.shape.rounded_rect(cr, w, h, 6)
		-- end
	end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
	"request::titlebars",
	function(c)
		-- Custom
		if beautiful.titlebar_fun then
			beautiful.titlebar_fun(c)
			return
		end

		-- Default
		-- buttons for the titlebar
		local buttons =
			awful.util.table.join(
			awful.button(
				{},
				1,
				function()
					client.focus = c
					c:raise()
					awful.mouse.client.move(c)
				end
			),
			awful.button(
				{},
				3,
				function()
					client.focus = c
					c:raise()
					awful.mouse.client.resize(c)
				end
			)
		)

		awful.titlebar(c, {size = 35}):setup {
			nil,
			{
				-- Middle
				{
					-- Title
					align = "center",
					widget = awful.titlebar.widget.titlewidget(c)
				},
				buttons = buttons,
				layout = wibox.layout.flex.horizontal
			},
			nil,
			layout = wibox.layout.align.horizontal
		}
	end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
	"mouse::enter",
	function(c)
		if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
			client.focus = c
		end
	end
)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- }}}
-- vim: set ts=2 sw=2 noet:
