local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

local SAVE_KEY = "ecohubv2/config.json"

local SaveData = {}

local function loadSave()
	local ok, data = pcall(function()
		return HttpService:JSONDecode(readfile(SAVE_KEY))
	end)
	if ok and type(data) == "table" then
		SaveData = data
	else
		print("[EcoHub] loadSave: arquivo nao encontrado ou invalido, iniciando vazio.")
		SaveData = {}
	end
end

local function writeSave()
	local ok, err = pcall(function()
		if not isfolder("ecohubv2") then makefolder("ecohubv2") end
		writefile(SAVE_KEY, HttpService:JSONEncode(SaveData))
	end)
	if not ok then
		print("[EcoHub] writeSave error: " .. tostring(err))
	end
	return ok
end

local function getSaved(id, default)
	if SaveData[id] ~= nil then return SaveData[id] end
	return default
end

local function setSaved(id, value)
	SaveData[id] = value
	writeSave()
end

loadSave()

local ICONS = {
	aim                      = "rbxassetid://10709818534",
	crosshair                = "rbxassetid://10709818534",
	target                   = "rbxassetid://10734977012",
	swords                   = "rbxassetid://10734975692",
	sword                    = "rbxassetid://10734975486",
	flame                    = "rbxassetid://10723376114",
	skull                    = "rbxassetid://10734962068",
	shield                   = "rbxassetid://10734951847",
	["shield-check"]         = "rbxassetid://10734951367",
	["shield-alert"]         = "rbxassetid://10734951173",
	["shield-close"]         = "rbxassetid://10734951535",
	["shield-off"]           = "rbxassetid://10734951684",
	bomb                     = "rbxassetid://10709781460",
	zap                      = "rbxassetid://10723345749",
	visuals                  = "rbxassetid://10723346959",
	eye                      = "rbxassetid://10723346959",
	["eye-off"]              = "rbxassetid://10723346871",
	image                    = "rbxassetid://10723415040",
	["image-minus"]          = "rbxassetid://10723414487",
	["image-off"]            = "rbxassetid://10723414677",
	["image-plus"]           = "rbxassetid://10723414827",
	layers                   = "rbxassetid://10723424505",
	palette                  = "rbxassetid://10734910430",
	paintbrush               = "rbxassetid://10734910187",
	["paintbrush-2"]         = "rbxassetid://10734910030",
	["paint-bucket"]         = "rbxassetid://10734909847",
	focus                    = "rbxassetid://10723377537",
	scan                     = "rbxassetid://10734942565",
	["scan-face"]            = "rbxassetid://10734942198",
	["scan-line"]            = "rbxassetid://10734942351",
	vehicle                  = "rbxassetid://10709789810",
	car                      = "rbxassetid://10709789810",
	bike                     = "rbxassetid://10709775894",
	plane                    = "rbxassetid://10734922971",
	rocket                   = "rbxassetid://10734934585",
	navigation               = "rbxassetid://10734906744",
	["navigation-2"]         = "rbxassetid://10734906332",
	["navigation-2-off"]     = "rbxassetid://10734906144",
	["navigation-off"]       = "rbxassetid://10734906580",
	move                     = "rbxassetid://10734900011",
	["move-3d"]              = "rbxassetid://10734898756",
	["move-diagonal"]        = "rbxassetid://10734899164",
	["move-diagonal-2"]      = "rbxassetid://10734898934",
	["move-horizontal"]      = "rbxassetid://10734899414",
	["move-vertical"]        = "rbxassetid://10734899821",
	wind                     = "rbxassetid://10747382750",
	players                  = "rbxassetid://10747373176",
	user                     = "rbxassetid://10747373176",
	["user-check"]           = "rbxassetid://10747371901",
	["user-cog"]             = "rbxassetid://10747372167",
	["user-minus"]           = "rbxassetid://10747372346",
	["user-plus"]            = "rbxassetid://10747372702",
	["user-x"]               = "rbxassetid://10747372992",
	users                    = "rbxassetid://10747373426",
	contact                  = "rbxassetid://10709811834",
	fingerprint              = "rbxassetid://10723375250",
	misc                     = "rbxassetid://10723345749",
	electricity              = "rbxassetid://10723345749",
	["electricity-off"]      = "rbxassetid://10723345643",
	star                     = "rbxassetid://10734966248",
	["star-half"]            = "rbxassetid://10734965897",
	["star-off"]             = "rbxassetid://10734966097",
	crown                    = "rbxassetid://10709818626",
	trophy                   = "rbxassetid://10747363809",
	medal                    = "rbxassetid://10734887072",
	ghost                    = "rbxassetid://10723396107",
	["alert-triangle"]       = "rbxassetid://10709753149",
	["alert-circle"]         = "rbxassetid://10709752996",
	["alert-octagon"]        = "rbxassetid://10709753064",
	info                     = "rbxassetid://10723415903",
	bell                     = "rbxassetid://10709775704",
	["bell-minus"]           = "rbxassetid://10709775241",
	["bell-off"]             = "rbxassetid://10709775320",
	["bell-plus"]            = "rbxassetid://10709775448",
	["bell-ring"]            = "rbxassetid://10709775560",
	config                   = "rbxassetid://10734950309",
	settings                 = "rbxassetid://10734950309",
	["settings-2"]           = "rbxassetid://10734950020",
	cog                      = "rbxassetid://10709810948",
	sliders                  = "rbxassetid://10734963400",
	["sliders-horizontal"]   = "rbxassetid://10734963191",
	wrench                   = "rbxassetid://10747383470",
	tool                     = "rbxassetid://10747383470",
	cpu                      = "rbxassetid://10709813383",
	terminal                 = "rbxassetid://10734982144",
	["terminal-square"]      = "rbxassetid://10734981995",
	code                     = "rbxassetid://10709810463",
	["code-2"]               = "rbxassetid://10709807111",
	database                 = "rbxassetid://10709818996",
	weapon                   = "rbxassetid://10734975486",
	["crosshair-2"]          = "rbxassetid://10709818534",
	gauge                    = "rbxassetid://10723395708",
	activity                 = "rbxassetid://10709752035",
	lock                     = "rbxassetid://10723434711",
	unlock                   = "rbxassetid://10747366027",
	key                      = "rbxassetid://10723416652",
	save                     = "rbxassetid://10734941499",
	download                 = "rbxassetid://10723344270",
	["download-cloud"]       = "rbxassetid://10723344088",
	upload                   = "rbxassetid://10747366434",
	["upload-cloud"]         = "rbxassetid://10747366266",
	trash                    = "rbxassetid://10747362393",
	["trash-2"]              = "rbxassetid://10747362241",
	copy                     = "rbxassetid://10709812159",
	refresh                  = "rbxassetid://10734933222",
	["refresh-ccw"]          = "rbxassetid://10734933056",
	search                   = "rbxassetid://10734943674",
	filter                   = "rbxassetid://10723375128",
	list                     = "rbxassetid://10723433811",
	["list-checks"]          = "rbxassetid://10734884548",
	["list-end"]             = "rbxassetid://10723426886",
	["list-minus"]           = "rbxassetid://10723426986",
	["list-ordered"]         = "rbxassetid://10723427199",
	["list-plus"]            = "rbxassetid://10723427334",
	["list-x"]               = "rbxassetid://10723433655",
	grid                     = "rbxassetid://10723404936",
	home                     = "rbxassetid://10723407389",
	compass                  = "rbxassetid://10709811445",
	map                      = "rbxassetid://10734886202",
	["map-pin"]              = "rbxassetid://10734886004",
	["map-pin-off"]          = "rbxassetid://10734885803",
	globe                    = "rbxassetid://10723404337",
	["globe-2"]              = "rbxassetid://10723398002",
	network                  = "rbxassetid://10734906975",
	["bar-chart"]            = "rbxassetid://10709773755",
	["bar-chart-2"]          = "rbxassetid://10709770317",
	["bar-chart-3"]          = "rbxassetid://10709770431",
	["bar-chart-4"]          = "rbxassetid://10709770560",
	["bar-chart-horizontal"] = "rbxassetid://10709773669",
	["line-chart"]           = "rbxassetid://10723426393",
	["pie-chart"]            = "rbxassetid://10734921727",
	["trending-up"]          = "rbxassetid://10747363465",
	["trending-down"]        = "rbxassetid://10747363205",
	target2                  = "rbxassetid://10734977012",
	crosshair3               = "rbxassetid://10709818534",
	siren                    = "rbxassetid://10734961284",
	["arrow-up"]             = "rbxassetid://10709768939",
	["arrow-down"]           = "rbxassetid://10709767827",
	["arrow-left"]           = "rbxassetid://10709768114",
	["arrow-right"]          = "rbxassetid://10709768347",
	["arrow-up-down"]        = "rbxassetid://10709768538",
	["arrow-left-right"]     = "rbxassetid://10709768019",
	["check"]                = "rbxassetid://10709790644",
	["check-circle"]         = "rbxassetid://10709790387",
	["check-circle-2"]       = "rbxassetid://10709790298",
	["check-square"]         = "rbxassetid://10709790537",
	["x"]                    = "rbxassetid://10747384394",
	["x-circle"]             = "rbxassetid://10747383819",
	["x-square"]             = "rbxassetid://10747384217",
	["plus"]                 = "rbxassetid://10734924532",
	["plus-circle"]          = "rbxassetid://10734923868",
	["plus-square"]          = "rbxassetid://10734924219",
	["minus"]                = "rbxassetid://10734896206",
	["minus-circle"]         = "rbxassetid://10734895856",
	["minus-square"]         = "rbxassetid://10734896029",
	["zoom-in"]              = "rbxassetid://10747384552",
	["zoom-out"]             = "rbxassetid://10747384679",
	["maximize"]             = "rbxassetid://10734886735",
	["maximize-2"]           = "rbxassetid://10734886496",
	["minimize"]             = "rbxassetid://10734895698",
	["minimize-2"]           = "rbxassetid://10734895530",
	["rotate-cw"]            = "rbxassetid://10734940654",
	["rotate-ccw"]           = "rbxassetid://10734940376",
	["refresh-cw"]           = "rbxassetid://10734933222",
	["share"]                = "rbxassetid://10734950813",
	["share-2"]              = "rbxassetid://10734950553",
	["link"]                 = "rbxassetid://10723426722",
	["link-2"]               = "rbxassetid://10723426595",
	["external-link"]        = "rbxassetid://10723346684",
	["clipboard"]            = "rbxassetid://10709799288",
	["clipboard-check"]      = "rbxassetid://10709798443",
	["clipboard-copy"]       = "rbxassetid://10709798574",
	["clipboard-list"]       = "rbxassetid://10709798792",
	["clipboard-x"]          = "rbxassetid://10709799124",
	["edit"]                 = "rbxassetid://10734883598",
	["edit-2"]               = "rbxassetid://10723344885",
	["edit-3"]               = "rbxassetid://10723345088",
	["pencil"]               = "rbxassetid://10734919691",
	["eraser"]               = "rbxassetid://10723346158",
	["scissors"]             = "rbxassetid://10734942778",
	["wifi"]                 = "rbxassetid://10747382504",
	["wifi-off"]             = "rbxassetid://10747382268",
	["bluetooth"]            = "rbxassetid://10709776655",
	["bluetooth-off"]        = "rbxassetid://10709776344",
	["signal"]               = "rbxassetid://10734961133",
	["signal-high"]          = "rbxassetid://10734954807",
	["signal-medium"]        = "rbxassetid://10734955336",
	["signal-low"]           = "rbxassetid://10734955080",
	["signal-zero"]          = "rbxassetid://10734960878",
	["battery"]              = "rbxassetid://10709774640",
	["battery-full"]         = "rbxassetid://10709774206",
	["battery-medium"]       = "rbxassetid://10709774513",
	["battery-low"]          = "rbxassetid://10709774370",
	["battery-charging"]     = "rbxassetid://10709774068",
	["monitor"]              = "rbxassetid://10734896881",
	["monitor-off"]          = "rbxassetid://10734896360",
	["server"]               = "rbxassetid://10734949856",
	["server-cog"]           = "rbxassetid://10734944444",
	["server-crash"]         = "rbxassetid://10734944554",
	["server-off"]           = "rbxassetid://10734944668",
	["hard-drive"]           = "rbxassetid://10723405749",
	["keyboard"]             = "rbxassetid://10723416765",
	["mouse"]                = "rbxassetid://10734898592",
	["printer"]              = "rbxassetid://10734930632",
	["smartphone"]           = "rbxassetid://10734963940",
	["tablet"]               = "rbxassetid://10734976394",
	["laptop"]               = "rbxassetid://10723423881",
	["camera"]               = "rbxassetid://10709789686",
	["camera-off"]           = "rbxassetid://10747822677",
	["mic"]                  = "rbxassetid://10734888864",
	["mic-2"]                = "rbxassetid://10734888430",
	["mic-off"]              = "rbxassetid://10734888646",
	["volume"]               = "rbxassetid://10747376008",
	["volume-1"]             = "rbxassetid://10747375450",
	["volume-2"]             = "rbxassetid://10747375679",
	["volume-x"]             = "rbxassetid://10747375880",
	["headphones"]           = "rbxassetid://10723406165",
	["speaker"]              = "rbxassetid://10734965419",
	["music"]                = "rbxassetid://10734905958",
	["music-2"]              = "rbxassetid://10734900215",
	["play"]                 = "rbxassetid://10734923549",
	["play-circle"]          = "rbxassetid://10734923214",
	["pause"]                = "rbxassetid://10734919336",
	["pause-circle"]         = "rbxassetid://10735024209",
	["stop-circle"]          = "rbxassetid://10734972621",
	["skip-back"]            = "rbxassetid://10734961526",
	["skip-forward"]         = "rbxassetid://10734961809",
	["rewind"]               = "rbxassetid://10734934347",
	["fast-forward"]         = "rbxassetid://10723354521",
	["repeat"]               = "rbxassetid://10734933966",
	["repeat-1"]             = "rbxassetid://10734933826",
	["shuffle"]              = "rbxassetid://10734953451",
	["heart"]                = "rbxassetid://10723406885",
	["heart-crack"]          = "rbxassetid://10723406299",
	["heart-off"]            = "rbxassetid://10723406662",
	["heart-pulse"]          = "rbxassetid://10723406795",
	["thumbs-up"]            = "rbxassetid://10734983629",
	["thumbs-down"]          = "rbxassetid://10734983359",
	["smile"]                = "rbxassetid://10734964441",
	["smile-plus"]           = "rbxassetid://10734964188",
	["frown"]                = "rbxassetid://10723394681",
	["meh"]                  = "rbxassetid://10734887603",
	["laugh"]                = "rbxassetid://10723424372",
	["angry"]                = "rbxassetid://10709761629",
	["annoyed"]              = "rbxassetid://10709761722",
	["gift"]                 = "rbxassetid://10723396402",
	["gift-card"]            = "rbxassetid://10723396225",
	["package"]              = "rbxassetid://10734909540",
	["package-2"]            = "rbxassetid://10734908151",
	["package-check"]        = "rbxassetid://10734908384",
	["package-open"]         = "rbxassetid://10734908793",
	["package-plus"]         = "rbxassetid://10734909016",
	["package-x"]            = "rbxassetid://10734909375",
	["shopping-bag"]         = "rbxassetid://10734952273",
	["shopping-cart"]        = "rbxassetid://10734952479",
	["tag"]                  = "rbxassetid://10734976528",
	["tags"]                 = "rbxassetid://10734976739",
	["ticket"]               = "rbxassetid://10734983868",
	["banknote"]             = "rbxassetid://10709770178",
	["coins"]                = "rbxassetid://10709811110",
	["dollar-sign"]          = "rbxassetid://10723343958",
	["euro"]                 = "rbxassetid://10723346372",
	["wallet"]               = "rbxassetid://10747376205",
	["piggy-bank"]           = "rbxassetid://10734921935",
	["gem"]                  = "rbxassetid://10723396000",
	["award"]                = "rbxassetid://10709769406",
	["bookmark"]             = "rbxassetid://10709782154",
	["bookmark-minus"]       = "rbxassetid://10709781919",
	["bookmark-plus"]        = "rbxassetid://10709782044",
	["flag"]                 = "rbxassetid://10723375890",
	["flag-off"]             = "rbxassetid://10723375443",
	["folder"]               = "rbxassetid://10723387563",
	["folder-open"]          = "rbxassetid://10723386277",
	["folder-plus"]          = "rbxassetid://10723386531",
	["folder-minus"]         = "rbxassetid://10723386127",
	["folder-x"]             = "rbxassetid://10723387448",
	["folder-check"]         = "rbxassetid://10723384605",
	["folder-lock"]          = "rbxassetid://10723386005",
	["file"]                 = "rbxassetid://10723374641",
	["file-text"]            = "rbxassetid://10723367380",
	["file-code"]            = "rbxassetid://10723356507",
	["file-image"]           = "rbxassetid://10723357790",
	["file-plus"]            = "rbxassetid://10723365877",
	["file-minus"]           = "rbxassetid://10723365254",
	["file-x"]               = "rbxassetid://10723374544",
	["file-check"]           = "rbxassetid://10723356210",
	["file-lock"]            = "rbxassetid://10723364957",
	["file-search"]          = "rbxassetid://10723366550",
	["file-edit"]            = "rbxassetid://10723357495",
	["mail"]                 = "rbxassetid://10734885430",
	["mail-check"]           = "rbxassetid://10723435182",
	["mail-open"]            = "rbxassetid://10723435342",
	["mail-plus"]            = "rbxassetid://10723435443",
	["mail-x"]               = "rbxassetid://10734885247",
	["mail-warning"]         = "rbxassetid://10734885015",
	["message-circle"]       = "rbxassetid://10734888000",
	["message-square"]       = "rbxassetid://10734888228",
	["send"]                 = "rbxassetid://10734943902",
	["reply"]                = "rbxassetid://10734934252",
	["reply-all"]            = "rbxassetid://10734934132",
	["forward"]              = "rbxassetid://10723388016",
	["calendar"]             = "rbxassetid://10709789505",
	["calendar-check"]       = "rbxassetid://10709783474",
	["calendar-plus"]        = "rbxassetid://10709788937",
	["calendar-minus"]       = "rbxassetid://10709783959",
	["calendar-x"]           = "rbxassetid://10709789407",
	["calendar-clock"]       = "rbxassetid://10709783577",
	["calendar-days"]        = "rbxassetid://10709783673",
	["clock"]                = "rbxassetid://10709805144",
	["timer"]                = "rbxassetid://10734984606",
	["timer-off"]            = "rbxassetid://10734984138",
	["timer-reset"]          = "rbxassetid://10734984355",
	["hourglass"]            = "rbxassetid://10723407498",
	["history"]              = "rbxassetid://10723407335",
	["sun"]                  = "rbxassetid://10734974297",
	["moon"]                 = "rbxassetid://10734897102",
	["cloud"]                = "rbxassetid://10709806740",
	["cloud-rain"]           = "rbxassetid://10709806277",
	["cloud-snow"]           = "rbxassetid://10709806374",
	["cloud-lightning"]      = "rbxassetid://10709805727",
	["snowflake"]            = "rbxassetid://10734964600",
	["thermometer"]          = "rbxassetid://10734983134",
	["droplet"]              = "rbxassetid://10723344432",
	["droplets"]             = "rbxassetid://10734883356",
	["waves"]                = "rbxassetid://10747376931",
	["flame2"]               = "rbxassetid://10723376114",
	["tornado"]              = "rbxassetid://10734985247",
	["anchor"]               = "rbxassetid://10709761530",
	["sailboat"]             = "rbxassetid://10734941354",
	["bus"]                  = "rbxassetid://10709783137",
	["train"]                = "rbxassetid://10747362105",
	["truck"]                = "rbxassetid://10747364031",
	["hammer"]               = "rbxassetid://10723405360",
	["axe"]                  = "rbxassetid://10709769508",
	["shovel"]               = "rbxassetid://10734952773",
	["ruler"]                = "rbxassetid://10734941018",
	["magnet"]               = "rbxassetid://10723435069",
	["microscope"]           = "rbxassetid://10734889106",
	["syringe"]              = "rbxassetid://10734975932",
	["stethoscope"]          = "rbxassetid://10734966384",
	["pill"]                 = "rbxassetid://10734922497",
	["beaker"]               = "rbxassetid://10709774756",
	["flask-conical"]        = "rbxassetid://10734883986",
	["flask-round"]          = "rbxassetid://10723376614",
	["atom"]                 = "rbxassetid://10709769598",
	["cpu2"]                 = "rbxassetid://10709813383",
	["bot"]                  = "rbxassetid://10709782230",
	["binary"]               = "rbxassetid://10709776050",
	["hash"]                 = "rbxassetid://10723405975",
	["percent"]              = "rbxassetid://10734919919",
	["power"]                = "rbxassetid://10734930466",
	["power-off"]            = "rbxassetid://10734930257",
	["toggle-left"]          = "rbxassetid://10734984834",
	["toggle-right"]         = "rbxassetid://10734985040",
	["loader"]               = "rbxassetid://10723434070",
	["loader-2"]             = "rbxassetid://10723433935",
	["more-horizontal"]      = "rbxassetid://10734897250",
	["more-vertical"]        = "rbxassetid://10734897387",
	["menu"]                 = "rbxassetid://10734887784",
	["sidebar"]              = "rbxassetid://10734954301",
	["sidebar-close"]        = "rbxassetid://10734953715",
	["sidebar-open"]         = "rbxassetid://10734954000",
	["layout"]               = "rbxassetid://10723425376",
	["layout-dashboard"]     = "rbxassetid://10723424646",
	["layout-grid"]          = "rbxassetid://10723424838",
	["layout-list"]          = "rbxassetid://10723424963",
	["columns"]              = "rbxassetid://10709811261",
	["rows"]                 = "rbxassetid://10709753570",
	["table"]                = "rbxassetid://10734976230",
	["table-2"]              = "rbxassetid://10734976097",
	["component"]            = "rbxassetid://10709811595",
	["puzzle"]               = "rbxassetid://10734930886",
	["layers2"]              = "rbxassetid://10723424505",
	["pen-tool"]             = "rbxassetid://10734919503",
	["wand"]                 = "rbxassetid://10747376565",
	["wand-2"]               = "rbxassetid://10747376349",
	["brush"]                = "rbxassetid://10709782758",
	["pipette"]              = "rbxassetid://10734922497",
	["highlighter"]          = "rbxassetid://10723407192",
	["type"]                 = "rbxassetid://10747364761",
	["bold"]                 = "rbxassetid://10747813908",
	["italic"]               = "rbxassetid://10723416195",
	["underline"]            = "rbxassetid://10747365191",
	["strikethrough"]        = "rbxassetid://10734973290",
	["quote"]                = "rbxassetid://10734931234",
	["indent"]               = "rbxassetid://10723415494",
	["outdent"]              = "rbxassetid://10734907933",
	["wrap-text"]            = "rbxassetid://10747383065",
	["locate"]               = "rbxassetid://10723434557",
	["locate-fixed"]         = "rbxassetid://10723434236",
	["locate-off"]           = "rbxassetid://10723434379",
	["help-circle"]          = "rbxassetid://10723406988",
	["log-in"]               = "rbxassetid://10723434830",
	["log-out"]              = "rbxassetid://10723434906",
	["import"]               = "rbxassetid://10723415205",
	["verified"]             = "rbxassetid://10747374131",
	["accessibility"]        = "rbxassetid://10709751939",
}

