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
	if not ok then print("[EcoHub] writeSave error: " .. tostring(err)) end
	return ok
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
	aim                  = "rbxassetid://10709818534",
	crosshair            = "rbxassetid://10709818534",
	target               = "rbxassetid://10734977012",
	swords               = "rbxassetid://10734975692",
	sword                = "rbxassetid://10734975486",
	flame                = "rbxassetid://10723376114",
	skull                = "rbxassetid://10734962068",
	shield               = "rbxassetid://10734951847",
	shieldCheck          = "rbxassetid://10734951367",
	shieldAlert          = "rbxassetid://10734951173",
	shieldClose          = "rbxassetid://10734951535",
	shieldOff            = "rbxassetid://10734951684",
	bomb                 = "rbxassetid://10709781460",
	zap                  = "rbxassetid://10723345749",
	visuals              = "rbxassetid://10723346959",
	eye                  = "rbxassetid://10723346959",
	eyeOff               = "rbxassetid://10723346871",
	image                = "rbxassetid://10723415040",
	imageMinus           = "rbxassetid://10723414487",
	imageOff             = "rbxassetid://10723414677",
	imagePlus            = "rbxassetid://10723414827",
	layers               = "rbxassetid://10723424505",
	palette              = "rbxassetid://10734910430",
	paintbrush           = "rbxassetid://10734910187",
	paintbrush2          = "rbxassetid://10734910030",
	paintBucket          = "rbxassetid://10734909847",
	focus                = "rbxassetid://10723377537",
	scan                 = "rbxassetid://10734942565",
	scanFace             = "rbxassetid://10734942198",
	scanLine             = "rbxassetid://10734942351",
	vehicle              = "rbxassetid://10709789810",
	car                  = "rbxassetid://10709789810",
	bike                 = "rbxassetid://10709775894",
	plane                = "rbxassetid://10734922971",
	rocket               = "rbxassetid://10734934585",
	navigation           = "rbxassetid://10734906744",
	navigation2          = "rbxassetid://10734906332",
	navigation2Off       = "rbxassetid://10734906144",
	navigationOff        = "rbxassetid://10734906580",
	move                 = "rbxassetid://10734900011",
	move3d               = "rbxassetid://10734898756",
	moveDiagonal         = "rbxassetid://10734899164",
	moveDiagonal2        = "rbxassetid://10734898934",
	moveHorizontal       = "rbxassetid://10734899414",
	moveVertical         = "rbxassetid://10734899821",
	wind                 = "rbxassetid://10747382750",
	players              = "rbxassetid://10747373176",
	user                 = "rbxassetid://10747373176",
	userCheck            = "rbxassetid://10747371901",
	userCog              = "rbxassetid://10747372167",
	userMinus            = "rbxassetid://10747372346",
	userPlus             = "rbxassetid://10747372702",
	userX                = "rbxassetid://10747372992",
	users                = "rbxassetid://10747373426",
	contact              = "rbxassetid://10709811834",
	fingerprint          = "rbxassetid://10723375250",
	misc                 = "rbxassetid://10723345749",
	electricity          = "rbxassetid://10723345749",
	electricityOff       = "rbxassetid://10723345643",
	star                 = "rbxassetid://10734966248",
	starHalf             = "rbxassetid://10734965897",
	starOff              = "rbxassetid://10734966097",
	crown                = "rbxassetid://10709818626",
	trophy               = "rbxassetid://10747363809",
	medal                = "rbxassetid://10734887072",
	ghost                = "rbxassetid://10723396107",
	alertTriangle        = "rbxassetid://10709753149",
	alertCircle          = "rbxassetid://10709752996",
	alertOctagon         = "rbxassetid://10709753064",
	info                 = "rbxassetid://10723415903",
	bell                 = "rbxassetid://10709775704",
	bellMinus            = "rbxassetid://10709775241",
	bellOff              = "rbxassetid://10709775320",
	bellPlus             = "rbxassetid://10709775448",
	bellRing             = "rbxassetid://10709775560",
	config               = "rbxassetid://10734950309",
	settings             = "rbxassetid://10734950309",
	settings2            = "rbxassetid://10734950020",
	cog                  = "rbxassetid://10709810948",
	sliders              = "rbxassetid://10734963400",
	slidersHorizontal    = "rbxassetid://10734963191",
	wrench               = "rbxassetid://10747383470",
	tool                 = "rbxassetid://10747383470",
	cpu                  = "rbxassetid://10709813383",
	terminal             = "rbxassetid://10734982144",
	terminalSquare       = "rbxassetid://10734981995",
	code                 = "rbxassetid://10709810463",
	code2                = "rbxassetid://10709807111",
	database             = "rbxassetid://10709818996",
	weapon               = "rbxassetid://10734975486",
	crosshair2           = "rbxassetid://10709818534",
	gauge                = "rbxassetid://10723395708",
	activity             = "rbxassetid://10709752035",
	lock                 = "rbxassetid://10723434711",
	unlock               = "rbxassetid://10747366027",
	key                  = "rbxassetid://10723416652",
	save                 = "rbxassetid://10734941499",
	download             = "rbxassetid://10723344270",
	downloadCloud        = "rbxassetid://10723344088",
	upload               = "rbxassetid://10747366434",
	uploadCloud          = "rbxassetid://10747366266",
	trash                = "rbxassetid://10747362393",
	trash2               = "rbxassetid://10747362241",
	copy                 = "rbxassetid://10709812159",
	refresh              = "rbxassetid://10734933222",
	refreshCcw           = "rbxassetid://10734933056",
	search               = "rbxassetid://10734943674",
	filter               = "rbxassetid://10723375128",
	list                 = "rbxassetid://10723433811",
	listChecks           = "rbxassetid://10734884548",
	listEnd              = "rbxassetid://10723426886",
	listMinus            = "rbxassetid://10723426986",
	listOrdered          = "rbxassetid://10723427199",
	listPlus             = "rbxassetid://10723427334",
	listX                = "rbxassetid://10723433655",
	grid                 = "rbxassetid://10723404936",
	home                 = "rbxassetid://10723407389",
	compass              = "rbxassetid://10709811445",
	map                  = "rbxassetid://10734886202",
	mapPin               = "rbxassetid://10734886004",
	mapPinOff            = "rbxassetid://10734885803",
	globe                = "rbxassetid://10723404337",
	globe2               = "rbxassetid://10723398002",
	network              = "rbxassetid://10734906975",
	barChart             = "rbxassetid://10709773755",
	barChart2            = "rbxassetid://10709770317",
	barChart3            = "rbxassetid://10709770431",
	barChart4            = "rbxassetid://10709770560",
	barChartH            = "rbxassetid://10709773669",
	lineChart            = "rbxassetid://10723426393",
	pieChart             = "rbxassetid://10734921727",
	trendingUp           = "rbxassetid://10747363465",
	trendingDown         = "rbxassetid://10747363205",
	siren                = "rbxassetid://10734961284",
	arrowUp              = "rbxassetid://10709768939",
	arrowDown            = "rbxassetid://10709767827",
	arrowLeft            = "rbxassetid://10709768114",
	arrowRight           = "rbxassetid://10709768347",
	arrowUpDown          = "rbxassetid://10709768538",
	arrowLeftRight       = "rbxassetid://10709768019",
	check                = "rbxassetid://10709790644",
	checkCircle          = "rbxassetid://10709790387",
	checkCircle2         = "rbxassetid://10709790298",
	checkSquare          = "rbxassetid://10709790537",
	x                    = "rbxassetid://10747384394",
	xCircle              = "rbxassetid://10747383819",
	xSquare              = "rbxassetid://10747384217",
	plus                 = "rbxassetid://10734924532",
	plusCircle           = "rbxassetid://10734923868",
	plusSquare           = "rbxassetid://10734924219",
	minus                = "rbxassetid://10734896206",
	minusCircle          = "rbxassetid://10734895856",
	minusSquare          = "rbxassetid://10734896029",
	zoomIn               = "rbxassetid://10747384552",
	zoomOut              = "rbxassetid://10747384679",
	maximize             = "rbxassetid://10734886735",
	maximize2            = "rbxassetid://10734886496",
	minimize             = "rbxassetid://10734895698",
	minimize2            = "rbxassetid://10734895530",
	rotateCw             = "rbxassetid://10734940654",
	rotateCcw            = "rbxassetid://10734940376",
	refreshCw            = "rbxassetid://10734933222",
	share                = "rbxassetid://10734950813",
	share2               = "rbxassetid://10734950553",
	link                 = "rbxassetid://10723426722",
	link2                = "rbxassetid://10723426595",
	externalLink         = "rbxassetid://10723346684",
	clipboard            = "rbxassetid://10709799288",
	clipboardCheck       = "rbxassetid://10709798443",
	clipboardCopy        = "rbxassetid://10709798574",
	clipboardList        = "rbxassetid://10709798792",
	clipboardX           = "rbxassetid://10709799124",
	edit                 = "rbxassetid://10734883598",
	edit2                = "rbxassetid://10723344885",
	edit3                = "rbxassetid://10723345088",
	pencil               = "rbxassetid://10734919691",
	eraser               = "rbxassetid://10723346158",
	scissors             = "rbxassetid://10734942778",
	wifi                 = "rbxassetid://10747382504",
	wifiOff              = "rbxassetid://10747382268",
	bluetooth            = "rbxassetid://10709776655",
	bluetoothOff         = "rbxassetid://10709776344",
	signal               = "rbxassetid://10734961133",
	signalHigh           = "rbxassetid://10734954807",
	signalMedium         = "rbxassetid://10734955336",
	signalLow            = "rbxassetid://10734955080",
	signalZero           = "rbxassetid://10734960878",
	battery              = "rbxassetid://10709774640",
	batteryFull          = "rbxassetid://10709774206",
	batteryMedium        = "rbxassetid://10709774513",
	batteryLow           = "rbxassetid://10709774370",
	batteryCharging      = "rbxassetid://10709774068",
	monitor              = "rbxassetid://10734896881",
	monitorOff           = "rbxassetid://10734896360",
	server               = "rbxassetid://10734949856",
	serverCog            = "rbxassetid://10734944444",
	serverCrash          = "rbxassetid://10734944554",
	serverOff            = "rbxassetid://10734944668",
	hardDrive            = "rbxassetid://10723405749",
	keyboard             = "rbxassetid://10723416765",
	mouse                = "rbxassetid://10734898592",
	printer              = "rbxassetid://10734930632",
	smartphone           = "rbxassetid://10734963940",
	tablet               = "rbxassetid://10734976394",
	laptop               = "rbxassetid://10723423881",
	camera               = "rbxassetid://10709789686",
	cameraOff            = "rbxassetid://10747822677",
	mic                  = "rbxassetid://10734888864",
	mic2                 = "rbxassetid://10734888430",
	micOff               = "rbxassetid://10734888646",
	volume               = "rbxassetid://10747376008",
	volume1              = "rbxassetid://10747375450",
	volume2              = "rbxassetid://10747375679",
	volumeX              = "rbxassetid://10747375880",
	headphones           = "rbxassetid://10723406165",
	speaker              = "rbxassetid://10734965419",
	music                = "rbxassetid://10734905958",
	music2               = "rbxassetid://10734900215",
	play                 = "rbxassetid://10734923549",
	playCircle           = "rbxassetid://10734923214",
	pause                = "rbxassetid://10734919336",
	pauseCircle          = "rbxassetid://10735024209",
	stopCircle           = "rbxassetid://10734972621",
	skipBack             = "rbxassetid://10734961526",
	skipForward          = "rbxassetid://10734961809",
	rewind               = "rbxassetid://10734934347",
	fastForward          = "rbxassetid://10723354521",
	repeat1              = "rbxassetid://10734933826",
	shuffle              = "rbxassetid://10734953451",
	heart                = "rbxassetid://10723406885",
	heartCrack           = "rbxassetid://10723406299",
	heartOff             = "rbxassetid://10723406662",
	heartPulse           = "rbxassetid://10723406795",
	thumbsUp             = "rbxassetid://10734983629",
	thumbsDown           = "rbxassetid://10734983359",
	smile                = "rbxassetid://10734964441",
	smilePlus            = "rbxassetid://10734964188",
	frown                = "rbxassetid://10723394681",
	meh                  = "rbxassetid://10734887603",
	laugh                = "rbxassetid://10723424372",
	angry                = "rbxassetid://10709761629",
	annoyed              = "rbxassetid://10709761722",
	gift                 = "rbxassetid://10723396402",
	giftCard             = "rbxassetid://10723396225",
	package              = "rbxassetid://10734909540",
	package2             = "rbxassetid://10734908151",
	packageCheck         = "rbxassetid://10734908384",
	packageOpen          = "rbxassetid://10734908793",
	packagePlus          = "rbxassetid://10734909016",
	packageX             = "rbxassetid://10734909375",
	shoppingBag          = "rbxassetid://10734952273",
	shoppingCart         = "rbxassetid://10734952479",
	tag                  = "rbxassetid://10734976528",
	tags                 = "rbxassetid://10734976739",
	ticket               = "rbxassetid://10734983868",
	banknote             = "rbxassetid://10709770178",
	coins                = "rbxassetid://10709811110",
	dollarSign           = "rbxassetid://10723343958",
	euro                 = "rbxassetid://10723346372",
	wallet               = "rbxassetid://10747376205",
	piggyBank            = "rbxassetid://10734921935",
	gem                  = "rbxassetid://10723396000",
	award                = "rbxassetid://10709769406",
	bookmark             = "rbxassetid://10709782154",
	bookmarkMinus        = "rbxassetid://10709781919",
	bookmarkPlus         = "rbxassetid://10709782044",
	flag                 = "rbxassetid://10723375890",
	flagOff              = "rbxassetid://10723375443",
	folder               = "rbxassetid://10723387563",
	folderOpen           = "rbxassetid://10723386277",
	folderPlus           = "rbxassetid://10723386531",
	folderMinus          = "rbxassetid://10723386127",
	folderX              = "rbxassetid://10723387448",
	folderCheck          = "rbxassetid://10723384605",
	folderLock           = "rbxassetid://10723386005",
	file                 = "rbxassetid://10723374641",
	fileText             = "rbxassetid://10723367380",
	fileCode             = "rbxassetid://10723356507",
	fileImage            = "rbxassetid://10723357790",
	filePlus             = "rbxassetid://10723365877",
	fileMinus            = "rbxassetid://10723365254",
	fileX                = "rbxassetid://10723374544",
	fileCheck            = "rbxassetid://10723356210",
	fileLock             = "rbxassetid://10723364957",
	fileSearch           = "rbxassetid://10723366550",
	fileEdit             = "rbxassetid://10723357495",
	mail                 = "rbxassetid://10734885430",
	mailCheck            = "rbxassetid://10723435182",
	mailOpen             = "rbxassetid://10723435342",
	mailPlus             = "rbxassetid://10723435443",
	mailX                = "rbxassetid://10734885247",
	mailWarning          = "rbxassetid://10734885015",
	messageCircle        = "rbxassetid://10734888000",
	messageSquare        = "rbxassetid://10734888228",
	send                 = "rbxassetid://10734943902",
	reply                = "rbxassetid://10734934252",
	replyAll             = "rbxassetid://10734934132",
	forward              = "rbxassetid://10723388016",
	calendar             = "rbxassetid://10709789505",
	calendarCheck        = "rbxassetid://10709783474",
	calendarPlus         = "rbxassetid://10709788937",
	calendarMinus        = "rbxassetid://10709783959",
	calendarX            = "rbxassetid://10709789407",
	calendarClock        = "rbxassetid://10709783577",
	calendarDays         = "rbxassetid://10709783673",
	clock                = "rbxassetid://10709805144",
	timer                = "rbxassetid://10734984606",
	timerOff             = "rbxassetid://10734984138",
	timerReset           = "rbxassetid://10734984355",
	hourglass            = "rbxassetid://10723407498",
	history              = "rbxassetid://10723407335",
	sun                  = "rbxassetid://10734974297",
	moon                 = "rbxassetid://10734897102",
	cloud                = "rbxassetid://10709806740",
	cloudRain            = "rbxassetid://10709806277",
	cloudSnow            = "rbxassetid://10709806374",
	cloudLightning       = "rbxassetid://10709805727",
	snowflake            = "rbxassetid://10734964600",
	thermometer          = "rbxassetid://10734983134",
	droplet              = "rbxassetid://10723344432",
	droplets             = "rbxassetid://10734883356",
	waves                = "rbxassetid://10747376931",
	flame2               = "rbxassetid://10723376114",
	tornado              = "rbxassetid://10734985247",
	anchor               = "rbxassetid://10709761530",
	sailboat             = "rbxassetid://10734941354",
	bus                  = "rbxassetid://10709783137",
	train                = "rbxassetid://10747362105",
	truck                = "rbxassetid://10747364031",
	hammer               = "rbxassetid://10723405360",
	axe                  = "rbxassetid://10709769508",
	shovel               = "rbxassetid://10734952773",
	ruler                = "rbxassetid://10734941018",
	magnet               = "rbxassetid://10723435069",
	microscope           = "rbxassetid://10734889106",
	syringe              = "rbxassetid://10734975932",
	stethoscope          = "rbxassetid://10734966384",
	pill                 = "rbxassetid://10734922497",
	beaker               = "rbxassetid://10709774756",
	flaskConical         = "rbxassetid://10734883986",
	flaskRound           = "rbxassetid://10723376614",
	atom                 = "rbxassetid://10709769598",
	bot                  = "rbxassetid://10709782230",
	binary               = "rbxassetid://10709776050",
	hash                 = "rbxassetid://10723405975",
	percent              = "rbxassetid://10734919919",
	power                = "rbxassetid://10734930466",
	powerOff             = "rbxassetid://10734930257",
	toggleLeft           = "rbxassetid://10734984834",
	toggleRight          = "rbxassetid://10734985040",
	loader               = "rbxassetid://10723434070",
	loader2              = "rbxassetid://10723433935",
	moreHorizontal       = "rbxassetid://10734897250",
	moreVertical         = "rbxassetid://10734897387",
	menu                 = "rbxassetid://10734887784",
	sidebar              = "rbxassetid://10734954301",
	sidebarClose         = "rbxassetid://10734953715",
	sidebarOpen          = "rbxassetid://10734954000",
	layout               = "rbxassetid://10723425376",
	layoutDashboard      = "rbxassetid://10723424646",
	layoutGrid           = "rbxassetid://10723424838",
	layoutList           = "rbxassetid://10723424963",
	columns              = "rbxassetid://10709811261",
	rows                 = "rbxassetid://10709753570",
	table                = "rbxassetid://10734976230",
	table2               = "rbxassetid://10734976097",
	component            = "rbxassetid://10709811595",
	puzzle               = "rbxassetid://10734930886",
	penTool              = "rbxassetid://10734919503",
	wand                 = "rbxassetid://10747376565",
	wand2                = "rbxassetid://10747376349",
	brush                = "rbxassetid://10709782758",
	pipette              = "rbxassetid://10734922497",
	highlighter          = "rbxassetid://10723407192",
	bold                 = "rbxassetid://10747813908",
	italic               = "rbxassetid://10723416195",
	underline            = "rbxassetid://10747365191",
	strikethrough        = "rbxassetid://10734973290",
	quote                = "rbxassetid://10734931234",
	indent               = "rbxassetid://10723415494",
	outdent              = "rbxassetid://10734907933",
	wrapText             = "rbxassetid://10747383065",
	locate               = "rbxassetid://10723434557",
	locateFixed          = "rbxassetid://10723434236",
	locateOff            = "rbxassetid://10723434379",
	helpCircle           = "rbxassetid://10723406988",
	logIn                = "rbxassetid://10723434830",
	logOut               = "rbxassetid://10723434906",
	import               = "rbxassetid://10723415205",
	verified             = "rbxassetid://10747374131",
	accessibility        = "rbxassetid://10709751939",
	buttonArrow          = "rbxassetid://10709791437",
}

