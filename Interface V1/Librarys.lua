local UIS     = game:GetService("UserInputService")
local TS      = game:GetService("TweenService")
local RS      = game:GetService("RunService")
local Players = game:GetService("Players")
local HTTP    = game:GetService("HttpService")
local lp      = Players.LocalPlayer

do
	local mobile = UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled
	if mobile then
		pcall(function() lp:Kick("[EcoHub] Unsupported device.") end)
		return
	end
end

local function cleanOld(p)
	if not p then return end
	for _, v in ipairs(p:GetChildren()) do
		if type(v.Name) == "string" and v.Name:sub(1,7) == "ecohub_" then
			pcall(function() v:Destroy() end)
		end
	end
end
pcall(function() cleanOld(game:GetService("CoreGui")) end)
pcall(function() if gethui then cleanOld(gethui()) end end)

local _iconsOk, _iconsData = pcall(function()
	return loadstring(game:HttpGet(
		"https://raw.githubusercontent.com/EcohubPassouAqui/v2/refs/heads/main/icons"
	))()
end)
local _reg = (_iconsOk and type(_iconsData) == "table" and _iconsData.assets) or {}
local function icon(name)
	return _reg["lucide-" .. tostring(name)] or "rbxassetid://0"
end

local _gameName = tostring(game.Name):gsub("[^%w%s%-_]",""):gsub("%s+","_"):sub(1,40)
if _gameName == "" then _gameName = "unknown" end

local function _cfgPath(winTitle)
	local wn = tostring(winTitle):gsub("[^%w%s%-_]",""):gsub("%s+","_"):sub(1,28)
	if wn == "" then wn = "window" end
	return "ecohub/" .. _gameName .. "/" .. wn .. "_config.json"
end

local function _mkFolders(path)
	pcall(function()
		local parts = string.split(path, "/")
		local b = ""
		for i = 1, #parts - 1 do
			b = (i == 1) and parts[i] or (b .. "/" .. parts[i])
			if not isfolder(b) then makefolder(b) end
		end
	end)
end

local function readCfg(path)
	local ok, d = pcall(function()
		_mkFolders(path)
		return isfile(path) and HTTP:JSONDecode(readfile(path)) or {}
	end)
	return (ok and type(d) == "table") and d or {}
end

local function saveCfg(path, d)
	pcall(function() _mkFolders(path) writefile(path, HTTP:JSONEncode(d)) end)
end

local LOGO_ID   = "rbxassetid://134382458890933"
local NOISE_ID  = "rbxassetid://9968344919"
local SHADOW_ID = "rbxassetid://5554236805"

local PANEL_W   = 550
local PANEL_H   = 350
local TITLE_H   = 38
local SIDE_FULL = 170
local SIDE_MINI = 44
local LOGO_H    = 88
local EL_H      = 38

local T = {
	Accent        = Color3.fromRGB(72, 138, 182),
	AccentDark    = Color3.fromRGB(40,  90, 130),
	AccentHov     = Color3.fromRGB(100, 165, 212),
	AcrylicBorder = Color3.fromRGB(55,  55,  55),
	TitleBarLine  = Color3.fromRGB(42,  42,  42),
	bg            = Color3.fromRGB(14,  14,  14),
	surface       = Color3.fromRGB(18,  18,  18),
	sidebar       = Color3.fromRGB(16,  16,  16),
	divider       = Color3.fromRGB(34,  34,  34),
	white         = Color3.fromRGB(218, 218, 218),
	dim           = Color3.fromRGB(70,  70,  70),
	dimLight      = Color3.fromRGB(110, 110, 110),
	tabIdle       = Color3.fromRGB(90,  90,  90),
	tabHov        = Color3.fromRGB(148, 148, 148),
	tabAct        = Color3.fromRGB(210, 210, 210),
	tabBgHov      = Color3.fromRGB(26,  26,  26),
	tabBgAct      = Color3.fromRGB(30,  30,  30),
	searchBg      = Color3.fromRGB(20,  20,  20),
	avatarBg      = Color3.fromRGB(22,  22,  22),
	underline     = Color3.fromRGB(72, 138, 182),
	secText       = Color3.fromRGB(55,  55,  55),
	elBg          = Color3.fromRGB(20,  20,  20),
	elBgHov       = Color3.fromRGB(28,  28,  28),
	elBorder      = Color3.fromRGB(46,  46,  46),
	floatBg       = Color3.fromRGB(18,  18,  18),
	inputBg       = Color3.fromRGB(14,  14,  14),
	pageBg        = Color3.fromRGB(14,  14,  14),
	togOff        = Color3.fromRGB(34,  34,  34),
	sliderRail    = Color3.fromRGB(26,  26,  26),
}

local function N(cls, props)
	local ok, o = pcall(Instance.new, cls)
	if not ok then return nil end
	for k, v in pairs(props) do
		if k ~= "Parent" then pcall(function() o[k] = v end) end
	end
	if props.Parent then pcall(function() o.Parent = props.Parent end) end
	return o
end

local function Tw(obj, goal, t, sty, dir)
	if not obj then return end
	pcall(function()
		TS:Create(obj,
			TweenInfo.new(t or 0.18, sty or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
			goal):Play()
	end)
end

local function Img(id, par, sz, pos, col, zi)
	return N("ImageLabel", {
		Size = UDim2.new(0,sz,0,sz), Position = pos,
		BackgroundTransparency = 1,
		Image = id, ImageColor3 = col or T.dim,
		ZIndex = zi or 5, Parent = par,
	})
end

local function Noise(par, alpha, zi)
	N("ImageLabel", {
		Size = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		Image = NOISE_ID,
		ImageTransparency = alpha or 0.94,
		ScaleType  = Enum.ScaleType.Tile,
		TileSize   = UDim2.new(0,64,0,64),
		ZIndex = zi or 99,
		Parent = par,
	})
end

local function Corner(par, r)
	N("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = par })
end

local function Stroke(par, col, thick, trans)
	N("UIStroke", {
		Color        = col   or T.elBorder,
		Thickness    = thick or 1,
		Transparency = trans or 0,
		Parent = par,
	})
end

local function Grad(par, c0, c1, rot)
	N("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, c0),
			ColorSequenceKeypoint.new(1, c1),
		}),
		Rotation = rot or 90,
		Parent = par,
	})
end

local _floats = {}
local _elo    = 0
local function NextOrder() _elo += 1 return _elo end

local function CloseAllFloats(except)
	for i = #_floats, 1, -1 do
		if _floats[i] ~= except then
			pcall(_floats[i])
			table.remove(_floats, i)
		end
	end
end

local function FloatPanel(guiRoot, w, h)
	local p = N("Frame", {
		Size = UDim2.new(0,w,0,h),
		BackgroundColor3 = T.floatBg,
		BorderSizePixel  = 0,
		ClipsDescendants = false,
		ZIndex = 200, Visible = false,
		Parent = guiRoot or game:GetService("CoreGui"),
	})
	Corner(p, 8)
	Stroke(p, T.elBorder, 1, 0.1)
	Grad(p, Color3.fromRGB(28,28,28), Color3.fromRGB(14,14,14), 90)
	Noise(p, 0.91, 201)
	N("ImageLabel", {
		Size  = UDim2.fromScale(1,1) + UDim2.fromOffset(40,40),
		Position = UDim2.fromOffset(-20,-20),
		BackgroundTransparency = 1,
		Image = SHADOW_ID,
		ScaleType   = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(23,23,277,277),
		ImageColor3 = Color3.fromRGB(0,0,0),
		ImageTransparency = 0.18,
		ZIndex = 199, Parent = p,
	})
	return p
