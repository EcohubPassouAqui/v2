-- ╔══════════════════════════════════════════╗
-- ║           EcoHub UI Library v7           ║
-- ╚══════════════════════════════════════════╝

local UIS     = game:GetService("UserInputService")
local TS      = game:GetService("TweenService")
local RS      = game:GetService("RunService")
local Players = game:GetService("Players")
local HTTP    = game:GetService("HttpService")
local lp      = Players.LocalPlayer

-- ─── Mobile block ───────────────────────────────────────────────────────────
do
	local mobile = UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled
	if mobile then
		pcall(function() lp:Kick("[EcoHub] Unsupported device.") end)
		return
	end
end

-- ─── Cleanup old GUIs ───────────────────────────────────────────────────────
local function cleanOld(parent)
	if not parent then return end
	for _, v in ipairs(parent:GetChildren()) do
		if type(v.Name) == "string" and v.Name:sub(1,7) == "ecohub_" then
			pcall(function() v:Destroy() end)
		end
	end
end
pcall(function() cleanOld(game:GetService("CoreGui")) end)
pcall(function() if gethui then cleanOld(gethui()) end end)

-- ─── Icons ──────────────────────────────────────────────────────────────────
local _iconsOk, _iconsData = pcall(function()
	return loadstring(game:HttpGet(
		"https://raw.githubusercontent.com/EcohubPassouAqui/v2/refs/heads/main/icons"
	))()
end)
local _iconReg = (_iconsOk and type(_iconsData) == "table" and _iconsData.assets) or {}
local function icon(name)
	return _iconReg["lucide-" .. tostring(name)] or "rbxassetid://0"
end

-- ─── Config helpers ─────────────────────────────────────────────────────────
local _gameName = tostring(game.Name):gsub("[^%w%s%-_]",""):gsub("%s+","_"):sub(1,40)
if _gameName == "" then _gameName = "unknown" end

local function cfgPath(winTitle)
	local wn = tostring(winTitle):gsub("[^%w%s%-_]",""):gsub("%s+","_"):sub(1,28)
	if wn == "" then wn = "window" end
	return "ecohub/" .. _gameName .. "/" .. wn .. "_config.json"
end

local function mkFolders(path)
	pcall(function()
		local parts = string.split(path, "/")
		local acc = ""
		for i = 1, #parts - 1 do
			acc = i == 1 and parts[i] or (acc .. "/" .. parts[i])
			if not isfolder(acc) then makefolder(acc) end
		end
	end)
end

local function readCfg(path)
	local ok, d = pcall(function()
		mkFolders(path)
		return isfile(path) and HTTP:JSONDecode(readfile(path)) or {}
	end)
	return (ok and type(d) == "table") and d or {}
end

local function saveCfg(path, d)
	pcall(function() mkFolders(path) writefile(path, HTTP:JSONEncode(d)) end)
end

-- ─── Asset IDs ──────────────────────────────────────────────────────────────
local LOGO_ID  = "rbxassetid://134382458890933"
local NOISE_ID = "rbxassetid://9968344919"

-- ─── Layout constants ───────────────────────────────────────────────────────
local PANEL_W   = 580
local PANEL_H   = 460
local TITLE_H   = 36
local SIDE_W    = 165
local SIDE_MINI = 42
local LOGO_H    = 100
local EL_H      = 36

-- ─── Color palette ──────────────────────────────────────────────────────────
local T = {
	Accent     = Color3.fromRGB(220, 220, 220),
	AccentDim  = Color3.fromRGB(160, 160, 160),
	AccentSub  = Color3.fromRGB(100, 100, 100),
	bg         = Color3.fromRGB(13,  13,  13),
	surface    = Color3.fromRGB(17,  17,  17),
	sidebar    = Color3.fromRGB(15,  15,  15),
	divider    = Color3.fromRGB(32,  32,  32),
	white      = Color3.fromRGB(220, 220, 220),
	dim        = Color3.fromRGB(65,  65,  65),
	dimLight   = Color3.fromRGB(105, 105, 105),
	tabIdle    = Color3.fromRGB(85,  85,  85),
	tabHov     = Color3.fromRGB(155, 155, 155),
	tabAct     = Color3.fromRGB(220, 220, 220),
	tabBgHov   = Color3.fromRGB(24,  24,  24),
	tabBgAct   = Color3.fromRGB(28,  28,  28),
	searchBg   = Color3.fromRGB(19,  19,  19),
	avatarBg   = Color3.fromRGB(20,  20,  20),
	underline  = Color3.fromRGB(220, 220, 220),
	secText    = Color3.fromRGB(55,  55,  55),
	elBg       = Color3.fromRGB(19,  19,  19),
	elBgHov    = Color3.fromRGB(26,  26,  26),
	elBorder   = Color3.fromRGB(44,  44,  44),
	dropBg     = Color3.fromRGB(16,  16,  16),
	dropItem   = Color3.fromRGB(22,  22,  22),
	dropSel    = Color3.fromRGB(30,  30,  30),
	inputBg    = Color3.fromRGB(13,  13,  13),
	pageBg     = Color3.fromRGB(13,  13,  13),
	togOff     = Color3.fromRGB(32,  32,  32),
	sliderRail = Color3.fromRGB(24,  24,  24),
}

-- ─── Instance factory ───────────────────────────────────────────────────────
local function N(cls, props)
	local ok, o = pcall(Instance.new, cls)
	if not ok then return nil end
	for k, v in pairs(props) do
		if k ~= "Parent" then pcall(function() o[k] = v end) end
	end
	if props.Parent then pcall(function() o.Parent = props.Parent end) end
	return o
end

-- ─── Tween shorthand ────────────────────────────────────────────────────────
local function Tw(obj, goal, t, style, dir)
	if not obj then return end
	pcall(function()
		TS:Create(obj,
			TweenInfo.new(t or 0.18, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
			goal
		):Play()
	end)
end

-- ─── UI helpers ─────────────────────────────────────────────────────────────
local function Corner(par, r)
	N("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = par })
end

local function Stroke(par, col, thick, trans)
	N("UIStroke", { Color = col or T.elBorder, Thickness = thick or 1, Transparency = trans or 0, Parent = par })
end

local function Grad(par, c0, c1, rot)
	N("UIGradient", {
		Color    = ColorSequence.new({ ColorSequenceKeypoint.new(0,c0), ColorSequenceKeypoint.new(1,c1) }),
		Rotation = rot or 90,
		Parent   = par,
	})
end

local function Noise(par, alpha, zi)
	N("ImageLabel", {
		Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
		Image = NOISE_ID, ImageTransparency = alpha or 0.94,
		ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.new(0,64,0,64),
		ZIndex = zi or 99, Parent = par,
	})
end

local function Img(id, par, sz, pos, col, zi)
	return N("ImageLabel", {
		Size = UDim2.new(0,sz,0,sz), Position = pos,
		BackgroundTransparency = 1, Image = id,
		ImageColor3 = col or T.dim, ZIndex = zi or 5, Parent = par,
	})
end

-- ─── Layout order counter ───────────────────────────────────────────────────
local _order = 0
local function NextOrder() _order = _order + 1 return _order end

-- ─── Element base frame ─────────────────────────────────────────────────────
local function ElBase(par, h)
	local f = N("Frame", {
		Size             = UDim2.new(1, 0, 0, h or EL_H),
		BackgroundColor3 = T.elBg,
		BorderSizePixel  = 0,
		ClipsDescendants = false,
		LayoutOrder      = NextOrder(),
		ZIndex           = 3,
		Parent           = par,
	})
	Corner(f, 6)
	Stroke(f, T.elBorder, 1, 0.28)
	Grad(f, Color3.fromRGB(28,28,28), Color3.fromRGB(17,17,17), 90)
	Noise(f, 0.95, 4)
	return f
end

-- ─── Hover effect ───────────────────────────────────────────────────────────
local function HoverEl(btn, frame)
	if not btn or not frame then return end
	btn.MouseEnter:Connect(function() Tw(frame, {BackgroundColor3 = T.elBgHov}, 0.1) end)
	btn.MouseLeave:Connect(function() Tw(frame, {BackgroundColor3 = T.elBg},    0.1) end)
end

-- ─── Section divider ────────────────────────────────────────────────────────
local function MkSection(par, text)
	_order = _order + 1
	local wrap = N("Frame", {
		Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1,
		LayoutOrder = _order, ZIndex = 2, Parent = par,
	})
	local line = N("Frame", {
		Size = UDim2.new(1,-10,0,1), Position = UDim2.new(0,5,1,-1),
		BackgroundColor3 = T.divider, BorderSizePixel = 0, ZIndex = 2, Parent = wrap,
	})
	N("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0,    Color3.fromRGB(13,13,13)),
			ColorSequenceKeypoint.new(0.15, Color3.fromRGB(42,42,42)),
			ColorSequenceKeypoint.new(0.85, Color3.fromRGB(42,42,42)),
			ColorSequenceKeypoint.new(1,    Color3.fromRGB(13,13,13)),
		}),
		Parent = line,
	})
	N("TextLabel", {
		Size = UDim2.new(1,-10,1,0), Position = UDim2.new(0,5,0,0),
		BackgroundTransparency = 1, Text = string.upper(text),
		TextColor3 = T.secText, TextSize = 9, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3, Parent = wrap,
	})
	return wrap
