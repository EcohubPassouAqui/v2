local UIS     = game:GetService("UserInputService")
local TS      = game:GetService("TweenService")
local RS      = game:GetService("RunService")
local Players = game:GetService("Players")
local HTTP    = game:GetService("HttpService")
local lp      = Players.LocalPlayer

do
	local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled
	if isMobile then
		local ok = pcall(function() lp:Kick("[ EcoHub ] Dispositivo nao suportado.") end)
		if not ok then pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId,lp) end) end
		return
	end
end

local _gameName = tostring(game.Name):gsub("[^%w%s%-_]",""):gsub("%s+","_"):sub(1,40)
if _gameName == "" then _gameName = "unknown" end

local function _cfgPath(windowName)
	local wn = tostring(windowName):gsub("[^%w%s%-_]",""):gsub("%s+","_"):sub(1,30)
	if wn == "" then wn = "window" end
	return "ecohub/" .. _gameName .. "/" .. wn .. "_config.json"
end

local function _ensureFolders(path)
	pcall(function()
		local parts = string.split(path, "/")
		local built = ""
		for i = 1, #parts - 1 do
			built = (i == 1) and parts[i] or (built .. "/" .. parts[i])
			if not isfolder(built) then makefolder(built) end
		end
	end)
end

local function readCfg(path)
	local ok, d = pcall(function()
		_ensureFolders(path)
		return isfile(path) and HTTP:JSONDecode(readfile(path)) or {}
	end)
	return (ok and type(d) == "table") and d or {}
end

local function saveCfg(path, d)
	pcall(function()
		_ensureFolders(path)
		writefile(path, HTTP:JSONEncode(d))
	end)
end

local function cleanOld(p)
	for _, v in ipairs(p:GetChildren()) do
		if v.Name:sub(1, 7) == "ecohub_" then v:Destroy() end
	end
end
cleanOld(game:GetService("CoreGui"))
if gethui then cleanOld(gethui()) end

local _iconsOk, _iconsData = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/EcohubPassouAqui/v2/refs/heads/main/icons"))()
end)
local _reg = (_iconsOk and type(_iconsData) == "table" and _iconsData.assets) or {}
local function icon(name) return _reg["lucide-" .. name] or "rbxassetid://0" end

local LOGO_ID   = "rbxassetid://134382458890933"
local PANEL_W   = 600
local PANEL_H   = 480
local TITLE_H   = 42
local SIDE_FULL = 200
local SIDE_MINI = 46
local LOGO_H    = 100

local T = {
	Accent        = Color3.fromRGB(72, 138, 182),
	AccentDark    = Color3.fromRGB(45, 100, 140),
	AccentHov     = Color3.fromRGB(95, 158, 205),
	AcrylicBorder = Color3.fromRGB(60, 60, 60),
	TitleBarLine  = Color3.fromRGB(65, 65, 65),
	bg            = Color3.fromRGB(20, 20, 20),
	surface       = Color3.fromRGB(25, 25, 25),
	sidebar       = Color3.fromRGB(22, 22, 22),
	divider       = Color3.fromRGB(50, 50, 50),
	white         = Color3.fromRGB(220, 220, 220),
	dim           = Color3.fromRGB(80, 80, 80),
	dimLight      = Color3.fromRGB(120, 120, 120),
	tabIdle       = Color3.fromRGB(110, 110, 110),
	tabHov        = Color3.fromRGB(160, 160, 160),
	tabAct        = Color3.fromRGB(210, 210, 210),
	tabBgHov      = Color3.fromRGB(38, 38, 38),
	tabBgAct      = Color3.fromRGB(42, 42, 42),
	searchBg      = Color3.fromRGB(28, 28, 28),
	avatarBg      = Color3.fromRGB(28, 28, 28),
	underline     = Color3.fromRGB(72, 138, 182),
	secText       = Color3.fromRGB(75, 75, 75),
	elBg          = Color3.fromRGB(27, 27, 27),
	elBgHov       = Color3.fromRGB(34, 34, 34),
	elBorder      = Color3.fromRGB(60, 60, 60),
	floatBg       = Color3.fromRGB(24, 24, 24),
	inputBg       = Color3.fromRGB(20, 20, 20),
	pageBg        = Color3.fromRGB(18, 18, 18),
}

local function New(cls, props)
	local ok, obj = pcall(Instance.new, cls)
	if not ok then print("[EcoHub] Erro ao criar instancia: " .. cls) return nil end
	for k, v in pairs(props) do if k ~= "Parent" then pcall(function() obj[k] = v end) end end
	if props.Parent then obj.Parent = props.Parent end
	return obj
end

local function Tw(obj, goal, t, style)
	TS:Create(obj, TweenInfo.new(t or 0.18, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), goal):Play()
end

local function Img(id, parent, sz, pos, color, zi)
	return New("ImageLabel", {
		Size = UDim2.new(0, sz, 0, sz), Position = pos, BackgroundTransparency = 1,
		Image = id, ImageColor3 = color or T.dim, ZIndex = zi or 5, Parent = parent,
	})
end


local _openFloats = {}
local _elo        = 0
local function _nextOrder() _elo += 1 return _elo end

local function _closeAllFloats(except)
	for i = #_openFloats, 1, -1 do
		local fn = _openFloats[i]
		if fn ~= except then pcall(fn) table.remove(_openFloats, i) end
	end
end

local function _elBase(parent, h)
	local f = New("Frame", {
		Size = UDim2.new(1, 0, 0, h or 44),
		BackgroundColor3 = T.elBg,
		BorderSizePixel  = 0,
		ClipsDescendants = false,
		LayoutOrder      = _nextOrder(),
		ZIndex           = 3,
		Parent           = parent,
	})
	New("UICorner",   { CornerRadius = UDim.new(0, 8), Parent = f })
	New("UIStroke",   { Color = T.elBorder, Thickness = 1, Transparency = 0.3, Parent = f })
	New("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(42, 42, 42)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(23, 23, 23)),
		}),
		Rotation = 90, Parent = f,
	})
	return f
end

local function _elLabel(parent, text, xOff, yOff, size, color, zi)
	return New("TextLabel", {
		Size = UDim2.new(1, -(xOff or 12), 0, size and (size + 4) or 14),
		Position = UDim2.new(0, xOff or 12, 0, yOff or 0),
		AnchorPoint = yOff and Vector2.new(0, 0) or Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Text = text, TextColor3 = color or T.white,
		TextSize = size or 12, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = zi or 4, Parent = parent,
	})
end

local function _hoverEl(btn, frame)
	btn.MouseEnter:Connect(function() Tw(frame, { BackgroundColor3 = T.elBgHov }, 0.1) end)
	btn.MouseLeave:Connect(function() Tw(frame, { BackgroundColor3 = T.elBg   }, 0.1) end)
end

