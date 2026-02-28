local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

local AUTOLOAD_FILE = "ecohub_autoload.txt"
local SCRIPT_URL    = ""

local function writeFile(path, content)
	if writefile then pcall(writefile, path, content)
	elseif savefile then pcall(savefile, path, content) end
end

local function readFile(path)
	if isfile and isfile(path) then
		local ok, data = pcall(readfile, path)
		if ok then return data end
	end
	return nil
end

local function deleteFile(path)
	if delfile then pcall(delfile, path)
	elseif removefile then pcall(removefile, path) end
end

local function getAutoLoad()
	return readFile(AUTOLOAD_FILE) == "true"
end

local function setAutoLoad(val)
	if val then writeFile(AUTOLOAD_FILE, "true")
	else deleteFile(AUTOLOAD_FILE) end
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
	elem            = Color3.fromRGB(28, 28, 28),
	elemHover       = Color3.fromRGB(36, 36, 36),
	sep             = Color3.fromRGB(45, 45, 45),
	toggleOff       = Color3.fromRGB(55, 55, 55),
	toggleOn        = Color3.fromRGB(160, 100, 255),
	sliderTrack     = Color3.fromRGB(45, 45, 45),
	sliderFill      = Color3.fromRGB(160, 100, 255),
	btnBg           = Color3.fromRGB(32, 32, 32),
	btnBorder       = Color3.fromRGB(60, 60, 60),
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
		TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
		props):Play()
end

local function stroke(parent, color, thickness)
	return ni("UIStroke", {Color = color or Theme.InElementBorder, Thickness = thickness or 1}, parent)
end

local function sep(parent)
	ni("Frame", {
		Size             = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = Theme.sep,
		BorderSizePixel  = 0,
	}, parent)
end

local Lib = {}
Lib.Icons = ICONS