end

-- ─── Global element registry (for search) ───────────────────────────────────
local _allElements = {}

local function RegEl(frame, labelText)
	table.insert(_allElements, { frame = frame, label = string.lower(labelText or "") })
end

-- ══════════════════════════════════════════════════════════════════════════════
-- ELEMENTS
-- ══════════════════════════════════════════════════════════════════════════════

-- ─── Toggle ─────────────────────────────────────────────────────────────────
local function MkToggle(par, text, default, cb, cfg, cpath, saveId)
	local state = default == true
	if saveId and cfg[saveId] ~= nil then state = cfg[saveId] == true end

	local f = ElBase(par, EL_H)
	RegEl(f, text)

	N("TextLabel", {
		Size = UDim2.new(1,-70,1,0), Position = UDim2.new(0,11,0,0),
		BackgroundTransparency = 1, Text = text, TextColor3 = T.white,
		TextSize = 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 4, Parent = f,
	})

	local TW, TH = 34, 18
	local track = N("Frame", {
		Size = UDim2.new(0,TW,0,TH), Position = UDim2.new(1,-(TW+10),0.5,-TH/2),
		BackgroundColor3 = state and T.Accent or T.togOff,
		BorderSizePixel = 0, ZIndex = 5, Parent = f,
	})
	Corner(track, TH)
	local tGrad = N("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, state and T.AccentDim or Color3.fromRGB(48,48,48)),
			ColorSequenceKeypoint.new(1, state and T.AccentSub or Color3.fromRGB(22,22,22)),
		}),
		Rotation = 90, Parent = track,
	})
	local tStr = N("UIStroke", {
		Color = state and T.Accent or Color3.fromRGB(52,52,52),
		Thickness = 1, Transparency = 0.3, Parent = track,
	})
	local KSZ = 12
	local knob = N("Frame", {
		Size = UDim2.new(0,KSZ,0,KSZ),
		Position = state and UDim2.new(1,-(KSZ+3),0.5,-KSZ/2) or UDim2.new(0,3,0.5,-KSZ/2),
		BackgroundColor3 = state and T.bg or T.white,
		BorderSizePixel = 0, ZIndex = 6, Parent = track,
	})
	Corner(knob, KSZ)

	local function refresh(s)
		Tw(track, {BackgroundColor3 = s and T.Accent or T.togOff}, 0.15)
		Tw(knob, {
			Position         = s and UDim2.new(1,-(KSZ+3),0.5,-KSZ/2) or UDim2.new(0,3,0.5,-KSZ/2),
			BackgroundColor3 = s and T.bg or T.white,
		}, 0.15, Enum.EasingStyle.Back)
		Tw(tStr, {Color = s and T.Accent or Color3.fromRGB(52,52,52)}, 0.13)
		if tGrad then
			tGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, s and T.AccentDim or Color3.fromRGB(48,48,48)),
				ColorSequenceKeypoint.new(1, s and T.AccentSub or Color3.fromRGB(22,22,22)),
			})
		end
	end

	local btn = N("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", ZIndex=7, Parent=f})
	btn.MouseButton1Click:Connect(function()
		state = not state
		refresh(state)
		if saveId then cfg[saveId] = state saveCfg(cpath, cfg) end
		pcall(function() if cb then cb(state) end end)
	end)
	HoverEl(btn, f)

	return {
		Set = function(v) state = v == true refresh(state) end,
		Get = function() return state end,
	}
end

-- ─── Checkbox ───────────────────────────────────────────────────────────────
local function MkCheckbox(par, text, default, cb, cfg, cpath, saveId)
	local state = default == true
	if saveId and cfg[saveId] ~= nil then state = cfg[saveId] == true end

	local f = ElBase(par, EL_H)
	RegEl(f, text)

	local BSZ = 16
	local box = N("Frame", {
		Size = UDim2.new(0,BSZ,0,BSZ), Position = UDim2.new(0,11,0.5,-BSZ/2),
		BackgroundColor3 = state and T.Accent or Color3.fromRGB(22,22,22),
		BorderSizePixel = 0, ZIndex = 5, Parent = f,
	})
	Corner(box, 4)
	local bStr = N("UIStroke", {
		Color = state and T.Accent or Color3.fromRGB(54,54,54), Thickness = 1.5, Parent = box,
	})
	local chk = N("ImageLabel", {
		Size = UDim2.new(0,10,0,10), Position = UDim2.new(0.5,-5,0.5,-5),
		BackgroundTransparency = 1, Image = icon("check"),
		ImageColor3 = T.bg, ImageTransparency = state and 0 or 1,
		ZIndex = 6, Parent = box,
	})
	N("TextLabel", {
		Size = UDim2.new(1,-(BSZ+22),1,0), Position = UDim2.new(0,BSZ+18,0,0),
		BackgroundTransparency = 1, Text = text, TextColor3 = T.white,
		TextSize = 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 4, Parent = f,
	})

	local function refresh(s)
		Tw(box,  {BackgroundColor3 = s and T.Accent or Color3.fromRGB(22,22,22)}, 0.14)
		Tw(bStr, {Color = s and T.Accent or Color3.fromRGB(54,54,54)}, 0.13)
		Tw(chk,  {ImageTransparency = s and 0 or 1}, 0.11)
	end

	local btn = N("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", ZIndex=7, Parent=f})
	btn.MouseButton1Click:Connect(function()
		state = not state
		refresh(state)
		if saveId then cfg[saveId] = state saveCfg(cpath, cfg) end
		pcall(function() if cb then cb(state) end end)
	end)
	HoverEl(btn, f)

	return {
		Set = function(v) state = v == true refresh(state) end,
		Get = function() return state end,
	}
end

-- ─── Button ─────────────────────────────────────────────────────────────────
local function MkButton(par, text, cb)
	local f = ElBase(par, EL_H)
	RegEl(f, text)

	N("TextLabel", {
		Size = UDim2.new(1,-36,1,0), Position = UDim2.new(0,11,0,0),
		BackgroundTransparency = 1, Text = text, TextColor3 = T.white,
		TextSize = 11, Font = Enum.Font.GothamSemibold,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 5, Parent = f,
	})
	local arrow = Img(icon("chevron-right"), f, 12, UDim2.new(1,-19,0.5,-6), T.dim, 5)

	local btn = N("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", ZIndex=7, Parent=f})
	btn.MouseEnter:Connect(function() Tw(f,{BackgroundColor3=T.elBgHov},0.1) Tw(arrow,{ImageColor3=T.Accent},0.1) end)
	btn.MouseLeave:Connect(function() Tw(f,{BackgroundColor3=T.elBg},0.1) Tw(arrow,{ImageColor3=T.dim},0.1) end)
	btn.MouseButton1Down:Connect(function() Tw(f,{BackgroundColor3=Color3.fromRGB(9,9,9)},0.06) end)
	btn.MouseButton1Up:Connect(function() Tw(f,{BackgroundColor3=T.elBgHov},0.06) end)
	btn.MouseButton1Click:Connect(function() pcall(function() if cb then cb() end end) end)

	return { Frame = f }
end