local function _floatPanel(guiRoot, w, h)
	if not guiRoot then guiRoot = game:GetService("CoreGui") end
	local p = New("Frame", {
		Size = UDim2.new(0, w, 0, h),
		BackgroundColor3 = T.floatBg,
		BorderSizePixel  = 0,
		ClipsDescendants = false,
		ZIndex           = 120,
		Visible          = false,
		Parent           = guiRoot,
	})
	New("UICorner",   { CornerRadius = UDim.new(0, 8), Parent = p })
	New("UIStroke",   { Color = T.elBorder, Thickness = 1, Transparency = 0.15, Parent = p })
	New("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(36, 36, 36)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20)),
		}),
		Rotation = 90, Parent = p,
	})
	New("ImageLabel", {
		Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(30, 30),
		Position = UDim2.fromOffset(-15, -15),
		BackgroundTransparency = 1,
		Image = "rbxassetid://5554236805",
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(23, 23, 277, 277),
		ImageColor3 = Color3.fromRGB(0, 0, 0),
		ImageTransparency = 0.15,
		ZIndex = 119, Parent = p,
	})
	return p
end

local function _anchorFloat(panel, trigger)
	local vp = game:GetService("Workspace").CurrentCamera.ViewportSize
	local ap = trigger.AbsolutePosition
	local as = trigger.AbsoluteSize
	local ps = panel.AbsoluteSize
	local x  = math.clamp(ap.X, 0, vp.X - ps.X - 4)
	local y  = ap.Y + as.Y + 5
	if y + ps.Y > vp.Y - 4 then y = ap.Y - ps.Y - 5 end
	panel.Position = UDim2.fromOffset(x, y)
end

local Elements = {}

function Elements.Section(parent, text)
	_elo += 1
	local f = New("Frame", {
		Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1,
		LayoutOrder = _elo, ZIndex = 3, Parent = parent,
	})
	local line = New("Frame", {
		Size = UDim2.new(1, -16, 0, 1), Position = UDim2.new(0, 8, 0.5, 0),
		BackgroundColor3 = T.divider, BorderSizePixel = 0, ZIndex = 3, Parent = f,
	})
	New("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0,   Color3.fromRGB(55,55,55)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(55,55,55)),
			ColorSequenceKeypoint.new(1,   Color3.fromRGB(22,22,22)),
		}), Parent = line,
	})
	local pill = New("Frame", {
		Size = UDim2.new(0, 0, 0, 16), Position = UDim2.new(0, 8, 0.5, -8),
		BackgroundColor3 = T.AccentDark, BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.X, ZIndex = 4, Parent = f,
	})
	New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = pill })
	New("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, T.AccentHov),
			ColorSequenceKeypoint.new(1, T.AccentDark),
		}), Rotation = 90, Parent = pill,
	})
	New("UIStroke", { Color = T.Accent, Thickness = 1, Transparency = 0.5, Parent = pill })
	New("TextLabel", {
		Size = UDim2.new(0, 0, 1, 0), BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.X,
		Text = "  " .. string.upper(text) .. "  ",
		TextColor3 = Color3.fromRGB(210, 210, 210), TextSize = 9, Font = Enum.Font.GothamBold,
		ZIndex = 5, Parent = pill,
	})
	return f
end

function Elements.Toggle(parent, text, default, cb)
	local state = default == true
	local f = _elBase(parent, 44)
	_elLabel(f, text, 12, nil, 12, T.white, 4)
	local track = New("Frame", {
		Size = UDim2.new(0, 38, 0, 20), Position = UDim2.new(1, -50, 0.5, -10),
		BackgroundColor3 = state and T.Accent or Color3.fromRGB(45,45,45),
		BorderSizePixel = 0, ZIndex = 5, Parent = f,
	})
	New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })
	local tGrad = New("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, state and T.AccentHov or Color3.fromRGB(60,60,60)),
			ColorSequenceKeypoint.new(1, state and T.AccentDark or Color3.fromRGB(35,35,35)),
		}), Rotation = 90, Parent = track,
	})
	local tStroke = New("UIStroke", { Color = state and T.Accent or Color3.fromRGB(60,60,60), Thickness = 1, Transparency = 0.35, Parent = track })
	local knob = New("Frame", {
		Size = UDim2.new(0, 14, 0, 14),
		Position = state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
		BackgroundColor3 = T.white, BorderSizePixel = 0, ZIndex = 6, Parent = track,
	})
	New("UICorner", { CornerRadius = UDim.new(1,0), Parent = knob })
	New("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(190,190,190)),
		}), Rotation = 90, Parent = knob,
	})
	local function refresh(s)
		Tw(track, { BackgroundColor3 = s and T.Accent or Color3.fromRGB(45,45,45) }, 0.15)
		Tw(knob,  { Position = s and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7) }, 0.15)
		Tw(tStroke, { Color = s and T.Accent or Color3.fromRGB(60,60,60) }, 0.15)
		tGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, s and T.AccentHov or Color3.fromRGB(60,60,60)),
			ColorSequenceKeypoint.new(1, s and T.AccentDark or Color3.fromRGB(35,35,35)),
		})
	end
	local btn = New("TextButton", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "", ZIndex = 7, Parent = f })
	btn.MouseButton1Click:Connect(function()
		state = not state refresh(state)
		if cb then cb(state) end
	end)
	_hoverEl(btn, f)
	return { Set = function(v) state = v refresh(state) end, Get = function() return state end }
end

function Elements.Checkbox(parent, text, default, cb)
	local state = default == true
	local f = _elBase(parent, 44)
	_elLabel(f, text, 44, nil, 12, T.white, 4)
	local box = New("Frame", {
		Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 12, 0.5, -9),
		BackgroundColor3 = state and T.Accent or Color3.fromRGB(28,28,28),
		BorderSizePixel = 0, ZIndex = 5, Parent = f,
	})
	New("UICorner", { CornerRadius = UDim.new(0, 5), Parent = box })
	local bGrad = New("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, state and T.AccentHov or Color3.fromRGB(44,44,44)),
			ColorSequenceKeypoint.new(1, state and T.AccentDark or Color3.fromRGB(22,22,22)),
		}), Rotation = 135, Parent = box,
	})
	local bStroke = New("UIStroke", { Color = state and T.Accent or Color3.fromRGB(62,62,62), Thickness = 1.5, Parent = box })
	local chkIco  = New("ImageLabel", {
		Size = UDim2.new(0,11,0,11), Position = UDim2.new(0.5,-5.5,0.5,-5.5),
		BackgroundTransparency = 1, Image = icon("check"),
		ImageColor3 = T.white, ImageTransparency = state and 0 or 1,
		ZIndex = 6, Parent = box,
	})
	local function refresh(s)
		Tw(box,     { BackgroundColor3 = s and T.Accent or Color3.fromRGB(28,28,28) }, 0.15)
		Tw(bStroke, { Color = s and T.Accent or Color3.fromRGB(62,62,62) }, 0.15)
		Tw(chkIco,  { ImageTransparency = s and 0 or 1 }, 0.1)
		bGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, s and T.AccentHov or Color3.fromRGB(44,44,44)),
			ColorSequenceKeypoint.new(1, s and T.AccentDark or Color3.fromRGB(22,22,22)),
		})
	end
	local btn = New("TextButton", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "", ZIndex = 7, Parent = f })
	btn.MouseButton1Click:Connect(function()
		state = not state refresh(state)
		if cb then cb(state) end
	end)
	_hoverEl(btn, f)
	return { Set = function(v) state = v refresh(state) end, Get = function() return state end }
