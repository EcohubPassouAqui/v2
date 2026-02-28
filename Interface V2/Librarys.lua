local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService      = game:GetService("TextService")
local HttpService      = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

local function TryGet(name, fallbacks)
	if typeof(name) == "function" then return name end
	for _, src in ipairs(fallbacks or {}) do
		if typeof(src) == "table" and typeof(src[name]) == "function" then
			return src[name]
		end
	end
	return nil
end

local _readfile   = TryGet("readfile",   {syn}) or (typeof(readfile)   == "function" and readfile)   or nil
local _writefile  = TryGet("writefile",  {syn}) or (typeof(writefile)  == "function" and writefile)  or nil
local _listfiles  = TryGet("listfiles",  {syn}) or (typeof(listfiles)  == "function" and listfiles)  or nil
local _makefolder = TryGet("makefolder", {syn}) or (typeof(makefolder) == "function" and makefolder) or nil
local _isfolder   = TryGet("isfolder",   {syn}) or (typeof(isfolder)   == "function" and isfolder)   or nil
local _delfile    = TryGet("delfile",    {syn}) or (typeof(delfile)    == "function" and delfile)
				 or TryGet("deletefile", {syn}) or (typeof(deletefile) == "function" and deletefile) or nil

local function SafeRead(p)
	if not _readfile then return nil end
	local ok, r = pcall(_readfile, p)
	if not ok then print("[LIB] SafeRead: " .. tostring(r)) return nil end
	return r
end

local function SafeWrite(p, d)
	if not _writefile then print("[LIB] SafeWrite: writefile not available") return false end
	local ok, e = pcall(_writefile, p, d)
	if not ok then print("[LIB] SafeWrite: " .. tostring(e)) return false end
	return true
end

local function SafeList(p)
	if not _listfiles then return {} end
	local ok, r = pcall(_listfiles, p)
	if not ok then return {} end
	return r or {}
end

local function SafeFolder(p)
	if not _makefolder then return false end
	local ok, e = pcall(_makefolder, p)
	if not ok then print("[LIB] SafeFolder: " .. tostring(e)) return false end
	return true
end

local function SafeIsDir(p)
	if not _isfolder then return false end
	local ok, r = pcall(_isfolder, p)
	if not ok then return false end
	return r == true
end

local function SafeDel(p)
	if not _delfile then return false end
	local ok, e = pcall(_delfile, p)
	if not ok then print("[LIB] SafeDel: " .. tostring(e)) return false end
	return true
end

local Lib = {}
Lib.__index = Lib
Lib.Options  = {}
Lib._optCount = 0

local function RegOpt(ctrl, typeName)
	Lib._optCount = Lib._optCount + 1
	local idx = "_opt_" .. Lib._optCount
	ctrl.Type = typeName
	ctrl._idx = idx
	Lib.Options[idx] = ctrl
	return idx
end

