local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/EcohubPassouAqui/v2/refs/heads/main/Interface%20V1/Librarys.lua"))()

local gameName = "[ Eco Hub ]"
pcall(function()
	local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
	if info and info.Name then gameName = info.Name end
end)

local Window = lib:CreateWindow({
	Title    = gameName,
	Subtitle = "v1.0",
})

local tabChams = Window:AddTab({
	Section = "Visuals",
	Title   = "Chams",
	Icon    = "eye",
})

local tabBox = Window:AddTab({
	Section = "Visuals",
	Title   = "Box ESP",
	Icon    = "box",
})

local tabVida = Window:AddTab({
	Section = "Visuals",
	Title   = "Health",
	Icon    = "heart",
})

local tabTraces = Window:AddTab({
	Section = "Visuals",
	Title   = "Traces",
	Icon    = "git-commit",
})

local tabLocalPlayer = Window:AddTab({
	Section = "Visuals",
	Title   = "Local Player",
	Icon    = "user",
})

local tabArmas = Window:AddTab({
	Section = "Visuals",
	Title   = "Weapons",
	Icon    = "crosshair",
})

local tabSettings = Window:AddTab({
	Section = "General",
	Title   = "Settings",
	Icon    = "settings",
})

tabChams:AddSection("Chams Settings")

tabChams:AddToggle("Enable Chams", false, function(v)

end, "chams_enabled")

tabChams:AddColorPicker("Chams Color", Color3.fromRGB(255, 80, 80), function(v)

end, "chams_color")

tabChams:AddDropdown("Chams Type", {"Filled", "Wireframe", "Outline"}, "Filled", function(v)

end, "chams_type")

tabChams:AddSlider("Transparency", 0, 100, 50, function(v)

end, "chams_transparency")

tabChams:AddSection("Chams Style")

tabChams:AddCheckbox("Apply to Enemies", true, function(v)

end, "chams_enemies")

tabChams:AddCheckbox("Apply to Teammates", false, function(v)

end, "chams_teammates")

tabChams:AddColorPicker("Teammate Color", Color3.fromRGB(80, 180, 255), function(v)

end, "chams_team_color")

tabBox:AddSection("Box ESP Settings")

tabBox:AddToggle("Enable Box ESP", false, function(v)

end, "box_enabled")

tabBox:AddColorPicker("Box Color", Color3.fromRGB(255, 255, 255), function(v)

end, "box_color")

tabBox:AddDropdown("Box Type", {"2D", "3D", "Corner"}, "2D", function(v)

end, "box_type")

tabBox:AddSlider("Thickness", 1, 5, 1, function(v)

end, "box_thickness")

tabBox:AddSection("Box Style")

tabBox:AddCheckbox("Filled Box", false, function(v)

end, "box_filled")

tabBox:AddSlider("Fill Transparency", 0, 100, 80, function(v)

end, "box_fill_transparency")

tabBox:AddColorPicker("Fill Color", Color3.fromRGB(255, 255, 255), function(v)

end, "box_fill_color")

tabVida:AddSection("Health Bar Settings")

tabVida:AddToggle("Enable Health Bar", false, function(v)

end, "hp_enabled")

tabVida:AddDropdown("Position", {"Left", "Right", "Top", "Bottom"}, "Left", function(v)

end, "hp_position")

tabVida:AddColorPicker("Color (High HP)", Color3.fromRGB(80, 220, 80), function(v)

end, "hp_color_high")

tabVida:AddColorPicker("Color (Low HP)", Color3.fromRGB(220, 60, 60), function(v)

end, "hp_color_low")

tabVida:AddToggle("Show Number", false, function(v)

end, "hp_show_number")

tabVida:AddSection("Health Bar Style")

tabVida:AddSlider("Bar Width", 1, 6, 2, function(v)

end, "hp_bar_width")

tabVida:AddSlider("Bar Height", 20, 80, 40, function(v)

end, "hp_bar_height")

tabVida:AddCheckbox("Show Background", true, function(v)

end, "hp_show_bg")

tabTraces:AddSection("Traces Settings")

tabTraces:AddToggle("Enable Traces", false, function(v)

end, "traces_enabled")

