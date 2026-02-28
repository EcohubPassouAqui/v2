local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService      = game:GetService("TextService")
local HttpService      = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

-- ──────────────────────────────────────────────────────────────
-- FILESYSTEM COMPAT
-- ──────────────────────────────────────────────────────────────
local _rf  = (typeof(readfile)   == "function" and readfile)   or nil
local _wf  = (typeof(writefile)  == "function" and writefile)  or nil
local _lf  = (typeof(listfiles)  == "function" and listfiles)  or nil
local _mf  = (typeof(makefolder) == "function" and makefolder) or nil
local _isd = (typeof(isfolder)   == "function" and isfolder)   or nil
local _df  = (typeof(delfile)    == "function" and delfile)
          or (typeof(deletefile) == "function" and deletefile) or nil

if syn then
    _rf  = _rf  or (syn.readfile   and syn.readfile)
    _wf  = _wf  or (syn.writefile  and syn.writefile)
    _lf  = _lf  or (syn.listfiles  and syn.listfiles)
    _mf  = _mf  or (syn.makefolder and syn.makefolder)
    _isd = _isd or (syn.isfolder   and syn.isfolder)
end

local function SafeRead(p)
    if not _rf then return nil end
    local ok,r = pcall(_rf,p) return ok and r or nil
end
local function SafeWrite(p,d)
    if not _wf then return false end
    local ok = pcall(_wf,p,d) return ok
end
local function SafeList(p)
    if not _lf then return {} end
    local ok,r = pcall(_lf,p) return (ok and r) or {}
end
local function SafeFolder(p)
    if not _mf then return false end
    pcall(_mf,p) return true
end
local function SafeIsDir(p)
    if not _isd then return false end
    local ok,r = pcall(_isd,p) return ok and r==true
end
local function SafeDel(p)
    if not _df then return false end
    local ok = pcall(_df,p) return ok
end

-- ──────────────────────────────────────────────────────────────
-- LIBRARY
-- ──────────────────────────────────────────────────────────────
local Library = {}
Library.__index = Library
Library.Options  = {}
Library._optCount = 0

local function RegOption(ctrl, typeName)
    Library._optCount = Library._optCount + 1
    local idx = "_opt_"..Library._optCount
    ctrl.Type = typeName
    ctrl._idx = idx
    Library.Options[idx] = ctrl
    return idx
end

-- ──────────────────────────────────────────────────────────────
-- ICONS (lucide)
-- ──────────────────────────────────────────────────────────────
local Icons = {
    ["lucide-accessibility"]="rbxassetid://10709751939",["lucide-activity"]="rbxassetid://10709752035",
    ["lucide-alert-circle"]="rbxassetid://10709752996",["lucide-alert-triangle"]="rbxassetid://10709753149",
    ["lucide-anchor"]="rbxassetid://10709761530",["lucide-aperture"]="rbxassetid://10709761813",
    ["lucide-archive"]="rbxassetid://10709762233",["lucide-arrow-down"]="rbxassetid://10709767827",
    ["lucide-arrow-left"]="rbxassetid://10709768114",["lucide-arrow-right"]="rbxassetid://10709768347",
    ["lucide-arrow-up"]="rbxassetid://10709768939",["lucide-award"]="rbxassetid://10709769406",
    ["lucide-axe"]="rbxassetid://10709769508",["lucide-bar-chart"]="rbxassetid://10709773755",
    ["lucide-bar-chart-2"]="rbxassetid://10709770317",["lucide-battery"]="rbxassetid://10709774640",
    ["lucide-bell"]="rbxassetid://10709775704",["lucide-bell-off"]="rbxassetid://10709775320",
    ["lucide-bike"]="rbxassetid://10709775894",["lucide-bluetooth"]="rbxassetid://10709776655",
    ["lucide-bold"]="rbxassetid://10747813908",["lucide-bomb"]="rbxassetid://10709781460",
    ["lucide-book"]="rbxassetid://10709781824",["lucide-book-open"]="rbxassetid://10709781717",
    ["lucide-bookmark"]="rbxassetid://10709782154",["lucide-bot"]="rbxassetid://10709782230",
    ["lucide-box"]="rbxassetid://10709782497",["lucide-briefcase"]="rbxassetid://10709782662",
    ["lucide-brush"]="rbxassetid://10709782758",["lucide-bug"]="rbxassetid://10709782845",
    ["lucide-building"]="rbxassetid://10709783051",["lucide-calendar"]="rbxassetid://10709789505",
    ["lucide-camera"]="rbxassetid://10709789686",["lucide-car"]="rbxassetid://10709789810",
    ["lucide-check"]="rbxassetid://10709790644",["lucide-check-circle"]="rbxassetid://10709790387",
    ["lucide-check-square"]="rbxassetid://10709790537",["lucide-chevron-down"]="rbxassetid://10709790948",
    ["lucide-chevron-left"]="rbxassetid://10709791281",["lucide-chevron-right"]="rbxassetid://10709791437",
    ["lucide-chevron-up"]="rbxassetid://10709791523",["lucide-circle"]="rbxassetid://10709798174",
    ["lucide-clock"]="rbxassetid://10709805144",["lucide-cloud"]="rbxassetid://10709806740",
    ["lucide-code"]="rbxassetid://10709810463",["lucide-coffee"]="rbxassetid://10709810814",
    ["lucide-cog"]="rbxassetid://10709810948",["lucide-coins"]="rbxassetid://10709811110",
    ["lucide-command"]="rbxassetid://10709811365",["lucide-compass"]="rbxassetid://10709811445",
    ["lucide-copy"]="rbxassetid://10709812159",["lucide-cpu"]="rbxassetid://10709813383",
    ["lucide-crosshair"]="rbxassetid://10709818534",["lucide-crown"]="rbxassetid://10709818626",
    ["lucide-database"]="rbxassetid://10709818996",["lucide-diamond"]="rbxassetid://10709819149",
    ["lucide-disc"]="rbxassetid://10723343537",["lucide-dollar-sign"]="rbxassetid://10723343958",
    ["lucide-download"]="rbxassetid://10723344270",["lucide-edit"]="rbxassetid://10734883598",
    ["lucide-edit-2"]="rbxassetid://10723344885",["lucide-eye"]="rbxassetid://10723346959",
    ["lucide-eye-off"]="rbxassetid://10723346871",["lucide-file"]="rbxassetid://10723374641",
    ["lucide-filter"]="rbxassetid://10723375128",["lucide-fingerprint"]="rbxassetid://10723375250",
    ["lucide-flame"]="rbxassetid://10723376114",["lucide-folder"]="rbxassetid://10723387563",
    ["lucide-folder-open"]="rbxassetid://10723386277",["lucide-gamepad"]="rbxassetid://10723395457",
    ["lucide-gamepad-2"]="rbxassetid://10723395215",["lucide-gauge"]="rbxassetid://10723395708",
    ["lucide-gem"]="rbxassetid://10723396000",["lucide-ghost"]="rbxassetid://10723396107",
    ["lucide-gift"]="rbxassetid://10723396402",["lucide-globe"]="rbxassetid://10723404337",
    ["lucide-hammer"]="rbxassetid://10723405360",["lucide-heart"]="rbxassetid://10723406885",
    ["lucide-help-circle"]="rbxassetid://10723406988",["lucide-home"]="rbxassetid://10723407389",
    ["lucide-image"]="rbxassetid://10723415040",["lucide-info"]="rbxassetid://10723415903",
    ["lucide-key"]="rbxassetid://10723416652",["lucide-keyboard"]="rbxassetid://10723416765",
    ["lucide-lamp"]="rbxassetid://10723417513",["lucide-layers"]="rbxassetid://10723424505",
    ["lucide-leaf"]="rbxassetid://10723425539",["lucide-lightbulb"]="rbxassetid://10723425852",
    ["lucide-link"]="rbxassetid://10723426722",["lucide-list"]="rbxassetid://10723433811",
    ["lucide-lock"]="rbxassetid://10723434711",["lucide-log-in"]="rbxassetid://10723434830",
    ["lucide-log-out"]="rbxassetid://10723434906",["lucide-magnet"]="rbxassetid://10723435069",
    ["lucide-mail"]="rbxassetid://10734885430",["lucide-map"]="rbxassetid://10734886202",
    ["lucide-map-pin"]="rbxassetid://10734886004",["lucide-maximize"]="rbxassetid://10734886735",
    ["lucide-medal"]="rbxassetid://10734887072",["lucide-megaphone"]="rbxassetid://10734887454",
    ["lucide-menu"]="rbxassetid://10734887784",["lucide-message-circle"]="rbxassetid://10734888000",
    ["lucide-message-square"]="rbxassetid://10734888228",["lucide-mic"]="rbxassetid://10734888864",
    ["lucide-mic-off"]="rbxassetid://10734888646",["lucide-minimize"]="rbxassetid://10734895698",
    ["lucide-minus"]="rbxassetid://10734896206",["lucide-minus-circle"]="rbxassetid://10734895856",
    ["lucide-monitor"]="rbxassetid://10734896881",["lucide-moon"]="rbxassetid://10734897102",
    ["lucide-more-horizontal"]="rbxassetid://10734897250",["lucide-more-vertical"]="rbxassetid://10734897387",
    ["lucide-mountain"]="rbxassetid://10734897956",["lucide-mouse"]="rbxassetid://10734898592",
    ["lucide-music"]="rbxassetid://10734905958",["lucide-navigation"]="rbxassetid://10734906744",
    ["lucide-network"]="rbxassetid://10734906975",["lucide-newspaper"]="rbxassetid://10734907168",
    ["lucide-package"]="rbxassetid://10734909540",["lucide-paint-bucket"]="rbxassetid://10734909847",
    ["lucide-paintbrush"]="rbxassetid://10734910187",["lucide-palette"]="rbxassetid://10734910430",
    ["lucide-pencil"]="rbxassetid://10734919691",["lucide-percent"]="rbxassetid://10734919919",
    ["lucide-phone"]="rbxassetid://10734921524",["lucide-pie-chart"]="rbxassetid://10734921727",
    ["lucide-pin"]="rbxassetid://10734922324",["lucide-play"]="rbxassetid://10734923549",
    ["lucide-plus"]="rbxassetid://10734924532",["lucide-plus-circle"]="rbxassetid://10734923868",
    ["lucide-power"]="rbxassetid://10734930466",["lucide-printer"]="rbxassetid://10734930632",
    ["lucide-puzzle"]="rbxassetid://10734930886",["lucide-radio"]="rbxassetid://10734931596",
    ["lucide-recycle"]="rbxassetid://10734932295",["lucide-refresh-ccw"]="rbxassetid://10734933056",
    ["lucide-refresh-cw"]="rbxassetid://10734933222",["lucide-reply"]="rbxassetid://10734934252",
    ["lucide-rocket"]="rbxassetid://10734934585",["lucide-rotate-ccw"]="rbxassetid://10734940376",
    ["lucide-rotate-cw"]="rbxassetid://10734940654",["lucide-ruler"]="rbxassetid://10734941018",
    ["lucide-save"]="rbxassetid://10734941499",["lucide-scan"]="rbxassetid://10734942565",
    ["lucide-scissors"]="rbxassetid://10734942778",["lucide-search"]="rbxassetid://10734943674",
    ["lucide-send"]="rbxassetid://10734943902",["lucide-server"]="rbxassetid://10734949856",
    ["lucide-settings"]="rbxassetid://10734950309",["lucide-settings-2"]="rbxassetid://10734950020",
    ["lucide-share"]="rbxassetid://10734950813",["lucide-shield"]="rbxassetid://10734951847",
    ["lucide-shield-alert"]="rbxassetid://10734951173",["lucide-shield-check"]="rbxassetid://10734951367",
    ["lucide-shopping-bag"]="rbxassetid://10734952273",["lucide-shopping-cart"]="rbxassetid://10734952479",
    ["lucide-shuffle"]="rbxassetid://10734953451",["lucide-sidebar"]="rbxassetid://10734954301",
    ["lucide-signal"]="rbxassetid://10734961133",["lucide-skull"]="rbxassetid://10734962068",
    ["lucide-slash"]="rbxassetid://10734962600",["lucide-sliders"]="rbxassetid://10734963400",
    ["lucide-sliders-horizontal"]="rbxassetid://10734963191",["lucide-smartphone"]="rbxassetid://10734963940",
    ["lucide-smile"]="rbxassetid://10734964441",["lucide-snowflake"]="rbxassetid://10734964600",
    ["lucide-sort-asc"]="rbxassetid://10734965115",["lucide-sort-desc"]="rbxassetid://10734965287",
    ["lucide-speaker"]="rbxassetid://10734965419",["lucide-star"]="rbxassetid://10734966248",
    ["lucide-stethoscope"]="rbxassetid://10734966384",["lucide-stop-circle"]="rbxassetid://10734972621",
    ["lucide-sun"]="rbxassetid://10734974297",["lucide-sword"]="rbxassetid://10734975486",
    ["lucide-swords"]="rbxassetid://10734975692",["lucide-syringe"]="rbxassetid://10734975932",
    ["lucide-table"]="rbxassetid://10734976230",["lucide-tag"]="rbxassetid://10734976528",
    ["lucide-target"]="rbxassetid://10734977012",["lucide-terminal"]="rbxassetid://10734982144",
    ["lucide-thermometer"]="rbxassetid://10734983134",["lucide-thumbs-down"]="rbxassetid://10734983359",
    ["lucide-thumbs-up"]="rbxassetid://10734983629",["lucide-ticket"]="rbxassetid://10734983868",
    ["lucide-timer"]="rbxassetid://10734984606",["lucide-toggle-left"]="rbxassetid://10734984834",
    ["lucide-toggle-right"]="rbxassetid://10734985040",["lucide-tornado"]="rbxassetid://10734985247",
    ["lucide-trash"]="rbxassetid://10747362393",["lucide-trash-2"]="rbxassetid://10747362241",
    ["lucide-trending-down"]="rbxassetid://10747363205",["lucide-trending-up"]="rbxassetid://10747363465",
    ["lucide-triangle"]="rbxassetid://10747363621",["lucide-trophy"]="rbxassetid://10747363809",
    ["lucide-truck"]="rbxassetid://10747364031",["lucide-tv"]="rbxassetid://10747364593",
    ["lucide-umbrella"]="rbxassetid://10747364971",["lucide-undo"]="rbxassetid://10747365484",
    ["lucide-unlock"]="rbxassetid://10747366027",["lucide-upload"]="rbxassetid://10747366434",
    ["lucide-user"]="rbxassetid://10747373176",["lucide-user-check"]="rbxassetid://10747371901",
    ["lucide-user-cog"]="rbxassetid://10747372167",["lucide-user-minus"]="rbxassetid://10747372346",
    ["lucide-user-plus"]="rbxassetid://10747372702",["lucide-user-x"]="rbxassetid://10747372992",
    ["lucide-users"]="rbxassetid://10747373426",["lucide-utensils"]="rbxassetid://10747373821",
    ["lucide-verified"]="rbxassetid://10747374131",["lucide-video"]="rbxassetid://10747374938",
    ["lucide-video-off"]="rbxassetid://10747374721",["lucide-volume"]="rbxassetid://10747376008",
    ["lucide-volume-2"]="rbxassetid://10747375679",["lucide-volume-x"]="rbxassetid://10747375880",
    ["lucide-wallet"]="rbxassetid://10747376205",["lucide-wand"]="rbxassetid://10747376565",
    ["lucide-watch"]="rbxassetid://10747376722",["lucide-webcam"]="rbxassetid://10747381992",
    ["lucide-wifi"]="rbxassetid://10747382504",["lucide-wifi-off"]="rbxassetid://10747382268",
    ["lucide-wind"]="rbxassetid://10747382750",["lucide-wrench"]="rbxassetid://10747383470",
    ["lucide-x"]="rbxassetid://10747384394",["lucide-x-circle"]="rbxassetid://10747383819",
    ["lucide-zoom-in"]="rbxassetid://10747384552",["lucide-zoom-out"]="rbxassetid://10747384679",
}
Library.Icons = Icons

