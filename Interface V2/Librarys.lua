local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

local AUTOLOAD_FILE = "ecohub_autoload.txt"
local SCRIPT_URL    = ""

local function writeFile(path, content)
	if writefile then
		pcall(writefile, path, content)
	elseif savefile then
		pcall(savefile, path, content)
	end
end

local function readFile(path)
	if isfile and isfile(path) then
		local ok, data = pcall(readfile, path)
		if ok then return data end
	end
	return nil
end

local function fileExists(path)
	if isfile then
		local ok, res = pcall(isfile, path)
		return ok and res
	end
	return false
end

local function deleteFile(path)
	if delfile then
		pcall(delfile, path)
	elseif removefile then
		pcall(removefile, path)
	end
end

local function getAutoLoad()
	local data = readFile(AUTOLOAD_FILE)
	return data == "true"
end

local function setAutoLoad(val)
	if val then
		writeFile(AUTOLOAD_FILE, "true")
	else
		deleteFile(AUTOLOAD_FILE)
	end
end

local ICONS = {
	aim     = "rbxassetid://10709818534",
	visuals = "rbxassetid://10723346959",
	vehicle = "rbxassetid://10709789810",
	players = "rbxassetid://10747373176",
	misc    = "rbxassetid://10723345749",
	config  = "rbxassetid://10734950309",
}

local Theme = {
	AcrylicMain     = Color3.fromRGB(30, 30, 30),
	TitleBarLine    = Color3.fromRGB(65, 65, 65),
	InElementBorder = Color3.fromRGB(55, 55, 55),
	bg              = Color3.fromRGB(20, 20, 20),
	pageArea        = Color3.fromRGB(22, 22, 22),
	card            = Color3.fromRGB(30, 30, 30),
	tabbar          = Color3.fromRGB(18, 18, 18),
	accentHi        = Color3.fromRGB(160, 100, 255),
	accentLo        = Color3.fromRGB(55, 20, 100),
	text            = Color3.fromRGB(235, 235, 235),
	muted           = Color3.fromRGB(130, 130, 130),
	dim             = Color3.fromRGB(70, 70, 70),
}

local W, H   = 780, 480
local TOPBAR = 62

