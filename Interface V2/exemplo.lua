local V2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/EcohubPassouAqui/v2/refs/heads/main/Interface%20V2/Librarys.lua"))()

local gameName = "EcoHub"
pcall(function()
	local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
	if info and info.Name then gameName = info.Name end
end)

local win = V2.new({
	Title  = gameName,
	Logo   = "rbxassetid://134382458890933",
	Toggle = Enum.KeyCode.LeftAlt,
})

-- // TAB 1 - COMBAT
local TabCombat = win:AddTab({
	Name = "Combat",
	Sub  = "Aim & Fire",
	Icon = "crosshair",
})

local CL = TabCombat:AddSection({ Side = "Left",   Title = "Aimbot",     Icon = "target"  })
local CC = TabCombat:AddSection({ Side = "Center", Title = "Prediction", Icon = "gauge"   })
local CR = TabCombat:AddSection({ Side = "Right",  Title = "Auto Fire",  Icon = "zap"     })

CL:AddToggle({
	Name     = "Enable Aimbot",
	SaveId   = "aimbot_enable",
	Default  = false,
	Callback = function(v) print("[Combat] Aimbot:", v) end,
})
CL:AddToggle({
	Name     = "Silent Aim",
	SaveId   = "aimbot_silent",
	Default  = false,
	Callback = function(v) print("[Combat] Silent:", v) end,
})
CL:AddSlider({
	Name     = "FOV",
	SaveId   = "aimbot_fov",
	Min      = 0,
	Max      = 360,
	Default  = 90,
	Suffix   = "°",
	Callback = function(v) print("[Combat] FOV:", v) end,
})
CL:AddSlider({
	Name     = "Smooth",
	SaveId   = "aimbot_smooth",
	Min      = 0,
	Max      = 100,
	Default  = 20,
	Callback = function(v) print("[Combat] Smooth:", v) end,
})
CL:AddDropdown({
	Name     = "Bone",
	SaveId   = "aimbot_bone",
	Options  = { "Head", "Neck", "Chest", "Pelvis", "LeftArm", "RightArm" },
	Default  = "Head",
	Callback = function(v) print("[Combat] Bone:", v) end,
})
CL:AddKeybind({
	Name     = "Aim Key",
	SaveId   = "aimbot_key",
	Default  = Enum.KeyCode.Q,
	Callback = function(k) print("[Combat] AimKey:", k) end,
})
CL:AddColorPicker({
	Name     = "FOV Color",
	SaveId   = "aimbot_fovcolor",
	Default  = Color3.fromRGB(160, 100, 255),
	Callback = function(c) print("[Combat] FOVColor:", c) end,
})
CL:AddButton({
	Name     = "Reset Aimbot",
	Callback = function() print("[Combat] Aimbot reset!") end,
})
CL:AddLabel({ Text = "Aimbot v2.0 loaded", Color = Color3.fromRGB(160, 100, 255) })
CL:AddParagraph({
	Title = "Info",
	Text  = "Aimbot with smooth, FOV and silent aim support.",
})

CC:AddToggle({
	Name     = "Enable Prediction",
	SaveId   = "pred_enable",
	Default  = true,
	Callback = function(v) print("[Combat] Prediction:", v) end,
})
CC:AddToggle({
	Name     = "Velocity Based",
	SaveId   = "pred_velocity",
	Default  = false,
	Callback = function(v) print("[Combat] Velocity:", v) end,
})
CC:AddSlider({
	Name     = "Predict Amount",
	SaveId   = "pred_amount",
	Min      = 0,
	Max      = 10,
	Default  = 3,
	Suffix   = "x",
	Callback = function(v) print("[Combat] PredictAmt:", v) end,
})
CC:AddSlider({
	Name     = "Gravity Comp",
	SaveId   = "pred_gravity",
	Min      = 0,
	Max      = 50,
	Default  = 10,
	Callback = function(v) print("[Combat] Gravity:", v) end,
})
CC:AddDropdown({
	Name     = "Method",
	SaveId   = "pred_method",
	Options  = { "Linear", "Velocity", "Advanced", "Hybrid" },
	Default  = "Linear",
	Callback = function(v) print("[Combat] Method:", v) end,
})
CC:AddKeybind({
	Name     = "Toggle Key",
	SaveId   = "pred_key",
	Default  = Enum.KeyCode.F,
	Callback = function(k) print("[Combat] PredKey:", k) end,
})
CC:AddColorPicker({
	Name     = "Highlight",
	SaveId   = "pred_highlight",
	Default  = Color3.fromRGB(255, 100, 100),
	Callback = function(c) print("[Combat] Highlight:", c) end,
})
CC:AddButton({
	Name     = "Calibrate",
	Callback = function() print("[Combat] Calibrating...") end,
})
CC:AddLabel({ Text = "Experimental feature", Color = Color3.fromRGB(255, 180, 60) })
CC:AddParagraph({
	Title = "Note",
	Text  = "Higher values may cause visual glitches on fast targets.",
})