end

function Elements.Button(parent, text, cb)
	local f = _elBase(parent, 42)
	local inner = New("Frame", {
		Size = UDim2.new(1, -16, 1, -14), Position = UDim2.new(0, 8, 0, 7),
		BackgroundColor3 = T.Accent, BorderSizePixel = 0, ZIndex = 4, Parent = f,
	})
	New("UICorner",   { CornerRadius = UDim.new(0, 6), Parent = inner })
	New("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, T.AccentHov),
			ColorSequenceKeypoint.new(1, T.AccentDark),
		}), Rotation = 90, Parent = inner,
	})
	New("UIStroke", { Color = T.AccentHov, Thickness = 1, Transparency = 0.5, Parent = inner })
	New("Frame", {
		Size = UDim2.new(1, 0, 0.45, 0), BackgroundColor3 = Color3.fromRGB(255,255,255),
		BackgroundTransparency = 0.88, BorderSizePixel = 0, ZIndex = 5, Parent = inner,
	})
	New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = inner:FindFirstChildWhichIsA("Frame") })
	New("TextLabel", {
		Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
		Text = text, TextColor3 = T.white, TextSize = 12, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 6, Parent = inner,
	})
	local btn = New("TextButton", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "", ZIndex = 7, Parent = f })
	btn.MouseEnter:Connect(function()    Tw(inner, { BackgroundColor3 = T.AccentHov }, 0.1) end)
	btn.MouseLeave:Connect(function()    Tw(inner, { BackgroundColor3 = T.Accent, Size = UDim2.new(1,-16,1,-14), Position = UDim2.new(0,8,0,7) }, 0.12) end)
	btn.MouseButton1Down:Connect(function() Tw(inner, { BackgroundColor3 = T.AccentDark, Size = UDim2.new(1,-20,1,-16), Position = UDim2.new(0,10,0,8) }, 0.08) end)
	btn.MouseButton1Up:Connect(function()   Tw(inner, { BackgroundColor3 = T.Accent, Size = UDim2.new(1,-16,1,-14), Position = UDim2.new(0,8,0,7) }, 0.1) end)
	btn.MouseButton1Click:Connect(function() if cb then cb() end end)
	return f
end

function Elements.Slider(parent, text, min, max, default, cb)
	min = min or 0 max = max or 100
	local val = math.clamp(default or min, min, max)
	local pct = (val - min) / (max - min)
	local drag = false
	local f = _elBase(parent, 54)
	New("TextLabel", {
		Size = UDim2.new(1, -80, 0, 16), Position = UDim2.new(0, 12, 0, 10),
		BackgroundTransparency = 1, Text = text, TextColor3 = T.white,
		TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 4, Parent = f,
	})
	local valLbl = New("TextLabel", {
		Size = UDim2.new(0, 62, 0, 16), Position = UDim2.new(1, -74, 0, 10),
		BackgroundTransparency = 1, Text = tostring(val),
		TextColor3 = T.Accent, TextSize = 11, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 4, Parent = f,
	})
	local rail = New("Frame", {
		Size = UDim2.new(1, -24, 0, 5), Position = UDim2.new(0, 12, 0, 36),
		BackgroundColor3 = Color3.fromRGB(38,38,38), BorderSizePixel = 0, ZIndex = 4, Parent = f,
	})
	New("UICorner",   { CornerRadius = UDim.new(1,0), Parent = rail })
	New("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(52,52,52)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(28,28,28)),
		}), Rotation = 90, Parent = rail,
	})
	local fill = New("Frame", {
		Size = UDim2.new(pct, 0, 1, 0), BackgroundColor3 = T.Accent,
		BorderSizePixel = 0, ZIndex = 5, Parent = rail,
	})
	New("UICorner",   { CornerRadius = UDim.new(1,0), Parent = fill })
	New("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, T.AccentHov),
			ColorSequenceKeypoint.new(1, T.Accent),
		}), Parent = fill,
	})
	local knob = New("Frame", {
		Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(pct, -7, 0.5, -7),
		BackgroundColor3 = T.white, BorderSizePixel = 0, ZIndex = 6, Parent = rail,
	})
	New("UICorner",   { CornerRadius = UDim.new(1,0), Parent = knob })
	New("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(185,185,185)),
		}), Rotation = 90, Parent = knob,
	})
	New("UIStroke", { Color = T.Accent, Thickness = 1.5, Parent = knob })
	local function setVal(v)
		val = math.clamp(math.round(v), min, max)
		local p = (val - min) / (max - min)
		fill.Size     = UDim2.new(p, 0, 1, 0)
		knob.Position = UDim2.new(p, -7, 0.5, -7)
		valLbl.Text   = tostring(val)
		if cb then cb(val) end
	end
	local hitbox = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 24), Position = UDim2.new(0, 0, 0, -10),
		BackgroundTransparency = 1, Text = "", ZIndex = 7, Parent = rail,
	})
	hitbox.MouseButton1Down:Connect(function()
		drag = true
		local mp  = UIS:GetMouseLocation()
		local ab  = rail.AbsolutePosition
		local sz  = rail.AbsoluteSize
		setVal(min + (max - min) * math.clamp((mp.X - ab.X) / sz.X, 0, 1))
	end)
	UIS.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
	end)
	RS.RenderStepped:Connect(function()
		if not drag then return end
		local mp  = UIS:GetMouseLocation()
		local ab  = rail.AbsolutePosition
		local sz  = rail.AbsoluteSize
		setVal(min + (max - min) * math.clamp((mp.X - ab.X) / sz.X, 0, 1))
	end)
	return { Set = function(v) setVal(v) end, Get = function() return val end }
end