local function ni(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do o[k] = v end
	if parent then o.Parent = parent end
	return o
end

local function corner(p, r)
	ni("UICorner", {CornerRadius = UDim.new(0, r or 8)}, p)
end

local function tw(obj, props, dur, style, dir)
	TweenService:Create(obj,
		TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
		props):Play()
end

local Lib = {}
Lib.Icons = ICONS

function Lib.new(config)
	config = config or {}

	if SCRIPT_URL == "" and config.ScriptUrl then
		SCRIPT_URL = config.ScriptUrl
	end

	if PlayerGui:FindFirstChild("MainGui") then
		PlayerGui.MainGui:Destroy()
	end

	local ScreenGui = ni("ScreenGui", {
		Name           = "MainGui",
		ResetOnSpawn   = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, PlayerGui)

	local Main = ni("Frame", {
		Size             = UDim2.new(0, W, 0, H),
		Position         = UDim2.new(0.5, -W/2, 0.5, -H/2),
		BackgroundColor3 = Theme.bg,
		BorderSizePixel  = 0,
		Active           = true,
		Draggable        = true,
		Visible          = true,
		ClipsDescendants = true,
	}, ScreenGui)
	corner(Main, 12)

	local TopBar = ni("Frame", {
		Size             = UDim2.new(1, 0, 0, TOPBAR),
		BackgroundColor3 = Theme.AcrylicMain,
		BorderSizePixel  = 0,
	}, Main)
	corner(TopBar, 12)
	ni("Frame", {
		Size             = UDim2.new(1, 0, 0, 12),
		Position         = UDim2.new(0, 0, 1, -12),
		BackgroundColor3 = Theme.AcrylicMain,
		BorderSizePixel  = 0,
	}, TopBar)
	ni("Frame", {
		Size             = UDim2.new(1, 0, 0, 1),
		Position         = UDim2.new(0, 0, 1, -1),
		BackgroundColor3 = Theme.TitleBarLine,
		BorderSizePixel  = 0,
	}, TopBar)

	ni("TextLabel", {
		Size                   = UDim2.new(0, 200, 1, 0),
		Position               = UDim2.new(0, 14, 0, 0),
		BackgroundTransparency = 1,
		Text                   = config.Title or "Painel",
		TextColor3             = Theme.text,
		TextSize               = 18,
		Font                   = Enum.Font.GothamBold,
		TextXAlignment         = Enum.TextXAlignment.Left,
	}, TopBar)

	local logoSize = 52
	ni("ImageLabel", {
		Size                   = UDim2.new(0, logoSize, 0, logoSize),
		Position               = UDim2.new(0.5, -logoSize/2, 0.5, -logoSize/2),
		BackgroundTransparency = 1,
		Image                  = config.Logo or "",
		ScaleType              = Enum.ScaleType.Fit,
		ZIndex                 = 2,
	}, TopBar)

	local blockW = 170
	local UserBlock = ni("Frame", {
		Size                   = UDim2.new(0, blockW, 0, TOPBAR),
		Position               = UDim2.new(1, -blockW, 0, 0),
		BackgroundTransparency = 1,
	}, TopBar)
	ni("Frame", {
		Size             = UDim2.new(0, 1, 0, 36),
		Position         = UDim2.new(0, 0, 0.5, -18),
		BackgroundColor3 = Theme.TitleBarLine,
		BorderSizePixel  = 0,
	}, UserBlock)

	local AvatarFrame = ni("Frame", {
		Size             = UDim2.new(0, 36, 0, 36),
		Position         = UDim2.new(0, 12, 0.5, -18),
		BackgroundColor3 = Theme.card,
		BorderSizePixel  = 0,
	}, UserBlock)
	corner(AvatarFrame, 8)
	ni("UIStroke", {Color = Theme.InElementBorder, Thickness = 1}, AvatarFrame)
	local av = ni("ImageLabel", {
		Size                   = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image                  = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=60&height=60&format=png",
		ScaleType              = Enum.ScaleType.Crop,
	}, AvatarFrame)
	corner(av, 8)

	ni("TextLabel", {
		Size                   = UDim2.new(1, -56, 0, 17),
		Position               = UDim2.new(0, 55, 0.5, -18),
		BackgroundTransparency = 1,
		Text                   = LocalPlayer.DisplayName,
		TextColor3             = Theme.text,
		TextSize               = 12,
		Font                   = Enum.Font.GothamBold,
		TextXAlignment         = Enum.TextXAlignment.Left,
		TextTruncate           = Enum.TextTruncate.AtEnd,
	}, UserBlock)
	ni("TextLabel", {
		Size                   = UDim2.new(1, -56, 0, 13),
		Position               = UDim2.new(0, 55, 0.5, 2),
		BackgroundTransparency = 1,
		Text                   = "@" .. LocalPlayer.Name,
		TextColor3             = Theme.muted,
		TextSize               = 9,
		Font                   = Enum.Font.Gotham,
		TextXAlignment         = Enum.TextXAlignment.Left,
		TextTruncate           = Enum.TextTruncate.AtEnd,
	}, UserBlock)

	local PageArea = ni("Frame", {
		Size             = UDim2.new(1, -16, 1, -TOPBAR - 60),
		Position         = UDim2.new(0, 8, 0, TOPBAR + 8),
		BackgroundColor3 = Theme.pageArea,
		BorderSizePixel  = 0,
		ClipsDescendants = true,
	}, Main)
	corner(PageArea, 10)

	local TABBAR_H = 52
	local TabBar = ni("Frame", {
		Size             = UDim2.new(1, 0, 0, TABBAR_H),
		Position         = UDim2.new(0, 0, 1, -TABBAR_H),
		BackgroundColor3 = Theme.tabbar,
		BorderSizePixel  = 0,
		ClipsDescendants = true,
	}, Main)
	corner(TabBar, 12)
	ni("Frame", {
		Size             = UDim2.new(1, 0, 0, 12),
		BackgroundColor3 = Theme.tabbar,
		BorderSizePixel  = 0,
	}, TabBar)
	ni("Frame", {
		Size             = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = Theme.TitleBarLine,
		BorderSizePixel  = 0,
	}, TabBar)

	local ICON_SIZE  = 18
	local SMALL_W    = 44
	local EXPANDED_W = 120
	local tabList    = {}
	local tabBtns    = {}
	local pages      = {}
	local curTab     = nil
	local animating  = false

	local function calcPositions(activeIdx)
		local total    = EXPANDED_W + (#tabList - 1) * SMALL_W
		local maxTotal = W - 20
		local expW     = EXPANDED_W
		if total > maxTotal then
			expW = math.max(SMALL_W + 20, maxTotal - (#tabList - 1) * SMALL_W)
		end
		local pos = {}
		local x = 0
		for i = 1, #tabList do
			local w = (i == activeIdx) and expW or SMALL_W
			pos[i] = {x = x, w = w}
			x = x + w
		end
		local realTotal = expW + (#tabList - 1) * SMALL_W
		local offset    = math.max(4, math.floor((W - realTotal) / 2))
		for i = 1, #tabList do pos[i].x = pos[i].x + offset end
		return pos, expW
	end

	local function switchTo(name)
		if curTab == name then return end
		if curTab and pages[curTab] then pages[curTab].Visible = false end
		curTab = name
		pages[name].Visible = true
		local activeIdx = 1
		for i, t in ipairs(tabList) do
			if t.name == name then activeIdx = i break end
		end
		local positions = calcPositions(activeIdx)
		for i, tb in ipairs(tabBtns) do
			local active = tabList[i].name == name
			local p = positions[i]
			tw(tb.bg, {Position = UDim2.new(0, p.x, 0, 0), Size = UDim2.new(0, p.w, 1, 0)}, 0.3)
			if active then
				tw(tb.sq,  {BackgroundColor3 = Theme.accentLo}, 0.25)
				tw(tb.str, {Color = Theme.accentHi, Thickness = 1.5}, 0.25)
				tw(tb.img, {ImageColor3 = Theme.accentHi}, 0.25)
				tw(tb.lbl, {TextColor3 = Theme.text,  TextTransparency = 0}, 0.25)
				tw(tb.sub, {TextColor3 = Theme.muted, TextTransparency = 0}, 0.25)
			else
				tw(tb.sq,  {BackgroundColor3 = Theme.card}, 0.25)
				tw(tb.str, {Color = Theme.InElementBorder, Thickness = 1}, 0.25)
				tw(tb.img, {ImageColor3 = Theme.dim}, 0.25)
				tw(tb.lbl, {TextTransparency = 1}, 0.18)
				tw(tb.sub, {TextTransparency = 1}, 0.18)
			end
		end
	end

	local centerP = UDim2.new(0.5, -W/2, 0.5, -H/2)
	local miniS   = UDim2.new(0, W * 0.45, 0, 38)
	local miniP   = UDim2.new(0.5, -(W * 0.45)/2, 1, -48)

	local function showGui()
		if animating then return end
		animating = true
		Main.Visible                = true
		Main.Size                   = miniS
		Main.Position               = miniP
		Main.BackgroundTransparency = 0.6
		tw(Main, {
			Size                   = UDim2.new(0, W, 0, H),
			Position               = centerP,
			BackgroundTransparency = 0,
		}, 0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		task.delay(0.44, function()
			animating = false
		end)
	end

	local function hideGui()
		if animating then return end
		animating = true
		tw(Main, {
			Size                   = UDim2.new(0, W, 0, H * 0.92),
			Position               = UDim2.new(0.5, -W/2, 0.5, -H * 0.92/2),
			BackgroundTransparency = 0.1,
		}, 0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		task.delay(0.13, function()
			tw(Main, {
				Size                   = miniS,
				Position               = miniP,
				BackgroundTransparency = 0.55,
			}, 0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		end)
		task.delay(0.43, function()
			tw(Main, {BackgroundTransparency = 1}, 0.12)
		end)
		task.delay(0.56, function()
			Main.Visible                = false
			Main.Size                   = UDim2.new(0, W, 0, H)
			Main.Position               = centerP
			Main.BackgroundTransparency = 0
			animating                   = false
		end)
	end

	local visible   = true
	local toggleKey = config.Toggle or Enum.KeyCode.LeftAlt

	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.KeyCode == toggleKey or input.KeyCode == Enum.KeyCode.RightAlt then
			if visible then
				visible = false
				hideGui()
			else
				visible = true
				showGui()
			end
		end
	end)

	local win = {}

	function win:AddTab(cfg)
		cfg = cfg or {}
		local name    = cfg.Name or ("Tab" .. tostring(#tabList + 1))
		local subText = cfg.Sub  or ""
		local iconId  = cfg.Icon or ICONS.aim
		if type(iconId) == "string" and not iconId:match("rbxasset") then
			iconId = ICONS[iconId] or ICONS.aim
		end

		local pg = ni("Frame", {
			Name                   = name,
			Size                   = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Visible                = false,
		}, PageArea)
		pages[name] = pg
		table.insert(tabList, {name = name, sub = subText, icon = iconId})

		local idx        = #tabList
		local positions  = calcPositions(idx)

		for i, tb in ipairs(tabBtns) do
			local p = positions[i]
			tb.bg.Position = UDim2.new(0, p.x, 0, 0)
			tb.bg.Size     = UDim2.new(0, SMALL_W, 1, 0)
		end

		local p  = positions[idx]
		local bg = ni("Frame", {
			Size                   = UDim2.new(0, SMALL_W, 1, 0),
			Position               = UDim2.new(0, p.x, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel        = 0,
			ClipsDescendants       = true,
		}, TabBar)
		local sq = ni("Frame", {
			Size             = UDim2.new(0, 34, 0, 34),
			Position         = UDim2.new(0, 5, 0.5, -17),
			BackgroundColor3 = Theme.card,
			BorderSizePixel  = 0,
		}, bg)
		corner(sq, 8)
		local sqStr = ni("UIStroke", {Color = Theme.InElementBorder, Thickness = 1}, sq)
		local img = ni("ImageLabel", {
			Size                   = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE),
			Position               = UDim2.new(0.5, -ICON_SIZE/2, 0.5, -ICON_SIZE/2),
			BackgroundTransparency = 1,
			Image                  = iconId,
			ImageColor3            = Theme.dim,
		}, sq)
		local lbl = ni("TextLabel", {
			Size                   = UDim2.new(1, -46, 0, 15),
			Position               = UDim2.new(0, 44, 0.5, -13),
			BackgroundTransparency = 1,
			Text                   = name,
			TextColor3             = Theme.text,
			TextSize               = 11,
			Font                   = Enum.Font.GothamBold,
			TextXAlignment         = Enum.TextXAlignment.Left,
			TextTransparency       = 1,
		}, bg)
		local sub_lbl = ni("TextLabel", {
			Size                   = UDim2.new(1, -46, 0, 10),
			Position               = UDim2.new(0, 44, 0.5, 3),
			BackgroundTransparency = 1,
			Text                   = subText,
			TextColor3             = Theme.muted,
			TextSize               = 8,
			Font                   = Enum.Font.Gotham,
			TextXAlignment         = Enum.TextXAlignment.Left,
			TextTransparency       = 1,
		}, bg)
		local btn = ni("TextButton", {
			Size                   = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text                   = "",
			BorderSizePixel        = 0,
			ZIndex                 = 10,
		}, bg)

		tabBtns[idx] = {name = name, bg = bg, sq = sq, str = sqStr, img = img, lbl = lbl, sub = sub_lbl}

		btn.MouseButton1Click:Connect(function() switchTo(name) end)
		btn.MouseEnter:Connect(function()
			if curTab ~= name then
				tw(sq,  {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.12)
				tw(img, {ImageColor3 = Theme.muted}, 0.12)
			end
		end)
		btn.MouseLeave:Connect(function()
			if curTab ~= name then
				tw(sq,  {BackgroundColor3 = Theme.card}, 0.12)
				tw(img, {ImageColor3 = Theme.dim}, 0.12)
			end
		end)

		if curTab == nil then
			task.delay(0.05, function() switchTo(name) end)
		end

		local tab = {}
		tab.Page = pg
		return tab
	end

	function win:AddSettingsTab()
		local settingsTab = self:AddTab({
			Name = "Settings",
			Sub  = "config",
			Icon = ICONS.config,
		})

		local pg = settingsTab.Page

		local scroll = ni("ScrollingFrame", {
			Size                  = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel       = 0,
			ScrollBarThickness    = 2,
			ScrollBarImageColor3  = Theme.accentHi,
			CanvasSize            = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize   = Enum.AutomaticSize.Y,
		}, pg)

		local layout = ni("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding   = UDim.new(0, 8),
		}, scroll)

		local pad = ni("UIPadding", {
			PaddingTop    = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10),
			PaddingLeft   = UDim.new(0, 10),
			PaddingRight  = UDim.new(0, 10),
		}, scroll)

		local function mkCard(h)
			local card = ni("Frame", {
				Size             = UDim2.new(1, 0, 0, h),
				BackgroundColor3 = Theme.card,
				BorderSizePixel  = 0,
			}, scroll)
			corner(card, 8)
			ni("UIStroke", {Color = Theme.InElementBorder, Thickness = 1}, card)
			return card
		end

		local function mkLabel(parent, text, size, color, posX, posY, w, h, bold)
			return ni("TextLabel", {
				Size                   = UDim2.new(0, w or 300, 0, h or 20),
				Position               = UDim2.new(0, posX or 12, 0, posY or 0),
				BackgroundTransparency = 1,
				Text                   = text,
				TextColor3             = color or Theme.text,
				TextSize               = size or 12,
				Font                   = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
				TextXAlignment         = Enum.TextXAlignment.Left,
			}, parent)
		end

		local autoLoadOn = getAutoLoad()

		local alCard = mkCard(64)
		mkLabel(alCard, "Auto Load", 13, Theme.text, 14, 10, 200, 18, true)
		mkLabel(alCard, "Executa o script automaticamente ao entrar no jogo", 10, Theme.muted, 14, 30, 360, 14)

		local alBg = ni("Frame", {
			Size             = UDim2.new(0, 36, 0, 20),
			Position         = UDim2.new(1, -48, 0.5, -10),
			BackgroundColor3 = autoLoadOn and Theme.accentHi or Theme.dim,
			BorderSizePixel  = 0,
		}, alCard)
		corner(alBg, 10)

		local alKnob = ni("Frame", {
			Size             = UDim2.new(0, 14, 0, 14),
			Position         = autoLoadOn and UDim2.new(0, 19, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel  = 0,
		}, alBg)
		corner(alKnob, 7)

		local alBtn = ni("TextButton", {
			Size                   = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text                   = "",
			BorderSizePixel        = 0,
			ZIndex                 = 5,
		}, alCard)

		alBtn.MouseButton1Click:Connect(function()
			autoLoadOn = not autoLoadOn
			setAutoLoad(autoLoadOn)
			tw(alBg,   {BackgroundColor3 = autoLoadOn and Theme.accentHi or Theme.dim}, 0.2)
			tw(alKnob, {Position = autoLoadOn and UDim2.new(0, 19, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}, 0.2)
		end)
		alBtn.MouseEnter:Connect(function() tw(alCard, {BackgroundColor3 = Color3.fromRGB(38, 38, 38)}, 0.12) end)
		alBtn.MouseLeave:Connect(function() tw(alCard, {BackgroundColor3 = Theme.card}, 0.12) end)

		local execCard = mkCard(54)
		mkLabel(execCard, "Executor detectado", 13, Theme.text, 14, 8, 250, 18, true)

		local function detectExecutor()
			if syn then return "Synapse X"
			elseif KRNL_LOADED then return "KRNL"
			elseif rconsoleprint then return "Script-Ware"
			elseif fluxus then return "Fluxus"
			elseif getexecutorname then
				local ok, name = pcall(getexecutorname)
				if ok and name then return name end
			elseif identifyexecutor then
				local ok, name = pcall(identifyexecutor)
				if ok and name then return name end
			end
			return "Desconhecido"
		end

		mkLabel(execCard, detectExecutor(), 11, Theme.accentHi, 14, 28, 350, 16)

		local fsCard = mkCard(54)
		mkLabel(fsCard, "Sistema de Arquivos", 13, Theme.text, 14, 8, 250, 18, true)

		local function detectFS()
			if writefile and readfile and isfile then return "Suporte total"
			elseif writefile then return "Escrita disponivel"
			elseif readfile then return "Leitura disponivel"
			else return "Sem suporte"
			end
		end

		local fsColor = (writefile and readfile and isfile) and Color3.fromRGB(45, 200, 85) or Color3.fromRGB(255, 160, 40)
		mkLabel(fsCard, detectFS(), 11, fsColor, 14, 28, 350, 16)

		if SCRIPT_URL ~= "" then
			local reloadCard = mkCard(40)
			mkLabel(reloadCard, "Recarregar Script", 12, Theme.text, 14, 10, 260, 20, true)

			local reloadBtn = ni("TextButton", {
				Size                   = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text                   = "",
				BorderSizePixel        = 0,
				ZIndex                 = 5,
			}, reloadCard)

			reloadBtn.MouseButton1Click:Connect(function()
				if loadstring and SCRIPT_URL ~= "" then
					pcall(function()
						loadstring(game:HttpGet(SCRIPT_URL))()
					end)
				end
			end)
			reloadBtn.MouseEnter:Connect(function() tw(reloadCard, {BackgroundColor3 = Color3.fromRGB(38, 38, 38)}, 0.12) end)
			reloadBtn.MouseLeave:Connect(function() tw(reloadCard, {BackgroundColor3 = Theme.card}, 0.12) end)
		end

		return settingsTab
	end

	return win
end

Lib.AutoLoad = {
	Check = function()
		local data = nil
		if isfile and isfile(AUTOLOAD_FILE) then
			local ok, v = pcall(readfile, AUTOLOAD_FILE)
			if ok then data = v end
		end
		return data == "true"
	end,
	Set = function(val)
		if val then
			if writefile then pcall(writefile, AUTOLOAD_FILE, "true")
			elseif savefile then pcall(savefile, AUTOLOAD_FILE, "true") end
		else
			if delfile then pcall(delfile, AUTOLOAD_FILE)
			elseif removefile then pcall(removefile, AUTOLOAD_FILE) end
		end
	end,
}

return Lib