end

local function AnchorFloat(panel, trigger)
	pcall(function()
		local vp = workspace.CurrentCamera.ViewportSize
		local ap = trigger.AbsolutePosition
		local as = trigger.AbsoluteSize
		local ps = panel.AbsoluteSize
		local x  = math.clamp(ap.X, 4, vp.X - ps.X - 4)
		local y  = ap.Y + as.Y + 6
		if y + ps.Y > vp.Y - 6 then y = ap.Y - ps.Y - 6 end
		panel.Position = UDim2.fromOffset(x, y)
	end)
end

local function ElBase(par, h)
	local f = N("Frame", {
		Size = UDim2.new(1,0,0,h or EL_H),
		BackgroundColor3 = T.elBg,
		BorderSizePixel  = 0,
		ClipsDescendants = false,
		LayoutOrder      = NextOrder(),
		ZIndex = 3,
		Parent = par,
	})
	Corner(f, 7)
	Stroke(f, T.elBorder, 1, 0.3)
	Grad(f, Color3.fromRGB(30,30,30), Color3.fromRGB(18,18,18), 90)
	Noise(f, 0.95, 4)
	return f
end

local function ElLabel(par, text, xOff, yOff, sz, col, zi)
	return N("TextLabel", {
		Size = UDim2.new(1,-((xOff or 12)+6), 0, (sz or 12)+4),
		Position   = UDim2.new(0, xOff or 12, 0, yOff or 0),
		AnchorPoint = yOff and Vector2.new(0,0) or Vector2.new(0,0.5),
		BackgroundTransparency = 1,
		Text = text, TextColor3 = col or T.white,
		TextSize = sz or 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate   = Enum.TextTruncate.AtEnd,
		ZIndex = zi or 4, Parent = par,
	})
end

local function HoverEl(btn, frame)
	if not btn or not frame then return end
	btn.MouseEnter:Connect(function() Tw(frame,{BackgroundColor3=T.elBgHov},0.1) end)
	btn.MouseLeave:Connect(function() Tw(frame,{BackgroundColor3=T.elBg  },0.1) end)
end

local function MkSection(par, text)
	_elo += 1
	local wrap = N("Frame", {
		Size = UDim2.new(1,0,0,22),
		BackgroundTransparency = 1,
		LayoutOrder = _elo, ZIndex = 2, Parent = par,
	})
	local line = N("Frame", {
		Size = UDim2.new(1,-12,0,1),
		Position = UDim2.new(0,6,1,-1),
		BackgroundColor3 = T.divider,
		BorderSizePixel  = 0, ZIndex = 2, Parent = wrap,
	})
	N("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0,   Color3.fromRGB(14,14,14)),
			ColorSequenceKeypoint.new(0.12, Color3.fromRGB(44,44,44)),
			ColorSequenceKeypoint.new(0.88, Color3.fromRGB(44,44,44)),
			ColorSequenceKeypoint.new(1,   Color3.fromRGB(14,14,14)),
		}), Parent = line,
	})
	N("TextLabel", {
		Size = UDim2.new(1,-10,1,0),
		Position = UDim2.new(0,6,0,0),
		BackgroundTransparency = 1,
		Text = string.upper(text),
		TextColor3 = T.secText,
		TextSize = 9, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 3, Parent = wrap,
	})
end

