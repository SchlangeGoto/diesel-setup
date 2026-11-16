hl.config({
	input = {
		kb_layout = "de",
	},
})
hl.monitor({
	output = "eDP-1",
	mode = "2880x1620@120",
	position = "0x470",
	scale = 1.67,
})
hl.on("hyprland.start", function()
	-- Keep clipboard content alive after source app closes
	hl.exec_cmd("wl-clip-persist --clipboard regular")

	-- Auto-mount removable media
	hl.exec_cmd("udiskie --tray")
end)
hl.window_rule({
	float = true,
	match = {
		class = "^(jetbrains-.*)$",
		title = "^(win.*)$",
	},
})
hl.window_rule({
	no_initial_focus = true,
	match = {
		class = "^(jetbrains-.*)$",
		title = "^(win.*)$",
	},
})
hl.window_rule({
	no_initial_focus = true,
	match = {
		class = "^(jetbrains-.*)$",
		title = "^$",
	},
})