-- ─── Slider ─────────────────────────────────────────────────────────────────
local function MkSlider(par, text, minV, maxV, defV, cb, cfg, cpath, saveId)
	minV = minV or 0
	maxV = maxV or 100
	local val  = math.clamp(defV or minV, minV, maxV)
	if saveId and cfg[saveId] ~= nil then
		val = math.clamp(tonumber(cfg[saveId]) or val, minV, maxV)
	end
	local pct  = (val - minV) / math.max(maxV - minV, 0.001)
	local drag = false

	local f = ElBase(par, 48)
	RegEl(f, text)

	N("TextLabel", {
		Size = UDim2.new(1,-60,0,14), Position = UDim2.new(0,11,0,7),
		BackgroundTransparency = 1, Text = text, TextColor3 = T.white,
		TextSize = 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = f,
	})

	local badge = N("Frame", {
		Size = UDim2.new(0,42,0,16), Position = UDim2.new(1,-52,0,6),
		BackgroundColor3 = Color3.fromRGB(9,9,9), BorderSizePixel = 0, ZIndex = 4, Parent = f,
	})
	Corner(badge, 4)
	Stroke(badge, T.elBorder, 1, 0.15)
	local valLbl = N("TextLabel", {
		Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
		Text = tostring(math.round(val)), TextColor3 = T.Accent,
		TextSize = 10, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 5, Parent = badge,
	})

	local RAIL_H = 3
	local rail = N("Frame", {
		Size = UDim2.new(1,-22,0,RAIL_H), Position = UDim2.new(0,11,0,33),
		BackgroundColor3 = T.sliderRail, BorderSizePixel = 0, ZIndex = 4, Parent = f,
	})
	Corner(rail, RAIL_H)
	Stroke(rail, T.elBorder, 1, 0.25)

	local fill = N("Frame", {
		Size = UDim2.new(pct,0,1,0), BackgroundColor3 = T.Accent,
		BorderSizePixel = 0, ZIndex = 5, Parent = rail,
	})
	Corner(fill, RAIL_H)

	local inner = N("Frame", {
		BackgroundTransparency = 1, Position = UDim2.new(0,6,0,0),
		Size = UDim2.new(1,-12,1,0), ZIndex = 5, Parent = rail,
	})

	local KSZ = 11
	local knob = N("Frame", {
		Size = UDim2.new(0,KSZ,0,KSZ), AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.new(pct,0,0.5,0), BackgroundColor3 = T.white,
		BorderSizePixel = 0, ZIndex = 6, Parent = inner,
	})
	Corner(knob, KSZ)
	N("UIStroke", {Color = T.Accent, Thickness = 1.5, Parent = knob})

	local function setVal(v)
		val = math.clamp(math.round(v), minV, maxV)
		local p = (val - minV) / math.max(maxV - minV, 0.001)
		if fill   then fill.Size     = UDim2.new(p,0,1,0)   end
		if knob   then knob.Position = UDim2.new(p,0,0.5,0) end
		if valLbl then valLbl.Text   = tostring(val)         end
		if saveId then cfg[saveId] = val saveCfg(cpath, cfg) end
		pcall(function() if cb then cb(val) end end)
	end

	local hit = N("TextButton", {
		Size = UDim2.new(1,0,0,22), Position = UDim2.new(0,0,0,-9),
		BackgroundTransparency = 1, Text = "", ZIndex = 8, Parent = rail,
	})
	hit.MouseButton1Down:Connect(function()
		drag = true
		local mp = UIS:GetMouseLocation()
		local ab, sz = inner.AbsolutePosition, inner.AbsoluteSize
		setVal(minV + (maxV-minV) * math.clamp((mp.X-ab.X)/sz.X, 0, 1))
	end)
	hit.MouseEnter:Connect(function()
		Tw(f, {BackgroundColor3=T.elBgHov}, 0.1)
		Tw(knob, {Size=UDim2.new(0,KSZ+2,0,KSZ+2)}, 0.1, Enum.EasingStyle.Back)
	end)
	hit.MouseLeave:Connect(function()
		Tw(f, {BackgroundColor3=T.elBg}, 0.1)
		if not drag then Tw(knob, {Size=UDim2.new(0,KSZ,0,KSZ)}, 0.1, Enum.EasingStyle.Back) end
	end)
	UIS.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			if drag then Tw(knob, {Size=UDim2.new(0,KSZ,0,KSZ)}, 0.1, Enum.EasingStyle.Back) end
			drag = false
		end
	end)
	RS.RenderStepped:Connect(function()
		if not drag or not inner then return end
		local mp = UIS:GetMouseLocation()
		local ab, sz = inner.AbsolutePosition, inner.AbsoluteSize
		setVal(minV + (maxV-minV) * math.clamp((mp.X-ab.X)/sz.X, 0, 1))
	end)

	return {
		Set = function(v) setVal(v) end,
		Get = function() return val end,
	}
end

-- ─── Dropdown (inline) ──────────────────────────────────────────────────────
local function MkDropdown(par, text, options, defV, cb, cfg, cpath, saveId)
	local selected = defV or (options and options[1]) or ""
	if saveId and cfg[saveId] ~= nil then selected = tostring(cfg[saveId]) end
	options = options or {}
	local open    = false
	local ITEM_H  = 28

	_order = _order + 1
	local wrap = N("Frame", {
		Size             = UDim2.new(1, 0, 0, EL_H),
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		LayoutOrder      = _order,
		ZIndex           = 10,
		Parent           = par,
	})

	local header = N("Frame", {
		Size             = UDim2.new(1, 0, 0, EL_H),
		BackgroundColor3 = T.elBg,
		BorderSizePixel  = 0,
		ZIndex           = 11,
		Parent           = wrap,
	})
	Corner(header, 6)
	Stroke(header, T.elBorder, 1, 0.28)
	Grad(header, Color3.fromRGB(28,28,28), Color3.fromRGB(17,17,17), 90)
	Noise(header, 0.95, 12)
	RegEl(header, text)

	N("TextLabel", {
		Size = UDim2.new(1,-130,1,0), Position = UDim2.new(0,11,0,0),
		BackgroundTransparency = 1, Text = text, TextColor3 = T.white,
		TextSize = 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 12, Parent = header,
	})

	local selLbl = N("TextLabel", {
		Size = UDim2.new(0,88,1,0), Position = UDim2.new(1,-120,0,0),
		BackgroundTransparency = 1, Text = selected, TextColor3 = T.Accent,
		TextSize = 10, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 12, Parent = header,
	})

	local arrowBox = N("Frame", {
		Size = UDim2.new(0,22,0,22), Position = UDim2.new(1,-30,0.5,-11),
		BackgroundColor3 = Color3.fromRGB(22,22,22), BorderSizePixel = 0, ZIndex = 12, Parent = header,
	})
	Corner(arrowBox, 5)
	Stroke(arrowBox, T.elBorder, 1, 0.2)
	local arrow = Img(icon("chevron-down"), arrowBox, 11, UDim2.new(0.5,-5.5,0.5,-5.5), T.dimLight, 13)

	local listWrap = N("Frame", {
		Size             = UDim2.new(1, 0, 0, 0),
		Position         = UDim2.new(0, 0, 0, EL_H + 3),
		BackgroundColor3 = T.dropBg,
		BorderSizePixel  = 0,
		ClipsDescendants = true,
		ZIndex           = 10,
		Parent           = wrap,
	})
	Corner(listWrap, 6)
	Stroke(listWrap, T.elBorder, 1, 0.2)
	Grad(listWrap, Color3.fromRGB(24,24,24), Color3.fromRGB(14,14,14), 90)

	local listScroll = N("ScrollingFrame", {
		Size                = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		ScrollBarThickness  = 3,
		ScrollBarImageColor3 = T.Accent,
		CanvasSize          = UDim2.new(0,0,0,0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ZIndex              = 11,
		Parent              = listWrap,
	})
	N("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,2), Parent=listScroll})
	N("UIPadding", {PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4), Parent=listScroll})

	local MAX_ITEMS_SHOWN = 6
	local fullH = math.min(#options, MAX_ITEMS_SHOWN) * (ITEM_H + 2) + 10

	local function buildItems()
		for _, c in ipairs(listScroll:GetChildren()) do
			if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then
				pcall(function() c:Destroy() end)
			end
		end
		for i, opt in ipairs(options) do
			local isSel = opt == selected
			local row = N("Frame", {
				Size             = UDim2.new(1,0,0,ITEM_H),
				BackgroundColor3 = isSel and T.dropSel or T.dropBg,
				BackgroundTransparency = isSel and 0 or 1,
				BorderSizePixel  = 0,
				LayoutOrder      = i,
				ZIndex           = 12,
				Parent           = listScroll,
			})
			Corner(row, 5)
			if isSel then Stroke(row, T.Accent, 1, 0.6) end
			N("TextLabel", {
				Size = UDim2.new(1,-16,1,0), Position = UDim2.fromOffset(10,0),
				BackgroundTransparency = 1, Text = opt,
				TextColor3 = isSel and T.white or T.dimLight,
				TextSize = 10, Font = isSel and Enum.Font.GothamSemibold or Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = 13, Parent = row,
			})
			local ob = N("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", ZIndex=14, Parent=row})
			ob.MouseEnter:Connect(function()
				if not isSel then Tw(row, {BackgroundTransparency=0, BackgroundColor3=Color3.fromRGB(20,20,20)}, 0.07) end
			end)
			ob.MouseLeave:Connect(function()
				if not isSel then Tw(row, {BackgroundTransparency=1}, 0.07) end
			end)
			ob.MouseButton1Click:Connect(function()
				selected = opt
				if selLbl then selLbl.Text = selected end
				buildItems()
				if saveId then cfg[saveId] = selected saveCfg(cpath, cfg) end
				pcall(function() if cb then cb(selected) end end)
				open = false
				Tw(listWrap, {Size=UDim2.new(1,0,0,0)}, 0.18, Enum.EasingStyle.Quint)
				Tw(wrap,     {Size=UDim2.new(1,0,0,EL_H)}, 0.18, Enum.EasingStyle.Quint)
				Tw(arrow,    {Rotation=0, ImageColor3=T.dimLight}, 0.14)
				Tw(header,   {BackgroundColor3=T.elBg}, 0.12)
			end)
		end
	end
	buildItems()

	local togBtn = N("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", ZIndex=15, Parent=header})
	togBtn.MouseButton1Click:Connect(function()
		open = not open
		if open then
			buildItems()
			Tw(listWrap, {Size=UDim2.new(1,0,0,fullH)}, 0.2, Enum.EasingStyle.Quint)
			Tw(wrap,     {Size=UDim2.new(1,0,0,EL_H+3+fullH)}, 0.2, Enum.EasingStyle.Quint)
			Tw(arrow,    {Rotation=180, ImageColor3=T.Accent}, 0.15)
			Tw(header,   {BackgroundColor3=T.elBgHov}, 0.12)
		else
			Tw(listWrap, {Size=UDim2.new(1,0,0,0)}, 0.18, Enum.EasingStyle.Quint)
			Tw(wrap,     {Size=UDim2.new(1,0,0,EL_H)}, 0.18, Enum.EasingStyle.Quint)
			Tw(arrow,    {Rotation=0, ImageColor3=T.dimLight}, 0.14)
			Tw(header,   {BackgroundColor3=T.elBg}, 0.12)
		end
	end)
	togBtn.MouseEnter:Connect(function() if not open then Tw(header,{BackgroundColor3=T.elBgHov},0.1) end end)
	togBtn.MouseLeave:Connect(function() if not open then Tw(header,{BackgroundColor3=T.elBg},0.1) end end)

	return {
		Set        = function(v) selected = v if selLbl then selLbl.Text = v end buildItems() end,
		Get        = function() return selected end,
		SetOptions = function(o) options = o buildItems() end,
	}
