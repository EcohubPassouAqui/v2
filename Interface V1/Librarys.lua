local UIS     = game:GetService("UserInputService")
local TS      = game:GetService("TweenService")
local RS      = game:GetService("RunService")
local Players = game:GetService("Players")
local HTTP    = game:GetService("HttpService")
local lp      = Players.LocalPlayer

do
	local mobile = UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled
	if mobile then
		pcall(function() lp:Kick("[EcoHub] Mobile devices are not supported.") end)
		return
	end
end

local function cleanOld(parent)
	if not parent then return end
	for _, v in ipairs(parent:GetChildren()) do
		if type(v.Name) == "string" and v.Name:sub(1,7) == "ecohub_" then
			pcall(function() v:Destroy() end)
		end
	end
end
pcall(function() cleanOld(game:GetService("CoreGui")) end)
pcall(function() if gethui then cleanOld(gethui()) end end)

local _iconReg = {
	["lucide-accessibility"] = "rbxassetid://10709751939",
	["lucide-activity"] = "rbxassetid://10709752035",
	["lucide-air-vent"] = "rbxassetid://10709752131",
	["lucide-airplay"] = "rbxassetid://10709752254",
	["lucide-alarm-check"] = "rbxassetid://10709752405",
	["lucide-alarm-clock"] = "rbxassetid://10709752630",
	["lucide-alarm-clock-off"] = "rbxassetid://10709752508",
	["lucide-alarm-minus"] = "rbxassetid://10709752732",
	["lucide-alarm-plus"] = "rbxassetid://10709752825",
	["lucide-album"] = "rbxassetid://10709752906",
	["lucide-alert-circle"] = "rbxassetid://10709752996",
	["lucide-alert-octagon"] = "rbxassetid://10709753064",
	["lucide-alert-triangle"] = "rbxassetid://10709753149",
	["lucide-align-center"] = "rbxassetid://10709753570",
	["lucide-align-center-horizontal"] = "rbxassetid://10709753272",
	["lucide-align-center-vertical"] = "rbxassetid://10709753421",
	["lucide-align-end-horizontal"] = "rbxassetid://10709753692",
	["lucide-align-end-vertical"] = "rbxassetid://10709753808",
	["lucide-align-horizontal-distribute-center"] = "rbxassetid://10747779791",
	["lucide-align-horizontal-distribute-end"] = "rbxassetid://10747784534",
	["lucide-align-horizontal-distribute-start"] = "rbxassetid://10709754118",
	["lucide-align-horizontal-justify-center"] = "rbxassetid://10709754204",
	["lucide-align-horizontal-justify-end"] = "rbxassetid://10709754317",
	["lucide-align-horizontal-justify-start"] = "rbxassetid://10709754436",
	["lucide-align-horizontal-space-around"] = "rbxassetid://10709754590",
	["lucide-align-horizontal-space-between"] = "rbxassetid://10709754749",
	["lucide-align-justify"] = "rbxassetid://10709759610",
	["lucide-align-left"] = "rbxassetid://10709759764",
	["lucide-align-right"] = "rbxassetid://10709759895",
	["lucide-align-start-horizontal"] = "rbxassetid://10709760051",
	["lucide-align-start-vertical"] = "rbxassetid://10709760244",
	["lucide-align-vertical-distribute-center"] = "rbxassetid://10709760351",
	["lucide-align-vertical-distribute-end"] = "rbxassetid://10709760434",
	["lucide-align-vertical-distribute-start"] = "rbxassetid://10709760612",
	["lucide-align-vertical-justify-center"] = "rbxassetid://10709760814",
	["lucide-align-vertical-justify-end"] = "rbxassetid://10709761003",
	["lucide-align-vertical-justify-start"] = "rbxassetid://10709761176",
	["lucide-align-vertical-space-around"] = "rbxassetid://10709761324",
	["lucide-align-vertical-space-between"] = "rbxassetid://10709761434",
	["lucide-anchor"] = "rbxassetid://10709761530",
	["lucide-angry"] = "rbxassetid://10709761629",
	["lucide-annoyed"] = "rbxassetid://10709761722",
	["lucide-aperture"] = "rbxassetid://10709761813",
	["lucide-apple"] = "rbxassetid://10709761889",
	["lucide-archive"] = "rbxassetid://10709762233",
	["lucide-archive-restore"] = "rbxassetid://10709762058",
	["lucide-armchair"] = "rbxassetid://10709762327",
	["lucide-arrow-big-down"] = "rbxassetid://10747796644",
	["lucide-arrow-big-left"] = "rbxassetid://10709762574",
	["lucide-arrow-big-right"] = "rbxassetid://10709762727",
	["lucide-arrow-big-up"] = "rbxassetid://10709762879",
	["lucide-arrow-down"] = "rbxassetid://10709767827",
	["lucide-arrow-down-circle"] = "rbxassetid://10709763034",
	["lucide-arrow-down-left"] = "rbxassetid://10709767656",
	["lucide-arrow-down-right"] = "rbxassetid://10709767750",
	["lucide-arrow-left"] = "rbxassetid://10709768114",
	["lucide-arrow-left-circle"] = "rbxassetid://10709767936",
	["lucide-arrow-left-right"] = "rbxassetid://10709768019",
	["lucide-arrow-right"] = "rbxassetid://10709768347",
	["lucide-arrow-right-circle"] = "rbxassetid://10709768226",
	["lucide-arrow-up"] = "rbxassetid://10709768939",
	["lucide-arrow-up-circle"] = "rbxassetid://10709768432",
	["lucide-arrow-up-down"] = "rbxassetid://10709768538",
	["lucide-arrow-up-left"] = "rbxassetid://10709768661",
	["lucide-arrow-up-right"] = "rbxassetid://10709768787",
	["lucide-asterisk"] = "rbxassetid://10709769095",
	["lucide-at-sign"] = "rbxassetid://10709769286",
	["lucide-award"] = "rbxassetid://10709769406",
	["lucide-axe"] = "rbxassetid://10709769508",
	["lucide-axis-3d"] = "rbxassetid://10709769598",
	["lucide-baby"] = "rbxassetid://10709769732",
	["lucide-backpack"] = "rbxassetid://10709769841",
	["lucide-baggage-claim"] = "rbxassetid://10709769935",
	["lucide-banana"] = "rbxassetid://10709770005",
	["lucide-banknote"] = "rbxassetid://10709770178",
	["lucide-bar-chart"] = "rbxassetid://10709773755",
	["lucide-bar-chart-2"] = "rbxassetid://10709770317",
	["lucide-bar-chart-3"] = "rbxassetid://10709770431",
	["lucide-bar-chart-4"] = "rbxassetid://10709770560",
	["lucide-bar-chart-horizontal"] = "rbxassetid://10709773669",
	["lucide-barcode"] = "rbxassetid://10747360675",
	["lucide-baseline"] = "rbxassetid://10709773863",
	["lucide-bath"] = "rbxassetid://10709773963",
	["lucide-battery"] = "rbxassetid://10709774640",
	["lucide-battery-charging"] = "rbxassetid://10709774068",
	["lucide-battery-full"] = "rbxassetid://10709774206",
	["lucide-battery-low"] = "rbxassetid://10709774370",
	["lucide-battery-medium"] = "rbxassetid://10709774513",
	["lucide-beaker"] = "rbxassetid://10709774756",
	["lucide-bed"] = "rbxassetid://10709775036",
	["lucide-bed-double"] = "rbxassetid://10709774864",
	["lucide-bed-single"] = "rbxassetid://10709774968",
	["lucide-beer"] = "rbxassetid://10709775167",
	["lucide-bell"] = "rbxassetid://10709775704",
	["lucide-bell-minus"] = "rbxassetid://10709775241",
	["lucide-bell-off"] = "rbxassetid://10709775320",
	["lucide-bell-plus"] = "rbxassetid://10709775448",
	["lucide-bell-ring"] = "rbxassetid://10709775560",
	["lucide-bike"] = "rbxassetid://10709775894",
	["lucide-binary"] = "rbxassetid://10709776050",
	["lucide-bitcoin"] = "rbxassetid://10709776126",
	["lucide-bluetooth"] = "rbxassetid://10709776655",
	["lucide-bluetooth-connected"] = "rbxassetid://10709776240",
	["lucide-bluetooth-off"] = "rbxassetid://10709776344",
	["lucide-bluetooth-searching"] = "rbxassetid://10709776501",
	["lucide-bold"] = "rbxassetid://10747813908",
	["lucide-bomb"] = "rbxassetid://10709781460",
	["lucide-bone"] = "rbxassetid://10709781605",
	["lucide-book"] = "rbxassetid://10709781824",
	["lucide-book-open"] = "rbxassetid://10709781717",
	["lucide-bookmark"] = "rbxassetid://10709782154",
	["lucide-bookmark-minus"] = "rbxassetid://10709781919",
	["lucide-bookmark-plus"] = "rbxassetid://10709782044",
	["lucide-bot"] = "rbxassetid://10709782230",
	["lucide-box"] = "rbxassetid://10709782497",
	["lucide-box-select"] = "rbxassetid://10709782342",
	["lucide-boxes"] = "rbxassetid://10709782582",
	["lucide-briefcase"] = "rbxassetid://10709782662",
	["lucide-brush"] = "rbxassetid://10709782758",
	["lucide-bug"] = "rbxassetid://10709782845",
	["lucide-building"] = "rbxassetid://10709783051",
	["lucide-building-2"] = "rbxassetid://10709782939",
	["lucide-bus"] = "rbxassetid://10709783137",
	["lucide-cake"] = "rbxassetid://10709783217",
	["lucide-calculator"] = "rbxassetid://10709783311",
	["lucide-calendar"] = "rbxassetid://10709789505",
	["lucide-calendar-check"] = "rbxassetid://10709783474",
	["lucide-calendar-check-2"] = "rbxassetid://10709783392",
	["lucide-calendar-clock"] = "rbxassetid://10709783577",
	["lucide-calendar-days"] = "rbxassetid://10709783673",
	["lucide-calendar-heart"] = "rbxassetid://10709783835",
	["lucide-calendar-minus"] = "rbxassetid://10709783959",
	["lucide-calendar-off"] = "rbxassetid://10709788784",
	["lucide-calendar-plus"] = "rbxassetid://10709788937",
	["lucide-calendar-range"] = "rbxassetid://10709789053",
	["lucide-calendar-search"] = "rbxassetid://10709789200",
	["lucide-calendar-x"] = "rbxassetid://10709789407",
	["lucide-calendar-x-2"] = "rbxassetid://10709789329",
	["lucide-camera"] = "rbxassetid://10709789686",
	["lucide-camera-off"] = "rbxassetid://10747822677",
	["lucide-car"] = "rbxassetid://10709789810",
	["lucide-carrot"] = "rbxassetid://10709789960",
	["lucide-cast"] = "rbxassetid://10709790097",
	["lucide-charge"] = "rbxassetid://10709790202",
	["lucide-check"] = "rbxassetid://10709790644",
	["lucide-check-circle"] = "rbxassetid://10709790387",
	["lucide-check-circle-2"] = "rbxassetid://10709790298",
	["lucide-check-square"] = "rbxassetid://10709790537",
	["lucide-chef-hat"] = "rbxassetid://10709790757",
	["lucide-cherry"] = "rbxassetid://10709790875",
	["lucide-chevron-down"] = "rbxassetid://10709790948",
	["lucide-chevron-first"] = "rbxassetid://10709791015",
	["lucide-chevron-last"] = "rbxassetid://10709791130",
	["lucide-chevron-left"] = "rbxassetid://10709791281",
	["lucide-chevron-right"] = "rbxassetid://10709791437",
	["lucide-chevron-up"] = "rbxassetid://10709791523",
	["lucide-chevrons-down"] = "rbxassetid://10709796864",
	["lucide-chevrons-down-up"] = "rbxassetid://10709791632",
	["lucide-chevrons-left"] = "rbxassetid://10709797151",
	["lucide-chevrons-left-right"] = "rbxassetid://10709797006",
	["lucide-chevrons-right"] = "rbxassetid://10709797382",
	["lucide-chevrons-right-left"] = "rbxassetid://10709797274",
	["lucide-chevrons-up"] = "rbxassetid://10709797622",
	["lucide-chevrons-up-down"] = "rbxassetid://10709797508",
	["lucide-chrome"] = "rbxassetid://10709797725",
	["lucide-circle"] = "rbxassetid://10709798174",
	["lucide-circle-dot"] = "rbxassetid://10709797837",
	["lucide-circle-ellipsis"] = "rbxassetid://10709797985",
	["lucide-circle-slashed"] = "rbxassetid://10709798100",
	["lucide-citrus"] = "rbxassetid://10709798276",
	["lucide-clapperboard"] = "rbxassetid://10709798350",
	["lucide-clipboard"] = "rbxassetid://10709799288",
	["lucide-clipboard-check"] = "rbxassetid://10709798443",
	["lucide-clipboard-copy"] = "rbxassetid://10709798574",
	["lucide-clipboard-edit"] = "rbxassetid://10709798682",
	["lucide-clipboard-list"] = "rbxassetid://10709798792",
	["lucide-clipboard-signature"] = "rbxassetid://10709798890",
	["lucide-clipboard-type"] = "rbxassetid://10709798999",
	["lucide-clipboard-x"] = "rbxassetid://10709799124",
	["lucide-clock"] = "rbxassetid://10709805144",
	["lucide-clock-1"] = "rbxassetid://10709799535",
	["lucide-clock-10"] = "rbxassetid://10709799718",
	["lucide-clock-11"] = "rbxassetid://10709799818",
	["lucide-clock-12"] = "rbxassetid://10709799962",
	["lucide-clock-2"] = "rbxassetid://10709803876",
	["lucide-clock-3"] = "rbxassetid://10709803989",
	["lucide-clock-4"] = "rbxassetid://10709804164",
	["lucide-clock-5"] = "rbxassetid://10709804291",
	["lucide-clock-6"] = "rbxassetid://10709804435",
	["lucide-clock-7"] = "rbxassetid://10709804599",
	["lucide-clock-8"] = "rbxassetid://10709804784",
	["lucide-clock-9"] = "rbxassetid://10709804996",
	["lucide-cloud"] = "rbxassetid://10709806740",
	["lucide-cloud-cog"] = "rbxassetid://10709805262",
	["lucide-cloud-drizzle"] = "rbxassetid://10709805371",
	["lucide-cloud-fog"] = "rbxassetid://10709805477",
	["lucide-cloud-hail"] = "rbxassetid://10709805596",
	["lucide-cloud-lightning"] = "rbxassetid://10709805727",
	["lucide-cloud-moon"] = "rbxassetid://10709805942",
	["lucide-cloud-moon-rain"] = "rbxassetid://10709805838",
	["lucide-cloud-off"] = "rbxassetid://10709806060",
	["lucide-cloud-rain"] = "rbxassetid://10709806277",
	["lucide-cloud-rain-wind"] = "rbxassetid://10709806166",
	["lucide-cloud-snow"] = "rbxassetid://10709806374",
	["lucide-cloud-sun"] = "rbxassetid://10709806631",
	["lucide-cloud-sun-rain"] = "rbxassetid://10709806475",
	["lucide-cloudy"] = "rbxassetid://10709806859",
	["lucide-clover"] = "rbxassetid://10709806995",
	["lucide-code"] = "rbxassetid://10709810463",
	["lucide-code-2"] = "rbxassetid://10709807111",
	["lucide-codepen"] = "rbxassetid://10709810534",
	["lucide-codesandbox"] = "rbxassetid://10709810676",
	["lucide-coffee"] = "rbxassetid://10709810814",
	["lucide-cog"] = "rbxassetid://10709810948",
	["lucide-coins"] = "rbxassetid://10709811110",
	["lucide-columns"] = "rbxassetid://10709811261",
	["lucide-command"] = "rbxassetid://10709811365",
	["lucide-compass"] = "rbxassetid://10709811445",
	["lucide-component"] = "rbxassetid://10709811595",
	["lucide-concierge-bell"] = "rbxassetid://10709811706",
	["lucide-connection"] = "rbxassetid://10747361219",
	["lucide-contact"] = "rbxassetid://10709811834",
	["lucide-contrast"] = "rbxassetid://10709811939",
	["lucide-cookie"] = "rbxassetid://10709812067",
	["lucide-copy"] = "rbxassetid://10709812159",
	["lucide-copyleft"] = "rbxassetid://10709812251",
	["lucide-copyright"] = "rbxassetid://10709812311",
	["lucide-corner-down-left"] = "rbxassetid://10709812396",
	["lucide-corner-down-right"] = "rbxassetid://10709812485",
	["lucide-corner-left-down"] = "rbxassetid://10709812632",
	["lucide-corner-left-up"] = "rbxassetid://10709812784",
	["lucide-corner-right-down"] = "rbxassetid://10709812939",
	["lucide-corner-right-up"] = "rbxassetid://10709813094",
	["lucide-corner-up-left"] = "rbxassetid://10709813185",
	["lucide-corner-up-right"] = "rbxassetid://10709813281",
	["lucide-cpu"] = "rbxassetid://10709813383",
	["lucide-croissant"] = "rbxassetid://10709818125",
	["lucide-crop"] = "rbxassetid://10709818245",
	["lucide-cross"] = "rbxassetid://10709818399",
	["lucide-crosshair"] = "rbxassetid://10709818534",
	["lucide-crown"] = "rbxassetid://10709818626",
	["lucide-cup-soda"] = "rbxassetid://10709818763",
	["lucide-curly-braces"] = "rbxassetid://10709818847",
	["lucide-currency"] = "rbxassetid://10709818931",
	["lucide-database"] = "rbxassetid://10709818996",
	["lucide-delete"] = "rbxassetid://10709819059",
	["lucide-diamond"] = "rbxassetid://10709819149",
	["lucide-dice-1"] = "rbxassetid://10709819266",
	["lucide-dice-2"] = "rbxassetid://10709819361",
	["lucide-dice-3"] = "rbxassetid://10709819508",
	["lucide-dice-4"] = "rbxassetid://10709819670",
	["lucide-dice-5"] = "rbxassetid://10709819801",
	["lucide-dice-6"] = "rbxassetid://10709819896",
	["lucide-dices"] = "rbxassetid://10723343321",
	["lucide-diff"] = "rbxassetid://10723343416",
	["lucide-disc"] = "rbxassetid://10723343537",
	["lucide-divide"] = "rbxassetid://10723343805",
	["lucide-divide-circle"] = "rbxassetid://10723343636",
	["lucide-divide-square"] = "rbxassetid://10723343737",
	["lucide-dollar-sign"] = "rbxassetid://10723343958",
	["lucide-download"] = "rbxassetid://10723344270",
	["lucide-download-cloud"] = "rbxassetid://10723344088",
	["lucide-droplet"] = "rbxassetid://10723344432",
	["lucide-droplets"] = "rbxassetid://10734883356",
	["lucide-drumstick"] = "rbxassetid://10723344737",
	["lucide-edit"] = "rbxassetid://10734883598",
	["lucide-edit-2"] = "rbxassetid://10723344885",
	["lucide-edit-3"] = "rbxassetid://10723345088",
	["lucide-egg"] = "rbxassetid://10723345518",
	["lucide-egg-fried"] = "rbxassetid://10723345347",
	["lucide-electricity"] = "rbxassetid://10723345749",
	["lucide-electricity-off"] = "rbxassetid://10723345643",
	["lucide-equal"] = "rbxassetid://10723345990",
	["lucide-equal-not"] = "rbxassetid://10723345866",
	["lucide-eraser"] = "rbxassetid://10723346158",
	["lucide-euro"] = "rbxassetid://10723346372",
	["lucide-expand"] = "rbxassetid://10723346553",
	["lucide-external-link"] = "rbxassetid://10723346684",
	["lucide-eye"] = "rbxassetid://10723346959",
	["lucide-eye-off"] = "rbxassetid://10723346871",
	["lucide-factory"] = "rbxassetid://10723347051",
	["lucide-fan"] = "rbxassetid://10723354359",
	["lucide-fast-forward"] = "rbxassetid://10723354521",
	["lucide-feather"] = "rbxassetid://10723354671",
	["lucide-figma"] = "rbxassetid://10723354801",
	["lucide-file"] = "rbxassetid://10723374641",
	["lucide-file-archive"] = "rbxassetid://10723354921",
	["lucide-file-audio"] = "rbxassetid://10723355148",
	["lucide-file-audio-2"] = "rbxassetid://10723355026",
	["lucide-file-axis-3d"] = "rbxassetid://10723355272",
	["lucide-file-badge"] = "rbxassetid://10723355622",
	["lucide-file-badge-2"] = "rbxassetid://10723355451",
	["lucide-file-bar-chart"] = "rbxassetid://10723355887",
	["lucide-file-bar-chart-2"] = "rbxassetid://10723355746",
	["lucide-file-box"] = "rbxassetid://10723355989",
	["lucide-file-check"] = "rbxassetid://10723356210",
	["lucide-file-check-2"] = "rbxassetid://10723356100",
	["lucide-file-clock"] = "rbxassetid://10723356329",
	["lucide-file-code"] = "rbxassetid://10723356507",
	["lucide-file-cog"] = "rbxassetid://10723356830",
	["lucide-file-cog-2"] = "rbxassetid://10723356676",
	["lucide-file-diff"] = "rbxassetid://10723357039",
	["lucide-file-digit"] = "rbxassetid://10723357151",
	["lucide-file-down"] = "rbxassetid://10723357322",
	["lucide-file-edit"] = "rbxassetid://10723357495",
	["lucide-file-heart"] = "rbxassetid://10723357637",
	["lucide-file-image"] = "rbxassetid://10723357790",
	["lucide-file-input"] = "rbxassetid://10723357933",
	["lucide-file-json"] = "rbxassetid://10723364435",
	["lucide-file-json-2"] = "rbxassetid://10723364361",
	["lucide-file-key"] = "rbxassetid://10723364605",
	["lucide-file-key-2"] = "rbxassetid://10723364515",
	["lucide-file-line-chart"] = "rbxassetid://10723364725",
	["lucide-file-lock"] = "rbxassetid://10723364957",
	["lucide-file-lock-2"] = "rbxassetid://10723364861",
	["lucide-file-minus"] = "rbxassetid://10723365254",
	["lucide-file-minus-2"] = "rbxassetid://10723365086",
	["lucide-file-output"] = "rbxassetid://10723365457",
	["lucide-file-pie-chart"] = "rbxassetid://10723365598",
	["lucide-file-plus"] = "rbxassetid://10723365877",
	["lucide-file-plus-2"] = "rbxassetid://10723365766",
	["lucide-file-question"] = "rbxassetid://10723365987",
	["lucide-file-scan"] = "rbxassetid://10723366167",
	["lucide-file-search"] = "rbxassetid://10723366550",
	["lucide-file-search-2"] = "rbxassetid://10723366340",
	["lucide-file-signature"] = "rbxassetid://10723366741",
	["lucide-file-spreadsheet"] = "rbxassetid://10723366962",
	["lucide-file-symlink"] = "rbxassetid://10723367098",
	["lucide-file-terminal"] = "rbxassetid://10723367244",
	["lucide-file-text"] = "rbxassetid://10723367380",
	["lucide-file-type"] = "rbxassetid://10723367606",
	["lucide-file-type-2"] = "rbxassetid://10723367509",
	["lucide-file-up"] = "rbxassetid://10723367734",
	["lucide-file-video"] = "rbxassetid://10723373884",
	["lucide-file-video-2"] = "rbxassetid://10723367834",
	["lucide-file-volume"] = "rbxassetid://10723374172",
	["lucide-file-volume-2"] = "rbxassetid://10723374030",
	["lucide-file-warning"] = "rbxassetid://10723374276",
	["lucide-file-x"] = "rbxassetid://10723374544",
	["lucide-file-x-2"] = "rbxassetid://10723374378",
	["lucide-files"] = "rbxassetid://10723374759",
	["lucide-film"] = "rbxassetid://10723374981",
	["lucide-filter"] = "rbxassetid://10723375128",
	["lucide-fingerprint"] = "rbxassetid://10723375250",
	["lucide-flag"] = "rbxassetid://10723375890",
	["lucide-flag-off"] = "rbxassetid://10723375443",
	["lucide-flag-triangle-left"] = "rbxassetid://10723375608",
	["lucide-flag-triangle-right"] = "rbxassetid://10723375727",
	["lucide-flame"] = "rbxassetid://10723376114",
	["lucide-flashlight"] = "rbxassetid://10723376471",
	["lucide-flashlight-off"] = "rbxassetid://10723376365",
	["lucide-flask-conical"] = "rbxassetid://10734883986",
	["lucide-flask-round"] = "rbxassetid://10723376614",
	["lucide-flip-horizontal"] = "rbxassetid://10723376884",
	["lucide-flip-horizontal-2"] = "rbxassetid://10723376745",
	["lucide-flip-vertical"] = "rbxassetid://10723377138",
	["lucide-flip-vertical-2"] = "rbxassetid://10723377026",
	["lucide-flower"] = "rbxassetid://10747830374",
	["lucide-flower-2"] = "rbxassetid://10723377305",
	["lucide-focus"] = "rbxassetid://10723377537",
	["lucide-folder"] = "rbxassetid://10723387563",
	["lucide-folder-archive"] = "rbxassetid://10723384478",
	["lucide-folder-check"] = "rbxassetid://10723384605",
	["lucide-folder-clock"] = "rbxassetid://10723384731",
	["lucide-folder-closed"] = "rbxassetid://10723384893",
	["lucide-folder-cog"] = "rbxassetid://10723385213",
	["lucide-folder-cog-2"] = "rbxassetid://10723385036",
	["lucide-folder-down"] = "rbxassetid://10723385338",
	["lucide-folder-edit"] = "rbxassetid://10723385445",
	["lucide-folder-heart"] = "rbxassetid://10723385545",
	["lucide-folder-input"] = "rbxassetid://10723385721",
	["lucide-folder-key"] = "rbxassetid://10723385848",
	["lucide-folder-lock"] = "rbxassetid://10723386005",
	["lucide-folder-minus"] = "rbxassetid://10723386127",
	["lucide-folder-open"] = "rbxassetid://10723386277",
	["lucide-folder-output"] = "rbxassetid://10723386386",
	["lucide-folder-plus"] = "rbxassetid://10723386531",
	["lucide-folder-search"] = "rbxassetid://10723386787",
	["lucide-folder-search-2"] = "rbxassetid://10723386674",
	["lucide-folder-symlink"] = "rbxassetid://10723386930",
	["lucide-folder-tree"] = "rbxassetid://10723387085",
	["lucide-folder-up"] = "rbxassetid://10723387265",
	["lucide-folder-x"] = "rbxassetid://10723387448",
	["lucide-folders"] = "rbxassetid://10723387721",
	["lucide-form-input"] = "rbxassetid://10723387841",
	["lucide-forward"] = "rbxassetid://10723388016",
	["lucide-frame"] = "rbxassetid://10723394389",
	["lucide-framer"] = "rbxassetid://10723394565",
	["lucide-frown"] = "rbxassetid://10723394681",
	["lucide-fuel"] = "rbxassetid://10723394846",
	["lucide-function-square"] = "rbxassetid://10723395041",
	["lucide-gamepad"] = "rbxassetid://10723395457",
	["lucide-gamepad-2"] = "rbxassetid://10723395215",
	["lucide-gauge"] = "rbxassetid://10723395708",
	["lucide-gavel"] = "rbxassetid://10723395896",
	["lucide-gem"] = "rbxassetid://10723396000",
	["lucide-ghost"] = "rbxassetid://10723396107",
	["lucide-gift"] = "rbxassetid://10723396402",
	["lucide-gift-card"] = "rbxassetid://10723396225",
	["lucide-git-branch"] = "rbxassetid://10723396676",
	["lucide-git-branch-plus"] = "rbxassetid://10723396542",
	["lucide-git-commit"] = "rbxassetid://10723396812",
	["lucide-git-compare"] = "rbxassetid://10723396954",
	["lucide-git-fork"] = "rbxassetid://10723397049",
	["lucide-git-merge"] = "rbxassetid://10723397165",
	["lucide-git-pull-request"] = "rbxassetid://10723397431",
	["lucide-git-pull-request-closed"] = "rbxassetid://10723397268",
	["lucide-git-pull-request-draft"] = "rbxassetid://10734884302",
	["lucide-glass"] = "rbxassetid://10723397788",
	["lucide-glass-2"] = "rbxassetid://10723397529",
	["lucide-glass-water"] = "rbxassetid://10723397678",
	["lucide-glasses"] = "rbxassetid://10723397895",
	["lucide-globe"] = "rbxassetid://10723404337",
	["lucide-globe-2"] = "rbxassetid://10723398002",
	["lucide-grab"] = "rbxassetid://10723404472",
	["lucide-graduation-cap"] = "rbxassetid://10723404691",
	["lucide-grape"] = "rbxassetid://10723404822",
	["lucide-grid"] = "rbxassetid://10723404936",
	["lucide-grip-horizontal"] = "rbxassetid://10723405089",
	["lucide-grip-vertical"] = "rbxassetid://10723405236",
	["lucide-hammer"] = "rbxassetid://10723405360",
	["lucide-hand"] = "rbxassetid://10723405649",
	["lucide-hand-metal"] = "rbxassetid://10723405508",
	["lucide-hard-drive"] = "rbxassetid://10723405749",
	["lucide-hard-hat"] = "rbxassetid://10723405859",
	["lucide-hash"] = "rbxassetid://10723405975",
	["lucide-haze"] = "rbxassetid://10723406078",
	["lucide-headphones"] = "rbxassetid://10723406165",
	["lucide-heart"] = "rbxassetid://10723406885",
	["lucide-heart-crack"] = "rbxassetid://10723406299",
	["lucide-heart-handshake"] = "rbxassetid://10723406480",
	["lucide-heart-off"] = "rbxassetid://10723406662",
	["lucide-heart-pulse"] = "rbxassetid://10723406795",
	["lucide-help-circle"] = "rbxassetid://10723406988",
	["lucide-hexagon"] = "rbxassetid://10723407092",
	["lucide-highlighter"] = "rbxassetid://10723407192",
	["lucide-history"] = "rbxassetid://10723407335",
	["lucide-home"] = "rbxassetid://10723407389",
	["lucide-hourglass"] = "rbxassetid://10723407498",
	["lucide-ice-cream"] = "rbxassetid://10723414308",
	["lucide-image"] = "rbxassetid://10723415040",
	["lucide-image-minus"] = "rbxassetid://10723414487",
	["lucide-image-off"] = "rbxassetid://10723414677",
	["lucide-image-plus"] = "rbxassetid://10723414827",
	["lucide-import"] = "rbxassetid://10723415205",
	["lucide-inbox"] = "rbxassetid://10723415335",
	["lucide-indent"] = "rbxassetid://10723415494",
	["lucide-indian-rupee"] = "rbxassetid://10723415642",
	["lucide-infinity"] = "rbxassetid://10723415766",
	["lucide-info"] = "rbxassetid://10723415903",
	["lucide-inspect"] = "rbxassetid://10723416057",
	["lucide-italic"] = "rbxassetid://10723416195",
	["lucide-japanese-yen"] = "rbxassetid://10723416363",
	["lucide-joystick"] = "rbxassetid://10723416527",
	["lucide-key"] = "rbxassetid://10723416652",
	["lucide-keyboard"] = "rbxassetid://10723416765",
	["lucide-lamp"] = "rbxassetid://10723417513",
	["lucide-lamp-ceiling"] = "rbxassetid://10723416922",
	["lucide-lamp-desk"] = "rbxassetid://10723417016",
	["lucide-lamp-floor"] = "rbxassetid://10723417131",
	["lucide-lamp-wall-down"] = "rbxassetid://10723417240",
	["lucide-lamp-wall-up"] = "rbxassetid://10723417356",
	["lucide-landmark"] = "rbxassetid://10723417608",
	["lucide-languages"] = "rbxassetid://10723417703",
	["lucide-laptop"] = "rbxassetid://10723423881",
	["lucide-laptop-2"] = "rbxassetid://10723417797",
	["lucide-lasso"] = "rbxassetid://10723424235",
	["lucide-lasso-select"] = "rbxassetid://10723424058",
	["lucide-laugh"] = "rbxassetid://10723424372",
	["lucide-layers"] = "rbxassetid://10723424505",
	["lucide-layout"] = "rbxassetid://10723425376",
	["lucide-layout-dashboard"] = "rbxassetid://10723424646",
	["lucide-layout-grid"] = "rbxassetid://10723424838",
	["lucide-layout-list"] = "rbxassetid://10723424963",
	["lucide-layout-template"] = "rbxassetid://10723425187",
	["lucide-leaf"] = "rbxassetid://10723425539",
	["lucide-library"] = "rbxassetid://10723425615",
	["lucide-life-buoy"] = "rbxassetid://10723425685",
	["lucide-lightbulb"] = "rbxassetid://10723425852",
	["lucide-lightbulb-off"] = "rbxassetid://10723425762",
	["lucide-line-chart"] = "rbxassetid://10723426393",
	["lucide-link"] = "rbxassetid://10723426722",
	["lucide-link-2"] = "rbxassetid://10723426595",
	["lucide-link-2-off"] = "rbxassetid://10723426513",
	["lucide-list"] = "rbxassetid://10723433811",
	["lucide-list-checks"] = "rbxassetid://10734884548",
	["lucide-list-end"] = "rbxassetid://10723426886",
	["lucide-list-minus"] = "rbxassetid://10723426986",
	["lucide-list-music"] = "rbxassetid://10723427081",
	["lucide-list-ordered"] = "rbxassetid://10723427199",
	["lucide-list-plus"] = "rbxassetid://10723427334",
	["lucide-list-start"] = "rbxassetid://10723427494",
	["lucide-list-video"] = "rbxassetid://10723427619",
	["lucide-list-x"] = "rbxassetid://10723433655",
	["lucide-loader"] = "rbxassetid://10723434070",
	["lucide-loader-2"] = "rbxassetid://10723433935",
	["lucide-locate"] = "rbxassetid://10723434557",
	["lucide-locate-fixed"] = "rbxassetid://10723434236",
	["lucide-locate-off"] = "rbxassetid://10723434379",
	["lucide-lock"] = "rbxassetid://10723434711",
	["lucide-log-in"] = "rbxassetid://10723434830",
	["lucide-log-out"] = "rbxassetid://10723434906",
	["lucide-luggage"] = "rbxassetid://10723434993",
	["lucide-magnet"] = "rbxassetid://10723435069",
	["lucide-mail"] = "rbxassetid://10734885430",
	["lucide-mail-check"] = "rbxassetid://10723435182",
	["lucide-mail-minus"] = "rbxassetid://10723435261",
	["lucide-mail-open"] = "rbxassetid://10723435342",
	["lucide-mail-plus"] = "rbxassetid://10723435443",
	["lucide-mail-question"] = "rbxassetid://10723435515",
	["lucide-mail-search"] = "rbxassetid://10734884739",
	["lucide-mail-warning"] = "rbxassetid://10734885015",
	["lucide-mail-x"] = "rbxassetid://10734885247",
	["lucide-mails"] = "rbxassetid://10734885614",
	["lucide-map"] = "rbxassetid://10734886202",
	["lucide-map-pin"] = "rbxassetid://10734886004",
	["lucide-map-pin-off"] = "rbxassetid://10734885803",
	["lucide-maximize"] = "rbxassetid://10734886735",
	["lucide-maximize-2"] = "rbxassetid://10734886496",
	["lucide-medal"] = "rbxassetid://10734887072",
	["lucide-megaphone"] = "rbxassetid://10734887454",
	["lucide-megaphone-off"] = "rbxassetid://10734887311",
	["lucide-meh"] = "rbxassetid://10734887603",
	["lucide-menu"] = "rbxassetid://10734887784",
	["lucide-message-circle"] = "rbxassetid://10734888000",
	["lucide-message-square"] = "rbxassetid://10734888228",
	["lucide-mic"] = "rbxassetid://10734888864",
	["lucide-mic-2"] = "rbxassetid://10734888430",
	["lucide-mic-off"] = "rbxassetid://10734888646",
	["lucide-microscope"] = "rbxassetid://10734889106",
	["lucide-microwave"] = "rbxassetid://10734895076",
	["lucide-milestone"] = "rbxassetid://10734895310",
	["lucide-minimize"] = "rbxassetid://10734895698",
	["lucide-minimize-2"] = "rbxassetid://10734895530",
	["lucide-minus"] = "rbxassetid://10734896206",
	["lucide-minus-circle"] = "rbxassetid://10734895856",
	["lucide-minus-square"] = "rbxassetid://10734896029",
	["lucide-monitor"] = "rbxassetid://10734896881",
	["lucide-monitor-off"] = "rbxassetid://10734896360",
	["lucide-monitor-speaker"] = "rbxassetid://10734896512",
	["lucide-moon"] = "rbxassetid://10734897102",
	["lucide-more-horizontal"] = "rbxassetid://10734897250",
	["lucide-more-vertical"] = "rbxassetid://10734897387",
	["lucide-mountain"] = "rbxassetid://10734897956",
	["lucide-mountain-snow"] = "rbxassetid://10734897665",
	["lucide-mouse"] = "rbxassetid://10734898592",
	["lucide-mouse-pointer"] = "rbxassetid://10734898476",
	["lucide-mouse-pointer-2"] = "rbxassetid://10734898194",
	["lucide-mouse-pointer-click"] = "rbxassetid://10734898355",
	["lucide-move"] = "rbxassetid://10734900011",
	["lucide-move-3d"] = "rbxassetid://10734898756",
	["lucide-move-diagonal"] = "rbxassetid://10734899164",
	["lucide-move-diagonal-2"] = "rbxassetid://10734898934",
	["lucide-move-horizontal"] = "rbxassetid://10734899414",
	["lucide-move-vertical"] = "rbxassetid://10734899821",
	["lucide-music"] = "rbxassetid://10734905958",
	["lucide-music-2"] = "rbxassetid://10734900215",
	["lucide-music-3"] = "rbxassetid://10734905665",
	["lucide-music-4"] = "rbxassetid://10734905823",
	["lucide-navigation"] = "rbxassetid://10734906744",
	["lucide-navigation-2"] = "rbxassetid://10734906332",
	["lucide-navigation-2-off"] = "rbxassetid://10734906144",
	["lucide-navigation-off"] = "rbxassetid://10734906580",
	["lucide-network"] = "rbxassetid://10734906975",
	["lucide-newspaper"] = "rbxassetid://10734907168",
	["lucide-octagon"] = "rbxassetid://10734907361",
	["lucide-option"] = "rbxassetid://10734907649",
	["lucide-outdent"] = "rbxassetid://10734907933",
	["lucide-package"] = "rbxassetid://10734909540",
	["lucide-package-2"] = "rbxassetid://10734908151",
	["lucide-package-check"] = "rbxassetid://10734908384",
	["lucide-package-minus"] = "rbxassetid://10734908626",
	["lucide-package-open"] = "rbxassetid://10734908793",
	["lucide-package-plus"] = "rbxassetid://10734909016",
	["lucide-package-search"] = "rbxassetid://10734909196",
	["lucide-package-x"] = "rbxassetid://10734909375",
	["lucide-paint-bucket"] = "rbxassetid://10734909847",
	["lucide-paintbrush"] = "rbxassetid://10734910187",
	["lucide-paintbrush-2"] = "rbxassetid://10734910030",
	["lucide-palette"] = "rbxassetid://10734910430",
	["lucide-palmtree"] = "rbxassetid://10734910680",
	["lucide-paperclip"] = "rbxassetid://10734910927",
	["lucide-party-popper"] = "rbxassetid://10734918735",
	["lucide-pause"] = "rbxassetid://10734919336",
	["lucide-pause-circle"] = "rbxassetid://10735024209",
	["lucide-pause-octagon"] = "rbxassetid://10734919143",
	["lucide-pen-tool"] = "rbxassetid://10734919503",
	["lucide-pencil"] = "rbxassetid://10734919691",
	["lucide-percent"] = "rbxassetid://10734919919",
	["lucide-person-standing"] = "rbxassetid://10734920149",
	["lucide-phone"] = "rbxassetid://10734921524",
	["lucide-phone-call"] = "rbxassetid://10734920305",
	["lucide-phone-forwarded"] = "rbxassetid://10734920508",
	["lucide-phone-incoming"] = "rbxassetid://10734920694",
	["lucide-phone-missed"] = "rbxassetid://10734920845",
	["lucide-phone-off"] = "rbxassetid://10734921077",
	["lucide-phone-outgoing"] = "rbxassetid://10734921288",
	["lucide-pie-chart"] = "rbxassetid://10734921727",
	["lucide-piggy-bank"] = "rbxassetid://10734921935",
	["lucide-pin"] = "rbxassetid://10734922324",
	["lucide-pin-off"] = "rbxassetid://10734922180",
	["lucide-pipette"] = "rbxassetid://10734922497",
	["lucide-pizza"] = "rbxassetid://10734922774",
	["lucide-plane"] = "rbxassetid://10734922971",
	["lucide-play"] = "rbxassetid://10734923549",
	["lucide-play-circle"] = "rbxassetid://10734923214",
	["lucide-plus"] = "rbxassetid://10734924532",
	["lucide-plus-circle"] = "rbxassetid://10734923868",
	["lucide-plus-square"] = "rbxassetid://10734924219",
	["lucide-podcast"] = "rbxassetid://10734929553",
	["lucide-pointer"] = "rbxassetid://10734929723",
	["lucide-pound-sterling"] = "rbxassetid://10734929981",
	["lucide-power"] = "rbxassetid://10734930466",
	["lucide-power-off"] = "rbxassetid://10734930257",
	["lucide-printer"] = "rbxassetid://10734930632",
	["lucide-puzzle"] = "rbxassetid://10734930886",
	["lucide-quote"] = "rbxassetid://10734931234",
	["lucide-radio"] = "rbxassetid://10734931596",
	["lucide-radio-receiver"] = "rbxassetid://10734931402",
	["lucide-rectangle-horizontal"] = "rbxassetid://10734931777",
	["lucide-rectangle-vertical"] = "rbxassetid://10734932081",
	["lucide-recycle"] = "rbxassetid://10734932295",
	["lucide-redo"] = "rbxassetid://10734932822",
	["lucide-redo-2"] = "rbxassetid://10734932586",
	["lucide-refresh-ccw"] = "rbxassetid://10734933056",
	["lucide-refresh-cw"] = "rbxassetid://10734933222",
	["lucide-refrigerator"] = "rbxassetid://10734933465",
	["lucide-regex"] = "rbxassetid://10734933655",
	["lucide-repeat"] = "rbxassetid://10734933966",
	["lucide-repeat-1"] = "rbxassetid://10734933826",
	["lucide-reply"] = "rbxassetid://10734934252",
	["lucide-reply-all"] = "rbxassetid://10734934132",
	["lucide-rewind"] = "rbxassetid://10734934347",
	["lucide-rocket"] = "rbxassetid://10734934585",
	["lucide-rocking-chair"] = "rbxassetid://10734939942",
	["lucide-rotate-3d"] = "rbxassetid://10734940107",
	["lucide-rotate-ccw"] = "rbxassetid://10734940376",
	["lucide-rotate-cw"] = "rbxassetid://10734940654",
	["lucide-rss"] = "rbxassetid://10734940825",
	["lucide-ruler"] = "rbxassetid://10734941018",
	["lucide-russian-ruble"] = "rbxassetid://10734941199",
	["lucide-sailboat"] = "rbxassetid://10734941354",
	["lucide-save"] = "rbxassetid://10734941499",
	["lucide-scale"] = "rbxassetid://10734941912",
	["lucide-scale-3d"] = "rbxassetid://10734941739",
	["lucide-scaling"] = "rbxassetid://10734942072",
	["lucide-scan"] = "rbxassetid://10734942565",
	["lucide-scan-face"] = "rbxassetid://10734942198",
	["lucide-scan-line"] = "rbxassetid://10734942351",
	["lucide-scissors"] = "rbxassetid://10734942778",
	["lucide-screen-share"] = "rbxassetid://10734943193",
	["lucide-screen-share-off"] = "rbxassetid://10734942967",
	["lucide-scroll"] = "rbxassetid://10734943448",
	["lucide-search"] = "rbxassetid://10734943674",
	["lucide-send"] = "rbxassetid://10734943902",
	["lucide-separator-horizontal"] = "rbxassetid://10734944115",
	["lucide-separator-vertical"] = "rbxassetid://10734944326",
	["lucide-server"] = "rbxassetid://10734949856",
	["lucide-server-cog"] = "rbxassetid://10734944444",
	["lucide-server-crash"] = "rbxassetid://10734944554",
	["lucide-server-off"] = "rbxassetid://10734944668",
	["lucide-settings"] = "rbxassetid://10734950309",
	["lucide-settings-2"] = "rbxassetid://10734950020",
	["lucide-share"] = "rbxassetid://10734950813",
	["lucide-share-2"] = "rbxassetid://10734950553",
	["lucide-sheet"] = "rbxassetid://10734951038",
	["lucide-shield"] = "rbxassetid://10734951847",
	["lucide-shield-alert"] = "rbxassetid://10734951173",
	["lucide-shield-check"] = "rbxassetid://10734951367",
	["lucide-shield-close"] = "rbxassetid://10734951535",
	["lucide-shield-off"] = "rbxassetid://10734951684",
	["lucide-shirt"] = "rbxassetid://10734952036",
	["lucide-shopping-bag"] = "rbxassetid://10734952273",
	["lucide-shopping-cart"] = "rbxassetid://10734952479",
	["lucide-shovel"] = "rbxassetid://10734952773",
	["lucide-shower-head"] = "rbxassetid://10734952942",
	["lucide-shrink"] = "rbxassetid://10734953073",
	["lucide-shrub"] = "rbxassetid://10734953241",
	["lucide-shuffle"] = "rbxassetid://10734953451",
	["lucide-sidebar"] = "rbxassetid://10734954301",
	["lucide-sidebar-close"] = "rbxassetid://10734953715",
	["lucide-sidebar-open"] = "rbxassetid://10734954000",
	["lucide-sigma"] = "rbxassetid://10734954538",
	["lucide-signal"] = "rbxassetid://10734961133",
	["lucide-signal-high"] = "rbxassetid://10734954807",
	["lucide-signal-low"] = "rbxassetid://10734955080",
	["lucide-signal-medium"] = "rbxassetid://10734955336",
	["lucide-signal-zero"] = "rbxassetid://10734960878",
	["lucide-siren"] = "rbxassetid://10734961284",
	["lucide-skip-back"] = "rbxassetid://10734961526",
	["lucide-skip-forward"] = "rbxassetid://10734961809",
	["lucide-skull"] = "rbxassetid://10734962068",
	["lucide-slack"] = "rbxassetid://10734962339",
	["lucide-slash"] = "rbxassetid://10734962600",
	["lucide-slice"] = "rbxassetid://10734963024",
	["lucide-sliders"] = "rbxassetid://10734963400",
	["lucide-sliders-horizontal"] = "rbxassetid://10734963191",
	["lucide-smartphone"] = "rbxassetid://10734963940",
	["lucide-smartphone-charging"] = "rbxassetid://10734963671",
	["lucide-smile"] = "rbxassetid://10734964441",
	["lucide-smile-plus"] = "rbxassetid://10734964188",
	["lucide-snowflake"] = "rbxassetid://10734964600",
	["lucide-sofa"] = "rbxassetid://10734964852",
	["lucide-sort-asc"] = "rbxassetid://10734965115",
	["lucide-sort-desc"] = "rbxassetid://10734965287",
	["lucide-speaker"] = "rbxassetid://10734965419",
	["lucide-sprout"] = "rbxassetid://10734965572",
	["lucide-square"] = "rbxassetid://10734965702",
	["lucide-star"] = "rbxassetid://10734966248",
	["lucide-star-half"] = "rbxassetid://10734965897",
	["lucide-star-off"] = "rbxassetid://10734966097",
	["lucide-stethoscope"] = "rbxassetid://10734966384",
	["lucide-sticker"] = "rbxassetid://10734972234",
	["lucide-sticky-note"] = "rbxassetid://10734972463",
	["lucide-stop-circle"] = "rbxassetid://10734972621",
	["lucide-stretch-horizontal"] = "rbxassetid://10734972862",
	["lucide-stretch-vertical"] = "rbxassetid://10734973130",
	["lucide-strikethrough"] = "rbxassetid://10734973290",
	["lucide-subscript"] = "rbxassetid://10734973457",
	["lucide-sun"] = "rbxassetid://10734974297",
	["lucide-sun-dim"] = "rbxassetid://10734973645",
	["lucide-sun-medium"] = "rbxassetid://10734973778",
	["lucide-sun-moon"] = "rbxassetid://10734973999",
	["lucide-sun-snow"] = "rbxassetid://10734974130",
	["lucide-sunrise"] = "rbxassetid://10734974522",
	["lucide-sunset"] = "rbxassetid://10734974689",
	["lucide-superscript"] = "rbxassetid://10734974850",
	["lucide-swiss-franc"] = "rbxassetid://10734975024",
	["lucide-switch-camera"] = "rbxassetid://10734975214",
	["lucide-sword"] = "rbxassetid://10734975486",
	["lucide-swords"] = "rbxassetid://10734975692",
	["lucide-syringe"] = "rbxassetid://10734975932",
	["lucide-table"] = "rbxassetid://10734976230",
	["lucide-table-2"] = "rbxassetid://10734976097",
	["lucide-tablet"] = "rbxassetid://10734976394",
	["lucide-tag"] = "rbxassetid://10734976528",
	["lucide-tags"] = "rbxassetid://10734976739",
	["lucide-target"] = "rbxassetid://10734977012",
	["lucide-tent"] = "rbxassetid://10734981750",
	["lucide-terminal"] = "rbxassetid://10734982144",
	["lucide-terminal-square"] = "rbxassetid://10734981995",
	["lucide-text-cursor"] = "rbxassetid://10734982395",
	["lucide-text-cursor-input"] = "rbxassetid://10734982297",
	["lucide-thermometer"] = "rbxassetid://10734983134",
	["lucide-thermometer-snowflake"] = "rbxassetid://10734982571",
	["lucide-thermometer-sun"] = "rbxassetid://10734982771",
	["lucide-thumbs-down"] = "rbxassetid://10734983359",
	["lucide-thumbs-up"] = "rbxassetid://10734983629",
	["lucide-ticket"] = "rbxassetid://10734983868",
	["lucide-timer"] = "rbxassetid://10734984606",
	["lucide-timer-off"] = "rbxassetid://10734984138",
	["lucide-timer-reset"] = "rbxassetid://10734984355",
	["lucide-toggle-left"] = "rbxassetid://10734984834",
	["lucide-toggle-right"] = "rbxassetid://10734985040",
	["lucide-tornado"] = "rbxassetid://10734985247",
	["lucide-toy-brick"] = "rbxassetid://10747361919",
	["lucide-train"] = "rbxassetid://10747362105",
	["lucide-trash"] = "rbxassetid://10747362393",
	["lucide-trash-2"] = "rbxassetid://10747362241",
	["lucide-tree-deciduous"] = "rbxassetid://10747362534",
	["lucide-tree-pine"] = "rbxassetid://10747362748",
	["lucide-trees"] = "rbxassetid://10747363016",
	["lucide-trending-down"] = "rbxassetid://10747363205",
	["lucide-trending-up"] = "rbxassetid://10747363465",
	["lucide-triangle"] = "rbxassetid://10747363621",
	["lucide-trophy"] = "rbxassetid://10747363809",
	["lucide-truck"] = "rbxassetid://10747364031",
	["lucide-tv"] = "rbxassetid://10747364593",
	["lucide-tv-2"] = "rbxassetid://10747364302",
	["lucide-type"] = "rbxassetid://10747364761",
	["lucide-umbrella"] = "rbxassetid://10747364971",
	["lucide-underline"] = "rbxassetid://10747365191",
	["lucide-undo"] = "rbxassetid://10747365484",
	["lucide-undo-2"] = "rbxassetid://10747365359",
	["lucide-unlink"] = "rbxassetid://10747365771",
	["lucide-unlink-2"] = "rbxassetid://10747397871",
	["lucide-unlock"] = "rbxassetid://10747366027",
	["lucide-upload"] = "rbxassetid://10747366434",
	["lucide-upload-cloud"] = "rbxassetid://10747366266",
	["lucide-usb"] = "rbxassetid://10747366606",
	["lucide-user"] = "rbxassetid://10747373176",
	["lucide-user-check"] = "rbxassetid://10747371901",
	["lucide-user-cog"] = "rbxassetid://10747372167",
	["lucide-user-minus"] = "rbxassetid://10747372346",
	["lucide-user-plus"] = "rbxassetid://10747372702",
	["lucide-user-x"] = "rbxassetid://10747372992",
	["lucide-users"] = "rbxassetid://10747373426",
	["lucide-utensils"] = "rbxassetid://10747373821",
	["lucide-utensils-crossed"] = "rbxassetid://10747373629",
	["lucide-venetian-mask"] = "rbxassetid://10747374003",
	["lucide-verified"] = "rbxassetid://10747374131",
	["lucide-vibrate"] = "rbxassetid://10747374489",
	["lucide-vibrate-off"] = "rbxassetid://10747374269",
	["lucide-video"] = "rbxassetid://10747374938",
	["lucide-video-off"] = "rbxassetid://10747374721",
	["lucide-view"] = "rbxassetid://10747375132",
	["lucide-voicemail"] = "rbxassetid://10747375281",
	["lucide-volume"] = "rbxassetid://10747376008",
	["lucide-volume-1"] = "rbxassetid://10747375450",
	["lucide-volume-2"] = "rbxassetid://10747375679",
	["lucide-volume-x"] = "rbxassetid://10747375880",
	["lucide-wallet"] = "rbxassetid://10747376205",
	["lucide-wand"] = "rbxassetid://10747376565",
	["lucide-wand-2"] = "rbxassetid://10747376349",
	["lucide-watch"] = "rbxassetid://10747376722",
	["lucide-waves"] = "rbxassetid://10747376931",
	["lucide-webcam"] = "rbxassetid://10747381992",
	["lucide-wifi"] = "rbxassetid://10747382504",
	["lucide-wifi-off"] = "rbxassetid://10747382268",
	["lucide-wind"] = "rbxassetid://10747382750",
	["lucide-wrap-text"] = "rbxassetid://10747383065",
	["lucide-wrench"] = "rbxassetid://10747383470",
	["lucide-x"] = "rbxassetid://10747384394",
	["lucide-x-circle"] = "rbxassetid://10747383819",
	["lucide-x-octagon"] = "rbxassetid://10747384037",
	["lucide-x-square"] = "rbxassetid://10747384217",
	["lucide-zoom-in"] = "rbxassetid://10747384552",
	["lucide-zoom-out"] = "rbxassetid://10747384679",
}

