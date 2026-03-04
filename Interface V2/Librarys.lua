local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

local SAVE_KEY = "ecohub/universal/config.json"
local SaveData = {}

local function loadSave()
	local ok, data = pcall(function()
		return HttpService:JSONDecode(readfile(SAVE_KEY))
	end)
	SaveData = (ok and type(data) == "table") and data or {}
end

local function writeSave()
	local ok, err = pcall(function()
		if not isfolder("ecohub") then makefolder("ecohub") end
		if not isfolder("ecohub/universal") then makefolder("ecohub/universal") end
		writefile(SAVE_KEY, HttpService:JSONEncode(SaveData))
	end)
	if not ok then print("[EcoHub] " .. tostring(err)) end
end

local function getSaved(id, default)
	return SaveData[id] ~= nil and SaveData[id] or default
end

local function setSaved(id, value)
	SaveData[id] = value
	writeSave()
end

loadSave()

local ICONS = {
	aim="rbxassetid://10709818534",crosshair="rbxassetid://10709818534",
	target="rbxassetid://10734977012",swords="rbxassetid://10734975692",
	sword="rbxassetid://10734975486",flame="rbxassetid://10723376114",
	skull="rbxassetid://10734962068",shield="rbxassetid://10734951847",
	shieldCheck="rbxassetid://10734951367",shieldAlert="rbxassetid://10734951173",
	bomb="rbxassetid://10709781460",zap="rbxassetid://10723345749",
	visuals="rbxassetid://10723346959",eye="rbxassetid://10723346959",
	eyeOff="rbxassetid://10723346871",layers="rbxassetid://10723424505",
	palette="rbxassetid://10734910430",focus="rbxassetid://10723377537",
	vehicle="rbxassetid://10709789810",car="rbxassetid://10709789810",
	plane="rbxassetid://10734922971",rocket="rbxassetid://10734934585",
	navigation="rbxassetid://10734906744",move="rbxassetid://10734900011",
	wind="rbxassetid://10747382750",players="rbxassetid://10747373176",
	user="rbxassetid://10747373176",userCheck="rbxassetid://10747371901",
	userPlus="rbxassetid://10747372702",userX="rbxassetid://10747372992",
	users="rbxassetid://10747373426",contact="rbxassetid://10709811834",
	fingerprint="rbxassetid://10723375250",misc="rbxassetid://10723345749",
	star="rbxassetid://10734966248",crown="rbxassetid://10709818626",
	trophy="rbxassetid://10747363809",medal="rbxassetid://10734887072",
	ghost="rbxassetid://10723396107",alertTriangle="rbxassetid://10709753149",
	alertCircle="rbxassetid://10709752996",info="rbxassetid://10723415903",
	bell="rbxassetid://10709775704",bellOff="rbxassetid://10709775320",
	bellRing="rbxassetid://10709775560",config="rbxassetid://10734950309",
	settings="rbxassetid://10734950309",settings2="rbxassetid://10734950020",
	cog="rbxassetid://10709810948",sliders="rbxassetid://10734963400",
	wrench="rbxassetid://10747383470",tool="rbxassetid://10747383470",
	cpu="rbxassetid://10709813383",terminal="rbxassetid://10734982144",
	code="rbxassetid://10709810463",database="rbxassetid://10709818996",
	weapon="rbxassetid://10734975486",gauge="rbxassetid://10723395708",
	activity="rbxassetid://10709752035",lock="rbxassetid://10723434711",
	unlock="rbxassetid://10747366027",key="rbxassetid://10723416652",
	save="rbxassetid://10734941499",download="rbxassetid://10723344270",
	upload="rbxassetid://10747366434",trash="rbxassetid://10747362393",
	copy="rbxassetid://10709812159",refresh="rbxassetid://10734933222",
	search="rbxassetid://10734943674",filter="rbxassetid://10723375128",
	list="rbxassetid://10723433811",grid="rbxassetid://10723404936",
	home="rbxassetid://10723407389",compass="rbxassetid://10709811445",
	map="rbxassetid://10734886202",globe="rbxassetid://10723404337",
	network="rbxassetid://10734906975",barChart="rbxassetid://10709773755",
	lineChart="rbxassetid://10723426393",pieChart="rbxassetid://10734921727",
	trendingUp="rbxassetid://10747363465",trendingDown="rbxassetid://10747363205",
	siren="rbxassetid://10734961284",arrowUp="rbxassetid://10709768939",
	arrowDown="rbxassetid://10709767827",arrowLeft="rbxassetid://10709768114",
	arrowRight="rbxassetid://10709768347",check="rbxassetid://10709790644",
	checkCircle="rbxassetid://10709790387",checkSquare="rbxassetid://10709790537",
	x="rbxassetid://10747384394",xCircle="rbxassetid://10747383819",
	plus="rbxassetid://10734924532",minus="rbxassetid://10734896206",
	zoomIn="rbxassetid://10747384552",zoomOut="rbxassetid://10747384679",
	maximize="rbxassetid://10734886735",minimize="rbxassetid://10734895698",
	rotateCw="rbxassetid://10734940654",share="rbxassetid://10734950813",
	link="rbxassetid://10723426722",clipboard="rbxassetid://10709799288",
	edit="rbxassetid://10734883598",pencil="rbxassetid://10734919691",
	scissors="rbxassetid://10734942778",wifi="rbxassetid://10747382504",
	wifiOff="rbxassetid://10747382268",signal="rbxassetid://10734961133",
	battery="rbxassetid://10709774640",batteryFull="rbxassetid://10709774206",
	monitor="rbxassetid://10734896881",server="rbxassetid://10734949856",
	hardDrive="rbxassetid://10723405749",keyboard="rbxassetid://10723416765",
	laptop="rbxassetid://10723423881",camera="rbxassetid://10709789686",
	mic="rbxassetid://10734888864",micOff="rbxassetid://10734888646",
	volume="rbxassetid://10747376008",volumeX="rbxassetid://10747375880",
	headphones="rbxassetid://10723406165",music="rbxassetid://10734905958",
	play="rbxassetid://10734923549",pause="rbxassetid://10734919336",
	heart="rbxassetid://10723406885",heartOff="rbxassetid://10723406662",
	thumbsUp="rbxassetid://10734983629",thumbsDown="rbxassetid://10734983359",
	smile="rbxassetid://10734964441",frown="rbxassetid://10723394681",
	gift="rbxassetid://10723396402",package="rbxassetid://10734909540",
	shoppingBag="rbxassetid://10734952273",tag="rbxassetid://10734976528",
	banknote="rbxassetid://10709770178",coins="rbxassetid://10709811110",
	dollarSign="rbxassetid://10723343958",wallet="rbxassetid://10747376205",
	gem="rbxassetid://10723396000",award="rbxassetid://10709769406",
	bookmark="rbxassetid://10709782154",flag="rbxassetid://10723375890",
	folder="rbxassetid://10723387563",file="rbxassetid://10723374641",
	fileText="rbxassetid://10723367380",fileCode="rbxassetid://10723356507",
	mail="rbxassetid://10734885430",mailOpen="rbxassetid://10723435342",
	messageCircle="rbxassetid://10734888000",send="rbxassetid://10734943902",
	calendar="rbxassetid://10709789505",clock="rbxassetid://10709805144",
	timer="rbxassetid://10734984606",hourglass="rbxassetid://10723407498",
	history="rbxassetid://10723407335",sun="rbxassetid://10734974297",
	moon="rbxassetid://10734897102",cloud="rbxassetid://10709806740",
	cloudRain="rbxassetid://10709806277",snowflake="rbxassetid://10734964600",
	thermometer="rbxassetid://10734983134",droplet="rbxassetid://10723344432",
	waves="rbxassetid://10747376931",flame2="rbxassetid://10723376114",
	anchor="rbxassetid://10709761530",bus="rbxassetid://10709783137",
	train="rbxassetid://10747362105",truck="rbxassetid://10747364031",
	hammer="rbxassetid://10723405360",axe="rbxassetid://10709769508",
	ruler="rbxassetid://10734941018",magnet="rbxassetid://10723435069",
	microscope="rbxassetid://10734889106",atom="rbxassetid://10709769598",
	bot="rbxassetid://10709782230",hash="rbxassetid://10723405975",
	power="rbxassetid://10734930466",powerOff="rbxassetid://10734930257",
	loader="rbxassetid://10723434070",menu="rbxassetid://10734887784",
	layout="rbxassetid://10723425376",component="rbxassetid://10709811595",
	puzzle="rbxassetid://10734930886",wand="rbxassetid://10747376565",
	brush="rbxassetid://10709782758",bold="rbxassetid://10747813908",
	helpCircle="rbxassetid://10723406988",logIn="rbxassetid://10723434830",
	logOut="rbxassetid://10723434906",verified="rbxassetid://10747374131",
	accessibility="rbxassetid://10709751939",buttonArrow="rbxassetid://10709791437",
}

