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

local W, H = 550, 350
local TOPBAR = 62
local ELEM_H = 28

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

	local logoSize = 58
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
		Size                   = UDim2.new(1, -16, 1, -TOPBAR - 60),
		Position               = UDim2.new(0, 8, 0, TOPBAR + 8),
		BackgroundTransparency = 1,
		BorderSizePixel        = 0,
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
		local x   = 0
		for i = 1, #tabList do
			local w  = (i == activeIdx) and expW or SMALL_W
			pos[i]   = {x = x, w = w}
			x        = x + w
		end
		local realTotal = expW + (#tabList - 1) * SMALL_W
		local offset    = math.max(4, math.floor((W - realTotal) / 2))
		for i = 1, #tabList do pos[i].x = pos[i].x + offset end
		return pos, expW
	end

	local function switchTo(name)
		if curTab == name then return end
		if curTab and pages[curTab] then pages[curTab].Visible = false end
		curTab              = name
		pages[name].Visible = true
		local activeIdx     = 1
		for i, t in ipairs(tabList) do
			if t.name == name then activeIdx = i break end
		end
		local positions = calcPositions(activeIdx)
		for i, tb in ipairs(tabBtns) do
			local active = tabList[i].name == name
			local p      = positions[i]
			tw(tb.bg, {Position = UDim2.new(0, p.x, 0, 0), Size = UDim2.new(0, p.w, 1, 0)}, 0.3)
			if active then
				tw(tb.sq,  {BackgroundColor3 = Theme.accentLo},         0.25)
				tw(tb.str, {Color = Theme.accentHi, Thickness = 1.5},   0.25)
				tw(tb.img, {ImageColor3 = Theme.accentHi},              0.25)
				tw(tb.lbl, {TextColor3 = Theme.text,  TextTransparency = 0}, 0.25)
				tw(tb.sub, {TextColor3 = Theme.muted, TextTransparency = 0}, 0.25)
			else
				tw(tb.sq,  {BackgroundColor3 = Theme.card},             0.25)
				tw(tb.str, {Color = Theme.InElementBorder, Thickness = 1}, 0.25)
				tw(tb.img, {ImageColor3 = Theme.dim},                   0.25)
				tw(tb.lbl, {TextTransparency = 1},                      0.18)
				tw(tb.sub, {TextTransparency = 1},                      0.18)
			end
		end
	end

	local centerP = UDim2.new(0.5, -W/2, 0.5, -H/2)

	local function setChildrenVisible(state)
		for _, v in ipairs(Main:GetChildren()) do
			if v:IsA("GuiObject") then v.Visible = state end
		end
	end

	local function showGui()
		if animating then return end
		animating               = true
		Main.Visible            = true
		Main.BackgroundTransparency = 1
		setChildrenVisible(false)
		tw(Main, {BackgroundTransparency = 0}, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		task.delay(0.1,  function() setChildrenVisible(true) end)
		task.delay(0.28, function() animating = false end)
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
		cfg           = cfg or {}
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

		local idx       = #tabList
		local positions = calcPositions(idx)

		for i, tb in ipairs(tabBtns) do
			local p        = positions[i]
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
				tw(img, {ImageColor3 = Theme.muted},                      0.12)
			end
		end)
		btn.MouseLeave:Connect(function()
			if curTab ~= name then
				tw(sq,  {BackgroundColor3 = Theme.card}, 0.12)
				tw(img, {ImageColor3 = Theme.dim},       0.12)
			end
		end)

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
			local gap    = PAD
			local eachW  = math.floor((totalW - gap * 2) / 3)
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
		PageArea:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutSections)

		local tab           = {}
		tab.Page            = pg
		tab.SectionLeft     = sectionLeft
		tab.SectionCenter   = sectionCenter
		tab.SectionRight    = sectionRight

		function tab:AddSection(cfg2)
			cfg2           = cfg2 or {}
			local side     = cfg2.Side  or "Left"
			local title    = cfg2.Title or ""
			local iconId2  = cfg2.Icon  or ""
			local target
			if side == "Left"        then target = sectionLeft
			elseif side == "Center"  then target = sectionCenter
			elseif side == "Right"   then target = sectionRight
			end

			if iconId2 ~= "" and type(iconId2) == "string" and not iconId2:match("rbxasset") then
				iconId2 = ICONS[iconId2] or iconId2
			end

			local HEADER_H = 32

			if title ~= "" then
				local titleBar = ni("Frame", {
					Size             = UDim2.new(1, 0, 0, HEADER_H),
					BackgroundColor3 = Theme.section,
					BorderSizePixel  = 0,
				}, target)

				local txtX = 10
				if iconId2 ~= "" then
					ni("ImageLabel", {
						Size                   = UDim2.new(0, 14, 0, 14),
						Position               = UDim2.new(0, 10, 0.5, -7),
						BackgroundTransparency = 1,
						Image                  = iconId2,
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

			-- ScrollingFrame for elements
			local scroll = ni("ScrollingFrame", {
				Size                    = UDim2.new(1, 0, 1, -HEADER_H),
				Position                = UDim2.new(0, 0, 0, HEADER_H),
				BackgroundTransparency  = 1,
				BorderSizePixel         = 0,
				ScrollBarThickness      = 3,
				ScrollBarImageColor3    = Theme.accentHi,
				CanvasSize              = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize     = Enum.AutomaticSize.Y,
				ScrollingDirection      = Enum.ScrollingDirection.Y,
				ClipsDescendants        = true,
			}, target)

			local list = ni("Frame", {
				Size                   = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				AutomaticSize          = Enum.AutomaticSize.Y,
			}, scroll)
			ni("UIListLayout", {
				SortOrder           = Enum.SortOrder.LayoutOrder,
				Padding             = UDim.new(0, 2),
				FillDirection       = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}, list)
			ni("UIPadding", {
				PaddingLeft   = UDim.new(0, 5),
				PaddingRight  = UDim.new(0, 5),
				PaddingTop    = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 4),
			}, list)

			local sec       = {}
			sec.Frame       = target
			sec.ScrollFrame = scroll
			sec.List        = list

			local function newRow(h, zidx)
				return ni("Frame", {
					Size             = UDim2.new(1, 0, 0, h),
					BackgroundColor3 = Theme.card,
					BorderSizePixel  = 0,
					LayoutOrder      = #list:GetChildren(),
					ZIndex           = zidx or 1,
				}, list)
			end

			-- TOGGLE
			function sec:AddToggle(cfg3)
				cfg3           = cfg3 or {}
				local label    = cfg3.Name     or "Toggle"
				local default  = cfg3.Default  or false
				local callback = cfg3.Callback or function() end
				local state    = default

				local row = newRow(ELEM_H)
				corner(row, 6)

				ni("TextLabel", {
					Size                   = UDim2.new(1, -50, 1, 0),
					Position               = UDim2.new(0, 8, 0, 0),
					BackgroundTransparency = 1,
					Text                   = label,
					TextColor3             = Theme.text,
					TextSize               = 10,
					Font                   = Enum.Font.Gotham,
					TextXAlignment         = Enum.TextXAlignment.Left,
				}, row)

				local trkW, trkH = 28, 14
				local track = ni("Frame", {
					Size             = UDim2.new(0, trkW, 0, trkH),
					Position         = UDim2.new(1, -trkW - 6, 0.5, -trkH/2),
					BackgroundColor3 = state and Theme.accentHi or Theme.dim,
					BorderSizePixel  = 0,
				}, row)
				corner(track, trkH)

				local knob = ni("Frame", {
					Size             = UDim2.new(0, 10, 0, 10),
					Position         = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5),
					BackgroundColor3 = Theme.text,
					BorderSizePixel  = 0,
				}, track)
				corner(knob, 10)

				local btn = ni("TextButton", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 5,
				}, row)
				btn.MouseButton1Click:Connect(function()
					state = not state
					tw(track, {BackgroundColor3 = state and Theme.accentHi or Theme.dim}, 0.18)
					tw(knob,  {Position = state and UDim2.new(1,-12,0.5,-5) or UDim2.new(0,2,0.5,-5)}, 0.18)
					callback(state)
				end)

				local el = {Value = state}
				function el:Set(v)
					state = v
					tw(track, {BackgroundColor3 = state and Theme.accentHi or Theme.dim}, 0.18)
					tw(knob,  {Position = state and UDim2.new(1,-12,0.5,-5) or UDim2.new(0,2,0.5,-5)}, 0.18)
					callback(state)
				end
				return el
			end

			-- SLIDER
			function sec:AddSlider(cfg3)
				cfg3           = cfg3 or {}
				local label    = cfg3.Name     or "Slider"
				local minV     = cfg3.Min      or 0
				local maxV     = cfg3.Max      or 100
				local default  = cfg3.Default  or minV
				local suffix   = cfg3.Suffix   or ""
				local callback = cfg3.Callback or function() end
				local value    = math.clamp(default, minV, maxV)

				local row = newRow(ELEM_H + 10)
				corner(row, 6)

				ni("TextLabel", {
					Size = UDim2.new(1,-50,0,14), Position = UDim2.new(0,8,0,4),
					BackgroundTransparency = 1, Text = label,
					TextColor3 = Theme.text, TextSize = 10,
					Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
				}, row)

				local valLbl = ni("TextLabel", {
					Size = UDim2.new(0,40,0,14), Position = UDim2.new(1,-46,0,4),
					BackgroundTransparency = 1, Text = tostring(value)..suffix,
					TextColor3 = Theme.accentHi, TextSize = 10,
					Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Right,
				}, row)

				local tBg = ni("Frame", {
					Size = UDim2.new(1,-16,0,4), Position = UDim2.new(0,8,0,24),
					BackgroundColor3 = Theme.dim, BorderSizePixel = 0,
				}, row)
				corner(tBg, 4)

				local pct  = (value - minV) / (maxV - minV)
				local fill = ni("Frame", {
					Size = UDim2.new(pct,0,1,0),
					BackgroundColor3 = Theme.accentHi, BorderSizePixel = 0,
				}, tBg)
				corner(fill, 4)

				local dragging = false
				local function update(absX)
					local rel  = math.clamp((absX - tBg.AbsolutePosition.X) / tBg.AbsoluteSize.X, 0, 1)
					value      = math.floor(minV + rel*(maxV-minV) + 0.5)
					fill.Size  = UDim2.new((value-minV)/(maxV-minV), 0, 1, 0)
					valLbl.Text = tostring(value)..suffix
					callback(value)
				end

				local btn = ni("TextButton", {
					Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 5,
				}, row)
				btn.MouseButton1Down:Connect(function(x) dragging = true update(x) end)
				btn.MouseButton1Up:Connect(function() dragging = false end)
				UserInputService.InputChanged:Connect(function(i)
					if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i.Position.X) end
				end)

				local el = {Value = value}
				function el:Set(v)
					value       = math.clamp(v, minV, maxV)
					fill.Size   = UDim2.new((value-minV)/(maxV-minV), 0, 1, 0)
					valLbl.Text = tostring(value)..suffix
					callback(value)
				end
				return el
			end

			-- KEYBIND
			function sec:AddKeybind(cfg3)
				cfg3           = cfg3 or {}
				local label    = cfg3.Name     or "Keybind"
				local default  = cfg3.Default  or Enum.KeyCode.Unknown
				local callback = cfg3.Callback or function() end
				local key      = default
				local listening = false

				local row = newRow(ELEM_H)
				corner(row, 6)

				ni("TextLabel", {
					Size = UDim2.new(1,-70,1,0), Position = UDim2.new(0,8,0,0),
					BackgroundTransparency = 1, Text = label,
					TextColor3 = Theme.text, TextSize = 10,
					Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
				}, row)

				local kBox = ni("Frame", {
					Size = UDim2.new(0,58,0,18), Position = UDim2.new(1,-64,0.5,-9),
					BackgroundColor3 = Theme.bg, BorderSizePixel = 0,
				}, row)
				corner(kBox, 4)
				ni("UIStroke", {Color = Theme.InElementBorder, Thickness = 1}, kBox)

				local kLbl = ni("TextLabel", {
					Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
					Text = key.Name, TextColor3 = Theme.accentHi,
					TextSize = 9, Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Center,
				}, kBox)

				local btn = ni("TextButton", {
					Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 5,
				}, row)
				btn.MouseButton1Click:Connect(function()
					listening      = true
					kLbl.Text      = "..."
					kLbl.TextColor3 = Theme.muted
					ni("UIStroke", {Color = Theme.accentHi, Thickness = 1}, kBox)
				end)
				UserInputService.InputBegan:Connect(function(input, processed)
					if not listening then return end
					if input.UserInputType == Enum.UserInputType.Keyboard then
						listening       = false
						key             = input.KeyCode
						kLbl.Text       = key.Name
						kLbl.TextColor3 = Theme.accentHi
						ni("UIStroke", {Color = Theme.InElementBorder, Thickness = 1}, kBox)
						callback(key)
					end
				end)

				return {Value = key}
			end

			-- DROPDOWN (MENU) — expands inside scroll
			function sec:AddDropdown(cfg3)
				cfg3           = cfg3 or {}
				local label    = cfg3.Name     or "Menu"
				local options  = cfg3.Options  or {}
				local default  = cfg3.Default  or (options[1] or "")
				local callback = cfg3.Callback or function() end
				local selected = default
				local open     = false

				local OPT_H   = 20
				local totalOptH = #options * OPT_H

				-- wrapper that grows when open
				local wrapper = ni("Frame", {
					Size             = UDim2.new(1, 0, 0, ELEM_H),
					BackgroundTransparency = 1,
					BorderSizePixel  = 0,
					LayoutOrder      = #list:GetChildren(),
					ClipsDescendants = false,
				}, list)

				local row = ni("Frame", {
					Size             = UDim2.new(1, 0, 0, ELEM_H),
					BackgroundColor3 = Theme.card,
					BorderSizePixel  = 0,
				}, wrapper)
				corner(row, 6)

				ni("TextLabel", {
					Size = UDim2.new(1,-80,1,0), Position = UDim2.new(0,8,0,0),
					BackgroundTransparency = 1, Text = label,
					TextColor3 = Theme.text, TextSize = 10,
					Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
				}, row)

				local selBox = ni("Frame", {
					Size = UDim2.new(0,68,0,18), Position = UDim2.new(1,-74,0.5,-9),
					BackgroundColor3 = Theme.bg, BorderSizePixel = 0,
				}, row)
				corner(selBox, 4)
				ni("UIStroke", {Color = Theme.InElementBorder, Thickness = 1}, selBox)

				local selLbl = ni("TextLabel", {
					Size = UDim2.new(1,-14,1,0), Position = UDim2.new(0,4,0,0),
					BackgroundTransparency = 1, Text = selected,
					TextColor3 = Theme.accentHi, TextSize = 9,
					Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
				}, selBox)

				ni("TextLabel", {
					Size = UDim2.new(0,12,1,0), Position = UDim2.new(1,-13,0,0),
					BackgroundTransparency = 1, Text = "v",
					TextColor3 = Theme.muted, TextSize = 8,
					Font = Enum.Font.GothamBold,
				}, selBox)

				local dropdown = ni("Frame", {
					Size             = UDim2.new(1, 0, 0, 0),
					Position         = UDim2.new(0, 0, 0, ELEM_H + 2),
					BackgroundColor3 = Theme.card,
					BorderSizePixel  = 0,
					ClipsDescendants = true,
					ZIndex           = 20,
					Visible          = false,
				}, wrapper)
				corner(dropdown, 6)
				ni("UIStroke", {Color = Theme.accentHi, Thickness = 1}, dropdown)

				local optList = ni("Frame", {
					Size = UDim2.new(1,0,0,totalOptH),
					BackgroundTransparency = 1, ZIndex = 21,
				}, dropdown)
				ni("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,0)}, optList)

				for i2, opt in ipairs(options) do
					local optBtn = ni("TextButton", {
						Size = UDim2.new(1,0,0,OPT_H),
						BackgroundTransparency = 1,
						Text = "  "..opt,
						TextColor3 = Theme.muted,
						TextSize = 9, Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = 22, LayoutOrder = i2,
					}, optList)
					optBtn.MouseButton1Click:Connect(function()
						selected    = opt
						selLbl.Text = opt
						open        = false
						wrapper.Size = UDim2.new(1,0,0,ELEM_H)
						tw(dropdown, {Size = UDim2.new(1,0,0,0)}, 0.18)
						task.delay(0.19, function() dropdown.Visible = false end)
						callback(selected)
					end)
					optBtn.MouseEnter:Connect(function() tw(optBtn,{TextColor3=Theme.text},0.1) end)
					optBtn.MouseLeave:Connect(function() tw(optBtn,{TextColor3=Theme.muted},0.1) end)
				end

				local toggleBtn = ni("TextButton", {
					Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 5,
				}, row)
				toggleBtn.MouseButton1Click:Connect(function()
					open = not open
					if open then
						dropdown.Visible = true
						dropdown.Size    = UDim2.new(1,0,0,0)
						wrapper.Size     = UDim2.new(1,0,0,ELEM_H + totalOptH + 4)
						tw(dropdown, {Size = UDim2.new(1,0,0,totalOptH)}, 0.2)
					else
						wrapper.Size = UDim2.new(1,0,0,ELEM_H)
						tw(dropdown, {Size = UDim2.new(1,0,0,0)}, 0.18)
						task.delay(0.19, function() dropdown.Visible = false end)
					end
				end)

				local el = {Value = selected}
				function el:Set(v)
					selected    = v
					selLbl.Text = v
					callback(v)
				end
				return el
			end

			-- PARAGRAPH
			function sec:AddParagraph(cfg3)
				cfg3        = cfg3 or {}
				local title = cfg3.Title or ""
				local text  = cfg3.Text  or ""
				local lines = math.max(1, math.ceil(#text / 26))
				local rowH  = 14 + lines * 12 + 6

				local row = newRow(rowH)
				corner(row, 6)

				if title ~= "" then
					ni("TextLabel", {
						Size = UDim2.new(1,-10,0,13), Position = UDim2.new(0,8,0,4),
						BackgroundTransparency = 1, Text = title,
						TextColor3 = Theme.accentHi, TextSize = 10,
						Font = Enum.Font.GothamBold,
						TextXAlignment = Enum.TextXAlignment.Left,
					}, row)
				end

				ni("TextLabel", {
					Size     = UDim2.new(1,-10,1, title ~= "" and -16 or 0),
					Position = UDim2.new(0,8,0, title ~= "" and 16 or 4),
					BackgroundTransparency = 1, Text = text,
					TextColor3 = Theme.muted, TextSize = 9,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
				}, row)

				return {Frame = row}
			end

			-- LABEL
			function sec:AddLabel(cfg3)
				cfg3        = cfg3 or {}
				local text  = cfg3.Text  or "Label"
				local color = cfg3.Color or Theme.muted

				local row = newRow(ELEM_H)
				corner(row, 6)

				ni("TextLabel", {
					Size = UDim2.new(1,-10,1,0), Position = UDim2.new(0,8,0,0),
					BackgroundTransparency = 1, Text = text,
					TextColor3 = color, TextSize = 10,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
				}, row)

				return {Frame = row}
			end

			-- COLOR PICKER — expands inside scroll
			function sec:AddColorPicker(cfg3)
				cfg3           = cfg3 or {}
				local label    = cfg3.Name     or "Color"
				local default  = cfg3.Default  or Color3.fromRGB(160, 100, 255)
				local callback = cfg3.Callback or function() end
				local color    = default
				local open     = false

				local PICKER_H = 90
				local wrapper  = ni("Frame", {
					Size                   = UDim2.new(1,0,0,ELEM_H),
					BackgroundTransparency = 1,
					BorderSizePixel        = 0,
					LayoutOrder            = #list:GetChildren(),
					ClipsDescendants       = false,
				}, list)

				local row = ni("Frame", {
					Size             = UDim2.new(1,0,0,ELEM_H),
					BackgroundColor3 = Theme.card,
					BorderSizePixel  = 0,
					ZIndex           = 10,
				}, wrapper)
				corner(row, 6)

				ni("TextLabel", {
					Size = UDim2.new(1,-50,1,0), Position = UDim2.new(0,8,0,0),
					BackgroundTransparency = 1, Text = label,
					TextColor3 = Theme.text, TextSize = 10,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
				}, row)

				local preview = ni("Frame", {
					Size = UDim2.new(0,20,0,20), Position = UDim2.new(1,-26,0.5,-10),
					BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 11,
				}, row)
				corner(preview, 4)
				ni("UIStroke", {Color = Theme.InElementBorder, Thickness = 1}, preview)

				local picker = ni("Frame", {
					Size             = UDim2.new(1,0,0,PICKER_H),
					Position         = UDim2.new(0,0,0,ELEM_H+2),
					BackgroundColor3 = Theme.bg,
					BorderSizePixel  = 0,
					Visible          = false,
					ZIndex           = 20,
				}, wrapper)
				corner(picker, 8)
				ni("UIStroke", {Color = Theme.InElementBorder, Thickness = 1}, picker)

				local huebar = ni("Frame", {
					Size = UDim2.new(1,-12,0,12), Position = UDim2.new(0,6,0,8),
					BackgroundColor3 = Color3.fromRGB(255,255,255),
					BorderSizePixel = 0, ZIndex = 21,
				}, picker)
				corner(huebar, 6)

				local hueGrad = Instance.new("UIGradient")
				hueGrad.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0,    Color3.fromRGB(255,0,0)),
					ColorSequenceKeypoint.new(0.167,Color3.fromRGB(255,255,0)),
					ColorSequenceKeypoint.new(0.333,Color3.fromRGB(0,255,0)),
					ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(0,255,255)),
					ColorSequenceKeypoint.new(0.667,Color3.fromRGB(0,0,255)),
					ColorSequenceKeypoint.new(0.833,Color3.fromRGB(255,0,255)),
					ColorSequenceKeypoint.new(1,    Color3.fromRGB(255,0,0)),
				})
				hueGrad.Parent = huebar

				local satFrame = ni("Frame", {
					Size = UDim2.new(1,-12,0,50), Position = UDim2.new(0,6,0,26),
					BackgroundColor3 = Color3.fromRGB(255,255,255),
					BorderSizePixel = 0, ZIndex = 21,
				}, picker)
				corner(satFrame, 4)

				local hueH2, satV2 = 0, 1
				local satGrad = Instance.new("UIGradient")
				satGrad.Color  = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,0,0))
				satGrad.Parent = satFrame

				local function updateColor()
					color                    = Color3.fromHSV(hueH2, satV2, 1)
					preview.BackgroundColor3 = color
					satGrad.Color            = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromHSV(hueH2,1,1))
					callback(color)
				end

				local hueDrag, satDrag = false, false

				local hueBtn = ni("TextButton", {
					Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
					Text = "", ZIndex = 22,
				}, huebar)
				hueBtn.MouseButton1Down:Connect(function(x)
					hueDrag = true
					hueH2   = math.clamp((x - huebar.AbsolutePosition.X) / huebar.AbsoluteSize.X, 0, 1)
					updateColor()
				end)
				hueBtn.MouseButton1Up:Connect(function() hueDrag = false end)

				local satBtn = ni("TextButton", {
					Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
					Text = "", ZIndex = 22,
				}, satFrame)
				satBtn.MouseButton1Down:Connect(function(x)
					satDrag = true
					satV2   = math.clamp((x - satFrame.AbsolutePosition.X) / satFrame.AbsoluteSize.X, 0, 1)
					updateColor()
				end)
				satBtn.MouseButton1Up:Connect(function() satDrag = false end)

				UserInputService.InputChanged:Connect(function(i)
					if i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
					if hueDrag then
						hueH2 = math.clamp((i.Position.X - huebar.AbsolutePosition.X) / huebar.AbsoluteSize.X, 0, 1)
						updateColor()
					end
					if satDrag then
						satV2 = math.clamp((i.Position.X - satFrame.AbsolutePosition.X) / satFrame.AbsoluteSize.X, 0, 1)
						updateColor()
					end
				end)
				UserInputService.InputEnded:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then
						hueDrag = false
						satDrag = false
					end
				end)

				local openBtn = ni("TextButton", {
					Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 12,
				}, row)
				openBtn.MouseButton1Click:Connect(function()
					open           = not open
					picker.Visible = open
					wrapper.Size   = open and UDim2.new(1,0,0,ELEM_H + PICKER_H + 4) or UDim2.new(1,0,0,ELEM_H)
				end)

				local el = {Value = color}
				function el:Set(c)
					color                    = c
					preview.BackgroundColor3 = c
					callback(c)
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
