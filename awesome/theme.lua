local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local xrdb = require("beautiful.xresources").get_current_theme()
local lain = require("lain")
local naughty = require("naughty")

local markup = lain.util.markup
local separators = lain.util.separators

local theme = {}

theme.dir = awful.util.get_configuration_dir()
theme.font = "sans-serif 8"
theme.icon_font = "wuncon siji 8"

theme.bg_normal = "alpha"
theme.bg_focus = xrdb.background
theme.bg_urgent = xrdb.color3
theme.fg_normal = xrdb.background
theme.fg_focus = xrdb.foreground
theme.fg_urgent = xrdb.foreground

theme.useless_gap = 4
theme.snapper_gap = theme.useless_gap
awful.mouse.snap.default_distance = 16

theme.titlebar_bg_normal = xrdb.background
theme.titlebar_bg_focus = xrdb.foreground
theme.titlebar_fg_normal = xrdb.foreground
theme.titlebar_fg_focus = xrdb.background
theme.titlebar_font = "notype greentea 8"

theme.border_width = 2
theme.border_normal = theme.titlebar_bg_focus
theme.border_focus = theme.titlebar_bg_focus

theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = true
theme.tasklist_fg_minimize = xrdb.foreground
theme.tasklist_bg_minimize = xrdb.background
theme.tasklist_fg_normal = xrdb.foreground
theme.tasklist_bg_normal = xrdb.background
theme.tasklist_fg_focus = xrdb.background
theme.tasklist_bg_focus = xrdb.color5
theme.tasklist_align = "center"
theme.tasklist_spacing = theme.useless_gap

theme.hotkeys_bg = xrdb.background
theme.hotkeys_fg = xrdb.foreground
theme.hotkeys_modifiers_fg = xrdb.color5
theme.hotkeys_font = "sans-serif bold 14"
theme.hotkeys_description_font = "sans-serif 14"
theme.hotkeys_group_margin = 20
theme.hotkeys_border_width = 2
theme.hotkeys_border_color = xrdb.foreground

theme.menu_height = 18
theme.menu_width = 130
theme.menu_bg_normal = xrdb.background
theme.menu_fg_normal = xrdb.foreground
theme.menu_bg_focus = xrdb.color6
theme.menu_fg_focus = xrdb.background
theme.menu_border_width = 2
theme.menu_submenu_icon = ""

theme.prompt_bg = xrdb.color0
theme.prompt_fg = xrdb.color7

theme.notification_bg = xrdb.background
theme.notification_fg = xrdb.foreground