local function icon(name)
	return _iconReg["lucide-" .. tostring(name)] or "rbxassetid://0"
end

local lib = {}

local _gameName = tostring(game.Name):gsub("[^%w%s%-_]",""):gsub("%s+","_"):sub(1,40)
if _gameName == "" then _gameName = "unknown" end

local function cfgPath(winTitle)
	local wn = tostring(winTitle):gsub("[^%w%s%-_]",""):gsub("%s+","_"):sub(1,28)
	if wn == "" then wn = "window" end
	return "ecohub/" .. _gameName .. "/" .. wn .. "_config.json"
end

local function mkFolders(path)
	pcall(function()
		local parts = string.split(path, "/")
		local acc = ""
		for i = 1, #parts - 1 do
			acc = i == 1 and parts[i] or (acc .. "/" .. parts[i])
			if not isfolder(acc) then makefolder(acc) end
		end
	end)
end

local function readCfg(path)
	local ok, d = pcall(function()
		mkFolders(path)
		return isfile(path) and HTTP:JSONDecode(readfile(path)) or {}
	end)
	return (ok and type(d) == "table") and d or {}
end

local function saveCfg(path, d)
	local ok2, err = pcall(function() mkFolders(path) writefile(path, HTTP:JSONEncode(d)) end)
	if not ok2 then print("[EcoHub] Error: saveCfg failed: " .. tostring(err)) end