CR:AddToggle({
	Name     = "Auto Fire",
	SaveId   = "autofire_enable",
	Default  = false,
	Callback = function(v) print("[Combat] AutoFire:", v) end,
})
CR:AddToggle({
	Name     = "Rapid Fire",
	SaveId   = "autofire_rapid",
	Default  = false,
	Callback = function(v) print("[Combat] RapidFire:", v) end,
})
CR:AddSlider({
	Name     = "Fire Rate",
	SaveId   = "autofire_rate",
	Min      = 1,
	Max      = 30,
	Default  = 10,
	Suffix   = "/s",
	Callback = function(v) print("[Combat] FireRate:", v) end,
})
CR:AddSlider({
	Name     = "Burst Count",
	SaveId   = "autofire_burst",
	Min      = 1,
	Max      = 10,
	Default  = 3,
	Callback = function(v) print("[Combat] Burst:", v) end,
})
CR:AddDropdown({
	Name     = "Mode",
	SaveId   = "autofire_mode",
	Options  = { "Single", "Burst", "Auto", "Shotgun" },
	Default  = "Single",
	Callback = function(v) print("[Combat] Mode:", v) end,
})
CR:AddKeybind({
	Name     = "Fire Key",
	SaveId   = "autofire_key",
	Default  = Enum.KeyCode.E,
	Callback = function(k) print("[Combat] FireKey:", k) end,
})
CR:AddColorPicker({
	Name     = "Tracer Color",
	SaveId   = "autofire_tracercolor",
	Default  = Color3.fromRGB(100, 200, 255),
	Callback = function(c) print("[Combat] Tracer:", c) end,
})
CR:AddButton({
	Name     = "Stop Firing",
	Callback = function() print("[Combat] Fire stopped!") end,
})
CR:AddLabel({ Text = "Use with caution!", Color = Color3.fromRGB(255, 80, 80) })
CR:AddParagraph({
	Title = "Warning",
	Text  = "Auto fire may be flagged by anti-cheat systems.",
})

-- // TAB 2 - VISUALS
local TabVisuals = win:AddTab({
	Name = "Visuals",
	Sub  = "ESP & Render",
	Icon = "eye",
})

local VL = TabVisuals:AddSection({ Side = "Left",   Title = "ESP",        Icon = "scanFace" })
local VC = TabVisuals:AddSection({ Side = "Center", Title = "Chams",      Icon = "layers"   })
local VR = TabVisuals:AddSection({ Side = "Right",  Title = "World",      Icon = "globe"    })

VL:AddToggle({
	Name     = "Enable ESP",
	SaveId   = "esp_enable",
	Default  = false,
	Callback = function(v) print("[Visuals] ESP:", v) end,
})
VL:AddToggle({
	Name     = "Show Names",
	SaveId   = "esp_names",
	Default  = true,
	Callback = function(v) print("[Visuals] Names:", v) end,
})
VL:AddToggle({
	Name     = "Show Health",
	SaveId   = "esp_health",
	Default  = true,
	Callback = function(v) print("[Visuals] Health:", v) end,
})
VL:AddToggle({
	Name     = "Show Distance",
	SaveId   = "esp_distance",
	Default  = false,
	Callback = function(v) print("[Visuals] Distance:", v) end,
})
VL:AddSlider({
	Name     = "Max Distance",
	SaveId   = "esp_maxdist",
	Min      = 50,
	Max      = 2000,
	Default  = 500,
	Suffix   = "m",
	Callback = function(v) print("[Visuals] MaxDist:", v) end,
})
VL:AddSlider({
	Name     = "Box Thickness",
	SaveId   = "esp_thickness",
	Min      = 1,
	Max      = 5,
	Default  = 1,
	Callback = function(v) print("[Visuals] Thickness:", v) end,
})
VL:AddDropdown({
	Name     = "Box Style",
	SaveId   = "esp_boxstyle",
	Options  = { "Full", "Corner", "3D", "None" },
	Default  = "Corner",
	Callback = function(v) print("[Visuals] BoxStyle:", v) end,
})
VL:AddKeybind({
	Name     = "Toggle ESP",
	SaveId   = "esp_key",
	Default  = Enum.KeyCode.Z,
	Callback = function(k) print("[Visuals] ESPKey:", k) end,
})
VL:AddColorPicker({
	Name     = "ESP Color",
	SaveId   = "esp_color",
	Default  = Color3.fromRGB(255, 50, 50),
	Callback = function(c) print("[Visuals] ESPColor:", c) end,
})
VL:AddButton({
	Name     = "Refresh ESP",
	Callback = function() print("[Visuals] ESP refreshed!") end,
})
VL:AddLabel({ Text = "ESP active on all players", Color = Color3.fromRGB(120, 120, 135) })
VL:AddParagraph({
	Title = "ESP Info",
	Text  = "Shows boxes, names, health and distance.",
})