-- ──────────────────────────────────────────────────────────────
-- THEME  (roxo igual à imagem)
-- ──────────────────────────────────────────────────────────────
local C = {
    BG      = Color3.fromRGB(20,  20,  22),
    SIDE    = Color3.fromRGB(15,  15,  17),
    ELEM    = Color3.fromRGB(30,  30,  33),
    SECT    = Color3.fromRGB(25,  25,  28),
    HOVER   = Color3.fromRGB(40,  40,  44),
    ACTIVE  = Color3.fromRGB(35,  35,  38),
    BTNHOV  = Color3.fromRGB(45,  45,  50),
    BTNACT  = Color3.fromRGB(28,  28,  32),
    ACCENT  = Color3.fromRGB(160, 100, 255),   -- roxo
    ACCENTD = Color3.fromRGB(130, 70,  220),
    TEXT    = Color3.fromRGB(235, 235, 240),
    TEXTSUB = Color3.fromRGB(165, 165, 175),
    DIM     = Color3.fromRGB(110, 110, 120),
    OFF     = Color3.fromRGB(22,  22,  25),
    CHECK   = Color3.fromRGB(160, 100, 255),
    BORDER  = Color3.fromRGB(55,  55,  62),
    SEP     = Color3.fromRGB(40,  40,  45),
    KEYBG   = Color3.fromRGB(25,  25,  28),
    DDBG    = Color3.fromRGB(28,  28,  32),
    DDBDR   = Color3.fromRGB(55,  55,  62),
    TABLINE = Color3.fromRGB(160, 100, 255),
    SUCCESS = Color3.fromRGB(80,  220, 120),
    WARN    = Color3.fromRGB(255, 200, 80),
    ERROR   = Color3.fromRGB(255, 90,  90),
}

local TI = {
    Fast = TweenInfo.new(0.10, Enum.EasingStyle.Quad),
    Med  = TweenInfo.new(0.18, Enum.EasingStyle.Quad),
    Slow = TweenInfo.new(0.25, Enum.EasingStyle.Quart),
    Key  = TweenInfo.new(0.08, Enum.EasingStyle.Quad),
}

local SQ = 5   -- corner radius padrão

-- ──────────────────────────────────────────────────────────────
-- HELPERS
-- ──────────────────────────────────────────────────────────────
local function Tw(obj, props, ti)
    pcall(function() TweenService:Create(obj, ti or TI.Fast, props):Play() end)
end

local function ni(class, props, parent)
    local o = Instance.new(class)
    for k,v in pairs(props) do o[k]=v end
    if parent then o.Parent=parent end
    return o
end

local function Corner(p, r)
    ni("UICorner",{CornerRadius=UDim.new(0,r or SQ)},p)
end

local function MkStroke(p, col, thick)
    return ni("UIStroke",{Color=col or C.BORDER, Thickness=thick or 1},p)
end

local function GetKeyName(kc)
    local m={Return="Enter",LeftShift="LShift",RightShift="RShift",
             LeftControl="LCtrl",RightControl="RCtrl",LeftAlt="LAlt",RightAlt="RAlt"}
    return m[kc.Name] or kc.Name
end

local function GetIconId(name)
    if not name then return nil end
    return Icons["lucide-"..name] or Icons[name]
end

local function MkIcon(parent, iconName, sz, px, py, col, ax, ay)
    local id = GetIconId(iconName)
    if not id then return nil end
    local img = ni("ImageLabel",{
        BackgroundTransparency=1, Image=id, ImageColor3=col or C.DIM,
        Size=sz or UDim2.new(0,14,0,14),
        Position=UDim2.new(0,px or 8,0.5,py or 0),
        AnchorPoint=Vector2.new(ax or 0, ay or 0.5),
        ScaleType=Enum.ScaleType.Fit,
    },parent)
    return img
end

local function MkCheckIcon(parent)
    return ni("ImageLabel",{
        BackgroundTransparency=1,
        Image="rbxassetid://10709790644",
        ImageColor3=Color3.fromRGB(255,255,255),
        ImageTransparency=1,
        Size=UDim2.new(0,11,0,11),
        Position=UDim2.new(0.5,0,0.5,0),
        AnchorPoint=Vector2.new(0.5,0.5),
        ScaleType=Enum.ScaleType.Fit,
    },parent)
end

