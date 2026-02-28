--[[
	EcoHub V2 - Interface Library
	Sistema completo com:
	- Auto-save em ecohubv2/config.json
	- Texturas em todos os elementos
	- Animações de clique e hover
	- Suporte a Set/SetTitle/SetDescription em todos os elementos
	- SaveId automático em todos os elementos
	- Dropdown sem z-fighting de cores
	- Logo maior no topbar
	- Toggle compacto
]]

-- ─── Serviços ────────────────────────────────────────────────────────────────
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local RunService       = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ─── Sistema de Save ─────────────────────────────────────────────────────────
local SAVE_PATH = "ecohubv2/config.json"
local SaveData  = {}

local function loadSave()
	local ok, data = pcall(function()
		return HttpService:JSONDecode(readfile(SAVE_PATH))
	end)
	SaveData = (ok and type(data) == "table") and data or {}
end

local function flushSave()
	pcall(function()
		if not isfolder("ecohubv2") then makefolder("ecohubv2") end
		writefile(SAVE_PATH, HttpService:JSONEncode(SaveData))
	end)
end

local function getSaved(id, default)
	return SaveData[id] ~= nil and SaveData[id] or default
end

local function setSaved(id, value)
	SaveData[id] = value
	flushSave()
end

loadSave()

-- ─── Ícones ──────────────────────────────────────────────────────────────────
local ICONS = {
	aim              = "rbxassetid://10709818534",
	crosshair        = "rbxassetid://10709818534",
	target           = "rbxassetid://10734977012",
	swords           = "rbxassetid://10734975692",
	sword            = "rbxassetid://10734975486",
	flame            = "rbxassetid://10723376114",
	skull            = "rbxassetid://10734962068",
	shield           = "rbxassetid://10734951847",
	["shield-check"] = "rbxassetid://10734951367",
	bomb             = "rbxassetid://10709781460",
	zap              = "rbxassetid://10723345749",
	visuals          = "rbxassetid://10723346959",
	eye              = "rbxassetid://10723346959",
	["eye-off"]      = "rbxassetid://10723346871",
	image            = "rbxassetid://10723415040",
	layers           = "rbxassetid://10723424505",
	palette          = "rbxassetid://10734910430",
	paintbrush       = "rbxassetid://10734910187",
	focus            = "rbxassetid://10723377537",
	scan             = "rbxassetid://10734942565",
	vehicle          = "rbxassetid://10709789810",
	car              = "rbxassetid://10709789810",
	bike             = "rbxassetid://10709775894",
	plane            = "rbxassetid://10734922971",
	rocket           = "rbxassetid://10734934585",
	navigation       = "rbxassetid://10734906744",
	move             = "rbxassetid://10734900011",
	wind             = "rbxassetid://10747382750",
	players          = "rbxassetid://10747373176",
	user             = "rbxassetid://10747373176",
	users            = "rbxassetid://10747373426",
	["user-check"]   = "rbxassetid://10747371901",
	["user-x"]       = "rbxassetid://10747372992",
	contact          = "rbxassetid://10709811834",
	fingerprint      = "rbxassetid://10723375250",
	misc             = "rbxassetid://10723345749",
	electricity      = "rbxassetid://10723345749",
	star             = "rbxassetid://10734966248",
	crown            = "rbxassetid://10709818626",
	trophy           = "rbxassetid://10747363809",
	medal            = "rbxassetid://10734887072",
	ghost            = "rbxassetid://10723396107",
	["alert-triangle"]= "rbxassetid://10709753149",
	info             = "rbxassetid://10723415903",
	bell             = "rbxassetid://10709775704",
	config           = "rbxassetid://10734950309",
	settings         = "rbxassetid://10734950309",
	["settings-2"]   = "rbxassetid://10734950020",
	cog              = "rbxassetid://10709810948",
	sliders          = "rbxassetid://10734963400",
	["sliders-horizontal"] = "rbxassetid://10734963191",
	wrench           = "rbxassetid://10747383470",
	tool             = "rbxassetid://10747383470",
	cpu              = "rbxassetid://10709813383",
	terminal         = "rbxassetid://10734982144",
	code             = "rbxassetid://10709810463",
	database         = "rbxassetid://10709818996",
	weapon           = "rbxassetid://10734975486",
	gauge            = "rbxassetid://10723395708",
	activity         = "rbxassetid://10709752035",
	lock             = "rbxassetid://10723434711",
	unlock           = "rbxassetid://10747366027",
	key              = "rbxassetid://10723416652",
	save             = "rbxassetid://10734941499",
	download         = "rbxassetid://10723344270",
	upload           = "rbxassetid://10747366434",
	trash            = "rbxassetid://10747362393",
	copy             = "rbxassetid://10709812159",
	refresh          = "rbxassetid://10734933222",
	search           = "rbxassetid://10734943674",
	filter           = "rbxassetid://10723375128",
	list             = "rbxassetid://10723433811",
	grid             = "rbxassetid://10723404936",
	home             = "rbxassetid://10723407389",
	compass          = "rbxassetid://10709811445",
	map              = "rbxassetid://10734886202",
	globe            = "rbxassetid://10723404337",
	network          = "rbxassetid://10734906975",
}

-- ─── Tema ────────────────────────────────────────────────────────────────────
local T = {
	bg          = Color3.fromRGB(12, 12, 16),
	surface     = Color3.fromRGB(18, 18, 24),
	card        = Color3.fromRGB(22, 22, 30),
	elem        = Color3.fromRGB(26, 26, 36),
	elemHover   = Color3.fromRGB(32, 32, 44),
	elemPress   = Color3.fromRGB(38, 20, 62),
	topbar      = Color3.fromRGB(16, 16, 22),
	tabbar      = Color3.fromRGB(10, 10, 14),
	border      = Color3.fromRGB(44, 44, 58),
	borderGlow  = Color3.fromRGB(80, 50, 130),
	divider     = Color3.fromRGB(36, 36, 48),
	accentHi    = Color3.fromRGB(160, 100, 255),
	accentMid   = Color3.fromRGB(120, 70, 200),
	accentLo    = Color3.fromRGB(48, 18, 90),
	accentPress = Color3.fromRGB(60, 24, 110),
	text        = Color3.fromRGB(228, 228, 235),
	textDim     = Color3.fromRGB(160, 160, 175),
	muted       = Color3.fromRGB(100, 100, 118),
	dim         = Color3.fromRGB(48, 48, 62),
	white       = Color3.fromRGB(255, 255, 255),
}

-- Textura IDs
local TEX_NOISE  = "rbxassetid://9968344919"
local TEX_GRAIN  = "rbxassetid://6578871732"

-- ─── Constantes de Layout ────────────────────────────────────────────────────
local W        = 590
local H        = 375
local TOPBAR_H = 64
local TABBAR_H = 56
local ELEM_H   = 28
local PAD      = 6
local CORNER   = 8