tabTraces:AddColorPicker("Traces Color", Color3.fromRGB(255, 255, 0), function(v)

end, "traces_color")

tabTraces:AddDropdown("Origin", {"Center", "Top", "Bottom"}, "Bottom", function(v)

end, "traces_origin")

tabTraces:AddSlider("Thickness", 1, 5, 1, function(v)

end, "traces_thickness")

tabTraces:AddSection("Traces Style")

tabTraces:AddCheckbox("Enemies Only", true, function(v)

end, "traces_enemies_only")

tabTraces:AddSlider("Max Distance", 50, 2000, 1000, function(v)

end, "traces_max_distance")

tabLocalPlayer:AddSection("Crosshair")

tabLocalPlayer:AddToggle("Custom Crosshair", false, function(v)

end, "crosshair_enabled")

tabLocalPlayer:AddColorPicker("Crosshair Color", Color3.fromRGB(255, 255, 255), function(v)

end, "crosshair_color")

tabLocalPlayer:AddDropdown("Crosshair Style", {"Cross", "Dot", "Circle", "T-Shape"}, "Cross", function(v)

end, "crosshair_style")

tabLocalPlayer:AddSlider("Size", 5, 30, 10, function(v)

end, "crosshair_size")

tabLocalPlayer:AddSlider("Gap", 0, 20, 4, function(v)

end, "crosshair_gap")

tabLocalPlayer:AddCheckbox("Show Center Dot", false, function(v)

end, "crosshair_dot")

tabLocalPlayer:AddSection("Field of View")

tabLocalPlayer:AddToggle("Show FOV", false, function(v)

end, "fov_enabled")

tabLocalPlayer:AddSlider("FOV Radius", 50, 500, 150, function(v)

end, "fov_radius")

tabLocalPlayer:AddColorPicker("FOV Color", Color3.fromRGB(255, 255, 255), function(v)

end, "fov_color")

tabLocalPlayer:AddCheckbox("Filled FOV", false, function(v)

end, "fov_filled")

tabLocalPlayer:AddSlider("FOV Transparency", 0, 100, 60, function(v)

end, "fov_transparency")

tabArmas:AddSection("Weapon Labels")

tabArmas:AddToggle("Weapon Name", false, function(v)

end, "weapon_name_enabled")

tabArmas:AddToggle("Show Distance", false, function(v)

end, "weapon_dist_enabled")

tabArmas:AddColorPicker("Text Color", Color3.fromRGB(220, 220, 220), function(v)

end, "weapon_text_color")

tabArmas:AddSlider("Text Size", 8, 20, 12, function(v)

end, "weapon_text_size")

tabArmas:AddDropdown("Text Alignment", {"Center", "Left", "Right"}, "Center", function(v)

end, "weapon_text_align")

tabArmas:AddSection("Dropped Weapons")

tabArmas:AddToggle("Dropped Weapon ESP", false, function(v)

end, "dropped_weapon_esp")

tabArmas:AddColorPicker("Dropped Color", Color3.fromRGB(255, 200, 50), function(v)

end, "dropped_weapon_color")

tabArmas:AddSlider("Max Pickup Distance", 10, 200, 60, function(v)

end, "dropped_weapon_maxdist")

tabArmas:AddCheckbox("Show Ammo Count", false, function(v)

end, "dropped_weapon_ammo")

tabSettings:AddSection("Interface")

tabSettings:AddKeybind("Toggle UI", Enum.KeyCode.RightAlt, function(v)

end, "ui_toggle_key")

tabSettings:AddToggle("Notifications", true, function(v)

end, "settings_notifs")

tabSettings:AddDropdown("Language", {"English", "Portuguese", "Spanish"}, "English", function(v)

end, "settings_language")

tabSettings:AddSlider("UI Scale", 50, 150, 100, function(v)

end, "settings_ui_scale")

tabSettings:AddSection("Performance")

tabSettings:AddSlider("Update Rate", 1, 60, 30, function(v)

end, "settings_update_rate")

tabSettings:AddCheckbox("Optimize Rendering", true, function(v)

end, "settings_optimize")

tabSettings:AddSection("Reset")

tabSettings:AddButton("Reset All Settings", function()

end)