end

local LOGO_ID  = "rbxassetid://134382458890933"
local NOISE_ID = "rbxassetid://9968344919"

local PANEL_W   = 580
local PANEL_H   = 460
local TITLE_H   = 36
local SIDE_W    = 165
local SIDE_MINI = 42
local LOGO_H    = 100
local EL_H      = 36

local T = {
	Accent     = Color3.fromRGB(220, 220, 220),
	AccentDim  = Color3.fromRGB(160, 160, 160),
	AccentSub  = Color3.fromRGB(100, 100, 100),
	bg         = Color3.fromRGB(13,  13,  13),
	surface    = Color3.fromRGB(17,  17,  17),
	sidebar    = Color3.fromRGB(15,  15,  15),
	divider    = Color3.fromRGB(32,  32,  32),
	white      = Color3.fromRGB(220, 220, 220),
	dim        = Color3.fromRGB(65,  65,  65),
	dimLight   = Color3.fromRGB(105, 105, 105),
	tabIdle    = Color3.fromRGB(85,  85,  85),
	tabHov     = Color3.fromRGB(155, 155, 155),
	tabAct     = Color3.fromRGB(220, 220, 220),
	tabBgHov   = Color3.fromRGB(24,  24,  24),
	tabBgAct   = Color3.fromRGB(28,  28,  28),
	searchBg   = Color3.fromRGB(19,  19,  19),
	avatarBg   = Color3.fromRGB(20,  20,  20),
	underline  = Color3.fromRGB(220, 220, 220),
	secText    = Color3.fromRGB(55,  55,  55),
	elBg       = Color3.fromRGB(19,  19,  19),
	elBgHov    = Color3.fromRGB(26,  26,  26),
	elBorder   = Color3.fromRGB(44,  44,  44),
	dropBg     = Color3.fromRGB(16,  16,  16),
	dropItem   = Color3.fromRGB(22,  22,  22),
	dropSel    = Color3.fromRGB(30,  30,  30),
	inputBg    = Color3.fromRGB(13,  13,  13),
	pageBg     = Color3.fromRGB(13,  13,  13),
	togOff     = Color3.fromRGB(32,  32,  32),
	sliderRail = Color3.fromRGB(24,  24,  24),
}