local ICONS = {
	["lucide-accessibility"] = "rbxassetid://10709751939",
	["lucide-activity"] = "rbxassetid://10709752035",
	["lucide-alert-circle"] = "rbxassetid://10709752996",
	["lucide-alert-triangle"] = "rbxassetid://10709753149",
	["lucide-anchor"] = "rbxassetid://10709761530",
	["lucide-aperture"] = "rbxassetid://10709761813",
	["lucide-archive"] = "rbxassetid://10709762233",
	["lucide-arrow-down"] = "rbxassetid://10709767827",
	["lucide-arrow-left"] = "rbxassetid://10709768114",
	["lucide-arrow-right"] = "rbxassetid://10709768347",
	["lucide-arrow-up"] = "rbxassetid://10709768939",
	["lucide-award"] = "rbxassetid://10709769406",
	["lucide-axe"] = "rbxassetid://10709769508",
	["lucide-bar-chart"] = "rbxassetid://10709773755",
	["lucide-bar-chart-2"] = "rbxassetid://10709770317",
	["lucide-battery"] = "rbxassetid://10709774640",
	["lucide-bell"] = "rbxassetid://10709775704",
	["lucide-bell-off"] = "rbxassetid://10709775320",
	["lucide-bike"] = "rbxassetid://10709775894",
	["lucide-bluetooth"] = "rbxassetid://10709776655",
	["lucide-bold"] = "rbxassetid://10747813908",
	["lucide-bomb"] = "rbxassetid://10709781460",
	["lucide-book"] = "rbxassetid://10709781824",
	["lucide-book-open"] = "rbxassetid://10709781717",
	["lucide-bookmark"] = "rbxassetid://10709782154",
	["lucide-bot"] = "rbxassetid://10709782230",
	["lucide-box"] = "rbxassetid://10709782497",
	["lucide-briefcase"] = "rbxassetid://10709782662",
	["lucide-brush"] = "rbxassetid://10709782758",
	["lucide-bug"] = "rbxassetid://10709782845",
	["lucide-building"] = "rbxassetid://10709783051",
	["lucide-calendar"] = "rbxassetid://10709789505",
	["lucide-camera"] = "rbxassetid://10709789686",
	["lucide-car"] = "rbxassetid://10709789810",
	["lucide-check"] = "rbxassetid://10709790644",
	["lucide-check-circle"] = "rbxassetid://10709790387",
	["lucide-check-square"] = "rbxassetid://10709790537",
	["lucide-chevron-down"] = "rbxassetid://10709790948",
	["lucide-chevron-left"] = "rbxassetid://10709791281",
	["lucide-chevron-right"] = "rbxassetid://10709791437",
	["lucide-chevron-up"] = "rbxassetid://10709791523",
	["lucide-circle"] = "rbxassetid://10709798174",
	["lucide-clock"] = "rbxassetid://10709805144",
	["lucide-cloud"] = "rbxassetid://10709806740",
	["lucide-code"] = "rbxassetid://10709810463",
	["lucide-coffee"] = "rbxassetid://10709810814",
	["lucide-cog"] = "rbxassetid://10709810948",
	["lucide-coins"] = "rbxassetid://10709811110",
	["lucide-command"] = "rbxassetid://10709811365",
	["lucide-compass"] = "rbxassetid://10709811445",
	["lucide-copy"] = "rbxassetid://10709812159",
	["lucide-cpu"] = "rbxassetid://10709813383",
	["lucide-crosshair"] = "rbxassetid://10709818534",
	["lucide-crown"] = "rbxassetid://10709818626",
	["lucide-database"] = "rbxassetid://10709818996",
	["lucide-diamond"] = "rbxassetid://10709819149",
	["lucide-disc"] = "rbxassetid://10723343537",
	["lucide-dollar-sign"] = "rbxassetid://10723343958",
	["lucide-download"] = "rbxassetid://10723344270",
	["lucide-edit"] = "rbxassetid://10734883598",
	["lucide-edit-2"] = "rbxassetid://10723344885",
	["lucide-eye"] = "rbxassetid://10723346959",
	["lucide-eye-off"] = "rbxassetid://10723346871",
	["lucide-file"] = "rbxassetid://10723374641",
	["lucide-filter"] = "rbxassetid://10723375128",
	["lucide-fingerprint"] = "rbxassetid://10723375250",
	["lucide-flame"] = "rbxassetid://10723376114",
	["lucide-folder"] = "rbxassetid://10723387563",
	["lucide-folder-open"] = "rbxassetid://10723386277",
	["lucide-gamepad"] = "rbxassetid://10723395457",
	["lucide-gamepad-2"] = "rbxassetid://10723395215",
	["lucide-gauge"] = "rbxassetid://10723395708",
	["lucide-gem"] = "rbxassetid://10723396000",
	["lucide-ghost"] = "rbxassetid://10723396107",
	["lucide-gift"] = "rbxassetid://10723396402",
	["lucide-globe"] = "rbxassetid://10723404337",
	["lucide-hammer"] = "rbxassetid://10723405360",
	["lucide-heart"] = "rbxassetid://10723406885",
	["lucide-help-circle"] = "rbxassetid://10723406988",
	["lucide-home"] = "rbxassetid://10723407389",
	["lucide-image"] = "rbxassetid://10723415040",
	["lucide-info"] = "rbxassetid://10723415903",
	["lucide-key"] = "rbxassetid://10723416652",
	["lucide-keyboard"] = "rbxassetid://10723416765",
	["lucide-lamp"] = "rbxassetid://10723417513",
	["lucide-layers"] = "rbxassetid://10723424505",
	["lucide-leaf"] = "rbxassetid://10723425539",
	["lucide-lightbulb"] = "rbxassetid://10723425852",
	["lucide-link"] = "rbxassetid://10723426722",
	["lucide-list"] = "rbxassetid://10723433811",
	["lucide-lock"] = "rbxassetid://10723434711",
	["lucide-log-in"] = "rbxassetid://10723434830",
	["lucide-log-out"] = "rbxassetid://10723434906",
	["lucide-magnet"] = "rbxassetid://10723435069",
	["lucide-mail"] = "rbxassetid://10734885430",
	["lucide-map"] = "rbxassetid://10734886202",
	["lucide-map-pin"] = "rbxassetid://10734886004",
	["lucide-maximize"] = "rbxassetid://10734886735",
	["lucide-medal"] = "rbxassetid://10734887072",
	["lucide-megaphone"] = "rbxassetid://10734887454",
	["lucide-menu"] = "rbxassetid://10734887784",
	["lucide-message-circle"] = "rbxassetid://10734888000",
	["lucide-message-square"] = "rbxassetid://10734888228",
	["lucide-mic"] = "rbxassetid://10734888864",
	["lucide-mic-off"] = "rbxassetid://10734888646",
	["lucide-minimize"] = "rbxassetid://10734895698",
	["lucide-minus"] = "rbxassetid://10734896206",
	["lucide-minus-circle"] = "rbxassetid://10734895856",
	["lucide-monitor"] = "rbxassetid://10734896881",
	["lucide-moon"] = "rbxassetid://10734897102",
	["lucide-more-horizontal"] = "rbxassetid://10734897250",
	["lucide-more-vertical"] = "rbxassetid://10734897387",
	["lucide-mountain"] = "rbxassetid://10734897956",
	["lucide-mouse"] = "rbxassetid://10734898592",
	["lucide-music"] = "rbxassetid://10734905958",
	["lucide-navigation"] = "rbxassetid://10734906744",
	["lucide-network"] = "rbxassetid://10734906975",
	["lucide-newspaper"] = "rbxassetid://10734907168",
	["lucide-package"] = "rbxassetid://10734909540",
	["lucide-paint-bucket"] = "rbxassetid://10734909847",
	["lucide-paintbrush"] = "rbxassetid://10734910187",
	["lucide-palette"] = "rbxassetid://10734910430",
	["lucide-pencil"] = "rbxassetid://10734919691",
	["lucide-percent"] = "rbxassetid://10734919919",
	["lucide-phone"] = "rbxassetid://10734921524",
	["lucide-pie-chart"] = "rbxassetid://10734921727",
	["lucide-pin"] = "rbxassetid://10734922324",
	["lucide-play"] = "rbxassetid://10734923549",
	["lucide-plus"] = "rbxassetid://10734924532",
	["lucide-plus-circle"] = "rbxassetid://10734923868",
	["lucide-power"] = "rbxassetid://10734930466",
	["lucide-printer"] = "rbxassetid://10734930632",
	["lucide-puzzle"] = "rbxassetid://10734930886",
	["lucide-radio"] = "rbxassetid://10734931596",
	["lucide-recycle"] = "rbxassetid://10734932295",
	["lucide-refresh-ccw"] = "rbxassetid://10734933056",
	["lucide-refresh-cw"] = "rbxassetid://10734933222",
	["lucide-reply"] = "rbxassetid://10734934252",
	["lucide-rocket"] = "rbxassetid://10734934585",
	["lucide-rotate-ccw"] = "rbxassetid://10734940376",
	["lucide-rotate-cw"] = "rbxassetid://10734940654",
	["lucide-ruler"] = "rbxassetid://10734941018",
	["lucide-save"] = "rbxassetid://10734941499",
	["lucide-scan"] = "rbxassetid://10734942565",
	["lucide-scissors"] = "rbxassetid://10734942778",
	["lucide-search"] = "rbxassetid://10734943674",
	["lucide-send"] = "rbxassetid://10734943902",
	["lucide-server"] = "rbxassetid://10734949856",
	["lucide-settings"] = "rbxassetid://10734950309",
	["lucide-settings-2"] = "rbxassetid://10734950020",
	["lucide-share"] = "rbxassetid://10734950813",
	["lucide-shield"] = "rbxassetid://10734951847",
	["lucide-shield-alert"] = "rbxassetid://10734951173",
	["lucide-shield-check"] = "rbxassetid://10734951367",
	["lucide-shopping-bag"] = "rbxassetid://10734952273",
	["lucide-shopping-cart"] = "rbxassetid://10734952479",
	["lucide-shuffle"] = "rbxassetid://10734953451",
	["lucide-sidebar"] = "rbxassetid://10734954301",
	["lucide-signal"] = "rbxassetid://10734961133",
	["lucide-skull"] = "rbxassetid://10734962068",
	["lucide-slash"] = "rbxassetid://10734962600",
	["lucide-sliders"] = "rbxassetid://10734963400",
	["lucide-sliders-horizontal"] = "rbxassetid://10734963191",
	["lucide-smartphone"] = "rbxassetid://10734963940",
	["lucide-smile"] = "rbxassetid://10734964441",
	["lucide-snowflake"] = "rbxassetid://10734964600",
	["lucide-sort-asc"] = "rbxassetid://10734965115",
	["lucide-sort-desc"] = "rbxassetid://10734965287",
	["lucide-speaker"] = "rbxassetid://10734965419",
	["lucide-star"] = "rbxassetid://10734966248",
	["lucide-stethoscope"] = "rbxassetid://10734966384",
	["lucide-stop-circle"] = "rbxassetid://10734972621",
	["lucide-sun"] = "rbxassetid://10734974297",
	["lucide-sword"] = "rbxassetid://10734975486",
	["lucide-swords"] = "rbxassetid://10734975692",
	["lucide-syringe"] = "rbxassetid://10734975932",
	["lucide-table"] = "rbxassetid://10734976230",
	["lucide-tag"] = "rbxassetid://10734976528",
	["lucide-target"] = "rbxassetid://10734977012",
	["lucide-terminal"] = "rbxassetid://10734982144",
	["lucide-thermometer"] = "rbxassetid://10734983134",
	["lucide-thumbs-down"] = "rbxassetid://10734983359",
	["lucide-thumbs-up"] = "rbxassetid://10734983629",
	["lucide-ticket"] = "rbxassetid://10734983868",
	["lucide-timer"] = "rbxassetid://10734984606",
	["lucide-toggle-left"] = "rbxassetid://10734984834",
	["lucide-toggle-right"] = "rbxassetid://10734985040",
	["lucide-tornado"] = "rbxassetid://10734985247",
	["lucide-trash"] = "rbxassetid://10747362393",
	["lucide-trash-2"] = "rbxassetid://10747362241",
	["lucide-trending-down"] = "rbxassetid://10747363205",
	["lucide-trending-up"] = "rbxassetid://10747363465",
	["lucide-triangle"] = "rbxassetid://10747363621",
	["lucide-trophy"] = "rbxassetid://10747363809",
	["lucide-truck"] = "rbxassetid://10747364031",
	["lucide-tv"] = "rbxassetid://10747364593",
	["lucide-umbrella"] = "rbxassetid://10747364971",
	["lucide-undo"] = "rbxassetid://10747365484",
	["lucide-unlock"] = "rbxassetid://10747366027",
	["lucide-upload"] = "rbxassetid://10747366434",
	["lucide-user"] = "rbxassetid://10747373176",
	["lucide-user-check"] = "rbxassetid://10747371901",
	["lucide-user-cog"] = "rbxassetid://10747372167",
	["lucide-user-minus"] = "rbxassetid://10747372346",
	["lucide-user-plus"] = "rbxassetid://10747372702",
	["lucide-user-x"] = "rbxassetid://10747372992",
	["lucide-users"] = "rbxassetid://10747373426",
	["lucide-utensils"] = "rbxassetid://10747373821",
	["lucide-verified"] = "rbxassetid://10747374131",
	["lucide-video"] = "rbxassetid://10747374938",
	["lucide-video-off"] = "rbxassetid://10747374721",
	["lucide-volume"] = "rbxassetid://10747376008",
	["lucide-volume-2"] = "rbxassetid://10747375679",
	["lucide-volume-x"] = "rbxassetid://10747375880",
	["lucide-wallet"] = "rbxassetid://10747376205",
	["lucide-wand"] = "rbxassetid://10747376565",
	["lucide-watch"] = "rbxassetid://10747376722",
	["lucide-webcam"] = "rbxassetid://10747381992",
	["lucide-wifi"] = "rbxassetid://10747382504",
	["lucide-wifi-off"] = "rbxassetid://10747382268",
	["lucide-wind"] = "rbxassetid://10747382750",
	["lucide-wrench"] = "rbxassetid://10747383470",
	["lucide-x"] = "rbxassetid://10747384394",
	["lucide-x-circle"] = "rbxassetid://10747383819",
	["lucide-zoom-in"] = "rbxassetid://10747384552",
	["lucide-zoom-out"] = "rbxassetid://10747384679",
}
Lib.Icons = ICONS

local CHECK_TEXTURE = "rbxassetid://10709790644"
local R = 6

local Theme = {
	AcrylicMain     = Color3.fromRGB(30, 30, 30),
	TitleBarLine    = Color3.fromRGB(55, 55, 55),
	InElementBorder = Color3.fromRGB(50, 50, 50),
	bg              = Color3.fromRGB(18, 18, 20),
	pageArea        = Color3.fromRGB(20, 20, 22),
	card            = Color3.fromRGB(28, 28, 30),
	tabbar          = Color3.fromRGB(16, 16, 18),
	accentHi        = Color3.fromRGB(160, 100, 255),
	accentLo        = Color3.fromRGB(55, 20, 100),
	text            = Color3.fromRGB(235, 235, 235),
	muted           = Color3.fromRGB(130, 130, 130),
	dim             = Color3.fromRGB(65, 65, 70),
	elem            = Color3.fromRGB(26, 26, 28),
	elemHov         = Color3.fromRGB(34, 34, 38),
	sep             = Color3.fromRGB(42, 42, 46),
	off             = Color3.fromRGB(20, 20, 22),
	keybg           = Color3.fromRGB(22, 22, 25),
	ddbg            = Color3.fromRGB(24, 24, 26),
}

local W, H   = 780, 480
local TOPBAR = 62

local TI = {
	Fast = TweenInfo.new(0.10, Enum.EasingStyle.Quad),
	Med  = TweenInfo.new(0.18, Enum.EasingStyle.Quad),
	Slow = TweenInfo.new(0.25, Enum.EasingStyle.Quart),
}

