-- EcoHub Free UI Library
-- Usage: local Hub = loadstring(...)() or require(...)
-- local Win = Hub:Window("Title")
-- local Tab = Win:Tab("Name","icon")
-- local Sec = Tab:Section("Name")
-- Tab:Toggle{key="k",text="T",desc="D",default=false,callback=fn}

local UIS     = game:GetService("UserInputService")
local TS      = game:GetService("TweenService")
local RS      = game:GetService("RunService")
local Players = game:GetService("Players")
local HTTP    = game:GetService("HttpService")
local MPS     = game:GetService("MarketplaceService")
local lp      = Players.LocalPlayer

-- ─── Config path ─────────────────────────────────────────────────────────────
local gameName = "unknown"
pcall(function()
    local i = MPS:GetProductInfo(game.PlaceId)
    gameName = tostring(i.Name):lower():gsub("[^%w%-_]","_"):sub(1,36)
end)
local CFG_FOLDER  = "EcoHub Free"
local CFG_FOLDER2 = "EcoHub Free/configs"
local CFG_PATH    = CFG_FOLDER2.."/"..gameName..".json"

local function ensureFolders()
    pcall(function()
        if not isfolder(CFG_FOLDER)  then makefolder(CFG_FOLDER)  end
        if not isfolder(CFG_FOLDER2) then makefolder(CFG_FOLDER2) end
    end)
end
local function readCfg()
    local ok,d = pcall(function()
        ensureFolders()
        return isfile(CFG_PATH) and HTTP:JSONDecode(readfile(CFG_PATH)) or {}
    end)
    return (ok and type(d)=="table") and d or {}
end
local function writeCfg(d)
    pcall(function() ensureFolders() writefile(CFG_PATH, HTTP:JSONEncode(d)) end)
end

local cfg = readCfg()
if not cfg.elements   then cfg.elements   = {} end
if not cfg.ui         then cfg.ui         = {} end

-- ─── Clean old GUIs ──────────────────────────────────────────────────────────
local function cleanOld(p)
    for _,v in ipairs(p:GetChildren()) do
        if v.Name:sub(1,7)=="ecohub_" then v:Destroy() end
    end
end
cleanOld(game:GetService("CoreGui"))
if gethui then cleanOld(gethui()) end

-- ─── Icons ───────────────────────────────────────────────────────────────────
local _iconsOk,_iconsData = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/EcohubPassouAqui/v2/refs/heads/main/icons"))()
end)
local _reg = (_iconsOk and type(_iconsData)=="table" and _iconsData.assets) or {}
local function icon(n) return _reg["lucide-"..n] or "rbxassetid://0" end
local LOGO = "rbxassetid://134382458890933"

-- ─── Theme ───────────────────────────────────────────────────────────────────
local T = {
    Accent      = Color3.fromRGB(68,132,176),
    AccentD     = Color3.fromRGB(42,96,136),
    AccentH     = Color3.fromRGB(90,152,198),
    bg          = Color3.fromRGB(17,17,17),
    bgB         = Color3.fromRGB(22,22,22),
    bgC         = Color3.fromRGB(26,26,26),
    sidebar     = Color3.fromRGB(19,19,19),
    divider     = Color3.fromRGB(44,44,44),
    border      = Color3.fromRGB(50,50,50),
    borderL     = Color3.fromRGB(38,38,38),
    white       = Color3.fromRGB(218,218,218),
    whiteD      = Color3.fromRGB(175,175,175),
    sub         = Color3.fromRGB(108,108,108),
    dim         = Color3.fromRGB(72,72,72),
    tabI        = Color3.fromRGB(95,95,95),
    tabH        = Color3.fromRGB(148,148,148),
    tabA        = Color3.fromRGB(205,205,205),
    secTxt      = Color3.fromRGB(62,62,62),
    elBg        = Color3.fromRGB(26,26,26),
    elBgH       = Color3.fromRGB(32,32,32),
    elBgT       = Color3.fromRGB(36,36,36),
    floatBg     = Color3.fromRGB(21,21,21),
    inputBg     = Color3.fromRGB(16,16,16),
    toggleOff   = Color3.fromRGB(40,40,40),
    toggleOffB  = Color3.fromRGB(52,52,52),
    checkOff    = Color3.fromRGB(23,23,23),
    tabBgH      = Color3.fromRGB(34,34,34),
    tabBgA      = Color3.fromRGB(38,38,38),
}

-- ─── Helpers ─────────────────────────────────────────────────────────────────
local function New(cls, props)
    local o = Instance.new(cls)
    for k,v in pairs(props) do if k~="Parent" then o[k]=v end end
    if props.Parent then o.Parent = props.Parent end
    return o
end
local function Tw(o, g, t, s)
    TS:Create(o, TweenInfo.new(t or 0.17, s or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), g):Play()
end
local function Img(id,par,sz,pos,col,zi)
    return New("ImageLabel",{Size=UDim2.new(0,sz,0,sz),Position=pos,BackgroundTransparency=1,
        Image=id,ImageColor3=col or T.dim,ZIndex=zi or 5,Parent=par})
end
local function Corner(r,par)   New("UICorner",{CornerRadius=UDim.new(0,r),Parent=par}) end
local function Stroke(col,t,tr,par) New("UIStroke",{Color=col,Thickness=t or 1,Transparency=tr or 0,Parent=par}) end
local function Grad(cs,rot,par) New("UIGradient",{Color=cs,Rotation=rot or 0,Parent=par}) end
local function GradC(a,b,rot,par)
    Grad(ColorSequence.new({ColorSequenceKeypoint.new(0,a),ColorSequenceKeypoint.new(1,b)}),rot,par)
end

-- save/load helpers
local function saveEl(key,val)
    if not key or key=="" then return end
    local sv = val
    if typeof(val)=="Color3" then sv={r=math.round(val.R*255),g=math.round(val.G*255),b=math.round(val.B*255)}
    elseif typeof(val)=="EnumItem" then sv=val.Name end
    cfg.elements[key]=sv writeCfg(cfg)
end
local function loadEl(key,def)
    if not key or key=="" then return def end
    local sv = cfg.elements[key]
    if sv==nil then return def end
    if type(def)=="number"  and type(sv)=="number"  then return sv end
    if type(def)=="boolean" and type(sv)=="boolean" then return sv end
    if type(def)=="string"  and type(sv)=="string"  then return sv end
    if typeof(def)=="Color3" and type(sv)=="table" and sv.r then
        return Color3.fromRGB(sv.r,sv.g,sv.b) end
    if typeof(def)=="EnumItem" and type(sv)=="string" then
        local ok,v = pcall(function() return Enum.KeyCode[sv] end)
        if ok then return v end end
    return def
end

-- ─── Float system ────────────────────────────────────────────────────────────
local _openFloats = {}
local function closeAllFloats(except)
    for i=#_openFloats,1,-1 do
        local fn=_openFloats[i]
        if fn~=except then pcall(fn) table.remove(_openFloats,i) end
    end
end
local function anchorFloat(panel, trigger)
    local vp = game:GetService("Workspace").CurrentCamera.ViewportSize
    local ap = trigger.AbsolutePosition
    local as = trigger.AbsoluteSize
    local ps = panel.AbsoluteSize
    local x  = math.clamp(ap.X, 2, vp.X - ps.X - 2)
    local y  = ap.Y + as.Y + 5
    if y + ps.Y > vp.Y - 4 then y = ap.Y - ps.Y - 5 end
    panel.Position = UDim2.fromOffset(x, y)
end

-- ─── Element registry for search ─────────────────────────────────────────────
local _registry = {}   -- {frame, lowerText, tabObj}
local function regEl(frame, text, tabRef)
    table.insert(_registry, {frame=frame, low=text:lower(), tab=tabRef})
end