local function N(cls, props)
	local ok, o = pcall(Instance.new, cls)
	if not ok then return nil end
	for k, v in pairs(props) do
		if k ~= "Parent" then pcall(function() o[k] = v end) end
	end
	if props.Parent then pcall(function() o.Parent = props.Parent end) end
	return o
end

local function Tw(obj, goal, t, style, dir)
	if not obj then return end
	pcall(function()
		TS:Create(obj,
			TweenInfo.new(t or 0.18, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
			goal
		):Play()
	end)
end

local function Corner(par, r)
	N("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = par })
end

local function Stroke(par, col, thick, trans)
	N("UIStroke", { Color = col or T.elBorder, Thickness = thick or 1, Transparency = trans or 0, Parent = par })
end

local function Grad(par, c0, c1, rot)
	N("UIGradient", {
		Color    = ColorSequence.new({ ColorSequenceKeypoint.new(0,c0), ColorSequenceKeypoint.new(1,c1) }),
		Rotation = rot or 90,
		Parent   = par,
	})
end

local function Noise(par, alpha, zi)
	N("ImageLabel", {
		Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
		Image = NOISE_ID, ImageTransparency = alpha or 0.94,
		ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.new(0,64,0,64),
		ZIndex = zi or 99, Parent = par,
	})
end

local function Img(id, par, sz, pos, col, zi)
	return N("ImageLabel", {
		Size = UDim2.new(0,sz,0,sz), Position = pos,
		BackgroundTransparency = 1, Image = id,
		ImageColor3 = col or T.dim, ZIndex = zi or 5, Parent = par,
	})
end

local function ElBase(par, h, orderRef)
	local f = N("Frame", {
		Size             = UDim2.new(1, 0, 0, h or EL_H),
		BackgroundColor3 = T.elBg,
		BorderSizePixel  = 0,
		ClipsDescendants = false,
		LayoutOrder      = orderRef(),
		ZIndex           = 3,
		Parent           = par,
	})
	Corner(f, 6)
	Stroke(f, T.elBorder, 1, 0.28)
	Grad(f, Color3.fromRGB(28,28,28), Color3.fromRGB(17,17,17), 90)
	Noise(f, 0.95, 4)
	return f
end

local function HoverEl(btn, frame)
	if not btn or not frame then return end
	btn.MouseEnter:Connect(function() Tw(frame, {BackgroundColor3 = T.elBgHov}, 0.1) end)
	btn.MouseLeave:Connect(function() Tw(frame, {BackgroundColor3 = T.elBg},    0.1) end)
end

local function MkSection(par, text, orderRef)
	local wrap = N("Frame", {
		Size             = UDim2.new(1, 0, 0, 28),
		BackgroundColor3 = Color3.fromRGB(17, 17, 17),
		BorderSizePixel  = 0,
		LayoutOrder      = orderRef(),
		ZIndex           = 2,
		ClipsDescendants = true,
		Parent           = par,
	})
	Corner(wrap, 6)
	Stroke(wrap, Color3.fromRGB(50, 50, 50), 1, 0.4)

	local shimmer = N("Frame", {
		Size             = UDim2.new(0, 60, 1, 0),
		Position         = UDim2.new(-0.2, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.85,
		BorderSizePixel  = 0,
		ZIndex           = 4,
		Parent           = wrap,
	})
	N("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0,   Color3.fromRGB(13,13,13)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
			ColorSequenceKeypoint.new(1,   Color3.fromRGB(13,13,13)),
		}),
		Rotation = 0,
		Parent   = shimmer,
	})

	local lbl = N("TextLabel", {
		Size              = UDim2.new(1, 0, 1, 0),
		Position          = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Text              = string.upper(text),
		TextColor3        = Color3.fromRGB(255, 255, 255),
		TextTransparency  = 0,
		TextSize          = 10,
		Font              = Enum.Font.GothamBold,
		TextXAlignment    = Enum.TextXAlignment.Center,
		ZIndex            = 5,
		Parent            = wrap,
	})

	N("UIStroke", {
		Color        = Color3.fromRGB(200, 200, 200),
		Thickness    = 0.5,
		Transparency = 0.6,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
		Parent       = lbl,
	})

	task.spawn(function()
		while wrap and wrap.Parent do
			Tw(shimmer, { Position = UDim2.new(-0.2, 0, 0, 0) }, 0)
			task.wait(0.05)
			Tw(shimmer, { Position = UDim2.new(1.2, 0, 0, 0) }, 1.6, Enum.EasingStyle.Linear)
			task.wait(3.2)
		end
	end)

	return wrap