end

-- ─── Keybind ─────────────────────────────────────────────────────────────────
local function MkKeybind(par, text, defKey, cb, cfg, cpath, saveId)
	local key = defKey or Enum.KeyCode.Unknown
	if saveId and cfg[saveId] then
		pcall(function() key = Enum.KeyCode[cfg[saveId]] or key end)
	end
	local listening = false

	local f = ElBase(par, EL_H)
	RegEl(f, text)

	N("TextLabel", {
		Size = UDim2.new(1,-108,1,0), Position = UDim2.new(0,11,0,0),
		BackgroundTransparency = 1, Text = text, TextColor3 = T.white,
		TextSize = 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 4, Parent = f,
	})

	local kBox = N("Frame", {
		Size = UDim2.new(0,90,0,22), Position = UDim2.new(1,-100,0.5,-11),
		BackgroundColor3 = Color3.fromRGB(16,16,16), BorderSizePixel = 0, ZIndex = 5, Parent = f,
	})
	Corner(kBox, 5)
	Grad(kBox, Color3.fromRGB(26,26,26), Color3.fromRGB(13,13,13), 90)
	Noise(kBox, 0.88, 6)
	local kStr = N("UIStroke", {Color=T.Accent, Thickness=1, Transparency=0.5, Parent=kBox})

	local kname = key == Enum.KeyCode.Unknown and "None" or key.Name
	local kLbl = N("TextLabel", {
		Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
		Text = "[ "..kname.." ]", TextColor3 = T.Accent,
		TextSize = 9, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 7, Parent = kBox,
	})

	local btn = N("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", ZIndex=8, Parent=f})
	btn.MouseButton1Click:Connect(function()
		listening = true
		if kLbl then kLbl.Text = "[ ... ]" kLbl.TextColor3 = T.dimLight end
		Tw(kStr, {Color=T.white, Transparency=0}, 0.1)
		Tw(kBox,  {BackgroundColor3=Color3.fromRGB(24,24,24)}, 0.1)
	end)
	UIS.InputBegan:Connect(function(inp)
		if not listening then return end
		if inp.UserInputType == Enum.UserInputType.Keyboard then
			listening = false
			if inp.KeyCode == Enum.KeyCode.Escape then
				local n = key == Enum.KeyCode.Unknown and "None" or key.Name
				if kLbl then kLbl.Text = "[ "..n.." ]" kLbl.TextColor3 = T.Accent end
			else
				key = inp.KeyCode
				if kLbl then kLbl.Text = "[ "..key.Name.." ]" kLbl.TextColor3 = T.Accent end
				if saveId then cfg[saveId] = key.Name saveCfg(cpath, cfg) end
				pcall(function() if cb then cb(key) end end)
			end
			Tw(kStr, {Color=T.Accent, Transparency=0.5}, 0.12)
			Tw(kBox,  {BackgroundColor3=Color3.fromRGB(16,16,16)}, 0.1)
		end
	end)
	HoverEl(btn, f)

	return {
		Set = function(k)
			key = k
			local n = k == Enum.KeyCode.Unknown and "None" or k.Name
			if kLbl then kLbl.Text = "[ "..n.." ]" end
		end,
		Get = function() return key end,
	}
end