VC:AddToggle({
	Name     = "Enable Chams",
	SaveId   = "chams_enable",
	Default  = false,
	Callback = function(v) print("[Visuals] Chams:", v) end,
})
VC:AddToggle({
	Name     = "Visible Only",
	SaveId   = "chams_visible",
	Default  = true,
	Callback = function(v) print("[Visuals] VisOnly:", v) end,
})
VC:AddToggle({
	Name     = "Team Check",
	SaveId   = "chams_team",
	Default  = true,
	Callback = function(v) print("[Visuals] TeamCheck:", v) end,
})
VC:AddSlider({
	Name     = "Transparency",
	SaveId   = "chams_trans",
	Min      = 0,
	Max      = 100,
	Default  = 50,
	Suffix   = "%",
	Callback = function(v) print("[Visuals] Trans:", v) end,
})
VC:AddDropdown({
	Name     = "Material",
	SaveId   = "chams_material",
	Options  = { "Neon", "Glass", "SmoothPlastic", "Metal" },
	Default  = "Neon",
	Callback = function(v) print("[Visuals] Material:", v) end,
})
VC:AddKeybind({
	Name     = "Toggle Chams",
	SaveId   = "chams_key",
	Default  = Enum.KeyCode.X,
	Callback = function(k) print("[Visuals] ChamsKey:", k) end,
})
VC:AddColorPicker({
	Name     = "Visible Color",
	SaveId   = "chams_vis_color",
	Default  = Color3.fromRGB(0, 255, 100),
	Callback = function(c) print("[Visuals] VisColor:", c) end,
})
VC:AddColorPicker({
	Name     = "Hidden Color",
	SaveId   = "chams_hid_color",
	Default  = Color3.fromRGB(255, 50, 50),
	Callback = function(c) print("[Visuals] HidColor:", c) end,
})
VC:AddButton({
	Name     = "Apply Chams",
	Callback = function() print("[Visuals] Chams applied!") end,
})
VC:AddLabel({ Text = "Chams render on players", Color = Color3.fromRGB(120, 120, 135) })
VC:AddParagraph({
	Title = "Chams Info",
	Text  = "Renders player models through walls.",
})