end

local function MkToggle(par, text, default, cb, cfg, cpath, saveId, orderRef, allElements)
	local state = default == true
	if saveId and cfg[saveId] ~= nil then state = cfg[saveId] == true end

	local f = ElBase(par, EL_H, orderRef)
	table.insert(allElements, { frame = f, label = string.lower(text or "") })

	N("TextLabel", {
		Size = UDim2.new(1,-70,1,0), Position = UDim2.new(0,11,0,0),
		BackgroundTransparency = 1, Text = text, TextColor3 = T.white,
		TextSize = 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 4, Parent = f,
	})

	local TW, TH = 34, 18
	local track = N("Frame", {
		Size = UDim2.new(0,TW,0,TH), Position = UDim2.new(1,-(TW+10),0.5,-TH/2),
		BackgroundColor3 = state and T.Accent or T.togOff,
		BorderSizePixel = 0, ZIndex = 5, Parent = f,
	})
	Corner(track, TH)
	local tGrad = N("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, state and T.AccentDim or Color3.fromRGB(48,48,48)),
			ColorSequenceKeypoint.new(1, state and T.AccentSub or Color3.fromRGB(22,22,22)),
		}),
		Rotation = 90, Parent = track,
	})
	local tStr = N("UIStroke", {
		Color = state and T.Accent or Color3.fromRGB(52,52,52),
		Thickness = 1, Transparency = 0.3, Parent = track,
	})
	local KSZ = 12
	local knob = N("Frame", {
		Size = UDim2.new(0,KSZ,0,KSZ),
		Position = state and UDim2.new(1,-(KSZ+3),0.5,-KSZ/2) or UDim2.new(0,3,0.5,-KSZ/2),
		BackgroundColor3 = state and T.bg or T.white,
		BorderSizePixel = 0, ZIndex = 6, Parent = track,
	})
	Corner(knob, KSZ)

	local function refresh(s)
		Tw(track, {BackgroundColor3 = s and T.Accent or T.togOff}, 0.15)
		Tw(knob, {
			Position         = s and UDim2.new(1,-(KSZ+3),0.5,-KSZ/2) or UDim2.new(0,3,0.5,-KSZ/2),
			BackgroundColor3 = s and T.bg or T.white,
		}, 0.15, Enum.EasingStyle.Back)
		Tw(tStr, {Color = s and T.Accent or Color3.fromRGB(52,52,52)}, 0.13)
		if tGrad then
			tGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, s and T.AccentDim or Color3.fromRGB(48,48,48)),
				ColorSequenceKeypoint.new(1, s and T.AccentSub or Color3.fromRGB(22,22,22)),
			})
		end
	end

	local btn = N("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", ZIndex=7, Parent=f})
	btn.MouseButton1Click:Connect(function()
		state = not state
		refresh(state)
		if saveId then cfg[saveId] = state saveCfg(cpath, cfg) end
		pcall(function() if cb then cb(state) end end)
	end)
	HoverEl(btn, f)

	return {
		Set = function(v) state = v == true refresh(state) end,
		Get = function() return state end,
	}
end

local function MkCheckbox(par, text, default, cb, cfg, cpath, saveId, orderRef, allElements)
	local state = default == true
	if saveId and cfg[saveId] ~= nil then state = cfg[saveId] == true end

	local f = ElBase(par, EL_H, orderRef)
	table.insert(allElements, { frame = f, label = string.lower(text or "") })

	local BSZ = 16
	local box = N("Frame", {
		Size = UDim2.new(0,BSZ,0,BSZ), Position = UDim2.new(0,11,0.5,-BSZ/2),
		BackgroundColor3 = state and T.Accent or Color3.fromRGB(22,22,22),
		BorderSizePixel = 0, ZIndex = 5, Parent = f,
	})
	Corner(box, 4)
	local bStr = N("UIStroke", {
		Color = state and T.Accent or Color3.fromRGB(54,54,54), Thickness = 1.5, Parent = box,
	})
	local chk = N("ImageLabel", {
		Size = UDim2.new(0,10,0,10), Position = UDim2.new(0.5,-5,0.5,-5),
		BackgroundTransparency = 1, Image = icon("check"),
		ImageColor3 = T.bg, ImageTransparency = state and 0 or 1,
		ZIndex = 6, Parent = box,
	})
	N("TextLabel", {
		Size = UDim2.new(1,-(BSZ+22),1,0), Position = UDim2.new(0,BSZ+18,0,0),
		BackgroundTransparency = 1, Text = text, TextColor3 = T.white,
		TextSize = 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 4, Parent = f,
	})

	local function refresh(s)
		Tw(box,  {BackgroundColor3 = s and T.Accent or Color3.fromRGB(22,22,22)}, 0.14)
		Tw(bStr, {Color = s and T.Accent or Color3.fromRGB(54,54,54)}, 0.13)
		Tw(chk,  {ImageTransparency = s and 0 or 1}, 0.11)
	end

	local btn = N("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", ZIndex=7, Parent=f})
	btn.MouseButton1Click:Connect(function()
		state = not state
		refresh(state)
		if saveId then cfg[saveId] = state saveCfg(cpath, cfg) end
		pcall(function() if cb then cb(state) end end)
	end)
	HoverEl(btn, f)

	return {
		Set = function(v) state = v == true refresh(state) end,
		Get = function() return state end,
	}
end

local function MkButton(par, text, cb, orderRef, allElements)
	local f = ElBase(par, EL_H, orderRef)
	table.insert(allElements, { frame = f, label = string.lower(text or "") })

	N("TextLabel", {
		Size = UDim2.new(1,-36,1,0), Position = UDim2.new(0,11,0,0),
		BackgroundTransparency = 1, Text = text, TextColor3 = T.white,
		TextSize = 11, Font = Enum.Font.GothamSemibold,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 5, Parent = f,
	})
	local arrow = Img(icon("chevron-right"), f, 12, UDim2.new(1,-19,0.5,-6), T.dim, 5)

	local btn = N("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", ZIndex=7, Parent=f})
	btn.MouseEnter:Connect(function() Tw(f,{BackgroundColor3=T.elBgHov},0.1) Tw(arrow,{ImageColor3=T.Accent},0.1) end)
	btn.MouseLeave:Connect(function() Tw(f,{BackgroundColor3=T.elBg},0.1) Tw(arrow,{ImageColor3=T.dim},0.1) end)
	btn.MouseButton1Down:Connect(function() Tw(f,{BackgroundColor3=Color3.fromRGB(9,9,9)},0.06) end)
	btn.MouseButton1Up:Connect(function() Tw(f,{BackgroundColor3=T.elBgHov},0.06) end)
	btn.MouseButton1Click:Connect(function() pcall(function() if cb then cb() end end) end)

	return { Frame = f }
end

local function MkSlider(par, text, minV, maxV, defV, cb, cfg, cpath, saveId, orderRef, allElements, connections)
	minV = minV or 0
	maxV = maxV or 100
	local val  = math.clamp(defV or minV, minV, maxV)
	if saveId and cfg[saveId] ~= nil then
		val = math.clamp(tonumber(cfg[saveId]) or val, minV, maxV)
	end
	local pct  = (val - minV) / math.max(maxV - minV, 0.001)
	local drag = false

	local f = ElBase(par, 48, orderRef)
	table.insert(allElements, { frame = f, label = string.lower(text or "") })

	N("TextLabel", {
		Size = UDim2.new(1,-60,0,14), Position = UDim2.new(0,11,0,7),
		BackgroundTransparency = 1, Text = text, TextColor3 = T.white,
		TextSize = 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = f,
	})

	local badge = N("Frame", {
		Size = UDim2.new(0,42,0,16), Position = UDim2.new(1,-52,0,6),
		BackgroundColor3 = Color3.fromRGB(9,9,9), BorderSizePixel = 0, ZIndex = 4, Parent = f,
	})
	Corner(badge, 4)
	Stroke(badge, T.elBorder, 1, 0.15)
	local valLbl = N("TextLabel", {
		Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
		Text = tostring(math.round(val)), TextColor3 = T.Accent,
		TextSize = 10, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 5, Parent = badge,
	})

	local RAIL_H = 3
	local rail = N("Frame", {
		Size = UDim2.new(1,-22,0,RAIL_H), Position = UDim2.new(0,11,0,33),
		BackgroundColor3 = T.sliderRail, BorderSizePixel = 0, ZIndex = 4, Parent = f,
	})
	Corner(rail, RAIL_H)
	Stroke(rail, T.elBorder, 1, 0.25)

	local fill = N("Frame", {
		Size = UDim2.new(pct,0,1,0), BackgroundColor3 = T.Accent,
		BorderSizePixel = 0, ZIndex = 5, Parent = rail,
	})
	Corner(fill, RAIL_H)

	local inner = N("Frame", {
		BackgroundTransparency = 1, Position = UDim2.new(0,6,0,0),
		Size = UDim2.new(1,-12,1,0), ZIndex = 5, Parent = rail,
	})

	local KSZ = 11
	local knob = N("Frame", {
		Size = UDim2.new(0,KSZ,0,KSZ), AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.new(pct,0,0.5,0), BackgroundColor3 = T.white,
		BorderSizePixel = 0, ZIndex = 6, Parent = inner,
	})
	Corner(knob, KSZ)
	N("UIStroke", {Color = T.Accent, Thickness = 1.5, Parent = knob})

	local function setVal(v)
		val = math.clamp(math.round(v), minV, maxV)
		local p = (val - minV) / math.max(maxV - minV, 0.001)
		if fill   then fill.Size     = UDim2.new(p,0,1,0)   end
		if knob   then knob.Position = UDim2.new(p,0,0.5,0) end
		if valLbl then valLbl.Text   = tostring(val)         end
		if saveId then cfg[saveId] = val saveCfg(cpath, cfg) end
		pcall(function() if cb then cb(val) end end)
	end

	local hit = N("TextButton", {
		Size = UDim2.new(1,0,0,22), Position = UDim2.new(0,0,0,-9),
		BackgroundTransparency = 1, Text = "", ZIndex = 8, Parent = rail,
	})
	hit.MouseButton1Down:Connect(function()
		drag = true
		local mp = UIS:GetMouseLocation()
		local ab, sz = inner.AbsolutePosition, inner.AbsoluteSize
		setVal(minV + (maxV-minV) * math.clamp((mp.X-ab.X)/sz.X, 0, 1))
	end)
	hit.MouseEnter:Connect(function()
		Tw(f, {BackgroundColor3=T.elBgHov}, 0.1)
		Tw(knob, {Size=UDim2.new(0,KSZ+2,0,KSZ+2)}, 0.1, Enum.EasingStyle.Back)
	end)
	hit.MouseLeave:Connect(function()
		Tw(f, {BackgroundColor3=T.elBg}, 0.1)
		if not drag then Tw(knob, {Size=UDim2.new(0,KSZ,0,KSZ)}, 0.1, Enum.EasingStyle.Back) end
	end)

	local ieConn
	ieConn = UIS.InputEnded:Connect(function(inp)
		if not f or not f.Parent then ieConn:Disconnect() return end
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			if drag then Tw(knob, {Size=UDim2.new(0,KSZ,0,KSZ)}, 0.1, Enum.EasingStyle.Back) end
			drag = false
		end
	end)
	table.insert(connections, ieConn)

	local rsConn
	rsConn = RS.RenderStepped:Connect(function()
		if not f or not f.Parent then rsConn:Disconnect() return end
		if not drag or not inner then return end
		local mp = UIS:GetMouseLocation()
		local ab, sz = inner.AbsolutePosition, inner.AbsoluteSize
		setVal(minV + (maxV-minV) * math.clamp((mp.X-ab.X)/sz.X, 0, 1))
	end)
	table.insert(connections, rsConn)

	return {
		Set = function(v) setVal(v) end,
		Get = function() return val end,
	}
end

