local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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
	section         = Color3.fromRGB(26, 26, 26),
	sectionBorder   = Color3.fromRGB(50, 50, 50),
	sectionTitle    = Color3.fromRGB(160, 100, 255),
}

local W, H = 780, 480
local TOPBAR = 62

local function ni(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do
		pcall(function() o[k] = v end)
	end
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
		Visible          = false,
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

	local logoSize = 46
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

	local ICON_SIZE = 18
	local SMALL_W = 44
	local EXPANDED_W = 120
	local tabList = {}
	local tabBtns = {}
	local pages = {}
	local curTab = nil
	local animating = false

	local function calcPositions(activeIdx)
		local total = EXPANDED_W + (#tabList - 1) * SMALL_W
		local maxTotal = W - 20
		local expW = EXPANDED_W
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
		local offset = math.max(4, math.floor((W - realTotal) / 2))
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

	local function setChildrenVisible(state)
		for _, v in ipairs(Main:GetChildren()) do
			if v:IsA("GuiObject") then
				v.Visible = state
			end
		end
	end

	local function showGui()
		if animating then return end
		animating = true
		if curTab == nil and #tabList > 0 then
			switchTo(tabList[1].name)
		end
		Main.Visible                = true
		Main.BackgroundTransparency = 1
		setChildrenVisible(false)
		tw(Main, {BackgroundTransparency = 0}, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		task.delay(0.1, function()
			setChildrenVisible(true)
		end)
		task.delay(0.28, function()
			animating = false
		end)
	end

	local function hideGui()
		if animating then return end
		animating = true
		setChildrenVisible(false)
		tw(Main, {BackgroundTransparency = 1}, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		task.delay(0.24, function()
			Main.Visible = false
			animating    = false
		end)
	end

	local visible = false
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

		local idx = #tabList
		local positions = calcPositions(idx)

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

		local PAD = 6

		local function makeSection(secName)
			local f = ni("Frame", {
				Name             = secName,
				BackgroundColor3 = Theme.section,
				BorderSizePixel  = 0,
			}, pg)
			corner(f, 10)
			ni("UIStroke", {Color = Theme.accentHi, Thickness = 1}, f)
			return f
		end

		local sectionLeft   = makeSection("SectionLeft")
		local sectionCenter = makeSection("SectionCenter")
		local sectionRight  = makeSection("SectionRight")

		local function layoutSections()
			local totalW = PageArea.AbsoluteSize.X - PAD * 2
			local totalH = PageArea.AbsoluteSize.Y - PAD * 2
			local gap  = PAD
			local eachW = math.floor((totalW - gap * 2) / 3)
			local xL = PAD
			local xC = PAD + eachW + gap
			local xR = PAD + (eachW + gap) * 2
			sectionLeft.Position   = UDim2.new(0, xL, 0, PAD)
			sectionLeft.Size       = UDim2.new(0, eachW, 0, totalH)
			sectionCenter.Position = UDim2.new(0, xC, 0, PAD)
			sectionCenter.Size     = UDim2.new(0, eachW, 0, totalH)
			sectionRight.Position  = UDim2.new(0, xR, 0, PAD)
			sectionRight.Size      = UDim2.new(0, eachW, 0, totalH)
		end

		layoutSections()

		PageArea:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			layoutSections()
		end)

		local tab = {}
		tab.Page          = pg
		tab.SectionLeft   = sectionLeft
		tab.SectionCenter = sectionCenter
		tab.SectionRight  = sectionRight

		function tab:AddSection(cfg2)
			cfg2 = cfg2 or {}
			local side   = cfg2.Side  or "Left"
			local title  = cfg2.Title or ""
			local iconId = cfg2.Icon  or ""
			local target
			if side == "Left"        then target = sectionLeft
			elseif side == "Center"  then target = sectionCenter
			elseif side == "Right"   then target = sectionRight
			end

			if iconId ~= "" and type(iconId) == "string" and not iconId:match("rbxasset") then
				iconId = ICONS[iconId] or iconId
			end

			if title ~= "" then
				local HEADER_H = 32
				local titleBar = ni("Frame", {
					Size             = UDim2.new(1, 0, 0, HEADER_H),
					BackgroundColor3 = Theme.section,
					BorderSizePixel  = 0,
				}, target)

				local txtX = 10
				if iconId ~= "" then
					ni("ImageLabel", {
						Size                   = UDim2.new(0, 14, 0, 14),
						Position               = UDim2.new(0, 10, 0.5, -7),
						BackgroundTransparency = 1,
						Image                  = iconId,
						ImageColor3            = Theme.accentHi,
					}, titleBar)
					txtX = 28
				end

				ni("TextLabel", {
					Size                   = UDim2.new(1, -txtX - 4, 1, 0),
					Position               = UDim2.new(0, txtX, 0, 0),
					BackgroundTransparency = 1,
					Text                   = title,
					TextColor3             = Theme.accentHi,
					TextSize               = 11,
					Font                   = Enum.Font.GothamBold,
					TextXAlignment         = Enum.TextXAlignment.Left,
				}, titleBar)

				ni("Frame", {
					Size             = UDim2.new(1, -10, 0, 1),
					Position         = UDim2.new(0, 5, 1, -1),
					BackgroundColor3 = Theme.accentLo,
					BorderSizePixel  = 0,
				}, titleBar)
			end

			local sec = {}
			sec.Frame = target
			return sec
		end

		return tab
	end

	return win
end

return Lib