local Theme = {
	Accent          = Color3.fromRGB(72, 138, 182),
	AccentDark      = Color3.fromRGB(20, 50, 75),
	AcrylicMain     = Color3.fromRGB(30, 30, 30),
	AcrylicBorder   = Color3.fromRGB(60, 60, 60),
	TitleBarLine    = Color3.fromRGB(65, 65, 65),
	InElementBorder = Color3.fromRGB(55, 55, 55),
	bg              = Color3.fromRGB(20, 20, 20),
	card            = Color3.fromRGB(30, 30, 30),
	tabbar          = Color3.fromRGB(18, 18, 18),
	text            = Color3.fromRGB(220, 220, 220),
	muted           = Color3.fromRGB(120, 120, 120),
	dim             = Color3.fromRGB(55, 55, 55),
	section         = Color3.fromRGB(25, 25, 25),
	elemBg          = Color3.fromRGB(35, 35, 35),
	elemHover       = Color3.fromRGB(45, 45, 45),
	dropdownBg      = Color3.fromRGB(35, 35, 35),
	dropdownHolder  = Color3.fromRGB(28, 28, 28),
}

local NOISE_TEX  = "rbxassetid://9968344919"
local SCROLL_TOP = "rbxassetid://6276641225"
local SCROLL_MID = "rbxassetid://6889812721"
local SCROLL_BOT = "rbxassetid://6889812791"
local ARROW_ICO  = "rbxassetid://10709790948"