local function MkDropdown(par, text, options, defV, cb, cfg, cpath, saveId, orderRef, allElements)
	local selected = defV or (options and options[1]) or ""
	if saveId and cfg[saveId] ~= nil then selected = tostring(cfg[saveId]) end
	options = options or {}
	local open    = false
	local ITEM_H  = 28

	local wrap = N("Frame", {
		Size             = UDim2.new(1, 0, 0, EL_H),
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		LayoutOrder      = orderRef(),
		ZIndex           = 10,
		Parent           = par,
	})

	local header = N("Frame", {
		Size             = UDim2.new(1, 0, 0, EL_H),
		BackgroundColor3 = T.elBg,
		BorderSizePixel  = 0,
		ZIndex           = 11,
		Parent           = wrap,
	})
	Corner(header, 6)
	Stroke(header, T.elBorder, 1, 0.28)
	Grad(header, Color3.fromRGB(28,28,28), Color3.fromRGB(17,17,17), 90)
	Noise(header, 0.95, 12)
	table.insert(allElements, { frame = header, label = string.lower(text or "") })

	N("TextLabel", {
		Size = UDim2.new(1,-95,1,0), Position = UDim2.new(0,11,0,0),
		BackgroundTransparency = 1, Text = text, TextColor3 = T.white,
		TextSize = 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 12, Parent = header,
	})

	local selLbl = N("TextLabel", {
		Size = UDim2.new(0,88,1,0), Position = UDim2.new(1,-120,0,0),
		BackgroundTransparency = 1, Text = selected, TextColor3 = T.Accent,
		TextSize = 10, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 12, Parent = header,
	})

	local arrowBox = N("Frame", {
		Size = UDim2.new(0,22,0,22), Position = UDim2.new(1,-30,0.5,-11),
		BackgroundColor3 = Color3.fromRGB(22,22,22), BorderSizePixel = 0, ZIndex = 12, Parent = header,
	})
	Corner(arrowBox, 5)
	Stroke(arrowBox, T.elBorder, 1, 0.2)
	local arrow = Img(icon("chevron-down"), arrowBox, 11, UDim2.new(0.5,-5.5,0.5,-5.5), T.dimLight, 13)

	local listWrap = N("Frame", {
		Size             = UDim2.new(1, 0, 0, 0),
		Position         = UDim2.new(0, 0, 0, EL_H + 3),
		BackgroundColor3 = T.dropBg,
		BorderSizePixel  = 0,
		ClipsDescendants = true,
		ZIndex           = 10,
		Parent           = wrap,
	})
	Corner(listWrap, 6)
	Stroke(listWrap, T.elBorder, 1, 0.2)
	Grad(listWrap, Color3.fromRGB(24,24,24), Color3.fromRGB(14,14,14), 90)

	local listScroll = N("ScrollingFrame", {
		Size                = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		ScrollBarThickness  = 3,
		ScrollBarImageColor3 = T.Accent,
		CanvasSize          = UDim2.new(0,0,0,0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ZIndex              = 11,
		Parent              = listWrap,
	})
	N("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,2), Parent=listScroll})
	N("UIPadding", {PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4), Parent=listScroll})

	local MAX_ITEMS_SHOWN = 6
	local fullH = math.min(#options, MAX_ITEMS_SHOWN) * (ITEM_H + 2) + 10

	local function buildItems()
		for _, c in ipairs(listScroll:GetChildren()) do
			if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then
				pcall(function() c:Destroy() end)
			end
		end
		for i, opt in ipairs(options) do
			local isSel = opt == selected
			local row = N("Frame", {
				Size             = UDim2.new(1,0,0,ITEM_H),
				BackgroundColor3 = isSel and T.dropSel or T.dropBg,
				BackgroundTransparency = isSel and 0 or 1,
				BorderSizePixel  = 0,
				LayoutOrder      = i,
				ZIndex           = 12,
				Parent           = listScroll,
			})
			Corner(row, 5)
			if isSel then Stroke(row, T.Accent, 1, 0.6) end
			N("TextLabel", {
				Size = UDim2.new(1,-16,1,0), Position = UDim2.fromOffset(10,0),
				BackgroundTransparency = 1, Text = opt,
				TextColor3 = isSel and T.white or T.dimLight,
				TextSize = 10, Font = isSel and Enum.Font.GothamSemibold or Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = 13, Parent = row,
			})
			local ob = N("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", ZIndex=14, Parent=row})
			ob.MouseEnter:Connect(function()
				if not isSel then Tw(row, {BackgroundTransparency=0, BackgroundColor3=Color3.fromRGB(20,20,20)}, 0.07) end
			end)
			ob.MouseLeave:Connect(function()
				if not isSel then Tw(row, {BackgroundTransparency=1}, 0.07) end
			end)
			ob.MouseButton1Click:Connect(function()
				selected = opt
				if selLbl then selLbl.Text = selected end
				buildItems()
				if saveId then cfg[saveId] = selected saveCfg(cpath, cfg) end
				pcall(function() if cb then cb(selected) end end)
				open = false
				Tw(listWrap, {Size=UDim2.new(1,0,0,0)}, 0.18, Enum.EasingStyle.Quint)
				Tw(wrap,     {Size=UDim2.new(1,0,0,EL_H)}, 0.18, Enum.EasingStyle.Quint)
				Tw(arrow,    {Rotation=0, ImageColor3=T.dimLight}, 0.14)
				Tw(header,   {BackgroundColor3=T.elBg}, 0.12)
			end)
		end
	end
	buildItems()

	local togBtn = N("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", ZIndex=15, Parent=header})
	togBtn.MouseButton1Click:Connect(function()
		open = not open
		if open then
			buildItems()
			Tw(listWrap, {Size=UDim2.new(1,0,0,fullH)}, 0.2, Enum.EasingStyle.Quint)
			Tw(wrap,     {Size=UDim2.new(1,0,0,EL_H+3+fullH)}, 0.2, Enum.EasingStyle.Quint)
			Tw(arrow,    {Rotation=180, ImageColor3=T.Accent}, 0.15)
			Tw(header,   {BackgroundColor3=T.elBgHov}, 0.12)
		else
			Tw(listWrap, {Size=UDim2.new(1,0,0,0)}, 0.18, Enum.EasingStyle.Quint)
			Tw(wrap,     {Size=UDim2.new(1,0,0,EL_H)}, 0.18, Enum.EasingStyle.Quint)
			Tw(arrow,    {Rotation=0, ImageColor3=T.dimLight}, 0.14)
			Tw(header,   {BackgroundColor3=T.elBg}, 0.12)
		end
	end)
	togBtn.MouseEnter:Connect(function() if not open then Tw(header,{BackgroundColor3=T.elBgHov},0.1) end end)
	togBtn.MouseLeave:Connect(function() if not open then Tw(header,{BackgroundColor3=T.elBg},0.1) end end)

	return {
		Set        = function(v) selected = v if selLbl then selLbl.Text = v end buildItems() end,
		Get        = function() return selected end,
		SetOptions = function(o) options = o buildItems() end,
	}
end

local function MkKeybind(par, text, defKey, cb, cfg, cpath, saveId, orderRef, allElements, connections)
	local key = defKey or Enum.KeyCode.Unknown
	if saveId and cfg[saveId] then
		pcall(function() key = Enum.KeyCode[cfg[saveId]] or key end)
	end
	local listening = false

	local f = ElBase(par, EL_H, orderRef)
	table.insert(allElements, { frame = f, label = string.lower(text or "") })

	N("TextLabel", {
		Size = UDim2.new(1,-108,1,0), Position = UDim2.new(0,11,0,0),
		BackgroundTransparency = 1, Text = text, TextColor3 = T.white,
		TextSize = 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 4, Parent = f,
	})

	local kBox = N("Frame", {
		Size = UDim2.new(0,90,0,22), Position = UDim2.new(1,-100,0.5,-11),
		BackgroundColor3 = Color3.fromRGB(16,16,16), BorderSizePixel = 0, ZIndex = 5, Parent = f,
	})
	Corner(kBox, 5)
	Grad(kBox, Color3.fromRGB(26,26,26), Color3.fromRGB(13,13,13), 90)
	Noise(kBox, 0.88, 6)
	local kStr = N("UIStroke", {Color=T.Accent, Thickness=1, Transparency=0.5, Parent=kBox})

	local kname = key == Enum.KeyCode.Unknown and "None" or key.Name
	local kLbl = N("TextLabel", {
		Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
		Text = "[ "..kname.." ]", TextColor3 = T.Accent,
		TextSize = 9, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 7, Parent = kBox,
	})

	local btn = N("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", ZIndex=8, Parent=f})
	btn.MouseButton1Click:Connect(function()
		listening = true
		if kLbl then kLbl.Text = "[ ... ]" kLbl.TextColor3 = T.dimLight end
		Tw(kStr, {Color=T.white, Transparency=0}, 0.1)
		Tw(kBox,  {BackgroundColor3=Color3.fromRGB(24,24,24)}, 0.1)
	end)

	local kConn
	kConn = UIS.InputBegan:Connect(function(inp)
		if not f or not f.Parent then kConn:Disconnect() return end
		if not listening then return end
		if inp.UserInputType == Enum.UserInputType.Keyboard then
			listening = false
			if inp.KeyCode == Enum.KeyCode.Escape then
				local n = key == Enum.KeyCode.Unknown and "None" or key.Name
				if kLbl then kLbl.Text = "[ "..n.." ]" kLbl.TextColor3 = T.Accent end
			else
				key = inp.KeyCode
				if kLbl then kLbl.Text = "[ "..key.Name.." ]" kLbl.TextColor3 = T.Accent end
				if saveId then cfg[saveId] = key.Name saveCfg(cpath, cfg) end
				pcall(function() if cb then cb(key) end end)
			end
			Tw(kStr, {Color=T.Accent, Transparency=0.5}, 0.12)
			Tw(kBox,  {BackgroundColor3=Color3.fromRGB(16,16,16)}, 0.1)
		end
	end)
	table.insert(connections, kConn)
	HoverEl(btn, f)

	return {
		Set = function(k)
			key = k
			local n = k == Enum.KeyCode.Unknown and "None" or k.Name
			if kLbl then kLbl.Text = "[ "..n.." ]" end
		end,
		Get = function() return key end,
	}
end

local function MkColorPicker(par, text, defCol, cb, cfg, cpath, saveId, orderRef, allElements, connections)
	local color = defCol or Color3.fromRGB(255, 80, 80)
	if saveId and cfg[saveId] then
		pcall(function() color = Color3.fromHex(cfg[saveId]) end)
	end

	local open = false

	local PAD       = 10
	local SLIDER_H  = 34
	local GAP_SL    = 4
	local PREVIEW_H = 46
	local HEX_H     = 28
	local GAP       = 6
	local PICK_H = PAD
		+ SLIDER_H + GAP_SL
		+ SLIDER_H + GAP_SL
		+ SLIDER_H + GAP
		+ PREVIEW_H + GAP
		+ HEX_H + PAD

	local wrap = N("Frame", {
		Size                   = UDim2.new(1, 0, 0, EL_H),
		BackgroundTransparency = 1,
		ClipsDescendants       = false,
		LayoutOrder            = orderRef(),
		ZIndex                 = 10,
		Parent                 = par,
	})

	local header = N("Frame", {
		Size             = UDim2.new(1, 0, 0, EL_H),
		BackgroundColor3 = T.elBg,
		BorderSizePixel  = 0,
		ZIndex           = 11,
		Parent           = wrap,
	})
	Corner(header, 6)
	Stroke(header, T.elBorder, 1, 0.28)
	Grad(header, Color3.fromRGB(28,28,28), Color3.fromRGB(17,17,17), 90)
	Noise(header, 0.95, 12)
	table.insert(allElements, { frame = header, label = string.lower(text or "") })

	N("TextLabel", {
		Size = UDim2.new(1,-52,1,0), Position = UDim2.new(0,11,0,0),
		BackgroundTransparency = 1, Text = text, TextColor3 = T.white,
		TextSize = 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 12, Parent = header,
	})
	local hSwatch = N("Frame", {
		Size = UDim2.new(0,22,0,22), Position = UDim2.new(1,-32,0.5,-11),
		BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 12, Parent = header,
	})
	Corner(hSwatch, 4)
	Stroke(hSwatch, Color3.fromRGB(70,70,70), 1, 0)

	local pickWrap = N("Frame", {
		Size             = UDim2.new(1, 0, 0, 0),
		Position         = UDim2.new(0, 0, 0, EL_H + 3),
		BackgroundColor3 = T.dropBg,
		BorderSizePixel  = 0,
		ClipsDescendants = true,
		ZIndex           = 10,
		Parent           = wrap,
	})
	Corner(pickWrap, 6)
	Stroke(pickWrap, T.elBorder, 1, 0.2)
	Grad(pickWrap, Color3.fromRGB(24,24,24), Color3.fromRGB(14,14,14), 90)

	local pickInner = N("Frame", {
		Size                   = UDim2.new(1, 0, 0, PICK_H),
		BackgroundTransparency = 1,
		ZIndex                 = 11,
		Parent                 = pickWrap,
	})

	local rV = math.round(color.R * 255)
	local gV = math.round(color.G * 255)
	local bV = math.round(color.B * 255)

	local function makeRGBRow(labelText, yOff, fillCol, initVal)
		local RAIL_H = 3
		local KSZ    = 11

		N("TextLabel", {
			Size = UDim2.new(0,40,0,SLIDER_H),
			Position = UDim2.fromOffset(PAD, yOff),
			BackgroundTransparency = 1, Text = labelText,
			TextColor3 = T.dimLight, TextSize = 10, Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 13, Parent = pickInner,
		})

		local badge = N("Frame", {
			Size = UDim2.new(0,32,0,18),
			Position = UDim2.new(1, -PAD-32, 0, yOff + (SLIDER_H-18)/2),
			BackgroundColor3 = Color3.fromRGB(9,9,9), BorderSizePixel = 0, ZIndex = 13, Parent = pickInner,
		})
		Corner(badge, 4)
		Stroke(badge, T.elBorder, 1, 0.15)
		local valLbl = N("TextLabel", {
			Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
			Text = tostring(initVal), TextColor3 = T.Accent,
			TextSize = 9, Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 14, Parent = badge,
		})

		local railOffL = PAD + 44
		local railOffR = PAD + 44 + PAD + 36
		local rail = N("Frame", {
			Size = UDim2.new(1, -(railOffL + railOffR - PAD), 0, RAIL_H),
			Position = UDim2.new(0, railOffL, 0, yOff + (SLIDER_H - RAIL_H)/2),
			BackgroundColor3 = T.sliderRail, BorderSizePixel = 0, ZIndex = 13, Parent = pickInner,
		})
		Corner(rail, RAIL_H)
		Stroke(rail, T.elBorder, 1, 0.3)

		local pct  = initVal / 255
		local fill = N("Frame", {
			Size = UDim2.new(pct, 0, 1, 0),
			BackgroundColor3 = fillCol,
			BorderSizePixel = 0, ZIndex = 14, Parent = rail,
		})
		Corner(fill, RAIL_H)

		local inner = N("Frame", {
			Size = UDim2.new(1, -12, 1, 0),
			Position = UDim2.new(0, 6, 0, 0),
			BackgroundTransparency = 1, ZIndex = 14, Parent = rail,
		})

		local knob = N("Frame", {
			Size = UDim2.new(0, KSZ, 0, KSZ),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(pct, 0, 0.5, 0),
			BackgroundColor3 = T.white,
			BorderSizePixel = 0, ZIndex = 15, Parent = inner,
		})
		Corner(knob, KSZ)
		N("UIStroke", {Color = fillCol, Thickness = 1.5, Parent = knob})

		local hit = N("TextButton", {
			Size = UDim2.new(1, 0, 0, 24),
			Position = UDim2.new(0, 0, 0, -10),
			BackgroundTransparency = 1, Text = "", ZIndex = 16, Parent = rail,
		})

		return {
			fill = fill, knob = knob, inner = inner,
			valLbl = valLbl, hit = hit, KSZ = KSZ,
		}
	end

	local y1 = PAD
	local y2 = y1 + SLIDER_H + GAP_SL
	local y3 = y2 + SLIDER_H + GAP_SL

	local sR = makeRGBRow("Red",   y1, Color3.fromRGB(220, 60,  60),  rV)
	local sG = makeRGBRow("Green", y2, Color3.fromRGB(60,  200, 80),  gV)
	local sB = makeRGBRow("Blue",  y3, Color3.fromRGB(60,  130, 220), bV)

	local prevY = y3 + SLIDER_H + GAP
	local preview = N("Frame", {
		Size = UDim2.new(1, -(PAD*2), 0, PREVIEW_H),
		Position = UDim2.fromOffset(PAD, prevY),
		BackgroundColor3 = color,
		BorderSizePixel = 0, ZIndex = 12, Parent = pickInner,
	})
	Corner(preview, 6)
	Stroke(preview, T.elBorder, 1, 0.15)

	local hexY = prevY + PREVIEW_H + GAP
	local hexRow = N("Frame", {
		Size = UDim2.new(1, -(PAD*2), 0, HEX_H),
		Position = UDim2.fromOffset(PAD, hexY),
		BackgroundColor3 = T.inputBg,
		BorderSizePixel = 0, ZIndex = 12, Parent = pickInner,
	})
	Corner(hexRow, 5)
	Stroke(hexRow, T.elBorder, 1, 0.2)

	N("TextLabel", {
		Size = UDim2.new(0,18,1,0), Position = UDim2.fromOffset(6,0),
		BackgroundTransparency = 1, Text = "#", TextColor3 = T.Accent,
		TextSize = 11, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 13, Parent = hexRow,
	})
	local hexInput = N("TextBox", {
		Size = UDim2.new(1,-50,1,0), Position = UDim2.fromOffset(22,0),
		BackgroundTransparency = 1,
		Text = color:ToHex():upper(),
		PlaceholderText = "RRGGBB", PlaceholderColor3 = T.dim,
		TextColor3 = T.white, TextSize = 10, Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false, ZIndex = 13, Parent = hexRow,
	})
	local hexSwatch = N("Frame", {
		Size = UDim2.new(0,16,0,16),
		Position = UDim2.new(1,-22,0.5,-8),
		BackgroundColor3 = color,
		BorderSizePixel = 0, ZIndex = 13, Parent = hexRow,
	})
	Corner(hexSwatch, 3)
	Stroke(hexSwatch, Color3.fromRGB(60,60,60), 1, 0)

	local function syncAll(skipHexUpdate)
		color = Color3.fromRGB(rV, gV, bV)
		pcall(function()
			hSwatch.BackgroundColor3  = color
			preview.BackgroundColor3  = color
			hexSwatch.BackgroundColor3 = color
			if not skipHexUpdate and hexInput then
				hexInput.Text = color:ToHex():upper()
			end
		end)
		if saveId then cfg[saveId] = color:ToHex() saveCfg(cpath, cfg) end
		pcall(function() if cb then cb(color) end end)
	end

	local function applySlider(sl, rawVal)
		local v = math.clamp(math.round(rawVal), 0, 255)
		local p = v / 255
		sl.fill.Size     = UDim2.new(p, 0, 1, 0)
		sl.knob.Position = UDim2.new(p, 0, 0.5, 0)
		sl.valLbl.Text   = tostring(v)
		return v
	end

	local function wireSlider(sl, setFn)
		local dragActive = false
		sl.hit.MouseButton1Down:Connect(function()
			dragActive = true
			local mp = UIS:GetMouseLocation()
			local ab = sl.inner.AbsolutePosition
			local sz = sl.inner.AbsoluteSize
			local v  = applySlider(sl, math.clamp((mp.X-ab.X)/sz.X, 0, 1) * 255)
			setFn(v) syncAll(false)
		end)
		sl.hit.MouseEnter:Connect(function()
			Tw(sl.knob, {Size=UDim2.new(0,sl.KSZ+2,0,sl.KSZ+2)}, 0.1, Enum.EasingStyle.Back)
		end)
		sl.hit.MouseLeave:Connect(function()
			if not dragActive then
				Tw(sl.knob, {Size=UDim2.new(0,sl.KSZ,0,sl.KSZ)}, 0.1, Enum.EasingStyle.Back)
			end
		end)

		local slIeConn
		slIeConn = UIS.InputEnded:Connect(function(inp)
			if not pickInner or not pickInner.Parent then slIeConn:Disconnect() return end
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then
				if dragActive then
					Tw(sl.knob, {Size=UDim2.new(0,sl.KSZ,0,sl.KSZ)}, 0.1, Enum.EasingStyle.Back)
				end
				dragActive = false
			end
		end)
		table.insert(connections, slIeConn)

		local slRsConn
		slRsConn = RS.RenderStepped:Connect(function()
			if not pickInner or not pickInner.Parent then slRsConn:Disconnect() return end
			if not dragActive or not open then return end
			local mp = UIS:GetMouseLocation()
			local ab = sl.inner.AbsolutePosition
			local sz = sl.inner.AbsoluteSize
			local v  = applySlider(sl, math.clamp((mp.X-ab.X)/sz.X, 0, 1) * 255)
			setFn(v) syncAll(false)
		end)
		table.insert(connections, slRsConn)
	end

	wireSlider(sR, function(v) rV = v end)
	wireSlider(sG, function(v) gV = v end)
	wireSlider(sB, function(v) bV = v end)

	if hexInput then
		hexInput.FocusLost:Connect(function(enter)
			if not enter then return end
			local txt = hexInput.Text:gsub("[^%x]","")
			if #txt == 3 then
				txt = txt:sub(1,1):rep(2) .. txt:sub(2,2):rep(2) .. txt:sub(3,3):rep(2)
			end
			local ok2, c2 = pcall(Color3.fromHex, txt)
			if ok2 and typeof(c2) == "Color3" then
				rV = math.round(c2.R * 255)
				gV = math.round(c2.G * 255)
				bV = math.round(c2.B * 255)
				applySlider(sR, rV)
				applySlider(sG, gV)
				applySlider(sB, bV)
				syncAll(true)
				hexInput.Text = color:ToHex():upper()
			else
				hexInput.Text = color:ToHex():upper()
			end
		end)
	end

	local togBtn = N("TextButton", {
		Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
		Text = "", ZIndex = 15, Parent = header,
	})
	togBtn.MouseButton1Click:Connect(function()
		open = not open
		if open then
			Tw(pickWrap, {Size = UDim2.new(1,0,0,PICK_H)},         0.2, Enum.EasingStyle.Quint)
			Tw(wrap,     {Size = UDim2.new(1,0,0,EL_H+3+PICK_H)}, 0.2, Enum.EasingStyle.Quint)
			Tw(header,   {BackgroundColor3 = T.elBgHov},            0.12)
		else
			Tw(pickWrap, {Size = UDim2.new(1,0,0,0)},    0.18, Enum.EasingStyle.Quint)
			Tw(wrap,     {Size = UDim2.new(1,0,0,EL_H)}, 0.18, Enum.EasingStyle.Quint)
			Tw(header,   {BackgroundColor3 = T.elBg},     0.12)
		end
	end)
	togBtn.MouseEnter:Connect(function()
		if not open then Tw(header, {BackgroundColor3=T.elBgHov}, 0.1) end
	end)
	togBtn.MouseLeave:Connect(function()
		if not open then Tw(header, {BackgroundColor3=T.elBg}, 0.1) end
	end)

	return {
		Set = function(c)
			color = c
			rV = math.round(c.R * 255)
			gV = math.round(c.G * 255)
			bV = math.round(c.B * 255)
			applySlider(sR, rV)
			applySlider(sG, gV)
			applySlider(sB, bV)
			syncAll(false)
		end,
		Get = function() return color end,
	}
