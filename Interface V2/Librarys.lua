--[[
	EcoHub V2 - Interface Library
	Estilo: sidebar de tabs à esquerda, section à direita
	Tema escuro com accent azul (96,205,255), elementos limpos
	Auto-save em ecohubv2/config.json
]]

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ─── Save ────────────────────────────────────────────────────────────────────
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
	star             = "rbxassetid://10734966248",
	crown            = "rbxassetid://10709818626",
	trophy           = "rbxassetid://10747363809",
	medal            = "rbxassetid://10734887072",
	ghost            = "rbxassetid://10723396107",
	["alert-triangle"] = "rbxassetid://10709753149",
	info             = "rbxassetid://10723415903",
	bell             = "rbxassetid://10709775704",
	config           = "rbxassetid://10734950309",
	settings         = "rbxassetid://10734950309",
	["settings-2"]   = "rbxassetid://10734950020",
	cog              = "rbxassetid://10709810948",
	sliders          = "rbxassetid://10734963400",
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
	bg             = Color3.fromRGB(30,  30,  30),
	sidebar        = Color3.fromRGB(35,  35,  35),
	topbar         = Color3.fromRGB(40,  40,  40),
	content        = Color3.fromRGB(40,  40,  40),
	elem           = Color3.fromRGB(50,  50,  50),
	elemHover      = Color3.fromRGB(57,  57,  57),
	elemPress      = Color3.fromRGB(44,  44,  44),
	tabBg          = Color3.fromRGB(40,  40,  40),
	tabActiveBg    = Color3.fromRGB(50,  50,  50),
	tab            = Color3.fromRGB(120, 120, 120),
	tabActive      = Color3.fromRGB(240, 240, 240),
	divider        = Color3.fromRGB(55,  55,  55),
	titleLine      = Color3.fromRGB(75,  75,  75),
	innerBorder    = Color3.fromRGB(90,  90,  90),
	elemBorder     = Color3.fromRGB(35,  35,  35),
	accent         = Color3.fromRGB(96,  205, 255),
	accentDark     = Color3.fromRGB(50,  120, 160),
	text           = Color3.fromRGB(240, 240, 240),
	subText        = Color3.fromRGB(170, 170, 170),
	muted          = Color3.fromRGB(120, 120, 120),
	toggleOff      = Color3.fromRGB(120, 120, 120),
	sliderRail     = Color3.fromRGB(120, 120, 120),
	dropdownBg     = Color3.fromRGB(45,  45,  45),
	dropdownOption = Color3.fromRGB(120, 120, 120),
	dropdownBorder = Color3.fromRGB(35,  35,  35),
	keybind        = Color3.fromRGB(120, 120, 120),
	white          = Color3.fromRGB(255, 255, 255),
}

-- ─── Layout ──────────────────────────────────────────────────────────────────
local W         = 560
local H         = 340
local TOPBAR_H  = 54
local SIDEBAR_W = 148
local ELEM_H    = 30
local ELEM_PAD  = 4
local CORNER    = 6