local function ni(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do o[k] = v end
	if parent then o.Parent = parent end
	return o
end

local function corner(p, r)
	ni("UICorner", {CornerRadius = UDim.new(0, r or R)}, p)
end

local function stroke(parent, col, thick)
	return ni("UIStroke", {Color = col or Theme.InElementBorder, Thickness = thick or 1}, parent)
end

local function tw(obj, props, ti)
	TweenService:Create(obj, ti or TI.Fast, props):Play()
end

local function GetIconId(name)
	if not name then return nil end
	return ICONS["lucide-" .. name] or ICONS[name]
end

local function MkIcon(parent, iconName, sz, px, py, col, ax, ay)
	local id = GetIconId(iconName)
	if not id then return nil end
	local img = Instance.new("ImageLabel")
	img.BackgroundTransparency = 1
	img.Image = id
	img.ImageColor3 = col or Theme.dim
	img.Size = sz or UDim2.new(0, 14, 0, 14)
	img.Position = UDim2.new(0, px or 8, 0.5, py or 0)
	img.AnchorPoint = Vector2.new(ax or 0, ay or 0.5)
	img.ScaleType = Enum.ScaleType.Fit
	img.Parent = parent
	return img
end

local function GetKeyName(kc)
	local m = {
		Return="Enter", LeftShift="LShift", RightShift="RShift",
		LeftControl="LCtrl", RightControl="RCtrl",
		LeftAlt="LAlt", RightAlt="RAlt"
	}
	return m[kc.Name] or kc.Name
end

local SyncGroups = {}
local function RegSync(ctrl, key)
	if not key then return end
	if not SyncGroups[key] then SyncGroups[key] = {} end
	table.insert(SyncGroups[key], ctrl)
end
local function DoSync(key, val, src)
	if not key or not SyncGroups[key] then return end
	for _, c in ipairs(SyncGroups[key]) do
		if c ~= src then pcall(function() c:Set(val) end) end
	end
end

local function BuildSection(sname, scrollFrame)
	local Outer = ni("Frame", {
		Size             = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = Theme.elem,
		BorderSizePixel  = 0,
		AutomaticSize    = Enum.AutomaticSize.Y,
		ClipsDescendants = true,
	}, scrollFrame)
	corner(Outer, R)
	stroke(Outer, Theme.InElementBorder, 1)

	local Header = ni("Frame", {
		Size             = UDim2.new(1, 0, 0, 28),
		BackgroundColor3 = Theme.accentHi,
		BorderSizePixel  = 0,
	}, Outer)
	corner(Header, R)

	ni("Frame", {
		Size             = UDim2.new(1, 0, 0, R),
		Position         = UDim2.new(0, 0, 1, -R),
		BackgroundColor3 = Theme.accentHi,
		BorderSizePixel  = 0,
	}, Header)

	ni("TextLabel", {
		Size                   = UDim2.new(1, -12, 1, 0),
		Position               = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Text                   = sname or "Section",
		TextColor3             = Color3.fromRGB(255, 255, 255),
		TextSize               = 11,
		Font                   = Enum.Font.GothamBold,
		TextXAlignment         = Enum.TextXAlignment.Left,
	}, Header)

	local Content = ni("Frame", {
		Size                   = UDim2.new(1, 0, 0, 0),
		Position               = UDim2.new(0, 0, 0, 28),
		BackgroundTransparency = 1,
		BorderSizePixel        = 0,
		AutomaticSize          = Enum.AutomaticSize.Y,
	}, Outer)

	ni("UIListLayout", {
		Parent    = Content,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding   = UDim.new(0, 0),
	})

	local elemCount = 0

	local function Base(h, noSep)
		elemCount = elemCount + 1
		local f = ni("Frame", {
			Size             = UDim2.new(1, 0, 0, h),
			BackgroundColor3 = Theme.elem,
			BorderSizePixel  = 0,
			LayoutOrder      = elemCount,
		}, Content)
		if not noSep and elemCount > 1 then
			ni("Frame", {
				Size             = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = Theme.sep,
				BorderSizePixel  = 0,
				ZIndex           = 2,
			}, f)
		end
		return f
	end

	local S = {}

	function S:addToggle(labelText, default, callback, bindKey, syncKey)
		local cb = callback or function() end
		local On = default == true
		local CK = bindKey
		local Listening = false
		local f = Base(32)
		local ctrl = {}

		local trackW, trackH = 32, 16

		local lbl = ni("TextLabel", {
			Size                   = UDim2.new(1, -80, 1, 0),
			Position               = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text                   = labelText or "Toggle",
			TextColor3             = Theme.text,
			TextSize               = 11,
			Font                   = Enum.Font.GothamSemibold,
			TextXAlignment         = Enum.TextXAlignment.Left,
		}, f)

		local track = ni("Frame", {
			Size             = UDim2.new(0, trackW, 0, trackH),
			AnchorPoint      = Vector2.new(1, 0.5),
			Position         = UDim2.new(1, -10, 0.5, 0),
			BackgroundColor3 = On and Theme.accentHi or Theme.dim,
			BorderSizePixel  = 0,
		}, f)
		corner(track, trackH / 2)

		local knob = ni("Frame", {
			Size             = UDim2.new(0, trackH - 6, 0, trackH - 6),
			AnchorPoint      = Vector2.new(0, 0.5),
			Position         = UDim2.new(0, On and (trackW - trackH + 3) or 3, 0.5, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel  = 0,
		}, track)
		local kc = Instance.new("UICorner") kc.CornerRadius = UDim.new(1,0) kc.Parent = knob

		local kb, ks
		if bindKey ~= nil then
			lbl.Size = UDim2.new(1, -122, 1, 0)

			kb = ni("TextButton", {
				Size             = UDim2.new(0, 32, 0, 16),
				AnchorPoint      = Vector2.new(1, 0.5),
				Position         = UDim2.new(1, -(trackW + 16), 0.5, 0),
				BackgroundColor3 = Theme.keybg,
				BorderSizePixel  = 0,
				AutoButtonColor  = false,
				Font             = Enum.Font.GothamBold,
				Text             = CK and "[" .. GetKeyName(CK) .. "]" or "[?]",
				TextColor3       = Theme.muted,
				TextSize         = 8,
			}, f)
			corner(kb, 3)
			ks = stroke(kb, Theme.InElementBorder, 1)

			local function ResizeKb()
				local sz = TextService:GetTextSize(kb.Text, 8, Enum.Font.GothamBold, Vector2.new(1e4, 1e4))
				local nw = math.max(32, sz.X + 12)
				kb.Size = UDim2.new(0, nw, 0, 16)
				kb.Position = UDim2.new(1, -(trackW + 10 + nw + 4), 0.5, 0)
			end
			kb:GetPropertyChangedSignal("Text"):Connect(ResizeKb)
			ResizeKb()

			kb.MouseButton1Click:Connect(function()
				if Listening then return end
				Listening = true
				kb.Text = "[...]"
				kb.TextColor3 = Theme.accentHi
				ks.Color = Theme.accentHi
				ResizeKb()
			end)
		end

		local function UpdateToggle()
			tw(track, {BackgroundColor3 = On and Theme.accentHi or Theme.dim})
			tw(knob,  {Position = UDim2.new(0, On and (trackW - trackH + 3) or 3, 0.5, 0)})
			tw(lbl,   {TextColor3 = On and Theme.text or Theme.muted})
		end

		UserInputService.InputBegan:Connect(function(inp, gp)
			if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
			if Listening then
				Listening = false
				CK = inp.KeyCode ~= Enum.KeyCode.Escape and inp.KeyCode or nil
				if kb then
					kb.Text = CK and "[" .. GetKeyName(inp.KeyCode) .. "]" or "[?]"
					kb.TextColor3 = Theme.muted
					ks.Color = Theme.InElementBorder
					local sz = TextService:GetTextSize(kb.Text, 8, Enum.Font.GothamBold, Vector2.new(1e4, 1e4))
					local nw = math.max(32, sz.X + 12)
					kb.Size = UDim2.new(0, nw, 0, 16)
					kb.Position = UDim2.new(1, -(trackW + 10 + nw + 4), 0.5, 0)
				end
				return
			end
			if not gp and CK and inp.KeyCode == CK then
				On = not On
				UpdateToggle()
				task.spawn(function() pcall(cb, On) end)
				DoSync(syncKey, On, ctrl)
			end
		end)

		local hit = ni("TextButton", {
			Size                   = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text                   = "",
			BorderSizePixel        = 0,
			ZIndex                 = 10,
		}, f)

		local _pressed = false
		hit.MouseEnter:Connect(function() tw(f, {BackgroundColor3 = Theme.elemHov}) end)
		hit.MouseLeave:Connect(function() _pressed = false tw(f, {BackgroundColor3 = Theme.elem}) end)
		hit.MouseButton1Down:Connect(function() if not Listening then _pressed = true end end)
		hit.MouseButton1Up:Connect(function()
			if not _pressed or Listening then _pressed = false return end
			_pressed = false
			On = not On
			UpdateToggle()
			task.spawn(function() pcall(cb, On) end)
			DoSync(syncKey, On, ctrl)
		end)

		UpdateToggle()

		function ctrl:Set(v) On = v == true UpdateToggle() end
		function ctrl:Get() return On end
		function ctrl:Toggle() On = not On UpdateToggle() DoSync(syncKey, On, ctrl) task.spawn(function() pcall(cb, On) end) end
		function ctrl:SetLabel(t) lbl.Text = tostring(t or "") end
		function ctrl:GetLabel() return lbl.Text end
		function ctrl:SetCallback(fn) cb = fn or function() end end
		function ctrl:SetKey(k)
			CK = k
			if kb then kb.Text = k and "[" .. GetKeyName(k) .. "]" or "[?]" end
		end
		function ctrl:GetKey() return CK end
		function ctrl:SetVisible(v) f.Visible = v == true end
		function ctrl:GetVisible() return f.Visible end
		function ctrl:remove() f:Destroy() end

		RegSync(ctrl, syncKey)
		RegOpt(ctrl, "Toggle")
		return ctrl
	end

	function S:addButton(labelText, callback, iconName)
		local cb = callback or function() end
		local f = Base(32)

		local padL = 10
		local ico
		if iconName then
			ico = MkIcon(f, iconName, UDim2.new(0, 13, 0, 13), 10, 0, Theme.dim, 0, 0.5)
			if ico then padL = 28 end
		end

		local arrow = ni("ImageLabel", {
			BackgroundTransparency = 1,
			Image                  = "rbxassetid://10709791437",
			ImageColor3            = Theme.dim,
			Size                   = UDim2.new(0, 10, 0, 10),
			AnchorPoint            = Vector2.new(1, 0.5),
			Position               = UDim2.new(1, -10, 0.5, 0),
			ScaleType              = Enum.ScaleType.Fit,
		}, f)

		local lbl = ni("TextLabel", {
			Size                   = UDim2.new(1, -(padL + 18), 1, 0),
			Position               = UDim2.new(0, padL, 0, 0),
			BackgroundTransparency = 1,
			Text                   = labelText or "Button",
			TextColor3             = Theme.text,
			TextSize               = 11,
			Font                   = Enum.Font.GothamSemibold,
			TextXAlignment         = Enum.TextXAlignment.Left,
		}, f)

		local btn = ni("TextButton", {
			Size                   = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text                   = "",
			BorderSizePixel        = 0,
			ZIndex                 = 5,
		}, f)

		btn.MouseEnter:Connect(function()
			tw(f, {BackgroundColor3 = Theme.elemHov})
			tw(arrow, {ImageColor3 = Theme.accentHi})
			tw(lbl, {TextColor3 = Theme.accentHi})
			if ico then tw(ico, {ImageColor3 = Theme.accentHi}) end
		end)
		btn.MouseLeave:Connect(function()
			tw(f, {BackgroundColor3 = Theme.elem})
			tw(arrow, {ImageColor3 = Theme.dim})
			tw(lbl, {TextColor3 = Theme.text})
			if ico then tw(ico, {ImageColor3 = Theme.dim}) end
		end)
		btn.MouseButton1Down:Connect(function()
			tw(f, {BackgroundColor3 = Color3.fromRGB(40, 20, 60)})
		end)
		btn.MouseButton1Up:Connect(function()
			tw(f, {BackgroundColor3 = Theme.elem})
			task.spawn(function() pcall(cb) end)
		end)

		local ctrl = {}
		function ctrl:SetText(t) lbl.Text = tostring(t or "") end
		function ctrl:GetText() return lbl.Text end
		function ctrl:SetCallback(fn) cb = fn or function() end end
		function ctrl:SetVisible(v) f.Visible = v == true end
		function ctrl:GetVisible() return f.Visible end
		function ctrl:remove() f:Destroy() end
		return ctrl
	end

	function S:addSlider(labelText, mn, mx, def, callback, syncKey)
		local cb = callback or function() end
		mn = tonumber(mn) or 0
		mx = tonumber(mx) or 100
		local cur = math.clamp(tonumber(def) or mn, mn, mx)
		local f = Base(46)
		local ctrl = {}

		ni("TextLabel", {
			Size                   = UDim2.new(1, -55, 0, 18),
			Position               = UDim2.new(0, 10, 0, 4),
			BackgroundTransparency = 1,
			Text                   = labelText or "Slider",
			TextColor3             = Theme.text,
			TextSize               = 11,
			Font                   = Enum.Font.GothamSemibold,
			TextXAlignment         = Enum.TextXAlignment.Left,
		}, f)

		local valLbl = ni("TextLabel", {
			Size                   = UDim2.new(0, 44, 0, 18),
			Position               = UDim2.new(1, -48, 0, 4),
			BackgroundTransparency = 1,
			Text                   = tostring(cur),
			TextColor3             = Theme.muted,
			TextSize               = 11,
			Font                   = Enum.Font.GothamBold,
			TextXAlignment         = Enum.TextXAlignment.Right,
		}, f)

		local trackBg = ni("Frame", {
			Size             = UDim2.new(1, -16, 0, 4),
			Position         = UDim2.new(0, 8, 0, 32),
			BackgroundColor3 = Theme.sep,
			BorderSizePixel  = 0,
		}, f)
		corner(trackBg, 2)

		local ratio = (cur - mn) / (mx - mn)
		local fill = ni("Frame", {
			Size             = UDim2.new(ratio, 0, 1, 0),
			BackgroundColor3 = Theme.accentHi,
			BorderSizePixel  = 0,
		}, trackBg)
		corner(fill, 2)

		local knob = ni("Frame", {
			Size             = UDim2.fromOffset(12, 12),
			AnchorPoint      = Vector2.new(0.5, 0.5),
			Position         = UDim2.new(ratio, 0, 0.5, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel  = 0,
			ZIndex           = 3,
		}, trackBg)
		local kc2 = Instance.new("UICorner") kc2.CornerRadius = UDim.new(1,0) kc2.Parent = knob

		local hit = ni("TextButton", {
			Size                   = UDim2.new(1, 0, 0, 20),
			Position               = UDim2.new(0, 0, 0.5, -10),
			BackgroundTransparency = 1,
			Text                   = "",
			BorderSizePixel        = 0,
			ZIndex                 = 4,
		}, trackBg)

		local drag = false

		local function UpdateSlider(px)
			local p = math.clamp((px - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
			cur = math.floor(mn + (mx - mn) * p)
			fill.Size = UDim2.new(p, 0, 1, 0)
			knob.Position = UDim2.new(p, 0, 0.5, 0)
			valLbl.Text = tostring(cur)
			task.spawn(function() pcall(cb, cur) end)
			DoSync(syncKey, cur, ctrl)
		end

		hit.MouseButton1Down:Connect(function()
			drag = true
			UpdateSlider(UserInputService:GetMouseLocation().X)
		end)
		UserInputService.InputChanged:Connect(function(i)
			if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
				UpdateSlider(i.Position.X)
			end
		end)
		UserInputService.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
		end)
		f.MouseEnter:Connect(function() tw(f, {BackgroundColor3 = Theme.elemHov}) end)
		f.MouseLeave:Connect(function() tw(f, {BackgroundColor3 = Theme.elem}) end)

		function ctrl:Set(v)
			cur = math.clamp(tonumber(v) or mn, mn, mx)
			local p = (cur - mn) / (mx - mn)
			fill.Size = UDim2.new(p, 0, 1, 0)
			knob.Position = UDim2.new(p, 0, 0.5, 0)
			valLbl.Text = tostring(cur)
		end
		function ctrl:Get() return cur end
		function ctrl:Update(v) ctrl:Set(v) DoSync(syncKey, cur, ctrl) task.spawn(function() pcall(cb, cur) end) end
		function ctrl:SetLabel(t) end
		function ctrl:SetCallback(fn) cb = fn or function() end end
		function ctrl:SetVisible(v) f.Visible = v == true end
		function ctrl:GetVisible() return f.Visible end
		function ctrl:remove() f:Destroy() end

		RegSync(ctrl, syncKey)
		RegOpt(ctrl, "Slider")
		return ctrl
	end

	function S:addLabel(text)
		local f = Base(26, true)
		f.BackgroundTransparency = 1
		local lbl = ni("TextLabel", {
			Size                   = UDim2.new(1, -10, 1, 0),
			Position               = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text                   = text or "",
			TextColor3             = Theme.muted,
			TextSize               = 10,
			Font                   = Enum.Font.Gotham,
			TextXAlignment         = Enum.TextXAlignment.Left,
		}, f)
		local ctrl = {}
		function ctrl:Set(t) lbl.Text = tostring(t or "") end
		function ctrl:Get() return lbl.Text end
		function ctrl:SetColor(c) lbl.TextColor3 = c end
		function ctrl:SetVisible(v) f.Visible = v == true end
		function ctrl:remove() f:Destroy() end
		return ctrl
	end

	function S:addSeparator()
		elemCount = elemCount + 1
		local f = ni("Frame", {
			Size             = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = Theme.sep,
			BorderSizePixel  = 0,
			LayoutOrder      = elemCount,
		}, Content)
		local ctrl = {}
		function ctrl:SetVisible(v) f.Visible = v == true end
		function ctrl:remove() f:Destroy() end
		return ctrl
	end

	function S:addTextBox(labelText, placeholder, callback, syncKey)
		local cb = callback or function() end
		local f = Base(48)
		local ctrl = {}

		ni("TextLabel", {
			Size                   = UDim2.new(1, -10, 0, 16),
			Position               = UDim2.new(0, 10, 0, 5),
			BackgroundTransparency = 1,
			Text                   = labelText or "TextBox",
			TextColor3             = Theme.text,
			TextSize               = 11,
			Font                   = Enum.Font.GothamSemibold,
			TextXAlignment         = Enum.TextXAlignment.Left,
		}, f)

		local ibg = ni("Frame", {
			Size             = UDim2.new(1, -16, 0, 18),
			Position         = UDim2.new(0, 8, 0, 24),
			BackgroundColor3 = Theme.off,
			BorderSizePixel  = 0,
		}, f)
		corner(ibg, 4)
		local is = stroke(ibg, Theme.InElementBorder, 1)

		local inp = ni("TextBox", {
			Size                   = UDim2.new(1, -8, 1, 0),
			Position               = UDim2.new(0, 4, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel        = 0,
			Text                   = "",
			PlaceholderText        = placeholder or "",
			PlaceholderColor3      = Theme.dim,
			TextColor3             = Theme.text,
			TextSize               = 10,
			Font                   = Enum.Font.GothamSemibold,
			TextXAlignment         = Enum.TextXAlignment.Left,
			ClearTextOnFocus       = false,
		}, ibg)

		inp.Focused:Connect(function()
			tw(ibg, {BackgroundColor3 = Theme.elemHov})
			is.Color = Theme.accentHi
		end)
		inp.FocusLost:Connect(function()
			tw(ibg, {BackgroundColor3 = Theme.off})
			is.Color = Theme.InElementBorder
			task.spawn(function() pcall(cb, inp.Text) end)
			DoSync(syncKey, inp.Text, ctrl)
		end)
		f.MouseEnter:Connect(function() tw(f, {BackgroundColor3 = Theme.elemHov}) end)
		f.MouseLeave:Connect(function() if not inp:IsFocused() then tw(f, {BackgroundColor3 = Theme.elem}) end end)

		function ctrl:Get() return inp.Text end
		function ctrl:Set(v) inp.Text = tostring(v or "") end
		function ctrl:Clear() inp.Text = "" end
		function ctrl:Update(v) inp.Text = tostring(v or "") DoSync(syncKey, inp.Text, ctrl) task.spawn(function() pcall(cb, inp.Text) end) end
		function ctrl:SetCallback(fn) cb = fn or function() end end
		function ctrl:SetVisible(v) f.Visible = v == true end
		function ctrl:GetVisible() return f.Visible end
		function ctrl:remove() f:Destroy() end

		RegSync(ctrl, syncKey)
		RegOpt(ctrl, "TextBox")
		return ctrl
	end

	function S:addDropdown(labelText, list, callback, iconName, syncKey)
		local cb = callback or function() end
		local Selected = nil
		local Open = false
		local ctrl = {}

		elemCount = elemCount + 1
		local Wrapper = ni("Frame", {
			Size                   = UDim2.new(1, 0, 0, 32),
			BackgroundTransparency = 1,
			BorderSizePixel        = 0,
			LayoutOrder            = elemCount,
			ClipsDescendants       = false,
			ZIndex                 = 10,
		}, Content)

		if elemCount > 1 then
			ni("Frame", {
				Size             = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = Theme.sep,
				BorderSizePixel  = 0,
				ZIndex           = 2,
			}, Wrapper)
		end

		local Hdr = ni("Frame", {
			Size             = UDim2.new(1, 0, 0, 32),
			BackgroundColor3 = Theme.elem,
			BorderSizePixel  = 0,
			ZIndex           = 10,
		}, Wrapper)

		local padL = 10
		if iconName then
			local ic = MkIcon(Hdr, iconName, UDim2.new(0, 13, 0, 13), 10, 0, Theme.dim, 0, 0.5)
			if ic then ic.ZIndex = 11 padL = 28 end
		end

		ni("TextLabel", {
			Size                   = UDim2.new(0.52, -padL, 1, 0),
			Position               = UDim2.new(0, padL, 0, 0),
			BackgroundTransparency = 1,
			Text                   = labelText or "Dropdown",
			TextColor3             = Theme.text,
			TextSize               = 11,
			Font                   = Enum.Font.GothamSemibold,
			TextXAlignment         = Enum.TextXAlignment.Left,
			ZIndex                 = 11,
		}, Hdr)

		local selLbl = ni("TextLabel", {
			Size                   = UDim2.new(0.48, -26, 1, 0),
			Position               = UDim2.new(0.52, 0, 0, 0),
			BackgroundTransparency = 1,
			Text                   = "none",
			TextColor3             = Theme.muted,
			TextSize               = 10,
			Font                   = Enum.Font.Gotham,
			TextXAlignment         = Enum.TextXAlignment.Right,
			ZIndex                 = 11,
		}, Hdr)

		local arrow = ni("ImageLabel", {
			BackgroundTransparency = 1,
			Image                  = "rbxassetid://10709790948",
			ImageColor3            = Theme.accentHi,
			Size                   = UDim2.new(0, 11, 0, 11),
			AnchorPoint            = Vector2.new(1, 0.5),
			Position               = UDim2.new(1, -9, 0.5, 0),
			ScaleType              = Enum.ScaleType.Fit,
			ZIndex                 = 11,
		}, Hdr)

		local tH = math.min(#list * 26 + 8, 130)

		local DL = ni("Frame", {
			Size             = UDim2.new(1, 0, 0, 0),
			Position         = UDim2.new(0, 0, 0, 34),
			BackgroundColor3 = Theme.ddbg,
			BorderSizePixel  = 0,
			ZIndex           = 50,
			ClipsDescendants = true,
			Visible          = false,
		}, Wrapper)
		corner(DL, R)
		stroke(DL, Theme.InElementBorder, 1)

		local dlScroll = ni("ScrollingFrame", {
			Size                 = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel      = 0,
			ScrollBarThickness   = 2,
			ScrollBarImageColor3 = Theme.accentHi,
			ZIndex               = 51,
			CanvasSize           = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize  = Enum.AutomaticSize.Y,
		}, DL)

		ni("UIListLayout", {Parent = dlScroll, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
		ni("UIPadding", {Parent = dlScroll, PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4)})

		local function CloseDD()
			Open = false
			tw(arrow, {Rotation = 0})
			tw(DL, {Size = UDim2.new(1, 0, 0, 0)}, TI.Med)
			task.delay(0.18, function()
				DL.Visible = false
				Wrapper.Size = UDim2.new(1, 0, 0, 32)
			end)
		end

		local function OpenDD()
			Open = true
			tw(arrow, {Rotation = 180})
			DL.Visible = true
			tw(DL, {Size = UDim2.new(1, 0, 0, tH)}, TI.Med)
			Wrapper.Size = UDim2.new(1, 0, 0, 34 + tH)
		end

		local function BuildItems(itemList)
			for _, c in ipairs(dlScroll:GetChildren()) do
				if c:IsA("TextButton") then c:Destroy() end
			end
			tH = math.min(#itemList * 26 + 8, 130)
			for _, item in ipairs(itemList) do
				local opt = ni("TextButton", {
					Size             = UDim2.new(1, 0, 0, 22),
					BackgroundColor3 = Theme.elem,
					BorderSizePixel  = 0,
					AutoButtonColor  = false,
					Font             = Enum.Font.GothamSemibold,
					Text             = tostring(item),
					TextColor3       = item == Selected and Theme.accentHi or Theme.muted,
					TextSize         = 10,
					ZIndex           = 52,
				}, dlScroll)
				corner(opt, 4)
				opt.MouseEnter:Connect(function() tw(opt, {BackgroundColor3 = Theme.elemHov}) end)
				opt.MouseLeave:Connect(function()
					tw(opt, {BackgroundColor3 = Theme.elem})
					opt.TextColor3 = item == Selected and Theme.accentHi or Theme.muted
				end)
				opt.MouseButton1Click:Connect(function()
					Selected = item
					selLbl.Text = tostring(item)
					selLbl.TextColor3 = Theme.accentHi
					CloseDD()
					task.spawn(function() pcall(cb, item) end)
					DoSync(syncKey, item, ctrl)
				end)
			end
		end

		BuildItems(list)

		local hb = ni("TextButton", {
			Size                   = UDim2.new(1, 0, 0, 32),
			BackgroundTransparency = 1,
			Text                   = "",
			BorderSizePixel        = 0,
			ZIndex                 = 12,
		}, Wrapper)
		hb.MouseButton1Click:Connect(function() if Open then CloseDD() else OpenDD() end end)
		hb.MouseEnter:Connect(function() tw(Hdr, {BackgroundColor3 = Theme.elemHov}) end)
		hb.MouseLeave:Connect(function() tw(Hdr, {BackgroundColor3 = Theme.elem}) end)

		function ctrl:Set(v)
			Selected = v
			selLbl.Text = v and tostring(v) or "none"
			selLbl.TextColor3 = v and Theme.accentHi or Theme.muted
		end
		function ctrl:Get() return Selected end
		function ctrl:Clear() ctrl:Set(nil) end
		function ctrl:SetList(nl) BuildItems(nl) end
		function ctrl:Update(v) ctrl:Set(v) DoSync(syncKey, v, ctrl) task.spawn(function() pcall(cb, v) end) end
		function ctrl:SetCallback(fn) cb = fn or function() end end
		function ctrl:SetVisible(v) Wrapper.Visible = v == true end
		function ctrl:GetVisible() return Wrapper.Visible end
		function ctrl:remove() Wrapper:Destroy() end

		RegSync(ctrl, syncKey)
		RegOpt(ctrl, "Dropdown")
		return ctrl
	end

	function S:addKeybind(labelText, default, callback, syncKey)
		local cb = callback or function() end
		local CK = default
		local Listening = false
		local f = Base(32)
		local ctrl = {}

		ni("TextLabel", {
			Size                   = UDim2.new(0.6, -10, 1, 0),
			Position               = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text                   = labelText or "Keybind",
			TextColor3             = Theme.text,
			TextSize               = 11,
			Font                   = Enum.Font.GothamSemibold,
			TextXAlignment         = Enum.TextXAlignment.Left,
		}, f)

		local kb = ni("TextButton", {
			Size             = UDim2.new(0, 68, 0, 18),
			AnchorPoint      = Vector2.new(1, 0.5),
			Position         = UDim2.new(1, -8, 0.5, 0),
			BackgroundColor3 = Theme.keybg,
			BorderSizePixel  = 0,
			AutoButtonColor  = false,
			Font             = Enum.Font.GothamBold,
			Text             = CK and "[" .. GetKeyName(CK) .. "]" or "[NONE]",
			TextColor3       = Theme.muted,
			TextSize         = 9,
		}, f)
		corner(kb, 4)
		local ks = stroke(kb, Theme.InElementBorder, 1)

		local function Resize()
			local sz = TextService:GetTextSize(kb.Text, 9, Enum.Font.GothamBold, Vector2.new(1e4, 1e4))
			kb.Size = UDim2.new(0, math.max(68, sz.X + 16), 0, 18)
		end
		kb:GetPropertyChangedSignal("Text"):Connect(Resize)
		Resize()

		kb.MouseButton1Click:Connect(function()
			if Listening then return end
			Listening = true
			kb.Text = "[...]"
			kb.TextColor3 = Theme.accentHi
			ks.Color = Theme.accentHi
			Resize()
		end)

		UserInputService.InputBegan:Connect(function(inp, gp)
			if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
			if Listening then
				Listening = false
				CK = inp.KeyCode ~= Enum.KeyCode.Escape and inp.KeyCode or nil
				kb.Text = CK and "[" .. GetKeyName(inp.KeyCode) .. "]" or "[NONE]"
				kb.TextColor3 = Theme.muted
				ks.Color = Theme.InElementBorder
				Resize()
				DoSync(syncKey, CK, ctrl)
				return
			end
			if not gp and CK and inp.KeyCode == CK then
				task.spawn(function() pcall(cb, CK) end)
			end
		end)

		f.MouseEnter:Connect(function() tw(f, {BackgroundColor3 = Theme.elemHov}) end)
		f.MouseLeave:Connect(function() tw(f, {BackgroundColor3 = Theme.elem}) end)

		function ctrl:Set(k) CK = k if kb then kb.Text = k and "[" .. GetKeyName(k) .. "]" or "[NONE]" end Resize() end
		function ctrl:Get() return CK end
		function ctrl:Clear() ctrl:Set(nil) end
		function ctrl:Update(k) ctrl:Set(k) DoSync(syncKey, k, ctrl) task.spawn(function() pcall(cb, CK) end) end
		function ctrl:SetCallback(fn) cb = fn or function() end end
		function ctrl:SetVisible(v) f.Visible = v == true end
		function ctrl:GetVisible() return f.Visible end
		function ctrl:remove() f:Destroy() end

		RegSync(ctrl, syncKey)
		RegOpt(ctrl, "Keybind")
		return ctrl
	end

	function S:addColorPicker(labelText, default, callback, syncKey)
		local cb = callback or function() end
		local CurColor = (typeof(default) == "Color3") and default or Color3.fromRGB(255, 255, 255)
		local H, Sat, V = Color3.toHSV(CurColor)
		local Open = false
		local ctrl = {}

		local function ToHex(c)
			return string.format("#%02X%02X%02X", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255))
		end

		elemCount = elemCount + 1
		local Wrapper = ni("Frame", {
			Size                   = UDim2.new(1, 0, 0, 32),
			BackgroundTransparency = 1,
			BorderSizePixel        = 0,
			LayoutOrder            = elemCount,
			ClipsDescendants       = false,
			ZIndex                 = 10,
		}, Content)

		if elemCount > 1 then
			ni("Frame", {Size = UDim2.new(1,0,0,1), BackgroundColor3 = Theme.sep, BorderSizePixel = 0, ZIndex = 2}, Wrapper)
		end

		local Hdr = ni("Frame", {
			Size = UDim2.new(1,0,0,32), BackgroundColor3 = Theme.elem, BorderSizePixel = 0, ZIndex = 10
		}, Wrapper)

		local pic = MkIcon(Hdr, "palette", UDim2.new(0,13,0,13), 10, 0, Theme.dim, 0, 0.5)
		if pic then pic.ZIndex = 11 end

		ni("TextLabel", {
			Size = UDim2.new(0.5, -30, 1, 0), Position = UDim2.new(0, 28, 0, 0),
			BackgroundTransparency = 1, Text = labelText or "Color",
			TextColor3 = Theme.text, TextSize = 11, Font = Enum.Font.GothamSemibold,
			TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11,
		}, Hdr)

		local hexLbl = ni("TextLabel", {
			Size = UDim2.new(0.5, -30, 1, 0), Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1, Text = ToHex(CurColor),
			TextColor3 = Theme.muted, TextSize = 9, Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 11,
		}, Hdr)

		local prev = ni("Frame", {
			Size = UDim2.new(0,14,0,14), AnchorPoint = Vector2.new(1,0.5),
			Position = UDim2.new(1,-9,0.5,0), BackgroundColor3 = CurColor,
			BorderSizePixel = 0, ZIndex = 11,
		}, Hdr)
		corner(prev, 3) stroke(prev, Theme.InElementBorder, 1)

		local Panel = ni("Frame", {
			Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,0,34),
			BackgroundColor3 = Theme.ddbg, BorderSizePixel = 0,
			ClipsDescendants = true, Visible = false, ZIndex = 50,
		}, Wrapper)
		corner(Panel, R) stroke(Panel, Theme.InElementBorder, 1)

		local function Refresh()
			CurColor = Color3.fromHSV(H, Sat, V)
			prev.BackgroundColor3 = CurColor
			hexLbl.Text = ToHex(CurColor)
			task.spawn(function() pcall(cb, CurColor) end)
			DoSync(syncKey, CurColor, ctrl)
		end

		local chs = {
			{l="H", g=function() return H end,   s=function(v) H=v end,   m=360},
			{l="S", g=function() return Sat end, s=function(v) Sat=v end, m=100},
			{l="V", g=function() return V end,   s=function(v) V=v end,   m=100},
		}
		local panelH = #chs * 30 + 12

		for i, ch in ipairs(chs) do
			local row = ni("Frame", {
				BackgroundTransparency = 1, BorderSizePixel = 0,
				Position = UDim2.new(0,10,0, 8 + (i-1)*30), Size = UDim2.new(1,-20,0,24), ZIndex = 51,
			}, Panel)
			ni("TextLabel", {
				BackgroundTransparency=1, Size=UDim2.new(0,14,1,0), Font=Enum.Font.GothamBold,
				Text=ch.l, TextColor3=Theme.accentHi, TextSize=10, ZIndex=52,
			}, row)
			local rt = ni("Frame", {
				BackgroundColor3=Theme.sep, BorderSizePixel=0,
				Position=UDim2.new(0,20,0.5,-2), Size=UDim2.new(1,-58,0,4), ZIndex=51,
			}, row)
			corner(rt, 2)
			local rf = ni("Frame", {BackgroundColor3=Theme.accentHi, BorderSizePixel=0, Size=UDim2.new(ch.g(),0,1,0), ZIndex=52}, rt)
			corner(rf, 2)
			local rdot = ni("Frame", {
				AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.new(ch.g(),0,0.5,0),
				Size=UDim2.fromOffset(11,11), BackgroundColor3=Theme.accentHi, BorderSizePixel=0, ZIndex=53,
			}, rt)
			local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(1,0) rc.Parent = rdot
			ni("TextLabel", {
				BackgroundTransparency=1, Position=UDim2.new(1,-34,0,0), Size=UDim2.new(0,32,1,0),
				Font=Enum.Font.GothamBold, Text=tostring(math.floor(ch.g()*ch.m)),
				TextColor3=Theme.muted, TextSize=9, ZIndex=52,
			}, row)
			local rth = ni("TextButton", {
				BackgroundTransparency=1, Position=UDim2.new(0,20,0.5,-9),
				Size=UDim2.new(1,-58,0,20), Text="", ZIndex=54,
			}, row)
			local dr = false
			local function UpdX(px)
				local p = math.clamp((px - rt.AbsolutePosition.X) / rt.AbsoluteSize.X, 0, 1)
				rf.Size = UDim2.new(p,0,1,0) rdot.Position = UDim2.new(p,0,0.5,0)
				ch.s(p) Refresh()
			end
			rth.MouseButton1Down:Connect(function() dr = true UpdX(UserInputService:GetMouseLocation().X) end)
			UserInputService.InputChanged:Connect(function(inp)
				if dr and inp.UserInputType == Enum.UserInputType.MouseMovement then UpdX(inp.Position.X) end
			end)
			UserInputService.InputEnded:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 then dr = false end
			end)
		end

		local hb = ni("TextButton", {
			BackgroundTransparency=1, Size=UDim2.new(1,0,0,32), Text="", BorderSizePixel=0, ZIndex=12,
		}, Wrapper)
		hb.MouseEnter:Connect(function() tw(Hdr, {BackgroundColor3 = Theme.elemHov}) end)
		hb.MouseLeave:Connect(function() tw(Hdr, {BackgroundColor3 = Theme.elem}) end)
		hb.MouseButton1Click:Connect(function()
			Open = not Open
			if Open then
				Panel.Visible = true
				tw(Panel, {Size = UDim2.new(1,0,0,panelH)}, TI.Med)
				Wrapper.Size = UDim2.new(1,0,0, 34 + panelH)
			else
				tw(Panel, {Size = UDim2.new(1,0,0,0)}, TI.Med)
				task.delay(0.18, function() Panel.Visible = false Wrapper.Size = UDim2.new(1,0,0,32) end)
			end
		end)

		function ctrl:Set(c)
			if typeof(c) ~= "Color3" then return end
			CurColor = c H, Sat, V = Color3.toHSV(c)
			prev.BackgroundColor3 = c hexLbl.Text = ToHex(c)
		end
		function ctrl:Get() return CurColor end
		function ctrl:GetHex() return ToHex(CurColor) end
		function ctrl:Update(c) ctrl:Set(c) DoSync(syncKey, c, ctrl) task.spawn(function() pcall(cb, CurColor) end) end
		function ctrl:SetCallback(fn) cb = fn or function() end end
		function ctrl:SetVisible(v) Wrapper.Visible = v == true end
		function ctrl:GetVisible() return Wrapper.Visible end
		function ctrl:remove() Wrapper:Destroy() end

		RegSync(ctrl, syncKey)
		RegOpt(ctrl, "ColorPicker")
		return ctrl
	end

	function S:remove() Outer:Destroy() end

	return S
end

function Lib.new(config)
	config = config or {}

	local FOLDER         = config.Folder or "ecohub"
	local CONFIG_FOLDER  = FOLDER .. "/configs"
	local SaveIgnore     = {}
	local AutoSaveOn     = false
	local AutoSaveName   = "autosave"
	local AutoLoadOn     = true

	local function EnsureFolders()
		pcall(function()
			if not SafeIsDir(FOLDER)        then SafeFolder(FOLDER) end
			if not SafeIsDir(CONFIG_FOLDER) then SafeFolder(CONFIG_FOLDER) end
		end)
	end
	EnsureFolders()

	local function GetConfigList()
		local out = {}
		for _, file in ipairs(SafeList(CONFIG_FOLDER)) do
			if file:sub(-5) == ".json" then
				local n = file:match("[/\\]([^/\\]+)%.json$")
				if n and n ~= "autoload" then table.insert(out, n) end
			end
		end
		table.sort(out)
		return out
	end

	local function SaveConfig(name)
		if not name or name:gsub(" ","") == "" then return false, "name empty" end
		local data = {objects = {}}
		for idx, opt in next, Lib.Options do
			if SaveIgnore[idx] then continue end
			local ok, v = pcall(function() return opt:Get() end)
			if not ok then continue end
			local t = opt.Type
			if t == "Toggle" then
				table.insert(data.objects, {type="Toggle", idx=idx, value=v})
			elseif t == "Slider" then
				table.insert(data.objects, {type="Slider", idx=idx, value=v})
			elseif t == "Dropdown" then
				table.insert(data.objects, {type="Dropdown", idx=idx, value=v})
			elseif t == "TextBox" then
				table.insert(data.objects, {type="TextBox", idx=idx, value=v})
			elseif t == "ColorPicker" and typeof(v) == "Color3" then
				table.insert(data.objects, {type="ColorPicker", idx=idx, value=string.format("%02X%02X%02X", math.floor(v.R*255), math.floor(v.G*255), math.floor(v.B*255))})
			elseif t == "Keybind" and v then
				table.insert(data.objects, {type="Keybind", idx=idx, value=v.Name})
			end
		end
		local ok2, enc = pcall(function() return HttpService:JSONEncode(data) end)
		if not ok2 then return false, "encode failed" end
		local wrote = SafeWrite(CONFIG_FOLDER .. "/" .. name .. ".json", enc)
		if not wrote then return false, "write failed" end
		return true
	end

	local function LoadConfig(name)
		if not name then return false, "no name" end
		local content = SafeRead(CONFIG_FOLDER .. "/" .. name .. ".json")
		if not content then return false, "file not found" end
		local ok2, decoded = pcall(function() return HttpService:JSONDecode(content) end)
		if not ok2 then return false, "decode failed" end
		for _, obj in ipairs(decoded.objects or {}) do
			task.spawn(function()
				local opt = Lib.Options[obj.idx]
				if not opt then return end
				if obj.type == "Toggle" then
					opt:Set(obj.value == true or obj.value == "true")
				elseif obj.type == "Slider" then
					opt:Set(tonumber(obj.value) or 0)
				elseif obj.type == "Dropdown" then
					opt:Set(obj.value)
				elseif obj.type == "TextBox" then
					opt:Set(tostring(obj.value))
				elseif obj.type == "ColorPicker" and type(obj.value) == "string" and #obj.value == 6 then
					local ok3, c = pcall(function()
						return Color3.fromRGB(
							tonumber("0x"..obj.value:sub(1,2)),
							tonumber("0x"..obj.value:sub(3,4)),
							tonumber("0x"..obj.value:sub(5,6)))
					end)
					if ok3 and c then opt:Set(c) end
				elseif obj.type == "Keybind" and obj.value then
					local ok4, k = pcall(function() return Enum.KeyCode[obj.value] end)
					if ok4 and k then opt:Set(k) end
				end
			end)
		end
		return true
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
	corner(Main, 10)

	local TopBar = ni("Frame", {
		Size             = UDim2.new(1, 0, 0, TOPBAR),
		BackgroundColor3 = Theme.AcrylicMain,
		BorderSizePixel  = 0,
	}, Main)
	corner(TopBar, 10)
	ni("Frame", {
		Size             = UDim2.new(1, 0, 0, 10),
		Position         = UDim2.new(0, 0, 1, -10),
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
		Size = UDim2.new(1,-56,0,17), Position = UDim2.new(0,55,0.5,-18),
		BackgroundTransparency = 1, Text = LocalPlayer.DisplayName,
		TextColor3 = Theme.text, TextSize = 12, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
	}, UserBlock)
	ni("TextLabel", {
		Size = UDim2.new(1,-56,0,13), Position = UDim2.new(0,55,0.5,2),
		BackgroundTransparency = 1, Text = "@" .. LocalPlayer.Name,
		TextColor3 = Theme.muted, TextSize = 9, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
	}, UserBlock)

	local PageArea = ni("Frame", {
		Size             = UDim2.new(1, -16, 1, -TOPBAR - 60),
		Position         = UDim2.new(0, 8, 0, TOPBAR + 8),
		BackgroundColor3 = Theme.pageArea,
		BorderSizePixel  = 0,
		ClipsDescendants = true,
	}, Main)
	corner(PageArea, 8)

	local TABBAR_H = 52
	local TabBar = ni("Frame", {
		Size             = UDim2.new(1, 0, 0, TABBAR_H),
		Position         = UDim2.new(0, 0, 1, -TABBAR_H),
		BackgroundColor3 = Theme.tabbar,
		BorderSizePixel  = 0,
		ClipsDescendants = true,
	}, Main)
	corner(TabBar, 10)
	ni("Frame", {Size=UDim2.new(1,0,0,10), BackgroundColor3=Theme.tabbar, BorderSizePixel=0}, TabBar)
	ni("Frame", {Size=UDim2.new(1,0,0,1), BackgroundColor3=Theme.TitleBarLine, BorderSizePixel=0}, TabBar)

	local ICON_SIZE  = 18
	local SMALL_W    = 44
	local EXPANDED_W = 120
	local tabList    = {}
	local tabBtns    = {}
	local pages      = {}
	local curTab     = nil
	local animating  = false

	local function calcPositions(activeIdx)
		local expW = EXPANDED_W
		local total = expW + (#tabList - 1) * SMALL_W
		if total > W - 20 then
			expW = math.max(SMALL_W + 20, (W - 20) - (#tabList - 1) * SMALL_W)
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
		for i, t in ipairs(tabList) do if t.name == name then activeIdx = i break end end
		local positions = calcPositions(activeIdx)
		for i, tb in ipairs(tabBtns) do
			local active = tabList[i].name == name
			local p = positions[i]
			tw(tb.bg, {Position = UDim2.new(0,p.x,0,0), Size = UDim2.new(0,p.w,1,0)}, TI.Slow)
			if active then
				tw(tb.sq,  {BackgroundColor3 = Theme.accentLo}, TI.Med)
				tw(tb.str, {Color = Theme.accentHi, Thickness = 1.5}, TI.Med)
				tw(tb.img, {ImageColor3 = Theme.accentHi}, TI.Med)
				tw(tb.lbl, {TextColor3 = Theme.text,  TextTransparency = 0}, TI.Med)
				tw(tb.sub, {TextColor3 = Theme.muted, TextTransparency = 0}, TI.Med)
			else
				tw(tb.sq,  {BackgroundColor3 = Theme.card}, TI.Med)
				tw(tb.str, {Color = Theme.InElementBorder, Thickness = 1}, TI.Med)
				tw(tb.img, {ImageColor3 = Theme.dim}, TI.Med)
				tw(tb.lbl, {TextTransparency = 1}, TI.Fast)
				tw(tb.sub, {TextTransparency = 1}, TI.Fast)
			end
		end
	end

	local centerP = UDim2.new(0.5, -W/2, 0.5, -H/2)
	local miniS   = UDim2.new(0, W * 0.45, 0, 38)
	local miniP   = UDim2.new(0.5, -(W * 0.45)/2, 1, -48)

	local function showGui()
		if animating then return end
		animating = true
		Main.Visible = true
		Main.Size = miniS
		Main.Position = miniP
		Main.BackgroundTransparency = 0.6
		tw(Main, {Size=UDim2.new(0,W,0,H), Position=centerP, BackgroundTransparency=0}, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
		task.delay(0.44, function() animating = false end)
	end

	local function hideGui()
		if animating then return end
		animating = true
		tw(Main, {Size=UDim2.new(0,W,0,H*0.92), Position=UDim2.new(0.5,-W/2,0.5,-H*0.92/2), BackgroundTransparency=0.1}, TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.In))
		task.delay(0.13, function()
			tw(Main, {Size=miniS, Position=miniP, BackgroundTransparency=0.55}, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In))
		end)
		task.delay(0.43, function() tw(Main, {BackgroundTransparency=1}, TweenInfo.new(0.12)) end)
		task.delay(0.56, function()
			Main.Visible = false
			Main.Size = UDim2.new(0,W,0,H)
			Main.Position = centerP
			Main.BackgroundTransparency = 0
			animating = false
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
		local iconId  = cfg.Icon or ICONS["lucide-crosshair"]
		if type(iconId) == "string" and not iconId:match("rbxasset") then
			iconId = GetIconId(iconId) or ICONS["lucide-crosshair"]
		end

		local pg = ni("Frame", {
			Name = name, Size = UDim2.new(1,0,1,0),
			BackgroundTransparency = 1, Visible = false,
		}, PageArea)

		local PageScroll = ni("ScrollingFrame", {
			Size                 = UDim2.new(1,0,1,0),
			BackgroundTransparency = 1,
			BorderSizePixel      = 0,
			ScrollBarThickness   = 3,
			ScrollBarImageColor3 = Theme.accentHi,
			CanvasSize           = UDim2.new(0,0,0,0),
			AutomaticCanvasSize  = Enum.AutomaticSize.Y,
			ScrollingDirection   = Enum.ScrollingDirection.Y,
		}, pg)

		ni("UIListLayout", {Parent=PageScroll, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,6)})
		ni("UIPadding", {Parent=PageScroll, PaddingTop=UDim.new(0,8), PaddingBottom=UDim.new(0,8), PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8)})

		pages[name] = pg
		table.insert(tabList, {name = name, sub = subText, icon = iconId})

		local idx       = #tabList
		local positions = calcPositions(idx)

		for i, tb in ipairs(tabBtns) do
			local p = positions[i]
			tb.bg.Position = UDim2.new(0,p.x,0,0)
			tb.bg.Size     = UDim2.new(0,SMALL_W,1,0)
		end

		local p  = positions[idx]
		local bg = ni("Frame", {
			Size=UDim2.new(0,SMALL_W,1,0), Position=UDim2.new(0,p.x,0,0),
			BackgroundTransparency=1, BorderSizePixel=0, ClipsDescendants=true,
		}, TabBar)
		local sq = ni("Frame", {
			Size=UDim2.new(0,34,0,34), Position=UDim2.new(0,5,0.5,-17),
			BackgroundColor3=Theme.card, BorderSizePixel=0,
		}, bg)
		corner(sq, 8)
		local sqStr = ni("UIStroke", {Color=Theme.InElementBorder, Thickness=1}, sq)
		local img = ni("ImageLabel", {
			Size=UDim2.new(0,ICON_SIZE,0,ICON_SIZE), Position=UDim2.new(0.5,-ICON_SIZE/2,0.5,-ICON_SIZE/2),
			BackgroundTransparency=1, Image=iconId, ImageColor3=Theme.dim,
		}, sq)
		local lbl = ni("TextLabel", {
			Size=UDim2.new(1,-46,0,15), Position=UDim2.new(0,44,0.5,-13),
			BackgroundTransparency=1, Text=name, TextColor3=Theme.text,
			TextSize=11, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, TextTransparency=1,
		}, bg)
		local sub_lbl = ni("TextLabel", {
			Size=UDim2.new(1,-46,0,10), Position=UDim2.new(0,44,0.5,3),
			BackgroundTransparency=1, Text=subText, TextColor3=Theme.muted,
			TextSize=8, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left, TextTransparency=1,
		}, bg)
		local btn = ni("TextButton", {
			Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", BorderSizePixel=0, ZIndex=10,
		}, bg)

		tabBtns[idx] = {name=name, bg=bg, sq=sq, str=sqStr, img=img, lbl=lbl, sub=sub_lbl}

		btn.MouseButton1Click:Connect(function() switchTo(name) end)
		btn.MouseEnter:Connect(function()
			if curTab ~= name then
				tw(sq,  {BackgroundColor3=Color3.fromRGB(38,38,38)}, TI.Fast)
				tw(img, {ImageColor3=Theme.muted}, TI.Fast)
			end
		end)
		btn.MouseLeave:Connect(function()
			if curTab ~= name then
				tw(sq,  {BackgroundColor3=Theme.card}, TI.Fast)
				tw(img, {ImageColor3=Theme.dim}, TI.Fast)
			end
		end)

		if curTab == nil then task.delay(0.05, function() switchTo(name) end) end

		local tab = {}
		tab.Page = pg

		function tab:AddSection(sectionName)
			local ok, result = pcall(BuildSection, sectionName, PageScroll)
			if not ok then
				print("[LIB] AddSection error: " .. tostring(result))
				return setmetatable({}, {__index = function() return function() end end})
			end
			return result
		end

		return tab
	end

	function win:AddSettingsTab()
		local settingsTab = self:AddTab({
			Name = "Settings",
			Sub  = "config",
			Icon = "lucide-settings",
		})

		local secCfg = settingsTab:AddSection("Configurações")

		local cfgNameCtrl = secCfg:addTextBox("Nome do config", "meu_config", nil)

		local cfgListCtrl = secCfg:addDropdown("Configs salvos", GetConfigList(), nil, "folder-open")

		secCfg:addSeparator()

		secCfg:addButton("Salvar config", function()
			local n = cfgNameCtrl:Get()
			if not n or n:gsub(" ","") == "" then print("[LIB] Nome do config vazio") return end
			local ok, err = SaveConfig(n)
			if ok then
				cfgListCtrl:SetList(GetConfigList())
				cfgListCtrl:Set(n)
			else
				print("[LIB] Erro ao salvar: " .. tostring(err))
			end
		end, "save")

		secCfg:addButton("Carregar config", function()
			local n = cfgListCtrl:Get()
			if not n then print("[LIB] Nenhum config selecionado") return end
			local ok, err = LoadConfig(n)
			if ok then cfgNameCtrl:Set(n)
			else print("[LIB] Erro ao carregar: " .. tostring(err)) end
		end, "download")

		secCfg:addButton("Sobrescrever config", function()
			local n = cfgListCtrl:Get()
			if not n then return end
			SaveConfig(n)
		end, "edit-2")

		secCfg:addButton("Deletar config", function()
			local n = cfgListCtrl:Get()
			if not n then return end
			SafeDel(CONFIG_FOLDER .. "/" .. n .. ".json")
			cfgListCtrl:SetList(GetConfigList())
			cfgListCtrl:Set(nil)
		end, "trash-2")

		secCfg:addButton("Atualizar lista", function()
			cfgListCtrl:SetList(GetConfigList())
		end, "refresh-cw")

		local secAuto = settingsTab:AddSection("Auto Load / Save")

		local autoLoadCtrl = secAuto:addToggle("Auto Load ao iniciar", true, function(v)
			AutoLoadOn = v
		end)

		secAuto:addButton("Definir como autoload", function()
			local n = cfgListCtrl:Get()
			if not n then print("[LIB] Nenhum config selecionado para autoload") return end
			SafeWrite(CONFIG_FOLDER .. "/autoload.txt", n)
		end, "star")

		secAuto:addButton("Remover autoload", function()
			SafeDel(CONFIG_FOLDER .. "/autoload.txt")
		end, "x-circle")

		local autoSaveCtrl = secAuto:addToggle("Auto Save ao mudar", false, function(v)
			AutoSaveOn = v
		end)

		local secInfo = settingsTab:AddSection("Sistema")

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

		secInfo:addLabel("Executor: " .. detectExecutor())
		secInfo:addLabel("File System: " .. ((_writefile and _readfile) and "Suporte total" or "Parcial/Sem suporte"))
		secInfo:addLabel("Pasta: " .. FOLDER)

		local idxCfgName  = cfgNameCtrl._idx
		local idxCfgList  = cfgListCtrl._idx
		local idxAutoLoad = autoLoadCtrl._idx
		local idxAutoSave = autoSaveCtrl._idx
		if idxCfgName  then SaveIgnore[idxCfgName]  = true end
		if idxCfgList  then SaveIgnore[idxCfgList]  = true end
		if idxAutoLoad then SaveIgnore[idxAutoLoad] = true end
		if idxAutoSave then SaveIgnore[idxAutoSave] = true end

		task.spawn(function()
			task.wait(2)
			if not AutoLoadOn then return end
			local alContent = SafeRead(CONFIG_FOLDER .. "/autoload.txt")
			if not alContent then return end
			local alName = alContent:gsub("%s","")
			if alName == "" then return end
			local ok, err = LoadConfig(alName)
			if ok then
				cfgListCtrl:Set(alName)
				cfgNameCtrl:Set(alName)
			else
				print("[LIB] Auto-load falhou: " .. tostring(err))
			end
		end)

		return settingsTab
	end

	win.SaveConfig   = SaveConfig
	win.LoadConfig   = LoadConfig
	win.Icons        = ICONS

	return win
end

Lib.AutoLoad = {
	Check = function(folder)
		folder = folder or "ecohub"
		local path = folder .. "/configs/autoload.txt"
		local ok, v = pcall(function() return SafeRead(path) end)
		if not ok or not v then return false end
		return v:gsub("%s","") ~= ""
	end,
}

return Lib