function Elements.Dropdown(parent, text, options, default, cb)
	local selected = default or (options and options[1]) or ""
	local open     = false
	options        = options or {}
	local f = _elBase(parent, 44)
	_elLabel(f, text, 12, nil, 12, T.white, 4)
	local selLbl = New("TextLabel", {
		Size = UDim2.new(0, 100, 0, 24), Position = UDim2.new(1, -138, 0.5, -12),
		BackgroundTransparency = 1, Text = selected,
		TextColor3 = T.Accent, TextSize = 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4, Parent = f,
	})
	local arrowBox = New("Frame", {
		Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -34, 0.5, -12),
		BackgroundColor3 = Color3.fromRGB(34,34,34), BorderSizePixel = 0, ZIndex = 4, Parent = f,
	})
	New("UICorner", { CornerRadius = UDim.new(0,6), Parent = arrowBox })
	local arrow = Img(icon("chevron-down"), arrowBox, 13, UDim2.new(0.5,-6.5,0.5,-6.5), T.dimLight, 5)
	local ITEM_H  = 30
	local PAD     = 8
	local MAX_VIS = 8
	local panelH = math.min(#options, MAX_VIS) * ITEM_H + PAD * 2
	local panel  = _floatPanel(nil, f.AbsoluteSize.X > 0 and f.AbsoluteSize.X or 200, panelH)
	local scroll = New("ScrollingFrame", {
		Size = UDim2.new(1, -8, 1, -8), Position = UDim2.fromOffset(4, 4),
		BackgroundTransparency = 1, ScrollBarThickness = 3,
		ScrollBarImageColor3 = T.divider,
		CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ZIndex = 122, Parent = panel,
	})
	New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,2), Parent = scroll })
	local function closePanel()
		open = false
		Tw(panel, { Size = UDim2.new(0, panel.AbsoluteSize.X, 0, 0) }, 0.16)
		Tw(arrow, { Rotation = 0 }, 0.16)
		task.delay(0.17, function()
			panel.Visible = false
			panel.Size = UDim2.new(0, panel.AbsoluteSize.X, 0, panelH)
		end)
		for i, fn in ipairs(_openFloats) do
			if fn == closePanel then table.remove(_openFloats, i) break end
		end
	end
	local function buildList()
		for _, c in ipairs(scroll:GetChildren()) do
			if not c:IsA("UIListLayout") then c:Destroy() end
		end
		for i, opt in ipairs(options) do
			local isActive = opt == selected
			local ob = New("TextButton", {
				Size = UDim2.new(1, 0, 0, ITEM_H),
				BackgroundColor3 = isActive and Color3.fromRGB(36,36,36) or Color3.fromRGB(27,27,27),
				BackgroundTransparency = isActive and 0 or 1,
				BorderSizePixel = 0, Text = "",
				AutoButtonColor = false, LayoutOrder = i, ZIndex = 123, Parent = scroll,
			})
			New("UICorner", { CornerRadius = UDim.new(0,6), Parent = ob })
			if isActive then
				New("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(44,44,44)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(28,28,28)),
					}), Rotation = 90, Parent = ob,
				})
				New("UIStroke", { Color = T.Accent, Thickness = 1, Transparency = 0.65, Parent = ob })
			end
			local sel = New("Frame", {
				Size = UDim2.new(0, 3, 0, 14), Position = UDim2.fromOffset(4, 8),
				BackgroundColor3 = T.Accent, BorderSizePixel = 0,
				BackgroundTransparency = isActive and 0 or 1, ZIndex = 124, Parent = ob,
			})
			New("UICorner", { CornerRadius = UDim.new(1,0), Parent = sel })
			New("TextLabel", {
				Size = UDim2.new(1, -18, 1, 0), Position = UDim2.fromOffset(14, 0),
				BackgroundTransparency = 1, Text = opt,
				TextColor3 = isActive and T.white or T.dimLight,
				TextSize = 11, Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = 124, Parent = ob,
			})
			ob.MouseEnter:Connect(function()
				if opt ~= selected then Tw(ob,{BackgroundTransparency=0,BackgroundColor3=Color3.fromRGB(32,32,32)},0.08) end
			end)
			ob.MouseLeave:Connect(function()
				if opt ~= selected then Tw(ob,{BackgroundTransparency=1},0.08) end
			end)
			ob.MouseButton1Click:Connect(function()
				selected    = opt
				selLbl.Text = selected
				buildList()
				closePanel()
				if cb then cb(selected) end
			end)
		end
		panelH = math.min(#options, MAX_VIS) * ITEM_H + PAD * 2
		panel.Size = UDim2.new(0, panel.AbsoluteSize.X, 0, panelH)
	end
	buildList()
	UIS.InputBegan:Connect(function(inp)
		if inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
		if not open then return end
		local mp = UIS:GetMouseLocation()
		local ap = panel.AbsolutePosition
		local as = panel.AbsoluteSize
		if mp.X < ap.X or mp.X > ap.X + as.X or mp.Y < ap.Y or mp.Y > ap.Y + as.Y then
			closePanel()
		end
	end)
	local btn = New("TextButton", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = f })
	btn.MouseButton1Click:Connect(function()
		if open then closePanel() return end
		_closeAllFloats(closePanel)
		open = true
		buildList()
		panel.Size    = UDim2.new(0, f.AbsoluteSize.X, 0, 0)
		panel.Visible = true
		_anchorFloat(panel, f)
		Tw(panel, { Size = UDim2.new(0, f.AbsoluteSize.X, 0, panelH) }, 0.2)
		Tw(arrow, { Rotation = 180 }, 0.18)
		table.insert(_openFloats, closePanel)
		f:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
			if open then _anchorFloat(panel, f) end
		end)
	end)
	_hoverEl(btn, f)
	return {
		Set        = function(v) selected = v selLbl.Text = v buildList() end,
		Get        = function() return selected end,
		SetOptions = function(o) options = o buildList() end,
	}
end

function Elements.Keybind(parent, text, default, cb)
	local key       = default or Enum.KeyCode.Unknown
	local listening = false
	local f = _elBase(parent, 44)
	_elLabel(f, text, 12, nil, 12, T.white, 4)
	local kbtn = New("TextButton", {
		Size = UDim2.new(0, 82, 0, 24), Position = UDim2.new(1, -94, 0.5, -12),
		BackgroundColor3 = Color3.fromRGB(30,30,30), BorderSizePixel = 0,
		Text = key.Name, TextColor3 = T.Accent, TextSize = 10,
		Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 5, Parent = f,
	})
	New("UICorner",   { CornerRadius = UDim.new(0,5), Parent = kbtn })
	New("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(42,42,42)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(24,24,24)),
		}), Rotation = 90, Parent = kbtn,
	})
	local kStroke = New("UIStroke", { Color = T.Accent, Thickness = 1, Transparency = 0.5, Parent = kbtn })
	kbtn.MouseButton1Click:Connect(function()
		_closeAllFloats()
		listening = true
		kbtn.Text = "..."
		kbtn.TextColor3 = T.white
		Tw(kbtn,    { BackgroundColor3 = Color3.fromRGB(42,42,42) }, 0.1)
		Tw(kStroke, { Color = T.white, Transparency = 0 }, 0.1)
	end)
	UIS.InputBegan:Connect(function(inp)
		if not listening then return end
		if inp.UserInputType == Enum.UserInputType.Keyboard then
			listening = false
			key       = inp.KeyCode
			kbtn.Text = key.Name
			kbtn.TextColor3 = T.Accent
			Tw(kbtn,    { BackgroundColor3 = Color3.fromRGB(30,30,30) }, 0.1)
			Tw(kStroke, { Color = T.Accent, Transparency = 0.5 }, 0.1)
			if cb then cb(key) end
		end
	end)
	_hoverEl(kbtn, f)
	return { Set = function(k) key = k kbtn.Text = k.Name end, Get = function() return key end }
end