end

local function MkLabel(par, text, iconName, orderRef, allElements)
	local f = ElBase(par, EL_H, orderRef)
	table.insert(allElements, { frame = f, label = string.lower(text or "") })

	local hasIcon = iconName and iconName ~= ""
	local txtOff = hasIcon and 34 or 11
	local txtW   = hasIcon and -54 or -22

	if hasIcon then
		Img(icon(iconName), f, 14, UDim2.new(0, 11, 0.5, -7), T.dimLight, 5)
	end

	local lbl = N("TextLabel", {
		Size = UDim2.new(1, txtW, 1, 0), Position = UDim2.new(0, txtOff, 0, 0),
		BackgroundTransparency = 1, Text = text, TextColor3 = T.dimLight,
		TextSize = 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 4, Parent = f,
	})

	return {
		SetText = function(v) if lbl then lbl.Text = tostring(v) end end,
		GetText = function() return lbl and lbl.Text or "" end,
	}
end

local function MkEmoji(par, emoji, text, orderRef, allElements)
	local f = ElBase(par, EL_H, orderRef)
	table.insert(allElements, { frame = f, label = string.lower(text or "") })

	local badge = N("Frame", {
		Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(0, 6, 0.5, -13),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		BorderSizePixel = 0, ZIndex = 5, Parent = f,
	})
	Corner(badge, 6)
	Stroke(badge, T.elBorder, 1, 0.2)

	local emojiLbl = N("TextLabel", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = tostring(emoji or ""),
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		ZIndex = 6, Parent = badge,
	})

	local textLbl = N("TextLabel", {
		Size = UDim2.new(1, -44, 1, 0), Position = UDim2.new(0, 40, 0, 0),
		BackgroundTransparency = 1, Text = tostring(text or ""),
		TextColor3 = T.white, TextSize = 11, Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 4, Parent = f,
	})

	return {
		SetEmoji   = function(v) if emojiLbl then emojiLbl.Text = tostring(v) end end,
		SetText    = function(v) if textLbl  then textLbl.Text  = tostring(v) end end,
		GetEmoji   = function() return emojiLbl and emojiLbl.Text or "" end,
		GetText    = function() return textLbl  and textLbl.Text  or "" end,
	}
end

local function MkSecObj(scroll, cfg, cpath, orderRef, allElements, connections)
	local obj = {}

	function obj:AddToggle(text, default, callback, saveId)
		return MkToggle(scroll, text, default, callback, cfg, cpath, saveId, orderRef, allElements)
	end
	function obj:AddCheckbox(text, default, callback, saveId)
		return MkCheckbox(scroll, text, default, callback, cfg, cpath, saveId, orderRef, allElements)
	end
	function obj:AddButton(text, callback)
		return MkButton(scroll, text, callback, orderRef, allElements)
	end
	function obj:AddSlider(text, minV, maxV, defV, callback, saveId)
		return MkSlider(scroll, text, minV, maxV, defV, callback, cfg, cpath, saveId, orderRef, allElements, connections)
	end
	function obj:AddDropdown(text, opts, defV, callback, saveId)
		return MkDropdown(scroll, text, opts, defV, callback, cfg, cpath, saveId, orderRef, allElements)
	end
	function obj:AddKeybind(text, defKey, callback, saveId)
		return MkKeybind(scroll, text, defKey, callback, cfg, cpath, saveId, orderRef, allElements, connections)
	end
	function obj:AddColorPicker(text, defCol, callback, saveId)
		return MkColorPicker(scroll, text, defCol, callback, cfg, cpath, saveId, orderRef, allElements, connections)
	end
	function obj:AddLabel(text, iconName)
		return MkLabel(scroll, text, iconName, orderRef, allElements)
	end
	function obj:AddEmoji(emoji, text)
		return MkEmoji(scroll, emoji, text, orderRef, allElements)
	end
	function obj:AddSection(name)
		MkSection(scroll, name or "Section", orderRef)
		return MkSecObj(scroll, cfg, cpath, orderRef, allElements, connections)
	end

	return obj
end

