local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")


local Theme = {
    bg              = Color3.fromRGB(14, 12, 18),
    topbar          = Color3.fromRGB(20, 17, 26),
    topbarLine      = Color3.fromRGB(55, 40, 75),
    pageArea        = Color3.fromRGB(16, 14, 22),
    section         = Color3.fromRGB(22, 18, 30),
    sectionBorder   = Color3.fromRGB(55, 40, 75),
    sectionHeader   = Color3.fromRGB(18, 15, 26),
    card            = Color3.fromRGB(28, 22, 38),
    tabbar          = Color3.fromRGB(14, 12, 18),
    tabbarLine      = Color3.fromRGB(45, 32, 65),
    accentHi        = Color3.fromRGB(190, 130, 255),
    accentMid       = Color3.fromRGB(130, 80, 200),
    accentLo        = Color3.fromRGB(55, 28, 90),
    text            = Color3.fromRGB(235, 225, 255),
    muted           = Color3.fromRGB(140, 120, 170),
    dim             = Color3.fromRGB(75, 60, 100),
    elemBorder      = Color3.fromRGB(60, 45, 85),
}

-- ╔══════════════════════════════╗
-- ║         LUCIDE ICONS         ║
-- ╚══════════════════════════════╝
local Icons = {
    home        = "rbxassetid://10723407389",
    eye         = "rbxassetid://10723346959",
    settings    = "rbxassetid://10734950309",
    star        = "rbxassetid://10734966248",
    user        = "rbxassetid://10747373176",
    shield      = "rbxassetid://10734951847",
    zap         = "rbxassetid://10723345749",
    sword       = "rbxassetid://10734975486",
    crosshair   = "rbxassetid://10709818534",
    target      = "rbxassetid://10734977012",
    bolt        = "rbxassetid://10723345749",
    layers      = "rbxassetid://10723424505",
    compass     = "rbxassetid://10709811445",
    ghost       = "rbxassetid://10723396107",
    flame       = "rbxassetid://10723376114",
    crown       = "rbxassetid://10709818626",
    gem         = "rbxassetid://10723396000",
    trophy      = "rbxassetid://10747363809",
    search      = "rbxassetid://10734943674",
    info        = "rbxassetid://10723415903",
    ["alert-triangle"] = "rbxassetid://10709753149",
    check       = "rbxassetid://10709790644",
    x           = "rbxassetid://10747384394",
    plus        = "rbxassetid://10734924532",
    minus       = "rbxassetid://10734896206",
    toggle      = "rbxassetid://10734984834",
    sliders     = "rbxassetid://10734963400",
    activity    = "rbxassetid://10709752035",
    trending    = "rbxassetid://10747363465",
    map         = "rbxassetid://10734886202",
    bell        = "rbxassetid://10709775704",
    lock        = "rbxassetid://10723434711",
    key         = "rbxassetid://10723416652",
    code        = "rbxassetid://10709810463",
    cpu         = "rbxassetid://10709813383",
    wifi        = "rbxassetid://10747382504",
    database    = "rbxassetid://10709818996",
}

-- ╔══════════════════════════════╗
-- ║         UTILITIES            ║
-- ╚══════════════════════════════╝
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
        TweenInfo.new(dur or 0.22, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props):Play()
end

-- Ripple muito sutil, sem spam
local rippleCooldown = false
local function spawnRipple(frame, relX, relY)
    if rippleCooldown then return end
    rippleCooldown = true
    task.delay(0.35, function() rippleCooldown = false end)

    local sz   = frame.AbsoluteSize
    local maxR = math.min(sz.X, sz.Y) * 0.45
    local s0   = 4
    local rip  = ni("Frame", {
        Size                   = UDim2.new(0, s0, 0, s0),
        Position               = UDim2.new(0, relX - s0/2, 0, relY - s0/2),
        BackgroundColor3       = Theme.accentHi,
        BackgroundTransparency = 0.78,
        BorderSizePixel        = 0,
        ZIndex                 = 30,
    }, frame)
    corner(rip, maxR)

    local endS = maxR * 2
    TweenService:Create(rip, TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size                   = UDim2.new(0, endS, 0, endS),
        Position               = UDim2.new(0, relX - endS/2, 0, relY - endS/2),
        BackgroundTransparency = 0.92,
    }):Play()
    task.delay(0.38, function()
        TweenService:Create(rip, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
            BackgroundTransparency = 1,
        }):Play()
        task.delay(0.2, function() rip:Destroy() end)
    end)