local T = {
	Accent       = Color3.fromRGB(130, 80, 200),
	AccentDark   = Color3.fromRGB(45, 20, 75),
	AccentMid    = Color3.fromRGB(90, 50, 150),
	AcrylicMain  = Color3.fromRGB(28, 28, 30),
	TitleLine    = Color3.fromRGB(60, 60, 65),
	ElemBorder   = Color3.fromRGB(52, 52, 58),
	bg           = Color3.fromRGB(18, 18, 20),
	card         = Color3.fromRGB(28, 28, 30),
	tabbar       = Color3.fromRGB(16, 16, 18),
	text         = Color3.fromRGB(225, 225, 230),
	muted        = Color3.fromRGB(110, 110, 120),
	dim          = Color3.fromRGB(50, 50, 58),
	section      = Color3.fromRGB(22, 22, 25),
	subSection   = Color3.fromRGB(28, 28, 32),
	elemBg       = Color3.fromRGB(33, 33, 38),
	elemHover    = Color3.fromRGB(44, 44, 52),
	dropBg       = Color3.fromRGB(24, 24, 28),
	toggleOff    = Color3.fromRGB(42, 42, 50),
	toggleOn     = Color3.fromRGB(130, 80, 200),
	success      = Color3.fromRGB(80, 200, 120),
	warning      = Color3.fromRGB(200, 160, 60),
	danger       = Color3.fromRGB(200, 70, 70),
}

local NOISE   = "rbxassetid://9968344919"
local S_TOP   = "rbxassetid://6276641225"
local S_MID   = "rbxassetid://6889812721"
local S_BOT   = "rbxassetid://6889812791"
local ARR_ICO = "rbxassetid://10709790948"
local LOGO_ID = "rbxassetid://134382458890933"

local W        = 680
local H        = 470
local TOPBAR   = 62
local TABBAR_H = 56
local ELEM_H   = 36
local PAD      = 6

local function ni(cls, props, par)
	local o = Instance.new(cls)
	for k,v in pairs(props) do pcall(function() o[k]=v end) end
	if par then o.Parent = par end
	return o
end

local function rnd(p, r)
	ni("UICorner",{CornerRadius=UDim.new(0,r or 8)},p)
end