-- ─── Color Picker — RGB Sliders (sem espaço invisível, com input hex) ────────
--
--  Quando aberto expande inline mostrando:
--   • Slider Red   (vermelho)
--   • Slider Green (verde)
--   • Slider Blue  (azul)
--   • Preview block da cor resultante
--   • Input #RRGGBB com auto-configuração dos sliders
--
local function MkColorPicker(par, text, defCol, cb, cfg, cpath, saveId)
	local color = defCol or Color3.fromRGB(255, 80, 80)
	if saveId and cfg[saveId] then
		pcall(function() color = Color3.fromHex(cfg[saveId]) end)
	end

	local open = false

	-- Layout dimensions
	local PAD       = 10
	local SLIDER_H  = 34   -- height per slider row
	local GAP_SL    = 4    -- gap between sliders
	local PREVIEW_H = 46   -- color preview height
	local HEX_H     = 28   -- hex input row height
	local GAP       = 6    -- gap between sections
	-- Total inner height (3 sliders + preview + hex + padding)
	local PICK_H = PAD
		+ SLIDER_H + GAP_SL
		+ SLIDER_H + GAP_SL
		+ SLIDER_H + GAP
		+ PREVIEW_H + GAP
		+ HEX_H + PAD

	-- ── Outer wrapper (grows when open, no invisible space) ────────────────
	_order = _order + 1
	local wrap = N("Frame", {
		Size                   = UDim2.new(1, 0, 0, EL_H),
		BackgroundTransparency = 1,
		ClipsDescendants       = false,
		LayoutOrder            = _order,
		ZIndex                 = 10,
		Parent                 = par,
	})

	-- ── Header ────────────────────────────────────────────────────────────
	local header = N("Frame", {
		Size             = UDim2.new(1, 0, 0, EL_H),
		BackgroundColor3 = T.elBg,
		BorderSizePixel  = 0,
		ZIndex           = 11,
		Parent           = wrap,
	})
	Corner(header, 6)
	Stroke(header, T.elBorder, 1, 0.28)
	Grad(header, Color3.fromRGB(28,28,28), Color3.fromRGB(17,17,17), 90)
	Noise(header, 0.95, 12)
	RegEl(header, text)

	N("TextLabel", {
		Size = UDim2.new(1,-52,1,0), Position = UDim2.new(0,11,0,0),
		BackgroundTransparency = 1, Text = text, TextColor3 = T.white,
		TextSize = 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 12, Parent = header,
	})
	-- small color swatch on header right
	local hSwatch = N("Frame", {
		Size = UDim2.new(0,22,0,22), Position = UDim2.new(1,-32,0.5,-11),
		BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 12, Parent = header,
	})
	Corner(hSwatch, 4)
	Stroke(hSwatch, Color3.fromRGB(70,70,70), 1, 0)

	-- ── Picker panel (collapsed by default) ───────────────────────────────
	local pickWrap = N("Frame", {
		Size             = UDim2.new(1, 0, 0, 0),
		Position         = UDim2.new(0, 0, 0, EL_H + 3),
		BackgroundColor3 = T.dropBg,
		BorderSizePixel  = 0,
		ClipsDescendants = true,
		ZIndex           = 10,
		Parent           = wrap,
	})
	Corner(pickWrap, 6)
	Stroke(pickWrap, T.elBorder, 1, 0.2)
	Grad(pickWrap, Color3.fromRGB(24,24,24), Color3.fromRGB(14,14,14), 90)

	-- Fixed-height inner container (never resizes, avoids phantom space)
	local pickInner = N("Frame", {
		Size                   = UDim2.new(1, 0, 0, PICK_H),
		BackgroundTransparency = 1,
		ZIndex                 = 11,
		Parent                 = pickWrap,
	})

	-- ── RGB values from initial color ─────────────────────────────────────
	local rV = math.round(color.R * 255)
	local gV = math.round(color.G * 255)
	local bV = math.round(color.B * 255)

	-- ── Helper: build one RGB slider row ─────────────────────────────────
	-- Returns table with references needed to update the visual
	local function makeRGBRow(labelText, yOff, fillCol, initVal)
		local RAIL_H = 3
		local KSZ    = 11

		-- channel label
		N("TextLabel", {
			Size = UDim2.new(0,40,0,SLIDER_H),
			Position = UDim2.fromOffset(PAD, yOff),
			BackgroundTransparency = 1, Text = labelText,
			TextColor3 = T.dimLight, TextSize = 10, Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 13, Parent = pickInner,
		})

		-- value badge (right side)
		local badge = N("Frame", {
			Size = UDim2.new(0,32,0,18),
			Position = UDim2.new(1, -PAD-32, 0, yOff + (SLIDER_H-18)/2),
			BackgroundColor3 = Color3.fromRGB(9,9,9), BorderSizePixel = 0, ZIndex = 13, Parent = pickInner,
		})
		Corner(badge, 4)
		Stroke(badge, T.elBorder, 1, 0.15)
		local valLbl = N("TextLabel", {
			Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
			Text = tostring(initVal), TextColor3 = T.Accent,
			TextSize = 9, Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 14, Parent = badge,
		})

		-- rail
		local railOffL = PAD + 44
		local railOffR = PAD + 44 + PAD + 36   -- distance from right edge taken by badge
		local rail = N("Frame", {
			Size = UDim2.new(1, -(railOffL + railOffR - PAD), 0, RAIL_H),
			Position = UDim2.new(0, railOffL, 0, yOff + (SLIDER_H - RAIL_H)/2),
			BackgroundColor3 = T.sliderRail, BorderSizePixel = 0, ZIndex = 13, Parent = pickInner,
		})
		Corner(rail, RAIL_H)
		Stroke(rail, T.elBorder, 1, 0.3)

		local pct  = initVal / 255
		local fill = N("Frame", {
			Size = UDim2.new(pct, 0, 1, 0),
			BackgroundColor3 = fillCol,
			BorderSizePixel = 0, ZIndex = 14, Parent = rail,
		})
		Corner(fill, RAIL_H)

		local inner = N("Frame", {
			Size = UDim2.new(1, -12, 1, 0),
			Position = UDim2.new(0, 6, 0, 0),
			BackgroundTransparency = 1, ZIndex = 14, Parent = rail,
		})

		local knob = N("Frame", {
			Size = UDim2.new(0, KSZ, 0, KSZ),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(pct, 0, 0.5, 0),
			BackgroundColor3 = T.white,
			BorderSizePixel = 0, ZIndex = 15, Parent = inner,
		})
		Corner(knob, KSZ)
		N("UIStroke", {Color = fillCol, Thickness = 1.5, Parent = knob})

		-- wider invisible hit area
		local hit = N("TextButton", {
			Size = UDim2.new(1, 0, 0, 24),
			Position = UDim2.new(0, 0, 0, -10),
			BackgroundTransparency = 1, Text = "", ZIndex = 16, Parent = rail,
		})

		return {
			fill = fill, knob = knob, inner = inner,
			valLbl = valLbl, hit = hit, KSZ = KSZ,
		}
	end

	local y1 = PAD
	local y2 = y1 + SLIDER_H + GAP_SL
	local y3 = y2 + SLIDER_H + GAP_SL

	local sR = makeRGBRow("Red",   y1, Color3.fromRGB(220, 60,  60),  rV)
	local sG = makeRGBRow("Green", y2, Color3.fromRGB(60,  200, 80),  gV)
	local sB = makeRGBRow("Blue",  y3, Color3.fromRGB(60,  130, 220), bV)

	-- ── Preview block ──────────────────────────────────────────────────────
	local prevY = y3 + SLIDER_H + GAP
	local preview = N("Frame", {
		Size = UDim2.new(1, -(PAD*2), 0, PREVIEW_H),
		Position = UDim2.fromOffset(PAD, prevY),
		BackgroundColor3 = color,
		BorderSizePixel = 0, ZIndex = 12, Parent = pickInner,
	})
	Corner(preview, 6)
	Stroke(preview, T.elBorder, 1, 0.15)

	-- ── Hex input row ──────────────────────────────────────────────────────
	local hexY = prevY + PREVIEW_H + GAP
	local hexRow = N("Frame", {
		Size = UDim2.new(1, -(PAD*2), 0, HEX_H),
		Position = UDim2.fromOffset(PAD, hexY),
		BackgroundColor3 = T.inputBg,
		BorderSizePixel = 0, ZIndex = 12, Parent = pickInner,
	})
	Corner(hexRow, 5)
	Stroke(hexRow, T.elBorder, 1, 0.2)

	N("TextLabel", {
		Size = UDim2.new(0,18,1,0), Position = UDim2.fromOffset(6,0),
		BackgroundTransparency = 1, Text = "#", TextColor3 = T.Accent,
		TextSize = 11, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 13, Parent = hexRow,
	})
	local hexInput = N("TextBox", {
		Size = UDim2.new(1,-50,1,0), Position = UDim2.fromOffset(22,0),
		BackgroundTransparency = 1,
		Text = color:ToHex():upper(),
		PlaceholderText = "RRGGBB", PlaceholderColor3 = T.dim,
		TextColor3 = T.white, TextSize = 10, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false, ZIndex = 13, Parent = hexRow,
	})
	local hexSwatch = N("Frame", {
		Size = UDim2.new(0,16,0,16),
		Position = UDim2.new(1,-22,0.5,-8),
		BackgroundColor3 = color,
		BorderSizePixel = 0, ZIndex = 13, Parent = hexRow,
	})
	Corner(hexSwatch, 3)
	Stroke(hexSwatch, Color3.fromRGB(60,60,60), 1, 0)

	-- ── Sync all visuals from rV/gV/bV ────────────────────────────────────
	local function syncAll(skipHexUpdate)
		color = Color3.fromRGB(rV, gV, bV)
		pcall(function()
			hSwatch.BackgroundColor3  = color
			preview.BackgroundColor3  = color
			hexSwatch.BackgroundColor3 = color
			if not skipHexUpdate and hexInput then
				hexInput.Text = color:ToHex():upper()
			end
		end)
		if saveId then cfg[saveId] = color:ToHex() saveCfg(cpath, cfg) end
		pcall(function() if cb then cb(color) end end)
	end

	-- Apply one slider visually and return clamped int value
	local function applySlider(sl, rawVal)
		local v = math.clamp(math.round(rawVal), 0, 255)
		local p = v / 255
		sl.fill.Size     = UDim2.new(p, 0, 1, 0)
		sl.knob.Position = UDim2.new(p, 0, 0.5, 0)
		sl.valLbl.Text   = tostring(v)
		return v
	end

	-- Wire a slider's drag behavior
	local function wireSlider(sl, setFn)
		local dragActive = false
		sl.hit.MouseButton1Down:Connect(function()
			dragActive = true
			local mp = UIS:GetMouseLocation()
			local ab = sl.inner.AbsolutePosition
			local sz = sl.inner.AbsoluteSize
			local v  = applySlider(sl, math.clamp((mp.X-ab.X)/sz.X, 0, 1) * 255)
			setFn(v) ; syncAll(false)
		end)
		sl.hit.MouseEnter:Connect(function()
			Tw(sl.knob, {Size=UDim2.new(0,sl.KSZ+2,0,sl.KSZ+2)}, 0.1, Enum.EasingStyle.Back)
		end)
		sl.hit.MouseLeave:Connect(function()
			if not dragActive then
				Tw(sl.knob, {Size=UDim2.new(0,sl.KSZ,0,sl.KSZ)}, 0.1, Enum.EasingStyle.Back)
			end
		end)
		UIS.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then
				if dragActive then
					Tw(sl.knob, {Size=UDim2.new(0,sl.KSZ,0,sl.KSZ)}, 0.1, Enum.EasingStyle.Back)
				end
				dragActive = false
			end
		end)
		RS.RenderStepped:Connect(function()
			if not dragActive or not open then return end
			local mp = UIS:GetMouseLocation()
			local ab = sl.inner.AbsolutePosition
			local sz = sl.inner.AbsoluteSize
			local v  = applySlider(sl, math.clamp((mp.X-ab.X)/sz.X, 0, 1) * 255)
			setFn(v) ; syncAll(false)
		end)
	end

	wireSlider(sR, function(v) rV = v end)
	wireSlider(sG, function(v) gV = v end)
	wireSlider(sB, function(v) bV = v end)

	-- ── Hex input → update sliders automatically ───────────────────────────
	if hexInput then
		hexInput.FocusLost:Connect(function(enter)
			if not enter then return end
			-- strip non-hex characters
			local txt = hexInput.Text:gsub("[^%x]","")
			-- support shorthand #RGB
			if #txt == 3 then
				txt = txt:sub(1,1):rep(2) .. txt:sub(2,2):rep(2) .. txt:sub(3,3):rep(2)
			end
			local ok2, c2 = pcall(Color3.fromHex, txt)
			if ok2 and typeof(c2) == "Color3" then
				rV = math.round(c2.R * 255)
				gV = math.round(c2.G * 255)
				bV = math.round(c2.B * 255)
				applySlider(sR, rV)
				applySlider(sG, gV)
				applySlider(sB, bV)
				syncAll(true)
				-- update input to canonical uppercase
				hexInput.Text = color:ToHex():upper()
			else
				hexInput.Text = color:ToHex():upper()
			end
		end)
	end

	-- ── Toggle open / close ────────────────────────────────────────────────
	local togBtn = N("TextButton", {
		Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
		Text = "", ZIndex = 15, Parent = header,
	})
	togBtn.MouseButton1Click:Connect(function()
		open = not open
		if open then
			Tw(pickWrap, {Size = UDim2.new(1,0,0,PICK_H)},         0.2, Enum.EasingStyle.Quint)
			Tw(wrap,     {Size = UDim2.new(1,0,0,EL_H+3+PICK_H)}, 0.2, Enum.EasingStyle.Quint)
			Tw(header,   {BackgroundColor3 = T.elBgHov},            0.12)
		else
			Tw(pickWrap, {Size = UDim2.new(1,0,0,0)},    0.18, Enum.EasingStyle.Quint)
			Tw(wrap,     {Size = UDim2.new(1,0,0,EL_H)}, 0.18, Enum.EasingStyle.Quint)
			Tw(header,   {BackgroundColor3 = T.elBg},     0.12)
		end
	end)
	togBtn.MouseEnter:Connect(function()
		if not open then Tw(header, {BackgroundColor3=T.elBgHov}, 0.1) end
	end)
	togBtn.MouseLeave:Connect(function()
		if not open then Tw(header, {BackgroundColor3=T.elBg}, 0.1) end
	end)

	return {
		Set = function(c)
			color = c
			rV = math.round(c.R * 255)
			gV = math.round(c.G * 255)
			bV = math.round(c.B * 255)
			applySlider(sR, rV)
			applySlider(sG, gV)
			applySlider(sB, bV)
			syncAll(false)
		end,
		Get = function() return color end,
	}