function lib:CreateWindow(opts)
	opts = type(opts) == "table" and opts or {}
	local title    = opts.Title    or "Eco Hub"
	local subtitle = opts.Subtitle or ""

	local cpath        = cfgPath(title)
	local cfg          = readCfg(cpath)
	local sideExpanded = true
	local minimized    = false
	local dragging     = false
	local dragOff      = Vector2.zero
	local tabs         = {}
	local activeTab    = nil
	local secLabels    = {}
	local sideOrder    = 0
	local lastSection  = nil
	local curSW        = SIDE_W
	local searchActive = false

	local _order       = 0
	local allElements  = {}
	local connections  = {}

	local function orderRef()
		_order = _order + 1
		return _order
	end

	local guiParent
	pcall(function() guiParent = gethui and gethui() end)
	guiParent = guiParent or game:GetService("CoreGui")

	local gui = N("ScreenGui", {
		Name           = "ecohub_" .. math.random(100000,999999),
		ResetOnSpawn   = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder   = 999,
		IgnoreGuiInset = true,
		Parent         = guiParent,
	})

	local main = N("Frame", {
		AnchorPoint      = Vector2.new(0.5,0.5),
		Size             = UDim2.new(0,PANEL_W,0,PANEL_H),
		Position         = UDim2.fromScale(0.5,0.5),
		BackgroundColor3 = T.bg,
		BorderSizePixel  = 0,
		ClipsDescendants = true,
		ZIndex           = 1,
		Parent           = gui,
	})

	local titleBar = N("Frame",{
		Size=UDim2.new(1,0,0,TITLE_H),
		BackgroundColor3=T.surface, BorderSizePixel=0, ZIndex=8, Parent=main,
	})
	Grad(titleBar, Color3.fromRGB(22,22,22), Color3.fromRGB(15,15,15), 90)
	Noise(titleBar, 0.92, 9)
	N("Frame",{
		Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
		BackgroundColor3=T.divider, BorderSizePixel=0, ZIndex=9, Parent=titleBar,
	})
	N("TextLabel",{
		Size=UDim2.new(0,200,1,0), Position=UDim2.new(0,12,0,0),
		BackgroundTransparency=1, Text=title, TextColor3=T.white,
		TextSize=13, Font=Enum.Font.GothamBold,
		TextXAlignment=Enum.TextXAlignment.Left, ZIndex=10, Parent=titleBar,
	})
	if subtitle ~= "" then
		N("TextLabel",{
			Size=UDim2.new(0,60,1,0), Position=UDim2.new(1,-68,0,0),
			BackgroundTransparency=1, Text=subtitle, TextColor3=T.dim,
			TextSize=10, Font=Enum.Font.Gotham,
			TextXAlignment=Enum.TextXAlignment.Right, ZIndex=10, Parent=titleBar,
		})
	end

	local sidebar = N("Frame",{
		Size=UDim2.new(0,curSW,1,-TITLE_H), Position=UDim2.new(0,0,0,TITLE_H),
		BackgroundColor3=T.sidebar, BorderSizePixel=0, ClipsDescendants=true,
		ZIndex=4, Parent=main,
	})
	Grad(sidebar, Color3.fromRGB(19,19,19), Color3.fromRGB(12,12,12), 90)
	Noise(sidebar, 0.93, 5)

	local vdiv = N("Frame",{
		Size=UDim2.new(0,1,1,-TITLE_H), Position=UDim2.new(0,curSW,0,TITLE_H),
		BackgroundColor3=T.divider, BorderSizePixel=0, ZIndex=5, Parent=main,
	})

	local logoArea = N("Frame",{
		Size=UDim2.new(1,0,0,LOGO_H), BackgroundTransparency=1, ZIndex=5, Parent=sidebar,
	})
	local sideLogoImg = N("ImageLabel",{
		Size=UDim2.new(0,72,0,72), Position=UDim2.new(0.5,-36,0.5,-36),
		BackgroundTransparency=1, Image=LOGO_ID, ZIndex=6, Parent=logoArea,
	})
	N("Frame",{
		Size=UDim2.new(1,-20,0,1), Position=UDim2.new(0,10,1,-1),
		BackgroundColor3=T.divider, BorderSizePixel=0, ZIndex=5, Parent=logoArea,
	})

	local sideScroll = N("ScrollingFrame",{
		Size=UDim2.new(1,0,1,-(LOGO_H+72)), Position=UDim2.new(0,0,0,LOGO_H+2),
		BackgroundTransparency=1, ScrollBarThickness=0,
		CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
		ZIndex=5, Parent=sidebar,
	})
	N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,1),Parent=sideScroll})
	N("UIPadding",{PaddingLeft=UDim.new(0,5),PaddingRight=UDim.new(0,5),PaddingTop=UDim.new(0,3),Parent=sideScroll})

	N("Frame",{
		Size=UDim2.new(1,-10,0,1), Position=UDim2.new(0,5,1,-66),
		BackgroundColor3=T.divider, BorderSizePixel=0, ZIndex=5, Parent=sidebar,
	})

	local colBtn = N("TextButton",{
		Size=UDim2.new(1,-10,0,22), Position=UDim2.new(0,5,1,-60),
		BackgroundColor3=T.tabBgHov, BackgroundTransparency=1,
		BorderSizePixel=0, Text="", AutoButtonColor=false, ZIndex=5, Parent=sidebar,
	})
	Corner(colBtn, 5)
	local colIco = Img(icon("chevron-left"), colBtn, 12, UDim2.new(1,-15,0.5,-6), T.dimLight, 6)
	local colLbl = N("TextLabel",{
		Size=UDim2.new(1,-22,1,0), Position=UDim2.new(0,7,0,0),
		BackgroundTransparency=1, Text="Collapse", TextColor3=T.dimLight,
		TextSize=10, Font=Enum.Font.Gotham,
		TextXAlignment=Enum.TextXAlignment.Left, ZIndex=6, Parent=colBtn,
	})

	local avFrame = N("Frame",{
		Size=UDim2.new(1,-10,0,32), Position=UDim2.new(0,5,1,-34),
		BackgroundColor3=T.avatarBg, BorderSizePixel=0, ZIndex=5, Parent=sidebar,
	})
	Corner(avFrame, 6)
	Stroke(avFrame, T.elBorder, 1, 0.3)
	local avImg = N("ImageLabel",{
		Size=UDim2.new(0,20,0,20), Position=UDim2.new(0,6,0.5,-10),
		BackgroundColor3=T.dim, BorderSizePixel=0, ZIndex=6, Parent=avFrame,
	})
	Corner(avImg, 10)
	local avName = N("TextLabel",{
		Size=UDim2.new(1,-32,0,12), Position=UDim2.new(0,30,0,5),
		BackgroundTransparency=1, Text=lp.DisplayName, TextColor3=T.white,
		TextSize=10, Font=Enum.Font.GothamBold,
		TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd,
		ZIndex=6, Parent=avFrame,
	})
	local avTag = N("TextLabel",{
		Size=UDim2.new(1,-32,0,10), Position=UDim2.new(0,30,0,17),
		BackgroundTransparency=1, Text="@"..lp.Name, TextColor3=T.dim,
		TextSize=9, Font=Enum.Font.Gotham,
		TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd,
		ZIndex=6, Parent=avFrame,
	})
	task.spawn(function()
		local ok, url = pcall(function()
			return Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
		end)
		if ok and avImg then avImg.Image = url end
	end)

	local pageArea = N("Frame",{
		Size=UDim2.new(1,-(curSW+1),1,-TITLE_H), Position=UDim2.new(0,curSW+1,0,TITLE_H),
		BackgroundColor3=T.pageBg, BorderSizePixel=0, ClipsDescendants=true,
		ZIndex=2, Parent=main,
	})

	local searchBar = N("Frame",{
		Size=UDim2.new(1,-14,0,26), Position=UDim2.new(0,7,0,7),
		BackgroundColor3=T.searchBg, BorderSizePixel=0, ZIndex=5, Parent=pageArea,
	})
	Corner(searchBar, 5)
	Stroke(searchBar, T.elBorder, 1, 0.2)
	Noise(searchBar, 0.93, 6)
	Img(icon("search"), searchBar, 11, UDim2.new(0,7,0.5,-5.5), T.dim, 7)
	local searchBox = N("TextBox",{
		Size=UDim2.new(1,-24,1,0), Position=UDim2.new(0,22,0,0),
		BackgroundTransparency=1, PlaceholderText="Search elements...",
		PlaceholderColor3=T.dim, Text="", TextColor3=T.white,
		TextSize=10, Font=Enum.Font.Gotham,
		TextXAlignment=Enum.TextXAlignment.Left,
		ClearTextOnFocus=false, ZIndex=7, Parent=searchBar,
	})

	N("Frame",{
		Size=UDim2.new(1,-14,0,1), Position=UDim2.new(0,7,0,41),
		BackgroundColor3=T.divider, BorderSizePixel=0, ZIndex=4, Parent=pageArea,
	})

	local contentArea = N("Frame",{
		Size=UDim2.new(1,0,1,-42), Position=UDim2.new(0,0,0,42),
		BackgroundColor3=T.pageBg, BorderSizePixel=0, ClipsDescendants=true,
		ZIndex=2, Parent=pageArea,
	})

	local searchPage = N("ScrollingFrame",{
		Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
		ScrollBarThickness=3, ScrollBarImageColor3=T.Accent,
		CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
		Visible=false, ZIndex=2, Parent=contentArea,
	})
	N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,8),Parent=searchPage})
	N("UIPadding",{
		PaddingTop=UDim.new(0,8), PaddingBottom=UDim.new(0,10),
		PaddingLeft=UDim.new(0,9), PaddingRight=UDim.new(0,9),
		Parent=searchPage,
	})
	local noResultLbl = N("TextLabel",{
		Size=UDim2.new(1,0,0,30), LayoutOrder=999,
		BackgroundTransparency=1, Text="No results found.",
		TextColor3=T.dimLight, TextSize=11, Font=Enum.Font.Gotham,
		TextXAlignment=Enum.TextXAlignment.Center, Visible=false,
		ZIndex=3, Parent=searchPage,
	})

	local _movedEntries = {}

	local function restoreSearchFrames()
		for _, m in ipairs(_movedEntries) do
			pcall(function()
				m.frame.LayoutOrder = m.origOrder
				m.frame.Parent      = m.origParent
			end)
		end
		_movedEntries = {}
	end

	local function doSearch(query)
		query = string.lower(query or "")

		restoreSearchFrames()

		if query == "" then
			searchActive = false
			searchPage.Visible = false
			if activeTab and activeTab.page then activeTab.page.Visible = true end
			return
		end

		searchActive = true
		if activeTab and activeTab.page then activeTab.page.Visible = false end
		searchPage.Visible = true

		for _, c in ipairs(searchPage:GetChildren()) do
			if not c:IsA("UIListLayout") and not c:IsA("UIPadding") and c ~= noResultLbl then
				pcall(function() c.Parent = nil end)
			end
		end

		local count, ord = 0, 0
		for _, entry in ipairs(allElements) do
			if entry.label:find(query, 1, true) and entry.frame and entry.frame.Parent then
				ord = ord + 1 count = count + 1
				table.insert(_movedEntries, {
					frame      = entry.frame,
					origParent = entry.frame.Parent,
					origOrder  = entry.frame.LayoutOrder,
				})
				entry.frame.LayoutOrder = ord
				entry.frame.Parent      = searchPage
			end
		end

		noResultLbl.Visible     = count == 0
		noResultLbl.LayoutOrder = ord + 1
	end

	searchBox:GetPropertyChangedSignal("Text"):Connect(function() doSearch(searchBox.Text) end)

	local function animUL(ul, instant)
		if not ul then return end
		ul.Size = UDim2.new(0,0,0,2) ul.Visible = true
		if instant then ul.Size = UDim2.new(1,-8,0,2)
		else Tw(ul, {Size=UDim2.new(1,-8,0,2)}, 0.22) end
	end

	local function selectTab(tab, instant)
		if not tab then return end
		for _, t in ipairs(tabs) do
			if t ~= tab then
				if t.page then t.page.Visible = false end
				if t.ul   then t.ul.Visible   = false end
				Tw(t.btn, {BackgroundTransparency=1}, 0.12)
				Tw(t.ico, {ImageColor3=T.tabIdle},    0.12)
				Tw(t.lbl, {TextColor3=T.tabIdle},     0.12)
			end
		end
		if not searchActive then
			if tab.page then tab.page.Visible = true end
		end
		activeTab = tab
		Tw(tab.btn, {BackgroundColor3=T.tabBgAct, BackgroundTransparency=0}, 0.13)
		Tw(tab.ico, {ImageColor3=T.white},  0.13)
		Tw(tab.lbl, {TextColor3=T.tabAct}, 0.13)
		animUL(tab.ul, instant)
		cfg.activeTab = tab.name saveCfg(cpath, cfg)
	end

	local function setSide(expanded)
		sideExpanded = expanded
		local sw = expanded and SIDE_W or SIDE_MINI
		curSW = sw
		Tw(sidebar,  {Size=UDim2.new(0,sw,1,-TITLE_H)}, 0.22)
		Tw(vdiv,     {Position=UDim2.new(0,sw,0,TITLE_H)}, 0.22)
		Tw(pageArea, {Size=UDim2.new(1,-(sw+1),1,-TITLE_H), Position=UDim2.new(0,sw+1,0,TITLE_H)}, 0.22)
		local hide = expanded and 0 or 1
		for _, l in ipairs(secLabels) do Tw(l, {TextTransparency=hide}, 0.15) end
		for _, t in ipairs(tabs) do
			Tw(t.lbl, {TextTransparency=hide}, 0.15)
			if t.tip then t.tip.Visible = false end
			if t.ico then
				t.ico.Position = expanded and UDim2.new(0,6,0.5,-7) or UDim2.new(0.5,-7,0.5,-7)
			end
		end
		Tw(avName, {TextTransparency=hide}, 0.15)
		Tw(avTag,  {TextTransparency=hide}, 0.15)
		if avImg then
			avImg.Position = expanded and UDim2.new(0,6,0.5,-10) or UDim2.new(0.5,-10,0.5,-10)
		end
		if sideLogoImg then
			Tw(sideLogoImg, {
				Size     = expanded and UDim2.new(0,72,0,72) or UDim2.new(0,22,0,22),
				Position = expanded and UDim2.new(0.5,-36,0.5,-36) or UDim2.new(0.5,-11,0.5,-11),
			}, 0.2)
		end
		colIco.Image    = expanded and icon("chevron-left") or icon("chevron-right")
		colIco.Position = expanded and UDim2.new(1,-15,0.5,-6) or UDim2.new(0.5,-6,0.5,-6)
		colLbl.Text = expanded and "Collapse" or "Expand"
		Tw(colLbl, {TextTransparency=hide}, 0.15)
		cfg.sideExpanded = expanded saveCfg(cpath, cfg)
	end

	if cfg.sideExpanded == false then setSide(false) end

	colBtn.MouseButton1Click:Connect(function() setSide(not sideExpanded) end)
	colBtn.MouseEnter:Connect(function()
		Tw(colBtn,{BackgroundTransparency=0,BackgroundColor3=T.tabBgHov},0.1)
		Tw(colIco,{ImageColor3=T.white},0.1) Tw(colLbl,{TextColor3=T.white},0.1)
	end)
	colBtn.MouseLeave:Connect(function()
		Tw(colBtn,{BackgroundTransparency=1},0.1)
		Tw(colIco,{ImageColor3=T.dimLight},0.1) Tw(colLbl,{TextColor3=T.dimLight},0.1)
	end)

	titleBar.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			local p = main.AbsolutePosition
			dragOff = Vector2.new(inp.Position.X-p.X, inp.Position.Y-p.Y)
		end
	end)
	titleBar.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)

	local dragConn
	dragConn = RS.RenderStepped:Connect(function()
		if not main or not main.Parent then dragConn:Disconnect() return end
		if not dragging then return end
		local m = UIS:GetMouseLocation()
		main.Position = UDim2.new(
			0, m.X-dragOff.X+main.AbsoluteSize.X*0.5,
			0, m.Y-dragOff.Y+main.AbsoluteSize.Y*0.5
		)
	end)
	table.insert(connections, dragConn)

	local minConn
	minConn = UIS.InputBegan:Connect(function(inp, _)
		if not gui or not gui.Parent then minConn:Disconnect() return end
		if inp.KeyCode == Enum.KeyCode.RightAlt then
			minimized = not minimized
			if main then main.Visible = not minimized end
			cfg.minimized = minimized saveCfg(cpath, cfg)
		end
	end)
	table.insert(connections, minConn)

	local function makeSideLabel(labelText)
		sideOrder = sideOrder + 1
		N("Frame",{Size=UDim2.new(1,0,0,4),BackgroundTransparency=1,LayoutOrder=sideOrder,ZIndex=5,Parent=sideScroll})
		sideOrder = sideOrder + 1
		local row = N("Frame",{Size=UDim2.new(1,0,0,14),BackgroundTransparency=1,LayoutOrder=sideOrder,ZIndex=5,Parent=sideScroll})
		local lbl = N("TextLabel",{
			Size=UDim2.new(1,-4,1,0), Position=UDim2.new(0,4,0,0),
			BackgroundTransparency=1, Text=string.upper(labelText),
			TextColor3=T.secText, TextSize=8, Font=Enum.Font.GothamBold,
			TextXAlignment=Enum.TextXAlignment.Left, ZIndex=6, Parent=row,
		})
		table.insert(secLabels, lbl)
	end

	local window = {}

	function window:AddTab(opts2)
		opts2 = type(opts2) == "table" and opts2 or {}
		local tabTitle   = opts2.Title   or "Tab"
		local tabIcon    = opts2.Icon    or "circle"
		local tabSection = opts2.Section or nil

		if tabSection and tabSection ~= lastSection then
			makeSideLabel(tabSection)
			lastSection = tabSection
		end
		sideOrder = sideOrder + 1

		local btn = N("TextButton",{
			Size=UDim2.new(1,0,0,26),
			BackgroundColor3=T.tabBgAct, BackgroundTransparency=1,
			BorderSizePixel=0, Text="", AutoButtonColor=false,
			LayoutOrder=sideOrder, ZIndex=6, Parent=sideScroll,
		})
		Corner(btn, 5)
		local ico = Img(icon(tabIcon), btn, 14, UDim2.new(0,5,0.5,-7), T.tabIdle, 7)
		local lbl = N("TextLabel",{
			Size=UDim2.new(1,-26,1,0), Position=UDim2.new(0,24,0,0),
			BackgroundTransparency=1, Text=tabTitle, TextColor3=T.tabIdle,
			TextSize=11, Font=Enum.Font.Gotham,
			TextXAlignment=Enum.TextXAlignment.Left, ZIndex=7, Parent=btn,
		})
		local ul = N("Frame",{
			Size=UDim2.new(0,0,0,2), Position=UDim2.new(0,4,1,-2),
			BackgroundColor3=T.underline, BorderSizePixel=0,
			Visible=false, ZIndex=9, Parent=btn,
		})
		Corner(ul, 2)
		local tip = N("TextLabel",{
			Size=UDim2.new(0,82,0,22), Position=UDim2.new(1,5,0.5,-11),
			BackgroundColor3=Color3.fromRGB(20,20,20),
			TextColor3=T.white, TextSize=10, Font=Enum.Font.Gotham,
			Text=tabTitle, TextXAlignment=Enum.TextXAlignment.Center,
			BackgroundTransparency=0, ZIndex=50, Visible=false, Parent=btn,
		})
		Corner(tip, 5)
		Stroke(tip, T.elBorder, 1, 0)

		local page = N("Frame",{
			Size=UDim2.fromScale(1,1), BackgroundColor3=T.pageBg,
			BorderSizePixel=0, ClipsDescendants=true,
			Visible=false, ZIndex=2, Parent=contentArea,
		})
		local scroll = N("ScrollingFrame",{
			Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
			ScrollBarThickness=3, ScrollBarImageColor3=T.Accent,
			CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
			ZIndex=2, Parent=page,
		})
		N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,8),Parent=scroll})
		N("UIPadding",{
			PaddingTop=UDim.new(0,8), PaddingBottom=UDim.new(0,10),
			PaddingLeft=UDim.new(0,9), PaddingRight=UDim.new(0,9),
			Parent=scroll,
		})

		local tab = {name=tabTitle, btn=btn, ico=ico, lbl=lbl, ul=ul, tip=tip, page=page, scroll=scroll}
		table.insert(tabs, tab)

		btn.MouseEnter:Connect(function()
			if activeTab ~= tab then
				Tw(btn,{BackgroundTransparency=0,BackgroundColor3=T.tabBgHov},0.1)
				Tw(ico,{ImageColor3=T.tabHov},0.1) Tw(lbl,{TextColor3=T.tabHov},0.1)
			end
			if not sideExpanded and tip then tip.Visible = true end
		end)
		btn.MouseLeave:Connect(function()
			if activeTab ~= tab then
				Tw(btn,{BackgroundTransparency=1},0.1)
				Tw(ico,{ImageColor3=T.tabIdle},0.1) Tw(lbl,{TextColor3=T.tabIdle},0.1)
			end
			if tip then tip.Visible = false end
		end)
		btn.MouseButton1Click:Connect(function()
			if searchActive then searchBox.Text="" doSearch("") end
			selectTab(tab)
		end)

		if #tabs == 1 then selectTab(tab, true) end
		if cfg.activeTab == tabTitle and cfg.activeTab ~= tabs[1].name then selectTab(tab, true) end

		local tabObj = MkSecObj(scroll, cfg, cpath, orderRef, allElements, connections)
		function tabObj:AddSection(sectionName)
			sectionName = type(sectionName)=="string" and sectionName or "Section"
			MkSection(scroll, sectionName, orderRef)
			return MkSecObj(scroll, cfg, cpath, orderRef, allElements, connections)
		end
		function tabObj:AddLabel(text, iconName)
			return MkLabel(scroll, text, iconName, orderRef, allElements)
		end
		function tabObj:AddEmoji(emoji, text)
			return MkEmoji(scroll, emoji, text, orderRef, allElements)
		end
		return tabObj
	end

	function window:Destroy()
		for _, conn in ipairs(connections) do
			pcall(function() conn:Disconnect() end)
		end
		connections = {}
		allElements = {}
		pcall(function() gui:Destroy() end)
	end

	return window
end

return lib