local function tw(obj, props, dur, sty, dir)
	TweenService:Create(obj,
		TweenInfo.new(dur or 0.20, sty or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
		props):Play()
end

local function noise(par, alpha, z)
	return ni("ImageLabel",{
		Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
		Image=NOISE,ImageTransparency=alpha or 0.92,
		ScaleType=Enum.ScaleType.Tile,TileSize=UDim2.new(0,64,0,64),
		ZIndex=z or 1,
	},par)
end

local EcohubLibrarys = {}
EcohubLibrarys.Icons = ICONS

function EcohubLibrarys.new(config)
	config = config or {}

	if PlayerGui:FindFirstChild("EcoHubV2_Gui") then
		PlayerGui.EcoHubV2_Gui:Destroy()
	end

	local ScreenGui = ni("ScreenGui",{
		Name="EcoHubV2_Gui",ResetOnSpawn=false,
		ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
	},PlayerGui)

	local Main = ni("Frame",{
		Size=UDim2.new(0,W,0,H),
		Position=UDim2.new(0.5,-W/2,0.5,-H/2),
		BackgroundColor3=T.bg,BorderSizePixel=0,
		Active=true,Draggable=true,Visible=true,
		ClipsDescendants=true,
	},ScreenGui)
	rnd(Main,12)
	noise(Main,0.96,1)

	local DropOverlay = ni("Frame",{
		Size=UDim2.new(0,5000,0,5000),
		Position=UDim2.new(0,0,0,0),
		BackgroundTransparency=1,BorderSizePixel=0,
		ZIndex=900,Active=false,
	},ScreenGui)

	local TopBar = ni("Frame",{
		Size=UDim2.new(1,0,0,TOPBAR),
		BackgroundColor3=T.AcrylicMain,BorderSizePixel=0,ZIndex=2,
	},Main)
	rnd(TopBar,12)
	ni("Frame",{Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,1,-12),
		BackgroundColor3=T.AcrylicMain,BorderSizePixel=0,ZIndex=2},TopBar)
	noise(TopBar,0.90,3)
	ni("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),
		BackgroundColor3=T.TitleLine,BorderSizePixel=0,ZIndex=3},TopBar)

	ni("TextLabel",{
		Size=UDim2.new(0,220,1,0),Position=UDim2.new(0,14,0,0),
		BackgroundTransparency=1,Text=config.Title or "EcoHub",
		TextColor3=T.text,TextSize=16,Font=Enum.Font.GothamBold,
		TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,
	},TopBar)

	local logoSz = 54
	local logoF = ni("Frame",{
		Size=UDim2.new(0,logoSz,0,logoSz),
		Position=UDim2.new(0.5,-logoSz/2,0.5,-logoSz/2),
		BackgroundTransparency=1,ZIndex=4,
	},TopBar)
	ni("ImageLabel",{
		Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
		Image=LOGO_ID,ScaleType=Enum.ScaleType.Fit,ZIndex=4,
	},logoF)

	local bW = 160
	local UB = ni("Frame",{
		Size=UDim2.new(0,bW,0,TOPBAR),Position=UDim2.new(1,-bW,0,0),
		BackgroundTransparency=1,ZIndex=4,
	},TopBar)
	local AvF = ni("Frame",{
		Size=UDim2.new(0,32,0,32),Position=UDim2.new(0,10,0.5,-16),
		BackgroundColor3=T.elemBg,BorderSizePixel=0,ZIndex=4,
	},UB)
	rnd(AvF,8)
	local av = ni("ImageLabel",{
		Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
		Image="https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=60&height=60&format=png",
		ScaleType=Enum.ScaleType.Crop,ZIndex=5,
	},AvF)
	rnd(av,8)
	ni("TextLabel",{
		Size=UDim2.new(1,-50,0,14),Position=UDim2.new(0,48,0.5,-15),
		BackgroundTransparency=1,Text=LocalPlayer.DisplayName,
		TextColor3=T.text,TextSize=10,Font=Enum.Font.GothamBold,
		TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=4,
	},UB)
	ni("TextLabel",{
		Size=UDim2.new(1,-50,0,10),Position=UDim2.new(0,48,0.5,1),
		BackgroundTransparency=1,Text="@"..LocalPlayer.Name,
		TextColor3=T.muted,TextSize=8,Font=Enum.Font.Gotham,
		TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=4,
	},UB)

	local PageArea = ni("Frame",{
		Size=UDim2.new(1,-PAD*2,1,-TOPBAR-TABBAR_H-PAD*2),
		Position=UDim2.new(0,PAD,0,TOPBAR+PAD),
		BackgroundTransparency=1,BorderSizePixel=0,
	},Main)

	local TabBar = ni("Frame",{
		Size=UDim2.new(1,0,0,TABBAR_H),Position=UDim2.new(0,0,1,-TABBAR_H),
		BackgroundColor3=T.tabbar,BorderSizePixel=0,ClipsDescendants=true,ZIndex=5,
	},Main)
	rnd(TabBar,12)
	ni("Frame",{Size=UDim2.new(1,0,0,12),BackgroundColor3=T.tabbar,BorderSizePixel=0,ZIndex=5},TabBar)
	noise(TabBar,0.92,6)

	local ISMALL  = 20
	local TAB_SML = 48
	local TAB_EXP = 126
	local tabList = {}
	local tabBtns = {}
	local pages   = {}
	local curTab  = nil
	local anim    = false
	local openDD  = nil

	local function calcPos(ai)
		local n=math.max(1,#tabList)
		local avail=W-16
		local expW=TAB_EXP
		if expW+(n-1)*TAB_SML>avail then expW=math.max(TAB_SML+16,avail-(n-1)*TAB_SML) end
		local totalW=expW+(n-1)*TAB_SML
		local off=math.max(4,math.floor((W-totalW)/2))
		local pos,x={},off
		for i=1,n do
			local w=(i==ai) and expW or TAB_SML
			pos[i]={x=x,w=w} x=x+w
		end
		return pos
	end

	local function applyPos(ai,animate)
		local pos=calcPos(ai)
		for i,tb in ipairs(tabBtns) do
			local p=pos[i]
			if animate then
				tw(tb.bg,{Position=UDim2.new(0,p.x,0,0),Size=UDim2.new(0,p.w,1,0)},0.26,Enum.EasingStyle.Quint)
			else
				tb.bg.Position=UDim2.new(0,p.x,0,0)
				tb.bg.Size=UDim2.new(0,p.w,1,0)
			end
		end
	end

	local function switchTo(name)
		if curTab==name then return end
		if openDD then openDD() openDD=nil end
		if curTab and pages[curTab] then pages[curTab].Visible=false end
		curTab=name pages[name].Visible=true
		local ai=1
		for i,t in ipairs(tabList) do if t.name==name then ai=i break end end
		applyPos(ai,true)
		for i,tb in ipairs(tabBtns) do
			local on=tabList[i].name==name
			if on then
				tw(tb.sq,{BackgroundColor3=T.AccentDark},0.20)
				tw(tb.str,{Color=T.Accent,Thickness=1.5},0.20)
				tw(tb.img,{ImageColor3=T.Accent},0.20)
				tw(tb.lbl,{TextColor3=T.text,TextTransparency=0},0.20)
				tw(tb.sub,{TextColor3=T.muted,TextTransparency=0},0.20)
			else
				tw(tb.sq,{BackgroundColor3=T.card},0.20)
				tw(tb.str,{Color=T.ElemBorder,Thickness=1},0.20)
				tw(tb.img,{ImageColor3=T.dim},0.20)
				tw(tb.lbl,{TextTransparency=1},0.15)
				tw(tb.sub,{TextTransparency=1},0.15)
			end
		end
	end

	local function setVis(state)
		for _,v in ipairs(Main:GetChildren()) do
			if v:IsA("GuiObject") then v.Visible=state end
		end
	end

	local isVisible=true
	local toggleKey=config.Toggle or Enum.KeyCode.LeftAlt

	local function showGui()
		if anim then return end anim=true
		Main.Visible=true Main.BackgroundTransparency=1
		setVis(false)
		tw(Main,{BackgroundTransparency=0},0.22,Enum.EasingStyle.Quart)
		task.delay(0.08,function() setVis(true) end)
		task.delay(0.25,function() anim=false end)
	end

	local function hideGui()
		if anim then return end anim=true
		if openDD then openDD() openDD=nil end
		setVis(false)
		tw(Main,{BackgroundTransparency=1},0.18,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
		task.delay(0.20,function() Main.Visible=false anim=false end)
	end

	UserInputService.InputBegan:Connect(function(inp,proc)
		if proc then return end
		if inp.KeyCode==toggleKey or inp.KeyCode==Enum.KeyCode.RightAlt then
			isVisible=not isVisible
			if isVisible then showGui() else hideGui() end
		end
	end)

	local function buildElementContainer(parent, topOffset, indent)
		indent = indent or 0
		local padL = 5 + indent * 4

		local scroll = ni("ScrollingFrame",{
			Size=UDim2.new(1,-4,1,-topOffset),
			Position=UDim2.new(0,2,0,topOffset),
			BackgroundTransparency=1,BorderSizePixel=0,
			ScrollBarThickness=3,ScrollBarImageColor3=T.Accent,
			BottomImage=S_BOT,MidImage=S_MID,TopImage=S_TOP,
			CanvasSize=UDim2.new(0,0,0,0),
			ScrollingDirection=Enum.ScrollingDirection.Y,
			ClipsDescendants=true,ZIndex=2,
		},parent)

		local lay=Instance.new("UIListLayout")
		lay.SortOrder=Enum.SortOrder.LayoutOrder
		lay.Padding=UDim.new(0,3)
		lay.FillDirection=Enum.FillDirection.Vertical
		lay.HorizontalAlignment=Enum.HorizontalAlignment.Center
		lay.Parent=scroll

		local pad=Instance.new("UIPadding")
		pad.PaddingLeft=UDim.new(0,padL)
		pad.PaddingRight=UDim.new(0,5)
		pad.PaddingTop=UDim.new(0,5)
		pad.PaddingBottom=UDim.new(0,5)
		pad.Parent=scroll

		lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			scroll.CanvasSize=UDim2.new(0,0,0,lay.AbsoluteContentSize.Y+14)
		end)

		local sec={}
		sec.Scroll=scroll
		local rowN=0

		local function newRow(h)
			rowN=rowN+1
			local r=ni("Frame",{
				Size=UDim2.new(1,0,0,h),
				BackgroundColor3=T.elemBg,
				BorderSizePixel=0,LayoutOrder=rowN,ZIndex=3,
			},scroll)
			rnd(r,7)
			noise(r,0.94,4)
			ni("UIStroke",{
				Color=T.ElemBorder,
				Thickness=0.8,
				ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
			},r)
			return r
		end

		function sec:AddToggle(cfg)
			cfg=cfg or {}
			local label=cfg.Name or "Toggle"
			local saveId=cfg.SaveId or label
			local callback=cfg.Callback or function() end
			local state=getSaved(saveId,not not (cfg.Default or false))

			local row=newRow(ELEM_H)

			local icnF
			if cfg.Icon and cfg.Icon~="" then
				local iId=cfg.Icon
				if not iId:match("rbxasset") then iId=ICONS[iId] or iId end
				icnF=ni("ImageLabel",{
					Size=UDim2.new(0,14,0,14),Position=UDim2.new(0,10,0.5,-7),
					BackgroundTransparency=1,Image=iId,ImageColor3=T.muted,ZIndex=5,
				},row)
			end

			local txtX=(icnF and 28) or 10
			local titleLbl=ni("TextLabel",{
				Size=UDim2.new(1,-70,1,0),Position=UDim2.new(0,txtX,0,0),
				BackgroundTransparency=1,Text=label,
				TextColor3=T.text,TextSize=11,Font=Enum.Font.GothamSemibold,
				TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5,
			},row)

			local trkW,trkH=42,24
			local track=ni("Frame",{
				Size=UDim2.new(0,trkW,0,trkH),
				Position=UDim2.new(1,-trkW-8,0.5,-trkH/2),
				BackgroundColor3=state and T.toggleOn or T.toggleOff,
				BorderSizePixel=0,ZIndex=5,
			},row)
			rnd(track,trkH)
			ni("UIStroke",{Color=Color3.fromRGB(70,70,85),Thickness=0.7},track)

			local kSz=18
			local knob=ni("Frame",{
				Size=UDim2.new(0,kSz,0,kSz),
				Position=state
					and UDim2.new(1,-kSz-3,0.5,-kSz/2)
					or  UDim2.new(0,3,0.5,-kSz/2),
				BackgroundColor3=state and Color3.new(1,1,1) or Color3.fromRGB(150,150,165),
				BorderSizePixel=0,ZIndex=7,
			},track)
			rnd(knob,kSz)

			local function applyS(v)
				tw(track,{BackgroundColor3=v and T.toggleOn or T.toggleOff},0.18)
				tw(knob,{
					Position=v and UDim2.new(1,-kSz-3,0.5,-kSz/2) or UDim2.new(0,3,0.5,-kSz/2),
					BackgroundColor3=v and Color3.new(1,1,1) or Color3.fromRGB(150,150,165),
				},0.20,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
				if icnF then tw(icnF,{ImageColor3=v and T.Accent or T.muted},0.18) end
			end

			local btn=ni("TextButton",{
				Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
				Text="",BorderSizePixel=0,ZIndex=9,
			},row)
			btn.MouseButton1Click:Connect(function()
				state=not state applyS(state) setSaved(saveId,state) callback(state)
			end)
			btn.MouseEnter:Connect(function() tw(row,{BackgroundColor3=T.elemHover},0.1) end)
			btn.MouseLeave:Connect(function() tw(row,{BackgroundColor3=T.elemBg},0.1) end)

			local el={Value=state}
			function el:Set(v)
				state=not not v el.Value=state
				applyS(state) setSaved(saveId,state) callback(state)
			end
			function el:SetTitle(t) titleLbl.Text=t end
			function el:OnChanged(fn)
				local old=callback callback=function(val) old(val) fn(val) end fn(state)
			end
			applyS(state)
			task.defer(function() callback(state) end)
			return el
		end

		function sec:AddSlider(cfg)
			cfg=cfg or {}
			local label    = cfg.Name or "Slider"
			local saveId   = cfg.SaveId or label
			local minV     = cfg.Min or 0
			local maxV     = cfg.Max or 100
			local rounding = cfg.Rounding or 1
			local suffix   = cfg.Suffix or ""
			local callback = cfg.Callback or function() end

			local function rv(v)
				return math.floor(v / rounding + 0.5) * rounding
			end
			local value = getSaved(saveId, rv(math.clamp(cfg.Default or minV, minV, maxV)))

			-- Layout constants
			local ROW_H    = 56
			local RAIL_H   = 6
			local KNOB_W   = 18
			local KNOB_H   = 30
			local PAD_X    = 12

			-- row
			local row = newRow(ROW_H)

			-- label (top-left)
			local sliderTitleLbl=ni("TextLabel",{
				Size=UDim2.new(1,-74,0,15),
				Position=UDim2.new(0,PAD_X,0,7),
				BackgroundTransparency=1,
				Text=label,
				TextColor3=T.text,
				TextSize=11,
				Font=Enum.Font.GothamSemibold,
				TextXAlignment=Enum.TextXAlignment.Left,
				ZIndex=5,
			},row)

			-- value badge (top-right)
			local valFrame = ni("Frame",{
				Size=UDim2.new(0,52,0,19),
				Position=UDim2.new(1,-62,0,7),
				BackgroundColor3=Color3.fromRGB(15,15,19),
				BorderSizePixel=0,ZIndex=5,
			},row)
			rnd(valFrame,5)
			ni("UIStroke",{Color=T.ElemBorder,Thickness=0.7},valFrame)
			local valLbl = ni("TextLabel",{
				Size=UDim2.new(1,0,1,0),
				BackgroundTransparency=1,
				Text=tostring(rv(value))..suffix,
				TextColor3=T.Accent,
				TextSize=10,
				Font=Enum.Font.GothamBold,
				TextXAlignment=Enum.TextXAlignment.Center,
				ZIndex=6,
			},valFrame)

			-- track container — holds only the rail, NOT the knob
			-- offset by PAD_X on each side; knob lives in row directly
			local TRACK_X  = PAD_X
			local TRACK_R  = PAD_X
			local TRACK_Y  = ROW_H - RAIL_H - 10  -- distance from top of row

			local railBg = ni("Frame",{
				Size=UDim2.new(1,-(TRACK_X+TRACK_R),0,RAIL_H),
				Position=UDim2.new(0,TRACK_X,0,TRACK_Y),
				BackgroundColor3=Color3.fromRGB(36,36,46),
				BorderSizePixel=0,ZIndex=5,
				ClipsDescendants=true,  -- fill never overflows
			},row)
			rnd(railBg,RAIL_H)
			ni("UIStroke",{Color=Color3.fromRGB(52,52,65),Thickness=0.7},railBg)

			local pct = (value - minV) / (maxV - minV)

			local fill = ni("Frame",{
				Size=UDim2.new(pct,0,1,0),
				BackgroundColor3=T.Accent,
				BorderSizePixel=0,ZIndex=6,
			},railBg)
			rnd(fill,RAIL_H)
			local fillGrad = Instance.new("UIGradient")
			fillGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(88,42,152)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(158,102,230)),
			})
			fillGrad.Parent = fill

			-- knob parented to ROW — never clips out of rail
			local knob = ni("Frame",{
				Size=UDim2.new(0,KNOB_W,0,KNOB_H),
				AnchorPoint=Vector2.new(0.5,0.5),
				-- Y center = TRACK_Y + RAIL_H/2
				Position=UDim2.new(0, TRACK_X + pct * (row.AbsoluteSize.X - TRACK_X - TRACK_R), 0, TRACK_Y + RAIL_H/2),
				BackgroundColor3=Color3.fromRGB(240,240,248),
				BorderSizePixel=0,ZIndex=8,
			},row)
			rnd(knob,5)
			local knobStroke = ni("UIStroke",{Color=T.Accent,Thickness=1.8},knob)

			-- two grip lines inside knob
			for _, xOff in ipairs({-3,3}) do
				ni("Frame",{
					Size=UDim2.new(0,1,0,12),
					AnchorPoint=Vector2.new(0.5,0.5),
					Position=UDim2.new(0.5,xOff,0.5,0),
					BackgroundColor3=Color3.fromRGB(160,110,220),
					BorderSizePixel=0,ZIndex=9,
				},knob)
			end

			-- update visuals — knob position computed from AbsoluteSize
			local function applyValue(v)
				value = rv(math.clamp(v, minV, maxV))
				local p = (value - minV) / (maxV - minV)
				-- rail fill
				fill.Size = UDim2.new(p, 0, 1, 0)
				-- knob: needs to know actual pixel width of rail
				local railW = railBg.AbsoluteSize.X
				if railW > 0 then
					knob.Position = UDim2.new(0, TRACK_X + p * railW, 0, TRACK_Y + RAIL_H/2)
				end
				valLbl.Text = tostring(value)..suffix
				setSaved(saveId, value)
				callback(value)
			end

			-- reposition knob when layout resolves (first frame AbsoluteSize may be 0)
			row:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				local p = (value - minV) / (maxV - minV)
				local railW = railBg.AbsoluteSize.X
				if railW > 0 then
					knob.Position = UDim2.new(0, TRACK_X + p * railW, 0, TRACK_Y + RAIL_H/2)
				end
			end)

			local isDragging = false

			local function computeFromX(screenX)
				local abs = railBg.AbsolutePosition.X
				local sz  = railBg.AbsoluteSize.X
				if sz <= 0 then return end
				local rel = math.clamp((screenX - abs) / sz, 0, 1)
				applyValue(minV + rel * (maxV - minV))
			end

			local hitBtn = ni("TextButton",{
				Size=UDim2.new(1,0,1,0),
				BackgroundTransparency=1,
				Text="",BorderSizePixel=0,ZIndex=10,
			},row)

			hitBtn.MouseButton1Down:Connect(function(x)
				isDragging = true
				computeFromX(x)
			end)
			UserInputService.InputChanged:Connect(function(inp)
				if isDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
					computeFromX(inp.Position.X)
				end
			end)
			UserInputService.InputEnded:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 then
					isDragging = false
				end
			end)

			hitBtn.MouseEnter:Connect(function()
				tw(row,   {BackgroundColor3=T.elemHover}, 0.1)
				tw(knob,  {Size=UDim2.new(0,KNOB_W+2,0,KNOB_H+2)}, 0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
				tw(knobStroke, {Color=Color3.fromRGB(170,120,245), Thickness=2.2}, 0.12)
			end)
			hitBtn.MouseLeave:Connect(function()
				tw(row,  {BackgroundColor3=T.elemBg}, 0.1)
				if not isDragging then
					tw(knob, {Size=UDim2.new(0,KNOB_W,0,KNOB_H)}, 0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
					tw(knobStroke, {Color=T.Accent, Thickness=1.8}, 0.12)
				end
			end)

			-- initialise
			task.defer(function()
				applyValue(value)
				callback(value)
			end)

			local el = {Value=value}
			function el:Set(v)
				applyValue(v)
				el.Value = value
			end
			function el:SetTitle(t) sliderTitleLbl.Text=t end
			function el:OnChanged(fn)
				local old = callback
				callback = function(val) old(val) fn(val) end
				fn(value)
			end
			return el
		end

		function sec:AddKeybind(cfg)
			cfg=cfg or {}
			local label=cfg.Name or "Keybind"
			local saveId=cfg.SaveId or label
			local callback=cfg.Callback or function() end
			local savedName=getSaved(saveId,nil)
			local key=cfg.Default or Enum.KeyCode.Unknown
			if savedName then
				local ok,k=pcall(function() return Enum.KeyCode[savedName] end)
				if ok and k and k~=Enum.KeyCode.Unknown then key=k end
			end
			local listening=false
			local row=newRow(ELEM_H)

			local kbTitleLbl=ni("TextLabel",{
				Size=UDim2.new(1,-80,1,0),Position=UDim2.new(0,10,0,0),
				BackgroundTransparency=1,Text=label,
				TextColor3=T.text,TextSize=11,Font=Enum.Font.GothamSemibold,
				TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5,
			},row)

			local kBox=ni("Frame",{
				Size=UDim2.new(0,68,0,24),Position=UDim2.new(1,-74,0.5,-12),
				BackgroundColor3=Color3.fromRGB(20,20,24),BorderSizePixel=0,ZIndex=5,
			},row)
			rnd(kBox,5) noise(kBox,0.86,6)
			local kStr=ni("UIStroke",{Color=T.ElemBorder,Thickness=0.8},kBox)

			local function kname(k)
				if type(k)~="userdata" then return tostring(k) end
				local n=k.Name return n=="Unknown" and "?" or n
			end

			local kLbl=ni("TextLabel",{
				Size=UDim2.new(1,-4,1,0),Position=UDim2.new(0,2,0,0),
				BackgroundTransparency=1,Text="[ "..kname(key).." ]",
				TextColor3=T.Accent,TextSize=9,Font=Enum.Font.GothamBold,
				TextXAlignment=Enum.TextXAlignment.Center,
				TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=7,
			},kBox)

			local btn=ni("TextButton",{
				Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
				Text="",BorderSizePixel=0,ZIndex=8,
			},row)
			btn.MouseButton1Click:Connect(function()
				listening=true kLbl.Text="[ ... ]" kLbl.TextColor3=T.muted
				tw(kStr,{Color=T.Accent},0.12)
			end)
			btn.MouseEnter:Connect(function() tw(row,{BackgroundColor3=T.elemHover},0.1) end)
			btn.MouseLeave:Connect(function() tw(row,{BackgroundColor3=T.elemBg},0.1) end)

			UserInputService.InputBegan:Connect(function(inp,proc)
				if not listening then return end
				if inp.UserInputType==Enum.UserInputType.Keyboard then
					if inp.KeyCode==Enum.KeyCode.Escape then
						listening=false kLbl.Text="[ "..kname(key).." ]" kLbl.TextColor3=T.Accent
						tw(kStr,{Color=T.ElemBorder},0.12) return
					end
					listening=false key=inp.KeyCode
					kLbl.Text="[ "..kname(key).." ]" kLbl.TextColor3=T.Accent
					tw(kStr,{Color=T.ElemBorder},0.12)
					setSaved(saveId,key.Name) callback(key)
				end
			end)

			local el={Value=key}
			function el:Set(k)
				key=k el.Value=k kLbl.Text="[ "..kname(k).." ]"
				setSaved(saveId,type(k)=="userdata" and k.Name or tostring(k)) callback(key)
			end
			function el:SetTitle(t) kbTitleLbl.Text=t end
			function el:OnChanged(fn) local old=callback callback=function(val) old(val) fn(val) end fn(key) end
			task.defer(function() callback(key) end)
			return el
		end

		function sec:AddDropdown(cfg)
			cfg=cfg or {}
			local label=cfg.Name or "Dropdown"
			local saveId=cfg.SaveId or label
			local options=cfg.Options or {}
			local callback=cfg.Callback or function() end
			local selected=getSaved(saveId,cfg.Default or (options[1] or ""))
			local isOpen=false

			local MAX_VIS=6
			local OPT_H=32
			local DPAD=4

			local row=newRow(ELEM_H)

			local ddTitleLbl=ni("TextLabel",{
				Size=UDim2.new(1,-96,1,0),Position=UDim2.new(0,10,0,0),
				BackgroundTransparency=1,Text=label,
				TextColor3=T.text,TextSize=11,Font=Enum.Font.GothamSemibold,
				TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5,
			},row)

			local selBox=ni("Frame",{
				Size=UDim2.new(0,82,0,24),Position=UDim2.new(1,-88,0.5,-12),
				BackgroundColor3=Color3.fromRGB(20,20,24),BorderSizePixel=0,ZIndex=5,
			},row)
			rnd(selBox,5) noise(selBox,0.86,6)
			local selStr=ni("UIStroke",{Color=T.ElemBorder,Thickness=0.8},selBox)

			local selLbl=ni("TextLabel",{
				Size=UDim2.new(1,-22,1,0),Position=UDim2.new(0,6,0,0),
				BackgroundTransparency=1,Text=selected,
				TextColor3=T.Accent,TextSize=9,Font=Enum.Font.GothamBold,
				TextXAlignment=Enum.TextXAlignment.Left,
				TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=7,
			},selBox)

			local arrIco=ni("ImageLabel",{
				Size=UDim2.new(0,14,0,14),Position=UDim2.new(1,-17,0.5,-7),
				BackgroundTransparency=1,Image=ARR_ICO,ImageColor3=T.muted,ZIndex=7,
			},selBox)

			local function getDropH()
				return math.min(#options,MAX_VIS)*OPT_H+DPAD*2
			end

			local dropBg=ni("Frame",{
				Size=UDim2.new(0,10,0,0),Position=UDim2.new(0,0,0,0),
				BackgroundColor3=T.dropBg,BorderSizePixel=0,
				ClipsDescendants=true,ZIndex=10,Visible=false,
			},DropOverlay)
			rnd(dropBg,7)
			ni("UIStroke",{Color=T.ElemBorder,Thickness=0.8},dropBg)
			noise(dropBg,0.88,11)

			local aLine=ni("Frame",{
				Size=UDim2.new(1,-14,0,1),Position=UDim2.new(0,7,0,0),
				BackgroundColor3=T.Accent,BorderSizePixel=0,ZIndex=13,
			},dropBg)
			local aGrad=Instance.new("UIGradient")
			aGrad.Color=ColorSequence.new({
				ColorSequenceKeypoint.new(0,T.dropBg),
				ColorSequenceKeypoint.new(0.15,T.Accent),
				ColorSequenceKeypoint.new(0.85,T.Accent),
				ColorSequenceKeypoint.new(1,T.dropBg),
			}) aGrad.Parent=aLine

			local optScr=ni("ScrollingFrame",{
				Size=UDim2.new(1,-2,1,-DPAD*2),Position=UDim2.new(0,1,0,DPAD),
				BackgroundTransparency=1,BorderSizePixel=0,
				ScrollBarThickness=(#options>MAX_VIS) and 3 or 0,
				ScrollBarImageColor3=T.Accent,
				BottomImage=S_BOT,MidImage=S_MID,TopImage=S_TOP,
				CanvasSize=UDim2.new(0,0,0,#options*OPT_H),
				ScrollingDirection=Enum.ScrollingDirection.Y,
				ClipsDescendants=true,ZIndex=14,
			},dropBg)

			local optHolder=ni("Frame",{
				Size=UDim2.new(1,0,0,#options*OPT_H),
				BackgroundTransparency=1,ZIndex=15,
			},optScr)

			ni("UIListLayout",{
				SortOrder=Enum.SortOrder.LayoutOrder,
				Padding=UDim.new(0,0),
				FillDirection=Enum.FillDirection.Vertical,
			},optHolder)

			local optBtns={}
			local el={Value=selected}

			local function applySelected()
				for i2,ob in pairs(optBtns) do
					local iS=options[i2]==selected
					tw(ob.row,{BackgroundColor3=iS and T.AccentDark or T.dropBg},0.12)
					tw(ob.lbl,{TextColor3=iS and T.text or T.muted},0.12)
					ob.chk.Visible=iS
					ob.lbl.Font=iS and Enum.Font.GothamBold or Enum.Font.Gotham
				end
			end

			local function closeD()
				if not isOpen then return end
				isOpen=false
				if openDD==closeD then openDD=nil end
				tw(arrIco,{ImageColor3=T.muted,Rotation=0},0.14)
				tw(selStr,{Color=T.ElemBorder},0.12)
				local cW=dropBg.AbsoluteSize.X
				tw(dropBg,{Size=UDim2.new(0,cW,0,0)},0.14,Enum.EasingStyle.Quint,Enum.EasingDirection.In)
				task.delay(0.16,function() if not isOpen then dropBg.Visible=false end end)
			end

			local function openD()
				if openDD and openDD~=closeD then openDD() end
				isOpen=true openDD=closeD

				local rAbs=row.AbsolutePosition
				local rW=row.AbsoluteSize.X
				local screenH=ScreenGui.AbsoluteSize.Y
				local dropH=getDropH()

				local posY=rAbs.Y+ELEM_H+2
				if posY+dropH > screenH-10 then
					posY=rAbs.Y-dropH-2
				end

				dropBg.Size=UDim2.new(0,rW,0,0)
				dropBg.Position=UDim2.new(0,rAbs.X,0,posY)
				dropBg.Visible=true

				optScr.CanvasSize=UDim2.new(0,0,0,#options*OPT_H)
				optScr.ScrollBarThickness=(#options>MAX_VIS) and 3 or 0
				optScr.CanvasPosition=Vector2.new(0,0)

				tw(arrIco,{ImageColor3=T.Accent,Rotation=180},0.14)
				tw(selStr,{Color=T.Accent},0.12)
				tw(dropBg,{Size=UDim2.new(0,rW,0,dropH)},0.18,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
			end

			local function buildOpt(i2,opt)
				local isSel=opt==selected
				local optRow=ni("Frame",{
					Size=UDim2.new(1,0,0,OPT_H),
					BackgroundColor3=isSel and T.AccentDark or T.dropBg,
					BorderSizePixel=0,ZIndex=16,LayoutOrder=i2,
				},optHolder)

				local optLbl=ni("TextLabel",{
					Size=UDim2.new(1,-30,1,0),Position=UDim2.new(0,10,0,0),
					BackgroundTransparency=1,Text=opt,
					TextColor3=isSel and T.text or T.muted,
					TextSize=10,Font=isSel and Enum.Font.GothamBold or Enum.Font.Gotham,
					TextXAlignment=Enum.TextXAlignment.Left,ZIndex=17,
				},optRow)

				local chk=ni("ImageLabel",{
					Size=UDim2.new(0,13,0,13),Position=UDim2.new(1,-18,0.5,-6.5),
					BackgroundTransparency=1,Image=ICONS.check,
					ImageColor3=T.Accent,ZIndex=18,Visible=isSel,
				},optRow)

				if i2<#options then
					ni("Frame",{
						Size=UDim2.new(1,-10,0,1),Position=UDim2.new(0,5,1,-1),
						BackgroundColor3=T.dim,BackgroundTransparency=0.6,
						BorderSizePixel=0,ZIndex=17,
					},optRow)
				end

				local optBtn=ni("TextButton",{
					Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
					Text="",BorderSizePixel=0,ZIndex=22,
				},optRow)

				optBtns[i2]={row=optRow,lbl=optLbl,chk=chk}

				optBtn.MouseButton1Click:Connect(function()
					selected=opt selLbl.Text=opt el.Value=opt
					closeD() applySelected() setSaved(saveId,selected) callback(selected)
				end)
				optBtn.MouseEnter:Connect(function()
					if opt~=selected then
						tw(optRow,{BackgroundColor3=T.elemHover},0.08)
						tw(optLbl,{TextColor3=T.text},0.08)
					end
				end)
				optBtn.MouseLeave:Connect(function()
					if opt~=selected then
						tw(optRow,{BackgroundColor3=T.dropBg},0.08)
						tw(optLbl,{TextColor3=T.muted},0.08)
					end
				end)
			end

			for i2,opt in ipairs(options) do
				local ok,err=pcall(buildOpt,i2,opt)
				if not ok then print("[EcoHub] " .. tostring(err)) end
			end

			local togBtn=ni("TextButton",{
				Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
				Text="",BorderSizePixel=0,ZIndex=8,
			},row)
			togBtn.MouseButton1Click:Connect(function()
				if isOpen then closeD() else openD() end
			end)
			togBtn.MouseEnter:Connect(function() tw(row,{BackgroundColor3=T.elemHover},0.1) end)
			togBtn.MouseLeave:Connect(function() tw(row,{BackgroundColor3=T.elemBg},0.1) end)

			UserInputService.InputBegan:Connect(function(inp)
				if not isOpen then return end
				if inp.UserInputType~=Enum.UserInputType.MouseButton1
					and inp.UserInputType~=Enum.UserInputType.Touch then return end
				task.wait()
				local mx=UserInputService:GetMouseLocation().X
				local my=UserInputService:GetMouseLocation().Y
				local da=dropBg.AbsolutePosition local ds=dropBg.AbsoluteSize
				local ra=row.AbsolutePosition    local rs=row.AbsoluteSize
				local inD=mx>=da.X and mx<=da.X+ds.X and my>=da.Y and my<=da.Y+ds.Y
				local inR=mx>=ra.X and mx<=ra.X+rs.X and my>=ra.Y and my<=ra.Y+rs.Y
				if not inD and not inR then closeD() end
			end)

			function el:Set(v)
				selected=v selLbl.Text=v el.Value=v
				applySelected() setSaved(saveId,v) callback(v)
			end
			function el:SetOptions(newOpts)
				options=newOpts
				optBtns={}
				for _,ch in ipairs(optHolder:GetChildren()) do
					if not ch:IsA("UIListLayout") then ch:Destroy() end
				end
				optHolder.Size=UDim2.new(1,0,0,#options*OPT_H)
				optScr.CanvasSize=UDim2.new(0,0,0,#options*OPT_H)
				optScr.ScrollBarThickness=(#options>MAX_VIS) and 3 or 0
				for i2,opt in ipairs(options) do
					local ok,err=pcall(buildOpt,i2,opt)
					if not ok then print("[EcoHub] " .. tostring(err)) end
				end
			end
			function el:SetTitle(t) ddTitleLbl.Text=t end
			function el:OnChanged(fn) local old=callback callback=function(val) old(val) fn(val) end fn(selected) end
			task.defer(function() callback(selected) end)
			return el
		end

		function sec:AddButton(cfg)
			cfg=cfg or {}
			local label=cfg.Name or "Button"
			local desc=cfg.Description or ""
			local callback=cfg.Callback or function() end
			local color=cfg.Color or "accent"

			local rowH = desc~="" and ELEM_H+14 or ELEM_H
			local row=newRow(rowH)

			local btnColor = color=="danger" and T.danger or color=="success" and T.success or color=="warning" and T.warning or T.Accent

			local leftStrip=ni("Frame",{
				Size=UDim2.new(0,3,0,rowH-12),Position=UDim2.new(0,0,0,6),
				BackgroundColor3=btnColor,BorderSizePixel=0,ZIndex=4,
			},row)
			rnd(leftStrip,2)

			ni("TextLabel",{
				Size=UDim2.new(1,-44,0,desc~="" and 14 or rowH),
				Position=UDim2.new(0,12,0,desc~="" and 6 or 0),
				BackgroundTransparency=1,Text=label,
				TextColor3=T.text,TextSize=11,Font=Enum.Font.GothamBold,
				TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5,
			},row)

			if desc~="" then
				ni("TextLabel",{
					Size=UDim2.new(1,-44,0,11),Position=UDim2.new(0,12,0,21),
					BackgroundTransparency=1,Text=desc,
					TextColor3=T.muted,TextSize=9,Font=Enum.Font.Gotham,
					TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5,
				},row)
			end

			local arrImg=ni("ImageLabel",{
				Image=ICONS.buttonArrow,Size=UDim2.fromOffset(14,14),
				AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,0.5,0),
				BackgroundTransparency=1,ImageColor3=T.muted,ZIndex=6,
			},row)

			local btn=ni("TextButton",{
				Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
				Text="",BorderSizePixel=0,ZIndex=8,
			},row)
			btn.MouseButton1Click:Connect(function()
				tw(row,{BackgroundColor3=Color3.fromRGB(
					math.floor(btnColor.R*255*0.3),
					math.floor(btnColor.G*255*0.3),
					math.floor(btnColor.B*255*0.3)
				)},0.07)
				tw(arrImg,{ImageColor3=btnColor},0.07)
				tw(leftStrip,{BackgroundColor3=btnColor},0.07)
				task.delay(0.14,function()
					tw(row,{BackgroundColor3=T.elemBg},0.14)
					tw(arrImg,{ImageColor3=T.muted},0.14)
				end)
				callback()
			end)
			btn.MouseEnter:Connect(function()
				tw(row,{BackgroundColor3=T.elemHover},0.1)
				tw(arrImg,{ImageColor3=T.text},0.1)
			end)
			btn.MouseLeave:Connect(function()
				tw(row,{BackgroundColor3=T.elemBg},0.1)
				tw(arrImg,{ImageColor3=T.muted},0.1)
			end)

			local el={Frame=row}
			function el:SetTitle(t)
				for _,c in ipairs(row:GetChildren()) do
					if c:IsA("TextLabel") and c.ZIndex==5 and c.TextSize==11 then
						c.Text=t break
					end
				end
			end
			function el:SetDescription(d)
				for _,c in ipairs(row:GetChildren()) do
					if c:IsA("TextLabel") and c.ZIndex==5 and c.TextSize==9 then
						c.Text=d break
					end
				end
			end
			return el
		end

		function sec:AddLabel(cfg)
			cfg=cfg or {}
			local row=newRow(ELEM_H)

			local icnF
			if cfg.Icon and cfg.Icon~="" then
				local iId=cfg.Icon
				if not iId:match("rbxasset") then iId=ICONS[iId] or iId end
				icnF=ni("ImageLabel",{
					Size=UDim2.new(0,13,0,13),Position=UDim2.new(0,9,0.5,-6.5),
					BackgroundTransparency=1,Image=iId,ImageColor3=cfg.Color or T.muted,ZIndex=5,
				},row)
			end

			local txtX=(icnF and 26) or 10
			local lbl=ni("TextLabel",{
				Size=UDim2.new(1,-txtX-6,1,0),Position=UDim2.new(0,txtX,0,0),
				BackgroundTransparency=1,Text=cfg.Text or "Label",
				TextColor3=cfg.Color or T.muted,TextSize=10,Font=Enum.Font.Gotham,
				TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5,
			},row)
			local el={Frame=row}
			function el:Set(t,c)
				lbl.Text=t
				if c then lbl.TextColor3=c if icnF then icnF.ImageColor3=c end end
			end
			return el
		end

		function sec:AddParagraph(cfg)
			cfg=cfg or {}
			local title=cfg.Title or ""
			local text=cfg.Text or ""
			local lines=math.max(1,math.ceil(#text/26))
			local rowH=(title~="" and 16 or 0)+lines*13+14
			local row=newRow(rowH)
			if title~="" then
				ni("TextLabel",{
					Size=UDim2.new(1,-10,0,13),Position=UDim2.new(0,10,0,5),
					BackgroundTransparency=1,Text=title,
					TextColor3=T.Accent,TextSize=10,Font=Enum.Font.GothamBold,
					TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5,
				},row)
			end
			local txtLbl=ni("TextLabel",{
				Size=UDim2.new(1,-12,0,lines*13),
				Position=UDim2.new(0,10,0,title~="" and 20 or 6),
				BackgroundTransparency=1,Text=text,
				TextColor3=T.muted,TextSize=9,Font=Enum.Font.Gotham,
				TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,ZIndex=5,
			},row)
			local el={Frame=row}
			function el:Set(t) txtLbl.Text=t end
			function el:SetTitle(t)
				for _,c in ipairs(row:GetChildren()) do
					if c:IsA("TextLabel") and c.TextSize==10 and c.ZIndex==5 then c.Text=t break end
				end
			end
			return el
		end

		function sec:AddInput(cfg)
			cfg=cfg or {}
			local label=cfg.Name or "Input"
			local saveId=cfg.SaveId or label
			local placeholder=cfg.Placeholder or "Type here..."
			local callback=cfg.Callback or function() end
			local value=getSaved(saveId,cfg.Default or "")

			local row=newRow(ELEM_H+10)

			local inputTitleLbl=ni("TextLabel",{
				Size=UDim2.new(1,-10,0,13),Position=UDim2.new(0,10,0,4),
				BackgroundTransparency=1,Text=label,
				TextColor3=T.muted,TextSize=8,Font=Enum.Font.GothamBold,
				TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5,
			},row)

			local iBox=ni("TextBox",{
				Size=UDim2.new(1,-16,0,20),Position=UDim2.new(0,8,0,18),
				BackgroundColor3=Color3.fromRGB(18,18,22),BorderSizePixel=0,
				Text=value,PlaceholderText=placeholder,
				TextColor3=T.text,PlaceholderColor3=T.muted,
				TextSize=9,Font=Enum.Font.Gotham,
				TextXAlignment=Enum.TextXAlignment.Left,
				ClearTextOnFocus=false,ZIndex=6,
			},row)
			rnd(iBox,5) noise(iBox,0.86,7)
			local iStr=ni("UIStroke",{Color=T.ElemBorder,Thickness=0.8},iBox)
			ni("UIPadding",{PaddingLeft=UDim.new(0,6)},iBox)

			iBox.Focused:Connect(function() tw(iStr,{Color=T.Accent},0.12) end)
			iBox.FocusLost:Connect(function(ent)
				tw(iStr,{Color=T.ElemBorder},0.12)
				value=iBox.Text setSaved(saveId,value)
				if ent then callback(value) end
			end)
			iBox:GetPropertyChangedSignal("Text"):Connect(function() value=iBox.Text end)

			local el={Value=value}
			function el:Set(v) value=v iBox.Text=v el.Value=v setSaved(saveId,v) callback(v) end
			function el:SetTitle(t) inputTitleLbl.Text=t end
			function el:OnChanged(fn) local old=callback callback=function(val) old(val) fn(val) end fn(value) end
			return el
		end

		function sec:AddColorPicker(cfg)
			cfg=cfg or {}
			local label=cfg.Name or "Color"
			local saveId=cfg.SaveId or label
			local callback=cfg.Callback or function() end
			local savedC=getSaved(saveId,nil)
			local color=cfg.Default or Color3.fromRGB(130,80,200)
			if savedC and type(savedC)=="table" then
				local ok,c=pcall(function() return Color3.fromRGB(savedC.r or 130,savedC.g or 80,savedC.b or 200) end)
				if ok then color=c end
			end

			local isOpen=false
			local H_PCK=118
			rowN=rowN+1

			local wrapper=ni("Frame",{
				Size=UDim2.new(1,0,0,ELEM_H),BackgroundTransparency=1,
				BorderSizePixel=0,LayoutOrder=rowN,ClipsDescendants=false,
			},scroll)

			local row=ni("Frame",{
				Size=UDim2.new(1,0,0,ELEM_H),
				BackgroundColor3=T.elemBg,BorderSizePixel=0,ZIndex=3,
			},wrapper)
			rnd(row,7) noise(row,0.94,4)
			ni("UIStroke",{Color=T.ElemBorder,Thickness=0.8,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},row)

			local cpTitleLbl=ni("TextLabel",{
				Size=UDim2.new(1,-52,1,0),Position=UDim2.new(0,10,0,0),
				BackgroundTransparency=1,Text=label,
				TextColor3=T.text,TextSize=11,Font=Enum.Font.GothamSemibold,
				TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5,
			},row)

			local prev=ni("Frame",{
				Size=UDim2.new(0,26,0,26),Position=UDim2.new(1,-32,0.5,-13),
				BackgroundColor3=color,BorderSizePixel=0,ZIndex=5,
			},row)
			rnd(prev,6)
			ni("UIStroke",{Color=T.ElemBorder,Thickness=0.8},prev)

			local picker=ni("Frame",{
				Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,0,ELEM_H+3),
				BackgroundColor3=Color3.fromRGB(20,20,24),BorderSizePixel=0,
				ClipsDescendants=true,Visible=false,ZIndex=20,
			},wrapper)
			rnd(picker,7) ni("UIStroke",{Color=T.ElemBorder,Thickness=0.7},picker) noise(picker,0.92,21)

			local huebar=ni("Frame",{
				Size=UDim2.new(1,-14,0,14),Position=UDim2.new(0,7,0,8),
				BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=22,
			},picker)
			rnd(huebar,7)
			local hg=Instance.new("UIGradient")
			hg.Color=ColorSequence.new({
				ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),
				ColorSequenceKeypoint.new(0.167,Color3.fromRGB(255,255,0)),
				ColorSequenceKeypoint.new(0.333,Color3.fromRGB(0,255,0)),
				ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),
				ColorSequenceKeypoint.new(0.667,Color3.fromRGB(0,0,255)),
				ColorSequenceKeypoint.new(0.833,Color3.fromRGB(255,0,255)),
				ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0)),
			}) hg.Parent=huebar

			local hThumb=ni("Frame",{
				Size=UDim2.new(0,10,1,4),AnchorPoint=Vector2.new(0.5,0.5),
				Position=UDim2.new(0,0,0.5,0),BackgroundColor3=Color3.new(1,1,1),
				BorderSizePixel=0,ZIndex=24,
			},huebar)
			rnd(hThumb,4) ni("UIStroke",{Color=Color3.new(0,0,0),Thickness=1.5},hThumb)

			local satF=ni("Frame",{
				Size=UDim2.new(1,-14,0,64),Position=UDim2.new(0,7,0,30),
				BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=22,
			},picker)
			rnd(satF,6)
			ni("UIStroke",{Color=Color3.fromRGB(50,50,60),Thickness=0.6},satF)
			local sg=Instance.new("UIGradient")
			sg.Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromHSV(0,1,1)) sg.Parent=satF

			local svF=ni("Frame",{
				Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),
				BorderSizePixel=0,ZIndex=23,
			},satF)
			rnd(svF,6)
			local vg=Instance.new("UIGradient")
			vg.Color=ColorSequence.new(Color3.new(0,0,0),Color3.new(0,0,0))
			vg.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})
			vg.Rotation=90 vg.Parent=svF

			local sThumb=ni("Frame",{
				Size=UDim2.new(0,14,0,14),AnchorPoint=Vector2.new(0.5,0.5),
				Position=UDim2.new(0,0,0,0),BackgroundColor3=Color3.new(1,1,1),
				BorderSizePixel=0,ZIndex=25,
			},satF)
			rnd(sThumb,14) ni("UIStroke",{Color=Color3.new(0,0,0),Thickness=1.5},sThumb)

			local hexLbl=ni("TextBox",{
				Size=UDim2.new(1,-14,0,20),Position=UDim2.new(0,7,0,102),
				BackgroundColor3=Color3.fromRGB(18,18,22),BorderSizePixel=0,
				TextColor3=T.text,PlaceholderColor3=T.muted,
				TextSize=9,Font=Enum.Font.GothamBold,
				TextXAlignment=Enum.TextXAlignment.Center,
				ClearTextOnFocus=false,ZIndex=22,
			},picker)
			rnd(hexLbl,5)
			ni("UIStroke",{Color=T.ElemBorder,Thickness=0.7},hexLbl)

			local hH,sV,bV=Color3.toHSV(color)

			local function toHex(c)
				return string.format("#%02X%02X%02X",
					math.floor(c.R*255),math.floor(c.G*255),math.floor(c.B*255))
			end

			local function updateT()
				hThumb.Position=UDim2.new(hH,0,0.5,0)
				sThumb.Position=UDim2.new(sV,0,1-bV,0)
				sg.Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromHSV(hH,1,1))
				prev.BackgroundColor3=Color3.fromHSV(hH,sV,bV)
				hexLbl.Text=toHex(Color3.fromHSV(hH,sV,bV))
			end

			local function commit()
				color=Color3.fromHSV(hH,sV,bV)
				prev.BackgroundColor3=color
				setSaved(saveId,{r=math.floor(color.R*255),g=math.floor(color.G*255),b=math.floor(color.B*255)})
				callback(color)
			end

			local hDrag,sDrag=false,false
			local hBtn=ni("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=26},huebar)
			hBtn.MouseButton1Down:Connect(function(x) hDrag=true hH=math.clamp((x-huebar.AbsolutePosition.X)/huebar.AbsoluteSize.X,0,1) updateT() commit() end)
			hBtn.MouseButton1Up:Connect(function() hDrag=false end)
			local sBtn=ni("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=26},satF)
			sBtn.MouseButton1Down:Connect(function(x,y)
				sDrag=true
				sV=math.clamp((x-satF.AbsolutePosition.X)/satF.AbsoluteSize.X,0,1)
				bV=1-math.clamp((y-satF.AbsolutePosition.Y)/satF.AbsoluteSize.Y,0,1)
				updateT() commit()
			end)
			sBtn.MouseButton1Up:Connect(function() sDrag=false end)
			UserInputService.InputChanged:Connect(function(i)
				if i.UserInputType~=Enum.UserInputType.MouseMovement then return end
				if hDrag then hH=math.clamp((i.Position.X-huebar.AbsolutePosition.X)/huebar.AbsoluteSize.X,0,1) updateT() commit() end
				if sDrag then
					sV=math.clamp((i.Position.X-satF.AbsolutePosition.X)/satF.AbsoluteSize.X,0,1)
					bV=1-math.clamp((i.Position.Y-satF.AbsolutePosition.Y)/satF.AbsoluteSize.Y,0,1)
					updateT() commit()
				end
			end)
			UserInputService.InputEnded:Connect(function(i)
				if i.UserInputType==Enum.UserInputType.MouseButton1 then hDrag=false sDrag=false end
			end)

			hexLbl.FocusLost:Connect(function()
				local hex=hexLbl.Text:gsub("#","")
				if #hex==6 then
					local r=tonumber(hex:sub(1,2),16)
					local g=tonumber(hex:sub(3,4),16)
					local b=tonumber(hex:sub(5,6),16)
					if r and g and b then
						local c=Color3.fromRGB(r,g,b)
						hH,sV,bV=Color3.toHSV(c)
						updateT() commit()
					end
				end
				hexLbl.Text=toHex(color)
			end)

			local openBtn=ni("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",BorderSizePixel=0,ZIndex=8},row)
			openBtn.MouseButton1Click:Connect(function()
				isOpen=not isOpen
				if isOpen then
					picker.Visible=true picker.Size=UDim2.new(1,0,0,0)
					wrapper.Size=UDim2.new(1,0,0,ELEM_H+H_PCK+5)
					tw(picker,{Size=UDim2.new(1,0,0,H_PCK)},0.22,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
				else
					tw(picker,{Size=UDim2.new(1,0,0,0)},0.18,Enum.EasingStyle.Back,Enum.EasingDirection.In)
					task.delay(0.20,function() picker.Visible=false wrapper.Size=UDim2.new(1,0,0,ELEM_H) end)
				end
			end)
			openBtn.MouseEnter:Connect(function() tw(row,{BackgroundColor3=T.elemHover},0.1) end)
			openBtn.MouseLeave:Connect(function() tw(row,{BackgroundColor3=T.elemBg},0.1) end)

			updateT()
			local el={Value=color}
			function el:Set(c) color=c el.Value=c local h,s,v=Color3.toHSV(c) hH=h sV=s bV=v updateT() commit() end
			function el:SetTitle(t) cpTitleLbl.Text=t end
			function el:OnChanged(fn) local old=callback callback=function(val) old(val) fn(val) end fn(color) end
			task.defer(function() callback(color) end)
			return el
		end

		function sec:AddSubSection(cfg)
			cfg=cfg or {}
			local title=cfg.Title or ""
			local iconId=cfg.Icon or ""
			if iconId~="" and not iconId:match("rbxasset") then iconId=ICONS[iconId] or iconId end

			rowN=rowN+1
			local wrapper=ni("Frame",{
				Size=UDim2.new(1,0,0,ELEM_H),BackgroundTransparency=1,
				BorderSizePixel=0,LayoutOrder=rowN,ClipsDescendants=false,
			},scroll)

			local headerH=28
			local subContainer=ni("Frame",{
				Size=UDim2.new(1,0,0,headerH),
				BackgroundColor3=T.subSection,BorderSizePixel=0,ZIndex=3,
			},wrapper)
			rnd(subContainer,6) noise(subContainer,0.90,4)
			ni("UIStroke",{Color=T.ElemBorder,Thickness=0.7},subContainer)

			local expanded=false
			local arrF=ni("ImageLabel",{
				Size=UDim2.new(0,12,0,12),Position=UDim2.new(1,-18,0.5,-6),
				BackgroundTransparency=1,Image=ARR_ICO,ImageColor3=T.muted,ZIndex=6,
			},subContainer)

			if iconId~="" then
				ni("ImageLabel",{
					Size=UDim2.new(0,13,0,13),Position=UDim2.new(0,8,0.5,-6.5),
					BackgroundTransparency=1,Image=iconId,ImageColor3=T.Accent,ZIndex=5,
				},subContainer)
			end

			local tX=iconId~="" and 26 or 10
			ni("TextLabel",{
				Size=UDim2.new(1,-tX-22,1,0),Position=UDim2.new(0,tX,0,0),
				BackgroundTransparency=1,Text=title,
				TextColor3=T.muted,TextSize=9,Font=Enum.Font.GothamBold,
				TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5,
			},subContainer)

			local acLine=ni("Frame",{
				Size=UDim2.new(0,2,1,-8),Position=UDim2.new(0,3,0,4),
				BackgroundColor3=T.Accent,BackgroundTransparency=0.5,
				BorderSizePixel=0,ZIndex=4,
			},subContainer)
			rnd(acLine,1)

			local innerFrame=ni("Frame",{
				Size=UDim2.new(1,-6,0,0),Position=UDim2.new(0,6,0,headerH+2),
				BackgroundColor3=T.subSection,BorderSizePixel=0,
				ClipsDescendants=false,ZIndex=2,
			},wrapper)
			rnd(innerFrame,5)
			ni("Frame",{
				Size=UDim2.new(0,1,1,0),Position=UDim2.new(0,0,0,0),
				BackgroundColor3=T.Accent,BackgroundTransparency=0.6,
				BorderSizePixel=0,ZIndex=3,
			},innerFrame)

			local innerSec=buildElementContainer(innerFrame,0,1)
			local innerH=0

			innerSec.Scroll:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
				innerH=innerSec.Scroll.AbsoluteCanvasSize.Y
				if expanded then
					wrapper.Size=UDim2.new(1,0,0,headerH+2+innerH+4)
					innerFrame.Size=UDim2.new(1,-6,0,innerH+4)
				end
			end)

			local togBtn=ni("TextButton",{
				Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
				Text="",BorderSizePixel=0,ZIndex=7,
			},subContainer)

			togBtn.MouseButton1Click:Connect(function()
				expanded=not expanded
				if expanded then
					local h=math.max(innerH,10)
					wrapper.Size=UDim2.new(1,0,0,headerH+2+h+4)
					innerFrame.Size=UDim2.new(1,-6,0,0)
					innerFrame.Visible=true
					tw(innerFrame,{Size=UDim2.new(1,-6,0,h+4)},0.20,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
					tw(arrF,{Rotation=180},0.16)
					tw(subContainer,{BackgroundColor3=T.AccentDark},0.16)
					tw(acLine,{BackgroundTransparency=0},0.16)
				else
					tw(innerFrame,{Size=UDim2.new(1,-6,0,0)},0.16,Enum.EasingStyle.Quint,Enum.EasingDirection.In)
					tw(arrF,{Rotation=0},0.16)
					tw(subContainer,{BackgroundColor3=T.subSection},0.16)
					tw(acLine,{BackgroundTransparency=0.5},0.16)
					task.delay(0.18,function()
						innerFrame.Visible=false
						wrapper.Size=UDim2.new(1,0,0,headerH)
					end)
				end
			end)
			togBtn.MouseEnter:Connect(function() tw(subContainer,{BackgroundColor3=T.elemHover},0.1) end)
			togBtn.MouseLeave:Connect(function()
				tw(subContainer,{BackgroundColor3=expanded and T.AccentDark or T.subSection},0.1)
			end)

			return innerSec
		end

		return sec
	end

	local win={}

	function win:AddTab(cfg)
		cfg=cfg or {}
		local name=cfg.Name or ("Tab"..tostring(#tabList+1))
		local subText=cfg.Sub or ""
		local iconId=cfg.Icon or ICONS.aim
		if type(iconId)=="string" and not iconId:match("rbxasset") then
			iconId=ICONS[iconId] or ICONS.aim
		end

		local pg=ni("Frame",{
			Name=name,Size=UDim2.new(1,0,1,0),
			BackgroundTransparency=1,Visible=false,
		},PageArea)
		pages[name]=pg
		table.insert(tabList,{name=name,sub=subText,icon=iconId})
		local idx=#tabList

		local bg=ni("Frame",{
			Size=UDim2.new(0,TAB_SML,1,0),Position=UDim2.new(0,0,0,0),
			BackgroundTransparency=1,BorderSizePixel=0,ClipsDescendants=true,ZIndex=6,
		},TabBar)

		local sq=ni("Frame",{
			Size=UDim2.new(0,36,0,36),Position=UDim2.new(0,6,0.5,-18),
			BackgroundColor3=T.card,BorderSizePixel=0,ZIndex=7,
		},bg)
		rnd(sq,9) noise(sq,0.86,8)
		local sqStr=ni("UIStroke",{Color=T.ElemBorder,Thickness=1},sq)

		local img=ni("ImageLabel",{
			Size=UDim2.new(0,ISMALL,0,ISMALL),
			Position=UDim2.new(0.5,-ISMALL/2,0.5,-ISMALL/2),
			BackgroundTransparency=1,Image=iconId,ImageColor3=T.dim,ZIndex=9,
		},sq)

		local lbl=ni("TextLabel",{
			Size=UDim2.new(1,-48,0,14),Position=UDim2.new(0,46,0.5,-12),
			BackgroundTransparency=1,Text=name,
			TextColor3=T.text,TextSize=10,Font=Enum.Font.GothamBold,
			TextXAlignment=Enum.TextXAlignment.Left,TextTransparency=1,ZIndex=7,
		},bg)

		local sub_lbl=ni("TextLabel",{
			Size=UDim2.new(1,-48,0,9),Position=UDim2.new(0,46,0.5,2),
			BackgroundTransparency=1,Text=subText,
			TextColor3=T.muted,TextSize=8,Font=Enum.Font.Gotham,
			TextXAlignment=Enum.TextXAlignment.Left,TextTransparency=1,ZIndex=7,
		},bg)

		local btn=ni("TextButton",{
			Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
			Text="",BorderSizePixel=0,ZIndex=12,
		},bg)

		tabBtns[idx]={name=name,bg=bg,sq=sq,str=sqStr,img=img,lbl=lbl,sub=sub_lbl}

		applyPos(curTab and (function()
			for i,t in ipairs(tabList) do if t.name==curTab then return i end end return idx
		end)() or idx, false)

		btn.MouseButton1Click:Connect(function() switchTo(name) end)
		btn.MouseEnter:Connect(function()
			if curTab~=name then tw(sq,{BackgroundColor3=T.elemHover},0.1) tw(img,{ImageColor3=T.muted},0.1) end
		end)
		btn.MouseLeave:Connect(function()
			if curTab~=name then tw(sq,{BackgroundColor3=T.card},0.1) tw(img,{ImageColor3=T.dim},0.1) end
		end)

		local function makeSec(secName)
			local f=ni("Frame",{
				Name=secName,BackgroundColor3=T.section,
				BorderSizePixel=0,ClipsDescendants=false,
			},pg)
			noise(f,0.94,1)
			rnd(f,8)
			return f
		end

		local sL=makeSec("SectionLeft")
		local sC=makeSec("SectionCenter")
		local sR=makeSec("SectionRight")

		local function layout()
			local tW=PageArea.AbsoluteSize.X
			local tH=PageArea.AbsoluteSize.Y
			local gap=PAD
			local eW=math.floor((tW-gap*2)/3)
			sL.Position=UDim2.new(0,0,0,0) sL.Size=UDim2.new(0,eW,1,0)
			sC.Position=UDim2.new(0,eW+gap,0,0) sC.Size=UDim2.new(0,eW,1,0)
			sR.Position=UDim2.new(0,(eW+gap)*2,0,0) sR.Size=UDim2.new(0,eW,1,0)
		end
		layout()
		PageArea:GetPropertyChangedSignal("AbsoluteSize"):Connect(layout)

		local tab={}
		tab.Page=pg tab.SectionLeft=sL tab.SectionCenter=sC tab.SectionRight=sR

		function tab:AddSection(cfg2)
			cfg2=cfg2 or {}
			local side=cfg2.Side or "Left"
			local title=cfg2.Title or ""
			local icoId=cfg2.Icon or ""
			local target = side=="Left" and sL or side=="Center" and sC or sR

			if icoId~="" and not icoId:match("rbxasset") then icoId=ICONS[icoId] or icoId end

			local HEADER_H=title~="" and 36 or 0

			if title~="" then
				local tBar=ni("Frame",{
					Size=UDim2.new(1,0,0,HEADER_H),
					BackgroundColor3=T.section,BorderSizePixel=0,ZIndex=2,
				},target)
				local tX=12
				if icoId~="" then
					ni("ImageLabel",{
						Size=UDim2.new(0,14,0,14),Position=UDim2.new(0,10,0.5,-7),
						BackgroundTransparency=1,Image=icoId,ImageColor3=T.Accent,ZIndex=3,
					},tBar)
					tX=28
				end
				ni("TextLabel",{
					Size=UDim2.new(1,-tX-4,1,0),Position=UDim2.new(0,tX,0,0),
					BackgroundTransparency=1,Text=title,
					TextColor3=T.Accent,TextSize=10,Font=Enum.Font.GothamBold,
					TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,
				},tBar)
				ni("Frame",{
					Size=UDim2.new(1,-12,0,1),Position=UDim2.new(0,6,1,-1),
					BackgroundColor3=T.dim,BorderSizePixel=0,ZIndex=3,
				},tBar)
			end

			local sec=buildElementContainer(target,HEADER_H,0)
			return sec
		end

		if #tabList==1 then
			curTab=name pages[name].Visible=true applyPos(1,false)
			local tb=tabBtns[1]
			tb.sq.BackgroundColor3=T.AccentDark tb.str.Color=T.Accent tb.str.Thickness=1.5
			tb.img.ImageColor3=T.Accent tb.lbl.TextTransparency=0 tb.lbl.TextColor3=T.text
			tb.sub.TextTransparency=0 tb.sub.TextColor3=T.muted
		end

		return tab
	end

	return win
end

return EcohubLibrarys