end

-- ══════════════════════════════════════════════════════════════════════════════
-- SECTION OBJECT
-- ══════════════════════════════════════════════════════════════════════════════

local function MkSecObj(scroll, cfg, cpath)
	local obj = {}

	function obj:AddToggle(text, default, callback, saveId)
		return MkToggle(scroll, text, default, callback, cfg, cpath, saveId)
	end
	function obj:AddCheckbox(text, default, callback, saveId)
		return MkCheckbox(scroll, text, default, callback, cfg, cpath, saveId)
	end
	function obj:AddButton(text, callback)
		return MkButton(scroll, text, callback)
	end
	function obj:AddSlider(text, minV, maxV, defV, callback, saveId)
		return MkSlider(scroll, text, minV, maxV, defV, callback, cfg, cpath, saveId)
	end
	function obj:AddDropdown(text, opts, defV, callback, saveId)
		return MkDropdown(scroll, text, opts, defV, callback, cfg, cpath, saveId)
	end
	function obj:AddKeybind(text, defKey, callback, saveId)
		return MkKeybind(scroll, text, defKey, callback, cfg, cpath, saveId)
	end
	function obj:AddColorPicker(text, defCol, callback, saveId)
		return MkColorPicker(scroll, text, defCol, callback, cfg, cpath, saveId)
	end
	function obj:AddSection(name)
		MkSection(scroll, name or "Section")
		return MkSecObj(scroll, cfg, cpath)
	end

	return obj
end

-- ══════════════════════════════════════════════════════════════════════════════
-- LIBRARY  —  CreateWindow
-- ══════════════════════════════════════════════════════════════════════════════

local lib = {}