-- ─── Base element frame ───────────────────────────────────────────────────────
local _elo = 0
local function nextLO() _elo+=1 return _elo end
local function elBase(parent, h)
    local f = New("Frame",{
        Size=UDim2.new(1,0,0,h or 44), BackgroundColor3=T.elBg,
        BorderSizePixel=0, ClipsDescendants=false,
        LayoutOrder=nextLO(), ZIndex=3, Parent=parent,
    })
    Corner(7,f) Stroke(T.border,1,0.22,f)
    GradC(T.elBgT, Color3.fromRGB(20,20,20), 90, f)
    return f
end
local function elHover(btn, f)
    btn.MouseEnter:Connect(function() Tw(f,{BackgroundColor3=T.elBgH},0.1) end)
    btn.MouseLeave:Connect(function() Tw(f,{BackgroundColor3=T.elBg },0.1) end)
end
local function elLabel(f, text, desc)
    local nameH = (desc and desc~="") and 14 or 0
    New("TextLabel",{
        Size=UDim2.new(1,-148,0,15), Position=UDim2.new(0,12, (nameH>0 and 0.5 or 0.5), nameH>0 and -14 or -7),
        BackgroundTransparency=1, Text=text, TextColor3=T.white,
        TextSize=12, Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextTruncate=Enum.TextTruncate.AtEnd, ZIndex=4, Parent=f,
    })
    if desc and desc~="" then
        New("TextLabel",{
            Size=UDim2.new(1,-148,0,11), Position=UDim2.new(0,12,0.5,2),
            BackgroundTransparency=1, Text=desc, TextColor3=T.sub,
            TextSize=9, Font=Enum.Font.Gotham,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextTruncate=Enum.TextTruncate.AtEnd, ZIndex=4, Parent=f,
        })
    end
end
local function floatPanel(w,h)
    local p = New("Frame",{
        Size=UDim2.fromOffset(w,h), BackgroundColor3=T.floatBg,
        BorderSizePixel=0, ClipsDescendants=false,
        ZIndex=130, Visible=false,
    })
    Corner(8,p) Stroke(T.border,1,0.08,p)
    GradC(Color3.fromRGB(32,32,32),Color3.fromRGB(17,17,17),90,p)
    New("ImageLabel",{
        Size=UDim2.fromScale(1,1)+UDim2.fromOffset(28,28), Position=UDim2.fromOffset(-14,-14),
        BackgroundTransparency=1, Image="rbxassetid://5554236805",
        ScaleType=Enum.ScaleType.Slice, SliceCenter=Rect.new(23,23,277,277),
        ImageColor3=Color3.fromRGB(0,0,0), ImageTransparency=0.22,
        ZIndex=129, Parent=p,
    })
    return p
end

-- ─── GUI root ────────────────────────────────────────────────────────────────
local guiName = "ecohub_"..math.random(1e5,9e5)
local gui = New("ScreenGui",{
    Name=guiName, ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    DisplayOrder=999, IgnoreGuiInset=true,
    Parent=(gethui and gethui()) or game:GetService("CoreGui"),
})

-- ─── Library object ──────────────────────────────────────────────────────────
local EcoHub = {}
EcoHub.__index = EcoHub