local function MkToggle(par, text, default, cb, cfg, cfgPath, saveId)
	local state = default == true
	if saveId and cfg and cfg[saveId] ~= nil then
		state = cfg[saveId] == true
	end

	local f = ElBase(par, EL_H)
	ElLabel(f, text, 12, nil, 11, T.white, 4)

	local TW2, TH2 = 36, 20
	local track = N("Frame", {
		Size = UDim2.new(0,TW2,0,TH2),
		Position = UDim2.new(1,-(TW2+10),0.5,-TH2/2),
		BackgroundColor3 = state and T.Accent or T.togOff,
		BorderSizePixel  = 0, ZIndex = 5, Parent = f,
	})
	Corner(track, TH2)
	local tGrad = N("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, state and T.AccentHov or Color3.fromRGB(50,50,50)),
			ColorSequenceKeypoint.new(1, state and T.AccentDark or Color3.fromRGB(24,24,24)),
		}), Rotation = 90, Parent = track,
	})
	local tStr = N("UIStroke", {
		Color = state and T.Accent or Color3.fromRGB(54,54,54),
		Thickness = 1, Transparency = 0.3, Parent = track,
	})
	local KSZ = 14
	local knob = N("Frame", {
		Size = UDim2.new(0,KSZ,0,KSZ),
		Position = state and UDim2.new(1,-(KSZ+3),0.5,-KSZ/2) or UDim2.new(0,3,0.5,-KSZ/2),
		BackgroundColor3 = T.white,
		BorderSizePixel  = 0, ZIndex = 6, Parent = track,
	})
	Corner(knob, KSZ)
	Grad(knob, Color3.fromRGB(255,255,255), Color3.fromRGB(185,185,185), 90)

	local function refresh(s)
		Tw(track,{BackgroundColor3 = s and T.Accent or T.togOff},0.16)
		Tw(knob, {Position = s and UDim2.new(1,-(KSZ+3),0.5,-KSZ/2) or UDim2.new(0,3,0.5,-KSZ/2)}, 0.16, Enum.EasingStyle.Back)
		Tw(tStr, {Color = s and T.Accent or Color3.fromRGB(54,54,54)},0.14)
		if tGrad then
			tGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, s and T.AccentHov or Color3.fromRGB(50,50,50)),
				ColorSequenceKeypoint.new(1, s and T.AccentDark or Color3.fromRGB(24,24,24)),
			})
		end
	end

	local btn = N("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=7,Parent=f})
	btn.MouseButton1Click:Connect(function()
		state = not state
		refresh(state)
		if saveId and cfg and cfgPath then
			cfg[saveId] = state
			saveCfg(cfgPath, cfg)
		end
		pcall(function() if cb then cb(state) end end)
	end)
	HoverEl(btn, f)
	return {
		Set = function(v) state = v==true refresh(state) end,
		Get = function() return state end,
	}
end

local function MkCheckbox(par, text, default, cb, cfg, cfgPath, saveId)
	local state = default == true
	if saveId and cfg and cfg[saveId] ~= nil then
		state = cfg[saveId] == true
	end

	local f = ElBase(par, EL_H)
	ElLabel(f, text, 40, nil, 11, T.white, 4)

	local BSZ = 16
	local box = N("Frame", {
		Size = UDim2.new(0,BSZ,0,BSZ),
		Position = UDim2.new(0,11,0.5,-BSZ/2),
		BackgroundColor3 = state and T.Accent or Color3.fromRGB(24,24,24),
		BorderSizePixel = 0, ZIndex = 5, Parent = f,
	})
	Corner(box, 5)
	local bGrad = N("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, state and T.AccentHov or Color3.fromRGB(38,38,38)),
			ColorSequenceKeypoint.new(1, state and T.AccentDark or Color3.fromRGB(16,16,16)),
		}), Rotation = 135, Parent = box,
	})
	local bStr = N("UIStroke", {
		Color = state and T.Accent or Color3.fromRGB(56,56,56),
		Thickness = 1.5, Parent = box,
	})
	local chkIco = N("ImageLabel", {
		Size = UDim2.new(0,10,0,10),
		Position = UDim2.new(0.5,-5,0.5,-5),
		BackgroundTransparency = 1,
		Image = icon("check"),
		ImageColor3 = T.white,
		ImageTransparency = state and 0 or 1,
		ZIndex = 6, Parent = box,
	})

	local function refresh(s)
		Tw(box,   {BackgroundColor3 = s and T.Accent or Color3.fromRGB(24,24,24)},0.15)
		Tw(bStr,  {Color = s and T.Accent or Color3.fromRGB(56,56,56)},0.14)
		Tw(chkIco,{ImageTransparency = s and 0 or 1},0.12)
		if bGrad then
			bGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, s and T.AccentHov or Color3.fromRGB(38,38,38)),
				ColorSequenceKeypoint.new(1, s and T.AccentDark or Color3.fromRGB(16,16,16)),
			})
		end
	end

	local btn = N("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=7,Parent=f})
	btn.MouseButton1Click:Connect(function()
		state = not state
		refresh(state)
		if saveId and cfg and cfgPath then
			cfg[saveId] = state
			saveCfg(cfgPath, cfg)
		end
		pcall(function() if cb then cb(state) end end)
	end)
	HoverEl(btn, f)
	return {
		Set = function(v) state = v==true refresh(state) end,
		Get = function() return state end,
	}
end

local function MkButton(par, text, cb)
	local f = ElBase(par, 36)

	N("TextLabel", {
		Size = UDim2.new(1,-36,1,0),
		Position = UDim2.new(0,12,0,0),
		BackgroundTransparency = 1,
		Text = text, TextColor3 = T.white,
		TextSize = 11, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 5, Parent = f,
	})

	local arrow = Img(icon("chevron-right"), f, 13, UDim2.new(1,-20,0.5,-6.5), T.dim, 5)

	local btn = N("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=7,Parent=f})
	btn.MouseEnter:Connect(function()
		Tw(f,    {BackgroundColor3 = T.elBgHov},0.1)
		Tw(arrow,{ImageColor3 = T.Accent},0.1)
	end)
	btn.MouseLeave:Connect(function()
		Tw(f,    {BackgroundColor3 = T.elBg},0.1)
		Tw(arrow,{ImageColor3 = T.dim},0.1)
	end)
	btn.MouseButton1Down:Connect(function()
		Tw(f, {BackgroundColor3 = Color3.fromRGB(10,10,10)},0.07)
	end)
	btn.MouseButton1Up:Connect(function()
		Tw(f, {BackgroundColor3 = T.elBgHov},0.07)
	end)
	btn.MouseButton1Click:Connect(function()
		pcall(function() if cb then cb() end end)
	end)
	return {Frame = f}
end

local function MkSlider(par, text, minV, maxV, defV, cb, cfg, cfgPath, saveId)
	minV = minV or 0
	maxV = maxV or 100
	local val  = math.clamp(defV or minV, minV, maxV)
	if saveId and cfg and cfg[saveId] ~= nil then
		val = math.clamp(tonumber(cfg[saveId]) or val, minV, maxV)
	end
	local pct  = (val - minV) / math.max(maxV - minV, 0.001)
	local drag = false

	local f = ElBase(par, 50)

	N("TextLabel", {
		Size = UDim2.new(1,-70,0,14),
		Position = UDim2.new(0,11,0,8),
		BackgroundTransparency = 1,
		Text = text, TextColor3 = T.white,
		TextSize = 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 4, Parent = f,
	})

	local badge = N("Frame", {
		Size = UDim2.new(0,46,0,18),
		Position = UDim2.new(1,-56,0,7),
		BackgroundColor3 = Color3.fromRGB(10,10,10),
		BorderSizePixel = 0, ZIndex = 4, Parent = f,
	})
	Corner(badge, 5)
	Stroke(badge, T.elBorder, 1, 0.15)
	local valLbl = N("TextLabel", {
		Size = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		Text = tostring(math.round(val)),
		TextColor3 = T.Accent, TextSize = 10, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 5, Parent = badge,
	})

	local RAIL_H = 3
	local rail = N("Frame", {
		Size = UDim2.new(1,-22,0,RAIL_H),
		Position = UDim2.new(0,11,0,35),
		BackgroundColor3 = T.sliderRail,
		BorderSizePixel = 0, ZIndex = 4, Parent = f,
	})
	Corner(rail, RAIL_H)
	Stroke(rail, T.elBorder, 1, 0.3)

	local fill = N("Frame", {
		Size = UDim2.new(pct,0,1,0),
		BackgroundColor3 = T.Accent,
		BorderSizePixel = 0, ZIndex = 5, Parent = rail,
	})
	Corner(fill, RAIL_H)
	Grad(fill, T.AccentHov, T.Accent, 0)

	local innerRail = N("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0,6,0,0),
		Size     = UDim2.new(1,-12,1,0),
		ZIndex = 5, Parent = rail,
	})

	local KSZ = 12
	local knob = N("Frame", {
		Size        = UDim2.new(0,KSZ,0,KSZ),
		AnchorPoint = Vector2.new(0.5,0.5),
		Position    = UDim2.new(pct,0,0.5,0),
		BackgroundColor3 = T.white,
		BorderSizePixel  = 0, ZIndex = 6, Parent = innerRail,
	})
	Corner(knob, KSZ)
	Grad(knob, Color3.fromRGB(255,255,255), Color3.fromRGB(185,185,185), 90)
	N("UIStroke",{Color=T.Accent,Thickness=1.5,Parent=knob})

	local function setVal(v)
		val = math.clamp(math.round(v), minV, maxV)
		local p = (val - minV) / math.max(maxV - minV, 0.001)
		if fill      then fill.Size      = UDim2.new(p,0,1,0)    end
		if knob      then knob.Position  = UDim2.new(p,0,0.5,0)  end
		if valLbl    then valLbl.Text    = tostring(val)          end
		if saveId and cfg and cfgPath then
			cfg[saveId] = val
			saveCfg(cfgPath, cfg)
		end
		pcall(function() if cb then cb(val) end end)
	end

	local hitbox = N("TextButton", {
		Size = UDim2.new(1,0,0,24),
		Position = UDim2.new(0,0,0,-10),
		BackgroundTransparency = 1, Text = "", ZIndex = 8, Parent = rail,
	})
	hitbox.MouseButton1Down:Connect(function()
		drag = true
		local mp = UIS:GetMouseLocation()
		local ab = innerRail.AbsolutePosition
		local sz = innerRail.AbsoluteSize
		setVal(minV + (maxV-minV) * math.clamp((mp.X-ab.X)/sz.X,0,1))
	end)
	hitbox.MouseEnter:Connect(function()
		Tw(f,   {BackgroundColor3=T.elBgHov},0.1)
		Tw(knob,{Size=UDim2.new(0,KSZ+2,0,KSZ+2)},0.1,Enum.EasingStyle.Back)
	end)
	hitbox.MouseLeave:Connect(function()
		Tw(f,{BackgroundColor3=T.elBg},0.1)
		if not drag then Tw(knob,{Size=UDim2.new(0,KSZ,0,KSZ)},0.1,Enum.EasingStyle.Back) end
	end)
	UIS.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			if drag then Tw(knob,{Size=UDim2.new(0,KSZ,0,KSZ)},0.1,Enum.EasingStyle.Back) end
			drag = false
		end
	end)
	RS.RenderStepped:Connect(function()
		if not drag or not innerRail then return end
		local mp = UIS:GetMouseLocation()
		local ab = innerRail.AbsolutePosition
		local sz = innerRail.AbsoluteSize
		setVal(minV + (maxV-minV) * math.clamp((mp.X-ab.X)/sz.X,0,1))
	end)

	return {
		Set = function(v) setVal(v) end,
		Get = function() return val end,
	}
end

