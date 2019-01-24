-- Enable focus follow mouse (FFM), where the focus automatically follows the
-- current placement of the mouse pointer.
awful = require("awful")
require("awful.autofocus")

client.connect_signal("mouse::enter", function(c)
	if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
		and awful.client.focus.filter(c) then
		client.focus = c
	end
end)