VR:AddToggle({
	Name     = "No Fog",
	SaveId   = "world_nofog",
	Default  = false,
	Callback = function(v) print("[Visuals] NoFog:", v) end,
})
VR:AddToggle({
	Name     = "Full Bright",
	SaveId   = "world_fullbright",
	Default  = false,
	Callback = function(v) print("[Visuals] FullBright:", v) end,
})
VR:AddToggle({
	Name     = "No Shadows",
	SaveId   = "world_noshadow",
	Default  = false,
	Callback = function(v) print("[Visuals] NoShadow:", v) end,
})
VR:AddSlider({
	Name     = "Brightness",
	SaveId   = "world_brightness",
	Min      = 0,
	Max      = 10,
	Default  = 2,
	Rounding = 0.5,
	Callback = function(v) print("[Visuals] Brightness:", v) end,
})
VR:AddSlider({
	Name     = "FoV Override",
	SaveId   = "world_fov",
	Min      = 40,
	Max      = 120,
	Default  = 70,
	Suffix   = "°",
	Callback = function(v) print("[Visuals] WorldFOV:", v) end,
})
VR:AddDropdown({
	Name     = "Sky Preset",
	SaveId   = "world_sky",
	Options  = { "Default", "Night", "Sunset", "Midnight", "Custom" },
	Default  = "Default",
	Callback = function(v) print("[Visuals] Sky:", v) end,
})
VR:AddKeybind({
	Name     = "Toggle Bright",
	SaveId   = "world_key",
	Default  = Enum.KeyCode.B,
	Callback = function(k) print("[Visuals] BrightKey:", k) end,
})
VR:AddColorPicker({
	Name     = "Ambient Color",
	SaveId   = "world_ambient",
	Default  = Color3.fromRGB(200, 200, 255),
	Callback = function(c) print("[Visuals] Ambient:", c) end,
})
VR:AddButton({
	Name     = "Reset World",
	Callback = function() print("[Visuals] World reset!") end,
})
VR:AddLabel({ Text = "World effects active", Color = Color3.fromRGB(120, 120, 135) })
VR:AddParagraph({
	Title = "World Info",
	Text  = "Modify lighting, fog and sky settings.",
})

-- // TAB 3 - MOVEMENT
local TabMove = win:AddTab({
	Name = "Movement",
	Sub  = "Speed & Physics",
	Icon = "wind",
})

local ML = TabMove:AddSection({ Side = "Left",   Title = "Speed",       Icon = "moveHorizontal" })
local MC = TabMove:AddSection({ Side = "Center", Title = "Fly & Jump",  Icon = "arrowUp"        })
local MR = TabMove:AddSection({ Side = "Right",  Title = "Physics",     Icon = "activity"       })

ML:AddToggle({
	Name     = "Speed Hack",
	SaveId   = "move_speed",
	Default  = false,
	Callback = function(v) print("[Move] Speed:", v) end,
})
ML:AddToggle({
	Name     = "No Clip",
	SaveId   = "move_noclip",
	Default  = false,
	Callback = function(v) print("[Move] NoClip:", v) end,
})
ML:AddToggle({
	Name     = "Auto Sprint",
	SaveId   = "move_sprint",
	Default  = false,
	Callback = function(v) print("[Move] Sprint:", v) end,
})
ML:AddSlider({
	Name     = "Walk Speed",
	SaveId   = "move_walkspeed",
	Min      = 16,
	Max      = 200,
	Default  = 16,
	Callback = function(v) print("[Move] WalkSpeed:", v) end,
})
ML:AddSlider({
	Name     = "Sprint Speed",
	SaveId   = "move_sprintspeed",
	Min      = 16,
	Max      = 300,
	Default  = 50,
	Callback = function(v) print("[Move] SprintSpeed:", v) end,
})
ML:AddDropdown({
	Name     = "Speed Mode",
	SaveId   = "move_speedmode",
	Options  = { "Velocity", "BodyVelocity", "CFrame", "HipHeight" },
	Default  = "Velocity",
	Callback = function(v) print("[Move] SpeedMode:", v) end,
})
ML:AddKeybind({
	Name     = "Speed Toggle",
	SaveId   = "move_speedkey",
	Default  = Enum.KeyCode.H,
	Callback = function(k) print("[Move] SpeedKey:", k) end,
})
ML:AddColorPicker({
	Name     = "Trail Color",
	SaveId   = "move_trail",
	Default  = Color3.fromRGB(100, 200, 255),
	Callback = function(c) print("[Move] Trail:", c) end,
})
ML:AddButton({
	Name     = "Reset Speed",
	Callback = function() print("[Move] Speed reset!") end,
})
ML:AddLabel({ Text = "Default speed: 16", Color = Color3.fromRGB(120, 120, 135) })
ML:AddParagraph({
	Title = "Speed Info",
	Text  = "Modifies character walk and sprint speed values.",
})

