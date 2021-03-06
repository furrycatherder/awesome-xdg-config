local awful = require "awful"
local wibox = require "wibox"
local gears = require "gears"
local xrdb  = require "beautiful.xresources".get_current_theme()
local lain  = require "lain"
local markup = lain.util.markup
local separators = lain.util.separators

local wallpaper = os.getenv "HOME" .. "/.config/wpg/.current"
gears.wallpaper.maximized(wallpaper)

local theme = {}
theme.useless_gap = 4
theme.snapper_gap = theme.useless_gap

theme.font = "greentea 8"
theme.icon_font = "siji 8"
theme.taglist_font = "greentea 8"
theme.titlebar_font = "greentea 8"
theme.hotkeys_font = "sans-serif bold 11"
theme.hotkeys_description_font = "sans-serif italic 11"

theme.bg_normal = "alpha"
theme.bg_focus = xrdb.background
theme.bg_urgent = xrdb.color1
theme.fg_normal = xrdb.foreground
theme.fg_focus = xrdb.foreground
theme.fg_urgent = xrdb.foreground

theme.titlebar_height = 24
theme.titlebar_bg_normal = xrdb.background
theme.titlebar_bg_focus = xrdb.color8
theme.titlebar_fg_normal = xrdb.foreground
theme.titlebar_fg_focus = theme.fg_normal

theme.border_width = 2
theme.border_normal = xrdb.color0
theme.border_focus = xrdb.color8

theme.hotkeys_group_margin = 20
theme.hotkeys_border_width = 2
theme.hotkeys_bg = xrdb.background
theme.hotkeys_fg = xrdb.foreground
theme.hotkeys_modifiers_fg = xrdb.color5
theme.hotkeys_border_color = xrdb.foreground

theme.menu_submenu_icon = ""
theme.menu_height = 18
theme.menu_width = 130
theme.menu_border_width = 1
theme.menu_bg_normal = xrdb.background
theme.menu_bg_focus = xrdb.color6
theme.menu_fg_normal = theme.fg_focus
theme.menu_fg_focus = theme.fg_normal

theme.prompt_bg = xrdb.color0
theme.prompt_fg = xrdb.color7

theme.notification_bg = xrdb.color6
theme.notification_fg = theme.fg_normal

theme.tasklist_align = "center"
theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = true
theme.tasklist_spacing = theme.useless_gap
theme.tasklist_shape_border_width = 1
theme.tasklist_shape_border_width_focus = 1
theme.tasklist_bg_normal = xrdb.background
theme.tasklist_bg_focus = xrdb.color5
theme.tasklist_bg_minimize = xrdb.background
theme.tasklist_fg_normal = xrdb.foreground
theme.tasklist_fg_focus = xrdb.background
theme.tasklist_fg_minimize = xrdb.foreground
theme.tasklist_shape = gears.shape.rectangle
theme.tasklist_shape_border_color = xrdb.color0
theme.tasklist_shape_border_color_focus = xrdb.color8

theme.titlebar = function(c, buttons)
	client_tags = awful.widget.taglist(screen.primary, function(t)
		-- Return true if t is in client_tags.
		curtags = c:tags()
		for _, tag in pairs(curtags) do
			if t == tag then
				return true
			end
		end

		return false
	end)

	awful.titlebar(c, {size = theme.titlebar_height}):setup {
		client_tags,
		{
			{
				align = "center",
				font = theme.titlebar_font,
				widget = awful.titlebar.widget.titlewidget(c)
			},
			buttons = buttons(c),
			layout = wibox.layout.flex.horizontal
		},
		nil,
		layout = wibox.layout.align.horizontal
	}
end

screen.primary.padding = {
	left = 10,
	right = 10,
	top = 0,
	bottom = 0
}

theme.setup = function(s)
	-- FIXME: We need to build up an inverse index to remove widgets by
	-- name?
	mpd = lain.widget.mpd {
		settings = function()
			mpd_notification_preset.fg = xrdb.foreground
			mpd_notification_preset.bg = xrdb.background
			artist = mpd_now.artist
			title = mpd_now.title

			format = title .. "  –  " .. artist

			if mpd_now.state == "play" then
				widget:set_markup(markup.font(theme.font,
					markup(theme.fg_normal, format)))
				if not mpd_widget:get_visible() then
					table.insert(active_widgets, 1,
						mpd_widget)
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
	mpd_icon = wibox.widget.textbox ""
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

			widget:set_markup(markup.font(theme.font,
				markup(theme.fg_normal, vlevel)))
			volume_widget:set_visible(true)
		end
	}
	volume_icon = wibox.widget.textbox ""
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
			widget:set_markup(markup.font(theme.font, coretemp_now
				.. " °C"))
		end
	}
	temperature_icon = wibox.widget.textbox ""
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
			widget:set_markup(markup.font(theme.font, bat_now.perc
				.. "%"))
		end
	}
	battery_icon = wibox.widget.textbox ""
	battery_icon.font = theme.icon_font
	battery_widget = wibox.widget {
		layout = wibox.layout.fixed.horizontal,
		spacing = 4,
		battery_icon,
		battery.widget
	}

	clock_icon = wibox.widget.textbox ""
	clock_icon.font = theme.icon_font
	clock = wibox.widget.textclock "%-m/%-d %H:%M"
	clock_widget = wibox.widget {
		layout = wibox.layout.fixed.horizontal,
		spacing = 4,
		clock_icon,
		clock
	}

	s.bar = awful.wibar {
		screen = s,
		position = "top",
		height = 28,
		width = (1 / 2) * s.geometry.width - 2 * theme.snapper_gap
	}

	s.bar.y = s.bar.y + theme.snapper_gap
	bar_struts = s.bar:struts()
	s.bar:struts {
		top = bar_struts.top + theme.snapper_gap
	}

	s.tasklist = awful.widget.tasklist(s,
		awful.widget.tasklist.filter.currenttags)

	-- Table containing active widgets. Widgets should remove themselves
	-- (in an inverted way?) (use remove_widgets) from the table when
	-- they're not visible.
	active_widgets = {
		layout = wibox.layout.fixed.horizontal,
		spacing = 12,
	}
	table.insert(active_widgets, volume_widget)
	table.insert(active_widgets, temperature_widget)
	table.insert(active_widgets, clock_widget)

	update_active_widgets = function()
		status_widgets = wibox.container.margin(
			wibox.container.background(
				wibox.container.margin(
					wibox.widget(active_widgets),
					12, 12, 0, 0),
				xrdb.background),
			0, 0, 0, 1,
			theme.fg_normal)

		s.bar:setup {
			s.tasklist,
			nil,
			status_widgets,
			layout = wibox.layout.align.horizontal
		}
	end
	update_active_widgets()
end

return theme
