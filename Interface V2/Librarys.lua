local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

local ICONS = {
    aim     = "rbxassetid://10709818534",
    visuals = "rbxassetid://10723346959",
    vehicle = "rbxassetid://10709789810",
    players = "rbxassetid://10747373176",
    misc    = "rbxassetid://10723345749",
    config  = "rbxassetid://10734950309",
    home    = "rbxassetid://10723407389",
    star    = "rbxassetid://10734966248",
    shield  = "rbxassetid://10734951847",
    ghost   = "rbxassetid://10723396107",
    flame   = "rbxassetid://10723376114",
    crown   = "rbxassetid://10709818626",
    sword   = "rbxassetid://10734975486",
    target  = "rbxassetid://10734977012",
    lock    = "rbxassetid://10723434711",
    wrench  = "rbxassetid://10747383470",
    skull   = "rbxassetid://10734962068",
    bell    = "rbxassetid://10709775704",
    search  = "rbxassetid://10734943674",
    user    = "rbxassetid://10747373176",
}

local Theme = {
    AcrylicMain     = Color3.fromRGB(30, 30, 30),
    TitleBarLine    = Color3.fromRGB(65, 65, 65),
    InElementBorder = Color3.fromRGB(55, 55, 55),
    bg              = Color3.fromRGB(20, 20, 20),
    pageArea        = Color3.fromRGB(22, 22, 22),
    card            = Color3.fromRGB(30, 30, 30),
    section         = Color3.fromRGB(26, 26, 26),
    tabbar          = Color3.fromRGB(18, 18, 18),
    secBorder       = Color3.fromRGB(50, 50, 50),
    accentHi        = Color3.fromRGB(110, 170, 210),
    accentLo        = Color3.fromRGB(30, 60, 85),
    text            = Color3.fromRGB(235, 235, 235),
    muted           = Color3.fromRGB(130, 130, 130),
    dim             = Color3.fromRGB(70, 70, 70),
}

local W, H = 780, 480

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
        TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props):Play()
end

local function resolveIcon(v)
    if not v then return ICONS.aim end
    if type(v) == "string" and v:match("rbxasset") then return v end
    return ICONS[v] or ICONS.aim
end

local Library = {}
Library.Icons = ICONS