MC:AddToggle({
	Name     = "Fly",
	SaveId   = "move_fly",
	Default  = false,
	Callback = function(v) print("[Move] Fly:", v) end,
})
MC:AddToggle({
	Name     = "Infinite Jump",
	SaveId   = "move_infjump",
	Default  = false,
	Callback = function(v) print("[Move] InfJump:", v) end,
})
MC:AddToggle({
	Name     = "Anti-AFK",
	SaveId   = "move_antiafk",
	Default  = false,
	Callback = function(v) print("[Move] AntiAFK:", v) end,
})
MC:AddSlider({
	Name     = "Fly Speed",
	SaveId   = "move_flyspeed",
	Min      = 10,
	Max      = 500,
	Default  = 80,
	Callback = function(v) print("[Move] FlySpeed:", v) end,
})
MC:AddSlider({
	Name     = "Jump Power",
	SaveId   = "move_jumppower",
	Min      = 50,
	Max      = 500,
	Default  = 50,
	Callback = function(v) print("[Move] JumpPower:", v) end,
})
MC:AddDropdown({
	Name     = "Fly Mode",
	SaveId   = "move_flymode",
	Options  = { "BodyGyro", "Noclip", "Platform", "Tween" },
	Default  = "BodyGyro",
	Callback = function(v) print("[Move] FlyMode:", v) end,
})
MC:AddKeybind({
	Name     = "Fly Toggle",
	SaveId   = "move_flykey",
	Default  = Enum.KeyCode.G,
	Callback = function(k) print("[Move] FlyKey:", k) end,
})
MC:AddColorPicker({
	Name     = "Fly Aura",
	SaveId   = "move_flyaura",
	Default  = Color3.fromRGB(160, 100, 255),
	Callback = function(c) print("[Move] FlyAura:", c) end,
})
MC:AddButton({
	Name     = "Land Now",
	Callback = function() print("[Move] Landing...") end,
})
MC:AddLabel({ Text = "Press G to fly", Color = Color3.fromRGB(120, 120, 135) })
MC:AddParagraph({
	Title = "Fly Info",
	Text  = "Use WASD to control direction while flying.",
})

MR:AddToggle({
	Name     = "Low Gravity",
	SaveId   = "phys_lowgrav",
	Default  = false,
	Callback = function(v) print("[Move] LowGrav:", v) end,
})
MR:AddToggle({
	Name     = "No Fall Dmg",
	SaveId   = "phys_nofallDmg",
	Default  = false,
	Callback = function(v) print("[Move] NoFall:", v) end,
})
MR:AddToggle({
	Name     = "Bhop",
	SaveId   = "phys_bhop",
	Default  = false,
	Callback = function(v) print("[Move] Bhop:", v) end,
})
MR:AddSlider({
	Name     = "Gravity",
	SaveId   = "phys_gravity",
	Min      = 10,
	Max      = 300,
	Default  = 196,
	Callback = function(v) print("[Move] Gravity:", v) end,
})
MR:AddSlider({
	Name     = "Hip Height",
	SaveId   = "phys_hipheight",
	Min      = 0,
	Max      = 10,
	Default  = 2,
	Rounding = 0.5,
	Callback = function(v) print("[Move] HipHeight:", v) end,
})
MR:AddDropdown({
	Name     = "Bhop Mode",
	SaveId   = "phys_bhopmode",
	Options  = { "Auto", "Manual", "Scroll" },
	Default  = "Auto",
	Callback = function(v) print("[Move] BhopMode:", v) end,
})
MR:AddKeybind({
	Name     = "Bhop Key",
	SaveId   = "phys_bhopkey",
	Default  = Enum.KeyCode.Space,
	Callback = function(k) print("[Move] BhopKey:", k) end,
})
MR:AddColorPicker({
	Name     = "Bhop Color",
	SaveId   = "phys_bhopcolor",
	Default  = Color3.fromRGB(255, 200, 50),
	Callback = function(c) print("[Move] BhopColor:", c) end,
})
MR:AddButton({
	Name     = "Reset Physics",
	Callback = function() print("[Move] Physics reset!") end,
})
MR:AddLabel({ Text = "Default gravity: 196", Color = Color3.fromRGB(120, 120, 135) })
MR:AddParagraph({
	Title = "Physics Info",
	Text  = "Modify workspace gravity and character physics.",
})

-- // TAB 4 - PLAYER
local TabPlayer = win:AddTab({
	Name = "Player",
	Sub  = "Chars & Misc",
	Icon = "user",
})

local PL = TabPlayer:AddSection({ Side = "Left",   Title = "Character",   Icon = "fingerprint" })
local PC = TabPlayer:AddSection({ Side = "Center", Title = "Misc",        Icon = "wand2"       })
local PR = TabPlayer:AddSection({ Side = "Right",  Title = "Farm",        Icon = "coins"       })