function Elements.ColorPicker(parent, text, default, cb)
	local color = default or Color3.fromRGB(255, 80, 80)
	local h, s, v = Color3.toHSV(color)
	local open    = false
	local svDrag  = false
	local hueDrag = false
	local SV_W    = 180
	local SV_H    = 150
	local BAR_W   = 14
	local GAP     = 10
	local HEX_H   = 28
	local PAD     = 10
	local TOTAL_W = SV_W + GAP + BAR_W + PAD * 2
	local TOTAL_H = SV_H + GAP + HEX_H + PAD * 2
	local f = _elBase(parent, 44)
	_elLabel(f, text, 12, nil, 12, T.white, 4)
	local swatch = New("Frame", {
		Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, -38, 0.5, -13),
		BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 5, Parent = f,
	})
	New("UICorner", { CornerRadius = UDim.new(0,5), Parent = swatch })
	New("UIStroke", { Color = Color3.fromRGB(85,85,85), Thickness = 1, Parent = swatch })
	local panel = _floatPanel(nil, TOTAL_W, TOTAL_H)
	local svBox = New("Frame", {
		Size = UDim2.fromOffset(SV_W, SV_H), Position = UDim2.fromOffset(PAD, PAD),
		BackgroundColor3 = Color3.fromHSV(h,1,1),
		BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 122, Parent = panel,
	})
	New("UICorner", { CornerRadius = UDim.new(0,6), Parent = svBox })
	New("UIStroke", { Color = Color3.fromRGB(55,55,55), Thickness = 1, Transparency = 0.3, Parent = svBox })
	local svWhite = New("Frame", { Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, ZIndex = 123, Parent = svBox })
	New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1) }), Parent = svWhite })
	local svBlack = New("Frame", { Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.new(0,0,0), BorderSizePixel = 0, ZIndex = 124, Parent = svBox })
	New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0) }), Rotation = 90, Parent = svBlack })
	local svKnob = New("Frame", {
		Size = UDim2.fromOffset(12,12), Position = UDim2.new(s,-6,1-v,-6),
		BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, ZIndex = 125, Parent = svBox,
	})
	New("UICorner", { CornerRadius = UDim.new(1,0), Parent = svKnob })
	New("UIStroke", { Color = Color3.new(1,1,1), Thickness = 2, Parent = svKnob })
	local hueBar = New("Frame", {
		Size = UDim2.fromOffset(BAR_W, SV_H),
		Position = UDim2.fromOffset(PAD + SV_W + GAP, PAD),
		BackgroundColor3 = Color3.new(1,1,1),
		BorderSizePixel = 0, ClipsDescendants = false, ZIndex = 122, Parent = panel,
	})
	New("UICorner", { CornerRadius = UDim.new(1,0), Parent = hueBar })
	New("UIStroke", { Color = Color3.fromRGB(55,55,55), Thickness = 1, Transparency = 0.3, Parent = hueBar })
	local hKeys = {}
	for i = 0, 6 do table.insert(hKeys, ColorSequenceKeypoint.new(i/6, Color3.fromHSV(i/6,1,1))) end
	New("UIGradient", { Color = ColorSequence.new(hKeys), Rotation = 90, Parent = hueBar })
	local hueKnob = New("Frame", {
		Size = UDim2.fromOffset(20,8), Position = UDim2.new(0.5,-10,h,-4),
		BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, ZIndex = 123, Parent = hueBar,
	})
	New("UICorner", { CornerRadius = UDim.new(1,0), Parent = hueKnob })
	New("UIStroke", { Color = Color3.fromRGB(180,180,180), Thickness = 1.5, Parent = hueKnob })
	local hexY   = PAD + SV_H + GAP
	local hexBox = New("Frame", {
		Size = UDim2.fromOffset(SV_W + GAP + BAR_W, HEX_H),
		Position = UDim2.fromOffset(PAD, hexY),
		BackgroundColor3 = T.inputBg, BorderSizePixel = 0, ZIndex = 122, Parent = panel,
	})
	New("UICorner", { CornerRadius = UDim.new(0,6), Parent = hexBox })
	New("UIStroke", { Color = T.elBorder, Thickness = 1, Transparency = 0.3, Parent = hexBox })
	local hashLbl = New("TextLabel", {
		Size = UDim2.new(0,20,1,0), Position = UDim2.fromOffset(6,0),
		BackgroundTransparency = 1, Text = "#",
		TextColor3 = T.Accent, TextSize = 12, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 123, Parent = hexBox,
	})
	local hexInput = New("TextBox", {
		Size = UDim2.new(1,-52,1,0), Position = UDim2.fromOffset(24,0),
		BackgroundTransparency = 1, Text = color:ToHex():upper(),
		PlaceholderText = "RRGGBB", PlaceholderColor3 = T.dim,
		TextColor3 = T.white, TextSize = 11, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false, ZIndex = 123, Parent = hexBox,
	})
	local hexSwatch = New("Frame", {
		Size = UDim2.new(0,18,0,18), Position = UDim2.new(1,-22,0.5,-9),
		BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 123, Parent = hexBox,
	})
	New("UICorner", { CornerRadius = UDim.new(0,4), Parent = hexSwatch })
	New("UIStroke", { Color = Color3.fromRGB(70,70,70), Thickness = 1, Parent = hexSwatch })
	local function updateAll()
		color = Color3.fromHSV(h, s, v)
		swatch.BackgroundColor3    = color
		hexSwatch.BackgroundColor3 = color
		svBox.BackgroundColor3     = Color3.fromHSV(h,1,1)
		svKnob.Position            = UDim2.new(s,-6,1-v,-6)
		hueKnob.Position           = UDim2.new(0.5,-10,h,-4)
		hexInput.Text              = color:ToHex():upper()
		if cb then cb(color) end
	end
	hexInput.FocusLost:Connect(function(enter)
		if not enter then return end
		local txt = hexInput.Text:gsub("#","")
		local ok, c = pcall(Color3.fromHex, txt)
		if ok and typeof(c) == "Color3" then
			h, s, v = Color3.toHSV(c)
			updateAll()
		else
			hexInput.Text = color:ToHex():upper()
		end
	end)
	local svHit = New("TextButton", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "", ZIndex = 126, Parent = svBox })
	svHit.MouseButton1Down:Connect(function() svDrag = true end)
	local hueHit = New("TextButton", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "", ZIndex = 124, Parent = hueBar })
	hueHit.MouseButton1Down:Connect(function() hueDrag = true end)
	UIS.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			svDrag = false hueDrag = false
		end
	end)
	RS.RenderStepped:Connect(function()
		if svDrag then
			local mp = UIS:GetMouseLocation()
			local ab = svBox.AbsolutePosition
			local sz = svBox.AbsoluteSize
			s = math.clamp((mp.X - ab.X) / sz.X, 0, 1)
			v = 1 - math.clamp((mp.Y - ab.Y) / sz.Y, 0, 1)
			updateAll()
		end
		if hueDrag then
			local mp = UIS:GetMouseLocation()
			local ab = hueBar.AbsolutePosition
			local sz = hueBar.AbsoluteSize
			h = math.clamp((mp.Y - ab.Y) / sz.Y, 0, 1)
			updateAll()
		end
	end)
	local function closeCP()
		open = false
		Tw(panel, { Size = UDim2.fromOffset(panel.AbsoluteSize.X, 0) }, 0.16)
		task.delay(0.17, function()
			panel.Visible = false
			panel.Size = UDim2.fromOffset(TOTAL_W, TOTAL_H)
		end)
		for i, fn in ipairs(_openFloats) do
			if fn == closeCP then table.remove(_openFloats, i) break end
		end
	end
	UIS.InputBegan:Connect(function(inp)
		if inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
		if not open then return end
		local mp = UIS:GetMouseLocation()
		local ap = panel.AbsolutePosition
		local as = panel.AbsoluteSize
		if mp.X < ap.X or mp.X > ap.X + as.X or mp.Y < ap.Y or mp.Y > ap.Y + as.Y then
			closeCP()
		end
	end)
	local toggleBtn = New("TextButton", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "", ZIndex = 6, Parent = f })
	toggleBtn.MouseButton1Click:Connect(function()
		if open then closeCP() return end
		_closeAllFloats(closeCP)
		open = true
		panel.Size    = UDim2.fromOffset(TOTAL_W, 0)
		panel.Visible = true
		_anchorFloat(panel, f)
		Tw(panel, { Size = UDim2.fromOffset(TOTAL_W, TOTAL_H) }, 0.2)
		table.insert(_openFloats, closeCP)
		f:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
			if open then _anchorFloat(panel, f) end
		end)
	end)
	_hoverEl(toggleBtn, f)
	return {
		Set = function(c) color = c h,s,v = Color3.toHSV(c) updateAll() end,
		Get = function() return color end,
	}