local Theme = {
	AcrylicMain     = Color3.fromRGB(22, 22, 28),
	TitleBarLine    = Color3.fromRGB(50, 50, 60),
	InElementBorder = Color3.fromRGB(48, 48, 58),
	bg              = Color3.fromRGB(14, 14, 18),
	card            = Color3.fromRGB(22, 22, 28),
	tabbar          = Color3.fromRGB(12, 12, 16),
	accentHi        = Color3.fromRGB(160, 100, 255),
	accentLo        = Color3.fromRGB(45, 15, 85),
	text            = Color3.fromRGB(230, 230, 235),
	muted           = Color3.fromRGB(120, 120, 135),
	dim             = Color3.fromRGB(50, 50, 62),
	section         = Color3.fromRGB(18, 18, 24),
	elemBg          = Color3.fromRGB(26, 26, 34),
	elemHover       = Color3.fromRGB(32, 32, 42),
	textureTint     = Color3.fromRGB(160, 100, 255),
}

local NOISE_TEX = "rbxassetid://9968344919"

local W, H   = 650, 450
local TOPBAR = 62
local ELEM_H = 30

local function ni(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do
		local ok, err = pcall(function() o[k] = v end)
		if not ok then
			print("[EcoHub] ni error ao setar " .. tostring(k) .. ": " .. tostring(err))
		end
	end
	if parent then o.Parent = parent end
	return o
end

local function corner(p, r)
	ni("UICorner", {CornerRadius = UDim.new(0, r or 8)}, p)
end

local function tw(obj, props, dur, style, dir)
	TweenService:Create(obj,
		TweenInfo.new(dur or 0.22, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
		props):Play()
end

local function addTexture(parent, alpha, zidx)
	local tex = ni("ImageLabel", {
		Size                   = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image                  = NOISE_TEX,
		ImageTransparency      = alpha or 0.88,
		ScaleType              = Enum.ScaleType.Tile,
		TileSize               = UDim2.new(0, 64, 0, 64),
		ZIndex                 = zidx or 0,
	}, parent)
	return tex
end

local function addBottomLine(parent, color, thickness)
	local line = ni("Frame", {
		Size             = UDim2.new(1, -16, 0, thickness or 1),
		Position         = UDim2.new(0, 8, 1, -(thickness or 1)),
		BackgroundColor3 = color or Theme.dim,
		BorderSizePixel  = 0,
	}, parent)
	corner(line, 1)
	return line
end

local Lib = {}
Lib.Icons = ICONS

function Lib.new(config)
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
		Position         = UDim2.new(0.5, -W/2, 0.5, -H/2),
		BackgroundColor3 = Theme.bg,
		BorderSizePixel  = 0,
		Active           = true,
		Draggable        = true,
		Visible          = true,
		ClipsDescendants = true,
	}, ScreenGui)
	corner(Main, 14)
	addTexture(Main, 0.92, 1)

	ni("UIStroke", {Color = Color3.fromRGB(60, 45, 90), Thickness = 1.2}, Main)

	local TopBar = ni("Frame", {
		Size             = UDim2.new(1, 0, 0, TOPBAR),
		BackgroundColor3 = Theme.AcrylicMain,
		BorderSizePixel  = 0,
		ZIndex           = 2,
	}, Main)
	corner(TopBar, 14)
	ni("Frame", {
		Size             = UDim2.new(1, 0, 0, 14),
		Position         = UDim2.new(0, 0, 1, -14),
		BackgroundColor3 = Theme.AcrylicMain,
		BorderSizePixel  = 0,
		ZIndex           = 2,
	}, TopBar)
	addTexture(TopBar, 0.85, 3)

	addBottomLine(TopBar, Theme.TitleBarLine, 1)

	ni("TextLabel", {
		Size                   = UDim2.new(0, 200, 1, 0),
		Position               = UDim2.new(0, 16, 0, 0),
		BackgroundTransparency = 1,
		Text                   = config.Title or "EcoHub",
		TextColor3             = Theme.text,
		TextSize               = 17,
		Font                   = Enum.Font.GothamBold,
		TextXAlignment         = Enum.TextXAlignment.Left,
		ZIndex                 = 4,
	}, TopBar)

	local logoSize = 52
	local logoFrame = ni("Frame", {
		Size                   = UDim2.new(0, logoSize, 0, logoSize),
		Position               = UDim2.new(0.5, -logoSize/2, 0.5, -logoSize/2),
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

	local blockW    = 170
	local UserBlock = ni("Frame", {
		Size                   = UDim2.new(0, blockW, 0, TOPBAR),
		Position               = UDim2.new(1, -blockW, 0, 0),
		BackgroundTransparency = 1,
		ZIndex                 = 4,
	}, TopBar)
	ni("Frame", {
		Size             = UDim2.new(0, 1, 0, 34),
		Position         = UDim2.new(0, 0, 0.5, -17),
		BackgroundColor3 = Theme.TitleBarLine,
		BorderSizePixel  = 0,
		ZIndex           = 4,
	}, UserBlock)

	local AvatarFrame = ni("Frame", {
		Size             = UDim2.new(0, 34, 0, 34),
		Position         = UDim2.new(0, 12, 0.5, -17),
		BackgroundColor3 = Theme.elemBg,
		BorderSizePixel  = 0,
		ZIndex           = 4,
	}, UserBlock)
	corner(AvatarFrame, 8)
	ni("UIStroke", {Color = Theme.InElementBorder, Thickness = 1}, AvatarFrame)
	local av = ni("ImageLabel", {
		Size                   = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image                  = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=60&height=60&format=png",
		ScaleType              = Enum.ScaleType.Crop,
		ZIndex                 = 5,
	}, AvatarFrame)
	corner(av, 8)

	ni("TextLabel", {
		Size = UDim2.new(1,-56,0,16), Position = UDim2.new(0,54,0.5,-18),
		BackgroundTransparency = 1, Text = LocalPlayer.DisplayName,
		TextColor3 = Theme.text, TextSize = 11,
		Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 4,
	}, UserBlock)
	ni("TextLabel", {
		Size = UDim2.new(1,-56,0,12), Position = UDim2.new(0,54,0.5,2),
		BackgroundTransparency = 1, Text = "@"..LocalPlayer.Name,
		TextColor3 = Theme.muted, TextSize = 9,
		Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 4,
	}, UserBlock)

	local PAD      = 6
	local TABBAR_H = 54

	local PageArea = ni("Frame", {
		Size                   = UDim2.new(1, -PAD*2, 1, -TOPBAR - TABBAR_H - PAD*2),
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
	corner(TabBar, 14)
	ni("Frame", {Size=UDim2.new(1,0,0,14), BackgroundColor3=Theme.tabbar, BorderSizePixel=0, ZIndex=5}, TabBar)
	ni("Frame", {Size=UDim2.new(1,0,0,1), BackgroundColor3=Theme.TitleBarLine, BorderSizePixel=0, ZIndex=5}, TabBar)
	addTexture(TabBar, 0.88, 6)

	local ICON_SIZE  = 26
	local SMALL_W    = 46
	local EXPANDED_W = 124
	local tabList    = {}
	local tabBtns    = {}
	local pages      = {}
	local curTab     = nil
	local animating  = false

	local function calcPositions(activeIdx)
		local expW = EXPANDED_W
		if EXPANDED_W + (#tabList-1)*SMALL_W > W-20 then
			expW = math.max(SMALL_W+20, W-20-(#tabList-1)*SMALL_W)
		end
		local pos = {}
		local x = 0
		for i = 1, #tabList do
			local w = (i == activeIdx) and expW or SMALL_W
			pos[i] = {x=x, w=w}
			x = x + w
		end
		local offset = math.max(4, math.floor((W-(expW+(#tabList-1)*SMALL_W))/2))
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
			tw(tb.bg, {Position=UDim2.new(0,p.x,0,0), Size=UDim2.new(0,p.w,1,0)}, 0.3)
			if active then
				tw(tb.sq,  {BackgroundColor3=Theme.accentLo},            0.25)
				tw(tb.str, {Color=Theme.accentHi, Thickness=1.5},        0.25)
				tw(tb.img, {ImageColor3=Theme.accentHi},                 0.25)
				tw(tb.lbl, {TextColor3=Theme.text,  TextTransparency=0}, 0.25)
				tw(tb.sub, {TextColor3=Theme.muted, TextTransparency=0}, 0.25)
			else
				tw(tb.sq,  {BackgroundColor3=Theme.card},                0.25)
				tw(tb.str, {Color=Theme.InElementBorder, Thickness=1},   0.25)
				tw(tb.img, {ImageColor3=Theme.dim},                      0.25)
				tw(tb.lbl, {TextTransparency=1},                         0.18)
				tw(tb.sub, {TextTransparency=1},                         0.18)
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
		Main.Visible = true
		Main.BackgroundTransparency = 1
		setChildrenVisible(false)
		tw(Main, {BackgroundTransparency=0}, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		task.delay(0.1,  function() setChildrenVisible(true) end)
		task.delay(0.28, function() animating = false end)
	end

	local function hideGui()
		if animating then return end
		animating = true
		setChildrenVisible(false)
		tw(Main, {BackgroundTransparency=1}, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		task.delay(0.24, function() Main.Visible = false animating = false end)
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
		cfg           = cfg or {}
		local name    = cfg.Name or ("Tab"..tostring(#tabList+1))
		local subText = cfg.Sub  or ""
		local iconId  = cfg.Icon or ICONS.aim
		if type(iconId) == "string" and not iconId:match("rbxasset") then
			iconId = ICONS[iconId] or ICONS.aim
		end

		local pg = ni("Frame", {
			Name = name, Size = UDim2.new(1,0,1,0),
			BackgroundTransparency = 1, Visible = false,
		}, PageArea)
		pages[name] = pg
		table.insert(tabList, {name=name, sub=subText, icon=iconId})

		local idx = #tabList
		local positions = calcPositions(idx)
		for i, tb in ipairs(tabBtns) do
			local p = positions[i]
			tb.bg.Position = UDim2.new(0,p.x,0,0)
			tb.bg.Size     = UDim2.new(0,SMALL_W,1,0)
		end

		local p  = positions[idx]
		local bg = ni("Frame", {
			Size = UDim2.new(0,SMALL_W,1,0), Position = UDim2.new(0,p.x,0,0),
			BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true,
			ZIndex = 6,
		}, TabBar)
		local sq = ni("Frame", {
			Size = UDim2.new(0,36,0,36), Position = UDim2.new(0,5,0.5,-18),
			BackgroundColor3 = Theme.card, BorderSizePixel = 0,
			ZIndex = 7,
		}, bg)
		corner(sq, 9)
		addTexture(sq, 0.82, 8)
		local sqStr = ni("UIStroke", {Color=Theme.InElementBorder, Thickness=1}, sq)
		local img = ni("ImageLabel", {
			Size = UDim2.new(0,ICON_SIZE,0,ICON_SIZE),
			Position = UDim2.new(0.5,-ICON_SIZE/2,0.5,-ICON_SIZE/2),
			BackgroundTransparency = 1, Image = iconId, ImageColor3 = Theme.dim,
			ZIndex = 9,
		}, sq)
		local lbl = ni("TextLabel", {
			Size = UDim2.new(1,-48,0,15), Position = UDim2.new(0,46,0.5,-13),
			BackgroundTransparency = 1, Text = name, TextColor3 = Theme.text,
			TextSize = 11, Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1,
			ZIndex = 7,
		}, bg)
		local sub_lbl = ni("TextLabel", {
			Size = UDim2.new(1,-48,0,10), Position = UDim2.new(0,46,0.5,3),
			BackgroundTransparency = 1, Text = subText, TextColor3 = Theme.muted,
			TextSize = 8, Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1,
			ZIndex = 7,
		}, bg)
		local btn = ni("TextButton", {
			Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
			Text = "", BorderSizePixel = 0, ZIndex = 12,
		}, bg)

		tabBtns[idx] = {name=name, bg=bg, sq=sq, str=sqStr, img=img, lbl=lbl, sub=sub_lbl}
		btn.MouseButton1Click:Connect(function() switchTo(name) end)
		btn.MouseEnter:Connect(function()
			if curTab ~= name then
				tw(sq,  {BackgroundColor3=Theme.elemHover}, 0.12)
				tw(img, {ImageColor3=Theme.muted},          0.12)
			end
		end)
		btn.MouseLeave:Connect(function()
			if curTab ~= name then
				tw(sq,  {BackgroundColor3=Theme.card}, 0.12)
				tw(img, {ImageColor3=Theme.dim},       0.12)
			end
		end)

		local function makeSection(secName)
			local f = ni("Frame", {
				Name=secName, BackgroundColor3=Theme.section, BorderSizePixel=0,
			}, pg)
			corner(f, 10)
			addTexture(f, 0.9, 1)
			return f
		end

		local sectionLeft   = makeSection("SectionLeft")
		local sectionCenter = makeSection("SectionCenter")
		local sectionRight  = makeSection("SectionRight")

		local function layoutSections()
			local totalW = PageArea.AbsoluteSize.X - PAD*2
			local totalH = PageArea.AbsoluteSize.Y - PAD*2
			local gap    = PAD
			local eachW  = math.floor((totalW - gap*2) / 3)
			sectionLeft.Position   = UDim2.new(0,PAD,0,PAD)
			sectionLeft.Size       = UDim2.new(0,eachW,0,totalH)
			sectionCenter.Position = UDim2.new(0,PAD+eachW+gap,0,PAD)
			sectionCenter.Size     = UDim2.new(0,eachW,0,totalH)
			sectionRight.Position  = UDim2.new(0,PAD+(eachW+gap)*2,0,PAD)
			sectionRight.Size      = UDim2.new(0,eachW,0,totalH)
		end

		layoutSections()
		PageArea:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutSections)

		local tab = {}
		tab.Page          = pg
		tab.SectionLeft   = sectionLeft
		tab.SectionCenter = sectionCenter
		tab.SectionRight  = sectionRight

		function tab:AddSection(cfg2)
			cfg2       = cfg2 or {}
			local side = cfg2.Side  or "Left"
			local title   = cfg2.Title or ""
			local iconId2 = cfg2.Icon  or ""
			local target
			if side == "Left"       then target = sectionLeft
			elseif side == "Center" then target = sectionCenter
			elseif side == "Right"  then target = sectionRight
			end
			if iconId2 ~= "" and not iconId2:match("rbxasset") then
				iconId2 = ICONS[iconId2] or iconId2
			end

			local HEADER_H = 34
			if title ~= "" then
				local titleBar = ni("Frame", {
					Size = UDim2.new(1,0,0,HEADER_H),
					BackgroundColor3 = Theme.section, BorderSizePixel = 0,
					ZIndex = 2,
				}, target)
				local txtX = 10
				if iconId2 ~= "" then
					ni("ImageLabel", {
						Size = UDim2.new(0,18,0,18), Position = UDim2.new(0,10,0.5,-9),
						BackgroundTransparency = 1, Image = iconId2, ImageColor3 = Theme.accentHi,
						ZIndex = 3,
					}, titleBar)
					txtX = 32
				end
				ni("TextLabel", {
					Size = UDim2.new(1,-txtX-4,1,0), Position = UDim2.new(0,txtX,0,0),
					BackgroundTransparency = 1, Text = title,
					TextColor3 = Theme.accentHi, TextSize = 11,
					Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 3,
				}, titleBar)
				ni("Frame", {
					Size = UDim2.new(1,-12,0,1), Position = UDim2.new(0,6,1,-1),
					BackgroundColor3 = Theme.dim, BorderSizePixel = 0,
					ZIndex = 3,
				}, titleBar)
			end

			local scroll = ni("ScrollingFrame", {
				Size                 = UDim2.new(1,-4,1,-HEADER_H),
				Position             = UDim2.new(0,2,0,HEADER_H),
				BackgroundTransparency = 1,
				BorderSizePixel      = 0,
				ScrollBarThickness   = 3,
				ScrollBarImageColor3 = Theme.accentHi,
				CanvasSize           = UDim2.new(0,0,0,0),
				ScrollingDirection   = Enum.ScrollingDirection.Y,
				ClipsDescendants     = true,
				ZIndex               = 2,
			}, target)

			local layout = Instance.new("UIListLayout")
			layout.SortOrder           = Enum.SortOrder.LayoutOrder
			layout.Padding             = UDim.new(0, 3)
			layout.FillDirection       = Enum.FillDirection.Vertical
			layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			layout.Parent              = scroll

			local pad = Instance.new("UIPadding")
			pad.PaddingLeft   = UDim.new(0, 5)
			pad.PaddingRight  = UDim.new(0, 5)
			pad.PaddingTop    = UDim.new(0, 5)
			pad.PaddingBottom = UDim.new(0, 5)
			pad.Parent        = scroll

			local function updateCanvas()
				scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 14)
			end
			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

			local sec  = {}
			sec.Frame  = target
			sec.Scroll = scroll

			local rowCount = 0
			local function newRow(h)
				rowCount = rowCount + 1
				local r = ni("Frame", {
					Size             = UDim2.new(1,0,0,h),
					BackgroundColor3 = Theme.elemBg,
					BorderSizePixel  = 0,
					LayoutOrder      = rowCount,
					ZIndex           = 3,
				}, scroll)
				corner(r, 7)
				addTexture(r, 0.86, 4)
				ni("UIStroke", {Color=Theme.InElementBorder, Thickness=0.8}, r)
				addBottomLine(r, Theme.dim, 1)
				return r
			end

			function sec:AddToggle(cfg3)
				cfg3           = cfg3 or {}
				local label    = cfg3.Name     or "Toggle"
				local saveId   = cfg3.SaveId   or label
				local default  = cfg3.Default  or false
				local callback = cfg3.Callback or function() end
				local state    = getSaved(saveId, not not default)

				local row = newRow(ELEM_H)
				ni("TextLabel", {
					Size = UDim2.new(1,-56,1,0), Position = UDim2.new(0,10,0,0),
					BackgroundTransparency = 1, Text = label,
					TextColor3 = Theme.text, TextSize = 10,
					Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 5,
				}, row)

				local trkW, trkH = 32, 17
				local track = ni("Frame", {
					Size             = UDim2.new(0,trkW,0,trkH),
					Position         = UDim2.new(1,-trkW-8,0.5,-trkH/2),
					BackgroundColor3 = state and Theme.accentHi or Theme.dim,
					BorderSizePixel  = 0,
					ZIndex           = 5,
				}, row)
				corner(track, trkH)
				addTexture(track, 0.80, 6)
				local stroke = ni("UIStroke", {
					Color     = state and Theme.accentHi or Theme.InElementBorder,
					Thickness = 1,
				}, track)

				local knobSz = 13
				local knob = ni("Frame", {
					Size             = UDim2.new(0,knobSz,0,knobSz),
					Position         = state and UDim2.new(1,-knobSz-2,0.5,-knobSz/2) or UDim2.new(0,2,0.5,-knobSz/2),
					BackgroundColor3 = Theme.text,
					BorderSizePixel  = 0,
					ZIndex           = 7,
				}, track)
				corner(knob, knobSz)
				ni("UIStroke", {Color=Color3.fromRGB(200,180,255), Thickness=0.5}, knob)

				local function applyState(v, animate)
					local dur = animate and 0.22 or 0
					tw(track,  {BackgroundColor3=v and Theme.accentHi or Theme.dim}, dur)
					tw(stroke, {Color=v and Theme.accentHi or Theme.InElementBorder}, dur)
					tw(knob,   {Position=v and UDim2.new(1,-knobSz-2,0.5,-knobSz/2) or UDim2.new(0,2,0.5,-knobSz/2)}, dur)
				end

				local btn = ni("TextButton", {
					Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 8,
				}, row)
				btn.MouseButton1Click:Connect(function()
					state = not state
					applyState(state, true)
					setSaved(saveId, state)
					callback(state)
				end)

				local el = {Value = state}
				function el:Set(v)
					state    = not not v
					el.Value = state
					applyState(state, true)
					setSaved(saveId, state)
					callback(state)
				end
				function el:OnChanged(fn)
					local oldCb = callback
					callback = function(val)
						oldCb(val)
						fn(val)
					end
					fn(state)
				end
				applyState(state, false)
				task.defer(function() callback(state) end)
				return el
			end

			function sec:AddSlider(cfg3)
				cfg3           = cfg3 or {}
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

				local row = newRow(ELEM_H + 16)
				ni("TextLabel", {
					Size = UDim2.new(1,-56,0,15), Position = UDim2.new(0,10,0,6),
					BackgroundTransparency = 1, Text = label,
					TextColor3 = Theme.text, TextSize = 10,
					Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 5,
				}, row)

				local valLbl = ni("TextLabel", {
					Size = UDim2.new(0,46,0,15), Position = UDim2.new(1,-50,0,6),
					BackgroundTransparency = 1,
					Text = tostring(roundVal(value))..suffix,
					TextColor3 = Theme.accentHi, TextSize = 10,
					Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Right,
					ZIndex = 5,
				}, row)

				local railBg = ni("Frame", {
					Size = UDim2.new(1,-22,0,5), Position = UDim2.new(0,11,0,28),
					BackgroundColor3 = Theme.dim, BorderSizePixel = 0,
					ZIndex = 5,
				}, row)
				corner(railBg, 5)
				addTexture(railBg, 0.78, 6)

				local pct  = (value - minV) / (maxV - minV)
				local fill = ni("Frame", {
					Size = UDim2.new(pct,0,1,0),
					BackgroundColor3 = Theme.accentHi, BorderSizePixel = 0,
					ZIndex = 6,
				}, railBg)
				corner(fill, 5)
				addTexture(fill, 0.75, 7)

				local dot = ni("Frame", {
					Size             = UDim2.new(0,13,0,13),
					AnchorPoint      = Vector2.new(0.5,0.5),
					Position         = UDim2.new(pct,0,0.5,0),
					BackgroundColor3 = Theme.text,
					BorderSizePixel  = 0,
					ZIndex           = 8,
				}, railBg)
				corner(dot, 13)
				ni("UIStroke", {Color=Theme.accentHi, Thickness=1.5}, dot)
				addTexture(dot, 0.7, 9)

				local function setVal(v, animate)
					value = roundVal(math.clamp(v, minV, maxV))
					local p   = (value - minV) / (maxV - minV)
					local dur = animate and 0.1 or 0
					tw(fill, {Size=UDim2.new(p,0,1,0)}, dur)
					tw(dot,  {Position=UDim2.new(p,0,0.5,0)}, dur)
					valLbl.Text = tostring(value)..suffix
					setSaved(saveId, value)
					callback(value)
				end

				local dragging = false
				local function onDrag(absX)
					local rel = math.clamp((absX - railBg.AbsolutePosition.X) / railBg.AbsoluteSize.X, 0, 1)
					setVal(minV + rel*(maxV-minV), false)
				end

				local hitBtn = ni("TextButton", {
					Size = UDim2.new(1,0,0,ELEM_H+16), Position = UDim2.new(0,0,0,0),
					BackgroundTransparency = 1, Text = "", BorderSizePixel = 0, ZIndex = 9,
				}, row)
				hitBtn.MouseButton1Down:Connect(function(x) dragging = true onDrag(x) end)
				hitBtn.MouseButton1Up:Connect(function() dragging = false end)
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

				local el = {Value = value}
				function el:Set(v)
					setVal(v, true)
					el.Value = value
				end
				function el:OnChanged(fn)
					local oldCb = callback
					callback = function(val)
						oldCb(val)
						fn(val)
					end
					fn(value)
				end
				setVal(value, false)
				task.defer(function() callback(value) end)
				return el
			end

			function sec:AddKeybind(cfg3)
				cfg3           = cfg3 or {}
				local label    = cfg3.Name     or "Keybind"
				local saveId   = cfg3.SaveId   or label
				local default  = cfg3.Default  or Enum.KeyCode.Unknown
				local callback = cfg3.Callback or function() end

				local savedKeyName = getSaved(saveId, nil)
				local key = default
				if savedKeyName then
					local ok, k = pcall(function()
						return Enum.KeyCode[savedKeyName]
					end)
					if ok and k then
						key = k
					else
						print("[EcoHub] AddKeybind: chave salva invalida '" .. tostring(savedKeyName) .. "', usando default.")
					end
				end

				local listening = false

				local row = newRow(ELEM_H)
				ni("TextLabel", {
					Size = UDim2.new(1,-72,1,0), Position = UDim2.new(0,10,0,0),
					BackgroundTransparency = 1, Text = label,
					TextColor3 = Theme.text, TextSize = 10,
					Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 5,
				}, row)

				local kBox = ni("Frame", {
					Size = UDim2.new(0,62,0,19), Position = UDim2.new(1,-68,0.5,-9.5),
					BackgroundColor3 = Theme.bg, BorderSizePixel = 0,
					ZIndex = 5,
				}, row)
				corner(kBox, 5)
				addTexture(kBox, 0.82, 6)
				local kStr = ni("UIStroke", {Color=Theme.InElementBorder, Thickness=1}, kBox)

				local keyName = type(key) == "userdata" and key.Name or tostring(key)
				local kLbl = ni("TextLabel", {
					Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
					Text = keyName, TextColor3 = Theme.accentHi,
					TextSize = 9, Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextTruncate = Enum.TextTruncate.AtEnd,
					ZIndex = 7,
				}, kBox)

				local btn = ni("TextButton", {
					Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 8,
				}, row)
				btn.MouseButton1Click:Connect(function()
					listening       = true
					kLbl.Text       = "..."
					kLbl.TextColor3 = Theme.muted
					tw(kStr, {Color=Theme.accentHi}, 0.12)
				end)
				UserInputService.InputBegan:Connect(function(input, processed)
					if listening then
						if input.UserInputType == Enum.UserInputType.Keyboard then
							listening       = false
							key             = input.KeyCode
							kLbl.Text       = key.Name
							kLbl.TextColor3 = Theme.accentHi
							tw(kStr, {Color=Theme.InElementBorder}, 0.12)
							setSaved(saveId, key.Name)
							callback(key)
						end
					end
				end)

				local el = {Value = key}
				function el:Set(k)
					key       = k
					el.Value  = k
					local n   = type(k) == "userdata" and k.Name or tostring(k)
					kLbl.Text = n
					setSaved(saveId, n)
					callback(key)
				end
				function el:OnChanged(fn)
					local oldCb = callback
					callback = function(val)
						oldCb(val)
						fn(val)
					end
					fn(key)
				end
				return el
			end

			function sec:AddDropdown(cfg3)
				cfg3           = cfg3 or {}
				local label    = cfg3.Name     or "Menu"
				local saveId   = cfg3.SaveId   or label
				local options  = cfg3.Options  or {}
				local default  = cfg3.Default  or (options[1] or "")
				local callback = cfg3.Callback or function() end
				local selected = getSaved(saveId, default)
				local open     = false

				local OPT_H     = 23
				local totalOptH = #options * OPT_H

				rowCount = rowCount + 1
				local wrapper = ni("Frame", {
					Size = UDim2.new(1,0,0,ELEM_H),
					BackgroundTransparency = 1, BorderSizePixel = 0,
					LayoutOrder = rowCount, ClipsDescendants = false,
				}, scroll)

				local row = ni("Frame", {
					Size = UDim2.new(1,0,0,ELEM_H),
					BackgroundColor3 = Theme.elemBg, BorderSizePixel = 0,
					ZIndex = 3,
				}, wrapper)
				corner(row, 7)
				addTexture(row, 0.86, 4)
				ni("UIStroke", {Color=Theme.InElementBorder, Thickness=0.8}, row)
				addBottomLine(row, Theme.dim, 1)

				ni("TextLabel", {
					Size = UDim2.new(1,-82,1,0), Position = UDim2.new(0,10,0,0),
					BackgroundTransparency = 1, Text = label,
					TextColor3 = Theme.text, TextSize = 10,
					Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 5,
				}, row)

				local selBox = ni("Frame", {
					Size = UDim2.new(0,72,0,19), Position = UDim2.new(1,-78,0.5,-9.5),
					BackgroundColor3 = Theme.bg, BorderSizePixel = 0,
					ZIndex = 5,
				}, row)
				corner(selBox, 5)
				addTexture(selBox, 0.82, 6)
				ni("UIStroke", {Color=Theme.InElementBorder, Thickness=1}, selBox)

				local selLbl = ni("TextLabel", {
					Size = UDim2.new(1,-16,1,0), Position = UDim2.new(0,5,0,0),
					BackgroundTransparency = 1, Text = selected,
					TextColor3 = Theme.accentHi, TextSize = 9,
					Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					ZIndex = 7,
				}, selBox)
				ni("TextLabel", {
					Size = UDim2.new(0,12,1,0), Position = UDim2.new(1,-13,0,0),
					BackgroundTransparency = 1, Text = "▾",
					TextColor3 = Theme.muted, TextSize = 10,
					Font = Enum.Font.GothamBold,
					ZIndex = 7,
				}, selBox)

				local dropdown = ni("Frame", {
					Size = UDim2.new(1,0,0,0),
					Position = UDim2.new(0,0,0,ELEM_H+3),
					BackgroundColor3 = Theme.elemBg, BorderSizePixel = 0,
					ClipsDescendants = true, ZIndex = 20, Visible = false,
				}, wrapper)
				corner(dropdown, 7)
				ni("UIStroke", {Color=Theme.InElementBorder, Thickness=0.8}, dropdown)
				addTexture(dropdown, 0.86, 21)

				local optHolder = ni("Frame", {
					Size = UDim2.new(1,0,0,totalOptH),
					BackgroundTransparency = 1, ZIndex = 22,
				}, dropdown)
				ni("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,0)}, optHolder)

				for i2, opt in ipairs(options) do
					local isSelected = (opt == selected)
					local optBtn = ni("TextButton", {
						Size = UDim2.new(1,0,0,OPT_H),
						BackgroundColor3 = isSelected and Theme.accentLo or Theme.elemBg,
						BorderSizePixel = 0, Text = "",
						ZIndex = 23, LayoutOrder = i2,
					}, optHolder)
					ni("TextLabel", {
						Size = UDim2.new(1,-8,1,0), Position = UDim2.new(0,8,0,0),
						BackgroundTransparency = 1, Text = opt,
						TextColor3 = isSelected and Theme.accentHi or Theme.muted,
						TextSize = 9, Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = 24,
					}, optBtn)
					optBtn.MouseButton1Click:Connect(function()
						for _, ch in ipairs(optHolder:GetChildren()) do
							if ch:IsA("TextButton") then
								local lbl2 = ch:FindFirstChildWhichIsA("TextLabel")
								local sel2 = lbl2 and lbl2.Text == opt
								tw(ch,    {BackgroundColor3=sel2 and Theme.accentLo or Theme.elemBg}, 0.12)
								if lbl2 then tw(lbl2, {TextColor3=sel2 and Theme.accentHi or Theme.muted}, 0.12) end
							end
						end
						selected    = opt
						selLbl.Text = opt
						open        = false
						wrapper.Size = UDim2.new(1,0,0,ELEM_H)
						tw(dropdown, {Size=UDim2.new(1,0,0,0)}, 0.18)
						task.delay(0.19, function() dropdown.Visible = false end)
						setSaved(saveId, selected)
						callback(selected)
					end)
					optBtn.MouseEnter:Connect(function()
						if opt ~= selected then tw(optBtn, {BackgroundColor3=Theme.elemHover}, 0.1) end
					end)
					optBtn.MouseLeave:Connect(function()
						if opt ~= selected then tw(optBtn, {BackgroundColor3=Theme.elemBg}, 0.1) end
					end)
				end

				local toggleBtn = ni("TextButton", {
					Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 8,
				}, row)
				toggleBtn.MouseButton1Click:Connect(function()
					open = not open
					if open then
						dropdown.Visible = true
						dropdown.Size    = UDim2.new(1,0,0,0)
						wrapper.Size     = UDim2.new(1,0,0,ELEM_H+totalOptH+5)
						tw(dropdown, {Size=UDim2.new(1,0,0,totalOptH)}, 0.2)
					else
						wrapper.Size = UDim2.new(1,0,0,ELEM_H)
						tw(dropdown, {Size=UDim2.new(1,0,0,0)}, 0.18)
						task.delay(0.19, function() dropdown.Visible = false end)
					end
				end)

				local el = {Value = selected}
				function el:Set(v)
					selected    = v
					selLbl.Text = v
					el.Value    = v
					setSaved(saveId, v)
					callback(v)
				end
				function el:SetOptions(newOpts)
					options     = newOpts
					totalOptH   = #options * OPT_H
					for _, ch in ipairs(optHolder:GetChildren()) do
						if not ch:IsA("UIListLayout") then ch:Destroy() end
					end
					for i2, opt in ipairs(options) do
						local optBtn = ni("TextButton", {
							Size = UDim2.new(1,0,0,OPT_H),
							BackgroundColor3 = Theme.elemBg, BorderSizePixel = 0,
							Text = "", ZIndex = 23, LayoutOrder = i2,
						}, optHolder)
						ni("TextLabel", {
							Size = UDim2.new(1,-8,1,0), Position = UDim2.new(0,8,0,0),
							BackgroundTransparency = 1, Text = opt,
							TextColor3 = Theme.muted, TextSize = 9,
							Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
							ZIndex = 24,
						}, optBtn)
					end
					optHolder.Size = UDim2.new(1,0,0,totalOptH)
				end
				function el:OnChanged(fn)
					local oldCb = callback
					callback = function(val)
						oldCb(val)
						fn(val)
					end
					fn(selected)
				end
				task.defer(function() callback(selected) end)
				return el
			end

			function sec:AddParagraph(cfg3)
				cfg3        = cfg3 or {}
				local title = cfg3.Title or ""
				local text  = cfg3.Text  or ""
				local lines = math.max(1, math.ceil(#text / 26))
				local rowH  = (title ~= "" and 14 or 0) + lines*12 + 12

				local row = newRow(rowH)
				if title ~= "" then
					ni("TextLabel", {
						Size = UDim2.new(1,-10,0,13), Position = UDim2.new(0,10,0,5),
						BackgroundTransparency = 1, Text = title,
						TextColor3 = Theme.accentHi, TextSize = 10,
						Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = 5,
					}, row)
				end
				local txtLbl = ni("TextLabel", {
					Size     = UDim2.new(1,-10,0,lines*12),
					Position = UDim2.new(0,10,0,title ~= "" and 18 or 5),
					BackgroundTransparency = 1, Text = text,
					TextColor3 = Theme.muted, TextSize = 9,
					Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					ZIndex = 5,
				}, row)

				local el = {Frame = row}
				function el:Set(t) txtLbl.Text = t end
				return el
			end

			function sec:AddLabel(cfg3)
				cfg3        = cfg3 or {}
				local text  = cfg3.Text  or "Label"
				local color = cfg3.Color or Theme.muted

				local row = newRow(ELEM_H)
				local lbl = ni("TextLabel", {
					Size = UDim2.new(1,-10,1,0), Position = UDim2.new(0,10,0,0),
					BackgroundTransparency = 1, Text = text,
					TextColor3 = color, TextSize = 10,
					Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 5,
				}, row)

				local el = {Frame = row}
				function el:Set(t, c)
					lbl.Text = t
					if c then lbl.TextColor3 = c end
				end
				return el
			end

			function sec:AddButton(cfg3)
				cfg3           = cfg3 or {}
				local label    = cfg3.Name     or "Button"
				local callback = cfg3.Callback or function() end

				local row = newRow(ELEM_H)
				local lbl = ni("TextLabel", {
					Size = UDim2.new(1,-10,1,0), Position = UDim2.new(0,10,0,0),
					BackgroundTransparency = 1, Text = label,
					TextColor3 = Theme.text, TextSize = 10,
					Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 5,
				}, row)

				local indicator = ni("Frame", {
					Size = UDim2.new(0,3,0,18), Position = UDim2.new(0,0,0.5,-9),
					BackgroundColor3 = Theme.accentHi, BorderSizePixel = 0,
					ZIndex = 5,
				}, row)
				corner(indicator, 3)

				local btn = ni("TextButton", {
					Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 8,
				}, row)
				btn.MouseButton1Click:Connect(function()
					tw(row, {BackgroundColor3=Theme.accentLo}, 0.1)
					task.delay(0.15, function() tw(row, {BackgroundColor3=Theme.elemBg}, 0.15) end)
					callback()
				end)
				btn.MouseEnter:Connect(function()
					tw(row, {BackgroundColor3=Theme.elemHover}, 0.12)
				end)
				btn.MouseLeave:Connect(function()
					tw(row, {BackgroundColor3=Theme.elemBg}, 0.12)
				end)

				local el = {Frame = row}
				return el
			end

			function sec:AddColorPicker(cfg3)
				cfg3           = cfg3 or {}
				local label    = cfg3.Name     or "Color"
				local saveId   = cfg3.SaveId   or label
				local default  = cfg3.Default  or Color3.fromRGB(160, 100, 255)
				local callback = cfg3.Callback or function() end

				local savedColor = getSaved(saveId, nil)
				local color = default
				if savedColor and type(savedColor) == "table" then
					local ok, c = pcall(function()
						return Color3.fromRGB(savedColor.r or 160, savedColor.g or 100, savedColor.b or 255)
					end)
					if ok then
						color = c
					else
						print("[EcoHub] AddColorPicker: cor salva invalida para '" .. saveId .. "', usando default.")
					end
				end

				local open  = false
				local H_PICKER = 96

				rowCount = rowCount + 1
				local wrapper = ni("Frame", {
					Size = UDim2.new(1,0,0,ELEM_H),
					BackgroundTransparency = 1, BorderSizePixel = 0,
					LayoutOrder = rowCount, ClipsDescendants = false,
				}, scroll)

				local row = ni("Frame", {
					Size = UDim2.new(1,0,0,ELEM_H),
					BackgroundColor3 = Theme.elemBg, BorderSizePixel = 0, ZIndex = 3,
				}, wrapper)
				corner(row, 7)
				addTexture(row, 0.86, 4)
				ni("UIStroke", {Color=Theme.InElementBorder, Thickness=0.8}, row)
				addBottomLine(row, Theme.dim, 1)

				ni("TextLabel", {
					Size = UDim2.new(1,-50,1,0), Position = UDim2.new(0,10,0,0),
					BackgroundTransparency = 1, Text = label,
					TextColor3 = Theme.text, TextSize = 10,
					Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 5,
				}, row)

				local preview = ni("Frame", {
					Size = UDim2.new(0,22,0,22), Position = UDim2.new(1,-28,0.5,-11),
					BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 5,
				}, row)
				corner(preview, 5)
				ni("UIStroke", {Color=Theme.InElementBorder, Thickness=1}, preview)

				local picker = ni("Frame", {
					Size = UDim2.new(1,0,0,H_PICKER),
					Position = UDim2.new(0,0,0,ELEM_H+3),
					BackgroundColor3 = Theme.bg, BorderSizePixel = 0,
					Visible = false, ZIndex = 20,
				}, wrapper)
				corner(picker, 8)
				ni("UIStroke", {Color=Theme.InElementBorder, Thickness=0.8}, picker)
				addTexture(picker, 0.88, 21)

				local huebar = ni("Frame", {
					Size = UDim2.new(1,-14,0,14), Position = UDim2.new(0,7,0,8),
					BackgroundColor3 = Color3.fromRGB(255,255,255), BorderSizePixel = 0, ZIndex = 22,
				}, picker)
				corner(huebar, 7)
				local hueGrad = Instance.new("UIGradient")
				hueGrad.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0,     Color3.fromRGB(255,0,0)),
					ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255,255,0)),
					ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0,255,0)),
					ColorSequenceKeypoint.new(0.5,   Color3.fromRGB(0,255,255)),
					ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0,0,255)),
					ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255,0,255)),
					ColorSequenceKeypoint.new(1,     Color3.fromRGB(255,0,0)),
				})
				hueGrad.Parent = huebar

				local satFrame = ni("Frame", {
					Size = UDim2.new(1,-14,0,54), Position = UDim2.new(0,7,0,28),
					BackgroundColor3 = Color3.fromRGB(255,255,255), BorderSizePixel = 0, ZIndex = 22,
				}, picker)
				corner(satFrame, 5)

				local hueH2, satV2, briV = Color3.toHSV(color)

				local satGrad = Instance.new("UIGradient")
				satGrad.Color  = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromHSV(hueH2,1,1))
				satGrad.Parent = satFrame

				local function updateColor()
					color = Color3.fromHSV(hueH2, satV2, briV)
					preview.BackgroundColor3 = color
					satGrad.Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromHSV(hueH2,1,1))
					setSaved(saveId, {
						r = math.floor(color.R*255),
						g = math.floor(color.G*255),
						b = math.floor(color.B*255)
					})
					callback(color)
				end

				local hueDrag, satDrag = false, false

				local hueBtn = ni("TextButton", {
					Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", ZIndex = 23,
				}, huebar)
				hueBtn.MouseButton1Down:Connect(function(x)
					hueDrag = true
					hueH2   = math.clamp((x - huebar.AbsolutePosition.X) / huebar.AbsoluteSize.X, 0, 1)
					updateColor()
				end)
				hueBtn.MouseButton1Up:Connect(function() hueDrag = false end)

				local satBtn = ni("TextButton", {
					Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", ZIndex = 23,
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
						hueDrag = false satDrag = false
					end
				end)

				local openBtn = ni("TextButton", {
					Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
					Text = "", BorderSizePixel = 0, ZIndex = 8,
				}, row)
				openBtn.MouseButton1Click:Connect(function()
					open = not open
					picker.Visible = open
					wrapper.Size = open and UDim2.new(1,0,0,ELEM_H+H_PICKER+5) or UDim2.new(1,0,0,ELEM_H)
				end)

				local el = {Value = color}
				function el:Set(c)
					color = c
					el.Value = c
					preview.BackgroundColor3 = c
					local h, s, v = Color3.toHSV(c)
					hueH2 = h satV2 = s briV = v
					updateColor()
					callback(c)
				end
				function el:OnChanged(fn)
					local oldCb = callback
					callback = function(val)
						oldCb(val)
						fn(val)
					end
					fn(color)
				end
				task.defer(function() callback(color) end)
				return el
			end

			return sec
		end

		if #tabList == 1 then
			switchTo(name)
		end

		return tab
	end

	return win
end

return Lib