local function MkDropdown(guiRoot, par, text, options, defV, cb, cfg, cfgPath, saveId)
	local selected = defV or (options and options[1]) or ""
	if saveId and cfg and cfg[saveId] ~= nil then
		selected = tostring(cfg[saveId])
	end
	local open = false
	options    = options or {}

	local ITEM_H  = 28
	local MAX_VIS = 8
	local PAD     = 6
	local panelH  = math.min(#options, MAX_VIS) * ITEM_H + PAD * 2

	local f = ElBase(par, EL_H)
	ElLabel(f, text, 12, nil, 11, T.white, 4)

	local selLbl = N("TextLabel", {
		Size = UDim2.new(0,100,0,22),
		Position = UDim2.new(1,-132,0.5,-11),
		BackgroundTransparency = 1,
		Text = selected, TextColor3 = T.Accent,
		TextSize = 10, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextTruncate   = Enum.TextTruncate.AtEnd,
		ZIndex = 4, Parent = f,
	})

	local arrowBox = N("Frame", {
		Size = UDim2.new(0,24,0,24),
		Position = UDim2.new(1,-32,0.5,-12),
		BackgroundColor3 = Color3.fromRGB(24,24,24),
		BorderSizePixel = 0, ZIndex = 4, Parent = f,
	})
	Corner(arrowBox, 5)
	Stroke(arrowBox, T.elBorder, 1, 0.2)
	local arrow = Img(icon("chevron-down"), arrowBox, 12, UDim2.new(0.5,-6,0.5,-6), T.dimLight, 5)

	local panel = FloatPanel(guiRoot, 200, panelH)
	local pScroll = N("ScrollingFrame", {
		Size = UDim2.new(1,-8,1,-8),
		Position = UDim2.fromOffset(4,4),
		BackgroundTransparency = 1,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = T.Accent,
		CanvasSize = UDim2.new(0,0,0,0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ZIndex = 202, Parent = panel,
	})
	N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=pScroll})

	local function closePanel()
		open = false
		local pw = panel and panel.AbsoluteSize.X or 200
		Tw(panel,{Size=UDim2.new(0,pw,0,0)},0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.In)
		Tw(arrow,{Rotation=0, ImageColor3=T.dimLight},0.14)
		task.delay(0.17,function()
			if panel then
				panel.Visible = false
				panel.Size    = UDim2.new(0,pw,0,panelH)
			end
		end)
		for i,fn in ipairs(_floats) do
			if fn == closePanel then table.remove(_floats,i) break end
		end
	end

	local function buildList()
		if not pScroll then return end
		for _, c in ipairs(pScroll:GetChildren()) do
			if not c:IsA("UIListLayout") then pcall(function() c:Destroy() end) end
		end
		for i, opt in ipairs(options) do
			local isSel = opt == selected
			local row = N("Frame", {
				Size = UDim2.new(1,0,0,ITEM_H),
				BackgroundColor3 = isSel and Color3.fromRGB(26,26,26) or T.floatBg,
				BackgroundTransparency = isSel and 0 or 1,
				BorderSizePixel = 0, LayoutOrder = i, ZIndex = 203, Parent = pScroll,
			})
			Corner(row, 5)
			if isSel then Stroke(row, T.Accent, 1, 0.55) end
			N("TextLabel", {
				Size = UDim2.new(1,-16,1,0),
				Position = UDim2.fromOffset(10,0),
				BackgroundTransparency = 1,
				Text = opt,
				TextColor3 = isSel and T.white or T.dimLight,
				TextSize = 10,
				Font = isSel and Enum.Font.GothamSemibold or Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate   = Enum.TextTruncate.AtEnd,
				ZIndex = 204, Parent = row,
			})
			local ob = N("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=205,Parent=row})
			ob.MouseEnter:Connect(function()
				if opt ~= selected then Tw(row,{BackgroundTransparency=0,BackgroundColor3=Color3.fromRGB(22,22,22)},0.08) end
			end)
			ob.MouseLeave:Connect(function()
				if opt ~= selected then Tw(row,{BackgroundTransparency=1},0.08) end
			end)
			ob.MouseButton1Click:Connect(function()
				selected = opt
				if selLbl then selLbl.Text = selected end
				buildList()
				closePanel()
				if saveId and cfg and cfgPath then
					cfg[saveId] = selected
					saveCfg(cfgPath, cfg)
				end
				pcall(function() if cb then cb(selected) end end)
			end)
		end
		panelH = math.max(math.min(#options,MAX_VIS)*ITEM_H + PAD*2, 36)
	end
	buildList()

	UIS.InputBegan:Connect(function(inp)
		if inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
		if not open or not panel then return end
		local mp = UIS:GetMouseLocation()
		local ap = panel.AbsolutePosition
		local as = panel.AbsoluteSize
		if mp.X<ap.X or mp.X>ap.X+as.X or mp.Y<ap.Y or mp.Y>ap.Y+as.Y then
			closePanel()
		end
	end)

	local togBtn = N("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=6,Parent=f})
	togBtn.MouseButton1Click:Connect(function()
		if open then closePanel() return end
		CloseAllFloats(closePanel)
		open = true
		buildList()
		local fw = f.AbsoluteSize.X
		if panel then
			panel.Size    = UDim2.new(0,fw,0,0)
			panel.Visible = true
			AnchorFloat(panel, f)
			Tw(panel,{Size=UDim2.new(0,fw,0,panelH)},0.2)
		end
		Tw(arrow,{Rotation=180,ImageColor3=T.Accent},0.16)
		table.insert(_floats, closePanel)
		pcall(function()
			f:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
				if open then AnchorFloat(panel,f) end
			end)
		end)
	end)
	HoverEl(togBtn, f)

	return {
		Set        = function(v) selected=v if selLbl then selLbl.Text=v end buildList() end,
		Get        = function() return selected end,
		SetOptions = function(o) options=o buildList() end,
	}
end

local function MkKeybind(par, text, defKey, cb, cfg, cfgPath, saveId)
	local key       = defKey or Enum.KeyCode.Unknown
	if saveId and cfg and cfg[saveId] then
		pcall(function() key = Enum.KeyCode[cfg[saveId]] or key end)
	end
	local listening = false

	local f = ElBase(par, EL_H)
	ElLabel(f, text, 12, nil, 11, T.white, 4)

	local kBox = N("Frame", {
		Size = UDim2.new(0,82,0,24),
		Position = UDim2.new(1,-92,0.5,-12),
		BackgroundColor3 = Color3.fromRGB(18,18,18),
		BorderSizePixel = 0, ZIndex = 5, Parent = f,
	})
	Corner(kBox, 5)
	Grad(kBox, Color3.fromRGB(28,28,28), Color3.fromRGB(14,14,14), 90)
	Noise(kBox, 0.88, 6)
	local kStr = N("UIStroke",{Color=T.Accent,Thickness=1,Transparency=0.6,Parent=kBox})

	local kname = key == Enum.KeyCode.Unknown and "None" or key.Name
	local kLbl = N("TextLabel", {
		Size = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		Text = "[ "..kname.." ]",
		TextColor3 = T.Accent, TextSize = 9, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextTruncate   = Enum.TextTruncate.AtEnd,
		ZIndex = 7, Parent = kBox,
	})

	local btn = N("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=8,Parent=f})
	btn.MouseButton1Click:Connect(function()
		CloseAllFloats()
		listening = true
		if kLbl then kLbl.Text = "[ ... ]" kLbl.TextColor3 = T.dimLight end
		Tw(kStr,{Color=T.AccentHov,Transparency=0},0.1)
		Tw(kBox, {BackgroundColor3=Color3.fromRGB(26,26,26)},0.1)
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
				if saveId and cfg and cfgPath then
					cfg[saveId] = key.Name
					saveCfg(cfgPath, cfg)
				end
				pcall(function() if cb then cb(key) end end)
			end
			Tw(kStr,{Color=T.Accent,Transparency=0.6},0.12)
			Tw(kBox, {BackgroundColor3=Color3.fromRGB(18,18,18)},0.1)
		end
	end)
	HoverEl(btn, f)

	return {
		Set = function(k)
			key = k
			local n = k==Enum.KeyCode.Unknown and "None" or k.Name
			if kLbl then kLbl.Text = "[ "..n.." ]" end
		end,
		Get = function() return key end,
	}
end

local function MkColorPicker(guiRoot, par, text, defCol, cb, cfg, cfgPath, saveId)
	local color = defCol or Color3.fromRGB(255,80,80)
	if saveId and cfg and cfg[saveId] then
		pcall(function()
			local hex = cfg[saveId]
			color = Color3.fromHex(hex)
		end)
	end
	local h, s, v = Color3.toHSV(color)
	local open    = false
	local svDrag  = false
	local hueDrag = false

	local SV_W  = 160
	local SV_H  = 130
	local HUE_W = 12
	local GAP   = 8
	local HEX_H = 26
	local PAD   = 8
	local TW2   = SV_W + GAP + HUE_W + PAD*2
	local TH2   = SV_H + GAP + HEX_H + PAD*2

	local f = ElBase(par, EL_H)
	ElLabel(f, text, 12, nil, 11, T.white, 4)

	local swatch = N("Frame", {
		Size = UDim2.new(0,24,0,24),
		Position = UDim2.new(1,-34,0.5,-12),
		BackgroundColor3 = color,
		BorderSizePixel = 0, ZIndex = 5, Parent = f,
	})
	Corner(swatch, 4)
	Stroke(swatch, Color3.fromRGB(75,75,75), 1, 0)

	local panel = FloatPanel(guiRoot, TW2, TH2)

	local svBox = N("Frame", {
		Size = UDim2.fromOffset(SV_W,SV_H),
		Position = UDim2.fromOffset(PAD,PAD),
		BackgroundColor3 = Color3.fromHSV(h,1,1),
		BorderSizePixel = 0, ClipsDescendants = true,
		ZIndex = 202, Parent = panel,
	})
	Corner(svBox, 5)
	Stroke(svBox, T.elBorder, 1, 0.25)
	local svW2 = N("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=203,Parent=svBox})
	N("UIGradient",{Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}),Parent=svW2})
	local svB2 = N("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,ZIndex=204,Parent=svBox})
	N("UIGradient",{Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)}),Rotation=90,Parent=svB2})
	local svKnob = N("Frame",{
		Size=UDim2.fromOffset(10,10),Position=UDim2.new(s,-5,1-v,-5),
		BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=205,Parent=svBox,
	})
	Corner(svKnob,10)
	N("UIStroke",{Color=Color3.new(1,1,1),Thickness=2,Parent=svKnob})

	local hueBar = N("Frame", {
		Size = UDim2.fromOffset(HUE_W,SV_H),
		Position = UDim2.fromOffset(PAD+SV_W+GAP,PAD),
		BackgroundColor3 = Color3.new(1,1,1),
		BorderSizePixel = 0, ZIndex = 202, Parent = panel,
	})
	Corner(hueBar, HUE_W)
	Stroke(hueBar, T.elBorder, 1, 0.25)
	local hKeys = {}
	for i=0,6 do table.insert(hKeys, ColorSequenceKeypoint.new(i/6, Color3.fromHSV(i/6,1,1))) end
	N("UIGradient",{Color=ColorSequence.new(hKeys),Rotation=90,Parent=hueBar})
	local hueKnob = N("Frame",{
		Size=UDim2.fromOffset(18,6),Position=UDim2.new(0.5,-9,h,-3),
		BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=203,Parent=hueBar,
	})
	Corner(hueKnob,3)
	N("UIStroke",{Color=Color3.fromRGB(170,170,170),Thickness=1.5,Parent=hueKnob})

	local hexBox = N("Frame",{
		Size=UDim2.fromOffset(SV_W+GAP+HUE_W,HEX_H),
		Position=UDim2.fromOffset(PAD,PAD+SV_H+GAP),
		BackgroundColor3=T.inputBg,BorderSizePixel=0,ZIndex=202,Parent=panel,
	})
	Corner(hexBox,5)
	Stroke(hexBox,T.elBorder,1,0.2)
	N("TextLabel",{
		Size=UDim2.new(0,18,1,0),Position=UDim2.fromOffset(5,0),
		BackgroundTransparency=1,Text="#",
		TextColor3=T.Accent,TextSize=11,Font=Enum.Font.GothamBold,
		TextXAlignment=Enum.TextXAlignment.Center,ZIndex=203,Parent=hexBox,
	})
	local hexInput = N("TextBox",{
		Size=UDim2.new(1,-48,1,0),Position=UDim2.fromOffset(22,0),
		BackgroundTransparency=1,
		Text=color:ToHex():upper(),
		PlaceholderText="RRGGBB",PlaceholderColor3=T.dim,
		TextColor3=T.white,TextSize=10,Font=Enum.Font.GothamBold,
		TextXAlignment=Enum.TextXAlignment.Left,
		ClearTextOnFocus=false,ZIndex=203,Parent=hexBox,
	})
	local hexSwatch = N("Frame",{
		Size=UDim2.new(0,16,0,16),Position=UDim2.new(1,-20,0.5,-8),
		BackgroundColor3=color,BorderSizePixel=0,ZIndex=203,Parent=hexBox,
	})
	Corner(hexSwatch,3)
	Stroke(hexSwatch,Color3.fromRGB(65,65,65),1,0)

	local function updateAll()
		color = Color3.fromHSV(h,s,v)
		pcall(function()
			swatch.BackgroundColor3    = color
			hexSwatch.BackgroundColor3 = color
			svBox.BackgroundColor3     = Color3.fromHSV(h,1,1)
			svKnob.Position            = UDim2.new(s,-5,1-v,-5)
			hueKnob.Position           = UDim2.new(0.5,-9,h,-3)
			if hexInput then hexInput.Text = color:ToHex():upper() end
		end)
		if saveId and cfg and cfgPath then
			cfg[saveId] = color:ToHex()
			saveCfg(cfgPath, cfg)
		end
		pcall(function() if cb then cb(color) end end)
	end

	if hexInput then
		hexInput.FocusLost:Connect(function(enter)
			if not enter then return end
			local txt = hexInput.Text:gsub("#","")
			local ok2,c2 = pcall(Color3.fromHex,txt)
			if ok2 and typeof(c2)=="Color3" then
				h,s,v = Color3.toHSV(c2) updateAll()
			else
				hexInput.Text = color:ToHex():upper()
			end
		end)
	end

	local svHit = N("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=206,Parent=svBox})
	svHit.MouseButton1Down:Connect(function() svDrag=true end)
	local hueHit = N("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=204,Parent=hueBar})
	hueHit.MouseButton1Down:Connect(function() hueDrag=true end)

	UIS.InputEnded:Connect(function(inp)
		if inp.UserInputType==Enum.UserInputType.MouseButton1 then svDrag=false hueDrag=false end
	end)
	RS.RenderStepped:Connect(function()
		if svDrag and svBox then
			local mp=UIS:GetMouseLocation()
			local ab=svBox.AbsolutePosition local sz=svBox.AbsoluteSize
			s=math.clamp((mp.X-ab.X)/sz.X,0,1)
			v=1-math.clamp((mp.Y-ab.Y)/sz.Y,0,1)
			updateAll()
		end
		if hueDrag and hueBar then
			local mp=UIS:GetMouseLocation()
			local ab=hueBar.AbsolutePosition local sz=hueBar.AbsoluteSize
			h=math.clamp((mp.Y-ab.Y)/sz.Y,0,1)
			updateAll()
		end
	end)

	local function closeCP()
		open = false
		local pw = panel and panel.AbsoluteSize.X or TW2
		Tw(panel,{Size=UDim2.fromOffset(pw,0)},0.16,Enum.EasingStyle.Quint,Enum.EasingDirection.In)
		task.delay(0.17,function()
			if panel then panel.Visible=false panel.Size=UDim2.fromOffset(TW2,TH2) end
		end)
		for i,fn in ipairs(_floats) do if fn==closeCP then table.remove(_floats,i) break end end
	end

	UIS.InputBegan:Connect(function(inp)
		if inp.UserInputType~=Enum.UserInputType.MouseButton1 then return end
		if not open or not panel then return end
		local mp=UIS:GetMouseLocation()
		local ap=panel.AbsolutePosition local as=panel.AbsoluteSize
		if mp.X<ap.X or mp.X>ap.X+as.X or mp.Y<ap.Y or mp.Y>ap.Y+as.Y then closeCP() end
	end)

	local togBtn = N("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=6,Parent=f})
	togBtn.MouseButton1Click:Connect(function()
		if open then closeCP() return end
		CloseAllFloats(closeCP)
		open = true
		if panel then
			panel.Size    = UDim2.fromOffset(TW2,0)
			panel.Visible = true
			AnchorFloat(panel,f)
			Tw(panel,{Size=UDim2.fromOffset(TW2,TH2)},0.2)
		end
		table.insert(_floats, closeCP)
		pcall(function()
			f:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
				if open then AnchorFloat(panel,f) end
			end)
		end)
	end)
	HoverEl(togBtn, f)

	return {
		Set = function(c) color=c h,s,v=Color3.toHSV(c) updateAll() end,
		Get = function() return color end,
	}
end

local function MkSecObj(guiRoot, scroll, cfg, cfgPath)
	local obj = {}

	function obj:AddToggle(text, default, cb, saveId)
		return MkToggle(scroll, text, default, cb, cfg, cfgPath, saveId)
	end
	function obj:AddCheckbox(text, default, cb, saveId)
		return MkCheckbox(scroll, text, default, cb, cfg, cfgPath, saveId)
	end
	function obj:AddButton(text, cb)
		return MkButton(scroll, text, cb)
	end
	function obj:AddSlider(text, minV, maxV, defV, cb, saveId)
		return MkSlider(scroll, text, minV, maxV, defV, cb, cfg, cfgPath, saveId)
	end
	function obj:AddDropdown(text, opts, defV, cb, saveId)
		return MkDropdown(guiRoot, scroll, text, opts, defV, cb, cfg, cfgPath, saveId)
	end
	function obj:AddKeybind(text, defKey, cb, saveId)
		return MkKeybind(scroll, text, defKey, cb, cfg, cfgPath, saveId)
	end
	function obj:AddColorPicker(text, defCol, cb, saveId)
		return MkColorPicker(guiRoot, scroll, text, defCol, cb, cfg, cfgPath, saveId)
	end
	function obj:AddSection(name)
		MkSection(scroll, name or "Section")
		return MkSecObj(guiRoot, scroll, cfg, cfgPath)
	end

	return obj
end

local lib = {}

function lib:CreateWindow(opts)
	opts = type(opts)=="table" and opts or {}

	local title    = opts.Title    or "Eco Hub"
	local subtitle = opts.Subtitle or ""

	local cfgPath      = _cfgPath(title)
	local cfg          = readCfg(cfgPath)
	local sideExpanded = true
	local minimized    = false
	local dragging     = false
	local dragOff      = Vector2.zero
	local tabs         = {}
	local activeTab    = nil
	local secLabels    = {}
	local sideOrder    = 0
	local curSW        = SIDE_FULL

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
		ZIndex = 1, Parent = gui,
	})
	Corner(main, 10)
	Stroke(main, T.AcrylicBorder, 1, 0)

	N("ImageLabel", {
		Size  = UDim2.fromScale(1,1) + UDim2.fromOffset(60,60),
		Position = UDim2.fromOffset(-30,-30),
		BackgroundTransparency = 1,
		Image = SHADOW_ID,
		ScaleType   = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(23,23,277,277),
		ImageColor3 = Color3.fromRGB(0,0,0),
		ImageTransparency = 0.4,
		ZIndex = 0, Parent = main,
	})

	local titleBar = N("Frame", {
		Size = UDim2.new(1,0,0,TITLE_H),
		BackgroundColor3 = T.surface,
		BorderSizePixel = 0, ZIndex = 8, Parent = main,
	})
	Grad(titleBar, Color3.fromRGB(24,24,24), Color3.fromRGB(16,16,16), 90)
	Noise(titleBar, 0.92, 9)

	N("Frame", {
		Size = UDim2.new(1,0,0,1),
		Position = UDim2.new(0,0,1,-1),
		BackgroundColor3 = T.TitleBarLine,
		BorderSizePixel = 0, ZIndex = 9, Parent = titleBar,
	})

	N("TextLabel", {
		Size = UDim2.new(0,200,1,0),
		Position = UDim2.new(0,12,0,0),
		BackgroundTransparency = 1,
		Text = title, TextColor3 = T.white,
		TextSize = 13, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 10, Parent = titleBar,
	})
	if subtitle ~= "" then
		N("TextLabel", {
			Size = UDim2.new(0,70,1,0),
			Position = UDim2.new(1,-78,0,0),
			BackgroundTransparency = 1,
			Text = subtitle, TextColor3 = T.dim,
			TextSize = 10, Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Right,
			ZIndex = 10, Parent = titleBar,
		})
	end

	local sidebar = N("Frame", {
		Size = UDim2.new(0,curSW,1,-TITLE_H),
		Position = UDim2.new(0,0,0,TITLE_H),
		BackgroundColor3 = T.sidebar,
		BorderSizePixel = 0, ClipsDescendants = true,
		ZIndex = 4, Parent = main,
	})
	Grad(sidebar, Color3.fromRGB(20,20,20), Color3.fromRGB(13,13,13), 90)
	Noise(sidebar, 0.93, 5)

	local vdiv = N("Frame", {
		Size = UDim2.new(0,1,1,-TITLE_H),
		Position = UDim2.new(0,curSW,0,TITLE_H),
		BackgroundColor3 = T.divider,
		BorderSizePixel = 0, ZIndex = 5, Parent = main,
	})

	local logoArea = N("Frame", {
		Size = UDim2.new(1,0,0,LOGO_H),
		BackgroundTransparency = 1,
		ZIndex = 5, Parent = sidebar,
	})
	local sideLogoImg = N("ImageLabel", {
		Size = UDim2.new(0,60,0,60),
		Position = UDim2.new(0.5,-30,0.5,-30),
		BackgroundTransparency = 1,
		Image = LOGO_ID, ZIndex = 6, Parent = logoArea,
	})
	N("Frame", {
		Size = UDim2.new(1,-20,0,1),
		Position = UDim2.new(0,10,1,-1),
		BackgroundColor3 = T.divider,
		BorderSizePixel = 0, ZIndex = 5, Parent = logoArea,
	})

	local sideScroll = N("ScrollingFrame", {
		Size = UDim2.new(1,0,1,-(LOGO_H+80)),
		Position = UDim2.new(0,0,0,LOGO_H+2),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(0,0,0,0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ZIndex = 5, Parent = sidebar,
	})
	N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,1),Parent=sideScroll})
	N("UIPadding",{
		PaddingLeft=UDim.new(0,5),PaddingRight=UDim.new(0,5),
		PaddingTop=UDim.new(0,3),Parent=sideScroll,
	})

	N("Frame", {
		Size = UDim2.new(1,-10,0,1),
		Position = UDim2.new(0,5,1,-74),
		BackgroundColor3 = T.divider,
		BorderSizePixel = 0, ZIndex = 5, Parent = sidebar,
	})

	local colBtn = N("TextButton", {
		Size = UDim2.new(1,-10,0,24),
		Position = UDim2.new(0,5,1,-68),
		BackgroundColor3 = T.tabBgHov,
		BackgroundTransparency = 1,
		BorderSizePixel = 0, Text = "",
		AutoButtonColor = false, ZIndex = 5, Parent = sidebar,
	})
	Corner(colBtn, 6)
	local colIco = Img(icon("chevron-left"),colBtn,12,UDim2.new(1,-17,0.5,-6),T.dimLight,6)
	local colLbl = N("TextLabel", {
		Size = UDim2.new(1,-24,1,0),
		Position = UDim2.new(0,7,0,0),
		BackgroundTransparency = 1,
		Text = "Collapse", TextColor3 = T.dimLight,
		TextSize = 10, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 6, Parent = colBtn,
	})

	local avFrame = N("Frame", {
		Size = UDim2.new(1,-10,0,36),
		Position = UDim2.new(0,5,1,-40),
		BackgroundColor3 = T.avatarBg,
		BorderSizePixel = 0, ZIndex = 5, Parent = sidebar,
	})
	Corner(avFrame, 7)
	Stroke(avFrame, T.elBorder, 1, 0.3)
	local avImg = N("ImageLabel", {
		Size = UDim2.new(0,22,0,22),
		Position = UDim2.new(0,6,0.5,-11),
		BackgroundColor3 = T.dim,
		BorderSizePixel = 0, ZIndex = 6, Parent = avFrame,
	})
	Corner(avImg, 11)
	local avName = N("TextLabel", {
		Size = UDim2.new(1,-36,0,13),
		Position = UDim2.new(0,32,0,5),
		BackgroundTransparency = 1,
		Text = lp.DisplayName, TextColor3 = T.white,
		TextSize = 10, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 6, Parent = avFrame,
	})
	local avTag = N("TextLabel", {
		Size = UDim2.new(1,-36,0,10),
		Position = UDim2.new(0,32,0,19),
		BackgroundTransparency = 1,
		Text = "@"..lp.Name, TextColor3 = T.dim,
		TextSize = 9, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 6, Parent = avFrame,
	})
	task.spawn(function()
		local ok,url = pcall(function()
			return Players:GetUserThumbnailAsync(lp.UserId,
				Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
		end)
		if ok and avImg then avImg.Image = url end
	end)

	local pageArea = N("Frame", {
		Size = UDim2.new(1,-(curSW+1),1,-TITLE_H),
		Position = UDim2.new(0,curSW+1,0,TITLE_H),
		BackgroundColor3 = T.pageBg,
		BorderSizePixel = 0, ClipsDescendants = true,
		ZIndex = 2, Parent = main,
	})

	local searchBar = N("Frame", {
		Size = UDim2.new(1,-16,0,26),
		Position = UDim2.new(0,8,0,8),
		BackgroundColor3 = T.searchBg,
		BorderSizePixel = 0, ZIndex = 5, Parent = pageArea,
	})
	Corner(searchBar, 5)
	Stroke(searchBar, T.elBorder, 1, 0.2)
	Noise(searchBar, 0.93, 6)
	Img(icon("search"), searchBar, 11, UDim2.new(0,8,0.5,-5.5), T.dim, 7)
	N("TextBox", {
		Size = UDim2.new(1,-26,1,0),
		Position = UDim2.new(0,22,0,0),
		BackgroundTransparency = 1,
		PlaceholderText = "Search...",
		PlaceholderColor3 = T.dim, Text = "",
		TextColor3 = T.white, TextSize = 10, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false, ZIndex = 7, Parent = searchBar,
	})

	N("Frame", {
		Size = UDim2.new(1,-16,0,1),
		Position = UDim2.new(0,8,0,42),
		BackgroundColor3 = T.divider,
		BorderSizePixel = 0, ZIndex = 4, Parent = pageArea,
	})

	local contentArea = N("Frame", {
		Size = UDim2.new(1,0,1,-46),
		Position = UDim2.new(0,0,0,46),
		BackgroundColor3 = T.pageBg,
		BorderSizePixel = 0, ClipsDescendants = true,
		ZIndex = 2, Parent = pageArea,
	})

	local function animUL(ul, instant)
		if not ul then return end
		ul.Size = UDim2.new(0,0,0,2) ul.Visible = true
		if instant then ul.Size = UDim2.new(1,-10,0,2)
		else Tw(ul,{Size=UDim2.new(1,-10,0,2)},0.22) end
	end

	local function selectTab(tab, instant)
		if not tab then return end
		for _, t in ipairs(tabs) do
			if t ~= tab then
				if t.page then t.page.Visible = false end
				if t.ul   then t.ul.Visible   = false end
				Tw(t.btn,{BackgroundTransparency=1},0.12)
				Tw(t.ico,{ImageColor3=T.tabIdle},0.12)
				Tw(t.lbl,{TextColor3 =T.tabIdle},0.12)
			end
		end
		if tab.page then tab.page.Visible = true end
		activeTab = tab
		Tw(tab.btn,{BackgroundColor3=T.tabBgAct,BackgroundTransparency=0},0.14)
		Tw(tab.ico,{ImageColor3=T.white},0.14)
		Tw(tab.lbl,{TextColor3 =T.tabAct},0.14)
		animUL(tab.ul, instant)
		cfg.activeTab = tab.name
		saveCfg(cfgPath, cfg)
	end

	local function setSide(expanded)
		sideExpanded = expanded
		local sw = expanded and SIDE_FULL or SIDE_MINI
		curSW = sw
		Tw(sidebar, {Size=UDim2.new(0,sw,1,-TITLE_H)},0.22)
		Tw(vdiv,    {Position=UDim2.new(0,sw,0,TITLE_H)},0.22)
		Tw(pageArea,{
			Size     = UDim2.new(1,-(sw+1),1,-TITLE_H),
			Position = UDim2.new(0,sw+1,0,TITLE_H),
		},0.22)
		local hide = expanded and 0 or 1
		for _, l in ipairs(secLabels) do Tw(l,{TextTransparency=hide},0.15) end
		for _, t in ipairs(tabs) do
			Tw(t.lbl,{TextTransparency=hide},0.15)
			if t.tip then t.tip.Visible = false end
			if t.ico then
				t.ico.Position = expanded
					and UDim2.new(0,6,0.5,-6.5)
					or  UDim2.new(0.5,-6.5,0.5,-6.5)
			end
		end
		Tw(avName,{TextTransparency=hide},0.15)
		Tw(avTag, {TextTransparency=hide},0.15)
		if avImg then
			avImg.Position = expanded and UDim2.new(0,6,0.5,-11) or UDim2.new(0.5,-11,0.5,-11)
		end
		if sideLogoImg then
			Tw(sideLogoImg,{
				Size     = expanded and UDim2.new(0,60,0,60) or UDim2.new(0,24,0,24),
				Position = expanded and UDim2.new(0.5,-30,0.5,-30) or UDim2.new(0.5,-12,0.5,-12),
			},0.2)
		end
		if colIco then
			colIco.Image    = expanded and icon("chevron-left") or icon("chevron-right")
			colIco.Position = expanded and UDim2.new(1,-17,0.5,-6) or UDim2.new(0.5,-6,0.5,-6)
		end
		if colLbl then
			colLbl.Text = expanded and "Collapse" or "Expand"
			Tw(colLbl,{TextTransparency=hide},0.15)
		end
		cfg.sideExpanded = expanded
		saveCfg(cfgPath, cfg)
	end

	if cfg.sideExpanded == false then setSide(false) end

	colBtn.MouseButton1Click:Connect(function() setSide(not sideExpanded) end)
	colBtn.MouseEnter:Connect(function()
		Tw(colBtn,{BackgroundTransparency=0,BackgroundColor3=T.tabBgHov},0.1)
		Tw(colIco, {ImageColor3=T.white},0.1)
		Tw(colLbl, {TextColor3 =T.white},0.1)
	end)
	colBtn.MouseLeave:Connect(function()
		Tw(colBtn,{BackgroundTransparency=1},0.1)
		Tw(colIco, {ImageColor3=T.dimLight},0.1)
		Tw(colLbl, {TextColor3 =T.dimLight},0.1)
	end)

	titleBar.InputBegan:Connect(function(inp)
		if inp.UserInputType==Enum.UserInputType.MouseButton1 then
			dragging = true
			local p = main.AbsolutePosition
			dragOff  = Vector2.new(inp.Position.X-p.X, inp.Position.Y-p.Y)
		end
	end)
	titleBar.InputEnded:Connect(function(inp)
		if inp.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
	end)
	RS.RenderStepped:Connect(function()
		if not dragging or not main then return end
		local m = UIS:GetMouseLocation()
		main.Position = UDim2.new(
			0, m.X - dragOff.X + main.AbsoluteSize.X * 0.5,
			0, m.Y - dragOff.Y + main.AbsoluteSize.Y * 0.5
		)
	end)

	UIS.InputBegan:Connect(function(inp,_)
		if inp.KeyCode == Enum.KeyCode.RightAlt then
			minimized = not minimized
			if main then main.Visible = not minimized end
			cfg.minimized = minimized
			saveCfg(cfgPath, cfg)
		end
	end)

	local function makeSideLabel(labelText)
		sideOrder += 1
		N("Frame",{Size=UDim2.new(1,0,0,5),BackgroundTransparency=1,LayoutOrder=sideOrder,ZIndex=5,Parent=sideScroll})
		sideOrder += 1
		local row = N("Frame",{Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,LayoutOrder=sideOrder,ZIndex=5,Parent=sideScroll})
		local lbl = N("TextLabel",{
			Size=UDim2.new(1,-4,1,0),Position=UDim2.new(0,4,0,0),
			BackgroundTransparency=1,
			Text=string.upper(labelText),TextColor3=T.secText,
			TextSize=8,Font=Enum.Font.GothamBold,
			TextXAlignment=Enum.TextXAlignment.Left,
			ZIndex=6,Parent=row,
		})
		table.insert(secLabels, lbl)
	end

	local window = {}

	function window:AddTab(opts2)
		opts2 = type(opts2)=="table" and opts2 or {}

		local tabTitle   = opts2.Title   or "Tab"
		local tabIcon    = opts2.Icon    or "circle"
		local tabSection = opts2.Section or nil

		if tabSection then makeSideLabel(tabSection) end

		sideOrder += 1

		local btn = N("TextButton", {
			Size = UDim2.new(1,0,0,28),
			BackgroundColor3 = T.tabBgAct,
			BackgroundTransparency = 1,
			BorderSizePixel = 0, Text = "",
			AutoButtonColor = false,
			LayoutOrder = sideOrder, ZIndex = 6, Parent = sideScroll,
		})
		Corner(btn, 6)

		local ico = Img(icon(tabIcon), btn, 14, UDim2.new(0,6,0.5,-7), T.tabIdle, 7)
		local lbl = N("TextLabel", {
			Size = UDim2.new(1,-28,1,0),
			Position = UDim2.new(0,26,0,0),
			BackgroundTransparency = 1,
			Text = tabTitle, TextColor3 = T.tabIdle,
			TextSize = 11, Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 7, Parent = btn,
		})

		local ul = N("Frame", {
			Size = UDim2.new(0,0,0,2),
			Position = UDim2.new(0,4,1,-2),
			BackgroundColor3 = T.underline,
			BorderSizePixel = 0, Visible = false, ZIndex = 9, Parent = btn,
		})
		Corner(ul, 2)

		local tip = N("TextLabel", {
			Size = UDim2.new(0,86,0,24),
			Position = UDim2.new(1,5,0.5,-12),
			BackgroundColor3 = Color3.fromRGB(22,22,22),
			TextColor3 = T.white, TextSize = 10, Font = Enum.Font.Gotham,
			Text = tabTitle, TextXAlignment = Enum.TextXAlignment.Center,
			BackgroundTransparency = 0, ZIndex = 50, Visible = false, Parent = btn,
		})
		Corner(tip, 5)
		Stroke(tip, T.elBorder, 1, 0)

		local page = N("Frame", {
			Size = UDim2.fromScale(1,1),
			BackgroundColor3 = T.pageBg,
			BorderSizePixel = 0, ClipsDescendants = true,
			Visible = false, ZIndex = 2, Parent = contentArea,
		})

		local scroll = N("ScrollingFrame", {
			Size = UDim2.fromScale(1,1),
			BackgroundTransparency = 1,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = T.Accent,
			CanvasSize = UDim2.new(0,0,0,0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ZIndex = 2, Parent = page,
		})
		N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,5),Parent=scroll})
		N("UIPadding",{
			PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,10),
			PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10),
			Parent=scroll,
		})

		local tab = {
			name=tabTitle, btn=btn, ico=ico, lbl=lbl,
			ul=ul, tip=tip, page=page, scroll=scroll,
		}
		table.insert(tabs, tab)

		btn.MouseEnter:Connect(function()
			if activeTab ~= tab then
				Tw(btn,{BackgroundTransparency=0,BackgroundColor3=T.tabBgHov},0.1)
				Tw(ico,{ImageColor3=T.tabHov},0.1)
				Tw(lbl,{TextColor3 =T.tabHov},0.1)
			end
			if not sideExpanded and tip then tip.Visible = true end
		end)
		btn.MouseLeave:Connect(function()
			if activeTab ~= tab then
				Tw(btn,{BackgroundTransparency=1},0.1)
				Tw(ico,{ImageColor3=T.tabIdle},0.1)
				Tw(lbl,{TextColor3 =T.tabIdle},0.1)
			end
			if tip then tip.Visible = false end
		end)
		btn.MouseButton1Click:Connect(function() selectTab(tab) end)

		if #tabs == 1 then selectTab(tab, true) end
		if cfg.activeTab == tabTitle then selectTab(tab, true) end

		local tabObj = MkSecObj(gui, scroll, cfg, cfgPath)

		function tabObj:AddSection(sectionName)
			sectionName = type(sectionName)=="string" and sectionName or "Section"
			MkSection(scroll, sectionName)
			return MkSecObj(gui, scroll, cfg, cfgPath)
		end

		return tabObj
	end

	function window:Destroy()
		pcall(function() gui:Destroy() end)
	end

	return window
end

return lib