end

-- ╔══════════════════════════════╗
-- ║          LIBRARY             ║
-- ╚══════════════════════════════╝
local UILib = {}
UILib.__index = UILib

function UILib.new(config)
    config = config or {}

    local W, H   = 800, 500
    local ICON_S = 18
    local SMALL  = 48
    local EXPAND = 144

    if PlayerGui:FindFirstChild("EcoHubGui") then
        PlayerGui.EcoHubGui:Destroy()
    end

    local ScreenGui = ni("ScreenGui", {
        Name           = "EcoHubGui",
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, PlayerGui)

    -- ── Main Frame ──────────────────────────────────────────────────────────
    local Main = ni("Frame", {
        Size             = UDim2.new(0, W, 0, H),
        Position         = UDim2.new(0.5, -W/2, 0.5, -H/2),
        BackgroundColor3 = Theme.bg,
        BorderSizePixel  = 0,
        Active           = true,
        Draggable        = true,
        ClipsDescendants = true,
    }, ScreenGui)
    corner(Main, 12)
    ni("UIStroke", {Color = Theme.accentLo, Thickness = 1.5}, Main)

    -- ── Top Bar ─────────────────────────────────────────────────────────────
    local TopBar = ni("Frame", {
        Size             = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Theme.topbar,
        BorderSizePixel  = 0,
    }, Main)
    corner(TopBar, 12)
    -- square off bottom corners
    ni("Frame", {
        Size             = UDim2.new(1, 0, 0, 12),
        Position         = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = Theme.topbar,
        BorderSizePixel  = 0,
    }, TopBar)
    -- bottom border line
    ni("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Theme.topbarLine,
        BorderSizePixel  = 0,
    }, TopBar)

    -- Accent dot
    ni("Frame", {
        Size             = UDim2.new(0, 7, 0, 7),
        Position         = UDim2.new(0, 12, 0.5, -3),
        BackgroundColor3 = Theme.accentHi,
        BorderSizePixel  = 0,
    }, TopBar)
    corner(TopBar:FindFirstChildWhichIsA("Frame", true) or TopBar, 4)

    -- Title
    ni("TextLabel", {
        Size                   = UDim2.new(0, 300, 1, 0),
        Position               = UDim2.new(0, 24, 0, 0),
        BackgroundTransparency = 1,
        Text                   = config.Title or "Eco Hub",
        TextColor3             = Theme.text,
        TextSize               = 15,
        Font                   = Enum.Font.GothamBold,
        TextXAlignment         = Enum.TextXAlignment.Left,
    }, TopBar)

    -- Subtitle / version badge
    if config.Sub then
        ni("TextLabel", {
            Size                   = UDim2.new(0, 120, 0, 18),
            Position               = UDim2.new(0, 0, 0.5, -9),
            AnchorPoint            = Vector2.new(0, 0),
            BackgroundTransparency = 1,
            Text                   = config.Sub,
            TextColor3             = Theme.muted,
            TextSize               = 9,
            Font                   = Enum.Font.Gotham,
            TextXAlignment         = Enum.TextXAlignment.Left,
        }, TopBar).Position = UDim2.new(1, -130, 0.5, -9)
    end

    -- ── Page Area ───────────────────────────────────────────────────────────
    local PageArea = ni("Frame", {
        Size             = UDim2.new(1, -16, 1, -106),
        Position         = UDim2.new(0, 8, 0, 52),
        BackgroundColor3 = Theme.pageArea,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
    }, Main)
    corner(PageArea, 10)
    ni("UIStroke", {Color = Theme.sectionBorder, Thickness = 1}, PageArea)

    -- ── Tab Bar ─────────────────────────────────────────────────────────────
    local TabBar = ni("Frame", {
        Size             = UDim2.new(1, 0, 0, 50),
        Position         = UDim2.new(0, 0, 1, -50),
        BackgroundColor3 = Theme.tabbar,
        BorderSizePixel  = 0,
    }, Main)
    corner(TabBar, 12)
    ni("Frame", {
        Size             = UDim2.new(1, 0, 0, 12),
        BackgroundColor3 = Theme.tabbar,
        BorderSizePixel  = 0,
    }, TabBar)
    ni("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Theme.tabbarLine,
        BorderSizePixel  = 0,
    }, TabBar)

    -- ── Tab state ───────────────────────────────────────────────────────────
    local tabList  = {}
    local tabBtns  = {}
    local pages    = {}
    local curTab   = nil
    local animating = false

    local function calcPositions(activeIdx)
        local pos = {}
        local x = 0
        for i = 1, #tabList do
            local w = (i == activeIdx) and EXPAND or SMALL
            pos[i] = {x = x, w = w}
            x = x + w
        end
        local offset = math.floor((W - x) / 2)
        for i = 1, #tabList do pos[i].x = pos[i].x + offset end
        return pos
    end

    local function refreshTabPositions(activeName)
        local activeIdx = 1
        for i, t in ipairs(tabList) do
            if t.name == activeName then activeIdx = i break end
        end
        local positions = calcPositions(activeIdx)
        for i, tb in ipairs(tabBtns) do
            local active = tabList[i].name == activeName
            local p = positions[i]
            tw(tb.bg, {Position = UDim2.new(0, p.x, 0, 0), Size = UDim2.new(0, p.w, 1, 0)}, 0.28)
            if active then
                tw(tb.sq,  {BackgroundColor3 = Theme.accentLo}, 0.22)
                tw(tb.str, {Color = Theme.accentMid, Thickness = 1.5}, 0.22)
                tw(tb.img, {ImageColor3 = Theme.accentHi}, 0.22)
                tw(tb.lbl, {TextColor3 = Theme.text,  TextTransparency = 0}, 0.22)
                tw(tb.sub, {TextColor3 = Theme.muted, TextTransparency = 0}, 0.22)
            else
                tw(tb.sq,  {BackgroundColor3 = Theme.card}, 0.22)
                tw(tb.str, {Color = Theme.elemBorder, Thickness = 1}, 0.22)
                tw(tb.img, {ImageColor3 = Theme.dim}, 0.22)
                tw(tb.lbl, {TextTransparency = 1}, 0.15)
                tw(tb.sub, {TextTransparency = 1}, 0.15)
            end
        end
    end

    local function switchTo(name)
        if curTab == name then return end
        if curTab and pages[curTab] then pages[curTab].Visible = false end
        curTab = name
        pages[name].Visible = true
        refreshTabPositions(name)
    end

    -- ── Show / Hide ─────────────────────────────────────────────────────────
    local function showGui()
        if animating then return end
        animating = true
        Main.Visible  = true
        Main.Size     = UDim2.new(0, W, 0, 0)
        Main.Position = UDim2.new(0.5, -W/2, 0.5, 0)
        tw(Main, {Size = UDim2.new(0, W, 0, H), Position = UDim2.new(0.5, -W/2, 0.5, -H/2)},
            0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.delay(0.4, function() animating = false end)
    end

    local function hideGui()
        if animating then return end
        animating = true
        tw(Main, {Size = UDim2.new(0, W, 0, 0), Position = UDim2.new(0.5, -W/2, 0.5, 0)},
            0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.delay(0.3, function()
            Main.Visible  = false
            Main.Size     = UDim2.new(0, W, 0, H)
            Main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
            animating     = false
        end)
    end

    local visible = true
    local toggleKey = config.Toggle or Enum.KeyCode.LeftAlt

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == toggleKey or input.KeyCode == Enum.KeyCode.RightAlt then
            if visible then visible = false hideGui()
            else visible = true showGui() end
        end
    end)

    -- ╔══════════════════════════════════════════════════════════════════╗
    -- ║                        WINDOW OBJECT                            ║
    -- ╚══════════════════════════════════════════════════════════════════╝
    local Window = {}

    -- Expõe Icons para uso externo
    Window.Icons = Icons

    function Window:AddTab(cfg)
        cfg = cfg or {}
        local name    = cfg.Name or ("Tab"..tostring(#tabList+1))
        local subText = cfg.Sub  or ""
        local iconId  = cfg.Icon or Icons.home

        -- Se o icon for string de nome, resolver para id
        if type(iconId) == "string" and not iconId:match("rbxasset") then
            iconId = Icons[iconId] or Icons.home
        end

        -- Página
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

        -- Reposicionar botões existentes
        for i, tb in ipairs(tabBtns) do
            local p = positions[i]
            tb.bg.Position = UDim2.new(0, p.x, 0, 0)
            tb.bg.Size     = UDim2.new(0, p.w, 1, 0)
        end

        -- Botão desta tab
        local p  = positions[idx]
        local bg = ni("Frame", {
            Size                   = UDim2.new(0, SMALL, 1, 0),
            Position               = UDim2.new(0, p.x, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            ClipsDescendants       = true,
        }, TabBar)

        local sq = ni("Frame", {
            Size             = UDim2.new(0, 32, 0, 32),
            Position         = UDim2.new(0, 8, 0.5, -16),
            BackgroundColor3 = Theme.card,
            BorderSizePixel  = 0,
        }, bg)
        corner(sq, 8)
        local sqStr = ni("UIStroke", {Color = Theme.elemBorder, Thickness = 1}, sq)

        local img = ni("ImageLabel", {
            Size                   = UDim2.new(0, ICON_S, 0, ICON_S),
            Position               = UDim2.new(0.5, -ICON_S/2, 0.5, -ICON_S/2),
            BackgroundTransparency = 1,
            Image                  = iconId,
            ImageColor3            = Theme.dim,
        }, sq)

        local lbl = ni("TextLabel", {
            Size                   = UDim2.new(1, -50, 0, 14),
            Position               = UDim2.new(0, 46, 0.5, -13),
            BackgroundTransparency = 1,
            Text                   = name,
            TextColor3             = Theme.text,
            TextSize               = 11,
            Font                   = Enum.Font.GothamBold,
            TextXAlignment         = Enum.TextXAlignment.Left,
            TextTransparency       = 1,
        }, bg)

        local sub_lbl = ni("TextLabel", {
            Size                   = UDim2.new(1, -50, 0, 10),
            Position               = UDim2.new(0, 46, 0.5, 3),
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

        local tbEntry = {name=name, bg=bg, sq=sq, str=sqStr, img=img, lbl=lbl, sub=sub_lbl}
        tabBtns[idx] = tbEntry

        btn.MouseButton1Click:Connect(function()
            switchTo(name)
        end)
        btn.MouseEnter:Connect(function()
            if curTab ~= name then
                tw(sq,  {BackgroundColor3 = Color3.fromRGB(35, 26, 48)}, 0.12)
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

        -- ╔══════════════════════════════════════════════════════════════════╗
        -- ║                         TAB OBJECT                               ║
        -- ╚══════════════════════════════════════════════════════════════════╝
        local Tab = {}
        Tab._page = pg

        --[[
            AddSection(cfg)
            cfg.Name   = "Nome"
            cfg.Icon   = Icons.home  (ou string do nome: "home")
            cfg.Side   = "left" | "center" | "right"
        ]]
        function Tab:AddSection(scfg)
            scfg = scfg or {}
            local sName = scfg.Name or "Section"
            local sIcon = scfg.Icon or Icons.settings
            local side  = scfg.Side or "left"

            -- Resolver icon por nome
            if type(sIcon) == "string" and not sIcon:match("rbxasset") then
                sIcon = Icons[sIcon] or Icons.settings
            end

            -- ── Layout 3 colunas fixas ────────────────────────────────────
            --   left   : 0%    → 30%
            --   center : 30%   → 65%  (35%)
            --   right  : 65%   → 100% (35%)
            local xPct, wPct
            if side == "left" then
                xPct = 0.00;  wPct = 0.30
            elseif side == "center" then
                xPct = 0.30;  wPct = 0.35
            else -- right
                xPct = 0.65;  wPct = 0.35
            end

            local GAP = 5

            local outer = ni("Frame", {
                Size             = UDim2.new(wPct, -GAP, 1, -GAP * 2),
                Position         = UDim2.new(xPct, GAP, 0, GAP),
                BackgroundColor3 = Theme.section,
                BorderSizePixel  = 0,
                ClipsDescendants = true,
            }, pg)
            corner(outer, 10)
            ni("UIStroke", {Color = Theme.sectionBorder, Thickness = 1}, outer)

            -- ── Section Header ────────────────────────────────────────────
            local header = ni("Frame", {
                Size             = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = Theme.sectionHeader,
                BorderSizePixel  = 0,
            }, outer)
            corner(header, 10)
            ni("Frame", {
                Size             = UDim2.new(1, 0, 0, 10),
                Position         = UDim2.new(0, 0, 1, -10),
                BackgroundColor3 = Theme.sectionHeader,
                BorderSizePixel  = 0,
            }, header)
            -- accent bottom line
            ni("Frame", {
                Size             = UDim2.new(1, 0, 0, 1),
                Position         = UDim2.new(0, 0, 1, -1),
                BackgroundColor3 = Theme.accentLo,
                BorderSizePixel  = 0,
            }, header)

            ni("ImageLabel", {
                Size                   = UDim2.new(0, 14, 0, 14),
                Position               = UDim2.new(0, 10, 0.5, -7),
                BackgroundTransparency = 1,
                Image                  = sIcon,
                ImageColor3            = Theme.accentHi,
            }, header)
            ni("TextLabel", {
                Size                   = UDim2.new(1, -32, 1, 0),
                Position               = UDim2.new(0, 28, 0, 0),
                BackgroundTransparency = 1,
                Text                   = sName,
                TextColor3             = Theme.text,
                TextSize               = 11,
                Font                   = Enum.Font.GothamBold,
                TextXAlignment         = Enum.TextXAlignment.Left,
            }, header)

            -- ── Scroll Content ────────────────────────────────────────────
            local scroll = ni("ScrollingFrame", {
                Size                 = UDim2.new(1, 0, 1, -36),
                Position             = UDim2.new(0, 0, 0, 36),
                BackgroundTransparency = 1,
                BorderSizePixel      = 0,
                ScrollBarThickness   = 2,
                ScrollBarImageColor3 = Theme.accentMid,
                CanvasSize           = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize  = Enum.AutomaticSize.Y,
                ScrollingDirection   = Enum.ScrollingDirection.Y,
                ElasticBehavior      = Enum.ElasticBehavior.Never,
            }, outer)
            ni("UIPadding", {
                PaddingTop    = UDim.new(0, 6),
                PaddingBottom = UDim.new(0, 6),
                PaddingLeft   = UDim.new(0, 5),
                PaddingRight  = UDim.new(0, 5),
            }, scroll)
            ni("UIListLayout", {
                Padding         = UDim.new(0, 4),
                FillDirection   = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder       = Enum.SortOrder.LayoutOrder,
            }, scroll)

            -- Ripple sutil ao clicar na section
            local hitbox = ni("TextButton", {
                Size                   = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text                   = "",
                BorderSizePixel        = 0,
                ZIndex                 = 19,
            }, outer)
            hitbox.MouseButton1Down:Connect(function(x, y)
                local abs = outer.AbsolutePosition
                spawnRipple(outer, x - abs.X, y - abs.Y)
            end)

            -- ╔════════════════════════════════════════════════════════╗
            -- ║                    SECTION OBJECT                       ║
            -- ╚════════════════════════════════════════════════════════╝
            local Section = {}
            Section._scroll = scroll

            -- ── Button ───────────────────────────────────────────────
            function Section:AddButton(bcfg)
                bcfg = bcfg or {}
                local bIcon = bcfg.Icon or Icons.check
                if type(bIcon) == "string" and not bIcon:match("rbxasset") then
                    bIcon = Icons[bIcon] or Icons.check
                end

                local row = ni("Frame", {
                    Size             = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Theme.card,
                    BorderSizePixel  = 0,
                    LayoutOrder      = bcfg.Order or 0,
                }, scroll)
                corner(row, 7)
                ni("UIStroke", {Color = Theme.elemBorder, Thickness = 1}, row)

                ni("ImageLabel", {
                    Size                   = UDim2.new(0, 14, 0, 14),
                    Position               = UDim2.new(0, 9, 0.5, -7),
                    BackgroundTransparency = 1,
                    Image                  = bIcon,
                    ImageColor3            = Theme.accentHi,
                }, row)
                ni("TextLabel", {
                    Size                   = UDim2.new(1, -30, 1, 0),
                    Position               = UDim2.new(0, 28, 0, 0),
                    BackgroundTransparency = 1,
                    Text                   = bcfg.Name or "Button",
                    TextColor3             = Theme.text,
                    TextSize               = 11,
                    Font                   = Enum.Font.Gotham,
                    TextXAlignment         = Enum.TextXAlignment.Left,
                }, row)

                local rowBtn = ni("TextButton", {
                    Size                   = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text                   = "",
                    ZIndex                 = 5,
                }, row)

                rowBtn.MouseEnter:Connect(function()
                    tw(row, {BackgroundColor3 = Color3.fromRGB(38, 28, 55)}, 0.12)
                end)
                rowBtn.MouseLeave:Connect(function()
                    tw(row, {BackgroundColor3 = Theme.card}, 0.12)
                end)
                rowBtn.MouseButton1Click:Connect(function()
                    if bcfg.Callback then
                        task.spawn(bcfg.Callback)
                    end
                end)

                return row
            end

            -- ── Toggle ───────────────────────────────────────────────
            function Section:AddToggle(tcfg)
                tcfg = tcfg or {}
                local tIcon = tcfg.Icon or Icons.toggle
                if type(tIcon) == "string" and not tIcon:match("rbxasset") then
                    tIcon = Icons[tIcon] or Icons.toggle
                end
                local state = tcfg.Default or false

                local row = ni("Frame", {
                    Size             = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Theme.card,
                    BorderSizePixel  = 0,
                    LayoutOrder      = tcfg.Order or 0,
                }, scroll)
                corner(row, 7)
                ni("UIStroke", {Color = Theme.elemBorder, Thickness = 1}, row)

                ni("ImageLabel", {
                    Size                   = UDim2.new(0, 14, 0, 14),
                    Position               = UDim2.new(0, 9, 0.5, -7),
                    BackgroundTransparency = 1,
                    Image                  = tIcon,
                    ImageColor3            = Theme.accentHi,
                }, row)
                ni("TextLabel", {
                    Size                   = UDim2.new(1, -60, 1, 0),
                    Position               = UDim2.new(0, 28, 0, 0),
                    BackgroundTransparency = 1,
                    Text                   = tcfg.Name or "Toggle",
                    TextColor3             = Theme.text,
                    TextSize               = 11,
                    Font                   = Enum.Font.Gotham,
                    TextXAlignment         = Enum.TextXAlignment.Left,
                }, row)

                -- Track
                local track = ni("Frame", {
                    Size             = UDim2.new(0, 30, 0, 15),
                    Position         = UDim2.new(1, -38, 0.5, -7),
                    BackgroundColor3 = state and Theme.accentMid or Theme.dim,
                    BorderSizePixel  = 0,
                }, row)
                corner(track, 8)

                local knob = ni("Frame", {
                    Size             = UDim2.new(0, 11, 0, 11),
                    Position         = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5),
                    BackgroundColor3 = Theme.text,
                    BorderSizePixel  = 0,
                }, track)
                corner(knob, 6)

                local rowBtn = ni("TextButton", {
                    Size                   = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text                   = "",
                    ZIndex                 = 5,
                }, row)

                rowBtn.MouseEnter:Connect(function()
                    tw(row, {BackgroundColor3 = Color3.fromRGB(38, 28, 55)}, 0.12)
                end)
                rowBtn.MouseLeave:Connect(function()
                    tw(row, {BackgroundColor3 = Theme.card}, 0.12)
                end)
                rowBtn.MouseButton1Click:Connect(function()
                    state = not state
                    tw(track, {BackgroundColor3 = state and Theme.accentMid or Theme.dim}, 0.18)
                    tw(knob,  {Position = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)}, 0.18)
                    if tcfg.Callback then
                        task.spawn(tcfg.Callback, state)
                    end
                end)

                local tog = {}
                function tog:Set(v)
                    state = v
                    tw(track, {BackgroundColor3 = state and Theme.accentMid or Theme.dim}, 0.18)
                    tw(knob,  {Position = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)}, 0.18)
                end
                function tog:Get() return state end
                return tog
            end

            -- ── Label ────────────────────────────────────────────────
            function Section:AddLabel(lcfg)
                lcfg = lcfg or {}
                local lbl = ni("TextLabel", {
                    Size                   = UDim2.new(1, 0, 0, 22),
                    BackgroundTransparency = 1,
                    Text                   = lcfg.Text or "",
                    TextColor3             = lcfg.Color or Theme.muted,
                    TextSize               = lcfg.Size or 10,
                    Font                   = Enum.Font.Gotham,
                    TextXAlignment         = Enum.TextXAlignment.Left,
                    TextWrapped            = true,
                    LayoutOrder            = lcfg.Order or 0,
                }, scroll)
                ni("UIPadding", {PaddingLeft = UDim.new(0, 8)}, lbl)
                return lbl
            end

            -- ── Separator ────────────────────────────────────────────
            function Section:AddSeparator()
                ni("Frame", {
                    Size             = UDim2.new(1, -10, 0, 1),
                    BackgroundColor3 = Theme.elemBorder,
                    BorderSizePixel  = 0,
                    LayoutOrder      = 99,
                }, scroll)
            end

            return Section
        end

        return Tab
    end

    return Window
end

return UILib