PL:AddToggle({
	Name     = "God Mode",
	SaveId   = "char_god",
	Default  = false,
	Callback = function(v) print("[Player] God:", v) end,
})
PL:AddToggle({
	Name     = "Invisible",
	SaveId   = "char_invis",
	Default  = false,
	Callback = function(v) print("[Player] Invis:", v) end,
})
PL:AddToggle({
	Name     = "Freeze Others",
	SaveId   = "char_freeze",
	Default  = false,
	Callback = function(v) print("[Player] Freeze:", v) end,
})
PL:AddSlider({
	Name     = "Health",
	SaveId   = "char_health",
	Min      = 1,
	Max      = 1000,
	Default  = 100,
	Callback = function(v) print("[Player] Health:", v) end,
})
PL:AddSlider({
	Name     = "Character Size",
	SaveId   = "char_size",
	Min      = 50,
	Max      = 200,
	Default  = 100,
	Suffix   = "%",
	Callback = function(v) print("[Player] Size:", v) end,
})
PL:AddDropdown({
	Name     = "Team",
	SaveId   = "char_team",
	Options  = { "Auto", "Red", "Blue", "Green", "Neutral" },
	Default  = "Auto",
	Callback = function(v) print("[Player] Team:", v) end,
})
PL:AddKeybind({
	Name     = "Respawn Key",
	SaveId   = "char_respawnkey",
	Default  = Enum.KeyCode.R,
	Callback = function(k) print("[Player] RespawnKey:", k) end,
})
PL:AddColorPicker({
	Name     = "Name Color",
	SaveId   = "char_namecolor",
	Default  = Color3.fromRGB(230, 230, 235),
	Callback = function(c) print("[Player] NameColor:", c) end,
})
PL:AddButton({
	Name     = "Respawn",
	Callback = function() print("[Player] Respawning...") end,
})
PL:AddLabel({ Text = "Character options", Color = Color3.fromRGB(120, 120, 135) })
PL:AddParagraph({
	Title = "Char Info",
	Text  = "God mode and invisibility use local methods.",
})

PC:AddToggle({
	Name     = "Chat Spam",
	SaveId   = "misc_chatspam",
	Default  = false,
	Callback = function(v) print("[Player] ChatSpam:", v) end,
})
PC:AddToggle({
	Name     = "Headless",
	SaveId   = "misc_headless",
	Default  = false,
	Callback = function(v) print("[Player] Headless:", v) end,
})
PC:AddToggle({
	Name     = "Admin Check",
	SaveId   = "misc_admincheck",
	Default  = false,
	Callback = function(v) print("[Player] AdminCheck:", v) end,
})
PC:AddSlider({
	Name     = "Spam Delay",
	SaveId   = "misc_spamdelay",
	Min      = 1,
	Max      = 60,
	Default  = 5,
	Suffix   = "s",
	Callback = function(v) print("[Player] SpamDelay:", v) end,
})
PC:AddDropdown({
	Name     = "Chat Mode",
	SaveId   = "misc_chatmode",
	Options  = { "Normal", "Shout", "Whisper", "Emote" },
	Default  = "Normal",
	Callback = function(v) print("[Player] ChatMode:", v) end,
})
PC:AddKeybind({
	Name     = "Spam Key",
	SaveId   = "misc_spamkey",
	Default  = Enum.KeyCode.T,
	Callback = function(k) print("[Player] SpamKey:", k) end,
})
PC:AddColorPicker({
	Name     = "Chat Color",
	SaveId   = "misc_chatcolor",
	Default  = Color3.fromRGB(255, 255, 100),
	Callback = function(c) print("[Player] ChatColor:", c) end,
})
PC:AddButton({
	Name     = "Send Shout",
	Callback = function() print("[Player] Shout sent!") end,
})
PC:AddLabel({ Text = "Use responsibly", Color = Color3.fromRGB(255, 180, 60) })
PC:AddParagraph({
	Title = "Misc Info",
	Text  = "Extra character and chat manipulation features.",
})