function theme.setup(s)
	s.padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10
	}

	-- TODO: Put this in a module.
	awful.tag(awful.util.tagnames, s, awful.layout.layouts)

	-- Bind all key numbers to tags.
	-- Be careful: we use keycodes to make it works on any keyboard layout.
	-- This should map on the top row of your keyboard, usually 1 to 9.
	for i = 1, tag:instances() do
		rootkeys = awful.util.table.join(
			rootkeys,
			-- View tag only.
			awful.key({"Mod4"}, "#" .. i + 9,
				function()
					local screen = awful.screen.focused()
					local tag = screen.tags[i]
					if tag then
						tag:view_only()
					end
				end,
				{description = "view tag #" .. i, group = "tag"}),

			-- Toggle tag display.
			awful.key({"Mod4", "Control"}, "#" .. i + 9,
				function()
					local screen = awful.screen.focused()
					local tag = screen.tags[i]
					if tag then
						awful.tag.viewtoggle(tag)
					end
				end,
				{description = "toggle tag #" .. i, group = "tag"}),

			-- Move client to tag.
			awful.key({"Mod4", "Shift"}, "#" .. i + 9,
				function()
					if client.focus then
						local tag = client.focus.screen.tags[i]
						if tag then
							client.focus:move_to_tag(tag)
						end
					end
				end,
				{description = "move focused client to tag #" .. i, group = "tag"}),

			-- Toggle tag on focused client.
			awful.key({"Mod4", "Control", "Shift"}, "#" .. i + 9,
				function()
					if client.focus then
						local tag = client.focus.screen.tags[i]
						if tag then
							client.focus:toggle_tag(tag)
						end
					end
				end,
				{description = "toggle focused client on tag #" .. i, group = "tag"})
			)
	end

	-- TODO: Put this in a module.
	prev_notification = nil
	tag.connect_signal("property::layout", function(t)
			local layout = awful.layout.getname(t.layout)
			local prev_id

			if prev_notification == nil then
				prev_id = nil
			else
				prev_id = prev_notification.id
			end

			local cur_notification = naughty.notify {
				text = layout,
				position = "top_middle",
				font = "sans-serif 32",
				replaces_id = prev_id,
				margin = 20,
			}
			prev_notification = cur_notification
	end)

	-- TODO: Add buttons back?
	s.tasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags)

	-- FIXME: We need to build up an inverse index to remove widgets by name.
	mpd = lain.widget.mpd {
		settings = function()
			mpd_notification_preset.fg = xrdb.foreground
			mpd_notification_preset.bg = xrdb.background
			artist = mpd_now.artist
			title = mpd_now.title

			format = title .. "  –  " .. artist

			if mpd_now.state == "play" then
				widget:set_markup(markup.font(theme.font, markup(theme.fg_normal, format)))
				if not mpd_widget:get_visible() then
					table.insert(active_widgets, 1, mpd_widget)
					mpd_widget:set_visible(true)
					update_active_widgets()
				end
			else
				if mpd_widget:get_visible() then
					table.remove(active_widgets, 1)
					mpd_widget:set_visible(false)
					update_active_widgets()
				end
			end
		end
	}
	mpd_icon = wibox.widget.textbox(markup(theme.fg_normal, ""))
	mpd_icon.font = theme.icon_font
	mpd_widget = wibox.widget {
		layout = wibox.layout.fixed.horizontal,
		spacing = 4,
		mpd_icon,
		mpd.widget
	}
	mpd_widget:set_visible(false)

	volume = lain.widget.alsa {
		settings = function()
			header = ""
			vlevel = volume_now.level

			if volume_now.status == "off" then
				vlevel = vlevel .. "M "
			else
				vlevel = vlevel .. "%"
			end

			widget:set_markup(markup.font(theme.font, markup(theme.fg_normal, vlevel)))
			volume_widget:set_visible(true)
		end
	}
	volume_icon = wibox.widget.textbox(markup(theme.fg_normal, ""))
	volume_icon.font = theme.icon_font
	volume_widget = wibox.widget {
		layout = wibox.layout.fixed.horizontal,
		spacing = 4,
		volume_icon,
		volume.widget
	}
	volume_widget:set_visible(false)

	temperature = lain.widget.temp {
		settings = function()
			widget:set_markup(markup.font(theme.font, coretemp_now .. " °C"))
		end
	}
	temperature_icon = wibox.widget.textbox("")
	temperature_icon.font = theme.icon_font
	temperature_widget = wibox.widget {
		layout = wibox.layout.fixed.horizontal,
		spacing = 4,
		temperature_icon,
		temperature.widget
	}

	battery = lain.widget.bat {
		battery = "BAT0",
		settings = function()
			widget:set_markup(markup.font(theme.font, bat_now.perc .. "%"))
		end
	}
	battery_icon = wibox.widget.textbox("")
	battery_icon.font = theme.icon_font
	battery_widget = wibox.widget {
		layout = wibox.layout.fixed.horizontal,
		spacing = 4,
		battery_icon,
		battery.widget
	}

	clock_icon = wibox.widget.textbox("")
	clock_icon.font = theme.icon_font
	clock = wibox.widget.textclock("%-m/%-d %H:%M", 1)
	clock_widget = wibox.widget {
		layout = wibox.layout.fixed.horizontal,
		spacing = 4,
		clock_icon,
		clock
	}

	-- Create the wibox
	s.bar =
		awful.wibar {
		screen = s,
		position = "top",
		height = 30,
		width = s.geometry.width - 2 * theme.snapper_gap
	}

	s.bar.y = s.bar.y + theme.snapper_gap
	bar_struts = s.bar:struts()
	s.bar:struts {
		top = bar_struts.top + theme.snapper_gap
	}

	-- Table containing active widgets. Widgets should remove themselves (in an
	-- inverted way?) from the table when they're not visible.
	active_widgets = {
		layout = wibox.layout.fixed.horizontal,
		spacing = 12,
	}
	table.insert(active_widgets, temperature_widget)
	table.insert(active_widgets, battery_widget)
	table.insert(active_widgets, clock_widget)

	update_active_widgets = function()
		s.status = wibox.widget(active_widgets)
		s.bar:setup {
			layout = wibox.layout.align.horizontal,
			-- s.tasklist,
			nil,
			nil,
			wibox.container.background(wibox.container.margin(s.status, 12, 12, 0, 0),
				xrdb.foreground),
		}
	end
	update_active_widgets()
end

return theme

-- vim: set ts=2 sw=2 noet:
