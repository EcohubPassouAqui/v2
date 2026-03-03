local ecohub = loadstring(game:HttpGet("https://raw.githubusercontent.com/EcohubPassouAqui/v2/refs/heads/main/Interface%20V1/Librarys.lua"))()

local UI = ecohub:CreateWindow("ecohub", "v1.0")

local Home = UI:addPage("Home", "home")
local General = Home:addSection("General")

General:addLabel("General options")
General:addParagraph("About", "Configure your general settings below. Changes apply instantly.")
General:addSeparator()

General:addButton("Click here", function()
    print("Button clicked!")
end)

local myToggle = General:addToggle("Enable something", false, function(state)
    print("Toggle state:", state)
end)

local myCheck = General:addCheck("Enable check", false, function(state)
    print("Check state:", state)
end)

local mySlider = General:addSlider("Speed", 0, 100, 50, function(value)
    print("Slider value:", value)
end)

local myTextBox = General:addTextBox("Name", "Type here...", function(text)
    print("TextBox text:", text)
end)

local myDropdown = General:addDropdown("Mode", {"Option 1", "Option 2", "Option 3"}, function(selected)
    print("Dropdown selected:", selected)
end)

local myKeybind = General:addKeybind("Action key", Enum.KeyCode.F, function(key)
    print("Keybind pressed:", key)
end)

local myColor = General:addColorPicker("ESP Color", Color3.fromRGB(255, 0, 0), function(color)
    print("Color selected:", color)
end)

local Combat = UI:addPage("Combat", "sword")
local CombatSec = Combat:addSection("Combat Settings")

CombatSec:addLabel("Aimbot options")
CombatSec:addParagraph("Warning", "Use these features responsibly. May affect gameplay.")
CombatSec:addSeparator()

local aimbotToggle = CombatSec:addToggle("Aimbot", false, function(state)
    print("Aimbot state:", state)
end)

local aimbotCheck = CombatSec:addCheck("Silent Aim", false, function(state)
    print("Silent Aim state:", state)
end)

local fovSlider = CombatSec:addSlider("FOV", 10, 500, 100, function(value)
    print("FOV value:", value)
end)

local smoothSlider = CombatSec:addSlider("Smooth", 1, 100, 20, function(value)
    print("Smooth value:", value)
end)

local hitboxDropdown = CombatSec:addDropdown("Hitbox", {"Head", "Body", "Nearest"}, function(sel)
    print("Hitbox selected:", sel)
end)

local aimKeybind = CombatSec:addKeybind("Aimbot key", Enum.KeyCode.Q, function(key)
    print("Aimbot key pressed:", key)
end)

local aimColor = CombatSec:addColorPicker("Aimbot Color", Color3.fromRGB(255, 50, 50), function(color)
    print("Aimbot color:", color)
end)

local Visual = UI:addPage("Visual", "eye")
local VisualSec = Visual:addSection("Visual Settings")

VisualSec:addLabel("ESP options")
VisualSec:addParagraph("ESP Info", "Renders players through walls. Adjust colors and distance below.")
VisualSec:addSeparator()

local espToggle = VisualSec:addToggle("Player ESP", false, function(state)
    print("ESP state:", state)
end)

local espCheck = VisualSec:addCheck("Show Name", false, function(state)
    print("Show Name state:", state)
end)

local espColor = VisualSec:addColorPicker("ESP Color", Color3.fromRGB(255, 255, 255), function(color)
    print("ESP color:", color)
end)

local transparencySlider = VisualSec:addSlider("Transparency", 0, 100, 0, function(value)
    print("Transparency value:", value)
end)

local distanceSlider = VisualSec:addSlider("Max Distance", 0, 1000, 500, function(value)
    print("Distance value:", value)
end)

local espTextBox = VisualSec:addTextBox("ESP Tag", "e.g. [ESP]", function(text)
    print("ESP tag:", text)
end)

local espDropdown = VisualSec:addDropdown("Style", {"Box", "Corner", "Skeleton"}, function(sel)
    print("ESP style:", sel)
end)

local Misc = UI:addPage("Misc", "settings")
local MiscSec = Misc:addSection("Miscellaneous")

MiscSec:addLabel("Utility tools")
MiscSec:addParagraph("Misc Info", "Extra tools and settings for convenience.")
MiscSec:addSeparator()

MiscSec:addButton("Teleport Lobby", function()
    print("Teleporting...")
end)

local autoRejoinToggle = MiscSec:addToggle("Auto rejoin", false, function(state)
    print("Auto rejoin:", state)
end)

local miscCheck = MiscSec:addCheck("No clip", false, function(state)
    print("No clip:", state)
end)

local toggleKeybind = MiscSec:addKeybind("Toggle GUI", Enum.KeyCode.RightAlt, function()
    print("GUI toggled via keybind")
end)

local customTag = MiscSec:addTextBox("Custom Tag", "Your text...", function(text)
    print("Tag typed:", text)
end)

local miscSlider = MiscSec:addSlider("Notification time", 1, 10, 3, function(value)
    print("Notif time:", value)
end)

local miscDropdown = MiscSec:addDropdown("Language", {"English", "Portuguese", "Spanish"}, function(sel)
    print("Language:", sel)
end)

local miscColor = MiscSec:addColorPicker("UI Accent", Color3.fromRGB(100, 140, 255), function(color)
    print("Accent color:", color)
end)