function lib:CreateWindow(opts)
	opts = type(opts) == "table" and opts or {}
	local title    = opts.Title    or "Eco Hub"
	local subtitle = opts.Subtitle or ""

	local cpath        = cfgPath(title)
	local cfg          = readCfg(cpath)
	local sideExpanded = true
	local minimized    = false
	local dragging     = false
	local dragOff      = Vector2.zero
	local tabs         = {}
	local activeTab    = nil
	local secLabels    = {}
	local sideOrder    = 0
	local curSW        = SIDE_W
	local searchActive = false

	local guiParent
	pcall(function() guiParent = gethui and gethui() end)
	guiParent = guiParent or game:GetService("CoreGui")

	local gui = N("ScreenGui", {
		Name           = "ecohub_" .. math.random(100000,999999),
		ResetOnSpawn   = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder   = 999,
		IgnoreGuiInset = true,
		Parent         = guiParent,
	})

	local main = N("Frame", {
		AnchorPoint      = Vector2.new(0.5,0.5),
		Size             = UDim2.new(0,PANEL_W,0,PANEL_H),
		Position         = UDim2.fromScale(0.5,0.5),
		BackgroundColor3 = T.bg,
		BorderSizePixel  = 0,
		ClipsDescendants = true,
		ZIndex           = 1,
		Parent           = gui,
	})

	local titleBar = N("Frame",{
		Size=UDim2.new(1,0,0,TITLE_H),
		BackgroundColor3=T.surface, BorderSizePixel=0, ZIndex=8, Parent=main,
	})
	Grad(titleBar, Color3.fromRGB(22,22,22), Color3.fromRGB(15,15,15), 90)
	Noise(titleBar, 0.92, 9)
	N("Frame",{
		Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
		BackgroundColor3=T.divider, BorderSizePixel=0, ZIndex=9, Parent=titleBar,
	})
	N("TextLabel",{
		Size=UDim2.new(0,200,1,0), Position=UDim2.new(0,12,0,0),
		BackgroundTransparency=1, Text=title, TextColor3=T.white,
		TextSize=13, Font=Enum.Font.GothamBold,
		TextXAlignment=Enum.TextXAlignment.Left, ZIndex=10, Parent=titleBar,
	})
	if subtitle ~= "" then
		N("TextLabel",{
			Size=UDim2.new(0,60,1,0), Position=UDim2.new(1,-68,0,0),
			BackgroundTransparency=1, Text=subtitle, TextColor3=T.dim,
			TextSize=10, Font=Enum.Font.Gotham,
			TextXAlignment=Enum.TextXAlignment.Right, ZIndex=10, Parent=titleBar,
		})
	end

	local sidebar = N("Frame",{
		Size=UDim2.new(0,curSW,1,-TITLE_H), Position=UDim2.new(0,0,0,TITLE_H),
		BackgroundColor3=T.sidebar, BorderSizePixel=0, ClipsDescendants=true,
		ZIndex=4, Parent=main,
	})
	Grad(sidebar, Color3.fromRGB(19,19,19), Color3.fromRGB(12,12,12), 90)
	Noise(sidebar, 0.93, 5)

	local vdiv = N("Frame",{
		Size=UDim2.new(0,1,1,-TITLE_H), Position=UDim2.new(0,curSW,0,TITLE_H),
		BackgroundColor3=T.divider, BorderSizePixel=0, ZIndex=5, Parent=main,
	})

	local logoArea = N("Frame",{
		Size=UDim2.new(1,0,0,LOGO_H), BackgroundTransparency=1, ZIndex=5, Parent=sidebar,
	})
	local sideLogoImg = N("ImageLabel",{
		Size=UDim2.new(0,72,0,72), Position=UDim2.new(0.5,-36,0.5,-36),
		BackgroundTransparency=1, Image=LOGO_ID, ZIndex=6, Parent=logoArea,
	})
	N("Frame",{
		Size=UDim2.new(1,-20,0,1), Position=UDim2.new(0,10,1,-1),
		BackgroundColor3=T.divider, BorderSizePixel=0, ZIndex=5, Parent=logoArea,
	})

	local sideScroll = N("ScrollingFrame",{
		Size=UDim2.new(1,0,1,-(LOGO_H+72)), Position=UDim2.new(0,0,0,LOGO_H+2),
		BackgroundTransparency=1, ScrollBarThickness=0,
		CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
		ZIndex=5, Parent=sidebar,
	})
	N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,1),Parent=sideScroll})
	N("UIPadding",{PaddingLeft=UDim.new(0,5),PaddingRight=UDim.new(0,5),PaddingTop=UDim.new(0,3),Parent=sideScroll})

	N("Frame",{
		Size=UDim2.new(1,-10,0,1), Position=UDim2.new(0,5,1,-66),
		BackgroundColor3=T.divider, BorderSizePixel=0, ZIndex=5, Parent=sidebar,
	})

	local colBtn = N("TextButton",{
		Size=UDim2.new(1,-10,0,22), Position=UDim2.new(0,5,1,-60),
		BackgroundColor3=T.tabBgHov, BackgroundTransparency=1,
		BorderSizePixel=0, Text="", AutoButtonColor=false, ZIndex=5, Parent=sidebar,
	})
	Corner(colBtn, 5)
	local colIco = Img(icon("chevron-left"), colBtn, 12, UDim2.new(1,-15,0.5,-6), T.dimLight, 6)
	local colLbl = N("TextLabel",{
		Size=UDim2.new(1,-22,1,0), Position=UDim2.new(0,7,0,0),
		BackgroundTransparency=1, Text="Collapse", TextColor3=T.dimLight,
		TextSize=10, Font=Enum.Font.Gotham,
		TextXAlignment=Enum.TextXAlignment.Left, ZIndex=6, Parent=colBtn,
	})

	local avFrame = N("Frame",{
		Size=UDim2.new(1,-10,0,32), Position=UDim2.new(0,5,1,-34),
		BackgroundColor3=T.avatarBg, BorderSizePixel=0, ZIndex=5, Parent=sidebar,
	})
	Corner(avFrame, 6)
	Stroke(avFrame, T.elBorder, 1, 0.3)
	local avImg = N("ImageLabel",{
		Size=UDim2.new(0,20,0,20), Position=UDim2.new(0,6,0.5,-10),
		BackgroundColor3=T.dim, BorderSizePixel=0, ZIndex=6, Parent=avFrame,
	})
	Corner(avImg, 10)
	local avName = N("TextLabel",{
		Size=UDim2.new(1,-32,0,12), Position=UDim2.new(0,30,0,5),
		BackgroundTransparency=1, Text=lp.DisplayName, TextColor3=T.white,
		TextSize=10, Font=Enum.Font.GothamBold,
		TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd,
		ZIndex=6, Parent=avFrame,
	})
	local avTag = N("TextLabel",{
		Size=UDim2.new(1,-32,0,10), Position=UDim2.new(0,30,0,17),
		BackgroundTransparency=1, Text="@"..lp.Name, TextColor3=T.dim,
		TextSize=9, Font=Enum.Font.Gotham,
		TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd,
		ZIndex=6, Parent=avFrame,
	})
	task.spawn(function()
		local ok, url = pcall(function()
			return Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
		end)
		if ok and avImg then avImg.Image = url end
	end)

	local pageArea = N("Frame",{
		Size=UDim2.new(1,-(curSW+1),1,-TITLE_H), Position=UDim2.new(0,curSW+1,0,TITLE_H),
		BackgroundColor3=T.pageBg, BorderSizePixel=0, ClipsDescendants=true,
		ZIndex=2, Parent=main,
	})

	local searchBar = N("Frame",{
		Size=UDim2.new(1,-14,0,26), Position=UDim2.new(0,7,0,7),
		BackgroundColor3=T.searchBg, BorderSizePixel=0, ZIndex=5, Parent=pageArea,
	})
	Corner(searchBar, 5)
	Stroke(searchBar, T.elBorder, 1, 0.2)
	Noise(searchBar, 0.93, 6)
	Img(icon("search"), searchBar, 11, UDim2.new(0,7,0.5,-5.5), T.dim, 7)
	local searchBox = N("TextBox",{
		Size=UDim2.new(1,-24,1,0), Position=UDim2.new(0,22,0,0),
		BackgroundTransparency=1, PlaceholderText="Search elements...",
		PlaceholderColor3=T.dim, Text="", TextColor3=T.white,
		TextSize=10, Font=Enum.Font.Gotham,
		TextXAlignment=Enum.TextXAlignment.Left,
		ClearTextOnFocus=false, ZIndex=7, Parent=searchBar,
	})

	N("Frame",{
		Size=UDim2.new(1,-14,0,1), Position=UDim2.new(0,7,0,41),
		BackgroundColor3=T.divider, BorderSizePixel=0, ZIndex=4, Parent=pageArea,
	})

	local contentArea = N("Frame",{
		Size=UDim2.new(1,0,1,-42), Position=UDim2.new(0,0,0,42),
		BackgroundColor3=T.pageBg, BorderSizePixel=0, ClipsDescendants=true,
		ZIndex=2, Parent=pageArea,
	})

	local searchPage = N("ScrollingFrame",{
		Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
		ScrollBarThickness=3, ScrollBarImageColor3=T.Accent,
		CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
		Visible=false, ZIndex=2, Parent=contentArea,
	})
	N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,5),Parent=searchPage})
	N("UIPadding",{
		PaddingTop=UDim.new(0,8), PaddingBottom=UDim.new(0,10),
		PaddingLeft=UDim.new(0,9), PaddingRight=UDim.new(0,9),
		Parent=searchPage,
	})
	local noResultLbl = N("TextLabel",{
		Size=UDim2.new(1,0,0,30), LayoutOrder=999,
		BackgroundTransparency=1, Text="No results found.",
		TextColor3=T.dimLight, TextSize=11, Font=Enum.Font.Gotham,
		TextXAlignment=Enum.TextXAlignment.Center, Visible=false,
		ZIndex=3, Parent=searchPage,
	})

	-- Tracks frames temporarily moved into searchPage so we can restore them
	local _movedEntries = {}  -- { frame, origParent, origLayoutOrder }

	local function restoreSearchFrames()
		for _, m in ipairs(_movedEntries) do
			pcall(function()
				m.frame.LayoutOrder = m.origOrder
				m.frame.Parent      = m.origParent
			end)
		end
		_movedEntries = {}
	end

	local function doSearch(query)
		query = string.lower(query or "")

		-- Restore any previously moved frames first
		restoreSearchFrames()

		if query == "" then
			searchActive = false
			searchPage.Visible = false
			if activeTab and activeTab.page then activeTab.page.Visible = true end
			return
		end

		searchActive = true
		if activeTab and activeTab.page then activeTab.page.Visible = false end
		searchPage.Visible = true

		-- Clear stale refs from searchPage (UIListLayout/UIPadding/noResultLbl stay)
		for _, c in ipairs(searchPage:GetChildren()) do
			if not c:IsA("UIListLayout") and not c:IsA("UIPadding") and c ~= noResultLbl then
				pcall(function() c.Parent = nil end)
			end
		end

		local count, order = 0, 0
		for _, entry in ipairs(_allElements) do
			if entry.label:find(query, 1, true) and entry.frame and entry.frame.Parent then
				order = order + 1 ; count = count + 1
				-- Save original parent & order so we can restore later
				table.insert(_movedEntries, {
					frame      = entry.frame,
					origParent = entry.frame.Parent,
					origOrder  = entry.frame.LayoutOrder,
				})
				entry.frame.LayoutOrder = order
				entry.frame.Parent      = searchPage
			end
		end

		noResultLbl.Visible     = count == 0
		noResultLbl.LayoutOrder = order + 1
	end

	searchBox:GetPropertyChangedSignal("Text"):Connect(function() doSearch(searchBox.Text) end)

	local function animUL(ul, instant)
		if not ul then return end
		ul.Size = UDim2.new(0,0,0,2) ul.Visible = true
		if instant then ul.Size = UDim2.new(1,-8,0,2)
		else Tw(ul, {Size=UDim2.new(1,-8,0,2)}, 0.22) end
	end

	local function selectTab(tab, instant)
		if not tab then return end
		for _, t in ipairs(tabs) do
			if t ~= tab then
				if t.page then t.page.Visible = false end
				if t.ul   then t.ul.Visible   = false end
				Tw(t.btn, {BackgroundTransparency=1}, 0.12)
				Tw(t.ico, {ImageColor3=T.tabIdle},    0.12)
				Tw(t.lbl, {TextColor3=T.tabIdle},     0.12)
			end
		end
		if not searchActive then
			if tab.page then tab.page.Visible = true end
		end
		activeTab = tab
		Tw(tab.btn, {BackgroundColor3=T.tabBgAct, BackgroundTransparency=0}, 0.13)
		Tw(tab.ico, {ImageColor3=T.white},  0.13)
		Tw(tab.lbl, {TextColor3=T.tabAct}, 0.13)
		animUL(tab.ul, instant)
		cfg.activeTab = tab.name ; saveCfg(cpath, cfg)
	end

	local function setSide(expanded)
		sideExpanded = expanded
		local sw = expanded and SIDE_W or SIDE_MINI
		curSW = sw
		Tw(sidebar,  {Size=UDim2.new(0,sw,1,-TITLE_H)}, 0.22)
		Tw(vdiv,     {Position=UDim2.new(0,sw,0,TITLE_H)}, 0.22)
		Tw(pageArea, {Size=UDim2.new(1,-(sw+1),1,-TITLE_H), Position=UDim2.new(0,sw+1,0,TITLE_H)}, 0.22)
		local hide = expanded and 0 or 1
		for _, l in ipairs(secLabels) do Tw(l, {TextTransparency=hide}, 0.15) end
		for _, t in ipairs(tabs) do
			Tw(t.lbl, {TextTransparency=hide}, 0.15)
			if t.tip then t.tip.Visible = false end
			if t.ico then
				t.ico.Position = expanded and UDim2.new(0,6,0.5,-7) or UDim2.new(0.5,-7,0.5,-7)
			end
		end
		Tw(avName, {TextTransparency=hide}, 0.15)
		Tw(avTag,  {TextTransparency=hide}, 0.15)
		if avImg then
			avImg.Position = expanded and UDim2.new(0,6,0.5,-10) or UDim2.new(0.5,-10,0.5,-10)
		end
		if sideLogoImg then
			Tw(sideLogoImg, {
				Size     = expanded and UDim2.new(0,72,0,72) or UDim2.new(0,22,0,22),
				Position = expanded and UDim2.new(0.5,-36,0.5,-36) or UDim2.new(0.5,-11,0.5,-11),
			}, 0.2)
		end
		colIco.Image    = expanded and icon("chevron-left") or icon("chevron-right")
		colIco.Position = expanded and UDim2.new(1,-15,0.5,-6) or UDim2.new(0.5,-6,0.5,-6)
		colLbl.Text = expanded and "Collapse" or "Expand"
		Tw(colLbl, {TextTransparency=hide}, 0.15)
		cfg.sideExpanded = expanded ; saveCfg(cpath, cfg)
	end

	if cfg.sideExpanded == false then setSide(false) end

	colBtn.MouseButton1Click:Connect(function() setSide(not sideExpanded) end)
	colBtn.MouseEnter:Connect(function()
		Tw(colBtn,{BackgroundTransparency=0,BackgroundColor3=T.tabBgHov},0.1)
		Tw(colIco,{ImageColor3=T.white},0.1) Tw(colLbl,{TextColor3=T.white},0.1)
	end)
	colBtn.MouseLeave:Connect(function()
		Tw(colBtn,{BackgroundTransparency=1},0.1)
		Tw(colIco,{ImageColor3=T.dimLight},0.1) Tw(colLbl,{TextColor3=T.dimLight},0.1)
	end)

	titleBar.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			local p = main.AbsolutePosition
			dragOff = Vector2.new(inp.Position.X-p.X, inp.Position.Y-p.Y)
		end
	end)
	titleBar.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
	RS.RenderStepped:Connect(function()
		if not dragging or not main then return end
		local m = UIS:GetMouseLocation()
		main.Position = UDim2.new(
			0, m.X-dragOff.X+main.AbsoluteSize.X*0.5,
			0, m.Y-dragOff.Y+main.AbsoluteSize.Y*0.5
		)
	end)

	UIS.InputBegan:Connect(function(inp, _)
		if inp.KeyCode == Enum.KeyCode.RightAlt then
			minimized = not minimized
			if main then main.Visible = not minimized end
			cfg.minimized = minimized ; saveCfg(cpath, cfg)
		end
	end)

	local function makeSideLabel(labelText)
		sideOrder = sideOrder + 1
		N("Frame",{Size=UDim2.new(1,0,0,4),BackgroundTransparency=1,LayoutOrder=sideOrder,ZIndex=5,Parent=sideScroll})
		sideOrder = sideOrder + 1
		local row = N("Frame",{Size=UDim2.new(1,0,0,14),BackgroundTransparency=1,LayoutOrder=sideOrder,ZIndex=5,Parent=sideScroll})
		local lbl = N("TextLabel",{
			Size=UDim2.new(1,-4,1,0), Position=UDim2.new(0,4,0,0),
			BackgroundTransparency=1, Text=string.upper(labelText),
			TextColor3=T.secText, TextSize=8, Font=Enum.Font.GothamBold,
			TextXAlignment=Enum.TextXAlignment.Left, ZIndex=6, Parent=row,
		})
		table.insert(secLabels, lbl)
	end

	local window = {}

	function window:AddTab(opts2)
		opts2 = type(opts2) == "table" and opts2 or {}
		local tabTitle   = opts2.Title   or "Tab"
		local tabIcon    = opts2.Icon    or "circle"
		local tabSection = opts2.Section or nil

		if tabSection then makeSideLabel(tabSection) end
		sideOrder = sideOrder + 1

		local btn = N("TextButton",{
			Size=UDim2.new(1,0,0,26),
			BackgroundColor3=T.tabBgAct, BackgroundTransparency=1,
			BorderSizePixel=0, Text="", AutoButtonColor=false,
			LayoutOrder=sideOrder, ZIndex=6, Parent=sideScroll,
		})
		Corner(btn, 5)
		local ico = Img(icon(tabIcon), btn, 14, UDim2.new(0,5,0.5,-7), T.tabIdle, 7)
		local lbl = N("TextLabel",{
			Size=UDim2.new(1,-26,1,0), Position=UDim2.new(0,24,0,0),
			BackgroundTransparency=1, Text=tabTitle, TextColor3=T.tabIdle,
			TextSize=11, Font=Enum.Font.Gotham,
			TextXAlignment=Enum.TextXAlignment.Left, ZIndex=7, Parent=btn,
		})
		local ul = N("Frame",{
			Size=UDim2.new(0,0,0,2), Position=UDim2.new(0,4,1,-2),
			BackgroundColor3=T.underline, BorderSizePixel=0,
			Visible=false, ZIndex=9, Parent=btn,
		})
		Corner(ul, 2)
		local tip = N("TextLabel",{
			Size=UDim2.new(0,82,0,22), Position=UDim2.new(1,5,0.5,-11),
			BackgroundColor3=Color3.fromRGB(20,20,20),
			TextColor3=T.white, TextSize=10, Font=Enum.Font.Gotham,
			Text=tabTitle, TextXAlignment=Enum.TextXAlignment.Center,
			BackgroundTransparency=0, ZIndex=50, Visible=false, Parent=btn,
		})
		Corner(tip, 5)
		Stroke(tip, T.elBorder, 1, 0)

		local page = N("Frame",{
			Size=UDim2.fromScale(1,1), BackgroundColor3=T.pageBg,
			BorderSizePixel=0, ClipsDescendants=true,
			Visible=false, ZIndex=2, Parent=contentArea,
		})
		local scroll = N("ScrollingFrame",{
			Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
			ScrollBarThickness=3, ScrollBarImageColor3=T.Accent,
			CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
			ZIndex=2, Parent=page,
		})
		N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,5),Parent=scroll})
		N("UIPadding",{
			PaddingTop=UDim.new(0,8), PaddingBottom=UDim.new(0,10),
			PaddingLeft=UDim.new(0,9), PaddingRight=UDim.new(0,9),
			Parent=scroll,
		})

		local tab = {name=tabTitle, btn=btn, ico=ico, lbl=lbl, ul=ul, tip=tip, page=page, scroll=scroll}
		table.insert(tabs, tab)

		btn.MouseEnter:Connect(function()
			if activeTab ~= tab then
				Tw(btn,{BackgroundTransparency=0,BackgroundColor3=T.tabBgHov},0.1)
				Tw(ico,{ImageColor3=T.tabHov},0.1) Tw(lbl,{TextColor3=T.tabHov},0.1)
			end
			if not sideExpanded and tip then tip.Visible = true end
		end)
		btn.MouseLeave:Connect(function()
			if activeTab ~= tab then
				Tw(btn,{BackgroundTransparency=1},0.1)
				Tw(ico,{ImageColor3=T.tabIdle},0.1) Tw(lbl,{TextColor3=T.tabIdle},0.1)
			end
			if tip then tip.Visible = false end
		end)
		btn.MouseButton1Click:Connect(function()
			if searchActive then searchBox.Text="" doSearch("") end
			selectTab(tab)
		end)

		if #tabs == 1 then selectTab(tab, true) end
		if cfg.activeTab == tabTitle then selectTab(tab, true) end

		local tabObj = MkSecObj(scroll, cfg, cpath)
		function tabObj:AddSection(sectionName)
			sectionName = type(sectionName)=="string" and sectionName or "Section"
			MkSection(scroll, sectionName)
			return MkSecObj(scroll, cfg, cpath)
		end
		return tabObj
	end

	function window:Destroy()
		pcall(function() gui:Destroy() end)
	end

	return window
end

return lib