-- ─── Utilitários ─────────────────────────────────────────────────────────────
local function ni(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do
		pcall(function() o[k] = v end)
	end
	if parent then o.Parent = parent end
	return o
end

local function uiCorner(parent, radius)
	return ni("UICorner", { CornerRadius = UDim.new(0, radius or CORNER) }, parent)
end

local function uiStroke(parent, color, thickness)
	return ni("UIStroke", { Color = color or T.border, Thickness = thickness or 1 }, parent)
end

local function tween(obj, props, dur, style, dir)
	TweenService:Create(
		obj,
		TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
		props
	):Play()
end

local function resolveIcon(id)
	if not id or id == "" then return "" end
	if type(id) == "string" and not id:match("rbxasset") then
		return ICONS[id] or id
	end
	return id
end

-- ─── Construtores de UI reutilizáveis ────────────────────────────────────────
local function addNoiseTex(parent, alpha, zIndex, tileSize)
	return ni("ImageLabel", {
		Size               = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image              = TEX_NOISE,
		ImageTransparency  = alpha or 0.88,
		ScaleType          = Enum.ScaleType.Tile,
		TileSize           = UDim2.new(0, tileSize or 64, 0, tileSize or 64),
		ZIndex             = zIndex or 2,
		ImageColor3        = T.accentHi,
	}, parent)
end

local function addGrainTex(parent, alpha, zIndex)
	return ni("ImageLabel", {
		Size               = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image              = TEX_GRAIN,
		ImageTransparency  = alpha or 0.92,
		ScaleType          = Enum.ScaleType.Tile,
		TileSize           = UDim2.new(0, 128, 0, 128),
		ZIndex             = zIndex or 3,
	}, parent)
end

local function addBottomDivider(parent, zIndex)
	local line = ni("Frame", {
		Size            = UDim2.new(1, -12, 0, 1),
		Position        = UDim2.new(0, 6, 1, -1),
		BackgroundColor3 = T.divider,
		BorderSizePixel = 0,
		ZIndex          = zIndex or 4,
	}, parent)
	uiCorner(line, 1)
	return line
end

-- Animação de clique (ripple sutil)
local function attachClickAnim(btn, target)
	btn.MouseButton1Down:Connect(function()
		tween(target, { BackgroundColor3 = T.elemPress }, 0.08)
	end)
	btn.MouseButton1Up:Connect(function()
		tween(target, { BackgroundColor3 = T.elem }, 0.18)
	end)
	btn.MouseLeave:Connect(function()
		tween(target, { BackgroundColor3 = T.elem }, 0.15)
	end)
end

local function attachHoverAnim(btn, target, normalColor, hoverColor)
	normalColor = normalColor or T.elem
	hoverColor  = hoverColor  or T.elemHover
	btn.MouseEnter:Connect(function()
		tween(target, { BackgroundColor3 = hoverColor }, 0.12)
	end)
	btn.MouseLeave:Connect(function()
		tween(target, { BackgroundColor3 = normalColor }, 0.15)
	end)
end

-- ─── Biblioteca Principal ─────────────────────────────────────────────────────
local Lib   = {}
Lib.Icons   = ICONS
Lib.Theme   = T

function Lib.new(config)
	config = config or {}

	if PlayerGui:FindFirstChild("EcoHub_V2") then
		PlayerGui.EcoHub_V2:Destroy()
	end

	-- ── ScreenGui ──────────────────────────────────────────────────────────────
	local Screen = ni("ScreenGui", {
		Name           = "EcoHub_V2",
		ResetOnSpawn   = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, PlayerGui)

	-- ── Janela Principal ───────────────────────────────────────────────────────
	local Main = ni("Frame", {
		Size             = UDim2.new(0, W, 0, H),
		Position         = UDim2.new(0.5, -W/2, 0.5, -H/2),
		BackgroundColor3 = T.bg,
		BorderSizePixel  = 0,
		Active           = true,
		Draggable        = true,
		ClipsDescendants = true,
	}, Screen)
	uiCorner(Main, 14)
	uiStroke(Main, T.borderGlow, 1.2)
	addNoiseTex(Main, 0.93, 1)
	addGrainTex(Main, 0.96, 2)

	-- ── TopBar ─────────────────────────────────────────────────────────────────
	local TopBar = ni("Frame", {
		Size             = UDim2.new(1, 0, 0, TOPBAR_H),
		BackgroundColor3 = T.topbar,
		BorderSizePixel  = 0,
		ZIndex           = 4,
	}, Main)
	uiCorner(TopBar, 14)
	-- Quadrado inferior para cobrir corners arredondados do fundo
	ni("Frame", {
		Size             = UDim2.new(1, 0, 0, 14),
		Position         = UDim2.new(0, 0, 1, -14),
		BackgroundColor3 = T.topbar,
		BorderSizePixel  = 0,
		ZIndex           = 4,
	}, TopBar)
	-- Linha divisória
	ni("Frame", {
		Size             = UDim2.new(1, 0, 0, 1),
		Position         = UDim2.new(0, 0, 1, -1),
		BackgroundColor3 = T.border,
		BorderSizePixel  = 0,
		ZIndex           = 5,
	}, TopBar)
	addNoiseTex(TopBar, 0.87, 5)

	-- Título
	local TitleLabel = ni("TextLabel", {
		Size                   = UDim2.new(0, 200, 1, 0),
		Position               = UDim2.new(0, 16, 0, 0),
		BackgroundTransparency = 1,
		Text                   = config.Title or "EcoHub",
		TextColor3             = T.text,
		TextSize               = 16,
		Font                   = Enum.Font.GothamBold,
		TextXAlignment         = Enum.TextXAlignment.Left,
		ZIndex                 = 6,
	}, TopBar)

	-- Logo Central (MAIOR)
	local LOGO_SIZE = 68
	local LogoContainer = ni("Frame", {
		Size             = UDim2.new(0, LOGO_SIZE, 0, LOGO_SIZE),
		Position         = UDim2.new(0.5, -LOGO_SIZE/2, 0.5, -LOGO_SIZE/2),
		BackgroundColor3 = T.surface,
		BorderSizePixel  = 0,
		ZIndex           = 6,
	}, TopBar)
	uiCorner(LogoContainer, 14)
	uiStroke(LogoContainer, T.border, 1)
	addNoiseTex(LogoContainer, 0.82, 7)
	ni("ImageLabel", {
		Size                   = UDim2.new(0.85, 0, 0.85, 0),
		Position               = UDim2.new(0.075, 0, 0.075, 0),
		BackgroundTransparency = 1,
		Image                  = config.Logo or "",
		ScaleType              = Enum.ScaleType.Fit,
		ZIndex                 = 8,
	}, LogoContainer)

	-- Bloco de usuário
	local USER_W = 165
	local UserBlock = ni("Frame", {
		Size                   = UDim2.new(0, USER_W, 0, TOPBAR_H),
		Position               = UDim2.new(1, -USER_W, 0, 0),
		BackgroundTransparency = 1,
		ZIndex                 = 6,
	}, TopBar)
	ni("Frame", {
		Size             = UDim2.new(0, 1, 0, 36),
		Position         = UDim2.new(0, 0, 0.5, -18),
		BackgroundColor3 = T.border,
		BorderSizePixel  = 0,
		ZIndex           = 6,
	}, UserBlock)

	local AvatarFrame = ni("Frame", {
		Size             = UDim2.new(0, 36, 0, 36),
		Position         = UDim2.new(0, 10, 0.5, -18),
		BackgroundColor3 = T.card,
		BorderSizePixel  = 0,
		ZIndex           = 7,
	}, UserBlock)
	uiCorner(AvatarFrame, 9)
	uiStroke(AvatarFrame, T.border, 1)
	local AvatarImg = ni("ImageLabel", {
		Size                   = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image                  = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=60&height=60&format=png",
		ScaleType              = Enum.ScaleType.Crop,
		ZIndex                 = 8,
	}, AvatarFrame)
	uiCorner(AvatarImg, 9)

	ni("TextLabel", {
		Size = UDim2.new(1, -54, 0, 16), Position = UDim2.new(0, 52, 0.5, -18),
		BackgroundTransparency = 1, Text = LocalPlayer.DisplayName,
		TextColor3 = T.text, TextSize = 11, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 7,
	}, UserBlock)
	ni("TextLabel", {
		Size = UDim2.new(1, -54, 0, 12), Position = UDim2.new(0, 52, 0.5, 2),
		BackgroundTransparency = 1, Text = "@" .. LocalPlayer.Name,
		TextColor3 = T.muted, TextSize = 9, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 7,
	}, UserBlock)

	-- ── Área de Páginas ────────────────────────────────────────────────────────
	local PageArea = ni("Frame", {
		Size                   = UDim2.new(1, -PAD*2, 1, -TOPBAR_H - TABBAR_H - PAD*2),
		Position               = UDim2.new(0, PAD, 0, TOPBAR_H + PAD),
		BackgroundTransparency = 1,
		BorderSizePixel        = 0,
		ClipsDescendants       = true,
	}, Main)

	-- ── TabBar ─────────────────────────────────────────────────────────────────
	local TabBar = ni("Frame", {
		Size             = UDim2.new(1, 0, 0, TABBAR_H),
		Position         = UDim2.new(0, 0, 1, -TABBAR_H),
		BackgroundColor3 = T.tabbar,
		BorderSizePixel  = 0,
		ClipsDescendants = true,
		ZIndex           = 8,
	}, Main)
	uiCorner(TabBar, 14)
	ni("Frame", {
		Size = UDim2.new(1, 0, 0, 14), BackgroundColor3 = T.tabbar,
		BorderSizePixel = 0, ZIndex = 8,
	}, TabBar)
	ni("Frame", {
		Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = T.border,
		BorderSizePixel = 0, ZIndex = 9,
	}, TabBar)
	addNoiseTex(TabBar, 0.88, 9)

	-- ── Estado das Abas ────────────────────────────────────────────────────────
	local tabList    = {}
	local tabBtns    = {}
	local pages      = {}
	local curTab     = nil
	local animating  = false

	local ICON_SIZE  = 17
	local SMALL_W    = 48
	local EXPAND_W   = 126

	local function calcTabPositions(activeIdx)
		local expW = EXPAND_W
		if expW + (#tabList - 1) * SMALL_W > W - 20 then
			expW = math.max(SMALL_W + 20, W - 20 - (#tabList - 1) * SMALL_W)
		end
		local positions = {}
		local x = 0
		for i = 1, #tabList do
			local w = (i == activeIdx) and expW or SMALL_W
			positions[i] = { x = x, w = w }
			x = x + w
		end
		local total  = expW + (#tabList - 1) * SMALL_W
		local offset = math.max(4, math.floor((W - total) / 2))
		for i = 1, #tabList do positions[i].x = positions[i].x + offset end
		return positions, expW
	end

	local function switchTab(name)
		if curTab == name then return end
		if curTab and pages[curTab] then pages[curTab].Visible = false end
		curTab              = name
		pages[name].Visible = true

		local activeIdx = 1
		for i, t in ipairs(tabList) do
			if t.name == name then activeIdx = i break end
		end

		local positions = calcTabPositions(activeIdx)
		for i, tb in ipairs(tabBtns) do
			local active = tabList[i].name == name
			local p      = positions[i]
			tween(tb.bg, { Position = UDim2.new(0, p.x, 0, 0), Size = UDim2.new(0, p.w, 1, 0) }, 0.3)
			if active then
				tween(tb.sq,  { BackgroundColor3 = T.accentLo },             0.25)
				tween(tb.str, { Color = T.accentHi, Thickness = 1.5 },       0.25)
				tween(tb.img, { ImageColor3 = T.accentHi },                  0.25)
				tween(tb.lbl, { TextColor3 = T.text,  TextTransparency = 0 }, 0.25)
				tween(tb.sub, { TextColor3 = T.muted, TextTransparency = 0 }, 0.25)
			else
				tween(tb.sq,  { BackgroundColor3 = T.card },                 0.25)
				tween(tb.str, { Color = T.border, Thickness = 1 },           0.25)
				tween(tb.img, { ImageColor3 = T.dim },                       0.25)
				tween(tb.lbl, { TextTransparency = 1 },                      0.18)
				tween(tb.sub, { TextTransparency = 1 },                      0.18)
			end
		end
	end

	-- ── Animação Show/Hide ─────────────────────────────────────────────────────
	local function setAllVisible(state)
		for _, v in ipairs(Main:GetChildren()) do
			if v:IsA("GuiObject") then v.Visible = state end
		end
	end

	local function showGui()
		if animating then return end
		animating = true
		Main.Visible = true
		Main.BackgroundTransparency = 1
		setAllVisible(false)
		tween(Main, { BackgroundTransparency = 0 }, 0.25, Enum.EasingStyle.Quart)
		task.delay(0.1,  function() setAllVisible(true) end)
		task.delay(0.28, function() animating = false end)
	end

	local function hideGui()
		if animating then return end
		animating = true
		setAllVisible(false)
		tween(Main, { BackgroundTransparency = 1 }, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		task.delay(0.24, function() Main.Visible = false animating = false end)
	end

	local guiVisible = true
	local toggleKey  = config.Toggle or Enum.KeyCode.LeftAlt

	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.KeyCode == toggleKey or input.KeyCode == Enum.KeyCode.RightAlt then
			guiVisible = not guiVisible
			if guiVisible then showGui() else hideGui() end
		end
	end)

	-- ── API da Janela ──────────────────────────────────────────────────────────
	local win = {}

	function win:SetTitle(text)
		TitleLabel.Text = text
	end

	function win:AddTab(cfg)
		cfg = cfg or {}
		local name    = cfg.Name or ("Tab" .. #tabList + 1)
		local subText = cfg.Sub  or ""
		local iconId  = resolveIcon(cfg.Icon) or ICONS.aim

		-- Página
		local page = ni("Frame", {
			Name = name, Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1, Visible = false,
		}, PageArea)
		pages[name] = page
		table.insert(tabList, { name = name, sub = subText, icon = iconId })

		-- Reposicionar abas existentes
		local idx       = #tabList
		local positions = calcTabPositions(idx)
		for i, tb in ipairs(tabBtns) do
			local p = positions[i]
			tb.bg.Position = UDim2.new(0, p.x, 0, 0)
			tb.bg.Size     = UDim2.new(0, SMALL_W, 1, 0)
		end

		-- Construir botão da aba
		local p  = positions[idx]
		local bg = ni("Frame", {
			Size = UDim2.new(0, SMALL_W, 1, 0), Position = UDim2.new(0, p.x, 0, 0),
			BackgroundTransparency = 1, BorderSizePixel = 0,
			ClipsDescendants = true, ZIndex = 9,
		}, TabBar)
		local sq = ni("Frame", {
			Size = UDim2.new(0, 38, 0, 38), Position = UDim2.new(0, 5, 0.5, -19),
			BackgroundColor3 = T.card, BorderSizePixel = 0, ZIndex = 10,
		}, bg)
		uiCorner(sq, 10)
		addNoiseTex(sq, 0.82, 11)
		local sqStr = uiStroke(sq, T.border, 1)
		local img = ni("ImageLabel", {
			Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE),
			Position = UDim2.new(0.5, -ICON_SIZE/2, 0.5, -ICON_SIZE/2),
			BackgroundTransparency = 1, Image = iconId, ImageColor3 = T.dim, ZIndex = 12,
		}, sq)
		local lbl = ni("TextLabel", {
			Size = UDim2.new(1, -50, 0, 15), Position = UDim2.new(0, 48, 0.5, -14),
			BackgroundTransparency = 1, Text = name, TextColor3 = T.text,
			TextSize = 11, Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, ZIndex = 10,
		}, bg)
		local sub_lbl = ni("TextLabel", {
			Size = UDim2.new(1, -50, 0, 10), Position = UDim2.new(0, 48, 0.5, 2),
			BackgroundTransparency = 1, Text = subText, TextColor3 = T.muted,
			TextSize = 8, Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, ZIndex = 10,
		}, bg)

		local btn = ni("TextButton", {
			Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
			Text = "", BorderSizePixel = 0, ZIndex = 14,
		}, bg)
		btn.MouseButton1Click:Connect(function()
			tween(sq, { BackgroundColor3 = T.accentPress }, 0.08)
			task.delay(0.12, function()
				if curTab == name then
					tween(sq, { BackgroundColor3 = T.accentLo }, 0.15)
				end
			end)
			switchTab(name)
		end)
		btn.MouseEnter:Connect(function()
			if curTab ~= name then
				tween(sq,  { BackgroundColor3 = T.elemHover }, 0.12)
				tween(img, { ImageColor3 = T.muted },          0.12)
			end
		end)
		btn.MouseLeave:Connect(function()
			if curTab ~= name then
				tween(sq,  { BackgroundColor3 = T.card }, 0.15)
				tween(img, { ImageColor3 = T.dim },       0.15)
			end
		end)

		tabBtns[idx] = { name = name, bg = bg, sq = sq, str = sqStr, img = img, lbl = lbl, sub = sub_lbl }

		if #tabList == 1 then
			switchTab(name)
		end

		-- ── Sections ───────────────────────────────────────────────────────────
		local function makeSection(secName)
			local f = ni("Frame", {
				Name = secName, BackgroundColor3 = T.surface, BorderSizePixel = 0,
			}, page)
			uiCorner(f, 10)
			addNoiseTex(f, 0.90, 1)
			return f
		end

		local SecLeft   = makeSection("SectionLeft")
		local SecCenter = makeSection("SectionCenter")
		local SecRight  = makeSection("SectionRight")

		local function layoutSections()
			local totalW = PageArea.AbsoluteSize.X - PAD * 2
			local totalH = PageArea.AbsoluteSize.Y - PAD * 2
			local gap    = PAD
			local eachW  = math.floor((totalW - gap * 2) / 3)
			SecLeft.Position   = UDim2.new(0, PAD, 0, PAD)
			SecLeft.Size       = UDim2.new(0, eachW, 0, totalH)
			SecCenter.Position = UDim2.new(0, PAD + eachW + gap, 0, PAD)
			SecCenter.Size     = UDim2.new(0, eachW, 0, totalH)
			SecRight.Position  = UDim2.new(0, PAD + (eachW + gap) * 2, 0, PAD)
			SecRight.Size      = UDim2.new(0, eachW, 0, totalH)
		end
		layoutSections()
		PageArea:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutSections)

		local tab = {
			Page          = page,
			SectionLeft   = SecLeft,
			SectionCenter = SecCenter,
			SectionRight  = SecRight,
		}

		-- ── AddSection ─────────────────────────────────────────────────────────
		function tab:AddSection(cfg2)
			cfg2 = cfg2 or {}
			local side    = cfg2.Side  or "Left"
			local title   = cfg2.Title or ""
			local iconId2 = resolveIcon(cfg2.Icon) or ""

			local target = (side == "Right" and SecRight) or (side == "Center" and SecCenter) or SecLeft

			local HEADER_H = 34

			-- Cabeçalho da Section
			if title ~= "" then
				local hdr = ni("Frame", {
					Size             = UDim2.new(1, 0, 0, HEADER_H),
					BackgroundColor3 = T.surface,
					BorderSizePixel  = 0,
					ZIndex           = 2,
				}, target)
				local txtX = 10
				if iconId2 ~= "" then
					ni("ImageLabel", {
						Size = UDim2.new(0, 13, 0, 13), Position = UDim2.new(0, 10, 0.5, -6.5),
						BackgroundTransparency = 1, Image = iconId2, ImageColor3 = T.accentHi, ZIndex = 3,
					}, hdr)
					txtX = 27
				end
				ni("TextLabel", {
					Size = UDim2.new(1, -txtX - 4, 1, 0), Position = UDim2.new(0, txtX, 0, 0),
					BackgroundTransparency = 1, Text = title,
					TextColor3 = T.accentHi, TextSize = 11,
					Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
				}, hdr)
				-- Linha divisória cinza (não roxa)
				ni("Frame", {
					Size = UDim2.new(1, -12, 0, 1), Position = UDim2.new(0, 6, 1, -1),
					BackgroundColor3 = T.divider, BorderSizePixel = 0, ZIndex = 3,
				}, hdr)
			end

			-- ScrollingFrame dos elementos
			local scroll = ni("ScrollingFrame", {
				Size                 = UDim2.new(1, -4, 1, -HEADER_H),
				Position             = UDim2.new(0, 2, 0, HEADER_H),
				BackgroundTransparency = 1,
				BorderSizePixel      = 0,
				ScrollBarThickness   = 3,
				ScrollBarImageColor3 = T.accentHi,
				CanvasSize           = UDim2.new(0, 0, 0, 0),
				ScrollingDirection   = Enum.ScrollingDirection.Y,
				ClipsDescendants     = true,
				ZIndex               = 2,
			}, target)

			local layout = ni("UIListLayout", {
				SortOrder           = Enum.SortOrder.LayoutOrder,
				Padding             = UDim.new(0, 3),
				FillDirection       = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}, scroll)

			ni("UIPadding", {
				PaddingLeft   = UDim.new(0, 5),
				PaddingRight  = UDim.new(0, 5),
				PaddingTop    = UDim.new(0, 5),
				PaddingBottom = UDim.new(0, 5),
			}, scroll)

			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 14)
			end)

			-- ── Helpers de elementos ─────────────────────────────────────────────
			local rowCount = 0

			-- Cria um row base com textura e divisor
			local function newRow(h)
				rowCount = rowCount + 1
				local r = ni("Frame", {
					Size             = UDim2.new(1, 0, 0, h),
					BackgroundColor3 = T.elem,
					BorderSizePixel  = 0,
					LayoutOrder      = rowCount,
					ZIndex           = 3,
					ClipsDescendants = true,
				}, scroll)
				uiCorner(r, 7)
				uiStroke(r, T.border, 0.8)
				addNoiseTex(r, 0.84, 4)
				addGrainTex(r, 0.94, 5)
				addBottomDivider(r, 6)
				return r
			end

			-- Cria wrapper para elementos expansíveis (dropdown, colorpicker)
			local function newExpandWrapper(h)
				rowCount = rowCount + 1
				local wrapper = ni("Frame", {
					Size = UDim2.new(1, 0, 0, h),
					BackgroundTransparency = 1, BorderSizePixel = 0,
					LayoutOrder = rowCount, ClipsDescendants = false,
					ZIndex = 3,
				}, scroll)
				local row = ni("Frame", {
					Size             = UDim2.new(1, 0, 0, h),
					BackgroundColor3 = T.elem, BorderSizePixel = 0, ZIndex = 3,
					ClipsDescendants = true,
				}, wrapper)
				uiCorner(row, 7)
				uiStroke(row, T.border, 0.8)
				addNoiseTex(row, 0.84, 4)
				addGrainTex(row, 0.94, 5)
				addBottomDivider(row, 6)
				return wrapper, row
			end

			-- Label esquerda padrão
			local function addRowLabel(parent, text, y_offset)
				return ni("TextLabel", {
					Size = UDim2.new(1, -10, 1, 0),
					Position = UDim2.new(0, 10, 0, y_offset or 0),
					BackgroundTransparency = 1, Text = text,
					TextColor3 = T.text, TextSize = 10,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 6,
				}, parent)
			end

			local sec = { Frame = target, Scroll = scroll }

			-- ════════════════════════════════════════════════════════════════════
			-- TOGGLE
			-- ════════════════════════════════════════════════════════════════════
			function sec:AddToggle(cfg3)
				cfg3 = cfg3 or {}
				local label    = cfg3.Name     or "Toggle"
				local saveId   = cfg3.SaveId   or ("toggle_" .. label)
				local default  = cfg3.Default  or false
				local callback = cfg3.Callback or function() end
				local state    = getSaved(saveId, not not default)

				local row = newRow(ELEM_H)
				local nameLbl = addRowLabel(row, label)

				-- Track (menor)
				local TRK_W, TRK_H = 28, 15
				local track = ni("Frame", {
					Size             = UDim2.new(0, TRK_W, 0, TRK_H),
					Position         = UDim2.new(1, -TRK_W - 8, 0.5, -TRK_H / 2),
					BackgroundColor3 = state and T.accentHi or T.dim,
					BorderSizePixel  = 0,
					ZIndex           = 6,
				}, row)
				uiCorner(track, TRK_H)
				addNoiseTex(track, 0.78, 7)
				local trackStr = uiStroke(track, state and T.accentHi or T.border, 1)

				local KNOB = 11
				local knob = ni("Frame", {
					Size             = UDim2.new(0, KNOB, 0, KNOB),
					Position         = state and UDim2.new(1, -KNOB - 2, 0.5, -KNOB / 2) or UDim2.new(0, 2, 0.5, -KNOB / 2),
					BackgroundColor3 = T.white,
					BorderSizePixel  = 0,
					ZIndex           = 8,
				}, track)
				uiCorner(knob, KNOB)

				local function applyState(v, animate)
					local dur = animate and 0.2 or 0
					tween(track,    { BackgroundColor3 = v and T.accentHi or T.dim }, dur)
					tween(trackStr, { Color = v and T.accentHi or T.border },         dur)
					tween(knob,     { Position = v and UDim2.new(1, -KNOB - 2, 0.5, -KNOB / 2) or UDim2.new(0, 2, 0.5, -KNOB / 2) }, dur)
				end

				local btn = ni("TextButton", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 10,
				}, row)
				btn.MouseButton1Click:Connect(function()
					state = not state
					-- animação de clique no row
					tween(row, { BackgroundColor3 = T.elemPress }, 0.08)
					task.delay(0.12, function() tween(row, { BackgroundColor3 = T.elem }, 0.15) end)
					applyState(state, true)
					setSaved(saveId, state)
					callback(state)
				end)
				attachHoverAnim(btn, row)

				applyState(state, false)
				task.defer(function() callback(state) end)

				-- API do elemento
				local el = { Value = state }
				function el:Set(v)
					state = not not v
					el.Value = state
					applyState(state, true)
					setSaved(saveId, state)
					callback(state)
				end
				function el:SetTitle(t) nameLbl.Text = t end
				function el:OnChanged(fn)
					local old = callback
					callback = function(val) old(val) fn(val) end
					fn(state)
				end
				return el
			end

			-- ════════════════════════════════════════════════════════════════════
			-- SLIDER
			-- ════════════════════════════════════════════════════════════════════
			function sec:AddSlider(cfg3)
				cfg3 = cfg3 or {}
				local label    = cfg3.Name     or "Slider"
				local saveId   = cfg3.SaveId   or ("slider_" .. label)
				local minV     = cfg3.Min      or 0
				local maxV     = cfg3.Max      or 100
				local rounding = cfg3.Rounding or 1
				local default  = cfg3.Default  or minV
				local suffix   = cfg3.Suffix   or ""
				local callback = cfg3.Callback or function() end
				local value    = getSaved(saveId, math.clamp(default, minV, maxV))

				local function roundVal(v)
					return math.floor(v / rounding + 0.5) * rounding
				end

				local ROW_H = ELEM_H + 16
				local row   = newRow(ROW_H)

				local nameLbl = ni("TextLabel", {
					Size = UDim2.new(1, -56, 0, 14), Position = UDim2.new(0, 10, 0, 5),
					BackgroundTransparency = 1, Text = label,
					TextColor3 = T.text, TextSize = 10, Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6,
				}, row)

				local valLbl = ni("TextLabel", {
					Size = UDim2.new(0, 46, 0, 14), Position = UDim2.new(1, -50, 0, 5),
					BackgroundTransparency = 1,
					Text = tostring(roundVal(value)) .. suffix,
					TextColor3 = T.accentHi, TextSize = 10, Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 6,
				}, row)

				local railBg = ni("Frame", {
					Size = UDim2.new(1, -20, 0, 5), Position = UDim2.new(0, 10, 0, 28),
					BackgroundColor3 = T.dim, BorderSizePixel = 0, ZIndex = 6,
				}, row)
				uiCorner(railBg, 5)
				addNoiseTex(railBg, 0.76, 7)

				local pct  = (value - minV) / math.max(maxV - minV, 1)
				local fill = ni("Frame", {
					Size = UDim2.new(pct, 0, 1, 0),
					BackgroundColor3 = T.accentHi, BorderSizePixel = 0, ZIndex = 7,
				}, railBg)
				uiCorner(fill, 5)
				addNoiseTex(fill, 0.72, 8)

				local dot = ni("Frame", {
					Size        = UDim2.new(0, 13, 0, 13),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position    = UDim2.new(pct, 0, 0.5, 0),
					BackgroundColor3 = T.white,
					BorderSizePixel  = 0,
					ZIndex           = 9,
				}, railBg)
				uiCorner(dot, 13)
				uiStroke(dot, T.accentHi, 1.5)

				local function setVal(v, animate)
					value = roundVal(math.clamp(v, minV, maxV))
					local p   = (value - minV) / math.max(maxV - minV, 1)
					local dur = animate and 0.08 or 0
					tween(fill, { Size = UDim2.new(p, 0, 1, 0) },       dur)
					tween(dot,  { Position = UDim2.new(p, 0, 0.5, 0) }, dur)
					valLbl.Text = tostring(value) .. suffix
					setSaved(saveId, value)
					callback(value)
				end

				local dragging = false
				local function onDrag(absX)
					local rel = math.clamp(
						(absX - railBg.AbsolutePosition.X) / railBg.AbsoluteSize.X, 0, 1
					)
					setVal(minV + rel * (maxV - minV), false)
				end

				local hitArea = ni("TextButton", {
					Size = UDim2.new(1, 0, 0, ROW_H), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 12,
				}, row)
				hitArea.MouseButton1Down:Connect(function(x)
					dragging = true
					tween(dot, { Size = UDim2.new(0, 15, 0, 15) }, 0.1)
					onDrag(x)
				end)
				hitArea.MouseButton1Up:Connect(function()
					dragging = false
					tween(dot, { Size = UDim2.new(0, 13, 0, 13) }, 0.1)
				end)
				UserInputService.InputChanged:Connect(function(i)
					if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
						onDrag(i.Position.X)
					end
				end)
				UserInputService.InputEnded:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
						tween(dot, { Size = UDim2.new(0, 13, 0, 13) }, 0.1)
					end
				end)
				attachHoverAnim(hitArea, row)

				setVal(value, false)
				task.defer(function() callback(value) end)

				local el = { Value = value }
				function el:Set(v) setVal(v, true) el.Value = value end
				function el:SetTitle(t) nameLbl.Text = t end
				function el:SetDescription(t) end -- placeholder compatibilidade
				function el:OnChanged(fn)
					local old = callback
					callback = function(val) old(val) fn(val) end
					fn(value)
				end
				return el
			end

			-- ════════════════════════════════════════════════════════════════════
			-- KEYBIND
			-- ════════════════════════════════════════════════════════════════════
			function sec:AddKeybind(cfg3)
				cfg3 = cfg3 or {}
				local label    = cfg3.Name     or "Keybind"
				local saveId   = cfg3.SaveId   or ("keybind_" .. label)
				local default  = cfg3.Default  or Enum.KeyCode.Unknown
				local callback = cfg3.Callback or function() end

				-- Restaurar tecla salva
				local savedName = getSaved(saveId, nil)
				local key = default
				if savedName then
					pcall(function() key = Enum.KeyCode[savedName] end)
				end
				local listening = false

				local row     = newRow(ELEM_H)
				local nameLbl = addRowLabel(row, label)

				local kBox = ni("Frame", {
					Size = UDim2.new(0, 64, 0, 20), Position = UDim2.new(1, -70, 0.5, -10),
					BackgroundColor3 = T.bg, BorderSizePixel = 0, ZIndex = 6,
				}, row)
				uiCorner(kBox, 5)
				addNoiseTex(kBox, 0.80, 7)
				local kStr = uiStroke(kBox, T.border, 1)

				local kLbl = ni("TextLabel", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
					Text = type(key) == "userdata" and key.Name or tostring(key),
					TextColor3 = T.accentHi, TextSize = 9, Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 8,
				}, kBox)

				local btn = ni("TextButton", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 10,
				}, row)
				btn.MouseButton1Click:Connect(function()
					listening = true
					kLbl.Text = "..."
					kLbl.TextColor3 = T.muted
					tween(kStr, { Color = T.accentHi }, 0.1)
					-- animação clique no row
					tween(row, { BackgroundColor3 = T.elemPress }, 0.08)
					task.delay(0.12, function() tween(row, { BackgroundColor3 = T.elem }, 0.15) end)
				end)
				UserInputService.InputBegan:Connect(function(input, processed)
					if not listening then return end
					if input.UserInputType == Enum.UserInputType.Keyboard then
						listening = false
						key = input.KeyCode
						kLbl.Text = key.Name
						kLbl.TextColor3 = T.accentHi
						tween(kStr, { Color = T.border }, 0.1)
						setSaved(saveId, key.Name)
						callback(key)
					end
				end)
				attachHoverAnim(btn, row)

				local el = { Value = key }
				function el:Set(k)
					key = k
					el.Value = k
					kLbl.Text = type(k) == "userdata" and k.Name or tostring(k)
					setSaved(saveId, kLbl.Text)
					callback(key)
				end
				function el:SetTitle(t) nameLbl.Text = t end
				function el:OnChanged(fn)
					local old = callback
					callback = function(val) old(val) fn(val) end
					fn(key)
				end
				return el
			end

			-- ════════════════════════════════════════════════════════════════════
			-- DROPDOWN
			-- ════════════════════════════════════════════════════════════════════
			function sec:AddDropdown(cfg3)
				cfg3 = cfg3 or {}
				local label    = cfg3.Name     or "Dropdown"
				local saveId   = cfg3.SaveId   or ("dropdown_" .. label)
				local options  = cfg3.Options  or {}
				local default  = cfg3.Default  or (options[1] or "")
				local callback = cfg3.Callback or function() end
				local selected = getSaved(saveId, default)
				local open     = false

				local OPT_H     = 24
				local totalOptH = #options * OPT_H

				local wrapper, row = newExpandWrapper(ELEM_H)

				-- Label
				local nameLbl = ni("TextLabel", {
					Size = UDim2.new(1, -88, 1, 0), Position = UDim2.new(0, 10, 0, 0),
					BackgroundTransparency = 1, Text = label,
					TextColor3 = T.text, TextSize = 10, Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
				}, row)

				-- Caixa de seleção
				local selBox = ni("Frame", {
					Size = UDim2.new(0, 74, 0, 20), Position = UDim2.new(1, -80, 0.5, -10),
					BackgroundColor3 = T.bg, BorderSizePixel = 0, ZIndex = 6,
				}, row)
				uiCorner(selBox, 5)
				addNoiseTex(selBox, 0.78, 7)
				uiStroke(selBox, T.border, 1)

				local selLbl = ni("TextLabel", {
					Size = UDim2.new(1, -18, 1, 0), Position = UDim2.new(0, 6, 0, 0),
					BackgroundTransparency = 1, Text = selected,
					TextColor3 = T.accentHi, TextSize = 9, Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 8,
				}, selBox)
				ni("TextLabel", {
					Size = UDim2.new(0, 14, 1, 0), Position = UDim2.new(1, -14, 0, 0),
					BackgroundTransparency = 1, Text = "▾",
					TextColor3 = T.muted, TextSize = 10, Font = Enum.Font.GothamBold, ZIndex = 8,
				}, selBox)

				-- Painel do dropdown (ZIndex alto, sem ClipsDescendants no wrapper)
				local dropPanel = ni("Frame", {
					Size = UDim2.new(1, 0, 0, 0),
					Position = UDim2.new(0, 0, 0, ELEM_H + 3),
					BackgroundColor3 = T.card,
					BorderSizePixel  = 0,
					ClipsDescendants = true,
					ZIndex           = 30,
					Visible          = false,
				}, wrapper)
				uiCorner(dropPanel, 7)
				uiStroke(dropPanel, T.border, 0.8)
				addNoiseTex(dropPanel, 0.82, 31)

				local optList = ni("Frame", {
					Size = UDim2.new(1, 0, 0, totalOptH),
					BackgroundTransparency = 1, ZIndex = 32,
				}, dropPanel)
				ni("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 0) }, optList)

				local optionBtns = {}

				local function buildOptions()
					for _, ch in ipairs(optList:GetChildren()) do
						if not ch:IsA("UIListLayout") then ch:Destroy() end
					end
					optionBtns = {}
					for i2, opt in ipairs(options) do
						local isSelected = (opt == selected)
						local optBtn = ni("TextButton", {
							Size = UDim2.new(1, 0, 0, OPT_H),
							-- Cor de fundo SÓLIDA para evitar z-fighting
							BackgroundColor3 = isSelected and T.accentLo or T.card,
							BorderSizePixel  = 0,
							Text             = "",
							ZIndex           = 33,
							LayoutOrder      = i2,
						}, optList)
						-- SEM textura no optBtn para evitar cor transparente atravessar
						local optLbl = ni("TextLabel", {
							Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0),
							BackgroundTransparency = 1, Text = opt,
							TextColor3 = isSelected and T.accentHi or T.textDim,
							TextSize = 9, Font = Enum.Font.Gotham,
							TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 34,
						}, optBtn)
						optBtn.MouseButton1Click:Connect(function()
							selected = opt
							selLbl.Text = opt
							open = false
							-- Atualizar visuais de todas as opções
							for _, ob in ipairs(optionBtns) do
								local sel2 = ob.lbl.Text == opt
								tween(ob.btn, { BackgroundColor3 = sel2 and T.accentLo or T.card }, 0.1)
								tween(ob.lbl, { TextColor3 = sel2 and T.accentHi or T.textDim },    0.1)
							end
							-- Fechar dropdown
							tween(dropPanel, { Size = UDim2.new(1, 0, 0, 0) }, 0.18)
							task.delay(0.2, function()
								dropPanel.Visible = false
								wrapper.Size = UDim2.new(1, 0, 0, ELEM_H)
							end)
							setSaved(saveId, selected)
							callback(selected)
						end)
						optBtn.MouseEnter:Connect(function()
							if opt ~= selected then
								tween(optBtn, { BackgroundColor3 = T.elemHover }, 0.1)
							end
						end)
						optBtn.MouseLeave:Connect(function()
							if opt ~= selected then
								tween(optBtn, { BackgroundColor3 = T.card }, 0.1)
							end
						end)
						table.insert(optionBtns, { btn = optBtn, lbl = optLbl })
					end
					totalOptH = #options * OPT_H
					optList.Size = UDim2.new(1, 0, 0, totalOptH)
				end
				buildOptions()

				local toggleBtn = ni("TextButton", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 10,
				}, row)
				toggleBtn.MouseButton1Click:Connect(function()
					open = not open
					-- animação clique
					tween(row, { BackgroundColor3 = T.elemPress }, 0.08)
					task.delay(0.12, function() tween(row, { BackgroundColor3 = T.elem }, 0.15) end)
					if open then
						dropPanel.Visible = true
						dropPanel.Size    = UDim2.new(1, 0, 0, 0)
						wrapper.Size      = UDim2.new(1, 0, 0, ELEM_H + totalOptH + 5)
						tween(dropPanel, { Size = UDim2.new(1, 0, 0, totalOptH) }, 0.22)
					else
						tween(dropPanel, { Size = UDim2.new(1, 0, 0, 0) }, 0.18)
						task.delay(0.2, function()
							dropPanel.Visible = false
							wrapper.Size = UDim2.new(1, 0, 0, ELEM_H)
						end)
					end
				end)
				attachHoverAnim(toggleBtn, row)

				task.defer(function() callback(selected) end)

				local el = { Value = selected }
				function el:Set(v)
					selected = v
					selLbl.Text = v
					el.Value = v
					setSaved(saveId, v)
					callback(v)
				end
				function el:SetTitle(t) nameLbl.Text = t end
				function el:SetOptions(newOpts)
					options = newOpts
					buildOptions()
				end
				function el:OnChanged(fn)
					local old = callback
					callback = function(val) old(val) fn(val) end
					fn(selected)
				end
				return el
			end

			-- ════════════════════════════════════════════════════════════════════
			-- BUTTON
			-- ════════════════════════════════════════════════════════════════════
			function sec:AddButton(cfg3)
				cfg3 = cfg3 or {}
				local label    = cfg3.Name     or "Button"
				local callback = cfg3.Callback or function() end

				local row     = newRow(ELEM_H)
				local nameLbl = addRowLabel(row, label)

				-- Indicador lateral accent
				local bar = ni("Frame", {
					Size = UDim2.new(0, 3, 0, 16), Position = UDim2.new(0, 0, 0.5, -8),
					BackgroundColor3 = T.accentHi, BorderSizePixel = 0, ZIndex = 6,
				}, row)
				uiCorner(bar, 2)

				local btn = ni("TextButton", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 10,
				}, row)
				btn.MouseButton1Click:Connect(function()
					tween(row, { BackgroundColor3 = T.accentPress }, 0.08)
					tween(bar, { BackgroundColor3 = T.accentMid   }, 0.08)
					task.delay(0.16, function()
						tween(row, { BackgroundColor3 = T.elem    }, 0.18)
						tween(bar, { BackgroundColor3 = T.accentHi }, 0.18)
					end)
					callback()
				end)
				attachHoverAnim(btn, row)

				local el = { Frame = row }
				function el:SetTitle(t) nameLbl.Text = t end
				return el
			end

			-- ════════════════════════════════════════════════════════════════════
			-- LABEL
			-- ════════════════════════════════════════════════════════════════════
			function sec:AddLabel(cfg3)
				cfg3 = cfg3 or {}
				local text  = cfg3.Text  or "Label"
				local color = cfg3.Color or T.muted

				local row = newRow(ELEM_H)
				local lbl = ni("TextLabel", {
					Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0),
					BackgroundTransparency = 1, Text = text,
					TextColor3 = color, TextSize = 10, Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6,
				}, row)

				local el = { Frame = row }
				function el:Set(t, c)
					lbl.Text = t
					if c then lbl.TextColor3 = c end
				end
				function el:SetTitle(t) lbl.Text = t end
				function el:SetColor(c) lbl.TextColor3 = c end
				return el
			end

			-- ════════════════════════════════════════════════════════════════════
			-- PARAGRAPH
			-- ════════════════════════════════════════════════════════════════════
			function sec:AddParagraph(cfg3)
				cfg3 = cfg3 or {}
				local title = cfg3.Title or ""
				local text  = cfg3.Text  or ""
				local lines = math.max(1, math.ceil(#text / 28))
				local rowH  = (title ~= "" and 14 or 0) + lines * 12 + 12

				local row = newRow(rowH)
				local titleLbl
				if title ~= "" then
					titleLbl = ni("TextLabel", {
						Size = UDim2.new(1, -10, 0, 13), Position = UDim2.new(0, 10, 0, 5),
						BackgroundTransparency = 1, Text = title,
						TextColor3 = T.accentHi, TextSize = 10, Font = Enum.Font.GothamBold,
						TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6,
					}, row)
				end
				local txtLbl = ni("TextLabel", {
					Size     = UDim2.new(1, -10, 0, lines * 12),
					Position = UDim2.new(0, 10, 0, title ~= "" and 19 or 5),
					BackgroundTransparency = 1, Text = text,
					TextColor3 = T.muted, TextSize = 9, Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, ZIndex = 6,
				}, row)

				local el = { Frame = row }
				function el:Set(t) txtLbl.Text = t end
				function el:SetTitle(t) if titleLbl then titleLbl.Text = t end end
				function el:SetDescription(t) txtLbl.Text = t end
				return el
			end

			-- ════════════════════════════════════════════════════════════════════
			-- COLOR PICKER
			-- ════════════════════════════════════════════════════════════════════
			function sec:AddColorPicker(cfg3)
				cfg3 = cfg3 or {}
				local label    = cfg3.Name     or "Color"
				local saveId   = cfg3.SaveId   or ("color_" .. label)
				local default  = cfg3.Default  or Color3.fromRGB(160, 100, 255)
				local callback = cfg3.Callback or function() end

				-- Restaurar cor salva
				local savedC = getSaved(saveId, nil)
				local color  = default
				if savedC and type(savedC) == "table" then
					pcall(function()
						color = Color3.fromRGB(savedC.r or 160, savedC.g or 100, savedC.b or 255)
					end)
				end

				local PICKER_H = 98
				local wrapper, row = newExpandWrapper(ELEM_H)

				local nameLbl = ni("TextLabel", {
					Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 10, 0, 0),
					BackgroundTransparency = 1, Text = label,
					TextColor3 = T.text, TextSize = 10, Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
				}, row)

				local preview = ni("Frame", {
					Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -28, 0.5, -11),
					BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 6,
				}, row)
				uiCorner(preview, 5)
				uiStroke(preview, T.border, 1)

				local picker = ni("Frame", {
					Size = UDim2.new(1, 0, 0, PICKER_H),
					Position = UDim2.new(0, 0, 0, ELEM_H + 3),
					BackgroundColor3 = T.card,
					BorderSizePixel  = 0,
					Visible          = false,
					ZIndex           = 25,
				}, wrapper)
				uiCorner(picker, 9)
				uiStroke(picker, T.border, 0.8)
				addNoiseTex(picker, 0.86, 26)

				-- Hue bar
				local huebar = ni("Frame", {
					Size = UDim2.new(1, -14, 0, 14), Position = UDim2.new(0, 7, 0, 8),
					BackgroundColor3 = T.white, BorderSizePixel = 0, ZIndex = 27,
				}, picker)
				uiCorner(huebar, 7)
				local hueGrad = Instance.new("UIGradient")
				hueGrad.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0,     Color3.fromRGB(255, 0,   0)),
					ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
					ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0,   255, 0)),
					ColorSequenceKeypoint.new(0.5,   Color3.fromRGB(0,   255, 255)),
					ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0,   0,   255)),
					ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0,   255)),
					ColorSequenceKeypoint.new(1,     Color3.fromRGB(255, 0,   0)),
				})
				hueGrad.Parent = huebar

				-- Sat/Brightness bar
				local satFrame = ni("Frame", {
					Size = UDim2.new(1, -14, 0, 56), Position = UDim2.new(0, 7, 0, 28),
					BackgroundColor3 = T.white, BorderSizePixel = 0, ZIndex = 27,
				}, picker)
				uiCorner(satFrame, 5)

				local hH, sV, bV = Color3.toHSV(color)

				local satGrad = Instance.new("UIGradient")
				satGrad.Color  = ColorSequence.new(T.white, Color3.fromHSV(hH, 1, 1))
				satGrad.Parent = satFrame

				local briGrad = Instance.new("UIGradient")
				briGrad.Color       = ColorSequence.new(Color3.new(1,1,1), Color3.new(0,0,0))
				briGrad.Rotation    = 90
				briGrad.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1 - bV),
					NumberSequenceKeypoint.new(1, 1),
				})
				briGrad.Parent = satFrame

				local function updateColor()
					color = Color3.fromHSV(hH, sV, bV)
					preview.BackgroundColor3 = color
					satGrad.Color = ColorSequence.new(T.white, Color3.fromHSV(hH, 1, 1))
					setSaved(saveId, {
						r = math.floor(color.R * 255),
						g = math.floor(color.G * 255),
						b = math.floor(color.B * 255),
					})
					callback(color)
				end

				local hueDrag, satDrag = false, false

				local hueBtn = ni("TextButton", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 28,
				}, huebar)
				hueBtn.MouseButton1Down:Connect(function(x)
					hueDrag = true
					hH = math.clamp((x - huebar.AbsolutePosition.X) / huebar.AbsoluteSize.X, 0, 1)
					updateColor()
				end)
				hueBtn.MouseButton1Up:Connect(function() hueDrag = false end)

				local satBtn = ni("TextButton", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 28,
				}, satFrame)
				satBtn.MouseButton1Down:Connect(function(x)
					satDrag = true
					sV = math.clamp((x - satFrame.AbsolutePosition.X) / satFrame.AbsoluteSize.X, 0, 1)
					updateColor()
				end)
				satBtn.MouseButton1Up:Connect(function() satDrag = false end)

				UserInputService.InputChanged:Connect(function(i)
					if i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
					if hueDrag then
						hH = math.clamp((i.Position.X - huebar.AbsolutePosition.X) / huebar.AbsoluteSize.X, 0, 1)
						updateColor()
					end
					if satDrag then
						sV = math.clamp((i.Position.X - satFrame.AbsolutePosition.X) / satFrame.AbsoluteSize.X, 0, 1)
						updateColor()
					end
				end)
				UserInputService.InputEnded:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then
						hueDrag = false
						satDrag = false
					end
				end)

				local open = false
				local openBtn = ni("TextButton", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 10,
				}, row)
				openBtn.MouseButton1Click:Connect(function()
					open = not open
					tween(row, { BackgroundColor3 = T.elemPress }, 0.08)
					task.delay(0.12, function() tween(row, { BackgroundColor3 = T.elem }, 0.15) end)
					picker.Visible = open
					wrapper.Size = open and UDim2.new(1, 0, 0, ELEM_H + PICKER_H + 5) or UDim2.new(1, 0, 0, ELEM_H)
				end)
				attachHoverAnim(openBtn, row)

				updateColor()
				task.defer(function() callback(color) end)

				local el = { Value = color }
				function el:Set(c)
					color = c
					el.Value = c
					preview.BackgroundColor3 = c
					hH, sV, bV = Color3.toHSV(c)
					updateColor()
				end
				function el:SetTitle(t) nameLbl.Text = t end
				function el:OnChanged(fn)
					local old = callback
					callback = function(val) old(val) fn(val) end
					fn(color)
				end
				return el
			end

			return sec
		end

		return tab
	end

	return win
end

return Lib