function Library.new(config)
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
        Size             = UDim2.new(1, 0, 0, 46),
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
        Size                   = UDim2.new(0, 180, 1, 0),
        Position               = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text                   = config.Title or "Painel",
        TextColor3             = Theme.text,
        TextSize               = 18,
        Font                   = Enum.Font.GothamBold,
        TextXAlignment         = Enum.TextXAlignment.Left,
    }, TopBar)

    if config.Logo then
        local lh = ni("Frame", {
            Size                   = UDim2.new(0, 48, 0, 48),
            Position               = UDim2.new(0.5, -24, 0.5, -24),
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
        }, TopBar)
        ni("ImageLabel", {
            Size                   = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image                  = config.Logo,
            ScaleType              = Enum.ScaleType.Fit,
        }, lh)
    end

    local UserBlock = ni("Frame", {
        Size                   = UDim2.new(0, 160, 0, 40),
        Position               = UDim2.new(1, -170, 0.5, -20),
        BackgroundTransparency = 1,
    }, TopBar)
    local AvatarCircle = ni("Frame", {
        Size             = UDim2.new(0, 32, 0, 32),
        Position         = UDim2.new(0, 0, 0.5, -16),
        BackgroundColor3 = Theme.bg,
        BorderSizePixel  = 0,
    }, UserBlock)
    corner(AvatarCircle, 16)
    local av = ni("ImageLabel", {
        Size                   = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image                  = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=60&height=60&format=png",
        ScaleType              = Enum.ScaleType.Crop,
    }, AvatarCircle)
    corner(av, 16)
    ni("TextLabel", {
        Size = UDim2.new(1, -40, 0, 16), Position = UDim2.new(0, 38, 0, 3),
        BackgroundTransparency = 1, Text = LocalPlayer.DisplayName,
        TextColor3 = Theme.text, TextSize = 11, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    }, UserBlock)
    ni("TextLabel", {
        Size = UDim2.new(1, -40, 0, 12), Position = UDim2.new(0, 38, 0, 20),
        BackgroundTransparency = 1, Text = "@" .. LocalPlayer.Name,
        TextColor3 = Theme.muted, TextSize = 9, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    }, UserBlock)

    local PageArea = ni("Frame", {
        Size             = UDim2.new(1, -16, 1, -108),
        Position         = UDim2.new(0, 8, 0, 54),
        BackgroundColor3 = Theme.pageArea,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
    }, Main)
    corner(PageArea, 10)
    ni("UIStroke", {Color = Theme.secBorder, Thickness = 1}, PageArea)

    local TabBar = ni("Frame", {
        Size             = UDim2.new(1, 0, 0, 52),
        Position         = UDim2.new(0, 0, 1, -52),
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
        BackgroundColor3 = Theme.TitleBarLine,
        BorderSizePixel  = 0,
    }, TabBar)

    local ICON_SIZE  = 18
    local SMALL_W    = 52
    local EXPANDED_W = 150

    local tabList  = {}
    local tabBtns  = {}
    local pages    = {}
    local curTab   = nil
    local animating = false

    local function calcPositions(activeIdx)
        local pos = {}
        local x = 0
        for i = 1, #tabList do
            local w = (i == activeIdx) and EXPANDED_W or SMALL_W
            pos[i] = {x = x, w = w}
            x = x + w
        end
        local offset = math.floor((W - x) / 2)
        for i = 1, #tabList do pos[i].x = pos[i].x + offset end
        return pos
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

    local function showGui()
        if animating then return end
        animating = true
        Main.Visible  = true
        Main.Size     = UDim2.new(0, W, 0, 0)
        Main.Position = UDim2.new(0.5, -W/2, 0.5, 0)
        tw(Main, {Size = UDim2.new(0, W, 0, H), Position = UDim2.new(0.5, -W/2, 0.5, -H/2)},
            0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.delay(0.42, function() animating = false end)
    end

    local function hideGui()
        if animating then return end
        animating = true
        tw(Main, {Size = UDim2.new(0, W, 0, 0), Position = UDim2.new(0.5, -W/2, 0.5, 0)},
            0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.delay(0.32, function()
            Main.Visible  = false
            Main.Size     = UDim2.new(0, W, 0, H)
            Main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
            animating     = false
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

    local Window = {}

    function Window:AddTab(cfg)
        cfg = cfg or {}
        local name    = cfg.Name or ("Tab" .. tostring(#tabList + 1))
        local subText = cfg.Sub  or ""
        local iconId  = resolveIcon(cfg.Icon)

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
            local p = positions[i]
            tb.bg.Position = UDim2.new(0, p.x, 0, 0)
            tb.bg.Size     = UDim2.new(0, p.w, 1, 0)
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
            Position         = UDim2.new(0, 9, 0.5, -17),
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
            Size             = UDim2.new(1, -54, 0, 15),
            Position         = UDim2.new(0, 48, 0.5, -13),
            BackgroundTransparency = 1,
            Text             = name,
            TextColor3       = Theme.text,
            TextSize         = 11,
            Font             = Enum.Font.GothamBold,
            TextXAlignment   = Enum.TextXAlignment.Left,
            TextTransparency = 1,
        }, bg)
        local sub_lbl = ni("TextLabel", {
            Size             = UDim2.new(1, -54, 0, 10),
            Position         = UDim2.new(0, 48, 0.5, 3),
            BackgroundTransparency = 1,
            Text             = subText,
            TextColor3       = Theme.muted,
            TextSize         = 8,
            Font             = Enum.Font.Gotham,
            TextXAlignment   = Enum.TextXAlignment.Left,
            TextTransparency = 1,
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

        local Tab = {}

        function Tab:AddSection(scfg)
            scfg = scfg or {}
            local sName  = scfg.Name or "Section"
            local sIcon  = resolveIcon(scfg.Icon)
            local side   = scfg.Side or "left"

            local xPct, wPct
            if side == "left" then
                xPct = 0.00; wPct = 0.35
            elseif side == "center" then
                xPct = 0.35; wPct = 0.35
            else
                xPct = 0.70; wPct = 0.30
            end

            local GAP = 3

            local outer = ni("Frame", {
                Size             = UDim2.new(wPct, -GAP, 1, -8),
                Position         = UDim2.new(xPct, GAP, 0, 4),
                BackgroundColor3 = Theme.section,
                BorderSizePixel  = 0,
                ClipsDescendants = true,
            }, pg)
            corner(outer, 10)
            ni("UIStroke", {Color = Theme.secBorder, Thickness = 1}, outer)

            local header = ni("Frame", {
                Size             = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                BorderSizePixel  = 0,
            }, outer)
            corner(header, 10)
            ni("Frame", {
                Size             = UDim2.new(1, 0, 0, 10),
                Position         = UDim2.new(0, 0, 1, -10),
                BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                BorderSizePixel  = 0,
            }, header)
            ni("Frame", {
                Size             = UDim2.new(1, 0, 0, 1),
                Position         = UDim2.new(0, 0, 1, -1),
                BackgroundColor3 = Theme.accentLo,
                BorderSizePixel  = 0,
            }, header)
            ni("ImageLabel", {
                Size                   = UDim2.new(0, 16, 0, 16),
                Position               = UDim2.new(0, 10, 0.5, -8),
                BackgroundTransparency = 1,
                Image                  = sIcon,
                ImageColor3            = Theme.accentHi,
            }, header)
            ni("TextLabel", {
                Size                   = UDim2.new(1, -34, 1, 0),
                Position               = UDim2.new(0, 30, 0, 0),
                BackgroundTransparency = 1,
                Text                   = sName,
                TextColor3             = Theme.text,
                TextSize               = 12,
                Font                   = Enum.Font.GothamBold,
                TextXAlignment         = Enum.TextXAlignment.Left,
            }, header)

            local scroll = ni("ScrollingFrame", {
                Size                   = UDim2.new(1, 0, 1, -38),
                Position               = UDim2.new(0, 0, 0, 38),
                BackgroundTransparency = 1,
                BorderSizePixel        = 0,
                ScrollBarThickness     = 2,
                ScrollBarImageColor3   = Theme.accentLo,
                CanvasSize             = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize    = Enum.AutomaticSize.Y,
                ScrollingDirection     = Enum.ScrollingDirection.Y,
                ElasticBehavior        = Enum.ElasticBehavior.Never,
            }, outer)
            ni("UIPadding", {
                PaddingTop    = UDim.new(0, 6),
                PaddingBottom = UDim.new(0, 6),
                PaddingLeft   = UDim.new(0, 4),
                PaddingRight  = UDim.new(0, 4),
            }, scroll)
            ni("UIListLayout", {
                Padding             = UDim.new(0, 4),
                FillDirection       = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder           = Enum.SortOrder.LayoutOrder,
            }, scroll)

            local Section = {}
            Section._scroll = scroll
            Section._outer  = outer
            return Section
        end

        return Tab
    end

    return Window
end

return Library