PR:AddToggle({
	Name     = "Auto Farm",
	SaveId   = "farm_enable",
	Default  = false,
	Callback = function(v) print("[Player] Farm:", v) end,
})
PR:AddToggle({
	Name     = "Auto Collect",
	SaveId   = "farm_collect",
	Default  = false,
	Callback = function(v) print("[Player] Collect:", v) end,
})
PR:AddToggle({
	Name     = "Auto Quest",
	SaveId   = "farm_quest",
	Default  = false,
	Callback = function(v) print("[Player] Quest:", v) end,
})
PR:AddSlider({
	Name     = "Farm Radius",
	SaveId   = "farm_radius",
	Min      = 10,
	Max      = 500,
	Default  = 100,
	Suffix   = "m",
	Callback = function(v) print("[Player] Radius:", v) end,
})
PR:AddSlider({
	Name     = "Farm Delay",
	SaveId   = "farm_delay",
	Min      = 100,
	Max      = 5000,
	Default  = 500,
	Suffix   = "ms",
	Callback = function(v) print("[Player] FarmDelay:", v) end,
})
PR:AddDropdown({
	Name     = "Target Type",
	SaveId   = "farm_target",
	Options  = { "Mobs", "Resources", "Players", "All" },
	Default  = "Mobs",
	Callback = function(v) print("[Player] Target:", v) end,
})
PR:AddKeybind({
	Name     = "Farm Toggle",
	SaveId   = "farm_key",
	Default  = Enum.KeyCode.J,
	Callback = function(k) print("[Player] FarmKey:", k) end,
})
PR:AddColorPicker({
	Name     = "Farm Range",
	SaveId   = "farm_rangecolor",
	Default  = Color3.fromRGB(100, 255, 150),
	Callback = function(c) print("[Player] RangeColor:", c) end,
})
PR:AddButton({
	Name     = "Start Farm",
	Callback = function() print("[Player] Farm started!") end,
})
PR:AddLabel({ Text = "Farm active", Color = Color3.fromRGB(100, 255, 150) })
PR:AddParagraph({
	Title = "Farm Info",
	Text  = "Auto farms mobs and resources within radius.",
})

-- // TAB 5 - SETTINGS
local TabSettings = win:AddTab({
	Name = "Settings",
	Sub  = "Config & Save",
	Icon = "settings",
})

local SL = TabSettings:AddSection({ Side = "Left",   Title = "Interface",  Icon = "palette"  })
local SC = TabSettings:AddSection({ Side = "Center", Title = "Config",     Icon = "save"     })
local SR = TabSettings:AddSection({ Side = "Right",  Title = "Anti-Cheat", Icon = "shield"   })

SL:AddToggle({
	Name     = "Animations",
	SaveId   = "ui_anims",
	Default  = true,
	Callback = function(v) print("[Settings] Anims:", v) end,
})
SL:AddToggle({
	Name     = "Sounds",
	SaveId   = "ui_sounds",
	Default  = true,
	Callback = function(v) print("[Settings] Sounds:", v) end,
})
SL:AddToggle({
	Name     = "Compact Mode",
	SaveId   = "ui_compact",
	Default  = false,
	Callback = function(v) print("[Settings] Compact:", v) end,
})
SL:AddSlider({
	Name     = "UI Scale",
	SaveId   = "ui_scale",
	Min      = 75,
	Max      = 150,
	Default  = 100,
	Suffix   = "%",
	Callback = function(v) print("[Settings] Scale:", v) end,
})
SL:AddSlider({
	Name     = "Opacity",
	SaveId   = "ui_opacity",
	Min      = 30,
	Max      = 100,
	Default  = 95,
	Suffix   = "%",
	Callback = function(v) print("[Settings] Opacity:", v) end,
})
SL:AddDropdown({
	Name     = "Theme",
	SaveId   = "ui_theme",
	Options  = { "Dark Purple", "Dark Blue", "Dark Red", "Midnight", "Abyss" },
	Default  = "Dark Purple",
	Callback = function(v) print("[Settings] Theme:", v) end,
})
SL:AddKeybind({
	Name     = "Open Key",
	SaveId   = "ui_openkey",
	Default  = Enum.KeyCode.LeftAlt,
	Callback = function(k) print("[Settings] OpenKey:", k) end,
})
SL:AddColorPicker({
	Name     = "Accent Color",
	SaveId   = "ui_accent",
	Default  = Color3.fromRGB(160, 100, 255),
	Callback = function(c) print("[Settings] Accent:", c) end,
})
SL:AddButton({
	Name     = "Apply Theme",
	Callback = function() print("[Settings] Theme applied!") end,
})
SL:AddLabel({ Text = "EcoHub V2 - Interface", Color = Color3.fromRGB(160, 100, 255) })
SL:AddParagraph({
	Title = "UI Info",
	Text  = "Customize the interface appearance and behavior.",
})