-- ──────────────────────────────────────────────────────────────
-- SECTION BUILDER  ← corrigido: header colado no conteúdo
-- ──────────────────────────────────────────────────────────────
local function BuildSection(sname, PageScroll)

    -- Wrapper externo com borda única
    local Outer = ni("Frame",{
        Size=UDim2.new(1,0,0,0),
        AutomaticSize=Enum.AutomaticSize.Y,
        BackgroundColor3=C.ELEM,
        BorderSizePixel=0,
        ClipsDescendants=true,
    }, PageScroll)
    Corner(Outer, SQ)
    MkStroke(Outer, C.BORDER, 1)

    -- Header roxo (topo do card)
    local Hdr = ni("Frame",{
        Size=UDim2.new(1,0,0,26),
        BackgroundColor3=C.ACCENT,
        BorderSizePixel=0,
    }, Outer)
    -- arredonda só o topo do header
    Corner(Hdr, SQ)
    -- tampa os cantos inferiores do header
    ni("Frame",{
        Size=UDim2.new(1,0,0,SQ),
        Position=UDim2.new(0,0,1,-SQ),
        BackgroundColor3=C.ACCENT,
        BorderSizePixel=0,
    }, Hdr)

    ni("TextLabel",{
        Size=UDim2.new(1,-12,1,0),
        Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Text=sname or "Section",
        TextColor3=Color3.fromRGB(255,255,255),
        TextSize=10,
        Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, Hdr)

    -- Área de conteúdo — começa imediatamente abaixo do header
    local Content = ni("Frame",{
        Size=UDim2.new(1,0,0,0),
        Position=UDim2.new(0,0,0,26),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y,
    }, Outer)

    ni("UIListLayout",{
        Parent=Content,
        SortOrder=Enum.SortOrder.LayoutOrder,
        Padding=UDim.new(0,0),
    })

    local elemCount = 0

    -- Base frame de elemento com separador automático
    local function Base(h, noSep)
        elemCount = elemCount + 1
        local f = ni("Frame",{
            Size=UDim2.new(1,0,0,h),
            BackgroundColor3=C.ELEM,
            BorderSizePixel=0,
            LayoutOrder=elemCount,
        }, Content)
        if not noSep and elemCount > 1 then
            ni("Frame",{
                Size=UDim2.new(1,0,0,1),
                BackgroundColor3=C.SEP,
                BorderSizePixel=0,
                ZIndex=2,
            }, f)
        end
        return f
    end

    -- Sync groups (por section)
    local SyncGroups = {}
    local function RegSync(ctrl, key)
        if not key then return end
        SyncGroups[key] = SyncGroups[key] or {}
        table.insert(SyncGroups[key], ctrl)
    end
    local function DoSync(key, val, src)
        if not key or not SyncGroups[key] then return end
        for _,c in ipairs(SyncGroups[key]) do
            if c ~= src then pcall(function() c:Set(val) end) end
        end
    end

    local S = {}

    -- ────────────────────────────────
    -- addButton
    -- ────────────────────────────────
    function S:addButton(name, callback, iconName)
        local cb = callback or function() end
        local f  = Base(32)
        local padL = 14
        local ico

        if iconName then
            ico = MkIcon(f, iconName, UDim2.new(0,13,0,13), 12, 0, C.DIM, 0, 0.5)
            if ico then padL=32 end
        end

        local arrow = ni("ImageLabel",{
            BackgroundTransparency=1, Image="rbxassetid://10709791437",
            ImageColor3=C.DIM, Size=UDim2.new(0,10,0,10),
            AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0),
            ScaleType=Enum.ScaleType.Fit,
        }, f)

        local btn = ni("TextButton",{
            Parent=f, BackgroundTransparency=1, Size=UDim2.new(1,0,1,0),
            AutoButtonColor=false, Font=Enum.Font.GothamSemibold,
            Text=name or "Button", TextColor3=C.TEXT, TextSize=11,
            TextXAlignment=padL>14 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
        })
        btn.Parent = f
        if padL>14 then
            ni("UIPadding",{PaddingLeft=UDim.new(0,padL)}, btn)
        end

        btn.MouseEnter:Connect(function()
            Tw(f,{BackgroundColor3=C.BTNHOV}) Tw(arrow,{ImageColor3=C.ACCENT})
            Tw(btn,{TextColor3=C.ACCENT}) if ico then Tw(ico,{ImageColor3=C.ACCENT}) end
        end)
        btn.MouseLeave:Connect(function()
            Tw(f,{BackgroundColor3=C.ELEM}) Tw(arrow,{ImageColor3=C.DIM})
            Tw(btn,{TextColor3=C.TEXT}) if ico then Tw(ico,{ImageColor3=C.DIM}) end
        end)
        btn.MouseButton1Down:Connect(function() Tw(f,{BackgroundColor3=C.BTNACT}) end)
        btn.MouseButton1Up:Connect(function()
            Tw(f,{BackgroundColor3=C.BTNHOV})
            task.spawn(function() pcall(cb) end)
        end)

        local ctrl={}
        function ctrl:SetText(t) btn.Text=tostring(t or "") end
        function ctrl:GetText() return btn.Text end
        function ctrl:SetCallback(fn) cb=fn or function() end end
        function ctrl:SetVisible(v) f.Visible=v==true end
        function ctrl:GetVisible() return f.Visible end
        function ctrl:remove() f:Destroy() end
        return ctrl
    end

    -- ────────────────────────────────
    -- addSeparator
    -- ────────────────────────────────
    function S:addSeparator()
        elemCount = elemCount+1
        local f = ni("Frame",{
            Size=UDim2.new(1,0,0,1), BackgroundColor3=C.SEP,
            BorderSizePixel=0, LayoutOrder=elemCount,
        }, Content)
        local ctrl={}
        function ctrl:SetVisible(v) f.Visible=v==true end
        function ctrl:SetColor(c) f.BackgroundColor3=c end
        function ctrl:remove() f:Destroy() end
        return ctrl
    end

    -- ────────────────────────────────
    -- addLabel
    -- ────────────────────────────────
    function S:addLabel(text)
        local f = Base(28, true)
        f.BackgroundTransparency=1
        local s=f:FindFirstChildOfClass("UIStroke") if s then s:Destroy() end
        local lbl = ni("TextLabel",{
            Size=UDim2.new(1,-20,1,0), Position=UDim2.new(0,10,0,0),
            BackgroundTransparency=1, Text=text or "",
            TextColor3=C.TEXTSUB, TextSize=10, Font=Enum.Font.Gotham,
            TextXAlignment=Enum.TextXAlignment.Left,
        }, f)
        local ctrl={}
        function ctrl:Set(t) lbl.Text=tostring(t or "") end
        function ctrl:Get() return lbl.Text end
        function ctrl:SetColor(c) lbl.TextColor3=c end
        function ctrl:SetVisible(v) f.Visible=v==true end
        function ctrl:remove() f:Destroy() end
        return ctrl
    end

    -- ────────────────────────────────
    -- addParagraph
    -- ────────────────────────────────
    function S:addParagraph(title2, body)
        elemCount = elemCount+1
        local f = ni("Frame",{
            Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
            BackgroundColor3=C.OFF, BorderSizePixel=0, LayoutOrder=elemCount,
        }, Content)
        Corner(f, SQ) MkStroke(f, C.BORDER, 1)
        ni("UIPadding",{PaddingBottom=UDim.new(0,8)}, f)

        local tl = ni("TextLabel",{
            BackgroundTransparency=1, Position=UDim2.new(0,10,0,6),
            Size=UDim2.new(1,-20,0,14), Font=Enum.Font.GothamSemibold,
            Text=title2 or "Title", TextColor3=C.TEXT, TextSize=11,
            TextXAlignment=Enum.TextXAlignment.Left,
        }, f)
        local cl = ni("TextLabel",{
            BackgroundTransparency=1, Position=UDim2.new(0,10,0,22),
            Size=UDim2.new(1,-20,0,0), AutomaticSize=Enum.AutomaticSize.Y,
            Font=Enum.Font.Gotham, Text=body or "", TextColor3=C.DIM, TextSize=10,
            TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true,
        }, f)

        local ctrl={}
        function ctrl:setTitle(t) tl.Text=tostring(t) end
        function ctrl:setBody(b) cl.Text=tostring(b) end
        function ctrl:setTitleColor(c) tl.TextColor3=c end
        function ctrl:setBodyColor(c) cl.TextColor3=c end
        function ctrl:SetVisible(v) f.Visible=v==true end
        function ctrl:remove() f:Destroy() end
        return ctrl
    end

    -- ────────────────────────────────
    -- addCheck  (checkbox quadrado)
    -- ────────────────────────────────
    function S:addCheck(checkname, default, callback, iconName, syncKey)
        local cb = callback or function() end
        local On = default==true
        local f  = Base(32)
        local ctrl={}

        local box = ni("Frame",{
            BackgroundColor3=On and C.CHECK or C.OFF, BorderSizePixel=0,
            Position=UDim2.new(0,8,0.5,0), AnchorPoint=Vector2.new(0,0.5),
            Size=UDim2.new(0,17,0,17),
        }, f)
        Corner(box, SQ)
        local bStroke = MkStroke(box, On and C.CHECK or C.BORDER)

        local fill = ni("Frame",{
            Parent=box, AnchorPoint=Vector2.new(0.5,0.5),
            BackgroundColor3=C.CHECK, BackgroundTransparency=On and 0 or 1,
            BorderSizePixel=0, Position=UDim2.new(0.5,0,0.5,0),
            Size=On and UDim2.new(1,0,1,0) or UDim2.new(0,0,0,0),
        })
        Corner(fill, SQ)
        local chkImg = MkCheckIcon(box)
        chkImg.ImageTransparency = On and 0 or 1

        local padL = 32
        if iconName then
            local ic=MkIcon(f,iconName,UDim2.new(0,13,0,13),32,0,C.DIM,0,0.5)
            if ic then padL=52 end
        end

        local lbl = ni("TextLabel",{
            BackgroundTransparency=1, Position=UDim2.new(0,padL,0,0),
            Size=UDim2.new(1,-(padL+10),1,0), Font=Enum.Font.GothamSemibold,
            Text=checkname or "Check", TextColor3=On and C.TEXT or C.DIM, TextSize=11,
            TextXAlignment=Enum.TextXAlignment.Left,
        }, f)

        local function UpdVisuals()
            Tw(box,{BackgroundColor3=On and C.CHECK or C.OFF})
            Tw(fill,{BackgroundTransparency=On and 0 or 1,
                     Size=On and UDim2.new(1,0,1,0) or UDim2.new(0,0,0,0)})
            Tw(chkImg,{ImageTransparency=On and 0 or 1})
            bStroke.Color = On and C.CHECK or C.BORDER
            Tw(lbl,{TextColor3=On and C.TEXT or C.DIM})
        end

        local hit = ni("TextButton",{
            BackgroundTransparency=1, Size=UDim2.new(1,0,1,0),
            AutoButtonColor=false, Text="", ZIndex=10,
        }, f)
        local _p=false
        hit.MouseEnter:Connect(function() Tw(f,{BackgroundColor3=C.HOVER}) end)
        hit.MouseLeave:Connect(function() _p=false Tw(f,{BackgroundColor3=C.ELEM}) end)
        hit.MouseButton1Down:Connect(function() _p=true end)
        hit.MouseButton1Up:Connect(function()
            if not _p then return end _p=false
            On=not On UpdVisuals()
            task.spawn(function() pcall(cb,On) end)
            DoSync(syncKey,On,ctrl)
        end)
        UpdVisuals()

        function ctrl:Set(v) On=v==true UpdVisuals() end
        function ctrl:Get() return On end
        function ctrl:Toggle() On=not On UpdVisuals() DoSync(syncKey,On,ctrl) task.spawn(function() pcall(cb,On) end) end
        function ctrl:SetLabel(t) lbl.Text=tostring(t or "") end
        function ctrl:GetLabel() return lbl.Text end
        function ctrl:SetCallback(fn) cb=fn or function() end end
        function ctrl:SetVisible(v) f.Visible=v==true end
        function ctrl:GetVisible() return f.Visible end
        function ctrl:remove() f:Destroy() end
        RegSync(ctrl,syncKey) RegOption(ctrl,"Check")
        return ctrl
    end

    -- ────────────────────────────────
    -- addToggle  (switch  +  [?] keybind)
    -- ────────────────────────────────
    function S:addToggle(togglename, default, callback, keybind, syncKey)
        local cb  = callback or function() end
        local On  = default==true
        local CK  = keybind
        local Lis = false
        local trackW,trackH = 34,16
        local f   = Base(32)
        local ctrl={}

        local lbl = ni("TextLabel",{
            BackgroundTransparency=1, Position=UDim2.new(0,10,0,0),
            Size=UDim2.new(1,-70,1,0),
            Font=Enum.Font.GothamSemibold, Text=togglename or "Toggle",
            TextColor3=C.TEXT, TextSize=11,
            TextXAlignment=Enum.TextXAlignment.Left,
        }, f)

        local track = ni("Frame",{
            BorderSizePixel=0, AnchorPoint=Vector2.new(1,0.5),
            Position=UDim2.new(1,-10,0.5,0),
            Size=UDim2.new(0,trackW,0,trackH),
            BackgroundColor3=On and C.CHECK or C.OFF,
        }, f)
        Corner(track, trackH/2)
        local tStroke = MkStroke(track, On and C.CHECK or C.BORDER)

        local knob = ni("Frame",{
            BorderSizePixel=0, AnchorPoint=Vector2.new(0,0.5),
            Size=UDim2.new(0,trackH-6,0,trackH-6),
            Position=UDim2.new(0, On and (trackW-(trackH-6)-2) or 2, 0.5,0),
            BackgroundColor3=On and Color3.fromRGB(255,255,255) or C.DIM,
        }, track)
        ni("UICorner",{CornerRadius=UDim.new(1,0)}, knob)

        -- keybind [?]
        local kb, ks
        if keybind ~= nil then
            -- encolhe label para caber
            lbl.Size = UDim2.new(1,-112,1,0)

            kb = ni("TextButton",{
                BackgroundColor3=C.KEYBG, BorderSizePixel=0,
                AnchorPoint=Vector2.new(1,0.5),
                Size=UDim2.new(0,36,0,16),
                AutoButtonColor=false, Font=Enum.Font.GothamBold,
                Text=CK and "["..GetKeyName(CK).."]" or "[?]",
                TextColor3=C.DIM, TextSize=8,
            }, f)
            Corner(kb, 3) ks = MkStroke(kb, C.BORDER)

            -- reposiciona dinamicamente
            local function Repos()
                local szW = TextService:GetTextSize(kb.Text,8,Enum.Font.GothamBold,Vector2.new(1e4,1e4)).X
                local w = math.max(36, szW+12)
                kb.Size = UDim2.new(0,w,0,16)
                kb.Position = UDim2.new(1,-(trackW+10+w+4),0.5,0)
            end
            kb:GetPropertyChangedSignal("Text"):Connect(Repos) Repos()

            kb.MouseButton1Click:Connect(function()
                if Lis then return end
                Lis=true kb.Text="[...]"
                kb.TextColor3=C.ACCENT ks.Color=C.ACCENT Repos()
            end)
            UserInputService.InputBegan:Connect(function(inp,gp)
                if inp.UserInputType~=Enum.UserInputType.Keyboard then return end
                if Lis then
                    Lis=false
                    CK = inp.KeyCode~=Enum.KeyCode.Escape and inp.KeyCode or nil
                    kb.Text = CK and "["..GetKeyName(inp.KeyCode).."]" or "[?]"
                    kb.TextColor3=C.DIM ks.Color=C.BORDER Repos()
                    return
                end
                if not gp and CK and inp.KeyCode==CK then
                    On=not On UpdTog()
                    task.spawn(function() pcall(cb,On) end)
                    DoSync(syncKey,On,ctrl)
                end
            end)
        end

        function UpdTog()
            Tw(track,{BackgroundColor3=On and C.CHECK or C.OFF})
            tStroke.Color = On and C.CHECK or C.BORDER
            Tw(knob,{
                Position=UDim2.new(0, On and (trackW-(trackH-6)-2) or 2, 0.5,0),
                BackgroundColor3=On and Color3.fromRGB(255,255,255) or C.DIM,
            })
            Tw(lbl,{TextColor3=On and C.TEXT or C.DIM})
        end

        local hit = ni("TextButton",{
            BackgroundTransparency=1, Size=UDim2.new(1,0,1,0),
            AutoButtonColor=false, Text="", ZIndex=10,
        }, f)
        local _p=false
        hit.MouseEnter:Connect(function() Tw(f,{BackgroundColor3=C.HOVER}) end)
        hit.MouseLeave:Connect(function() _p=false Tw(f,{BackgroundColor3=C.ELEM}) end)
        hit.MouseButton1Down:Connect(function() if not Lis then _p=true end end)
        hit.MouseButton1Up:Connect(function()
            if not _p or Lis then _p=false return end _p=false
            On=not On UpdTog()
            task.spawn(function() pcall(cb,On) end)
            DoSync(syncKey,On,ctrl)
        end)
        UpdTog()

        function ctrl:Set(v) On=v==true UpdTog() end
        function ctrl:Get() return On end
        function ctrl:Toggle() On=not On UpdTog() DoSync(syncKey,On,ctrl) task.spawn(function() pcall(cb,On) end) end
        function ctrl:Update(v) On=v==true UpdTog() DoSync(syncKey,On,ctrl) task.spawn(function() pcall(cb,On) end) end
        function ctrl:SetLabel(t) lbl.Text=tostring(t or "") end
        function ctrl:GetLabel() return lbl.Text end
        function ctrl:SetCallback(fn) cb=fn or function() end end
        function ctrl:SetKey(k) CK=k if kb then kb.Text=k and "["..GetKeyName(k).."]" or "[?]" end end
        function ctrl:GetKey() return CK end
        function ctrl:SetVisible(v) f.Visible=v==true end
        function ctrl:GetVisible() return f.Visible end
        function ctrl:remove() f:Destroy() end
        RegSync(ctrl,syncKey) RegOption(ctrl,"Toggle")
        return ctrl
    end

    -- ────────────────────────────────
    -- addSlider
    -- ────────────────────────────────
    function S:addSlider(name, mn, mx, def, callback, iconName, syncKey)
        local cb=callback or function() end
        mn=tonumber(mn) or 0 mx=tonumber(mx) or 100
        local cur=math.clamp(tonumber(def) or mn,mn,mx)
        local f=Base(46)
        local ctrl={}

        if iconName then MkIcon(f,iconName,UDim2.new(0,13,0,13),8,0,C.ACCENT,0,0.5) end

        ni("TextLabel",{
            BackgroundTransparency=1, Position=UDim2.new(0,10,0,6),
            Size=UDim2.new(1,-60,0,14), Font=Enum.Font.GothamSemibold,
            Text=name or "Slider", TextColor3=C.TEXT, TextSize=11,
            TextXAlignment=Enum.TextXAlignment.Left,
        }, f)

        local vl = ni("TextLabel",{
            BackgroundTransparency=1, Position=UDim2.new(1,-54,0,6),
            Size=UDim2.new(0,44,0,14), Font=Enum.Font.GothamBold,
            Text=tostring(cur), TextColor3=C.ACCENT, TextSize=10,
            TextXAlignment=Enum.TextXAlignment.Right,
        }, f)

        local trackBg = ni("Frame",{
            BackgroundColor3=C.OFF, BorderSizePixel=0,
            Position=UDim2.new(0,10,0,28), Size=UDim2.new(1,-20,0,4),
        }, f)
        Corner(trackBg,2)

        local ratio=(cur-mn)/(mx-mn)
        local fillF = ni("Frame",{BackgroundColor3=C.ACCENT,BorderSizePixel=0,Size=UDim2.new(ratio,0,1,0)},trackBg)
        Corner(fillF,2)

        local knob = ni("Frame",{
            AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.new(ratio,0,0.5,0),
            Size=UDim2.fromOffset(11,11), BackgroundColor3=C.ACCENT,
            ZIndex=3, BorderSizePixel=0,
        }, trackBg)
        ni("UICorner",{CornerRadius=UDim.new(1,0)},knob)

        local hit=ni("TextButton",{
            BackgroundTransparency=1, Position=UDim2.new(0,0,0.5,-10),
            Size=UDim2.new(1,0,0,20), Text="", ZIndex=4,
        }, trackBg)

        local drag=false
        local function UpdS(px)
            local p=math.clamp((px-trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X,0,1)
            cur=math.floor(mn+(mx-mn)*p)
            fillF.Size=UDim2.new(p,0,1,0) knob.Position=UDim2.new(p,0,0.5,0)
            vl.Text=tostring(cur)
            task.spawn(function() pcall(cb,cur) end) DoSync(syncKey,cur,ctrl)
        end
        hit.MouseButton1Down:Connect(function() drag=true UpdS(UserInputService:GetMouseLocation().X) end)
        UserInputService.InputChanged:Connect(function(i)
            if drag and i.UserInputType==Enum.UserInputType.MouseMovement then UpdS(i.Position.X) end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
        end)
        f.MouseEnter:Connect(function() Tw(f,{BackgroundColor3=C.HOVER}) end)
        f.MouseLeave:Connect(function() Tw(f,{BackgroundColor3=C.ELEM}) end)

        function ctrl:Set(v)
            cur=math.clamp(tonumber(v) or mn,mn,mx)
            local p=(cur-mn)/(mx-mn)
            fillF.Size=UDim2.new(p,0,1,0) knob.Position=UDim2.new(p,0,0.5,0)
            vl.Text=tostring(cur)
        end
        function ctrl:Get() return cur end
        function ctrl:Update(v) ctrl:Set(v) DoSync(syncKey,cur,ctrl) task.spawn(function() pcall(cb,cur) end) end
        function ctrl:SetCallback(fn) cb=fn or function() end end
        function ctrl:SetVisible(v) f.Visible=v==true end
        function ctrl:GetVisible() return f.Visible end
        function ctrl:remove() f:Destroy() end
        RegSync(ctrl,syncKey) RegOption(ctrl,"Slider")
        return ctrl
    end

    -- ────────────────────────────────
    -- addTextBox  (+ optional checkbox)
    -- ────────────────────────────────
    function S:addTextBox(name, placeholder, callback, iconName, withCheck, checkDefault, checkCallback, syncKey)
        local cb=callback or function() end
        local chkCb=checkCallback or function() end
        local hasChk=withCheck==true
        local chkOn=hasChk and (checkDefault==true) or false
        local f=Base(hasChk and 56 or 52)
        f.AutomaticSize=Enum.AutomaticSize.None
        local ctrl={}

        local padL=10
        if iconName then
            local ic=MkIcon(f,iconName,UDim2.new(0,13,0,13),8,0,C.DIM,0,0.5)
            if ic then ic.Position=UDim2.new(0,8,0,8) ic.AnchorPoint=Vector2.new(0,0) padL=26 end
        end

        ni("TextLabel",{
            BackgroundTransparency=1, Position=UDim2.new(0,padL,0,7),
            Size=UDim2.new(1,-(padL+10),0,14), Font=Enum.Font.GothamSemibold,
            Text=name or "TextBox", TextColor3=C.TEXT, TextSize=11,
            TextXAlignment=Enum.TextXAlignment.Left,
        }, f)

        local ibg=ni("Frame",{
            BackgroundColor3=C.OFF, BorderSizePixel=0,
            Position=UDim2.new(0,8,0,25), Size=UDim2.new(1,hasChk and -50 or -16,0,20),
        }, f)
        Corner(ibg,SQ) local iStr=MkStroke(ibg,C.BORDER)

        local inp=ni("TextBox",{
            BackgroundTransparency=1, BorderSizePixel=0,
            Position=UDim2.new(0,6,0,0), Size=UDim2.new(1,-12,1,0),
            Font=Enum.Font.GothamSemibold, PlaceholderText=placeholder or "",
            PlaceholderColor3=C.DIM, Text="", TextColor3=C.TEXT,
            TextSize=10, ClearTextOnFocus=false,
        }, ibg)

        inp.Focused:Connect(function() Tw(ibg,{BackgroundColor3=C.ACTIVE}) iStr.Color=C.ACCENT end)
        inp.FocusLost:Connect(function()
            Tw(ibg,{BackgroundColor3=C.OFF}) iStr.Color=C.BORDER
            task.spawn(function() pcall(cb,inp.Text) end) DoSync(syncKey,inp.Text,ctrl)
        end)
        f.MouseEnter:Connect(function() Tw(f,{BackgroundColor3=C.HOVER}) end)
        f.MouseLeave:Connect(function() if not inp:IsFocused() then Tw(f,{BackgroundColor3=C.ELEM}) end end)

        -- opcional: checkbox
        if hasChk then
            local chkBox=ni("Frame",{
                BackgroundColor3=chkOn and C.CHECK or C.OFF, BorderSizePixel=0,
                AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-8,0,25),
                Size=UDim2.new(0,22,0,20),
            }, f)
            Corner(chkBox,SQ) local cStr=MkStroke(chkBox,chkOn and C.CHECK or C.BORDER)
            local cFill=ni("Frame",{
                AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=C.CHECK,
                BackgroundTransparency=chkOn and 0 or 1, BorderSizePixel=0,
                Position=UDim2.new(0.5,0,0.5,0), Size=chkOn and UDim2.new(1,0,1,0) or UDim2.new(0,0,0,0),
            }, chkBox) Corner(cFill,SQ)
            local cImg=MkCheckIcon(chkBox) cImg.ImageTransparency=chkOn and 0 or 1

            local ch2=ni("TextButton",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Text="",ZIndex=6},chkBox)
            ch2.MouseButton1Click:Connect(function()
                chkOn=not chkOn
                Tw(chkBox,{BackgroundColor3=chkOn and C.CHECK or C.OFF})
                Tw(cFill,{BackgroundTransparency=chkOn and 0 or 1,
                           Size=chkOn and UDim2.new(1,0,1,0) or UDim2.new(0,0,0,0)})
                Tw(cImg,{ImageTransparency=chkOn and 0 or 1})
                cStr.Color=chkOn and C.CHECK or C.BORDER
                task.spawn(function() pcall(chkCb,chkOn) end)
            end)
            function ctrl:GetCheck() return chkOn end
        end

        function ctrl:Get() return tostring(inp.Text) end
        function ctrl:Set(v) inp.Text=tostring(v or "") end
        function ctrl:Update(v) inp.Text=tostring(v or "") DoSync(syncKey,inp.Text,ctrl) task.spawn(function() pcall(cb,inp.Text) end) end
        function ctrl:Clear() inp.Text="" end
        function ctrl:Focus() inp:CaptureFocus() end
        function ctrl:Blur() inp:ReleaseFocus() end
        function ctrl:SetCallback(fn) cb=fn or function() end end
        function ctrl:SetVisible(v) f.Visible=v==true end
        function ctrl:GetVisible() return f.Visible end
        function ctrl:remove() f:Destroy() end
        RegSync(ctrl,syncKey) RegOption(ctrl,"TextBox")
        return ctrl
    end

    -- ────────────────────────────────
    -- addDropdown
    -- ────────────────────────────────
    function S:addDropdown(name, list, callback, iconName, syncKey)
        local cb=callback or function() end
        local Selected=nil local Open=false
        local ctrl={}

        elemCount=elemCount+1
        local Wrapper=ni("Frame",{
            Size=UDim2.new(1,0,0,32), BackgroundTransparency=1,
            BorderSizePixel=0, LayoutOrder=elemCount, ClipsDescendants=false, ZIndex=10,
        }, Content)
        if elemCount>1 then
            ni("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=C.SEP,BorderSizePixel=0,ZIndex=2},Wrapper)
        end

        local Hdr=ni("Frame",{
            Size=UDim2.new(1,0,0,32), BackgroundColor3=C.ELEM, BorderSizePixel=0, ZIndex=10,
        }, Wrapper)
        Corner(Hdr,SQ) MkStroke(Hdr,C.BORDER)

        local leftOff=12
        if iconName then
            local ic=MkIcon(Hdr,iconName,UDim2.new(0,13,0,13),10,0,C.DIM,0,0.5)
            if ic then ic.ZIndex=11 leftOff=30 end
        end
        ni("TextLabel",{
            BackgroundTransparency=1, Position=UDim2.new(0,leftOff,0,0),
            Size=UDim2.new(0.52,-leftOff,1,0), Font=Enum.Font.GothamSemibold,
            Text=name or "Dropdown", TextColor3=C.TEXT, TextSize=11,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=11,
        }, Hdr)
        local ds=ni("TextLabel",{
            BackgroundTransparency=1, Position=UDim2.new(0.52,0,0,0),
            Size=UDim2.new(0.48,-26,1,0), Font=Enum.Font.Gotham,
            Text="none", TextColor3=C.DIM, TextSize=10,
            TextXAlignment=Enum.TextXAlignment.Right, ZIndex=11,
        }, Hdr)
        local da=ni("ImageLabel",{
            BackgroundTransparency=1, Image="rbxassetid://10709790948",
            ImageColor3=C.ACCENT, Size=UDim2.new(0,11,0,11),
            AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-9,0.5,0),
            ScaleType=Enum.ScaleType.Fit, ZIndex=11,
        }, Hdr)

        local tH=math.min(#list*26+10,130)
        local DL=ni("Frame",{
            BackgroundColor3=C.DDBG, BorderSizePixel=0,
            Position=UDim2.new(0,0,0,34), Size=UDim2.new(1,0,0,0),
            ZIndex=50, ClipsDescendants=true, Visible=false,
        }, Wrapper)
        Corner(DL,SQ) MkStroke(DL,C.DDBDR)

        local scroll=ni("ScrollingFrame",{
            BackgroundTransparency=1, BorderSizePixel=0, Size=UDim2.new(1,0,1,0),
            ScrollBarThickness=2, ScrollBarImageColor3=C.ACCENT,
            ZIndex=51, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
        }, DL)
        ni("UIListLayout",{Parent=scroll,Padding=UDim.new(0,2)})
        ni("UIPadding",{Parent=scroll,PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),
            PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4)})

        local function CloseDD()
            Open=false Tw(da,{Rotation=0})
            Tw(DL,{Size=UDim2.new(1,0,0,0)})
            task.delay(0.15,function() DL.Visible=false Wrapper.Size=UDim2.new(1,0,0,32) end)
        end
        local function OpenDD()
            Open=true Tw(da,{Rotation=180})
            DL.Visible=true Tw(DL,{Size=UDim2.new(1,0,0,tH)})
            Wrapper.Size=UDim2.new(1,0,0,34+tH)
        end

        local function BuildItems(itemList)
            for _,c in ipairs(scroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
            tH=math.min(#itemList*26+10,130)
            for _,item in ipairs(itemList) do
                local opt=ni("TextButton",{
                    BackgroundColor3=C.ELEM, BorderSizePixel=0, Size=UDim2.new(1,0,0,22),
                    AutoButtonColor=false, Font=Enum.Font.GothamSemibold,
                    Text=tostring(item), TextColor3=item==Selected and C.ACCENT or C.DIM,
                    TextSize=10, ZIndex=52,
                }, scroll)
                Corner(opt,SQ)
                opt.MouseEnter:Connect(function() Tw(opt,{BackgroundColor3=C.BTNHOV}) end)
                opt.MouseLeave:Connect(function()
                    Tw(opt,{BackgroundColor3=C.ELEM})
                    opt.TextColor3=item==Selected and C.ACCENT or C.DIM
                end)
                opt.MouseButton1Click:Connect(function()
                    Selected=item ds.Text=tostring(item) ds.TextColor3=C.ACCENT
                    CloseDD()
                    task.spawn(function() pcall(cb,item) end) DoSync(syncKey,item,ctrl)
                end)
            end
        end
        BuildItems(list)

        local hb=ni("TextButton",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,32),Text="",ZIndex=12},Wrapper)
        hb.MouseButton1Click:Connect(function() if Open then CloseDD() else OpenDD() end end)
        hb.MouseEnter:Connect(function() Tw(Hdr,{BackgroundColor3=C.HOVER}) end)
        hb.MouseLeave:Connect(function() Tw(Hdr,{BackgroundColor3=C.ELEM}) end)

        function ctrl:Set(v) Selected=v ds.Text=v and tostring(v) or "none" ds.TextColor3=v and C.ACCENT or C.DIM end
        function ctrl:Get() return Selected end
        function ctrl:Clear() ctrl:Set(nil) end
        function ctrl:SetList(nl) BuildItems(nl) end
        function ctrl:Update(v) ctrl:Set(v) DoSync(syncKey,v,ctrl) task.spawn(function() pcall(cb,v) end) end
        function ctrl:SetCallback(fn) cb=fn or function() end end
        function ctrl:SetVisible(v) Wrapper.Visible=v==true end
        function ctrl:GetVisible() return Wrapper.Visible end
        function ctrl:Open() OpenDD() end
        function ctrl:Close() CloseDD() end
        function ctrl:remove() Wrapper:Destroy() end
        RegSync(ctrl,syncKey) RegOption(ctrl,"Dropdown")
        return ctrl
    end

    -- ────────────────────────────────
    -- addKeybind  (standalone)
    -- ────────────────────────────────
    function S:addKeybind(name, default, callback, syncKey)
        local cb=callback or function() end
        local CK=default local Lis=false
        local f=Base(32) local ctrl={}

        ni("TextLabel",{
            BackgroundTransparency=1, Position=UDim2.new(0,10,0,0),
            Size=UDim2.new(0.6,0,1,0), Font=Enum.Font.GothamSemibold,
            Text=name or "Keybind", TextColor3=C.TEXT, TextSize=11,
            TextXAlignment=Enum.TextXAlignment.Left,
        }, f)

        local kb=ni("TextButton",{
            BackgroundColor3=C.KEYBG, BorderSizePixel=0,
            AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-8,0.5,0),
            Size=UDim2.new(0,68,0,18), AutoButtonColor=false,
            Font=Enum.Font.GothamBold,
            Text=CK and "["..GetKeyName(CK).."]" or "[NONE]",
            TextColor3=C.DIM, TextSize=9,
        }, f)
        Corner(kb,SQ) local ks=MkStroke(kb,C.BORDER)

        local function Resize()
            local sz=TextService:GetTextSize(kb.Text,9,Enum.Font.GothamBold,Vector2.new(1e4,1e4))
            Tw(kb,{Size=UDim2.new(0,math.max(68,sz.X+16),0,18)},TI.Key)
        end
        kb:GetPropertyChangedSignal("Text"):Connect(Resize) Resize()

        kb.MouseButton1Click:Connect(function()
            if Lis then return end Lis=true
            kb.Text="[...]" kb.TextColor3=C.ACCENT ks.Color=C.ACCENT Resize()
        end)
        UserInputService.InputBegan:Connect(function(inp,gp)
            if inp.UserInputType~=Enum.UserInputType.Keyboard then return end
            if Lis then
                Lis=false CK=inp.KeyCode~=Enum.KeyCode.Escape and inp.KeyCode or nil
                kb.Text=CK and "["..GetKeyName(inp.KeyCode).."]" or "[NONE]"
                kb.TextColor3=C.DIM ks.Color=C.BORDER Resize()
                DoSync(syncKey,CK,ctrl) return
            end
            if not gp and CK and inp.KeyCode==CK then
                task.spawn(function() pcall(cb,CK) end)
            end
        end)
        f.MouseEnter:Connect(function() Tw(f,{BackgroundColor3=C.HOVER}) end)
        f.MouseLeave:Connect(function() Tw(f,{BackgroundColor3=C.ELEM}) end)

        function ctrl:Set(k) CK=k kb.Text=k and "["..GetKeyName(k).."]" or "[NONE]" Resize() end
        function ctrl:Get() return CK end
        function ctrl:Clear() CK=nil kb.Text="[NONE]" Resize() end
        function ctrl:Update(k) ctrl:Set(k) DoSync(syncKey,k,ctrl) task.spawn(function() pcall(cb,CK) end) end
        function ctrl:SetCallback(fn) cb=fn or function() end end
        function ctrl:SetVisible(v) f.Visible=v==true end
        function ctrl:GetVisible() return f.Visible end
        function ctrl:remove() f:Destroy() end
        RegSync(ctrl,syncKey) RegOption(ctrl,"Keybind")
        return ctrl
    end

    -- ────────────────────────────────
    -- addColorPicker
    -- ────────────────────────────────
    function S:addColorPicker(name, default, callback, syncKey)
        local cb=callback or function() end
        local CurColor=typeof(default)=="Color3" and default or Color3.fromRGB(255,255,255)
        local H,Sat,V=Color3.toHSV(CurColor)
        local Open=false local ctrl={}

        local function ToHex(c)
            return string.format("#%02X%02X%02X",math.floor(c.R*255),math.floor(c.G*255),math.floor(c.B*255))
        end

        elemCount=elemCount+1
        local Wrapper=ni("Frame",{
            Size=UDim2.new(1,0,0,32), BackgroundTransparency=1,
            BorderSizePixel=0, LayoutOrder=elemCount, ClipsDescendants=false, ZIndex=10,
        }, Content)
        if elemCount>1 then
            ni("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=C.SEP,BorderSizePixel=0,ZIndex=2},Wrapper)
        end

        local Hdr=ni("Frame",{Size=UDim2.new(1,0,0,32),BackgroundColor3=C.ELEM,BorderSizePixel=0,ZIndex=10},Wrapper)
        Corner(Hdr,SQ) MkStroke(Hdr,C.BORDER)

        local pico=MkIcon(Hdr,"palette",UDim2.new(0,13,0,13),10,0,C.DIM,0,0.5)
        if pico then pico.ZIndex=11 end

        ni("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,30,0,0),
            Size=UDim2.new(0.5,-30,1,0),Font=Enum.Font.GothamSemibold,
            Text=name or "Color",TextColor3=C.TEXT,TextSize=11,
            TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11},Hdr)

        local hexL=ni("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0.5,0,0,0),
            Size=UDim2.new(0.5,-36,1,0),Font=Enum.Font.GothamBold,
            Text=ToHex(CurColor),TextColor3=C.DIM,TextSize=10,
            TextXAlignment=Enum.TextXAlignment.Right,ZIndex=11},Hdr)

        local prev=ni("Frame",{BackgroundColor3=CurColor,BorderSizePixel=0,
            AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,0.5,0),
            Size=UDim2.new(0,15,0,15),ZIndex=11},Hdr)
        Corner(prev,SQ) MkStroke(prev,C.BORDER)

        local Panel=ni("Frame",{BackgroundColor3=C.DDBG,BorderSizePixel=0,
            Position=UDim2.new(0,0,0,34),Size=UDim2.new(1,0,0,0),
            ClipsDescendants=true,Visible=false,ZIndex=50},Wrapper)
        Corner(Panel,SQ) MkStroke(Panel,C.DDBDR)

        local function Refresh()
            CurColor=Color3.fromHSV(H,Sat,V)
            prev.BackgroundColor3=CurColor hexL.Text=ToHex(CurColor)
            task.spawn(function() pcall(cb,CurColor) end) DoSync(syncKey,CurColor,ctrl)
        end

        local chs={{l="H",g=function()return H end,s=function(v)H=v end,m=360},
                   {l="S",g=function()return Sat end,s=function(v)Sat=v end,m=100},
                   {l="V",g=function()return V end,s=function(v)V=v end,m=100}}
        local panelH=#chs*30+12

        for i,ch in ipairs(chs) do
            local row=ni("Frame",{BackgroundTransparency=1,BorderSizePixel=0,
                Position=UDim2.new(0,10,0,8+(i-1)*30),Size=UDim2.new(1,-20,0,24),ZIndex=51},Panel)
            ni("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(0,14,1,0),
                Font=Enum.Font.GothamBold,Text=ch.l,TextColor3=C.ACCENT,TextSize=10,ZIndex=52},row)
            local rt=ni("Frame",{BackgroundColor3=C.OFF,BorderSizePixel=0,
                Position=UDim2.new(0,20,0.5,-2),Size=UDim2.new(1,-58,0,4),ZIndex=51},row)
            Corner(rt,2)
            local rf=ni("Frame",{BackgroundColor3=C.ACCENT,BorderSizePixel=0,
                Size=UDim2.new(ch.g(),0,1,0),ZIndex=52},rt) Corner(rf,2)
            local rdot=ni("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(ch.g(),0,0.5,0),
                Size=UDim2.fromOffset(11,11),BackgroundColor3=C.ACCENT,ZIndex=53,BorderSizePixel=0},rt)
            ni("UICorner",{CornerRadius=UDim.new(1,0)},rdot)
            ni("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(1,-36,0,0),
                Size=UDim2.new(0,34,1,0),Font=Enum.Font.GothamBold,
                Text=tostring(math.floor(ch.g()*ch.m)),TextColor3=C.DIM,TextSize=9,ZIndex=52},row)
            local rth=ni("TextButton",{BackgroundTransparency=1,Position=UDim2.new(0,20,0.5,-9),
                Size=UDim2.new(1,-58,0,20),Text="",ZIndex=54},row)
            local dr=false
            local function UpdX(px)
                local p=math.clamp((px-rt.AbsolutePosition.X)/rt.AbsoluteSize.X,0,1)
                rf.Size=UDim2.new(p,0,1,0) rdot.Position=UDim2.new(p,0,0.5,0) ch.s(p) Refresh()
            end
            rth.MouseButton1Down:Connect(function() dr=true UpdX(UserInputService:GetMouseLocation().X) end)
            UserInputService.InputChanged:Connect(function(inp)
                if dr and inp.UserInputType==Enum.UserInputType.MouseMovement then UpdX(inp.Position.X) end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 then dr=false end
            end)
        end

        local hb=ni("TextButton",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,32),Text="",
            AutoButtonColor=false,ZIndex=12},Wrapper)
        hb.MouseEnter:Connect(function() Tw(Hdr,{BackgroundColor3=C.HOVER}) end)
        hb.MouseLeave:Connect(function() Tw(Hdr,{BackgroundColor3=C.ELEM}) end)
        hb.MouseButton1Click:Connect(function()
            Open=not Open
            if Open then
                Panel.Visible=true Tw(Panel,{Size=UDim2.new(1,0,0,panelH)},TI.Med)
                Wrapper.Size=UDim2.new(1,0,0,34+panelH)
            else
                Tw(Panel,{Size=UDim2.new(1,0,0,0)},TI.Med)
                task.delay(0.18,function() Panel.Visible=false Wrapper.Size=UDim2.new(1,0,0,32) end)
            end
        end)

        function ctrl:Set(c)
            if typeof(c)~="Color3" then return end
            CurColor=c H,Sat,V=Color3.toHSV(c)
            prev.BackgroundColor3=c hexL.Text=ToHex(c)
        end
        function ctrl:Get() return CurColor end
        function ctrl:GetHex() return ToHex(CurColor) end
        function ctrl:Update(c) ctrl:Set(c) DoSync(syncKey,c,ctrl) task.spawn(function() pcall(cb,CurColor) end) end
        function ctrl:SetCallback(fn) cb=fn or function() end end
        function ctrl:SetVisible(v) Wrapper.Visible=v==true end
        function ctrl:GetVisible() return Wrapper.Visible end
        function ctrl:remove() Wrapper:Destroy() end
        RegSync(ctrl,syncKey) RegOption(ctrl,"ColorPicker")
        return ctrl
    end

    function S:remove() Outer:Destroy() end
    return S