local function BuildSection(sectionName, scrollFrame)
	local Outer = ni("Frame", {
		Size             = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
		BorderSizePixel  = 0,
		AutomaticSize    = Enum.AutomaticSize.Y,
	}, scrollFrame)
	corner(Outer, 6)
	stroke(Outer, Color3.fromRGB(55, 55, 55), 1)

	local Header = ni("Frame", {
		Size             = UDim2.new(1, 0, 0, 28),
		BackgroundColor3 = Color3.fromRGB(160, 100, 255),
		BorderSizePixel  = 0,
	}, Outer)
	corner(Header, 6)
	ni("Frame", {
		Size             = UDim2.new(1, 0, 0, 10),
		Position         = UDim2.new(0, 0, 1, -10),
		BackgroundColor3 = Color3.fromRGB(160, 100, 255),
		BorderSizePixel  = 0,
	}, Header)

	ni("TextLabel", {
		Size                   = UDim2.new(1, -12, 1, 0),
		Position               = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Text                   = sectionName or "Section",
		TextColor3             = Color3.fromRGB(255, 255, 255),
		TextSize               = 11,
		Font                   = Enum.Font.GothamBold,
		TextXAlignment         = Enum.TextXAlignment.Left,
	}, Header)

	local Content = ni("Frame", {
		Size              = UDim2.new(1, 0, 0, 0),
		Position          = UDim2.new(0, 0, 0, 28),
		BackgroundTransparency = 1,
		BorderSizePixel   = 0,
		AutomaticSize     = Enum.AutomaticSize.Y,
	}, Outer)

	ni("UIListLayout", {
		Parent    = Content,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding   = UDim.new(0, 0),
	})

	local SecObj = {}
	local elemCount = 0

	local function mkElem(h)
		elemCount = elemCount + 1
		local f = ni("Frame", {
			Size             = UDim2.new(1, 0, 0, h),
			BackgroundColor3 = Theme.elem,
			BorderSizePixel  = 0,
			LayoutOrder      = elemCount,
		}, Content)
		if elemCount > 1 then
			ni("Frame", {
				Size             = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = Theme.sep,
				BorderSizePixel  = 0,
				ZIndex           = 2,
			}, f)
		end
		return f
	end

	function SecObj:addToggle(labelText, default, callback, bindKey)
		local cb = callback or function() end
		local On = default == true
		local Listening = false
		local CKey = bindKey or nil

		local f = mkElem(32)

		local Lbl = ni("TextLabel", {
			Size                   = UDim2.new(1, -90, 1, 0),
			Position               = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text                   = labelText or "Toggle",
			TextColor3             = Theme.text,
			TextSize               = 11,
			Font                   = Enum.Font.GothamSemibold,
			TextXAlignment         = Enum.TextXAlignment.Left,
		}, f)

		local TglBg = ni("Frame", {
			Size             = UDim2.new(0, 16, 0, 16),
			Position         = UDim2.new(1, -36, 0.5, -8),
			BackgroundColor3 = On and Theme.toggleOn or Theme.toggleOff,
			BorderSizePixel  = 0,
		}, f)
		corner(TglBg, 3)
		stroke(TglBg, On and Color3.fromRGB(180, 120, 255) or Color3.fromRGB(70, 70, 70), 1)

		local TglMark = ni("Frame", {
			Size                   = UDim2.new(0, 8, 0, 8),
			Position               = UDim2.new(0.5, -4, 0.5, -4),
			BackgroundColor3       = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = On and 0 or 1,
			BorderSizePixel        = 0,
		}, TglBg)
		corner(TglMark, 2)

		local KbFrame, KbLabel
		if bindKey ~= nil or true then
			KbFrame = ni("Frame", {
				Size             = UDim2.new(0, 28, 0, 16),
				Position         = UDim2.new(1, -68, 0.5, -8),
				BackgroundColor3 = Color3.fromRGB(35, 35, 35),
				BorderSizePixel  = 0,
			}, f)
			corner(KbFrame, 3)
			stroke(KbFrame, Color3.fromRGB(60, 60, 60), 1)

			KbLabel = ni("TextLabel", {
				Size                   = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text                   = CKey and "[" .. CKey.Name:sub(1,3):upper() .. "]" or "[?]",
				TextColor3             = Theme.muted,
				TextSize               = 8,
				Font                   = Enum.Font.GothamBold,
			}, KbFrame)
		end

		local function updateVisuals()
			tw(TglBg, {BackgroundColor3 = On and Theme.toggleOn or Theme.toggleOff}, 0.15)
			tw(TglMark, {BackgroundTransparency = On and 0 or 1}, 0.15)
		end

		local HitBtn = ni("TextButton", {
			Size                   = UDim2.new(1, KbFrame and -72 or -40, 1, 0),
			BackgroundTransparency = 1,
			Text                   = "",
			BorderSizePixel        = 0,
			ZIndex                 = 5,
		}, f)

		HitBtn.MouseEnter:Connect(function() tw(f, {BackgroundColor3 = Theme.elemHover}, 0.1) end)
		HitBtn.MouseLeave:Connect(function() tw(f, {BackgroundColor3 = Theme.elem}, 0.1) end)
		HitBtn.MouseButton1Click:Connect(function()
			if Listening then return end
			On = not On
			updateVisuals()
			pcall(cb, On)
		end)

		if KbFrame then
			local KbBtn = ni("TextButton", {
				Size                   = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text                   = "",
				BorderSizePixel        = 0,
				ZIndex                 = 6,
			}, KbFrame)

			KbBtn.MouseButton1Click:Connect(function()
				if Listening then return end
				Listening = true
				KbLabel.Text = "[...]"
				KbLabel.TextColor3 = Theme.accentHi
			end)

			UserInputService.InputBegan:Connect(function(inp, gp)
				if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
				if Listening then
					Listening = false
					if inp.KeyCode == Enum.KeyCode.Escape then
						CKey = nil
						KbLabel.Text = "[?]"
					else
						CKey = inp.KeyCode
						KbLabel.Text = "[" .. inp.KeyCode.Name:sub(1,3):upper() .. "]"
					end
					KbLabel.TextColor3 = Theme.muted
					return
				end
				if not gp and CKey and inp.KeyCode == CKey then
					On = not On
					updateVisuals()
					pcall(cb, On)
				end
			end)
		end

		updateVisuals()

		local ctrl = {}
		function ctrl:Set(v) On = v == true updateVisuals() pcall(cb, On) end
		function ctrl:Get() return On end
		return ctrl
	end

	function SecObj:addButton(labelText, callback)
		local cb = callback or function() end
		local f = mkElem(34)

		local BtnFrame = ni("Frame", {
			Size             = UDim2.new(1, -16, 0, 22),
			Position         = UDim2.new(0, 8, 0.5, -11),
			BackgroundColor3 = Theme.btnBg,
			BorderSizePixel  = 0,
		}, f)
		corner(BtnFrame, 4)
		stroke(BtnFrame, Theme.btnBorder, 1)

		ni("TextLabel", {
			Size                   = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text                   = labelText or "Button",
			TextColor3             = Theme.text,
			TextSize               = 11,
			Font                   = Enum.Font.GothamSemibold,
		}, BtnFrame)

		local BtnHit = ni("TextButton", {
			Size                   = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text                   = "",
			BorderSizePixel        = 0,
			ZIndex                 = 5,
		}, BtnFrame)

		BtnHit.MouseEnter:Connect(function()
			tw(BtnFrame, {BackgroundColor3 = Color3.fromRGB(42, 42, 42)}, 0.1)
		end)
		BtnHit.MouseLeave:Connect(function()
			tw(BtnFrame, {BackgroundColor3 = Theme.btnBg}, 0.1)
		end)
		BtnHit.MouseButton1Down:Connect(function()
			tw(BtnFrame, {BackgroundColor3 = Color3.fromRGB(55, 30, 90)}, 0.08)
		end)
		BtnHit.MouseButton1Click:Connect(function()
			tw(BtnFrame, {BackgroundColor3 = Theme.btnBg}, 0.15)
			pcall(cb)
		end)
	end

	function SecObj:addSlider(labelText, min, max, default, callback)
		local cb  = callback or function() end
		min       = tonumber(min) or 0
		max       = tonumber(max) or 100
		local cur = math.clamp(tonumber(default) or min, min, max)

		local f = mkElem(46)

		local TopRow = ni("Frame", {
			Size                   = UDim2.new(1, 0, 0, 20),
			Position               = UDim2.new(0, 0, 0, 4),
			BackgroundTransparency = 1,
			BorderSizePixel        = 0,
		}, f)

		ni("TextLabel", {
			Size                   = UDim2.new(1, -50, 1, 0),
			Position               = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text                   = labelText or "Slider",
			TextColor3             = Theme.text,
			TextSize               = 11,
			Font                   = Enum.Font.GothamSemibold,
			TextXAlignment         = Enum.TextXAlignment.Left,
		}, TopRow)

		local ValLbl = ni("TextLabel", {
			Size                   = UDim2.new(0, 40, 1, 0),
			Position               = UDim2.new(1, -44, 0, 0),
			BackgroundTransparency = 1,
			Text                   = tostring(cur),
			TextColor3             = Theme.muted,
			TextSize               = 11,
			Font                   = Enum.Font.GothamBold,
			TextXAlignment         = Enum.TextXAlignment.Right,
		}, TopRow)

		local TrackBg = ni("Frame", {
			Size             = UDim2.new(1, -16, 0, 4),
			Position         = UDim2.new(0, 8, 0, 32),
			BackgroundColor3 = Theme.sliderTrack,
			BorderSizePixel  = 0,
		}, f)
		corner(TrackBg, 2)

		local ratio = (cur - min) / (max - min)
		local Fill = ni("Frame", {
			Size             = UDim2.new(ratio, 0, 1, 0),
			BackgroundColor3 = Theme.sliderFill,
			BorderSizePixel  = 0,
		}, TrackBg)
		corner(Fill, 2)

		local Knob = ni("Frame", {
			Size             = UDim2.new(0, 12, 0, 12),
			Position         = UDim2.new(ratio, -6, 0.5, -6),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel  = 0,
			ZIndex           = 3,
		}, TrackBg)
		corner(Knob, 6)

		local TrackHit = ni("TextButton", {
			Size                   = UDim2.new(1, 0, 0, 20),
			Position               = UDim2.new(0, 0, 0.5, -10),
			BackgroundTransparency = 1,
			Text                   = "",
			BorderSizePixel        = 0,
			ZIndex                 = 4,
		}, TrackBg)

		local Dragging = false

		local function updateSlider(px)
			local p = math.clamp((px - TrackBg.AbsolutePosition.X) / TrackBg.AbsoluteSize.X, 0, 1)
			cur = math.floor(min + (max - min) * p)
			Fill.Size = UDim2.new(p, 0, 1, 0)
			Knob.Position = UDim2.new(p, -6, 0.5, -6)
			ValLbl.Text = tostring(cur)
			pcall(cb, cur)
		end

		TrackHit.MouseButton1Down:Connect(function()
			Dragging = true
			tw(Knob, {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(Fill.Size.X.Scale, -7, 0.5, -7)}, 0.1)
		end)
		TrackHit.MouseButton1Click:Connect(function()
			updateSlider(UserInputService:GetMouseLocation().X)
		end)
		UserInputService.InputChanged:Connect(function(i)
			if Dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
				updateSlider(i.Position.X)
			end
		end)
		UserInputService.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 then
				Dragging = false
				tw(Knob, {Size = UDim2.new(0, 12, 0, 12)}, 0.1)
			end
		end)
		f.MouseEnter:Connect(function() tw(f, {BackgroundColor3 = Theme.elemHover}, 0.1) end)
		f.MouseLeave:Connect(function() tw(f, {BackgroundColor3 = Theme.elem}, 0.1) end)

		local ctrl = {}
		function ctrl:Set(v)
			cur = math.clamp(v, min, max)
			local p = (cur - min) / (max - min)
			Fill.Size = UDim2.new(p, 0, 1, 0)
			Knob.Position = UDim2.new(p, -6, 0.5, -6)
			ValLbl.Text = tostring(cur)
		end
		function ctrl:Get() return cur end
		return ctrl
	end

	function SecObj:addLabel(text)
		local f = mkElem(26)
		ni("TextLabel", {
			Size                   = UDim2.new(1, -10, 1, 0),
			Position               = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text                   = text or "",
			TextColor3             = Theme.muted,
			TextSize               = 10,
			Font                   = Enum.Font.Gotham,
			TextXAlignment         = Enum.TextXAlignment.Left,
		}, f)
	end

	function SecObj:addTextBox(labelText, placeholder, callback)
		local cb = callback or function() end
		local f = mkElem(44)

		ni("TextLabel", {
			Size                   = UDim2.new(1, -10, 0, 16),
			Position               = UDim2.new(0, 10, 0, 4),
			BackgroundTransparency = 1,
			Text                   = labelText or "Input",
			TextColor3             = Theme.text,
			TextSize               = 11,
			Font                   = Enum.Font.GothamSemibold,
			TextXAlignment         = Enum.TextXAlignment.Left,
		}, f)

		local InputWrap = ni("Frame", {
			Size             = UDim2.new(1, -16, 0, 16),
			Position         = UDim2.new(0, 8, 0, 24),
			BackgroundColor3 = Color3.fromRGB(18, 18, 18),
			BorderSizePixel  = 0,
		}, f)
		corner(InputWrap, 3)
		local wStroke = stroke(InputWrap, Color3.fromRGB(50, 50, 50), 1)

		local Input = ni("TextBox", {
			Size                   = UDim2.new(1, -8, 1, 0),
			Position               = UDim2.new(0, 4, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel        = 0,
			Text                   = "",
			PlaceholderText        = placeholder or "",
			PlaceholderColor3      = Theme.dim,
			TextColor3             = Theme.text,
			TextSize               = 10,
			Font                   = Enum.Font.Gotham,
			TextXAlignment         = Enum.TextXAlignment.Left,
			ClearTextOnFocus       = false,
		}, InputWrap)

		Input.Focused:Connect(function()
			tw(InputWrap, {BackgroundColor3 = Color3.fromRGB(24, 24, 24)})
			wStroke.Color = Theme.accentHi
		end)
		Input.FocusLost:Connect(function()
			tw(InputWrap, {BackgroundColor3 = Color3.fromRGB(18, 18, 18)})
			wStroke.Color = Color3.fromRGB(50, 50, 50)
			pcall(cb, Input.Text)
		end)
	end

	function SecObj:addDropdown(labelText, list, callback)
		local cb = callback or function() end
		local Selected = nil
		local Open = false
		local tH = math.min(#list * 22, 110)

		local Wrapper = ni("Frame", {
			Size                   = UDim2.new(1, 0, 0, 32),
			BackgroundTransparency = 1,
			BorderSizePixel        = 0,
			LayoutOrder            = elemCount + 1,
			ClipsDescendants       = false,
		}, Content)
		elemCount = elemCount + 1

		local Hdr = ni("Frame", {
			Size             = UDim2.new(1, 0, 0, 32),
			BackgroundColor3 = Theme.elem,
			BorderSizePixel  = 0,
		}, Wrapper)
		if elemCount > 1 then
			ni("Frame", {
				Size             = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = Theme.sep,
				BorderSizePixel  = 0,
				ZIndex           = 2,
			}, Hdr)
		end

		ni("TextLabel", {
			Size                   = UDim2.new(0.55, -10, 1, 0),
			Position               = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text                   = labelText or "Dropdown",
			TextColor3             = Theme.text,
			TextSize               = 11,
			Font                   = Enum.Font.GothamSemibold,
			TextXAlignment         = Enum.TextXAlignment.Left,
		}, Hdr)

		local SelLbl = ni("TextLabel", {
			Size                   = UDim2.new(0.45, -26, 1, 0),
			Position               = UDim2.new(0.55, 0, 0, 0),
			BackgroundTransparency = 1,
			Text                   = "none",
			TextColor3             = Theme.muted,
			TextSize               = 10,
			Font                   = Enum.Font.Gotham,
			TextXAlignment         = Enum.TextXAlignment.Right,
		}, Hdr)

		local Arrow = ni("TextLabel", {
			Size                   = UDim2.new(0, 18, 1, 0),
			Position               = UDim2.new(1, -20, 0, 0),
			BackgroundTransparency = 1,
			Text                   = "v",
			TextColor3             = Theme.accentHi,
			TextSize               = 9,
			Font                   = Enum.Font.GothamBold,
		}, Hdr)

		local DL = ni("Frame", {
			Size             = UDim2.new(1, 0, 0, 0),
			Position         = UDim2.new(0, 0, 0, 32),
			BackgroundColor3 = Color3.fromRGB(22, 22, 22),
			BorderSizePixel  = 0,
			ZIndex           = 20,
			ClipsDescendants = true,
			Visible          = false,
		}, Wrapper)
		corner(DL, 4)
		stroke(DL, Color3.fromRGB(55, 55, 55), 1)

		local DLInner = ni("Frame", {
			Size                   = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel        = 0,
			ZIndex                 = 20,
		}, DL)
		ni("UIListLayout", {Parent = DLInner, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 0)})

		local opts = {}

		local function closeDD()
			Open = false
			Arrow.Text = "v"
			tw(DL, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
			task.delay(0.16, function()
				DL.Visible = false
				Wrapper.Size = UDim2.new(1, 0, 0, 32)
			end)
		end

		local function openDD()
			Open = true
			Arrow.Text = "^"
			DL.Visible = true
			tw(DL, {Size = UDim2.new(1, 0, 0, tH)}, 0.15)
			Wrapper.Size = UDim2.new(1, 0, 0, 34 + tH)
		end

		local HB = ni("TextButton", {
			Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1,
			Text = "", BorderSizePixel = 0, ZIndex = 7,
		}, Wrapper)
		HB.MouseButton1Click:Connect(function() if Open then closeDD() else openDD() end end)
		HB.MouseEnter:Connect(function() tw(Hdr, {BackgroundColor3 = Theme.elemHover}, 0.1) end)
		HB.MouseLeave:Connect(function() tw(Hdr, {BackgroundColor3 = Theme.elem}, 0.1) end)

		for i, item in ipairs(list) do
			local isSel = false
			local Opt = ni("TextButton", {
				Size             = UDim2.new(1, 0, 0, 22),
				BackgroundColor3 = Color3.fromRGB(22, 22, 22),
				BorderSizePixel  = 0,
				Text             = "",
				Font             = Enum.Font.Gotham,
				AutoButtonColor  = false,
				ZIndex           = 21,
				LayoutOrder      = i,
			}, DLInner)

			local Bar = ni("Frame", {
				Size             = UDim2.new(0, 2, 1, 0),
				BackgroundColor3 = Theme.accentHi,
				BackgroundTransparency = 1,
				BorderSizePixel  = 0,
				ZIndex           = 22,
			}, Opt)

			ni("TextLabel", {
				Size = UDim2.new(1, -12, 1, 0), Position = UDim2.new(0, 10, 0, 0),
				BackgroundTransparency = 1, Text = tostring(item),
				TextColor3 = Theme.muted, TextSize = 10,
				Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 22,
			}, Opt)

			if i < #list then
				ni("Frame", {
					Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
					BackgroundColor3 = Theme.sep, BorderSizePixel = 0, ZIndex = 21,
				}, Opt)
			end

			Opt.MouseButton1Click:Connect(function()
				for _, o in pairs(opts) do o.sel = false o.update() end
				isSel = true
				Selected = item
				SelLbl.Text = tostring(item)
				SelLbl.TextColor3 = Theme.text
				closeDD()
				pcall(cb, item)
			end)

			local function upd()
				tw(Bar, {BackgroundTransparency = isSel and 0 or 1}, 0.12)
			end
			Opt.MouseEnter:Connect(function() tw(Opt, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.1) end)
			Opt.MouseLeave:Connect(function() tw(Opt, {BackgroundColor3 = Color3.fromRGB(22, 22, 22)}, 0.1) upd() end)
			table.insert(opts, {sel = false, update = upd})
		end

		local ctrl = {}
		function ctrl:Set(v) Selected = v SelLbl.Text = tostring(v) SelLbl.TextColor3 = Theme.text end
		function ctrl:Get() return Selected end
		return ctrl
	end

	return SecObj
end

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
		task.delay(0.44, function() animating = false end)
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
		task.delay(0.43, function() tw(Main, {BackgroundTransparency = 1}, 0.12) end)
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
			if visible then visible = false hideGui()
			else visible = true showGui() end
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

		local PageScroll = ni("ScrollingFrame", {
			Size                 = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel      = 0,
			ScrollBarThickness   = 3,
			ScrollBarImageColor3 = Theme.accentHi,
			CanvasSize           = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize  = Enum.AutomaticSize.Y,
			ScrollingDirection   = Enum.ScrollingDirection.Y,
		}, pg)

		ni("UIListLayout", {
			Parent    = PageScroll,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding   = UDim.new(0, 6),
		})
		ni("UIPadding", {
			Parent        = PageScroll,
			PaddingTop    = UDim.new(0, 8),
			PaddingBottom = UDim.new(0, 8),
			PaddingLeft   = UDim.new(0, 8),
			PaddingRight  = UDim.new(0, 8),
		})

		pages[name] = pg
		table.insert(tabList, {name = name, sub = subText, icon = iconId})

		local idx       = #tabList
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

		local tab = {}
		tab.Page = pg

		function tab:AddSection(sectionName)
			return BuildSection(sectionName, PageScroll)
		end

		return tab
	end

	function win:AddSettingsTab()
		local settingsTab = self:AddTab({
			Name = "Settings",
			Sub  = "config",
			Icon = ICONS.config,
		})

		local sec = settingsTab:AddSection("Auto Load")
		local autoLoadOn = getAutoLoad()

		local alCtrl = sec:addToggle("Auto Load ao iniciar", autoLoadOn, function(val)
			setAutoLoad(val)
		end)

		sec:addLabel("Salva preferencia no executor atual")

		local sec2 = settingsTab:AddSection("Sistema")

		local function detectExecutor()
			if syn then return "Synapse X"
			elseif KRNL_LOADED then return "KRNL"
			elseif rconsoleprint then return "Script-Ware"
			elseif fluxus then return "Fluxus"
			elseif getexecutorname then
				local ok, n = pcall(getexecutorname) if ok and n then return n end
			elseif identifyexecutor then
				local ok, n = pcall(identifyexecutor) if ok and n then return n end
			end
			return "Desconhecido"
		end

		sec2:addLabel("Executor: " .. detectExecutor())
		sec2:addLabel("FS: " .. ((writefile and readfile) and "Suporte total" or "Parcial/Nenhum"))

		if SCRIPT_URL ~= "" then
			local sec3 = settingsTab:AddSection("Script")
			sec3:addButton("Recarregar Script", function()
				if loadstring then
					pcall(function() loadstring(game:HttpGet(SCRIPT_URL))() end)
				end
			end)
		end

		return settingsTab
	end

	return win
end

Lib.AutoLoad = {
	Check = function()
		if isfile and isfile(AUTOLOAD_FILE) then
			local ok, v = pcall(readfile, AUTOLOAD_FILE)
			if ok then return v == "true" end
		end
		return false
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
