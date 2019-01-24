--
--   ██████   ███     ██  █████   ██████  ██████  ██████████   █████
--  ░░░░░░██ ░░██  █ ░██ ██░░░██ ██░░░░  ██░░░░██░░██░░██░░██ ██░░░██
--   ███████  ░██ ███░██░███████░░█████ ░██   ░██ ░██ ░██ ░██░███████
--  ██░░░░██  ░████░████░██░░░░  ░░░░░██░██   ░██ ░██ ░██ ░██░██░░░░
-- ░░████████ ███░ ░░░██░░██████ ██████ ░░██████  ███ ░██ ░██░░██████
--  ░░░░░░░░ ░░░    ░░░  ░░░░░░ ░░░░░░   ░░░░░░  ░░░  ░░  ░░  ░░░░░░
--

require "errors"
local awful = require "awful"
local beautiful = require "beautiful"
local naughty = require "naughty"

local theme = require "theme"
beautiful.init(theme)
awful.screen.connect_for_each_screen(function(s) beautiful.setup(s) end)

awful.util.terminal = "urxvt" or "st" or "xterm"
awful.util.browser = "firefox"
awful.util.tagnames = {"1", "2", "3", "4", "5"}
awful.layout.layouts = {
	awful.layout.suit.fair,
	awful.layout.suit.tile,
	awful.layout.suit.magnifier,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.floating,
}
awful.mouse.snap.default_distance = 16

awful.tag(awful.util.tagnames, screen.primary, awful.layout.layouts)

-- XXX: hotkeys depends on the number of tag instances.
local hotkeys = require "hotkeys"
root.keys(hotkeys.root)

local buttons = require "buttons"
root.buttons(buttons.root)

-- Show the current layout as a notification upon switching.
prev_notification = nil
tag.connect_signal("property::layout", function(t)
	local layout = awful.layout.getname(t.layout)
	local prev_id = nil

	if prev_notification then
		prev_id = prev_notification.id
	end

	local cur_notification = naughty.notify {
		text = layout,
		position = "top_middle",
		font = "sans-serif 24",
		replaces_id = prev_id,
		margin = 12,
		timeout = 2,
	}
	prev_notification = cur_notification
end)

-- Enable autofocus and focus follows mouse.
require "ffm"
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Add a titlebar to each client if titlebars_enabled is set to true in the
-- rules.
client.connect_signal("request::titlebars", function(c)
	beautiful.titlebar(c, buttons.titlebar)
end)

awful.rules.rules = {
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = hotkeys.client,
			buttons = buttons.client,
			screen = awful.screen.preferred,
			placement = awful.placement.no_offscreen,
			size_hints_honor = false,
		}
	},
	{
		rule_any = {type = {"dialog", "normal"}},
		properties = {titlebars_enabled = true}
	},
	{rule = {class = "Pavucontrol"}, properties = {floating = true}},
	{rule = {class = "TeamViewer"},  properties = {floating = true}},
	{rule = {class = "Firefox"},     properties = {titlebars_enabled = false}},
	{rule = {class = "feh"},         properties = {floating = true} },
}