end

-- ──────────────────────────────────────────────────────────────
-- CreateWindow
-- ──────────────────────────────────────────────────────────────
function Library:CreateWindow(windowname, windowinfo, folder)
    folder = folder or "ecohub"
    local ConfigFolder  = folder
    local ConfigCfgPath = folder.."/configs"

    local function EnsureFolders()
        pcall(function()
            if not SafeIsDir(ConfigFolder)  then SafeFolder(ConfigFolder)  end
            if not SafeIsDir(ConfigCfgPath) then SafeFolder(ConfigCfgPath) end
        end)
    end
    EnsureFolders()

    local function GetConfigList()
        local out={}
        for _,file in ipairs(SafeList(ConfigCfgPath)) do
            if file:sub(-5)==".json" then
                local n=file:match("[/\\]([^/\\]+)%.json$")
                if n and n~="autoload" then table.insert(out,n) end
            end
        end
        table.sort(out) return out
    end

    local SaveIgnore={}

    local function SaveConfig(name)
        if not name or name:gsub(" ","")=="" then return false,"empty name" end
        local data={objects={}}
        for idx,opt in next,Library.Options do
            if SaveIgnore[idx] then continue end
            local ok,v=pcall(function() return opt:Get() end)
            if not ok then continue end
            local t=opt.Type
            if t=="Check" or t=="Toggle" then
                table.insert(data.objects,{type=t,idx=idx,value=v})
            elseif t=="Slider" then
                table.insert(data.objects,{type="Slider",idx=idx,value=v})
            elseif t=="Dropdown" then
                table.insert(data.objects,{type="Dropdown",idx=idx,value=v})
            elseif t=="TextBox" then
                table.insert(data.objects,{type="TextBox",idx=idx,value=v})
            elseif t=="ColorPicker" and typeof(v)=="Color3" then
                table.insert(data.objects,{type="ColorPicker",idx=idx,
                    value=string.format("%02X%02X%02X",
                        math.floor(v.R*255),math.floor(v.G*255),math.floor(v.B*255))})
            elseif t=="Keybind" and v then
                table.insert(data.objects,{type="Keybind",idx=idx,value=v.Name})
            end
        end
        local ok2,enc=pcall(function() return HttpService:JSONEncode(data) end)
        if not ok2 then return false,"encode failed" end
        return SafeWrite(ConfigCfgPath.."/"..name..".json",enc) and true or (false,"write failed")
    end

    local function LoadConfig(name)
        if not name then return false,"no name" end
        local content=SafeRead(ConfigCfgPath.."/"..name..".json")
        if not content then return false,"file not found" end
        local ok2,dec=pcall(function() return HttpService:JSONDecode(content) end)
        if not ok2 then return false,"decode failed" end
        for _,obj in ipairs(dec.objects or {}) do
            task.spawn(function()
                local opt=Library.Options[obj.idx] if not opt then return end
                if obj.type=="Check" or obj.type=="Toggle" then
                    opt:Set(obj.value==true or obj.value=="true")
                elseif obj.type=="Slider" then opt:Set(tonumber(obj.value) or 0)
                elseif obj.type=="Dropdown" then opt:Set(obj.value)
                elseif obj.type=="TextBox" then opt:Set(tostring(obj.value))
                elseif obj.type=="ColorPicker" and type(obj.value)=="string" and #obj.value==6 then
                    local ok3,c=pcall(function() return Color3.fromRGB(
                        tonumber("0x"..obj.value:sub(1,2)),
                        tonumber("0x"..obj.value:sub(3,4)),
                        tonumber("0x"..obj.value:sub(5,6))) end)
                    if ok3 then opt:Set(c) end
                elseif obj.type=="Keybind" and obj.value then
                    local ok3,k=pcall(function() return Enum.KeyCode[obj.value] end)
                    if ok3 and k then opt:Set(k) end
                end
            end)
        end
        return true
    end

    -- destroy old gui
    pcall(function()
        local g=game:GetService("CoreGui"):FindFirstChild("ecohub_gui")
        if g then g:Destroy() end
    end)
    task.wait(0.05)

    -- ── GUI root ──
    local ScreenGui=ni("ScreenGui",{
        Name="ecohub_gui", Parent=game:GetService("CoreGui"),
        ZIndexBehavior=Enum.ZIndexBehavior.Global,
        ResetOnSpawn=false, DisplayOrder=999,
    })

    local WINDOW_W,WINDOW_H=550,350
    local Main=ni("Frame",{
        Name="Main", Parent=ScreenGui,
        BackgroundColor3=C.BG, BorderSizePixel=0,
        Position=UDim2.new(0.5,-WINDOW_W/2,0.5,-WINDOW_H/2),
        Size=UDim2.new(0,WINDOW_W,0,WINDOW_H),
        ClipsDescendants=true,
    })
    Corner(Main,SQ+1) MkStroke(Main,C.BORDER,1)

    -- ── TitleBar ──
    local TitleBar=ni("Frame",{
        Parent=Main, BackgroundColor3=C.SIDE, BorderSizePixel=0,
        Size=UDim2.new(1,0,0,38), ZIndex=2, ClipsDescendants=false,
    })
    Corner(TitleBar,SQ+1)
    ni("Frame",{Parent=TitleBar,BackgroundColor3=C.SIDE,BorderSizePixel=0,
        Position=UDim2.new(0,0,0.5,0),Size=UDim2.new(1,0,0.5,0),ZIndex=2})
    ni("TextLabel",{Parent=TitleBar,BackgroundTransparency=1,
        Position=UDim2.new(0,14,0,0),Size=UDim2.new(0.65,0,1,0),
        Font=Enum.Font.GothamBold,Text=windowname or "ecohub",
        TextColor3=C.TEXT,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5})
    ni("TextLabel",{Parent=TitleBar,BackgroundTransparency=1,
        Size=UDim2.new(1,-50,1,0),Font=Enum.Font.Gotham,
        Text=windowinfo or "v1.0",TextColor3=C.DIM,TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Right,ZIndex=5})

    -- minimize button
    local MinBtn=ni("TextButton",{Parent=TitleBar,BackgroundColor3=C.ELEM,BorderSizePixel=0,
        AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,0.5,0),
        Size=UDim2.new(0,22,0,22),AutoButtonColor=false,Text="",ZIndex=6})
    Corner(MinBtn,SQ) MkStroke(MinBtn,C.BORDER)
    local MinIco=MkIcon(MinBtn,"minimize",UDim2.new(0,12,0,12),0,0,C.DIM,0.5,0.5)
    if MinIco then MinIco.Position=UDim2.new(0.5,0,0.5,0) MinIco.ZIndex=7 end
    MinBtn.MouseEnter:Connect(function()
        Tw(MinBtn,{BackgroundColor3=C.HOVER}) if MinIco then Tw(MinIco,{ImageColor3=C.ACCENT}) end
    end)
    MinBtn.MouseLeave:Connect(function()
        Tw(MinBtn,{BackgroundColor3=C.ELEM}) if MinIco then Tw(MinIco,{ImageColor3=C.DIM}) end
    end)

    ni("Frame",{Parent=TitleBar,BackgroundColor3=C.SEP,BorderSizePixel=0,
        AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,1,0),Size=UDim2.new(1,0,0,1),ZIndex=3})

    -- ── Body ──
    local Body=ni("Frame",{Parent=Main,BackgroundTransparency=1,BorderSizePixel=0,
        Position=UDim2.new(0,0,0,38),Size=UDim2.new(1,0,1,-38),ClipsDescendants=true})

    -- Sidebar
    local Sidebar=ni("Frame",{Parent=Body,BackgroundColor3=C.SIDE,BorderSizePixel=0,
        Size=UDim2.new(0,140,1,0),ClipsDescendants=true})
    ni("Frame",{Parent=Body,BackgroundColor3=C.SEP,BorderSizePixel=0,
        Position=UDim2.new(0,140,0,0),Size=UDim2.new(0,1,1,0),ZIndex=3})

    -- logo
    local BRAND_IMAGE="rbxassetid://112537363055720"
    local LogoImg=ni("ImageLabel",{Parent=Sidebar,BackgroundTransparency=1,Image=BRAND_IMAGE,
        Size=UDim2.new(0,110,0,110),AnchorPoint=Vector2.new(0.5,0),
        Position=UDim2.new(0.5,0,0,10),ScaleType=Enum.ScaleType.Fit,ZIndex=2})
    ni("Frame",{Parent=Sidebar,BackgroundColor3=C.SEP,BorderSizePixel=0,
        Position=UDim2.new(0,8,0,126),Size=UDim2.new(1,-16,0,1)})

    -- tab scroll
    local TabScroll=ni("ScrollingFrame",{Parent=Sidebar,BackgroundTransparency=1,BorderSizePixel=0,
        Position=UDim2.new(0,6,0,134),Size=UDim2.new(1,-12,1,-172),
        ScrollBarThickness=2,ScrollBarImageColor3=C.ACCENT,
        CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ClipsDescendants=true})
    ni("UIListLayout",{Parent=TabScroll,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2)})

    -- settings btn
    ni("Frame",{Parent=Sidebar,BackgroundColor3=C.SEP,BorderSizePixel=0,
        AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,8,1,-38),Size=UDim2.new(1,-16,0,1)})
    local SettingsBtn=ni("TextButton",{Parent=Sidebar,BackgroundColor3=C.ELEM,
        BackgroundTransparency=1,BorderSizePixel=0,
        AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,6,1,-6),
        Size=UDim2.new(1,-12,0,28),AutoButtonColor=false,Text="",ClipsDescendants=true})
    Corner(SettingsBtn,SQ)
    local SInd=ni("Frame",{Parent=SettingsBtn,BackgroundColor3=C.TABLINE,BorderSizePixel=0,
        AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.new(0,2,0,0)})
    Corner(SInd,1)
    local SHL=ni("Frame",{Parent=SettingsBtn,BackgroundColor3=C.TABLINE,BackgroundTransparency=1,
        BorderSizePixel=0,Size=UDim2.new(1,0,1,0)}) Corner(SHL,SQ)
    local SIco=ni("ImageLabel",{Parent=SettingsBtn,BackgroundTransparency=1,
        Image=GetIconId("settings") or "",ImageColor3=C.DIM,
        Size=UDim2.new(0,14,0,14),Position=UDim2.new(0,10,0.5,0),
        AnchorPoint=Vector2.new(0,0.5),ScaleType=Enum.ScaleType.Fit})
    ni("TextLabel",{Parent=SettingsBtn,BackgroundTransparency=1,
        Position=UDim2.new(0,28,0,0),Size=UDim2.new(1,-34,1,0),
        Font=Enum.Font.GothamSemibold,Text="Settings",TextColor3=C.DIM,
        TextSize=12,TextXAlignment=Enum.TextXAlignment.Left})

    -- ContentArea
    local ContentArea=ni("Frame",{Parent=Body,BackgroundTransparency=1,BorderSizePixel=0,
        Position=UDim2.new(0,146,0,5),Size=UDim2.new(1,-151,1,-10),ClipsDescendants=true})

    -- SettingsPage
    local SettingsPage=ni("Frame",{Parent=ContentArea,BackgroundTransparency=1,
        BorderSizePixel=0,Size=UDim2.new(1,0,1,0),Visible=false,ClipsDescendants=false})
    local SettingsScroll=ni("ScrollingFrame",{Parent=SettingsPage,BackgroundTransparency=1,
        BorderSizePixel=0,Size=UDim2.new(1,0,1,0),ScrollBarThickness=2,
        ScrollBarImageColor3=C.ACCENT,CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y})
    ni("UIListLayout",{Parent=SettingsScroll,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6)})
    ni("UIPadding",{Parent=SettingsScroll,PaddingTop=UDim.new(0,2),PaddingBottom=UDim.new(0,6),PaddingRight=UDim.new(0,2)})

    -- ── Settings sections ──
    local cfgSec=BuildSection("Configs",SettingsScroll)
    local cfgNameCtrl=cfgSec:addTextBox("Config name","my_config",nil)
    local cfgListCtrl=cfgSec:addDropdown("Saved configs",GetConfigList(),nil,"folder-open")
    cfgSec:addSeparator()
    cfgSec:addButton("Save config",function()
        local n=cfgNameCtrl:Get()
        if not n or n:gsub(" ","")=="" then return end
        local ok=SaveConfig(n)
        if ok then cfgListCtrl:SetList(GetConfigList()) cfgListCtrl:Set(n) end
    end,"save")
    cfgSec:addButton("Load config",function()
        local n=cfgListCtrl:Get() if not n then return end
        local ok=LoadConfig(n) if ok then cfgNameCtrl:Set(n) end
    end,"download")
    cfgSec:addButton("Overwrite config",function()
        local n=cfgListCtrl:Get() if not n then return end SaveConfig(n)
    end,"edit-2")
    cfgSec:addButton("Delete config",function()
        local n=cfgListCtrl:Get() if not n then return end
        SafeDel(ConfigCfgPath.."/"..n..".json")
        cfgListCtrl:SetList(GetConfigList()) cfgListCtrl:Set(nil)
    end,"trash-2")
    cfgSec:addButton("Refresh list",function()
        cfgListCtrl:SetList(GetConfigList())
    end,"refresh-cw")

    local AutoSaveEnabled=false local AutoLoadEnabled=true

    local autoSaveSec=BuildSection("Auto-Save",SettingsScroll)
    local autoSaveCtrl=autoSaveSec:addToggle("Enable auto-save",false,function(v) AutoSaveEnabled=v end)
    autoSaveSec:addParagraph("How it works","Saves automatically whenever any option changes.")

    local autoLoadSec=BuildSection("Auto-Load",SettingsScroll)
    local autoLoadCtrl=autoLoadSec:addToggle("Enable auto-load",true,function(v) AutoLoadEnabled=v end)
    autoLoadSec:addButton("Set as autoload",function()
        local n=cfgListCtrl:Get() if not n then return end
        SafeWrite(ConfigCfgPath.."/autoload.txt",n)
    end,"star")
    autoLoadSec:addButton("Load autoload now",function()
        local fc=SafeRead(ConfigCfgPath.."/autoload.txt")
        if not fc or fc:gsub("%s","")=="" then return end
        local nm=fc:gsub("%s","")
        local ok=LoadConfig(nm)
        if ok then cfgListCtrl:Set(nm) cfgNameCtrl:Set(nm) end
    end,"download")
    autoLoadSec:addButton("Remove autoload",function()
        SafeDel(ConfigCfgPath.."/autoload.txt")
    end,"x-circle")
    autoLoadSec:addParagraph("How it works","Marked config loads automatically 2 s after script start.")

    -- Sistema section (igual ao código externo)
    local function detectExecutor()
        if syn then return "Synapse X"
        elseif KRNL_LOADED then return "KRNL"
        elseif rconsoleprint then return "Script-Ware"
        elseif fluxus then return "Fluxus"
        elseif getexecutorname then local ok,n=pcall(getexecutorname) if ok and n then return n end
        elseif identifyexecutor then local ok,n=pcall(identifyexecutor) if ok and n then return n end end
        return "Desconhecido"
    end
    local sysSection=BuildSection("Sistema",SettingsScroll)
    sysSection:addLabel("Executor: "..detectExecutor())
    sysSection:addLabel("FS: "..(_wf and _rf and "Suporte total" or "Parcial / sem suporte"))
    sysSection:addLabel("Pasta: "..folder)

    -- marca ignorados
    for _,idx in ipairs({cfgNameCtrl._idx,cfgListCtrl._idx,autoSaveCtrl._idx,autoLoadCtrl._idx}) do
        if idx then SaveIgnore[idx]=true end
    end

    -- auto-load task
    task.spawn(function()
        task.wait(2)
        if not AutoLoadEnabled then return end
        local fc=SafeRead(ConfigCfgPath.."/autoload.txt")
        if not fc then return end
        local nm=fc:gsub("%s","") if nm=="" then return end
        local ok=LoadConfig(nm)
        if ok then cfgListCtrl:Set(nm) cfgNameCtrl:Set(nm) end
    end)

    -- ── Drag ──
    local dragging,dragStart,startPos,dragInput
    TitleBar.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true dragStart=inp.Position startPos=Main.Position end
    end)
    TitleBar.InputChanged:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseMovement then dragInput=inp end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp==dragInput then
            local d=inp.Position-dragStart
            Main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,
                                    startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)

    -- ── Minimize / MiniPanel ──
    local Minimized=false
    local FullSize=UDim2.new(0,WINDOW_W,0,WINDOW_H)
    local TM=TweenInfo.new(0.20,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
    local TO=TweenInfo.new(0.25,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)

    local MiniPanel=ni("Frame",{Parent=ScreenGui,BackgroundColor3=C.SIDE,
        BackgroundTransparency=1,BorderSizePixel=0,
        AnchorPoint=Vector2.new(0.5,1),Position=UDim2.new(0.5,0,1,-10),
        Size=UDim2.new(0,260,0,40),Visible=false,ZIndex=100})
    Corner(MiniPanel,SQ) MkStroke(MiniPanel,C.BORDER,1)
    ni("TextLabel",{Parent=MiniPanel,BackgroundTransparency=1,
        Position=UDim2.new(0,14,0,3),Size=UDim2.new(1,-84,0,16),
        Font=Enum.Font.GothamBold,Text=windowname or "ecohub",
        TextColor3=C.TEXT,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=101})
    ni("TextLabel",{Parent=MiniPanel,BackgroundTransparency=1,
        Position=UDim2.new(0,14,0,22),Size=UDim2.new(1,-84,0,12),
        Font=Enum.Font.Gotham,Text="minimized  |  RightAlt to open",
        TextColor3=C.DIM,TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=101})
    local MiniBtn=ni("TextButton",{Parent=MiniPanel,BackgroundColor3=C.ACCENT,BorderSizePixel=0,
        AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,0.5,0),
        Size=UDim2.new(0,56,0,24),AutoButtonColor=false,
        Font=Enum.Font.GothamBold,Text="Open",TextColor3=Color3.fromRGB(10,10,10),
        TextSize=11,ZIndex=102}) Corner(MiniBtn,SQ)
    MiniBtn.MouseEnter:Connect(function() Tw(MiniBtn,{BackgroundColor3=C.ACCENTD}) end)
    MiniBtn.MouseLeave:Connect(function() Tw(MiniBtn,{BackgroundColor3=C.ACCENT}) end)

    local function ShowMain()
        Main.Visible=true Main.Size=UDim2.new(0,WINDOW_W,0,0)
        TweenService:Create(Main,TO,{Size=FullSize}):Play()
    end
    local function HideMain()
        TweenService:Create(Main,TM,{Size=UDim2.new(0,WINDOW_W,0,0)}):Play()
        task.delay(TM.Time,function() Main.Visible=false end)
    end
    local function ShowMini()
        MiniPanel.Visible=true MiniPanel.BackgroundTransparency=1
        TweenService:Create(MiniPanel,TO,{BackgroundTransparency=0}):Play()
        for _,d in ipairs(MiniPanel:GetDescendants()) do pcall(function()
            if typeof(d.BackgroundTransparency)=="number" then
                TweenService:Create(d,TO,{BackgroundTransparency=d:IsA("TextButton") and 0 or 1}):Play() end
            if typeof(d.TextTransparency)=="number" then TweenService:Create(d,TO,{TextTransparency=0}):Play() end
            if typeof(d.ImageTransparency)=="number" then TweenService:Create(d,TO,{ImageTransparency=0}):Play() end
        end) end
    end
    local function HideMini()
        TweenService:Create(MiniPanel,TM,{BackgroundTransparency=1}):Play()
        for _,d in ipairs(MiniPanel:GetDescendants()) do pcall(function()
            if typeof(d.BackgroundTransparency)=="number" then TweenService:Create(d,TM,{BackgroundTransparency=1}):Play() end
            if typeof(d.TextTransparency)=="number" then TweenService:Create(d,TM,{TextTransparency=1}):Play() end
            if typeof(d.ImageTransparency)=="number" then TweenService:Create(d,TM,{ImageTransparency=1}):Play() end
        end) end
        task.delay(TM.Time,function() MiniPanel.Visible=false end)
    end

    local function DoMinimize(toMin)
        Minimized=toMin
        if toMin then HideMain() task.delay(TM.Time+0.02,ShowMini)
        else HideMini() task.delay(TM.Time+0.02,ShowMain) end
    end

    MinBtn.MouseButton1Click:Connect(function() DoMinimize(true) end)
    MiniBtn.MouseButton1Click:Connect(function() DoMinimize(false) end)

    local ToggleKey=Enum.KeyCode.RightAlt
    UserInputService.InputBegan:Connect(function(inp,gp)
        if not gp and inp.KeyCode==ToggleKey then DoMinimize(not Minimized) end
    end)

    -- ── Tab system ──
    local Pages={} local SettingsActive=false

    local function SetSActive(active)
        SettingsActive=active
        if active then
            Tw(SettingsBtn,{BackgroundTransparency=0,BackgroundColor3=C.ACTIVE})
            SIco.ImageColor3=C.ACCENT
            Tw(SInd,{Size=UDim2.new(0,2,0,18)},TI.Slow)
            Tw(SHL,{BackgroundTransparency=0.93},TI.Med)
        else
            Tw(SettingsBtn,{BackgroundTransparency=1})
            SIco.ImageColor3=C.DIM
            Tw(SInd,{Size=UDim2.new(0,2,0,0)})
            Tw(SHL,{BackgroundTransparency=1})
        end
    end

    local function DeactivateAll()
        for _,p in pairs(Pages) do p.Page.Visible=false p.Deactivate() end
        SettingsPage.Visible=false SetSActive(false)
    end

    SettingsBtn.MouseButton1Click:Connect(function()
        if SettingsActive then return end
        DeactivateAll() SetSActive(true) SettingsPage.Visible=true
    end)
    SettingsBtn.MouseEnter:Connect(function()
        if not SettingsActive then
            Tw(SettingsBtn,{BackgroundTransparency=0,BackgroundColor3=C.HOVER})
            SIco.ImageColor3=C.TEXTSUB
        end
    end)
    SettingsBtn.MouseLeave:Connect(function()
        if not SettingsActive then Tw(SettingsBtn,{BackgroundTransparency=1}) SIco.ImageColor3=C.DIM end
    end)

    local Window={}

    function Window:addPage(pagename, iconName)
        local Tab=ni("TextButton",{Parent=TabScroll,BackgroundColor3=C.ELEM,
            BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.new(1,0,0,30),
            AutoButtonColor=false,Text="",ClipsDescendants=true})
        Corner(Tab,SQ)

        local TabInd=ni("Frame",{Parent=Tab,BackgroundColor3=C.TABLINE,BorderSizePixel=0,
            AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.new(0,2,0,0)})
        Corner(TabInd,1)
        local TabHL=ni("Frame",{Parent=Tab,BackgroundColor3=C.TABLINE,BackgroundTransparency=1,
            BorderSizePixel=0,Size=UDim2.new(1,0,1,0)}) Corner(TabHL,SQ)

        local TabIcon=nil
        if iconName then
            local id=GetIconId(iconName)
            if id then
                TabIcon=ni("ImageLabel",{Parent=Tab,BackgroundTransparency=1,Image=id,
                    ImageColor3=C.DIM,Size=UDim2.new(0,16,0,16),
                    Position=UDim2.new(0,10,0.5,0),AnchorPoint=Vector2.new(0,0.5),
                    ScaleType=Enum.ScaleType.Fit})
            end
        end
        local lblOff = TabIcon and (10+16+5) or 14
        local lblW   = TabIcon and (10+16+12) or 18
        local TabLbl=ni("TextLabel",{Parent=Tab,BackgroundTransparency=1,
            Position=UDim2.new(0,lblOff,0,0),Size=UDim2.new(1,-lblW,1,0),
            Font=Enum.Font.GothamSemibold,Text=pagename,TextColor3=C.DIM,
            TextSize=12,TextXAlignment=Enum.TextXAlignment.Left})

        local PageFrame=ni("Frame",{Parent=ContentArea,BackgroundTransparency=1,
            BorderSizePixel=0,Size=UDim2.new(1,0,1,0),Visible=false,ClipsDescendants=true})
        local PageScroll=ni("ScrollingFrame",{Parent=PageFrame,BackgroundTransparency=1,
            BorderSizePixel=0,Size=UDim2.new(1,0,1,0),ScrollBarThickness=2,
            ScrollBarImageColor3=C.ACCENT,CanvasSize=UDim2.new(0,0,0,0),
            AutomaticCanvasSize=Enum.AutomaticSize.Y,ClipsDescendants=true})
        ni("UIListLayout",{Parent=PageScroll,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6)})
        ni("UIPadding",{Parent=PageScroll,PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,8),PaddingRight=UDim.new(0,2)})

        local isActive=false
        local function ActivateTab()
            isActive=true
            Tw(Tab,{BackgroundTransparency=0,BackgroundColor3=C.ACTIVE})
            TabLbl.TextColor3=C.TEXT
            if TabIcon then Tw(TabIcon,{ImageColor3=C.ACCENT}) end
            Tw(TabInd,{Size=UDim2.new(0,2,0,18)},TI.Slow)
            Tw(TabHL,{BackgroundTransparency=0.93},TI.Med)
        end
        local function DeactivateTab()
            isActive=false
            Tw(Tab,{BackgroundTransparency=1})
            TabLbl.TextColor3=C.DIM
            if TabIcon then Tw(TabIcon,{ImageColor3=C.DIM}) end
            Tw(TabInd,{Size=UDim2.new(0,2,0,0)})
            Tw(TabHL,{BackgroundTransparency=1})
        end

        table.insert(Pages,{Tab=Tab,Page=PageFrame,Activate=ActivateTab,Deactivate=DeactivateTab})

        local function SelectTab()
            for _,p in pairs(Pages) do
                if p.Tab~=Tab then p.Deactivate() p.Page.Visible=false end
            end
            SettingsPage.Visible=false SetSActive(false)
            ActivateTab() PageFrame.Visible=true
        end

        Tab.MouseButton1Click:Connect(SelectTab)
        Tab.MouseEnter:Connect(function()
            if not isActive then Tw(Tab,{BackgroundTransparency=0,BackgroundColor3=C.HOVER})
                TabLbl.TextColor3=C.TEXTSUB
                if TabIcon then Tw(TabIcon,{ImageColor3=C.TEXTSUB}) end end
        end)
        Tab.MouseLeave:Connect(function()
            if not isActive then Tw(Tab,{BackgroundTransparency=1}) TabLbl.TextColor3=C.DIM
                if TabIcon then Tw(TabIcon,{ImageColor3=C.DIM}) end end
        end)

        if #Pages==1 then SelectTab() end

        local PageObj={}
        function PageObj:addSection(sname)
            local ok,r=pcall(BuildSection,sname,PageScroll)
            if not ok then
                return setmetatable({},{__index=function() return function() end end})
            end
            return r
        end
        return PageObj
    end

    function Window:setToggleKey(kc) ToggleKey=kc end
    function Window:SaveConfig(n) return SaveConfig(n) end
    function Window:LoadConfig(n) return LoadConfig(n) end
    function Window:setIgnoreIndexes(list)
        for _,k in ipairs(list) do SaveIgnore[k]=true end
    end
    function Window:getColors() return C end

    return Window
end

-- AutoLoad helper (compatível com nosso estilo)
Library.AutoLoad = {
    Check = function(folder)
        folder = folder or "ecohub"
        local v = SafeRead(folder.."/configs/autoload.txt")
        return v and v:gsub("%s","")~="" or false
    end,
}

return Library