-- ─── Helpers de instância ────────────────────────────────────────────────────
local function ni(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do pcall(function() o[k] = v end) end
	if parent then o.Parent = parent end
	return o
end

local function uiCorner(p, r)
	return ni("UICorner", { CornerRadius = UDim.new(0, r or CORNER) }, p)
end

local function uiStroke(p, c, t)
	return ni("UIStroke", { Color = c or T.elemBorder, Thickness = t or 1 }, p)
end

local function tween(obj, props, dur, style, dir)
	TweenService:Create(obj,
		TweenInfo.new(dur or 0.18, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
		props):Play()
end

local function resolveIcon(id)
	if not id or id == "" then return "" end
	if type(id) == "string" and not id:match("rbxasset") then return ICONS[id] or id end
	return id
end

-- Hover + click suave em qualquer row
local function attachRowAnim(row, btn)
	btn.MouseEnter:Connect(function()
		tween(row, { BackgroundColor3 = T.elemHover }, 0.1)
	end)
	btn.MouseLeave:Connect(function()
		tween(row, { BackgroundColor3 = T.elem }, 0.12)
	end)
	btn.MouseButton1Down:Connect(function()
		tween(row, { BackgroundColor3 = T.elemPress }, 0.06)
	end)
	btn.MouseButton1Up:Connect(function()
		tween(row, { BackgroundColor3 = T.elemHover }, 0.1)
	end)
end

-- ─── Lib ─────────────────────────────────────────────────────────────────────
local Lib   = {}
Lib.Icons   = ICONS
Lib.Theme   = T

function Lib.new(config)
	config = config or {}

	if PlayerGui:FindFirstChild("EcoHub_V2") then
		PlayerGui.EcoHub_V2:Destroy()
	end

	-- ScreenGui
	local Screen = ni("ScreenGui", {
		Name = "EcoHub_V2", ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, PlayerGui)

	-- Janela
	local Main = ni("Frame", {
		Size = UDim2.new(0, W, 0, H),
		Position = UDim2.new(0.5, -W/2, 0.5, -H/2),
		BackgroundColor3 = T.bg,
		BorderSizePixel = 0,
		Active = true, Draggable = true,
		ClipsDescendants = true,
	}, Screen)
	uiCorner(Main, 10)
	uiStroke(Main, T.titleLine, 1)

	-- TopBar
	local TopBar = ni("Frame", {
		Size = UDim2.new(1, 0, 0, TOPBAR_H),
		BackgroundColor3 = T.topbar,
		BorderSizePixel = 0, ZIndex = 3,
	}, Main)
	ni("Frame", {
		Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
		BackgroundColor3 = T.titleLine, BorderSizePixel = 0, ZIndex = 4,
	}, TopBar)

	-- Logo GRANDE sem fundo
	local LOGO_SZ = 46
	local LogoImg = ni("ImageLabel", {
		Size = UDim2.new(0, LOGO_SZ, 0, LOGO_SZ),
		Position = UDim2.new(0, 10, 0.5, -LOGO_SZ/2),
		BackgroundTransparency = 1,
		Image = config.Logo or "",
		ScaleType = Enum.ScaleType.Fit,
		ZIndex = 5,
	}, TopBar)

	local TitleLabel = ni("TextLabel", {
		Size = UDim2.new(0, 200, 0, 20),
		Position = UDim2.new(0, LOGO_SZ + 18, 0.5, -18),
		BackgroundTransparency = 1,
		Text = config.Title or "Hub Name",
		TextColor3 = T.text, TextSize = 15, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
	}, TopBar)

	local GameLabel = ni("TextLabel", {
		Size = UDim2.new(0, 200, 0, 14),
		Position = UDim2.new(0, LOGO_SZ + 18, 0.5, 3),
		BackgroundTransparency = 1,
		Text = config.GameName or "Game Name",
		TextColor3 = T.subText, TextSize = 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
	}, TopBar)

	-- Corpo
	local Body = ni("Frame", {
		Size = UDim2.new(1, 0, 1, -TOPBAR_H),
		Position = UDim2.new(0, 0, 0, TOPBAR_H),
		BackgroundTransparency = 1, BorderSizePixel = 0,
	}, Main)

	-- Sidebar
	local Sidebar = ni("Frame", {
		Size = UDim2.new(0, SIDEBAR_W, 1, 0),
		BackgroundColor3 = T.sidebar, BorderSizePixel = 0, ZIndex = 2,
	}, Body)
	ni("Frame", {
		Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0),
		BackgroundColor3 = T.titleLine, BorderSizePixel = 0, ZIndex = 3,
	}, Sidebar)

	local TabListFrame = ni("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1, ZIndex = 3,
	}, Sidebar)
	ni("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 2),
		FillDirection = Enum.FillDirection.Vertical,
	}, TabListFrame)
	ni("UIPadding", {
		PaddingTop = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 6),
		PaddingRight = UDim.new(0, 6),
	}, TabListFrame)

	-- Área de conteúdo
	local ContentArea = ni("Frame", {
		Size = UDim2.new(1, -SIDEBAR_W, 1, 0),
		Position = UDim2.new(0, SIDEBAR_W, 0, 0),
		BackgroundColor3 = T.content, BorderSizePixel = 0,
	}, Body)

	-- Estado das tabs
	local tabList  = {}
	local tabBtns  = {}
	local pages    = {}
	local curTab   = nil
	local animating = false

	local function switchTab(name)
		if curTab == name then return end
		if curTab and pages[curTab] then pages[curTab].Visible = false end
		curTab = name
		pages[name].Visible = true
		for _, tb in ipairs(tabBtns) do
			local active = tb.name == name
			tween(tb.row, { BackgroundColor3 = active and T.tabActiveBg or T.tabBg }, 0.15)
			tween(tb.lbl, { TextColor3 = active and T.tabActive or T.tab },            0.15)
			if tb.img then
				tween(tb.img, { ImageColor3 = active and T.accent or T.muted }, 0.15)
			end
			tb.bar.Visible = active
		end
	end

	-- Show/Hide
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
		tween(Main, { BackgroundTransparency = 0 }, 0.22, Enum.EasingStyle.Quart)
		task.delay(0.08, function() setAllVisible(true) end)
		task.delay(0.25, function() animating = false end)
	end

	local function hideGui()
		if animating then return end
		animating = true
		setAllVisible(false)
		tween(Main, { BackgroundTransparency = 1 }, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		task.delay(0.22, function() Main.Visible = false animating = false end)
	end

	local guiVisible = true
	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		local toggle = config.Toggle or Enum.KeyCode.LeftAlt
		if input.KeyCode == toggle or input.KeyCode == Enum.KeyCode.RightAlt then
			guiVisible = not guiVisible
			if guiVisible then showGui() else hideGui() end
		end
	end)

	-- ── API da janela ──────────────────────────────────────────────────────────
	local win = {}

	function win:SetTitle(t)    TitleLabel.Text = t end
	function win:SetGameName(t) GameLabel.Text  = t end
	function win:SetLogo(id)    LogoImg.Image   = id end

	function win:AddTab(cfg)
		cfg = cfg or {}
		local name   = cfg.Name or ("Tab" .. #tabList + 1)
		local iconId = resolveIcon(cfg.Icon) or ""

		-- Página de scroll
		local page = ni("ScrollingFrame", {
			Name = name, Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1, BorderSizePixel = 0,
			ScrollBarThickness = 3, ScrollBarImageColor3 = T.accent,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Visible = false, ZIndex = 2,
		}, ContentArea)
		ni("UIPadding", {
			PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
			PaddingTop  = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
		}, page)
		local pageLayout = ni("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding   = UDim.new(0, 5),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
		}, page)
		pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
		end)
		pages[name] = page
		table.insert(tabList, { name = name })

		-- Botão de tab na sidebar
		local idx    = #tabList
		local tabRow = ni("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = T.tabBg, BorderSizePixel = 0,
			LayoutOrder = idx, ZIndex = 4,
		}, TabListFrame)
		uiCorner(tabRow, 6)

		-- Barra accent lateral (só na tab ativa)
		local accentBar = ni("Frame", {
			Size = UDim2.new(0, 3, 0, 18), Position = UDim2.new(0, 0, 0.5, -9),
			BackgroundColor3 = T.accent, BorderSizePixel = 0,
			Visible = false, ZIndex = 5,
		}, tabRow)
		uiCorner(accentBar, 2)

		local labelX = 12
		local iconImg
		if iconId ~= "" then
			iconImg = ni("ImageLabel", {
				Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 12, 0.5, -8),
				BackgroundTransparency = 1, Image = iconId, ImageColor3 = T.muted, ZIndex = 5,
			}, tabRow)
			labelX = 34
		end

		local tabLbl = ni("TextLabel", {
			Size = UDim2.new(1, -labelX - 6, 1, 0), Position = UDim2.new(0, labelX, 0, 0),
			BackgroundTransparency = 1, Text = name,
			TextColor3 = T.tab, TextSize = 12, Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
		}, tabRow)

		local tabBtn = ni("TextButton", {
			Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
			Text = "", BorderSizePixel = 0, ZIndex = 8,
		}, tabRow)
		tabBtn.MouseButton1Click:Connect(function()
			tween(tabRow, { BackgroundColor3 = T.elemPress }, 0.06)
			task.delay(0.1, function() tween(tabRow, { BackgroundColor3 = T.tabActiveBg }, 0.12) end)
			switchTab(name)
		end)
		tabBtn.MouseEnter:Connect(function()
			if curTab ~= name then tween(tabRow, { BackgroundColor3 = T.elemHover }, 0.1) end
		end)
		tabBtn.MouseLeave:Connect(function()
			if curTab ~= name then tween(tabRow, { BackgroundColor3 = T.tabBg }, 0.12) end
		end)

		table.insert(tabBtns, { name = name, row = tabRow, lbl = tabLbl, img = iconImg, bar = accentBar })
		if #tabList == 1 then switchTab(name) end

		-- ── Objeto de tab ─────────────────────────────────────────────────────
		local tab          = { Page = page }
		local sectionCount = 0

		function tab:AddSection(cfg2)
			cfg2 = cfg2 or {}
			local title   = cfg2.Title or ""
			local iconId2 = resolveIcon(cfg2.Icon) or ""

			sectionCount = sectionCount + 1

			local secFrame = ni("Frame", {
				Name = "Sec_" .. sectionCount,
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1, BorderSizePixel = 0,
				LayoutOrder = sectionCount, AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 2,
			}, page)
			ni("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding   = UDim.new(0, ELEM_PAD),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}, secFrame)

			-- Cabeçalho
			if title ~= "" then
				local hdr = ni("Frame", {
					Size = UDim2.new(1, 0, 0, 24),
					BackgroundTransparency = 1, BorderSizePixel = 0,
					LayoutOrder = 0, ZIndex = 3,
				}, secFrame)
				local txtX = 0
				if iconId2 ~= "" then
					ni("ImageLabel", {
						Size = UDim2.new(0, 13, 0, 13), Position = UDim2.new(0, 0, 0.5, -6.5),
						BackgroundTransparency = 1, Image = iconId2,
						ImageColor3 = T.subText, ZIndex = 4,
					}, hdr)
					txtX = 18
				end
				ni("TextLabel", {
					Size = UDim2.new(1, -txtX, 1, 0), Position = UDim2.new(0, txtX, 0, 0),
					BackgroundTransparency = 1, Text = title,
					TextColor3 = T.subText, TextSize = 11, Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4,
				}, hdr)
			end

			-- ── Helpers de row ─────────────────────────────────────────────────
			local rowCount = 0

			local function newRow(h)
				rowCount = rowCount + 1
				local r = ni("Frame", {
					Size = UDim2.new(1, 0, 0, h),
					BackgroundColor3 = T.elem,
					BorderSizePixel = 0,
					LayoutOrder = rowCount + 1,
					ClipsDescendants = true, ZIndex = 3,
				}, secFrame)
				uiCorner(r, CORNER)
				return r
			end

			local function newWrapper(h)
				rowCount = rowCount + 1
				local w = ni("Frame", {
					Size = UDim2.new(1, 0, 0, h),
					BackgroundTransparency = 1, BorderSizePixel = 0,
					LayoutOrder = rowCount + 1, ClipsDescendants = false, ZIndex = 3,
				}, secFrame)
				local r = ni("Frame", {
					Size = UDim2.new(1, 0, 0, h),
					BackgroundColor3 = T.elem, BorderSizePixel = 0,
					ClipsDescendants = true, ZIndex = 3,
				}, w)
				uiCorner(r, CORNER)
				return w, r
			end

			local function mkLabel(parent, text, posX, color, size)
				return ni("TextLabel", {
					Size = UDim2.new(1, -(posX or 10) - 4, 1, 0),
					Position = UDim2.new(0, posX or 10, 0, 0),
					BackgroundTransparency = 1, Text = text,
					TextColor3 = color or T.text,
					TextSize = size or 12, Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
				}, parent)
			end

			local sec = { Frame = secFrame }

			-- ── Label ─────────────────────────────────────────────────────────
			function sec:AddLabel(cfg3)
				cfg3 = cfg3 or {}
				local row = newRow(ELEM_H)
				local lbl = mkLabel(row, cfg3.Text or "Label", 10, cfg3.Color or T.text)
				local el  = { Frame = row }
				function el:Set(t, c) lbl.Text = t if c then lbl.TextColor3 = c end end
				function el:SetTitle(t) lbl.Text = t end
				function el:SetColor(c) lbl.TextColor3 = c end
				return el
			end

			-- ── Paragraph ─────────────────────────────────────────────────────
			function sec:AddParagraph(cfg3)
				cfg3 = cfg3 or {}
				local title = cfg3.Title or ""
				local text  = cfg3.Text  or ""
				local rowH  = (title ~= "" and 18 or 0) + 16 + 8
				local row   = newRow(rowH)
				local titleLbl
				if title ~= "" then
					titleLbl = ni("TextLabel", {
						Size = UDim2.new(1, -10, 0, 16), Position = UDim2.new(0, 10, 0, 4),
						BackgroundTransparency = 1, Text = title,
						TextColor3 = T.text, TextSize = 12, Font = Enum.Font.GothamBold,
						TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
					}, row)
				end
				local contentLbl = ni("TextLabel", {
					Size = UDim2.new(1, -10, 0, 14),
					Position = UDim2.new(0, 10, 0, title ~= "" and 20 or 7),
					BackgroundTransparency = 1, Text = text,
					TextColor3 = T.subText, TextSize = 11, Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true, ZIndex = 5,
				}, row)
				local el = { Frame = row }
				function el:SetTitle(t) if titleLbl then titleLbl.Text = t end end
				function el:SetDescription(t) contentLbl.Text = t end
				function el:Set(t) contentLbl.Text = t end
				return el
			end

			-- ── Button ────────────────────────────────────────────────────────
			function sec:AddButton(cfg3)
				cfg3 = cfg3 or {}
				local label    = cfg3.Name     or "Button"
				local callback = cfg3.Callback or function() end
				local row      = newRow(ELEM_H)
				local nameLbl  = mkLabel(row, label)
				ni("ImageLabel", {
					Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -22, 0.5, -8),
					BackgroundTransparency = 1, Image = ICONS.grid or "",
					ImageColor3 = T.muted, ZIndex = 5,
				}, row)
				local btn = ni("TextButton", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 8,
				}, row)
				btn.MouseButton1Click:Connect(function() callback() end)
				attachRowAnim(row, btn)
				local el = { Frame = row }
				function el:SetTitle(t) nameLbl.Text = t end
				return el
			end

			-- ── Slider ────────────────────────────────────────────────────────
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

				local function roundV(v) return math.floor(v / rounding + 0.5) * rounding end

				local ROW_H = ELEM_H + 14
				local row   = newRow(ROW_H)

				local nameLbl = ni("TextLabel", {
					Size = UDim2.new(1, -50, 0, 14), Position = UDim2.new(0, 10, 0, 6),
					BackgroundTransparency = 1, Text = label,
					TextColor3 = T.text, TextSize = 12, Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
				}, row)
				local valLbl = ni("TextLabel", {
					Size = UDim2.new(0, 40, 0, 14), Position = UDim2.new(1, -44, 0, 6),
					BackgroundTransparency = 1,
					Text = tostring(roundV(value)) .. suffix,
					TextColor3 = T.subText, TextSize = 11, Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 5,
				}, row)

				local railBg = ni("Frame", {
					Size = UDim2.new(1, -20, 0, 4), Position = UDim2.new(0, 10, 0, 28),
					BackgroundColor3 = T.sliderRail, BorderSizePixel = 0, ZIndex = 5,
				}, row)
				uiCorner(railBg, 4)

				local pct  = (value - minV) / math.max(maxV - minV, 1)
				local fill = ni("Frame", {
					Size = UDim2.new(pct, 0, 1, 0),
					BackgroundColor3 = T.accent, BorderSizePixel = 0, ZIndex = 6,
				}, railBg)
				uiCorner(fill, 4)

				local dot = ni("Frame", {
					Size = UDim2.new(0, 12, 0, 12), AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(pct, 0, 0.5, 0),
					BackgroundColor3 = T.white, BorderSizePixel = 0, ZIndex = 7,
				}, railBg)
				uiCorner(dot, 12)

				local function setVal(v, animate)
					value = roundV(math.clamp(v, minV, maxV))
					local p = (value - minV) / math.max(maxV - minV, 1)
					tween(fill, { Size = UDim2.new(p, 0, 1, 0) },       animate and 0.08 or 0)
					tween(dot,  { Position = UDim2.new(p, 0, 0.5, 0) }, animate and 0.08 or 0)
					valLbl.Text = tostring(value) .. suffix
					setSaved(saveId, value)
					callback(value)
				end

				local dragging = false
				local function onDrag(absX)
					local rel = math.clamp((absX - railBg.AbsolutePosition.X) / railBg.AbsoluteSize.X, 0, 1)
					setVal(minV + rel * (maxV - minV), false)
				end

				local hit = ni("TextButton", {
					Size = UDim2.new(1, 0, 0, ROW_H), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 9,
				}, row)
				hit.MouseButton1Down:Connect(function(x)
					dragging = true
					tween(dot, { Size = UDim2.new(0, 14, 0, 14) }, 0.07)
					onDrag(x)
				end)
				hit.MouseButton1Up:Connect(function()
					dragging = false
					tween(dot, { Size = UDim2.new(0, 12, 0, 12) }, 0.07)
				end)
				UserInputService.InputChanged:Connect(function(i)
					if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then onDrag(i.Position.X) end
				end)
				UserInputService.InputEnded:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
						tween(dot, { Size = UDim2.new(0, 12, 0, 12) }, 0.07)
					end
				end)
				attachRowAnim(row, hit)
				setVal(value, false)
				task.defer(function() callback(value) end)

				local el = { Value = value }
				function el:Set(v) setVal(v, true) el.Value = value end
				function el:SetTitle(t) nameLbl.Text = t end
				function el:SetDescription(t) end
				function el:OnChanged(fn)
					local old = callback
					callback = function(val) old(val) fn(val) end
					fn(value)
				end
				return el
			end

			-- ── Keybind ───────────────────────────────────────────────────────
			function sec:AddKeybind(cfg3)
				cfg3 = cfg3 or {}
				local label    = cfg3.Name     or "Keybind"
				local saveId   = cfg3.SaveId   or ("keybind_" .. label)
				local default  = cfg3.Default  or Enum.KeyCode.Unknown
				local callback = cfg3.Callback or function() end

				local savedName = getSaved(saveId, nil)
				local key = default
				if savedName then pcall(function() key = Enum.KeyCode[savedName] end) end
				local listening = false

				local row     = newRow(ELEM_H)
				local nameLbl = mkLabel(row, label)

				local kBox = ni("Frame", {
					Size = UDim2.new(0, 30, 0, 20), Position = UDim2.new(1, -36, 0.5, -10),
					BackgroundColor3 = T.keybind, BorderSizePixel = 0, ZIndex = 5,
				}, row)
				uiCorner(kBox, 4)

				local kLbl = ni("TextLabel", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
					Text = type(key) == "userdata" and key.Name or tostring(key),
					TextColor3 = T.bg, TextSize = 10, Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 6,
				}, kBox)

				local btn = ni("TextButton", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 9,
				}, row)
				btn.MouseButton1Click:Connect(function()
					listening = true
					kLbl.Text = "..."
					tween(kBox, { BackgroundColor3 = T.accent }, 0.1)
				end)
				UserInputService.InputBegan:Connect(function(input, processed)
					if not listening then return end
					if input.UserInputType == Enum.UserInputType.Keyboard then
						listening = false
						key = input.KeyCode
						kLbl.Text = key.Name
						tween(kBox, { BackgroundColor3 = T.keybind }, 0.12)
						setSaved(saveId, key.Name)
						callback(key)
					end
				end)
				attachRowAnim(row, btn)

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

			-- ── Toggle ────────────────────────────────────────────────────────
			function sec:AddToggle(cfg3)
				cfg3 = cfg3 or {}
				local label    = cfg3.Name     or "Toggle"
				local saveId   = cfg3.SaveId   or ("toggle_" .. label)
				local default  = cfg3.Default  or false
				local callback = cfg3.Callback or function() end
				local state    = getSaved(saveId, not not default)

				local row     = newRow(ELEM_H)
				local nameLbl = mkLabel(row, label)

				local TRK_W, TRK_H = 34, 18
				local track = ni("Frame", {
					Size = UDim2.new(0, TRK_W, 0, TRK_H),
					Position = UDim2.new(1, -TRK_W - 8, 0.5, -TRK_H/2),
					BackgroundColor3 = state and T.accent or T.toggleOff,
					BorderSizePixel = 0, ZIndex = 5,
				}, row)
				uiCorner(track, TRK_H)

				local KNOB = 13
				local knob = ni("Frame", {
					Size = UDim2.new(0, KNOB, 0, KNOB),
					Position = state and UDim2.new(1, -KNOB-2, 0.5, -KNOB/2) or UDim2.new(0, 2, 0.5, -KNOB/2),
					BackgroundColor3 = T.white, BorderSizePixel = 0, ZIndex = 6,
				}, track)
				uiCorner(knob, KNOB)

				local function applyState(v, animate)
					local dur = animate and 0.18 or 0
					tween(track, { BackgroundColor3 = v and T.accent or T.toggleOff }, dur)
					tween(knob,  { Position = v and UDim2.new(1, -KNOB-2, 0.5, -KNOB/2) or UDim2.new(0, 2, 0.5, -KNOB/2) }, dur)
				end

				local btn = ni("TextButton", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 9,
				}, row)
				btn.MouseButton1Click:Connect(function()
					state = not state
					applyState(state, true)
					setSaved(saveId, state)
					callback(state)
				end)
				attachRowAnim(row, btn)
				applyState(state, false)
				task.defer(function() callback(state) end)

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

			-- ── Dropdown ──────────────────────────────────────────────────────
			function sec:AddDropdown(cfg3)
				cfg3 = cfg3 or {}
				local label    = cfg3.Name     or "Dropdown"
				local saveId   = cfg3.SaveId   or ("dropdown_" .. label)
				local options  = cfg3.Options  or {}
				local default  = cfg3.Default  or (options[1] or "")
				local callback = cfg3.Callback or function() end
				local selected = getSaved(saveId, default)
				local open     = false

				local OPT_H     = 26
				local totalOptH = #options * OPT_H
				local wrapper, row = newWrapper(ELEM_H)

				local nameLbl = ni("TextLabel", {
					Size = UDim2.new(1, -95, 1, 0), Position = UDim2.new(0, 10, 0, 0),
					BackgroundTransparency = 1, Text = label,
					TextColor3 = T.text, TextSize = 12, Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
				}, row)

				local selLbl = ni("TextLabel", {
					Size = UDim2.new(0, 60, 1, 0), Position = UDim2.new(1, -76, 0, 0),
					BackgroundTransparency = 1, Text = selected,
					TextColor3 = T.subText, TextSize = 11, Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Right,
					TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5,
				}, row)

				local arrowLbl = ni("TextLabel", {
					Size = UDim2.new(0, 16, 1, 0), Position = UDim2.new(1, -16, 0, 0),
					BackgroundTransparency = 1, Text = "∧",
					TextColor3 = T.muted, TextSize = 10, Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 5,
				}, row)

				-- Painel dropdown (ZIndex alto, sem ClipDescendants no wrapper)
				local dropPanel = ni("Frame", {
					Size = UDim2.new(1, 0, 0, 0),
					Position = UDim2.new(0, 0, 0, ELEM_H + 3),
					BackgroundColor3 = T.dropdownBg,
					BorderSizePixel = 0, ClipsDescendants = true,
					Visible = false, ZIndex = 25,
				}, wrapper)
				uiCorner(dropPanel, 6)
				uiStroke(dropPanel, T.dropdownBorder, 1)

				local optList = ni("Frame", {
					Size = UDim2.new(1, 0, 0, totalOptH),
					BackgroundTransparency = 1, ZIndex = 26,
				}, dropPanel)
				ni("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, optList)

				local optionBtns = {}
				local function buildOptions()
					for _, ch in ipairs(optList:GetChildren()) do
						if not ch:IsA("UIListLayout") then ch:Destroy() end
					end
					optionBtns = {}
					for i2, opt in ipairs(options) do
						local isSel = opt == selected
						local optBtn = ni("TextButton", {
							Size = UDim2.new(1, 0, 0, OPT_H),
							BackgroundColor3 = T.dropdownBg,
							BorderSizePixel = 0, Text = "",
							ZIndex = 27, LayoutOrder = i2,
						}, optList)
						local optLbl = ni("TextLabel", {
							Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0),
							BackgroundTransparency = 1, Text = opt,
							TextColor3 = isSel and T.accent or T.dropdownOption,
							TextSize = 11, Font = Enum.Font.Gotham,
							TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 28,
						}, optBtn)
						optBtn.MouseButton1Click:Connect(function()
							selected = opt
							selLbl.Text = opt
							for _, ob in ipairs(optionBtns) do
								local s = ob.lbl.Text == opt
								tween(ob.lbl, { TextColor3 = s and T.accent or T.dropdownOption }, 0.1)
								tween(ob.btn, { BackgroundColor3 = T.dropdownBg }, 0.1)
							end
							open = false
							arrowLbl.Text = "∧"
							tween(dropPanel, { Size = UDim2.new(1, 0, 0, 0) }, 0.16)
							task.delay(0.18, function()
								dropPanel.Visible = false
								wrapper.Size = UDim2.new(1, 0, 0, ELEM_H)
							end)
							setSaved(saveId, selected)
							callback(selected)
						end)
						optBtn.MouseEnter:Connect(function()
							if opt ~= selected then tween(optBtn, { BackgroundColor3 = T.elemHover }, 0.08) end
						end)
						optBtn.MouseLeave:Connect(function()
							tween(optBtn, { BackgroundColor3 = T.dropdownBg }, 0.1)
						end)
						table.insert(optionBtns, { btn = optBtn, lbl = optLbl })
					end
					totalOptH = #options * OPT_H
					optList.Size = UDim2.new(1, 0, 0, totalOptH)
				end
				buildOptions()

				local toggleBtn = ni("TextButton", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 9,
				}, row)
				toggleBtn.MouseButton1Click:Connect(function()
					open = not open
					arrowLbl.Text = open and "∨" or "∧"
					if open then
						dropPanel.Visible = true
						dropPanel.Size    = UDim2.new(1, 0, 0, 0)
						wrapper.Size      = UDim2.new(1, 0, 0, ELEM_H + totalOptH + 4)
						tween(dropPanel, { Size = UDim2.new(1, 0, 0, totalOptH) }, 0.2)
					else
						tween(dropPanel, { Size = UDim2.new(1, 0, 0, 0) }, 0.16)
						task.delay(0.18, function()
							dropPanel.Visible = false
							wrapper.Size = UDim2.new(1, 0, 0, ELEM_H)
						end)
					end
				end)
				attachRowAnim(row, toggleBtn)
				task.defer(function() callback(selected) end)

				local el = { Value = selected }
				function el:Set(v) selected = v selLbl.Text = v el.Value = v setSaved(saveId, v) callback(v) end
				function el:SetTitle(t) nameLbl.Text = t end
				function el:SetOptions(newOpts) options = newOpts buildOptions() end
				function el:OnChanged(fn)
					local old = callback
					callback = function(val) old(val) fn(val) end
					fn(selected)
				end
				return el
			end

			-- ── ColorPicker ───────────────────────────────────────────────────
			function sec:AddColorPicker(cfg3)
				cfg3 = cfg3 or {}
				local label    = cfg3.Name     or "Color"
				local saveId   = cfg3.SaveId   or ("color_" .. label)
				local default  = cfg3.Default  or Color3.fromRGB(96, 205, 255)
				local callback = cfg3.Callback or function() end

				local savedC = getSaved(saveId, nil)
				local color  = default
				if savedC and type(savedC) == "table" then
					pcall(function() color = Color3.fromRGB(savedC.r or 96, savedC.g or 205, savedC.b or 255) end)
				end

				local PICKER_H = 90
				local wrapper, row = newWrapper(ELEM_H)

				local nameLbl = ni("TextLabel", {
					Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 10, 0, 0),
					BackgroundTransparency = 1, Text = label,
					TextColor3 = T.text, TextSize = 12, Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
				}, row)

				local preview = ni("Frame", {
					Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -26, 0.5, -10),
					BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 5,
				}, row)
				uiCorner(preview, 4)
				uiStroke(preview, T.innerBorder, 1)

				local picker = ni("Frame", {
					Size = UDim2.new(1, 0, 0, PICKER_H),
					Position = UDim2.new(0, 0, 0, ELEM_H + 3),
					BackgroundColor3 = T.dropdownBg, BorderSizePixel = 0,
					Visible = false, ZIndex = 25,
				}, wrapper)
				uiCorner(picker, 6)
				uiStroke(picker, T.dropdownBorder, 1)

				local huebar = ni("Frame", {
					Size = UDim2.new(1, -14, 0, 14), Position = UDim2.new(0, 7, 0, 7),
					BackgroundColor3 = T.white, BorderSizePixel = 0, ZIndex = 26,
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

				local satFrame = ni("Frame", {
					Size = UDim2.new(1, -14, 0, 52), Position = UDim2.new(0, 7, 0, 27),
					BackgroundColor3 = T.white, BorderSizePixel = 0, ZIndex = 26,
				}, picker)
				uiCorner(satFrame, 4)

				local hH, sV, bV = Color3.toHSV(color)
				local satGrad = Instance.new("UIGradient")
				satGrad.Color  = ColorSequence.new(T.white, Color3.fromHSV(hH, 1, 1))
				satGrad.Parent = satFrame

				local function updateColor()
					color = Color3.fromHSV(hH, sV, bV)
					preview.BackgroundColor3 = color
					satGrad.Color = ColorSequence.new(T.white, Color3.fromHSV(hH, 1, 1))
					setSaved(saveId, { r = math.floor(color.R*255), g = math.floor(color.G*255), b = math.floor(color.B*255) })
					callback(color)
				end

				local hueDrag, satDrag = false, false
				local hueBtn = ni("TextButton", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 27,
				}, huebar)
				hueBtn.MouseButton1Down:Connect(function(x)
					hueDrag = true
					hH = math.clamp((x - huebar.AbsolutePosition.X) / huebar.AbsoluteSize.X, 0, 1)
					updateColor()
				end)
				hueBtn.MouseButton1Up:Connect(function() hueDrag = false end)

				local satBtn = ni("TextButton", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 27,
				}, satFrame)
				satBtn.MouseButton1Down:Connect(function(x)
					satDrag = true
					sV = math.clamp((x - satFrame.AbsolutePosition.X) / satFrame.AbsoluteSize.X, 0, 1)
					updateColor()
				end)
				satBtn.MouseButton1Up:Connect(function() satDrag = false end)

				UserInputService.InputChanged:Connect(function(i)
					if i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
					if hueDrag then hH = math.clamp((i.Position.X - huebar.AbsolutePosition.X) / huebar.AbsoluteSize.X, 0, 1) updateColor() end
					if satDrag then sV = math.clamp((i.Position.X - satFrame.AbsolutePosition.X) / satFrame.AbsoluteSize.X, 0, 1) updateColor() end
				end)
				UserInputService.InputEnded:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then hueDrag = false satDrag = false end
				end)

				local open = false
				local openBtn = ni("TextButton", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 9,
				}, row)
				openBtn.MouseButton1Click:Connect(function()
					open = not open
					picker.Visible = open
					wrapper.Size = open and UDim2.new(1, 0, 0, ELEM_H + PICKER_H + 4) or UDim2.new(1, 0, 0, ELEM_H)
				end)
				attachRowAnim(row, openBtn)
				updateColor()
				task.defer(function() callback(color) end)

				local el = { Value = color }
				function el:Set(c)
					color = c el.Value = c
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