-- ─── Window ──────────────────────────────────────────────────────────────────
function EcoHub:Window(opts)
    opts = opts or {}
    local title    = opts.Title or opts[1] or "EcoHub Free"
    local subtitle = opts.Subtitle or "v1.0"
    local W = 620 local H = 500
    local TH = 40 local SF = 188 local SM = 42 local LH = 86
    local sW = cfg.ui.side==false and SM or SF
    local expanded = cfg.ui.side~=false
    local minimized = false
    local dragging  = false
    local dragOff   = Vector2.zero

    local main = New("Frame",{
        AnchorPoint=Vector2.new(0.5,0.5), Size=UDim2.new(0,W,0,H),
        Position=UDim2.fromScale(0.5,0.5), BackgroundColor3=T.bg,
        BorderSizePixel=0, ClipsDescendants=true, ZIndex=1, Parent=gui,
    })
    Corner(10,main) Stroke(T.border,1,0.05,main)

    -- titlebar
    local tb = New("Frame",{
        Size=UDim2.new(1,0,0,TH), BackgroundColor3=T.bgB,
        BorderSizePixel=0, ZIndex=8, Parent=main,
    })
    Corner(10,tb)
    New("Frame",{Size=UDim2.new(1,0,0,10),Position=UDim2.new(0,0,1,-10),
        BackgroundColor3=T.bgB,BorderSizePixel=0,ZIndex=8,Parent=tb})
    New("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,0),
        BackgroundColor3=T.divider,BorderSizePixel=0,ZIndex=9,Parent=tb})
    Img(LOGO,tb,20,UDim2.new(0,10,0.5,-10),T.white,9)
    New("TextLabel",{Size=UDim2.new(0,200,1,0),Position=UDim2.new(0,36,0,0),
        BackgroundTransparency=1,Text=title,TextColor3=T.white,
        TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=9,Parent=tb})
    New("TextLabel",{Size=UDim2.new(0,80,1,0),Position=UDim2.new(1,-86,0,0),
        BackgroundTransparency=1,Text=subtitle,TextColor3=T.dim,
        TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Right,
        ZIndex=9,Parent=tb})

    -- sidebar
    local sb = New("Frame",{
        Size=UDim2.new(0,sW,1,-TH), Position=UDim2.new(0,0,0,TH),
        BackgroundColor3=T.sidebar,BorderSizePixel=0,ClipsDescendants=true,
        ZIndex=4,Parent=main,
    })
    local vline = New("Frame",{
        Size=UDim2.new(0,1,1,-TH), Position=UDim2.new(0,sW,0,TH),
        BackgroundColor3=T.divider,BorderSizePixel=0,ZIndex=5,Parent=main,
    })

    -- logo
    local logoA = New("Frame",{Size=UDim2.new(1,0,0,LH),BackgroundTransparency=1,ZIndex=5,Parent=sb})
    local logoI = New("ImageLabel",{
        Size=UDim2.new(0,54,0,54),
        Position=UDim2.new(0.5,-27,0.5,-27),
        BackgroundTransparency=1,Image=LOGO,ImageColor3=T.white,ZIndex=6,Parent=logoA,
    })
    New("Frame",{Size=UDim2.new(1,-18,0,1),Position=UDim2.new(0,9,1,-1),
        BackgroundColor3=T.divider,BorderSizePixel=0,ZIndex=5,Parent=logoA})

    -- side scroll
    local ss = New("ScrollingFrame",{
        Size=UDim2.new(1,0,1,-(LH+88)), Position=UDim2.new(0,0,0,LH+1),
        BackgroundTransparency=1,ScrollBarThickness=0,
        CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ZIndex=5,Parent=sb,
    })
    New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,1),Parent=ss})
    New("UIPadding",{PaddingLeft=UDim.new(0,5),PaddingRight=UDim.new(0,5),PaddingTop=UDim.new(0,3),Parent=ss})

    New("Frame",{Size=UDim2.new(1,-10,0,1),Position=UDim2.new(0,5,1,-82),
        BackgroundColor3=T.divider,BorderSizePixel=0,ZIndex=5,Parent=sb})

    local colBtn = New("TextButton",{
        Size=UDim2.new(1,-10,0,24),Position=UDim2.new(0,5,1,-76),
        BackgroundColor3=T.tabBgH,BackgroundTransparency=1,
        BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=5,Parent=sb,
    })
    Corner(6,colBtn)
    local colIco   = Img(icon("chevron-left"),colBtn,12,UDim2.new(1,-18,0.5,-6),T.dim,6)
    local colLbl   = New("TextLabel",{
        Size=UDim2.new(1,-24,1,0),Position=UDim2.new(0,6,0,0),
        BackgroundTransparency=1,Text="Recolher",TextColor3=T.dim,
        TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=6,Parent=colBtn,
    })

    -- avatar
    local avFr = New("Frame",{
        Size=UDim2.new(1,-10,0,36),Position=UDim2.new(0,5,1,-42),
        BackgroundColor3=T.bgC,BorderSizePixel=0,ZIndex=5,Parent=sb,
    })
    Corner(7,avFr) Stroke(T.borderL,1,0.3,avFr)
    local avImg = New("ImageLabel",{
        Size=UDim2.new(0,22,0,22),Position=UDim2.new(0,6,0.5,-11),
        BackgroundColor3=T.dim,BorderSizePixel=0,ZIndex=6,Parent=avFr,
    })
    Corner(11,avImg)
    local avName = New("TextLabel",{
        Size=UDim2.new(1,-34,0,12),Position=UDim2.new(0,32,0,5),
        BackgroundTransparency=1,Text=lp.DisplayName,TextColor3=T.white,
        TextSize=11,Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
        ZIndex=6,Parent=avFr,
    })
    local avTag = New("TextLabel",{
        Size=UDim2.new(1,-34,0,10),Position=UDim2.new(0,32,0,19),
        BackgroundTransparency=1,Text="@"..lp.Name,TextColor3=T.dim,
        TextSize=9,Font=Enum.Font.Gotham,
        TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
        ZIndex=6,Parent=avFr,
    })
    task.spawn(function()
        local ok,url=pcall(function()
            return Players:GetUserThumbnailAsync(lp.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size48x48)
        end)
        if ok then avImg.Image=url end
    end)

    -- page area
    local pageArea = New("Frame",{
        Size=UDim2.new(1,-(sW+1),1,-TH), Position=UDim2.new(0,sW+1,0,TH),
        BackgroundTransparency=1,ClipsDescendants=true,ZIndex=2,Parent=main,
    })

    -- search bar top
    local topBar = New("Frame",{
        Size=UDim2.new(1,0,0,44),BackgroundTransparency=1,ZIndex=5,Parent=pageArea,
    })
    local searchFr = New("Frame",{
        Size=UDim2.new(1,-14,0,27),Position=UDim2.new(0,7,0,8),
        BackgroundColor3=T.bgC,BorderSizePixel=0,ZIndex=6,Parent=topBar,
    })
    Corner(7,searchFr) Stroke(T.divider,1,0.15,searchFr)
    Img(icon("search"),searchFr,13,UDim2.new(0,8,0.5,-6.5),T.dim,7)
    local searchBox = New("TextBox",{
        Size=UDim2.new(1,-30,1,0),Position=UDim2.new(0,24,0,0),
        BackgroundTransparency=1,PlaceholderText="Pesquisar elemento...",
        PlaceholderColor3=T.dim,Text="",TextColor3=T.white,
        TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,
        ClearTextOnFocus=false,ZIndex=7,Parent=searchFr,
    })
    New("Frame",{
        Size=UDim2.new(1,-14,0,1),Position=UDim2.new(0,7,1,-1),
        BackgroundColor3=T.divider,BorderSizePixel=0,ZIndex=5,Parent=topBar,
    })

    -- content area
    local contentA = New("Frame",{
        Size=UDim2.new(1,0,1,-45),Position=UDim2.new(0,0,0,45),
        BackgroundTransparency=1,ClipsDescendants=true,ZIndex=2,Parent=pageArea,
    })

    -- search result page
    local searchPage = New("Frame",{
        Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
        ClipsDescendants=true,Visible=false,ZIndex=3,Parent=contentA,
    })
    local searchScroll = New("ScrollingFrame",{
        Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
        ScrollBarThickness=3,ScrollBarImageColor3=T.divider,
        CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ZIndex=3,Parent=searchPage,
    })
    New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,5),Parent=searchScroll})
    New("UIPadding",{PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,10),
        PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10),Parent=searchScroll})

    -- empty state label
    local noResultLbl = New("TextLabel",{
        Size=UDim2.new(1,0,0,40),Position=UDim2.new(0,0,0,20),
        BackgroundTransparency=1,Text="Nenhum resultado encontrado.",
        TextColor3=T.sub,TextSize=12,Font=Enum.Font.Gotham,
        TextXAlignment=Enum.TextXAlignment.Center,
        Visible=false,ZIndex=4,Parent=searchPage,
    })

    -- tabs list
    local tabs      = {}
    local activeTab = nil
    local secLabels = {}
    local slo       = 0

    local function animUL(ul,instant)
        ul.Size=UDim2.new(0,0,0,2) ul.Visible=true
        if instant then ul.Size=UDim2.new(1,-6,0,2)
        else Tw(ul,{Size=UDim2.new(1,-6,0,2)},0.2) end
    end
    local function selTab(tab, instant)
        searchPage.Visible=false searchBox.Text=""
        for _,t in ipairs(tabs) do
            if t~=tab then
                t.page.Visible=false t.ul.Visible=false
                Tw(t.btn,{BackgroundTransparency=1},0.12)
                Tw(t.ico,{ImageColor3=T.tabI},0.12)
                Tw(t.lbl,{TextColor3=T.tabI},0.12)
            end
        end
        tab.page.Visible=true activeTab=tab
        Tw(tab.btn,{BackgroundColor3=T.tabBgA,BackgroundTransparency=0},0.12)
        Tw(tab.ico,{ImageColor3=T.white},0.12)
        Tw(tab.lbl,{TextColor3=T.tabA},0.12)
        animUL(tab.ul,instant)
        cfg.ui.activeTab=tab.name writeCfg(cfg)
    end

    -- search logic
    local function doSearch(q)
        q = q:lower():gsub("^%s+",""):gsub("%s+$","")
        if q=="" then
            searchPage.Visible=false
            if activeTab then selTab(activeTab,true) end
            return
        end
        -- hide all tab pages
        for _,t in ipairs(tabs) do t.page.Visible=false end
        searchPage.Visible=true
        -- clear old clones
        for _,c in ipairs(searchScroll:GetChildren()) do
            if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
        end
        local found = 0
        for _,entry in ipairs(_registry) do
            if entry.low:find(q,1,true) then
                found += 1
                -- clone frame appearance with a wrapper
                local clone = New("Frame",{
                    Size=UDim2.new(1,0,0,entry.frame.Size.Y.Offset),
                    BackgroundColor3=entry.frame.BackgroundColor3,
                    BorderSizePixel=0, ClipsDescendants=false,
                    LayoutOrder=found, ZIndex=3, Parent=searchScroll,
                })
                Corner(7,clone) Stroke(T.border,1,0.22,clone)
                GradC(T.elBgT,Color3.fromRGB(20,20,20),90,clone)
                -- copy children visually (reference, not reparent)
                for _,ch in ipairs(entry.frame:GetChildren()) do
                    local ok = pcall(function()
                        if ch:IsA("GuiObject") or ch:IsA("UICorner") or ch:IsA("UIStroke") or ch:IsA("UIGradient") then
                            local cl2 = ch:Clone()
                            cl2.Parent = clone
                        end
                    end)
                    _ = ok
                end
                -- tab badge
                if entry.tab then
                    New("TextLabel",{
                        Size=UDim2.new(0,0,0,14),Position=UDim2.new(0,8,1,-16),
                        BackgroundTransparency=1,Text="↳ "..entry.tab,
                        TextColor3=T.Accent,TextSize=9,Font=Enum.Font.GothamBold,
                        AutomaticSize=Enum.AutomaticSize.X,
                        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10,Parent=clone,
                    })
                    clone.Size = UDim2.new(1,0,0,entry.frame.Size.Y.Offset+16)
                end
                -- click to jump to tab
                local hitBtn = New("TextButton",{
                    Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=20,Parent=clone,
                })
                local tabTarget = entry.tab
                hitBtn.MouseButton1Click:Connect(function()
                    searchBox.Text=""
                    searchPage.Visible=false
                    for _,t in ipairs(tabs) do
                        if t.name==tabTarget then selTab(t) break end
                    end
                    task.wait(0.05)
                    -- scroll to element
                    if entry.tab then
                        for _,t in ipairs(tabs) do
                            if t.name==tabTarget then
                                local sc = t.scroll
                                local ap = entry.frame.AbsolutePosition
                                local sap = sc.AbsolutePosition
                                sc.CanvasPosition = Vector2.new(0, math.max(0, ap.Y - sap.Y - 10))
                                break
                            end
                        end
                    end
                end)
            end
        end
        noResultLbl.Visible = (found==0)
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        doSearch(searchBox.Text)
    end)

    -- addSection helper (inside window scope)
    local function addSec(label)
        slo+=1
        New("Frame",{Size=UDim2.new(1,0,0,5),BackgroundTransparency=1,LayoutOrder=slo,ZIndex=5,Parent=ss})
        slo+=1
        local row = New("Frame",{Size=UDim2.new(1,0,0,15),BackgroundTransparency=1,LayoutOrder=slo,ZIndex=5,Parent=ss})
        local lbl = New("TextLabel",{
            Size=UDim2.new(1,-4,1,0),Position=UDim2.new(0,4,0,0),
            BackgroundTransparency=1,Text=string.upper(label),
            TextColor3=T.secTxt,TextSize=8,Font=Enum.Font.GothamBold,
            TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6,Parent=row,
        })
        table.insert(secLabels,lbl)
    end

    -- setSide
    local function setSide(exp)
        expanded = exp
        local nw = exp and SF or SM
        sW = nw
        Tw(sb,{Size=UDim2.new(0,nw,1,-TH)},0.18)
        Tw(vline,{Position=UDim2.new(0,nw,0,TH)},0.18)
        Tw(pageArea,{Size=UDim2.new(1,-(nw+1),1,-TH),Position=UDim2.new(0,nw+1,0,TH)},0.18)
        local hide = exp and 0 or 1
        for _,l in ipairs(secLabels) do Tw(l,{TextTransparency=hide},0.14) end
        for _,t in ipairs(tabs) do
            Tw(t.lbl,{TextTransparency=hide},0.14)
            t.ico.Position = exp and UDim2.new(0,6,0.5,-7) or UDim2.new(0.5,-7,0.5,-7)
            t.tip.Visible=false
        end
        Tw(avName,{TextTransparency=hide},0.14)
        Tw(avTag, {TextTransparency=hide},0.14)
        avImg.Position = exp and UDim2.new(0,6,0.5,-11) or UDim2.new(0.5,-11,0.5,-11)
        if exp then
            logoI.Size=UDim2.new(0,54,0,54) logoI.Position=UDim2.new(0.5,-27,0.5,-27)
        else
            logoI.Size=UDim2.new(0,24,0,24) logoI.Position=UDim2.new(0.5,-12,0.5,-12)
        end
        colIco.Image=icon(exp and "chevron-left" or "chevron-right")
        colLbl.Text = exp and "Recolher" or "Expandir"
        colIco.Position = exp and UDim2.new(1,-18,0.5,-6) or UDim2.new(0.5,-6,0.5,-6)
        Tw(colLbl,{TextTransparency=hide},0.14)
        cfg.ui.side=exp writeCfg(cfg)
    end

    colBtn.MouseButton1Click:Connect(function() setSide(not expanded) end)
    colBtn.MouseEnter:Connect(function()
        Tw(colBtn,{BackgroundTransparency=0,BackgroundColor3=T.tabBgH},0.1)
        Tw(colIco,{ImageColor3=T.white},0.1) Tw(colLbl,{TextColor3=T.white},0.1)
    end)
    colBtn.MouseLeave:Connect(function()
        Tw(colBtn,{BackgroundTransparency=1},0.1)
        Tw(colIco,{ImageColor3=T.dim},0.1) Tw(colLbl,{TextColor3=T.dim},0.1)
    end)

    -- drag
    tb.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            local p=main.AbsolutePosition
            dragOff=Vector2.new(inp.Position.X-p.X,inp.Position.Y-p.Y)
        end
    end)
    tb.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)
    RS.RenderStepped:Connect(function()
        if not dragging then return end
        local m=UIS:GetMouseLocation()
        main.Position=UDim2.new(0,m.X-dragOff.X+main.AbsoluteSize.X*0.5,0,m.Y-dragOff.Y+main.AbsoluteSize.Y*0.5)
    end)
    UIS.InputBegan:Connect(function(inp)
        if inp.KeyCode==Enum.KeyCode.RightAlt then
            minimized=not minimized main.Visible=not minimized
            cfg.ui.minimized=minimized writeCfg(cfg)
        end
    end)

    if not expanded then setSide(false) end

    -- ── Window object ──────────────────────────────────────────────────────────
    local Win = {}
    Win.__index = Win

    function Win:Tab(name, iconName)
        slo+=1
        local btn = New("TextButton",{
            Size=UDim2.new(1,0,0,27), BackgroundColor3=T.tabBgA,
            BackgroundTransparency=1, BorderSizePixel=0, Text="",
            AutoButtonColor=false, LayoutOrder=slo, ZIndex=6, Parent=ss,
        })
        Corner(6,btn)
        local ico = Img(icon(iconName or "square"),btn,13,UDim2.new(0,6,0.5,-6.5),T.tabI,7)
        local lbl = New("TextLabel",{
            Size=UDim2.new(1,-23,1,0),Position=UDim2.new(0,23,0,0),
            BackgroundTransparency=1,Text=name,TextColor3=T.tabI,
            TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,
            ZIndex=7,Parent=btn,
        })
        local ul = New("Frame",{
            Size=UDim2.new(0,0,0,2),Position=UDim2.new(0,3,1,-2),
            BackgroundColor3=T.Accent,BorderSizePixel=0,Visible=false,ZIndex=9,Parent=btn,
        })
        Corner(1,ul)
        local tip = New("TextLabel",{
            Size=UDim2.new(0,82,0,21),Position=UDim2.new(1,5,0.5,-10.5),
            BackgroundColor3=Color3.fromRGB(26,26,26),TextColor3=T.white,
            TextSize=10,Font=Enum.Font.Gotham,Text=name,
            TextXAlignment=Enum.TextXAlignment.Center,BackgroundTransparency=0,
            ZIndex=30,Visible=false,Parent=btn,
        })
        Corner(5,tip)

        local page = New("Frame",{
            Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
            ClipsDescendants=true,Visible=false,ZIndex=2,Parent=contentA,
        })
        local scroll = New("ScrollingFrame",{
            Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
            ScrollBarThickness=3,ScrollBarImageColor3=T.dim,
            CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
            ZIndex=2,Parent=page,
        })
        New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,5),Parent=scroll})
        New("UIPadding",{PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,10),
            PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10),Parent=scroll})

        local tabObj = {name=name,btn=btn,ico=ico,lbl=lbl,ul=ul,tip=tip,page=page,scroll=scroll}
        table.insert(tabs,tabObj)

        btn.MouseEnter:Connect(function()
            if activeTab~=tabObj then
                Tw(btn,{BackgroundTransparency=0,BackgroundColor3=T.tabBgH},0.1)
                Tw(ico,{ImageColor3=T.tabH},0.1) Tw(lbl,{TextColor3=T.tabH},0.1)
            end
            if not expanded then tip.Visible=true end
        end)
        btn.MouseLeave:Connect(function()
            if activeTab~=tabObj then
                Tw(btn,{BackgroundTransparency=1},0.1)
                Tw(ico,{ImageColor3=T.tabI},0.1) Tw(lbl,{TextColor3=T.tabI},0.1)
            end
            tip.Visible=false
        end)
        btn.MouseButton1Click:Connect(function() selTab(tabObj) end)

        -- select first tab or saved tab
        if #tabs==1 then
            local saved = cfg.ui.activeTab
            if not saved then selTab(tabObj,true) end
        end
        if cfg.ui.activeTab==name then selTab(tabObj,true) end

        -- ── Tab object ─────────────────────────────────────────────────────────
        local Tab = {}
        Tab.__index = Tab

        function Tab:Section(text)
            _elo+=1
            local f = New("Frame",{
                Size=UDim2.new(1,0,0,24),BackgroundTransparency=1,
                LayoutOrder=_elo,ZIndex=3,Parent=scroll,
            })
            local line = New("Frame",{
                Size=UDim2.new(1,-10,0,1),Position=UDim2.new(0,5,0.5,0),
                BackgroundColor3=T.divider,BorderSizePixel=0,ZIndex=3,Parent=f,
            })
            Grad(ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(50,50,50)),
                ColorSequenceKeypoint.new(0.65,Color3.fromRGB(50,50,50)),
                ColorSequenceKeypoint.new(1,Color3.fromRGB(18,18,18))}),0,line)
            local pill = New("Frame",{
                Size=UDim2.new(0,0,0,14),Position=UDim2.new(0,5,0.5,-7),
                BackgroundColor3=T.AccentD,BorderSizePixel=0,
                AutomaticSize=Enum.AutomaticSize.X,ZIndex=4,Parent=f,
            })
            Corner(7,pill)
            GradC(T.AccentH,T.AccentD,90,pill)
            Stroke(T.Accent,1,0.55,pill)
            New("TextLabel",{
                Size=UDim2.new(0,0,1,0),BackgroundTransparency=1,
                AutomaticSize=Enum.AutomaticSize.X,
                Text="  "..string.upper(text).."  ",
                TextColor3=Color3.fromRGB(205,205,205),TextSize=8,Font=Enum.Font.GothamBold,
                ZIndex=5,Parent=pill,
            })
            return f
        end

        function Tab:Toggle(opts)
            local key  = opts.key or opts.Key or ""
            local text = opts.text or opts.Text or "Toggle"
            local desc = opts.desc or opts.Desc or opts.description or ""
            local def  = loadEl(key, opts.default==true or opts.Default==true)
            local cb   = opts.callback or opts.Callback
            local state = def
            local h = (desc~="") and 52 or 44

            local f = elBase(scroll, h) elLabel(f, text, desc)

            local track = New("Frame",{
                Size=UDim2.new(0,34,0,18),Position=UDim2.new(1,-45,0.5,-9),
                BackgroundColor3=state and T.Accent or T.toggleOff,
                BorderSizePixel=0,ZIndex=5,Parent=f,
            })
            Corner(9,track)
            local tG = New("UIGradient",{
                Color=ColorSequence.new({
                    ColorSequenceKeypoint.new(0,state and T.AccentH or T.toggleOffB),
                    ColorSequenceKeypoint.new(1,state and T.AccentD or T.toggleOff),
                }),Rotation=90,Parent=track,
            })
            local tS = New("UIStroke",{
                Color=state and T.Accent or Color3.fromRGB(55,55,55),
                Thickness=1,Transparency=0.35,Parent=track,
            })
            local knob = New("Frame",{
                Size=UDim2.new(0,12,0,12),
                Position=state and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6),
                BackgroundColor3=T.white,BorderSizePixel=0,ZIndex=6,Parent=track,
            })
            Corner(6,knob)
            GradC(Color3.fromRGB(255,255,255),Color3.fromRGB(185,185,185),90,knob)

            local function ref(s)
                Tw(track,{BackgroundColor3=s and T.Accent or T.toggleOff},0.13)
                Tw(knob,{Position=s and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6)},0.13)
                Tw(tS,{Color=s and T.Accent or Color3.fromRGB(55,55,55)},0.13)
                tG.Color=ColorSequence.new({
                    ColorSequenceKeypoint.new(0,s and T.AccentH or T.toggleOffB),
                    ColorSequenceKeypoint.new(1,s and T.AccentD or T.toggleOff),
                })
            end
            local hitBtn=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=7,Parent=f})
            hitBtn.MouseButton1Click:Connect(function()
                state=not state ref(state) saveEl(key,state)
                if cb then task.spawn(cb,state) end
            end)
            elHover(hitBtn,f) regEl(f,text,name)
            if cb and state then task.spawn(cb,state) end
            return {Set=function(v)state=v ref(state) saveEl(key,state) end,Get=function()return state end,Frame=f}
        end

        function Tab:Checkbox(opts)
            local key  = opts.key or ""
            local text = opts.text or "Checkbox"
            local desc = opts.desc or ""
            local def  = loadEl(key, opts.default==true)
            local cb   = opts.callback
            local state = def
            local h = (desc~="") and 52 or 44

            local f = elBase(scroll,h) elLabel(f,text,desc)

            local box = New("Frame",{
                Size=UDim2.new(0,16,0,16),Position=UDim2.new(1,-28,0.5,-8),
                BackgroundColor3=state and T.Accent or T.checkOff,
                BorderSizePixel=0,ZIndex=5,Parent=f,
            })
            Corner(4,box)
            local bG=New("UIGradient",{
                Color=ColorSequence.new({
                    ColorSequenceKeypoint.new(0,state and T.AccentH or Color3.fromRGB(38,38,38)),
                    ColorSequenceKeypoint.new(1,state and T.AccentD or Color3.fromRGB(18,18,18)),
                }),Rotation=135,Parent=box,
            })
            local bS=New("UIStroke",{Color=state and T.Accent or Color3.fromRGB(55,55,55),Thickness=1.5,Parent=box})
            local chk=New("ImageLabel",{
                Size=UDim2.new(0,9,0,9),Position=UDim2.new(0.5,-4.5,0.5,-4.5),
                BackgroundTransparency=1,Image=icon("check"),
                ImageColor3=T.white,ImageTransparency=state and 0 or 1,ZIndex=6,Parent=box,
            })
            local function ref(s)
                Tw(box,{BackgroundColor3=s and T.Accent or T.checkOff},0.13)
                Tw(bS,{Color=s and T.Accent or Color3.fromRGB(55,55,55)},0.13)
                Tw(chk,{ImageTransparency=s and 0 or 1},0.1)
                bG.Color=ColorSequence.new({
                    ColorSequenceKeypoint.new(0,s and T.AccentH or Color3.fromRGB(38,38,38)),
                    ColorSequenceKeypoint.new(1,s and T.AccentD or Color3.fromRGB(18,18,18)),
                })
            end
            local hitBtn=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=7,Parent=f})
            hitBtn.MouseButton1Click:Connect(function()
                state=not state ref(state) saveEl(key,state)
                if cb then task.spawn(cb,state) end
            end)
            elHover(hitBtn,f) regEl(f,text,name)
            if cb and state then task.spawn(cb,state) end
            return {Set=function(v)state=v ref(state) saveEl(key,state) end,Get=function()return state end,Frame=f}
        end

        function Tab:Button(opts)
            local text = opts.text or "Button"
            local desc = opts.desc or ""
            local cb   = opts.callback
            local h = (desc~="") and 52 or 44
            local f = elBase(scroll,h)

            local inner = New("Frame",{
                Size=UDim2.new(1,-14,0,h-18),Position=UDim2.new(0,7,1,-(h-11)),
                BackgroundColor3=T.Accent,BorderSizePixel=0,ZIndex=4,Parent=f,
            })
            Corner(6,inner)
            GradC(T.AccentH,T.AccentD,90,inner)
            Stroke(T.AccentH,1,0.55,inner)
            New("Frame",{Size=UDim2.new(1,0,0.42,0),BackgroundColor3=Color3.fromRGB(255,255,255),
                BackgroundTransparency=0.88,BorderSizePixel=0,ZIndex=5,Parent=inner})
            Corner(6,inner:FindFirstChildWhichIsA("Frame"))

            if desc~="" then
                New("TextLabel",{Size=UDim2.new(1,-14,0,14),Position=UDim2.new(0,8,0,7),
                    BackgroundTransparency=1,Text=text,TextColor3=T.white,
                    TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,Parent=f})
                New("TextLabel",{Size=UDim2.new(1,-14,0,10),Position=UDim2.new(0,8,0,22),
                    BackgroundTransparency=1,Text=desc,TextColor3=T.sub,
                    TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,Parent=f})
            else
                New("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
                    Text=text,TextColor3=T.white,TextSize=12,Font=Enum.Font.GothamBold,
                    TextXAlignment=Enum.TextXAlignment.Center,ZIndex=6,Parent=inner})
            end

            local hitBtn=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=7,Parent=f})
            hitBtn.MouseEnter:Connect(function()   Tw(inner,{BackgroundColor3=T.AccentH},0.1) end)
            hitBtn.MouseLeave:Connect(function()   Tw(inner,{BackgroundColor3=T.Accent,Size=UDim2.new(1,-14,0,h-18),Position=UDim2.new(0,7,1,-(h-11))},0.12) end)
            hitBtn.MouseButton1Down:Connect(function() Tw(inner,{BackgroundColor3=T.AccentD,Size=UDim2.new(1,-18,0,h-20),Position=UDim2.new(0,9,1,-(h-12))},0.07) end)
            hitBtn.MouseButton1Up:Connect(function()   Tw(inner,{BackgroundColor3=T.Accent,Size=UDim2.new(1,-14,0,h-18),Position=UDim2.new(0,7,1,-(h-11))},0.1) end)
            hitBtn.MouseButton1Click:Connect(function() if cb then task.spawn(cb) end end)
            regEl(f,text,name)
            return {Frame=f}
        end

        function Tab:Slider(opts)
            local key  = opts.key or ""
            local text = opts.text or "Slider"
            local desc = opts.desc or ""
            local min  = opts.min or 0
            local max  = opts.max or 100
            local def  = loadEl(key, opts.default or min)
            local suf  = opts.suffix or ""
            local cb   = opts.callback
            local val  = math.clamp(def,min,max)
            local pct  = (val-min)/(max-min)
            local drag = false
            local h = (desc~="") and 58 or 50

            local f = elBase(scroll,h)
            New("TextLabel",{
                Size=UDim2.new(1,-90,0,14),Position=UDim2.new(0,12,0,8),
                BackgroundTransparency=1,Text=text,TextColor3=T.white,
                TextSize=12,Font=Enum.Font.GothamBold,
                TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,Parent=f,
            })
            if desc~="" then
                New("TextLabel",{
                    Size=UDim2.new(1,-90,0,10),Position=UDim2.new(0,12,0,23),
                    BackgroundTransparency=1,Text=desc,TextColor3=T.sub,
                    TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,Parent=f,
                })
            end
            local valFr = New("Frame",{
                Size=UDim2.new(0,58,0,20),Position=UDim2.new(1,-68,0,6),
                BackgroundColor3=Color3.fromRGB(32,32,32),BorderSizePixel=0,ZIndex=4,Parent=f,
            })
            Corner(5,valFr)
            local valLbl = New("TextLabel",{
                Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
                Text=tostring(val)..suf,TextColor3=T.Accent,
                TextSize=10,Font=Enum.Font.GothamBold,
                TextXAlignment=Enum.TextXAlignment.Center,ZIndex=5,Parent=valFr,
            })

            local railY = (desc~="") and 40 or 32
            local rail = New("Frame",{
                Size=UDim2.new(1,-22,0,5),Position=UDim2.new(0,11,0,railY),
                BackgroundColor3=Color3.fromRGB(34,34,34),BorderSizePixel=0,ZIndex=4,Parent=f,
            })
            Corner(3,rail)
            GradC(Color3.fromRGB(48,48,48),Color3.fromRGB(24,24,24),90,rail)
            local fill=New("Frame",{Size=UDim2.new(pct,0,1,0),BackgroundColor3=T.Accent,BorderSizePixel=0,ZIndex=5,Parent=rail})
            Corner(3,fill) GradC(T.AccentH,T.Accent,0,fill)
            local knob=New("Frame",{
                Size=UDim2.new(0,13,0,13),Position=UDim2.new(pct,-6.5,0.5,-6.5),
                BackgroundColor3=T.white,BorderSizePixel=0,ZIndex=6,Parent=rail,
            })
            Corner(7,knob) GradC(Color3.fromRGB(255,255,255),Color3.fromRGB(180,180,180),90,knob)
            Stroke(T.Accent,1.5,0,knob)

            local function setV(nv)
                val=math.clamp(math.round(nv),min,max)
                local p=(val-min)/(max-min)
                fill.Size=UDim2.new(p,0,1,0) knob.Position=UDim2.new(p,-6.5,0.5,-6.5)
                valLbl.Text=tostring(val)..suf saveEl(key,val)
                if cb then task.spawn(cb,val) end
            end

            local hit=New("TextButton",{
                Size=UDim2.new(1,0,0,24),Position=UDim2.new(0,0,0,-10),
                BackgroundTransparency=1,Text="",ZIndex=7,Parent=rail,
            })
            hit.MouseButton1Down:Connect(function()
                drag=true
                local mp=UIS:GetMouseLocation() local ab=rail.AbsolutePosition local sz=rail.AbsoluteSize
                setV(min+(max-min)*math.clamp((mp.X-ab.X)/sz.X,0,1))
            end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
            RS.RenderStepped:Connect(function()
                if not drag then return end
                local mp=UIS:GetMouseLocation() local ab=rail.AbsolutePosition local sz=rail.AbsoluteSize
                setV(min+(max-min)*math.clamp((mp.X-ab.X)/sz.X,0,1))
            end)
            regEl(f,text,name)
            if cb then task.spawn(cb,val) end
            return {Set=function(v)setV(v) end,Get=function()return val end,Frame=f}
        end

        function Tab:Dropdown(opts)
            local key  = opts.key or ""
            local text = opts.text or "Dropdown"
            local desc = opts.desc or ""
            local ops  = opts.options or opts.Options or {}
            local def  = loadEl(key, opts.default or (ops[1] or ""))
            local cb   = opts.callback
            local sel  = def
            local open = false
            local h    = (desc~="") and 52 or 44

            local f = elBase(scroll,h) elLabel(f,text,desc)

            local selLbl=New("TextLabel",{
                Size=UDim2.new(0,88,0,16),Position=UDim2.new(1,-122,0.5,-8),
                BackgroundTransparency=1,Text=sel,TextColor3=T.Accent,
                TextSize=10,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Right,
                TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=4,Parent=f,
            })
            local aFr=New("Frame",{
                Size=UDim2.new(0,20,0,20),Position=UDim2.new(1,-30,0.5,-10),
                BackgroundColor3=Color3.fromRGB(30,30,30),BorderSizePixel=0,ZIndex=4,Parent=f,
            })
            Corner(5,aFr)
            local arrow=Img(icon("chevron-down"),aFr,11,UDim2.new(0.5,-5.5,0.5,-5.5),T.sub,5)

            local ITEM_H=28 local PAD=6
            local function panH() return math.min(#ops,7)*ITEM_H+PAD*2 end
            local panel=floatPanel(200,panH())
            panel.Parent=gui
            local pScroll=New("ScrollingFrame",{
                Size=UDim2.new(1,-6,1,-6),Position=UDim2.fromOffset(3,3),
                BackgroundTransparency=1,ScrollBarThickness=3,ScrollBarImageColor3=T.dim,
                CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
                ZIndex=132,Parent=panel,
            })
            New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=pScroll})

            local function closeDP()
                open=false Tw(panel,{Size=UDim2.new(0,panel.AbsoluteSize.X,0,0)},0.13)
                Tw(arrow,{Rotation=0},0.13)
                task.delay(0.14,function() panel.Visible=false panel.Size=UDim2.new(0,panel.AbsoluteSize.X,0,panH()) end)
                for i,fn in ipairs(_openFloats) do if fn==closeDP then table.remove(_openFloats,i) break end end
            end
            local function buildDP()
                for _,c in ipairs(pScroll:GetChildren()) do
                    if not c:IsA("UIListLayout") then c:Destroy() end
                end
                for i,op in ipairs(ops) do
                    local iS=op==sel
                    local ob=New("TextButton",{
                        Size=UDim2.new(1,0,0,ITEM_H),
                        BackgroundColor3=iS and Color3.fromRGB(34,34,34) or Color3.fromRGB(24,24,24),
                        BackgroundTransparency=iS and 0 or 1,
                        BorderSizePixel=0,Text="",AutoButtonColor=false,LayoutOrder=i,ZIndex=133,Parent=pScroll,
                    })
                    Corner(5,ob)
                    if iS then GradC(Color3.fromRGB(42,42,42),Color3.fromRGB(26,26,26),90,ob) Stroke(T.Accent,1,0.62,ob) end
                    New("Frame",{
                        Size=UDim2.new(0,2,0,11),Position=UDim2.fromOffset(4,8.5),
                        BackgroundColor3=T.Accent,BorderSizePixel=0,
                        BackgroundTransparency=iS and 0 or 1,ZIndex=134,Parent=ob,
                    })
                    Corner(1,ob:FindFirstChildWhichIsA("Frame"))
                    New("TextLabel",{
                        Size=UDim2.new(1,-12,1,0),Position=UDim2.fromOffset(10,0),
                        BackgroundTransparency=1,Text=op,
                        TextColor3=iS and T.white or T.whiteD,TextSize=11,Font=Enum.Font.Gotham,
                        TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
                        ZIndex=134,Parent=ob,
                    })
                    ob.MouseEnter:Connect(function() if op~=sel then Tw(ob,{BackgroundTransparency=0,BackgroundColor3=Color3.fromRGB(28,28,28)},0.08) end end)
                    ob.MouseLeave:Connect(function() if op~=sel then Tw(ob,{BackgroundTransparency=1},0.08) end end)
                    ob.MouseButton1Click:Connect(function()
                        sel=op selLbl.Text=sel buildDP() closeDP()
                        saveEl(key,sel) if cb then task.spawn(cb,sel) end
                    end)
                end
                panel.Size=UDim2.new(0,f.AbsoluteSize.X>10 and f.AbsoluteSize.X or 200,0,panH())
            end
            buildDP()
            UIS.InputBegan:Connect(function(inp)
                if inp.UserInputType~=Enum.UserInputType.MouseButton1 then return end
                if not open then return end
                local mp=UIS:GetMouseLocation() local ap=panel.AbsolutePosition local as=panel.AbsoluteSize
                if mp.X<ap.X or mp.X>ap.X+as.X or mp.Y<ap.Y or mp.Y>ap.Y+as.Y then closeDP() end
            end)
            local hitBtn=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=5,Parent=f})
            hitBtn.MouseButton1Click:Connect(function()
                if open then closeDP() return end
                closeAllFloats(closeDP) open=true buildDP()
                panel.Size=UDim2.new(0,f.AbsoluteSize.X,0,0) panel.Visible=true
                anchorFloat(panel,f)
                Tw(panel,{Size=UDim2.new(0,f.AbsoluteSize.X,0,panH())},0.17)
                Tw(arrow,{Rotation=180},0.15)
                table.insert(_openFloats,closeDP)
                f:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                    if open then anchorFloat(panel,f) end
                end)
            end)
            elHover(hitBtn,f) regEl(f,text,name)
            if cb then task.spawn(cb,sel) end
            return {
                Set=function(v)sel=v selLbl.Text=v buildDP() saveEl(key,v) end,
                Get=function()return sel end,
                SetOptions=function(o)ops=o buildDP() end,
                Frame=f,
            }
        end

        function Tab:Keybind(opts)
            local key  = opts.key or ""
            local text = opts.text or "Keybind"
            local desc = opts.desc or ""
            local def  = loadEl(key, opts.default or Enum.KeyCode.Unknown)
            local cb   = opts.callback
            local kc   = def
            local listening = false
            local h = (desc~="") and 52 or 44

            local f = elBase(scroll,h) elLabel(f,text,desc)

            local kbtn=New("TextButton",{
                Size=UDim2.new(0,72,0,20),Position=UDim2.new(1,-82,0.5,-10),
                BackgroundColor3=Color3.fromRGB(26,26,26),BorderSizePixel=0,
                Text=kc.Name,TextColor3=T.Accent,TextSize=10,
                Font=Enum.Font.GothamBold,AutoButtonColor=false,ZIndex=5,Parent=f,
            })
            Corner(5,kbtn) GradC(Color3.fromRGB(38,38,38),Color3.fromRGB(20,20,20),90,kbtn)
            local kS=New("UIStroke",{Color=T.Accent,Thickness=1,Transparency=0.5,Parent=kbtn})

            kbtn.MouseButton1Click:Connect(function()
                closeAllFloats() listening=true kbtn.Text="..."
                kbtn.TextColor3=T.sub Tw(kbtn,{BackgroundColor3=Color3.fromRGB(36,36,36)},0.1) Tw(kS,{Color=T.white,Transparency=0.15},0.1)
            end)
            UIS.InputBegan:Connect(function(inp)
                if not listening then return end
                if inp.UserInputType==Enum.UserInputType.Keyboard then
                    listening=false kc=inp.KeyCode kbtn.Text=kc.Name kbtn.TextColor3=T.Accent
                    Tw(kbtn,{BackgroundColor3=Color3.fromRGB(26,26,26)},0.1) Tw(kS,{Color=T.Accent,Transparency=0.5},0.1)
                    saveEl(key,kc) if cb then task.spawn(cb,kc) end
                end
            end)
            kbtn.MouseEnter:Connect(function() Tw(kbtn,{BackgroundColor3=Color3.fromRGB(34,34,34)},0.1) end)
            kbtn.MouseLeave:Connect(function() Tw(kbtn,{BackgroundColor3=Color3.fromRGB(26,26,26)},0.1) end)
            regEl(f,text,name)
            return {Set=function(k)kc=k kbtn.Text=k.Name saveEl(key,k) end,Get=function()return kc end,Frame=f}
        end

        function Tab:ColorPicker(opts)
            local key  = opts.key or ""
            local text = opts.text or "Color"
            local desc = opts.desc or ""
            local def  = loadEl(key, opts.default or Color3.fromRGB(255,80,80))
            local cb   = opts.callback
            local color = def
            local H,S,V = Color3.toHSV(color)
            local open=false local svDrag=false local hueDrag=false
            local SW=172 local SH=140 local HW=13 local G=7 local HEH=27 local P=8
            local TW2=SW+G+HW+P*2 local TH2=SH+G+HEH+P*2
            local el_h = (desc~="") and 52 or 44

            local f = elBase(scroll,el_h) elLabel(f,text,desc)

            local sw=New("Frame",{
                Size=UDim2.new(0,22,0,22),Position=UDim2.new(1,-32,0.5,-11),
                BackgroundColor3=color,BorderSizePixel=0,ZIndex=5,Parent=f,
            })
            Corner(5,sw) Stroke(Color3.fromRGB(75,75,75),1,0,sw)

            local panel=floatPanel(TW2,TH2) panel.Parent=gui

            local svBox=New("Frame",{
                Size=UDim2.fromOffset(SW,SH),Position=UDim2.fromOffset(P,P),
                BackgroundColor3=Color3.fromHSV(H,1,1),
                BorderSizePixel=0,ClipsDescendants=true,ZIndex=132,Parent=panel,
            })
            Corner(6,svBox) Stroke(Color3.fromRGB(48,48,48),1,0.4,svBox)
            local svW2=New("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=133,Parent=svBox})
            New("UIGradient",{Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}),Parent=svW2})
            local svB2=New("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,ZIndex=134,Parent=svBox})
            New("UIGradient",{Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)}),Rotation=90,Parent=svB2})
            local svKn=New("Frame",{
                Size=UDim2.fromOffset(11,11),Position=UDim2.new(S,-5.5,1-V,-5.5),
                BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=135,Parent=svBox,
            })
            Corner(6,svKn) Stroke(Color3.new(1,1,1),2,0,svKn)

            local hueFr=New("Frame",{
                Size=UDim2.fromOffset(HW,SH),Position=UDim2.fromOffset(P+SW+G,P),
                BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=132,Parent=panel,
            })
            Corner(7,hueFr) Stroke(Color3.fromRGB(48,48,48),1,0.4,hueFr)
            local hKeys={}
            for i=0,6 do table.insert(hKeys,ColorSequenceKeypoint.new(i/6,Color3.fromHSV(i/6,1,1))) end
            New("UIGradient",{Color=ColorSequence.new(hKeys),Rotation=90,Parent=hueFr})
            local hueKn=New("Frame",{
                Size=UDim2.fromOffset(19,7),Position=UDim2.new(0.5,-9.5,H,-3.5),
                BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=133,Parent=hueFr,
            })
            Corner(4,hueKn) Stroke(Color3.fromRGB(165,165,165),1.5,0,hueKn)

            local hexY2=P+SH+G
            local hexFr2=New("Frame",{
                Size=UDim2.fromOffset(SW+G+HW,HEH),Position=UDim2.fromOffset(P,hexY2),
                BackgroundColor3=T.inputBg,BorderSizePixel=0,ZIndex=132,Parent=panel,
            })
            Corner(6,hexFr2) Stroke(T.border,1,0.28,hexFr2)
            New("TextLabel",{
                Size=UDim2.new(0,16,1,0),Position=UDim2.fromOffset(7,0),
                BackgroundTransparency=1,Text="#",TextColor3=T.Accent,
                TextSize=12,Font=Enum.Font.GothamBold,
                TextXAlignment=Enum.TextXAlignment.Center,ZIndex=133,Parent=hexFr2,
            })
            local hexIn=New("TextBox",{
                Size=UDim2.new(1,-46,1,0),Position=UDim2.fromOffset(20,0),
                BackgroundTransparency=1,Text=color:ToHex():upper(),
                PlaceholderText="RRGGBB",PlaceholderColor3=T.dim,
                TextColor3=T.white,TextSize=11,Font=Enum.Font.GothamBold,
                TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false,
                ZIndex=133,Parent=hexFr2,
            })
            local hexSw2=New("Frame",{
                Size=UDim2.new(0,15,0,15),Position=UDim2.new(1,-20,0.5,-7.5),
                BackgroundColor3=color,BorderSizePixel=0,ZIndex=133,Parent=hexFr2,
            })
            Corner(4,hexSw2) Stroke(Color3.fromRGB(62,62,62),1,0,hexSw2)

            local function updAll()
                color=Color3.fromHSV(H,S,V)
                sw.BackgroundColor3=color hexSw2.BackgroundColor3=color
                svBox.BackgroundColor3=Color3.fromHSV(H,1,1)
                svKn.Position=UDim2.new(S,-5.5,1-V,-5.5)
                hueKn.Position=UDim2.new(0.5,-9.5,H,-3.5)
                hexIn.Text=color:ToHex():upper()
                saveEl(key,color) if cb then task.spawn(cb,color) end
            end

            hexIn.FocusLost:Connect(function(enter)
                if not enter then return end
                local txt=hexIn.Text:gsub("#","")
                local ok2,c2=pcall(Color3.fromHex,txt)
                if ok2 and typeof(c2)=="Color3" then H,S,V=Color3.toHSV(c2) updAll()
                else hexIn.Text=color:ToHex():upper() end
            end)

            local svHit2=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=136,Parent=svBox})
            local hueHit2=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=134,Parent=hueFr})
            svHit2.MouseButton1Down:Connect(function() svDrag=true end)
            hueHit2.MouseButton1Down:Connect(function() hueDrag=true end)
            UIS.InputEnded:Connect(function(i2)
                if i2.UserInputType==Enum.UserInputType.MouseButton1 then svDrag=false hueDrag=false end
            end)
            RS.RenderStepped:Connect(function()
                if svDrag then
                    local mp2=UIS:GetMouseLocation() local ab2=svBox.AbsolutePosition local sz2=svBox.AbsoluteSize
                    S=math.clamp((mp2.X-ab2.X)/sz2.X,0,1) V=1-math.clamp((mp2.Y-ab2.Y)/sz2.Y,0,1)
                    updAll()
                end
                if hueDrag then
                    local mp2=UIS:GetMouseLocation() local ab2=hueFr.AbsolutePosition local sz2=hueFr.AbsoluteSize
                    H=math.clamp((mp2.Y-ab2.Y)/sz2.Y,0,1) updAll()
                end
            end)

            local function closeCP2()
                open=false Tw(panel,{Size=UDim2.fromOffset(TW2,0)},0.13)
                task.delay(0.14,function() panel.Visible=false panel.Size=UDim2.fromOffset(TW2,TH2) end)
                for i3,fn3 in ipairs(_openFloats) do if fn3==closeCP2 then table.remove(_openFloats,i3) break end end
            end
            UIS.InputBegan:Connect(function(i4)
                if i4.UserInputType~=Enum.UserInputType.MouseButton1 then return end
                if not open then return end
                local mp4=UIS:GetMouseLocation() local ap4=panel.AbsolutePosition local as4=panel.AbsoluteSize
                if mp4.X<ap4.X or mp4.X>ap4.X+as4.X or mp4.Y<ap4.Y or mp4.Y>ap4.Y+as4.Y then closeCP2() end
            end)

            local tBtn2=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=6,Parent=f})
            tBtn2.MouseButton1Click:Connect(function()
                if open then closeCP2() return end
                closeAllFloats(closeCP2) open=true
                panel.Size=UDim2.fromOffset(TW2,0) panel.Visible=true
                anchorFloat(panel,f)
                Tw(panel,{Size=UDim2.fromOffset(TW2,TH2)},0.17)
                table.insert(_openFloats,closeCP2)
                f:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                    if open then anchorFloat(panel,f) end
                end)
            end)
            elHover(tBtn2,f) regEl(f,text,name)
            if cb then task.spawn(cb,color) end
            return {Set=function(c3)color=c3 H,S,V=Color3.toHSV(c3) updAll() end,Get=function()return color end,Frame=f}
        end

        return Tab
    end

    function Win:Section(text)
        -- helper to add section to sidebar (not used in tab context, placeholder)
    end

    function Win:AddSection(text)
        addSec(text)
    end

    return setmetatable(Win, {__index = Win})
end

-- Convenience: predefined tabs
function EcoHub:QuickSetup(opts)
    opts = opts or {}
    local win = self:Window(opts)
    local tabs_out = {}
    local sections = opts.tabs or {
        {name="Main",    icon="home"},
        {name="Aimbot",  icon="crosshair"},
        {name="Misc",    icon="electricity"},
        {name="ESP",     icon="eye"},
        {name="Protect", icon="shield"},
        {name="Config",  icon="settings"},
    }
    for _,t in ipairs(sections) do
        tabs_out[t.name] = win:Tab(t.name, t.icon)
    end
    return win, tabs_out
end

return EcoHub