local W        = 660
local H        = 460
local TOPBAR   = 60
local TABBAR_H = 54
local ELEM_H   = 32
local PAD      = 6

local function ni(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do
		local ok, err = pcall(function() o[k] = v end)
		if not ok then print("[EcoHub] ni error " .. tostring(k) .. ": " .. tostring(err)) end
	end
	if parent then o.Parent = parent end
	return o
end

local function corner(p, r)
	ni("UICorner", { CornerRadius = UDim.new(0, r or 8) }, p)
end

local function tw(obj, props, dur, style, dir)
	TweenService:Create(obj,
		TweenInfo.new(dur or 0.22, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
		props):Play()
end

local function addTexture(parent, alpha, zidx)
	return ni("ImageLabel", {
		Size                   = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image                  = NOISE_TEX,
		ImageTransparency      = alpha or 0.92,
		ScaleType              = Enum.ScaleType.Tile,
		TileSize               = UDim2.new(0, 64, 0, 64),
		ZIndex                 = zidx or 0,
	}, parent)
end

local EcohubLibrarys = {}
EcohubLibrarys.Icons = ICONS

function EcohubLibrarys.new(config)
	config = config or {}

	if PlayerGui:FindFirstChild("EcoHubV2_Gui") then
		PlayerGui.EcoHubV2_Gui:Destroy()
	end

	local ScreenGui = ni("ScreenGui", {
		Name           = "EcoHubV2_Gui",
		ResetOnSpawn   = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, PlayerGui)

	local Main = ni("Frame", {
		Size             = UDim2.new(0, W, 0, H),
		Position         = UDim2.new(0.5, -W / 2, 0.5, -H / 2),
		BackgroundColor3 = Theme.bg,
		BorderSizePixel  = 0,
		Active           = true,
		Draggable        = true,
		Visible          = true,
		ClipsDescendants = true,
	}, ScreenGui)
	corner(Main, 12)
	addTexture(Main, 0.96, 1)

	local TopBar = ni("Frame", {
		Size             = UDim2.new(1, 0, 0, TOPBAR),
		BackgroundColor3 = Theme.AcrylicMain,
		BorderSizePixel  = 0,
		ZIndex           = 2,
	}, Main)
	corner(TopBar, 12)
	ni("Frame", {
		Size             = UDim2.new(1, 0, 0, 12),
		Position         = UDim2.new(0, 0, 1, -12),
		BackgroundColor3 = Theme.AcrylicMain,
		BorderSizePixel  = 0,
		ZIndex           = 2,
	}, TopBar)
	addTexture(TopBar, 0.90, 3)
	ni("Frame", {
		Size             = UDim2.new(1, 0, 0, 1),
		Position         = UDim2.new(0, 0, 1, -1),
		BackgroundColor3 = Theme.TitleBarLine,
		BorderSizePixel  = 0,
		ZIndex           = 3,
	}, TopBar)

	ni("TextLabel", {
		Size                   = UDim2.new(0, 200, 1, 0),
		Position               = UDim2.new(0, 14, 0, 0),
		BackgroundTransparency = 1,
		Text                   = config.Title or "EcoHub",
		TextColor3             = Theme.text,
		TextSize               = 16,
		Font                   = Enum.Font.GothamBold,
		TextXAlignment         = Enum.TextXAlignment.Left,
		ZIndex                 = 4,
	}, TopBar)

	local logoSize = 48
	local logoFrame = ni("Frame", {
		Size                   = UDim2.new(0, logoSize, 0, logoSize),
		Position               = UDim2.new(0.5, -logoSize / 2, 0.5, -logoSize / 2),
		BackgroundTransparency = 1,
		ZIndex                 = 4,
	}, TopBar)
	ni("ImageLabel", {
		Size                   = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image                  = config.Logo or "",
		ScaleType              = Enum.ScaleType.Fit,
		ZIndex                 = 4,
	}, logoFrame)

	local blockW    = 160
	local UserBlock = ni("Frame", {
		Size                   = UDim2.new(0, blockW, 0, TOPBAR),
		Position               = UDim2.new(1, -blockW, 0, 0),
		BackgroundTransparency = 1,
		ZIndex                 = 4,
	}, TopBar)

	local AvatarFrame = ni("Frame", {
		Size             = UDim2.new(0, 32, 0, 32),
		Position         = UDim2.new(0, 10, 0.5, -16),
		BackgroundColor3 = Theme.elemBg,
		BorderSizePixel  = 0,
		ZIndex           = 4,
	}, UserBlock)
	corner(AvatarFrame, 8)
	local av = ni("ImageLabel", {
		Size                   = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image                  = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=60&height=60&format=png",
		ScaleType              = Enum.ScaleType.Crop,
		ZIndex                 = 5,
	}, AvatarFrame)
	corner(av, 8)

	ni("TextLabel", {
		Size                   = UDim2.new(1, -50, 0, 14),
		Position               = UDim2.new(0, 48, 0.5, -15),
		BackgroundTransparency = 1,
		Text                   = LocalPlayer.DisplayName,
		TextColor3             = Theme.text,
		TextSize               = 10,
		Font                   = Enum.Font.GothamBold,
		TextXAlignment         = Enum.TextXAlignment.Left,
		TextTruncate           = Enum.TextTruncate.AtEnd,
		ZIndex                 = 4,
	}, UserBlock)
	ni("TextLabel", {
		Size                   = UDim2.new(1, -50, 0, 10),
		Position               = UDim2.new(0, 48, 0.5, 1),
		BackgroundTransparency = 1,
		Text                   = "@" .. LocalPlayer.Name,
		TextColor3             = Theme.muted,
		TextSize               = 8,
		Font                   = Enum.Font.Gotham,
		TextXAlignment         = Enum.TextXAlignment.Left,
		TextTruncate           = Enum.TextTruncate.AtEnd,
		ZIndex                 = 4,
	}, UserBlock)

	local PageArea = ni("Frame", {
		Size                   = UDim2.new(1, -PAD * 2, 1, -TOPBAR - TABBAR_H - PAD * 2),
		Position               = UDim2.new(0, PAD, 0, TOPBAR + PAD),
		BackgroundTransparency = 1,
		BorderSizePixel        = 0,
	}, Main)

	local TabBar = ni("Frame", {
		Size             = UDim2.new(1, 0, 0, TABBAR_H),
		Position         = UDim2.new(0, 0, 1, -TABBAR_H),
		BackgroundColor3 = Theme.tabbar,
		BorderSizePixel  = 0,
		ClipsDescendants = true,
		ZIndex           = 5,
	}, Main)
	corner(TabBar, 12)
	ni("Frame", {
		Size             = UDim2.new(1, 0, 0, 12),
		BackgroundColor3 = Theme.tabbar,
		BorderSizePixel  = 0,
		ZIndex           = 5,
	}, TabBar)
	addTexture(TabBar, 0.92, 6)

	local ICON_SIZE  = 20
	local SMALL_W    = 48
	local EXPANDED_W = 124
	local tabList    = {}
	local tabBtns    = {}
	local pages      = {}
	local curTab     = nil
	local animating  = false

	local function getExpW()
		local total = #tabList
		if total == 0 then return EXPANDED_W end
		local available = W - 16
		local expW = EXPANDED_W
		if expW + (total - 1) * SMALL_W > available then
			expW = math.max(SMALL_W + 16, available - (total - 1) * SMALL_W)
		end
		return expW
	end

	local function calcPositions(activeIdx)
		local total  = #tabList
		local expW   = getExpW()
		local totalW = expW + (total - 1) * SMALL_W
		local offset = math.max(4, math.floor((W - totalW) / 2))
		local pos    = {}
		local x      = offset
		for i = 1, total do
			local w = (i == activeIdx) and expW or SMALL_W
			pos[i]  = { x = x, w = w }
			x       = x + w
		end
		return pos, expW
	end

	local function applyPositions(activeIdx, animate)
		local positions = calcPositions(activeIdx)
		local dur       = animate and 0.26 or 0
		for i, tb in ipairs(tabBtns) do
			local p = positions[i]
			if animate then
				tw(tb.bg, { Position = UDim2.new(0, p.x, 0, 0), Size = UDim2.new(0, p.w, 1, 0) }, dur, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			else
				tb.bg.Position = UDim2.new(0, p.x, 0, 0)
				tb.bg.Size     = UDim2.new(0, p.w, 1, 0)
			end
		end
		return positions
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
		applyPositions(activeIdx, true)
		for i, tb in ipairs(tabBtns) do
			local active = tabList[i].name == name
			if active then
				tw(tb.sq,  { BackgroundColor3 = Theme.AccentDark },            0.22)
				tw(tb.str, { Color = Theme.Accent, Thickness = 1.5 },          0.22)
				tw(tb.img, { ImageColor3 = Theme.Accent },                     0.22)
				tw(tb.lbl, { TextColor3 = Theme.text, TextTransparency = 0 },  0.22)
				tw(tb.sub, { TextColor3 = Theme.muted, TextTransparency = 0 }, 0.22)
			else
				tw(tb.sq,  { BackgroundColor3 = Theme.card },                  0.22)
				tw(tb.str, { Color = Theme.InElementBorder, Thickness = 1 },   0.22)
				tw(tb.img, { ImageColor3 = Theme.dim },                        0.22)
				tw(tb.lbl, { TextTransparency = 1 },                           0.16)
				tw(tb.sub, { TextTransparency = 1 },                           0.16)
			end
		end
	end

	local function setChildrenVisible(state)
		for _, v in ipairs(Main:GetChildren()) do
			if v:IsA("GuiObject") then v.Visible = state end
		end
	end

	local function showGui()
		if animating then return end
		animating = true
		Main.Visible                = true
		Main.BackgroundTransparency = 1
		setChildrenVisible(false)
		tw(Main, { BackgroundTransparency = 0 }, 0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		task.delay(0.08, function() setChildrenVisible(true) end)
		task.delay(0.26, function() animating = false end)
	end

	local function hideGui()
		if animating then return end
		animating = true
		setChildrenVisible(false)
		tw(Main, { BackgroundTransparency = 1 }, 0.20, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		task.delay(0.22, function() Main.Visible = false animating = false end)
	end

	local visible   = true
	local toggleKey = config.Toggle or Enum.KeyCode.LeftAlt

	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.KeyCode == toggleKey or input.KeyCode == Enum.KeyCode.RightAlt then
			visible = not visible
			if visible then showGui() else hideGui() end
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
		table.insert(tabList, { name = name, sub = subText, icon = iconId })

		local idx = #tabList

		local bg = ni("Frame", {
			Size                   = UDim2.new(0, SMALL_W, 1, 0),
			Position               = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel        = 0,
			ClipsDescendants       = true,
			ZIndex                 = 6,
		}, TabBar)

		local sq = ni("Frame", {
			Size             = UDim2.new(0, 36, 0, 36),
			Position         = UDim2.new(0, 6, 0.5, -18),
			BackgroundColor3 = Theme.card,
			BorderSizePixel  = 0,
			ZIndex           = 7,
		}, bg)
		corner(sq, 9)
		addTexture(sq, 0.86, 8)
		local sqStr = ni("UIStroke", { Color = Theme.InElementBorder, Thickness = 1 }, sq)

		local img = ni("ImageLabel", {
			Size                   = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE),
			Position               = UDim2.new(0.5, -ICON_SIZE / 2, 0.5, -ICON_SIZE / 2),
			BackgroundTransparency = 1,
			Image                  = iconId,
			ImageColor3            = Theme.dim,
			ZIndex                 = 9,
		}, sq)

		local lbl = ni("TextLabel", {
			Size                   = UDim2.new(1, -48, 0, 14),
			Position               = UDim2.new(0, 46, 0.5, -12),
			BackgroundTransparency = 1,
			Text                   = name,
			TextColor3             = Theme.text,
			TextSize               = 10,
			Font                   = Enum.Font.GothamBold,
			TextXAlignment         = Enum.TextXAlignment.Left,
			TextTransparency       = 1,
			ZIndex                 = 7,
		}, bg)
		local sub_lbl = ni("TextLabel", {
			Size                   = UDim2.new(1, -48, 0, 9),
			Position               = UDim2.new(0, 46, 0.5, 2),
			BackgroundTransparency = 1,
			Text                   = subText,
			TextColor3             = Theme.muted,
			TextSize               = 8,
			Font                   = Enum.Font.Gotham,
			TextXAlignment         = Enum.TextXAlignment.Left,
			TextTransparency       = 1,
			ZIndex                 = 7,
		}, bg)

		local btn = ni("TextButton", {
			Size                   = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text                   = "",
			BorderSizePixel        = 0,
			ZIndex                 = 12,
		}, bg)

		tabBtns[idx] = { name = name, bg = bg, sq = sq, str = sqStr, img = img, lbl = lbl, sub = sub_lbl }

		applyPositions(curTab and (function()
			for i, t in ipairs(tabList) do if t.name == curTab then return i end end
			return idx
		end)() or idx, false)

		btn.MouseButton1Click:Connect(function() switchTo(name) end)
		btn.MouseEnter:Connect(function()
			if curTab ~= name then
				tw(sq,  { BackgroundColor3 = Theme.elemHover }, 0.1)
				tw(img, { ImageColor3 = Theme.muted },          0.1)
			end
		end)
		btn.MouseLeave:Connect(function()
			if curTab ~= name then
				tw(sq,  { BackgroundColor3 = Theme.card }, 0.1)
				tw(img, { ImageColor3 = Theme.dim },       0.1)
			end
		end)

		local function makeSection(secName)
			local f = ni("Frame", {
				Name             = secName,
				BackgroundColor3 = Theme.section,
				BorderSizePixel  = 0,
			}, pg)
			addTexture(f, 0.94, 1)
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
			sectionLeft.Position   = UDim2.new(0, PAD, 0, PAD)
			sectionLeft.Size       = UDim2.new(0, eachW, 0, totalH)
			sectionCenter.Position = UDim2.new(0, PAD + eachW + gap, 0, PAD)
			sectionCenter.Size     = UDim2.new(0, eachW, 0, totalH)
			sectionRight.Position  = UDim2.new(0, PAD + (eachW + gap) * 2, 0, PAD)
			sectionRight.Size      = UDim2.new(0, eachW, 0, totalH)
		end

		layoutSections()
		PageArea:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutSections)

		local tab           = {}
		tab.Page          = pg
		tab.SectionLeft   = sectionLeft
		tab.SectionCenter = sectionCenter
		tab.SectionRight  = sectionRight

		function tab:AddSection(cfg2)
			cfg2 = cfg2 or {}
			local side    = cfg2.Side  or "Left"
			local title   = cfg2.Title or ""
			local iconId2 = cfg2.Icon  or ""
			local target
			if     side == "Left"   then target = sectionLeft
			elseif side == "Center" then target = sectionCenter
			elseif side == "Right"  then target = sectionRight
			end
			if iconId2 ~= "" and not iconId2:match("rbxasset") then
				iconId2 = ICONS[iconId2] or iconId2
			end

			local HEADER_H = title ~= "" and 36 or 0

			if title ~= "" then
				local titleBar = ni("Frame", {
					Size             = UDim2.new(1, 0, 0, HEADER_H),
					BackgroundColor3 = Theme.section,
					BorderSizePixel  = 0,
					ZIndex           = 2,
				}, target)
				local txtX = 12
				if iconId2 ~= "" then
					ni("ImageLabel", {
						Size                   = UDim2.new(0, 14, 0, 14),
						Position               = UDim2.new(0, 10, 0.5, -7),
						BackgroundTransparency = 1,
						Image                  = iconId2,
						ImageColor3            = Theme.Accent,
						ZIndex                 = 3,
					}, titleBar)
					txtX = 28
				end
				ni("TextLabel", {
					Size                   = UDim2.new(1, -txtX - 4, 1, 0),
					Position               = UDim2.new(0, txtX, 0, 0),
					BackgroundTransparency = 1,
					Text                   = title,
					TextColor3             = Theme.Accent,
					TextSize               = 10,
					Font                   = Enum.Font.GothamBold,
					TextXAlignment         = Enum.TextXAlignment.Left,
					ZIndex                 = 3,
				}, titleBar)
				ni("Frame", {
					Size             = UDim2.new(1, -12, 0, 1),
					Position         = UDim2.new(0, 6, 1, -1),
					BackgroundColor3 = Theme.dim,
					BorderSizePixel  = 0,
					ZIndex           = 3,
				}, titleBar)
			end

			local scroll = ni("ScrollingFrame", {
				Size                   = UDim2.new(1, -4, 1, -HEADER_H),
				Position               = UDim2.new(0, 2, 0, HEADER_H),
				BackgroundTransparency = 1,
				BorderSizePixel        = 0,
				ScrollBarThickness     = 3,
				ScrollBarImageColor3   = Theme.Accent,
				BottomImage            = SCROLL_BOT,
				MidImage               = SCROLL_MID,
				TopImage               = SCROLL_TOP,
				CanvasSize             = UDim2.new(0, 0, 0, 0),
				ScrollingDirection     = Enum.ScrollingDirection.Y,
				ClipsDescendants       = true,
				ZIndex                 = 2,
			}, target)

			local layout = Instance.new("UIListLayout")
			layout.SortOrder           = Enum.SortOrder.LayoutOrder
			layout.Padding             = UDim.new(0, 4)
			layout.FillDirection       = Enum.FillDirection.Vertical
			layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			layout.Parent              = scroll

			local pad = Instance.new("UIPadding")
			pad.PaddingLeft   = UDim.new(0, 5)
			pad.PaddingRight  = UDim.new(0, 5)
			pad.PaddingTop    = UDim.new(0, 5)
			pad.PaddingBottom = UDim.new(0, 5)
			pad.Parent        = scroll

			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 14)
			end)

			local sec      = {}
			sec.Frame      = target
			sec.Scroll     = scroll
			local rowCount = 0

			local function newRow(h)
				rowCount = rowCount + 1
				local r = ni("Frame", {
					Size             = UDim2.new(1, 0, 0, h),
					BackgroundColor3 = Theme.elemBg,
					BorderSizePixel  = 0,
					LayoutOrder      = rowCount,
					ZIndex           = 3,
				}, scroll)
				addTexture(r, 0.90, 4)
				return r
			end

			function sec:AddToggle(cfg3)
				cfg3 = cfg3 or {}
				local label    = cfg3.Name     or "Toggle"
				local saveId   = cfg3.SaveId   or label
				local default  = cfg3.Default  or false
				local callback = cfg3.Callback or function() end
				local state    = getSaved(saveId, not not default)

				local row = newRow(ELEM_H)
				ni("TextLabel", {
					Size                   = UDim2.new(1, -60, 1, 0),
					Position               = UDim2.new(0, 10, 0, 0),
					BackgroundTransparency = 1,
					Text                   = label,
					TextColor3             = Theme.text,
					TextSize               = 10,
					Font                   = Enum.Font.Gotham,
					TextXAlignment         = Enum.TextXAlignment.Left,
					ZIndex                 = 5,
				}, row)

				local trkW, trkH = 32, 17
				local track = ni("Frame", {
					Size             = UDim2.new(0, trkW, 0, trkH),
					Position         = UDim2.new(1, -trkW - 8, 0.5, -trkH / 2),
					BackgroundColor3 = state and Theme.Accent or Theme.dim,
					BorderSizePixel  = 0,
					ZIndex           = 5,
				}, row)
				corner(track, trkH)
				addTexture(track, 0.84, 6)
				local stroke = ni("UIStroke", {
					Color     = state and Theme.Accent or Theme.InElementBorder,
					Thickness = 1,
				}, track)

				local knobSz = 13
				local knob   = ni("Frame", {
					Size             = UDim2.new(0, knobSz, 0, knobSz),
					Position         = state
						and UDim2.new(1, -knobSz - 2, 0.5, -knobSz / 2)
						or  UDim2.new(0, 2, 0.5, -knobSz / 2),
					BackgroundColor3 = Theme.text,
					BorderSizePixel  = 0,
					ZIndex           = 7,
				}, track)
				corner(knob, knobSz)
				ni("UIStroke", { Color = Color3.fromRGB(140, 160, 180), Thickness = 0.5 }, knob)

				local function applyState(v, animate)
					local dur = animate and 0.20 or 0
					tw(track,  { BackgroundColor3 = v and Theme.Accent or Theme.dim },                0.20)
					tw(stroke, { Color = v and Theme.Accent or Theme.InElementBorder },               0.20)
					tw(knob,   { Position = v
						and UDim2.new(1, -knobSz - 2, 0.5, -knobSz / 2)
						or  UDim2.new(0, 2, 0.5, -knobSz / 2) },                                     0.20)
				end

				local btn = ni("TextButton", {
					Size                   = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                   = "",
					BorderSizePixel        = 0,
					ZIndex                 = 8,
				}, row)
				btn.MouseButton1Click:Connect(function()
					state = not state
					applyState(state, true)
					setSaved(saveId, state)
					callback(state)
				end)
				btn.MouseEnter:Connect(function() tw(row, { BackgroundColor3 = Theme.elemHover }, 0.1) end)
				btn.MouseLeave:Connect(function() tw(row, { BackgroundColor3 = Theme.elemBg },    0.1) end)

				local el = { Value = state }
				function el:Set(v)
					state    = not not v
					el.Value = state
					applyState(state, true)
					setSaved(saveId, state)
					callback(state)
				end
				function el:OnChanged(fn)
					local oldCb = callback
					callback = function(val) oldCb(val) fn(val) end
					fn(state)
				end
				applyState(state, false)
				task.defer(function() callback(state) end)
				return el
			end

			function sec:AddSlider(cfg3)
				cfg3 = cfg3 or {}
				local label    = cfg3.Name     or "Slider"
				local saveId   = cfg3.SaveId   or label
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

				local row = newRow(ELEM_H + 18)
				ni("TextLabel", {
					Size                   = UDim2.new(1, -54, 0, 14),
					Position               = UDim2.new(0, 10, 0, 5),
					BackgroundTransparency = 1,
					Text                   = label,
					TextColor3             = Theme.text,
					TextSize               = 10,
					Font                   = Enum.Font.Gotham,
					TextXAlignment         = Enum.TextXAlignment.Left,
					ZIndex                 = 5,
				}, row)

				local valLbl = ni("TextLabel", {
					Size                   = UDim2.new(0, 44, 0, 14),
					Position               = UDim2.new(1, -50, 0, 5),
					BackgroundTransparency = 1,
					Text                   = tostring(roundVal(value)) .. suffix,
					TextColor3             = Theme.Accent,
					TextSize               = 10,
					Font                   = Enum.Font.GothamBold,
					TextXAlignment         = Enum.TextXAlignment.Right,
					ZIndex                 = 5,
				}, row)

				local railBg = ni("Frame", {
					Size             = UDim2.new(1, -20, 0, 5),
					Position         = UDim2.new(0, 10, 0, 28),
					BackgroundColor3 = Theme.dim,
					BorderSizePixel  = 0,
					ZIndex           = 5,
				}, row)
				corner(railBg, 5)
				addTexture(railBg, 0.80, 6)

				local pct  = (value - minV) / (maxV - minV)
				local fill = ni("Frame", {
					Size             = UDim2.new(pct, 0, 1, 0),
					BackgroundColor3 = Theme.Accent,
					BorderSizePixel  = 0,
					ZIndex           = 6,
				}, railBg)
				corner(fill, 5)

				local dot = ni("Frame", {
					Size             = UDim2.new(0, 13, 0, 13),
					AnchorPoint      = Vector2.new(0.5, 0.5),
					Position         = UDim2.new(pct, 0, 0.5, 0),
					BackgroundColor3 = Theme.text,
					BorderSizePixel  = 0,
					ZIndex           = 8,
				}, railBg)
				corner(dot, 13)
				ni("UIStroke", { Color = Theme.Accent, Thickness = 1.5 }, dot)

				local function setVal(v, animate)
					value       = roundVal(math.clamp(v, minV, maxV))
					local p     = (value - minV) / (maxV - minV)
					local dur   = animate and 0.08 or 0
					tw(fill, { Size     = UDim2.new(p, 0, 1, 0) },   dur)
					tw(dot,  { Position = UDim2.new(p, 0, 0.5, 0) }, dur)
					valLbl.Text = tostring(value) .. suffix
					setSaved(saveId, value)
					callback(value)
				end

				local dragging = false
				local function onDrag(absX)
					local rel = math.clamp((absX - railBg.AbsolutePosition.X) / railBg.AbsoluteSize.X, 0, 1)
					setVal(minV + rel * (maxV - minV), false)
				end

				local hitBtn = ni("TextButton", {
					Size                   = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                   = "",
					BorderSizePixel        = 0,
					ZIndex                 = 9,
				}, row)
				hitBtn.MouseButton1Down:Connect(function(x) dragging = true onDrag(x) end)
				hitBtn.MouseButton1Up:Connect(function()    dragging = false end)
				dot.InputBegan:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
				end)
				dot.InputEnded:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
				end)
				UserInputService.InputChanged:Connect(function(i)
					if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
						onDrag(i.Position.X)
					end
				end)
				UserInputService.InputEnded:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
				end)

				hitBtn.MouseEnter:Connect(function() tw(row, { BackgroundColor3 = Theme.elemHover }, 0.1) end)
				hitBtn.MouseLeave:Connect(function() tw(row, { BackgroundColor3 = Theme.elemBg },    0.1) end)

				local el = { Value = value }
				function el:Set(v)
					setVal(v, true)
					el.Value = value
				end
				function el:OnChanged(fn)
					local oldCb = callback
					callback = function(val) oldCb(val) fn(val) end
					fn(value)
				end
				setVal(value, false)
				task.defer(function() callback(value) end)
				return el
			end

			function sec:AddKeybind(cfg3)
				cfg3 = cfg3 or {}
				local label    = cfg3.Name     or "Keybind"
				local saveId   = cfg3.SaveId   or label
				local default  = cfg3.Default  or Enum.KeyCode.Unknown
				local callback = cfg3.Callback or function() end

				local savedKeyName = getSaved(saveId, nil)
				local key = default
				if savedKeyName then
					local ok, k = pcall(function() return Enum.KeyCode[savedKeyName] end)
					if ok and k and k ~= Enum.KeyCode.Unknown then
						key = k
					else
						print("[EcoHub] AddKeybind: saved key invalid '" .. tostring(savedKeyName) .. "', using default.")
					end
				end

				local listening = false
				local row       = newRow(ELEM_H)

				ni("TextLabel", {
					Size                   = UDim2.new(1, -78, 1, 0),
					Position               = UDim2.new(0, 10, 0, 0),
					BackgroundTransparency = 1,
					Text                   = label,
					TextColor3             = Theme.text,
					TextSize               = 10,
					Font                   = Enum.Font.Gotham,
					TextXAlignment         = Enum.TextXAlignment.Left,
					ZIndex                 = 5,
				}, row)

				local kBox = ni("Frame", {
					Size             = UDim2.new(0, 66, 0, 20),
					Position         = UDim2.new(1, -72, 0.5, -10),
					BackgroundColor3 = Color3.fromRGB(20, 20, 22),
					BorderSizePixel  = 0,
					ZIndex           = 5,
				}, row)
				corner(kBox, 5)
				addTexture(kBox, 0.86, 6)
				local kStr = ni("UIStroke", { Color = Theme.InElementBorder, Thickness = 1 }, kBox)

				local function keyDisplayName(k)
					if type(k) ~= "userdata" then return tostring(k) end
					local n = k.Name
					return n == "Unknown" and "?" or n
				end

				local kLbl = ni("TextLabel", {
					Size                   = UDim2.new(1, -4, 1, 0),
					Position               = UDim2.new(0, 2, 0, 0),
					BackgroundTransparency = 1,
					Text                   = "[ " .. keyDisplayName(key) .. " ]",
					TextColor3             = Theme.Accent,
					TextSize               = 9,
					Font                   = Enum.Font.GothamBold,
					TextXAlignment         = Enum.TextXAlignment.Center,
					TextTruncate           = Enum.TextTruncate.AtEnd,
					ZIndex                 = 7,
				}, kBox)

				local btn = ni("TextButton", {
					Size                   = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                   = "",
					BorderSizePixel        = 0,
					ZIndex                 = 8,
				}, row)
				btn.MouseButton1Click:Connect(function()
					listening       = true
					kLbl.Text       = "[ ... ]"
					kLbl.TextColor3 = Theme.muted
					tw(kStr, { Color = Theme.Accent }, 0.12)
				end)
				btn.MouseEnter:Connect(function() tw(row, { BackgroundColor3 = Theme.elemHover }, 0.1) end)
				btn.MouseLeave:Connect(function() tw(row, { BackgroundColor3 = Theme.elemBg },    0.1) end)

				UserInputService.InputBegan:Connect(function(input, processed)
					if not listening then return end
					if input.UserInputType == Enum.UserInputType.Keyboard then
						if input.KeyCode == Enum.KeyCode.Escape then
							listening       = false
							kLbl.Text       = "[ " .. keyDisplayName(key) .. " ]"
							kLbl.TextColor3 = Theme.Accent
							tw(kStr, { Color = Theme.InElementBorder }, 0.12)
							return
						end
						listening       = false
						key             = input.KeyCode
						kLbl.Text       = "[ " .. keyDisplayName(key) .. " ]"
						kLbl.TextColor3 = Theme.Accent
						tw(kStr, { Color = Theme.InElementBorder }, 0.12)
						setSaved(saveId, key.Name)
						callback(key)
					end
				end)

				local el = { Value = key }
				function el:Set(k)
					key       = k
					el.Value  = k
					kLbl.Text = "[ " .. keyDisplayName(k) .. " ]"
					setSaved(saveId, type(k) == "userdata" and k.Name or tostring(k))
					callback(key)
				end
				function el:OnChanged(fn)
					local oldCb = callback
					callback = function(val) oldCb(val) fn(val) end
					fn(key)
				end
				task.defer(function() callback(key) end)
				return el
			end

			function sec:AddDropdown(cfg3)
				cfg3 = cfg3 or {}
				local label    = cfg3.Name     or "Dropdown"
				local saveId   = cfg3.SaveId   or label
				local options  = cfg3.Options  or {}
				local default  = cfg3.Default  or (options[1] or "")
				local callback = cfg3.Callback or function() end
				local selected = getSaved(saveId, default)
				local open     = false

				local MAX_VISIBLE = 5
				local OPT_H       = 28
				local PADDING     = 5

				rowCount = rowCount + 1
				local wrapper = ni("Frame", {
					Size                   = UDim2.new(1, 0, 0, ELEM_H),
					BackgroundTransparency = 1,
					BorderSizePixel        = 0,
					LayoutOrder            = rowCount,
					ClipsDescendants       = false,
					ZIndex                 = 30,
				}, scroll)

				local row = ni("Frame", {
					Size             = UDim2.new(1, 0, 0, ELEM_H),
					BackgroundColor3 = Theme.elemBg,
					BorderSizePixel  = 0,
					ZIndex           = 31,
				}, wrapper)
				addTexture(row, 0.90, 32)
				local rowStroke = ni("UIStroke", { Color = Theme.InElementBorder, Thickness = 0.7 }, row)

				ni("TextLabel", {
					Size                   = UDim2.new(1, -92, 1, 0),
					Position               = UDim2.new(0, 10, 0, 0),
					BackgroundTransparency = 1,
					Text                   = label,
					TextColor3             = Theme.text,
					TextSize               = 10,
					Font                   = Enum.Font.Gotham,
					TextXAlignment         = Enum.TextXAlignment.Left,
					ZIndex                 = 33,
				}, row)

				local selBox = ni("Frame", {
					Size             = UDim2.new(0, 80, 0, 20),
					Position         = UDim2.new(1, -86, 0.5, -10),
					BackgroundColor3 = Color3.fromRGB(20, 20, 22),
					BorderSizePixel  = 0,
					ZIndex           = 33,
				}, row)
				corner(selBox, 5)
				addTexture(selBox, 0.86, 34)
				local selStroke = ni("UIStroke", { Color = Theme.InElementBorder, Thickness = 1 }, selBox)

				local selLbl = ni("TextLabel", {
					Size                   = UDim2.new(1, -22, 1, 0),
					Position               = UDim2.new(0, 6, 0, 0),
					BackgroundTransparency = 1,
					Text                   = selected,
					TextColor3             = Theme.Accent,
					TextSize               = 9,
					Font                   = Enum.Font.GothamBold,
					TextXAlignment         = Enum.TextXAlignment.Left,
					TextTruncate           = Enum.TextTruncate.AtEnd,
					ZIndex                 = 35,
				}, selBox)

				local arrowIco = ni("ImageLabel", {
					Size                   = UDim2.new(0, 14, 0, 14),
					Position               = UDim2.new(1, -17, 0.5, -7),
					BackgroundTransparency = 1,
					Image                  = ARROW_ICO,
					ImageColor3            = Theme.muted,
					ZIndex                 = 35,
				}, selBox)

				local dropVisibleH = math.min(#options, MAX_VISIBLE) * OPT_H + PADDING * 2

				local dropBg = ni("Frame", {
					Size             = UDim2.new(1, 0, 0, 0),
					Position         = UDim2.new(0, 0, 0, ELEM_H + 3),
					BackgroundColor3 = Theme.dropdownHolder,
					BorderSizePixel  = 0,
					ClipsDescendants = true,
					ZIndex           = 50,
					Visible          = false,
				}, wrapper)
				ni("UIStroke", { Color = Theme.AcrylicBorder, Thickness = 1 }, dropBg)
				addTexture(dropBg, 0.90, 51)

				local accentLine = ni("Frame", {
					Size             = UDim2.new(1, -20, 0, 1),
					Position         = UDim2.new(0, 10, 0, 0),
					BackgroundColor3 = Theme.Accent,
					BorderSizePixel  = 0,
					ZIndex           = 53,
				}, dropBg)
				local accentGrad = Instance.new("UIGradient")
				accentGrad.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0,    Theme.dropdownHolder),
					ColorSequenceKeypoint.new(0.15, Theme.Accent),
					ColorSequenceKeypoint.new(0.85, Theme.Accent),
					ColorSequenceKeypoint.new(1,    Theme.dropdownHolder),
				})
				accentGrad.Parent = accentLine

				local optScroll = ni("ScrollingFrame", {
					Size                   = UDim2.new(1, -6, 1, -(PADDING * 2)),
					Position               = UDim2.new(0, 3, 0, PADDING),
					BackgroundTransparency = 1,
					BorderSizePixel        = 0,
					ScrollBarThickness     = (#options > MAX_VISIBLE) and 3 or 0,
					ScrollBarImageColor3   = Theme.Accent,
					BottomImage            = SCROLL_BOT,
					MidImage               = SCROLL_MID,
					TopImage               = SCROLL_TOP,
					CanvasSize             = UDim2.new(0, 0, 0, #options * OPT_H),
					ScrollingDirection     = Enum.ScrollingDirection.Y,
					ClipsDescendants       = true,
					ZIndex                 = 52,
				}, dropBg)

				local optHolder = ni("Frame", {
					Size                   = UDim2.new(1, 0, 0, #options * OPT_H),
					BackgroundTransparency = 1,
					ZIndex                 = 53,
				}, optScroll)

				ni("UIListLayout", {
					SortOrder     = Enum.SortOrder.LayoutOrder,
					Padding       = UDim.new(0, 0),
					FillDirection = Enum.FillDirection.Vertical,
				}, optHolder)

				local optButtons = {}

				local function applySelected()
					for idx2, ob in pairs(optButtons) do
						local iS = options[idx2] == selected
						tw(ob.row, { BackgroundColor3 = iS and Theme.AccentDark or Theme.dropdownHolder }, 0.12)
						tw(ob.lbl, { TextColor3 = iS and Theme.text or Theme.muted },                      0.12)
						tw(ob.bar, { Size = UDim2.new(0, iS and 3 or 0, 0, 12) },                         0.14)
						ob.chkIco.Visible = iS
						ob.lbl.Font = iS and Enum.Font.GothamBold or Enum.Font.Gotham
					end
				end

				local function closeDD()
					open = false
					tw(arrowIco,  { ImageColor3 = Theme.muted, Rotation = 0 }, 0.18)
					tw(selStroke, { Color = Theme.InElementBorder },           0.14)
					tw(rowStroke, { Color = Theme.InElementBorder },           0.14)
					wrapper.Size = UDim2.new(1, 0, 0, ELEM_H)
					tw(dropBg, { Size = UDim2.new(1, 0, 0, 0) }, 0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
					task.delay(0.20, function() dropBg.Visible = false end)
				end

				local function buildOptionItem(i2, opt)
					local isSel  = (opt == selected)
					local optRow = ni("Frame", {
						Size             = UDim2.new(1, 0, 0, OPT_H),
						BackgroundColor3 = isSel and Theme.AccentDark or Theme.dropdownHolder,
						BorderSizePixel  = 0,
						ZIndex           = 54,
						LayoutOrder      = i2,
					}, optHolder)

					local leftBar = ni("Frame", {
						Size             = UDim2.new(0, isSel and 3 or 0, 0, 12),
						Position         = UDim2.new(0, 0, 0.5, -6),
						BackgroundColor3 = Theme.Accent,
						BorderSizePixel  = 0,
						ZIndex           = 56,
					}, optRow)
					corner(leftBar, 2)

					local optLbl = ni("TextLabel", {
						Size                   = UDim2.new(1, -32, 1, 0),
						Position               = UDim2.new(0, 10, 0, 0),
						BackgroundTransparency = 1,
						Text                   = opt,
						TextColor3             = isSel and Theme.text or Theme.muted,
						TextSize               = 10,
						Font                   = isSel and Enum.Font.GothamBold or Enum.Font.Gotham,
						TextXAlignment         = Enum.TextXAlignment.Left,
						ZIndex                 = 55,
					}, optRow)

					local chkIco = ni("ImageLabel", {
						Size                   = UDim2.new(0, 12, 0, 12),
						Position               = UDim2.new(1, -18, 0.5, -6),
						BackgroundTransparency = 1,
						Image                  = ICONS.check,
						ImageColor3            = Theme.Accent,
						ZIndex                 = 56,
						Visible                = isSel,
					}, optRow)

					if i2 < #options then
						ni("Frame", {
							Size                   = UDim2.new(1, -12, 0, 1),
							Position               = UDim2.new(0, 6, 1, -1),
							BackgroundColor3       = Theme.dim,
							BackgroundTransparency = 0.5,
							BorderSizePixel        = 0,
							ZIndex                 = 55,
						}, optRow)
					end

					local optBtn = ni("TextButton", {
						Size                   = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Text                   = "",
						BorderSizePixel        = 0,
						ZIndex                 = 60,
					}, optRow)

					optButtons[i2] = { row = optRow, lbl = optLbl, bar = leftBar, chkIco = chkIco }

					optBtn.MouseButton1Click:Connect(function()
						selected    = opt
						selLbl.Text = opt
						el.Value    = opt
						closeDD()
						applySelected()
						setSaved(saveId, selected)
						callback(selected)
					end)
					optBtn.MouseEnter:Connect(function()
						if opt ~= selected then
							tw(optRow, { BackgroundColor3 = Theme.elemHover }, 0.1)
							tw(optLbl, { TextColor3 = Theme.text },            0.1)
						end
					end)
					optBtn.MouseLeave:Connect(function()
						if opt ~= selected then
							tw(optRow, { BackgroundColor3 = Theme.dropdownHolder }, 0.1)
							tw(optLbl, { TextColor3 = Theme.muted },               0.1)
						end
					end)
				end

				for i2, opt in ipairs(options) do
					local ok, err = pcall(buildOptionItem, i2, opt)
					if not ok then print("[EcoHub] AddDropdown buildOptionItem error: " .. tostring(err)) end
				end

				local toggleBtn = ni("TextButton", {
					Size                   = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                   = "",
					BorderSizePixel        = 0,
					ZIndex                 = 36,
				}, row)

				local el = { Value = selected }

				local function openDD()
					open           = true
					dropBg.Visible = true
					dropBg.Size    = UDim2.new(1, 0, 0, 0)
					wrapper.Size   = UDim2.new(1, 0, 0, ELEM_H + dropVisibleH + 3)
					tw(arrowIco,  { ImageColor3 = Theme.Accent, Rotation = 180 }, 0.18)
					tw(selStroke, { Color = Theme.Accent },                       0.14)
					tw(rowStroke, { Color = Theme.Accent },                       0.14)
					tw(dropBg, { Size = UDim2.new(1, 0, 0, dropVisibleH) }, 0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
				end

				toggleBtn.MouseButton1Click:Connect(function()
					if open then closeDD() else openDD() end
				end)
				toggleBtn.MouseEnter:Connect(function() tw(row, { BackgroundColor3 = Theme.elemHover }, 0.1) end)
				toggleBtn.MouseLeave:Connect(function() tw(row, { BackgroundColor3 = Theme.elemBg },    0.1) end)

				UserInputService.InputBegan:Connect(function(input)
					if open and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
						local absPos  = dropBg.AbsolutePosition
						local absSize = dropBg.AbsoluteSize
						local mX      = UserInputService:GetMouseLocation().X
						local mY      = UserInputService:GetMouseLocation().Y
						if mX < absPos.X or mX > absPos.X + absSize.X
							or mY < absPos.Y - ELEM_H - 3 or mY > absPos.Y + absSize.Y then
							closeDD()
						end
					end
				end)

				function el:Set(v)
					selected    = v
					selLbl.Text = v
					el.Value    = v
					applySelected()
					setSaved(saveId, v)
					callback(v)
				end
				function el:SetOptions(newOpts)
					options      = newOpts
					dropVisibleH = math.min(#options, MAX_VISIBLE) * OPT_H + PADDING * 2
					optButtons   = {}
					for _, ch in ipairs(optHolder:GetChildren()) do
						if not ch:IsA("UIListLayout") then ch:Destroy() end
					end
					optHolder.Size       = UDim2.new(1, 0, 0, #options * OPT_H)
					optScroll.CanvasSize = UDim2.new(0, 0, 0, #options * OPT_H)
					optScroll.ScrollBarThickness = (#options > MAX_VISIBLE) and 3 or 0
					for i2, opt in ipairs(options) do
						local ok, err = pcall(buildOptionItem, i2, opt)
						if not ok then print("[EcoHub] SetOptions buildOptionItem error: " .. tostring(err)) end
					end
				end
				function el:OnChanged(fn)
					local oldCb = callback
					callback = function(val) oldCb(val) fn(val) end
					fn(selected)
				end
				task.defer(function() callback(selected) end)
				return el
			end

			function sec:AddParagraph(cfg3)
				cfg3 = cfg3 or {}
				local title = cfg3.Title or ""
				local text  = cfg3.Text  or ""
				local lines = math.max(1, math.ceil(#text / 26))
				local rowH  = (title ~= "" and 15 or 0) + lines * 13 + 14

				local row = newRow(rowH)
				if title ~= "" then
					ni("TextLabel", {
						Size                   = UDim2.new(1, -10, 0, 13),
						Position               = UDim2.new(0, 10, 0, 5),
						BackgroundTransparency = 1,
						Text                   = title,
						TextColor3             = Theme.Accent,
						TextSize               = 10,
						Font                   = Enum.Font.GothamBold,
						TextXAlignment         = Enum.TextXAlignment.Left,
						ZIndex                 = 5,
					}, row)
				end
				local txtLbl = ni("TextLabel", {
					Size                   = UDim2.new(1, -12, 0, lines * 13),
					Position               = UDim2.new(0, 10, 0, title ~= "" and 19 or 6),
					BackgroundTransparency = 1,
					Text                   = text,
					TextColor3             = Theme.muted,
					TextSize               = 9,
					Font                   = Enum.Font.Gotham,
					TextXAlignment         = Enum.TextXAlignment.Left,
					TextWrapped            = true,
					ZIndex                 = 5,
				}, row)

				local el = { Frame = row }
				function el:Set(t) txtLbl.Text = t end
				return el
			end

			function sec:AddLabel(cfg3)
				cfg3 = cfg3 or {}
				local text  = cfg3.Text  or "Label"
				local color = cfg3.Color or Theme.muted

				local row = newRow(ELEM_H)
				local lbl = ni("TextLabel", {
					Size                   = UDim2.new(1, -10, 1, 0),
					Position               = UDim2.new(0, 10, 0, 0),
					BackgroundTransparency = 1,
					Text                   = text,
					TextColor3             = color,
					TextSize               = 10,
					Font                   = Enum.Font.Gotham,
					TextXAlignment         = Enum.TextXAlignment.Left,
					ZIndex                 = 5,
				}, row)
				local el = { Frame = row }
				function el:Set(t, c)
					lbl.Text = t
					if c then lbl.TextColor3 = c end
				end
				return el
			end

			function sec:AddButton(cfg3)
				cfg3 = cfg3 or {}
				local label    = cfg3.Name     or "Button"
				local callback = cfg3.Callback or function() end

				local row = newRow(ELEM_H)

				ni("TextLabel", {
					Size                   = UDim2.new(1, -42, 1, 0),
					Position               = UDim2.new(0, 12, 0, 0),
					BackgroundTransparency = 1,
					Text                   = label,
					TextColor3             = Theme.text,
					TextSize               = 10,
					Font                   = Enum.Font.GothamBold,
					TextXAlignment         = Enum.TextXAlignment.Left,
					ZIndex                 = 5,
				}, row)

				local arrowImg = ni("ImageLabel", {
					Image                  = ICONS.buttonArrow,
					Size                   = UDim2.fromOffset(14, 14),
					AnchorPoint            = Vector2.new(1, 0.5),
					Position               = UDim2.new(1, -10, 0.5, 0),
					BackgroundTransparency = 1,
					ImageColor3            = Theme.muted,
					ZIndex                 = 6,
				}, row)

				local acBar = ni("Frame", {
					Size             = UDim2.new(0, 0, 0, 14),
					Position         = UDim2.new(0, 0, 0.5, -7),
					BackgroundColor3 = Theme.Accent,
					BorderSizePixel  = 0,
					ZIndex           = 4,
				}, row)
				corner(acBar, 2)

				local btn = ni("TextButton", {
					Size                   = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                   = "",
					BorderSizePixel        = 0,
					ZIndex                 = 8,
				}, row)

				btn.MouseButton1Click:Connect(function()
					tw(row,      { BackgroundColor3 = Theme.AccentDark }, 0.08)
					tw(arrowImg, { ImageColor3 = Theme.Accent },          0.08)
					tw(acBar,    { Size = UDim2.new(0, 3, 0, 14) },       0.08)
					task.delay(0.14, function()
						tw(row,      { BackgroundColor3 = Theme.elemBg }, 0.14)
						tw(arrowImg, { ImageColor3 = Theme.muted },       0.14)
						tw(acBar,    { Size = UDim2.new(0, 0, 0, 14) },   0.14)
					end)
					callback()
				end)
				btn.MouseEnter:Connect(function()
					tw(row,      { BackgroundColor3 = Theme.elemHover }, 0.1)
					tw(arrowImg, { ImageColor3 = Theme.text },           0.1)
					tw(acBar,    { Size = UDim2.new(0, 3, 0, 14) },      0.1)
				end)
				btn.MouseLeave:Connect(function()
					tw(row,      { BackgroundColor3 = Theme.elemBg },  0.1)
					tw(arrowImg, { ImageColor3 = Theme.muted },        0.1)
					tw(acBar,    { Size = UDim2.new(0, 0, 0, 14) },    0.1)
				end)

				local el = { Frame = row }
				return el
			end

			function sec:AddColorPicker(cfg3)
				cfg3 = cfg3 or {}
				local label    = cfg3.Name     or "Color"
				local saveId   = cfg3.SaveId   or label
				local default  = cfg3.Default  or Color3.fromRGB(72, 138, 182)
				local callback = cfg3.Callback or function() end

				local savedColor = getSaved(saveId, nil)
				local color      = default
				if savedColor and type(savedColor) == "table" then
					local ok, c = pcall(function()
						return Color3.fromRGB(savedColor.r or 72, savedColor.g or 138, savedColor.b or 182)
					end)
					if ok then color = c else
						print("[EcoHub] AddColorPicker: invalid saved color for '" .. saveId .. "', using default.")
					end
				end

				local open     = false
				local H_PICKER = 108

				rowCount = rowCount + 1
				local wrapper = ni("Frame", {
					Size                   = UDim2.new(1, 0, 0, ELEM_H),
					BackgroundTransparency = 1,
					BorderSizePixel        = 0,
					LayoutOrder            = rowCount,
					ClipsDescendants       = false,
				}, scroll)

				local row = ni("Frame", {
					Size             = UDim2.new(1, 0, 0, ELEM_H),
					BackgroundColor3 = Theme.elemBg,
					BorderSizePixel  = 0,
					ZIndex           = 3,
				}, wrapper)
				addTexture(row, 0.90, 4)

				ni("TextLabel", {
					Size                   = UDim2.new(1, -50, 1, 0),
					Position               = UDim2.new(0, 10, 0, 0),
					BackgroundTransparency = 1,
					Text                   = label,
					TextColor3             = Theme.text,
					TextSize               = 10,
					Font                   = Enum.Font.Gotham,
					TextXAlignment         = Enum.TextXAlignment.Left,
					ZIndex                 = 5,
				}, row)

				local preview = ni("Frame", {
					Size             = UDim2.new(0, 22, 0, 22),
					Position         = UDim2.new(1, -28, 0.5, -11),
					BackgroundColor3 = color,
					BorderSizePixel  = 0,
					ZIndex           = 5,
				}, row)
				corner(preview, 5)
				ni("UIStroke", { Color = Theme.InElementBorder, Thickness = 1 }, preview)

				local picker = ni("Frame", {
					Size             = UDim2.new(1, 0, 0, 0),
					Position         = UDim2.new(0, 0, 0, ELEM_H + 3),
					BackgroundColor3 = Color3.fromRGB(22, 22, 22),
					BorderSizePixel  = 0,
					ClipsDescendants = true,
					Visible          = false,
					ZIndex           = 20,
				}, wrapper)
				ni("UIStroke", { Color = Theme.InElementBorder, Thickness = 0.7 }, picker)
				addTexture(picker, 0.92, 21)

				local huebar = ni("Frame", {
					Size             = UDim2.new(1, -14, 0, 14),
					Position         = UDim2.new(0, 7, 0, 8),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel  = 0,
					ZIndex           = 22,
				}, picker)
				corner(huebar, 7)

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

				local hueThumb = ni("Frame", {
					Size             = UDim2.new(0, 9, 1, 4),
					AnchorPoint      = Vector2.new(0.5, 0.5),
					Position         = UDim2.new(0, 0, 0.5, 0),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel  = 0,
					ZIndex           = 24,
				}, huebar)
				corner(hueThumb, 4)
				ni("UIStroke", { Color = Color3.fromRGB(0, 0, 0), Thickness = 1.5 }, hueThumb)

				local satFrame = ni("Frame", {
					Size             = UDim2.new(1, -14, 0, 56),
					Position         = UDim2.new(0, 7, 0, 30),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel  = 0,
					ZIndex           = 22,
				}, picker)
				corner(satFrame, 5)

				local satGradH = Instance.new("UIGradient")
				satGradH.Color  = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromHSV(0, 1, 1))
				satGradH.Parent = satFrame

				local satGradV = ni("Frame", {
					Size             = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel  = 0,
					ZIndex           = 23,
				}, satFrame)
				corner(satGradV, 5)
				local vGrad = Instance.new("UIGradient")
				vGrad.Color        = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0))
				vGrad.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0),
				})
				vGrad.Rotation = 90
				vGrad.Parent   = satGradV

				local satThumb = ni("Frame", {
					Size             = UDim2.new(0, 11, 0, 11),
					AnchorPoint      = Vector2.new(0.5, 0.5),
					Position         = UDim2.new(0, 0, 0, 0),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel  = 0,
					ZIndex           = 25,
				}, satFrame)
				corner(satThumb, 11)
				ni("UIStroke", { Color = Color3.fromRGB(0, 0, 0), Thickness = 1.5 }, satThumb)

				local hueH2, satV2, briV = Color3.toHSV(color)

				local function updateThumbs()
					hueThumb.Position            = UDim2.new(hueH2, 0, 0.5, 0)
					satThumb.Position            = UDim2.new(satV2, 0, 1 - briV, 0)
					satGradH.Color               = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromHSV(hueH2, 1, 1))
					preview.BackgroundColor3     = Color3.fromHSV(hueH2, satV2, briV)
				end

				local function commitColor()
					color = Color3.fromHSV(hueH2, satV2, briV)
					preview.BackgroundColor3 = color
					setSaved(saveId, {
						r = math.floor(color.R * 255),
						g = math.floor(color.G * 255),
						b = math.floor(color.B * 255),
					})
					callback(color)
				end

				local hueDrag, satDrag = false, false

				local hueBtn = ni("TextButton", {
					Size                   = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                   = "",
					ZIndex                 = 26,
				}, huebar)
				hueBtn.MouseButton1Down:Connect(function(x)
					hueDrag = true
					hueH2   = math.clamp((x - huebar.AbsolutePosition.X) / huebar.AbsoluteSize.X, 0, 1)
					updateThumbs() commitColor()
				end)
				hueBtn.MouseButton1Up:Connect(function() hueDrag = false end)

				local satBtn = ni("TextButton", {
					Size                   = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                   = "",
					ZIndex                 = 26,
				}, satFrame)
				satBtn.MouseButton1Down:Connect(function(x, y)
					satDrag = true
					satV2   = math.clamp((x - satFrame.AbsolutePosition.X) / satFrame.AbsoluteSize.X, 0, 1)
					briV    = 1 - math.clamp((y - satFrame.AbsolutePosition.Y) / satFrame.AbsoluteSize.Y, 0, 1)
					updateThumbs() commitColor()
				end)
				satBtn.MouseButton1Up:Connect(function() satDrag = false end)

				UserInputService.InputChanged:Connect(function(i)
					if i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
					if hueDrag then
						hueH2 = math.clamp((i.Position.X - huebar.AbsolutePosition.X) / huebar.AbsoluteSize.X, 0, 1)
						updateThumbs() commitColor()
					end
					if satDrag then
						satV2 = math.clamp((i.Position.X - satFrame.AbsolutePosition.X) / satFrame.AbsoluteSize.X, 0, 1)
						briV  = 1 - math.clamp((i.Position.Y - satFrame.AbsolutePosition.Y) / satFrame.AbsoluteSize.Y, 0, 1)
						updateThumbs() commitColor()
					end
				end)
				UserInputService.InputEnded:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then
						hueDrag = false satDrag = false
					end
				end)

				local openBtn = ni("TextButton", {
					Size                   = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text                   = "",
					BorderSizePixel        = 0,
					ZIndex                 = 8,
				}, row)
				openBtn.MouseButton1Click:Connect(function()
					open = not open
					if open then
						picker.Visible = true
						picker.Size    = UDim2.new(1, 0, 0, 0)
						wrapper.Size   = UDim2.new(1, 0, 0, ELEM_H + H_PICKER + 5)
						tw(picker, { Size = UDim2.new(1, 0, 0, H_PICKER) }, 0.20, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
					else
						tw(picker, { Size = UDim2.new(1, 0, 0, 0) }, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In)
						task.delay(0.20, function()
							picker.Visible = false
							wrapper.Size   = UDim2.new(1, 0, 0, ELEM_H)
						end)
					end
				end)
				openBtn.MouseEnter:Connect(function() tw(row, { BackgroundColor3 = Theme.elemHover }, 0.1) end)
				openBtn.MouseLeave:Connect(function() tw(row, { BackgroundColor3 = Theme.elemBg },    0.1) end)

				updateThumbs()

				local el = { Value = color }
				function el:Set(c)
					color    = c
					el.Value = c
					local h, s, v = Color3.toHSV(c)
					hueH2 = h satV2 = s briV = v
					updateThumbs() commitColor()
				end
				function el:OnChanged(fn)
					local oldCb = callback
					callback = function(val) oldCb(val) fn(val) end
					fn(color)
				end
				task.defer(function() callback(color) end)
				return el
			end

			function sec:AddInput(cfg3)
				cfg3 = cfg3 or {}
				local label       = cfg3.Name        or "Input"
				local saveId      = cfg3.SaveId      or label
				local default     = cfg3.Default     or ""
				local placeholder = cfg3.Placeholder or "Type here..."
				local callback    = cfg3.Callback    or function() end
				local value       = getSaved(saveId, default)

				local row = newRow(ELEM_H + 6)
				ni("TextLabel", {
					Size                   = UDim2.new(1, -10, 0, 13),
					Position               = UDim2.new(0, 10, 0, 4),
					BackgroundTransparency = 1,
					Text                   = label,
					TextColor3             = Theme.muted,
					TextSize               = 8,
					Font                   = Enum.Font.GothamBold,
					TextXAlignment         = Enum.TextXAlignment.Left,
					ZIndex                 = 5,
				}, row)

				local inputBox = ni("TextBox", {
					Size              = UDim2.new(1, -16, 0, 18),
					Position          = UDim2.new(0, 8, 0, 17),
					BackgroundColor3  = Color3.fromRGB(20, 20, 22),
					BorderSizePixel   = 0,
					Text              = value,
					PlaceholderText   = placeholder,
					TextColor3        = Theme.text,
					PlaceholderColor3 = Theme.muted,
					TextSize          = 9,
					Font              = Enum.Font.Gotham,
					TextXAlignment    = Enum.TextXAlignment.Left,
					ClearTextOnFocus  = false,
					ZIndex            = 6,
				}, row)
				corner(inputBox, 5)
				addTexture(inputBox, 0.86, 7)
				local inpStr = ni("UIStroke", { Color = Theme.InElementBorder, Thickness = 0.8 }, inputBox)
				ni("UIPadding", { PaddingLeft = UDim.new(0, 6) }, inputBox)

				inputBox.Focused:Connect(function()
					tw(inpStr, { Color = Theme.Accent }, 0.12)
				end)
				inputBox.FocusLost:Connect(function(entered)
					tw(inpStr, { Color = Theme.InElementBorder }, 0.12)
					value = inputBox.Text
					setSaved(saveId, value)
					if entered then callback(value) end
				end)
				inputBox:GetPropertyChangedSignal("Text"):Connect(function()
					value = inputBox.Text
				end)

				local el = { Value = value }
				function el:Set(v)
					value         = v
					inputBox.Text = v
					el.Value      = v
					setSaved(saveId, v)
					callback(v)
				end
				function el:OnChanged(fn)
					local oldCb = callback
					callback = function(val) oldCb(val) fn(val) end
					fn(value)
				end
				return el
			end

			return sec
		end

		if #tabList == 1 then
			curTab              = name
			pages[name].Visible = true
			applyPositions(1, false)
			local tb                = tabBtns[1]
			tb.sq.BackgroundColor3  = Theme.AccentDark
			tb.str.Color            = Theme.Accent
			tb.str.Thickness        = 1.5
			tb.img.ImageColor3      = Theme.Accent
			tb.lbl.TextTransparency = 0
			tb.lbl.TextColor3       = Theme.text
			tb.sub.TextTransparency = 0
			tb.sub.TextColor3       = Theme.muted
		end

		return tab
	end

	return win
end

return EcohubLibrarys
