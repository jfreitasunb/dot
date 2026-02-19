-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 12
config.color_scheme = "Tokyo Night"

config.default_cursor_style = "BlinkingBlock"

-- config.window_decorations = "RESIZE"
config.enable_tab_bar = false

-- Sets the font for the window frame (tab bar)
config.window_frame = {
	-- Berkeley Mono for me again, though an idea could be to try a
	-- serif font here instead of monospace for a nicer look?
	font = wezterm.font({ family = "JetBrains Mono", weight = "Bold" }),
	font_size = 11,
}
-- config.swap_backspace_and_delete = true,
-- Finally, return the configuration to wezterm:
return config