SC:AddToggle({
	Name     = "Auto Save",
	SaveId   = "cfg_autosave",
	Default  = true,
	Callback = function(v) print("[Settings] AutoSave:", v) end,
})
SC:AddToggle({
	Name     = "Load on Start",
	SaveId   = "cfg_autoload",
	Default  = true,
	Callback = function(v) print("[Settings] AutoLoad:", v) end,
})
SC:AddToggle({
	Name     = "Cloud Sync",
	SaveId   = "cfg_cloudsync",
	Default  = false,
	Callback = function(v) print("[Settings] CloudSync:", v) end,
})
SC:AddSlider({
	Name     = "Save Interval",
	SaveId   = "cfg_interval",
	Min      = 5,
	Max      = 120,
	Default  = 30,
	Suffix   = "s",
	Callback = function(v) print("[Settings] Interval:", v) end,
})
SC:AddDropdown({
	Name     = "Config Slot",
	SaveId   = "cfg_slot",
	Options  = { "Slot 1", "Slot 2", "Slot 3", "Slot 4", "Default" },
	Default  = "Default",
	Callback = function(v) print("[Settings] Slot:", v) end,
})
SC:AddKeybind({
	Name     = "Quick Save",
	SaveId   = "cfg_savekey",
	Default  = Enum.KeyCode.F5,
	Callback = function(k) print("[Settings] SaveKey:", k) end,
})
SC:AddColorPicker({
	Name     = "Save Indicator",
	SaveId   = "cfg_savecolor",
	Default  = Color3.fromRGB(100, 255, 150),
	Callback = function(c) print("[Settings] SaveColor:", c) end,
})
SC:AddButton({
	Name     = "Save Config",
	Callback = function() print("[Settings] Config saved!") end,
})
SC:AddButton({
	Name     = "Load Config",
	Callback = function() print("[Settings] Config loaded!") end,
})
SC:AddButton({
	Name     = "Reset All",
	Callback = function() print("[Settings] All reset!") end,
})
SC:AddLabel({ Text = "Config auto-saved", Color = Color3.fromRGB(120, 120, 135) })
SC:AddParagraph({
	Title = "Config Info",
	Text  = "Configs saved to ecohubv2 folder locally.",
})

SR:AddToggle({
	Name     = "Anti-Detect",
	SaveId   = "ac_detect",
	Default  = false,
	Callback = function(v) print("[Settings] AntiDetect:", v) end,
})
SR:AddToggle({
	Name     = "Safe Mode",
	SaveId   = "ac_safe",
	Default  = true,
	Callback = function(v) print("[Settings] SafeMode:", v) end,
})
SR:AddToggle({
	Name     = "Panic Mode",
	SaveId   = "ac_panic",
	Default  = false,
	Callback = function(v) print("[Settings] Panic:", v) end,
})
SR:AddSlider({
	Name     = "Check Interval",
	SaveId   = "ac_interval",
	Min      = 1,
	Max      = 60,
	Default  = 5,
	Suffix   = "s",
	Callback = function(v) print("[Settings] ACInterval:", v) end,
})
SR:AddDropdown({
	Name     = "AC Mode",
	SaveId   = "ac_mode",
	Options  = { "Passive", "Active", "Aggressive", "Off" },
	Default  = "Passive",
	Callback = function(v) print("[Settings] ACMode:", v) end,
})
SR:AddKeybind({
	Name     = "Panic Key",
	SaveId   = "ac_panickey",
	Default  = Enum.KeyCode.Delete,
	Callback = function(k) print("[Settings] PanicKey:", k) end,
})
SR:AddColorPicker({
	Name     = "Alert Color",
	SaveId   = "ac_alertcolor",
	Default  = Color3.fromRGB(255, 80, 80),
	Callback = function(c) print("[Settings] AlertColor:", c) end,
})
SR:AddButton({
	Name     = "Panic Now",
	Callback = function() print("[Settings] PANIC - disabling all!") end,
})
SR:AddLabel({ Text = "Stay safe!", Color = Color3.fromRGB(255, 80, 80) })
SR:AddParagraph({
	Title = "AC Info",
	Text  = "Panic key disables all features instantly on press.",
})