end

local lib = {}

function lib:CreateWindow(opts)
	if type(opts) ~= "table" then
		print("[EcoHub] CreateWindow: opts deve ser uma tabela")
		opts = {}
	end

	local title    = opts.Title    or "Eco Hub"
	local subtitle = opts.Subtitle or ""

	local cfgPath = _cfgPath(title)

	local cfg         = readCfg(cfgPath)
	local sideExpanded = true
	local minimized    = false
	local dragging     = false
	local dragOff      = Vector2.zero
	local tabs         = {}
	local activeTab    = nil
	local secLabels    = {}
	local layoutOrder  = 0
	local curSW        = SIDE_FULL

	local guiName = "ecohub_" .. math.random(100000, 999999)
	local gui = New("ScreenGui", {
		Name = guiName, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 999, IgnoreGuiInset = true,
		Parent = (gethui and gethui()) or game:GetService("CoreGui"),
	})

	local main = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, PANEL_W, 0, PANEL_H),
		Position = UDim2.fromScale(0.5, 0.5), BackgroundColor3 = T.bg,
		BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 1, Parent = gui,
	})
	New("UIStroke", { Color = T.AcrylicBorder, Thickness = 1, Parent = main })

	local titleBar = New("Frame", {
		Size = UDim2.new(1, 0, 0, TITLE_H), BackgroundColor3 = T.surface,
		BorderSizePixel = 0, ZIndex = 8, Parent = main,
	})
	New("Frame", {
		Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = T.TitleBarLine, BorderSizePixel = 0, ZIndex = 9, Parent = titleBar,
	})
	New("TextLabel", {
		Size = UDim2.new(0, 200, 1, 0), Position = UDim2.new(0, 14, 0, 0),
		BackgroundTransparency = 1, Text = title, TextColor3 = T.white,
		TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 9, Parent = titleBar,
	})
	if subtitle ~= "" then
		New("TextLabel", {
			Size = UDim2.new(0, 80, 1, 0), Position = UDim2.new(1, -88, 0, 0),
			BackgroundTransparency = 1, Text = subtitle, TextColor3 = T.dim,
			TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Right,
			ZIndex = 9, Parent = titleBar,
		})
	end

	local sidebar = New("Frame", {
		Size = UDim2.new(0, curSW, 1, -TITLE_H), Position = UDim2.new(0, 0, 0, TITLE_H),
		BackgroundColor3 = T.sidebar, BorderSizePixel = 0, ClipsDescendants = true,
		ZIndex = 4, Parent = main,
	})
	local vdiv = New("Frame", {
		Size = UDim2.new(0, 1, 1, -TITLE_H), Position = UDim2.new(0, curSW, 0, TITLE_H),
		BackgroundColor3 = T.divider, BorderSizePixel = 0, ZIndex = 5, Parent = main,
	})

	local logoArea = New("Frame", {
		Size = UDim2.new(1, 0, 0, LOGO_H), BackgroundTransparency = 1, ZIndex = 5, Parent = sidebar,
	})
	local sideLogoImg = New("ImageLabel", {
		Size = UDim2.new(0, 76, 0, 76), Position = UDim2.new(0.5, -38, 0.5, -38),
		BackgroundTransparency = 1, Image = LOGO_ID, ImageColor3 = T.white, ZIndex = 6, Parent = logoArea,
	})
	New("Frame", {
		Size = UDim2.new(1, -24, 0, 1), Position = UDim2.new(0, 12, 1, -1),
		BackgroundColor3 = T.divider, BorderSizePixel = 0, ZIndex = 5, Parent = logoArea,
	})

	local sideScroll = New("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, -(LOGO_H + 98)), Position = UDim2.new(0, 0, 0, LOGO_H + 4),
		BackgroundTransparency = 1, ScrollBarThickness = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ZIndex = 5, Parent = sidebar,
	})
	New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1), Parent = sideScroll })
	New("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingTop = UDim.new(0, 4), Parent = sideScroll })

	New("Frame", {
		Size = UDim2.new(1, -12, 0, 1), Position = UDim2.new(0, 6, 1, -90),
		BackgroundColor3 = T.divider, BorderSizePixel = 0, ZIndex = 5, Parent = sidebar,
	})

	local collapseBtn = New("TextButton", {
		Size = UDim2.new(1, -12, 0, 28), Position = UDim2.new(0, 6, 1, -82),
		BackgroundColor3 = T.tabBgHov, BackgroundTransparency = 1,
		BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 5, Parent = sidebar,
	})
	New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = collapseBtn })
	local collapseIco   = Img(icon("chevron-left"), collapseBtn, 13, UDim2.new(1, -20, 0.5, -6.5), T.dimLight, 6)
	local collapseLabel = New("TextLabel", {
		Size = UDim2.new(1, -28, 1, 0), Position = UDim2.new(0, 8, 0, 0),
		BackgroundTransparency = 1, Text = "Recolher", TextColor3 = T.dimLight,
		TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 6, Parent = collapseBtn,
	})

	local avatarFrame = New("Frame", {
		Size = UDim2.new(1, -12, 0, 40), Position = UDim2.new(0, 6, 1, -46),
		BackgroundColor3 = T.avatarBg, BorderSizePixel = 0, ZIndex = 5, Parent = sidebar,
	})
	New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = avatarFrame })
	local avatarImg = New("ImageLabel", {
		Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(0, 7, 0.5, -13),
		BackgroundColor3 = T.dim, BorderSizePixel = 0, ZIndex = 6, Parent = avatarFrame,
	})
	New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = avatarImg })
	local avatarName = New("TextLabel", {
		Size = UDim2.new(1, -42, 0, 14), Position = UDim2.new(0, 40, 0, 5),
		BackgroundTransparency = 1, Text = lp.DisplayName, TextColor3 = T.white,
		TextSize = 11, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 6, Parent = avatarFrame,
	})
	local avatarTag = New("TextLabel", {
		Size = UDim2.new(1, -42, 0, 12), Position = UDim2.new(0, 40, 0, 20),
		BackgroundTransparency = 1, Text = "@" .. lp.Name, TextColor3 = T.dim,
		TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 6, Parent = avatarFrame,
	})
	task.spawn(function()
		local ok, url = pcall(function()
			return Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
		end)
		if ok then avatarImg.Image = url end
	end)

	local pageArea = New("Frame", {
		Size = UDim2.new(1, -(curSW + 1), 1, -TITLE_H), Position = UDim2.new(0, curSW + 1, 0, TITLE_H),
		BackgroundColor3 = T.pageBg, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 2, Parent = main,
	})

	local searchBar = New("Frame", {
		Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 10),
		BackgroundColor3 = T.searchBg, BorderSizePixel = 0, ZIndex = 6, Parent = pageArea,
	})
	New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = searchBar })
	New("UIStroke", { Color = T.divider, Thickness = 1, Parent = searchBar })
	Img(icon("search"), searchBar, 13, UDim2.new(0, 9, 0.5, -6.5), T.dim, 7)
	New("TextBox", {
		Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 26, 0, 0),
		BackgroundTransparency = 1, PlaceholderText = "Pesquisar...",
		PlaceholderColor3 = T.dim, Text = "", TextColor3 = T.white,
		TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false, ZIndex = 7, Parent = searchBar,
	})
	New("Frame", {
		Size = UDim2.new(1, -20, 0, 1), Position = UDim2.new(0, 10, 0, 48),
		BackgroundColor3 = T.divider, BorderSizePixel = 0, ZIndex = 5, Parent = pageArea,
	})

	local contentArea = New("Frame", {
		Size = UDim2.new(1, 0, 1, -54), Position = UDim2.new(0, 0, 0, 54),
		BackgroundColor3 = T.pageBg, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 2, Parent = pageArea,
	})

	local sideTabOrder = 0

	local function animUL(ul, instant)
		ul.Size = UDim2.new(0, 0, 0, 1) ul.Visible = true
		if instant then ul.Size = UDim2.new(1, -8, 0, 1)
		else Tw(ul, { Size = UDim2.new(1, -8, 0, 1) }, 0.22) end
	end

	local function selectTab(tab, instant)
		for _, t in ipairs(tabs) do
			if t ~= tab then
				t.page.Visible = false t.ul.Visible = false
				Tw(t.btn, { BackgroundTransparency = 1 }, 0.12)
				Tw(t.ico, { ImageColor3 = T.tabIdle }, 0.12)
				Tw(t.lbl, { TextColor3  = T.tabIdle }, 0.12)
			end
		end
		tab.page.Visible = true activeTab = tab
		Tw(tab.btn, { BackgroundColor3 = T.tabBgAct, BackgroundTransparency = 0 }, 0.12)
		Tw(tab.ico, { ImageColor3 = T.white }, 0.12)
		Tw(tab.lbl, { TextColor3  = T.tabAct }, 0.12)
		animUL(tab.ul, instant)
		cfg.activeTab = tab.name saveCfg(cfg)
	end

	local function setSide(expanded)
		sideExpanded = expanded
		local sw = expanded and SIDE_FULL or SIDE_MINI
		curSW = sw
		Tw(sidebar,  { Size     = UDim2.new(0, sw, 1, -TITLE_H) }, 0.2)
		Tw(vdiv,     { Position = UDim2.new(0, sw, 0, TITLE_H)  }, 0.2)
		Tw(pageArea, { Size = UDim2.new(1, -(sw+1), 1, -TITLE_H), Position = UDim2.new(0, sw+1, 0, TITLE_H) }, 0.2)
		local hide = expanded and 0 or 1
		for _, l in ipairs(secLabels) do Tw(l, { TextTransparency = hide }, 0.15) end
		for _, t in ipairs(tabs) do
			Tw(t.lbl, { TextTransparency = hide }, 0.15)
			t.ico.Position = expanded and UDim2.new(0, 7, 0.5, -7.5) or UDim2.new(0.5, -7.5, 0.5, -7.5)
			t.tip.Visible = false
		end
		Tw(avatarName, { TextTransparency = hide }, 0.15)
		Tw(avatarTag,  { TextTransparency = hide }, 0.15)
		avatarImg.Position = expanded and UDim2.new(0, 7, 0.5, -13) or UDim2.new(0.5, -13, 0.5, -13)
		if expanded then
			sideLogoImg.Size     = UDim2.new(0, 76, 0, 76)
			sideLogoImg.Position = UDim2.new(0.5, -38, 0.5, -38)
		else
			sideLogoImg.Size     = UDim2.new(0, 28, 0, 28)
			sideLogoImg.Position = UDim2.new(0.5, -14, 0.5, -14)
		end
		collapseIco.Image    = expanded and icon("chevron-left") or icon("chevron-right")
		collapseLabel.Text   = expanded and "Recolher" or "Expandir"
		collapseIco.Position = expanded and UDim2.new(1, -20, 0.5, -6.5) or UDim2.new(0.5, -6.5, 0.5, -6.5)
		Tw(collapseLabel, { TextTransparency = hide }, 0.15)
		cfg.sideExpanded = expanded saveCfg(cfg)
	end

	local function getTabByName(n)
		for _, t in ipairs(tabs) do if t.name == n then return t end end
	end

	if cfg.sideExpanded == false then setSide(false) end

	collapseBtn.MouseButton1Click:Connect(function() setSide(not sideExpanded) end)
	collapseBtn.MouseEnter:Connect(function()
		Tw(collapseBtn,   { BackgroundTransparency = 0, BackgroundColor3 = T.tabBgHov }, 0.1)
		Tw(collapseIco,   { ImageColor3 = T.white }, 0.1)
		Tw(collapseLabel, { TextColor3  = T.white }, 0.1)
	end)
	collapseBtn.MouseLeave:Connect(function()
		Tw(collapseBtn,   { BackgroundTransparency = 1 }, 0.1)
		Tw(collapseIco,   { ImageColor3 = T.dimLight }, 0.1)
		Tw(collapseLabel, { TextColor3  = T.dimLight }, 0.1)
	end)

	titleBar.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			local p = main.AbsolutePosition
			dragOff = Vector2.new(inp.Position.X - p.X, inp.Position.Y - p.Y)
		end
	end)
	titleBar.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
	RS.RenderStepped:Connect(function()
		if not dragging then return end
		local m = UIS:GetMouseLocation()
		main.Position = UDim2.new(0, m.X - dragOff.X + main.AbsoluteSize.X * 0.5, 0, m.Y - dragOff.Y + main.AbsoluteSize.Y * 0.5)
	end)

	UIS.InputBegan:Connect(function(inp, _)
		if inp.KeyCode == Enum.KeyCode.RightAlt then
			minimized = not minimized
			main.Visible = not minimized
			cfg.minimized = minimized
			saveCfg(cfgPath, cfg)
		end
	end)

	local window = {}

	local function makeSideLabel(labelText)
		sideTabOrder += 1
		New("Frame", {
			Size = UDim2.new(1, 0, 0, 6), BackgroundTransparency = 1,
			LayoutOrder = sideTabOrder, ZIndex = 5, Parent = sideScroll,
		})
		sideTabOrder += 1
		local row = New("Frame", {
			Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1,
			LayoutOrder = sideTabOrder, ZIndex = 5, Parent = sideScroll,
		})
		local sideLbl = New("TextLabel", {
			Size = UDim2.new(1, -4, 1, 0), Position = UDim2.new(0, 4, 0, 0),
			BackgroundTransparency = 1, Text = string.upper(labelText),
			TextColor3 = T.secText, TextSize = 9, Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6, Parent = row,
		})
		table.insert(secLabels, sideLbl)
	end

	local function makeContentSection(sectionName, scroll)
		Elements.Section(scroll, sectionName)
		local sec = {}
		function sec:AddToggle(text, default, cb)
			return Elements.Toggle(scroll, text, default, cb)
		end
		function sec:AddCheckbox(text, default, cb)
			return Elements.Checkbox(scroll, text, default, cb)
		end
		function sec:AddButton(text, cb)
			return Elements.Button(scroll, text, cb)
		end
		function sec:AddSlider(text, min, max, default, cb)
			return Elements.Slider(scroll, text, min, max, default, cb)
		end
		function sec:AddDropdown(text, options, default, cb)
			return Elements.Dropdown(scroll, text, options, default, cb)
		end
		function sec:AddKeybind(text, default, cb)
			return Elements.Keybind(scroll, text, default, cb)
		end
		function sec:AddColorPicker(text, default, cb)
			return Elements.ColorPicker(scroll, text, default, cb)
		end
		return sec
	end

	function window:AddSideLabel(labelText)
		if type(labelText) ~= "string" then
			print("[EcoHub] AddSideLabel: texto deve ser string")
			labelText = "Section"
		end
		makeSideLabel(labelText)
	end

	function window:AddTab(opts2)
		if type(opts2) ~= "table" then
			print("[EcoHub] AddTab: opts deve ser uma tabela")
			opts2 = {}
		end

		local tabTitle   = opts2.Title   or "Tab"
		local tabIcon    = opts2.Icon    or "circle"
		local tabSection = opts2.Section or nil

		if tabSection then
			makeSideLabel(tabSection)
		end

		sideTabOrder += 1

		local btn = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = T.tabBgAct,
			BackgroundTransparency = 1, BorderSizePixel = 0, Text = "",
			AutoButtonColor = false, LayoutOrder = sideTabOrder, ZIndex = 6, Parent = sideScroll,
		})
		New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
		local ico = Img(icon(tabIcon), btn, 15, UDim2.new(0, 7, 0.5, -7.5), T.tabIdle, 7)
		local lbl = New("TextLabel", {
			Size = UDim2.new(1, -28, 1, 0), Position = UDim2.new(0, 27, 0, 0),
			BackgroundTransparency = 1, Text = tabTitle, TextColor3 = T.tabIdle,
			TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 7, Parent = btn,
		})
		local ul = New("Frame", {
			Size = UDim2.new(0, 0, 0, 1), Position = UDim2.new(0, 4, 1, -1),
			BackgroundColor3 = T.underline, BorderSizePixel = 0, Visible = false, ZIndex = 9, Parent = btn,
		})
		local tip = New("TextLabel", {
			Size = UDim2.new(0, 90, 0, 24), Position = UDim2.new(1, 6, 0.5, -12),
			BackgroundColor3 = Color3.fromRGB(30, 30, 30), TextColor3 = T.white,
			TextSize = 11, Font = Enum.Font.Gotham, Text = tabTitle,
			TextXAlignment = Enum.TextXAlignment.Center, BackgroundTransparency = 0,
			ZIndex = 30, Visible = false, Parent = btn,
		})
		New("UICorner", { CornerRadius = UDim.new(0, 5), Parent = tip })

		local page = New("Frame", {
			Size = UDim2.fromScale(1, 1), BackgroundColor3 = T.pageBg,
			BorderSizePixel = 0, ClipsDescendants = true, Visible = false, ZIndex = 2, Parent = contentArea,
		})
		local scroll = New("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
			ScrollBarThickness = 3, ScrollBarImageColor3 = T.divider,
			CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ZIndex = 2, Parent = page,
		})
		New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = scroll })
		New("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = scroll })

		if tabSection then
			makeContentSection(tabSection, scroll)
		end

		local tab = { name = tabTitle, btn = btn, ico = ico, lbl = lbl, ul = ul, tip = tip, page = page, scroll = scroll }
		table.insert(tabs, tab)

		btn.MouseEnter:Connect(function()
			if activeTab ~= tab then
				Tw(btn, { BackgroundTransparency = 0, BackgroundColor3 = T.tabBgHov }, 0.1)
				Tw(ico, { ImageColor3 = T.tabHov }, 0.1)
				Tw(lbl, { TextColor3  = T.tabHov }, 0.1)
			end
			if not sideExpanded then tip.Visible = true end
		end)
		btn.MouseLeave:Connect(function()
			if activeTab ~= tab then
				Tw(btn, { BackgroundTransparency = 1 }, 0.1)
				Tw(ico, { ImageColor3 = T.tabIdle }, 0.1)
				Tw(lbl, { TextColor3  = T.tabIdle }, 0.1)
			end
			tip.Visible = false
		end)
		btn.MouseButton1Click:Connect(function() selectTab(tab) end)

		if #tabs == 1 then selectTab(tab, true) end
		if cfg.activeTab == tabTitle then selectTab(tab, true) end

		local tabObj = {}

		function tabObj:AddSection(sectionName)
			if type(sectionName) ~= "string" then
				print("[EcoHub] AddSection: nome deve ser string")
				sectionName = "Section"
			end
			return makeContentSection(sectionName, scroll)
		end

		function tabObj:AddToggle(text, default, cb)
			return Elements.Toggle(scroll, text, default, cb)
		end
		function tabObj:AddCheckbox(text, default, cb)
			return Elements.Checkbox(scroll, text, default, cb)
		end
		function tabObj:AddButton(text, cb)
			return Elements.Button(scroll, text, cb)
		end
		function tabObj:AddSlider(text, min, max, default, cb)
			return Elements.Slider(scroll, text, min, max, default, cb)
		end
		function tabObj:AddDropdown(text, options, default, cb)
			return Elements.Dropdown(scroll, text, options, default, cb)
		end
		function tabObj:AddKeybind(text, default, cb)
			return Elements.Keybind(scroll, text, default, cb)
		end
		function tabObj:AddColorPicker(text, default, cb)
			return Elements.ColorPicker(scroll, text, default, cb)
		end

		return tabObj
	end

	function window:Destroy()
		gui:Destroy()
	end

	return window
end

return lib
