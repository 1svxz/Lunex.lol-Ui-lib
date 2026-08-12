local Lib = (function()
-- ============================================================
-- LUNEX UI LIBRARY – CONFIGS / THEMES NOW SCAN FOLDERS DIRECTLY
-- ============================================================

local UserInputService = game:GetService("UserInputService")
local TweenServ = game:GetService("TweenService")
local RunServ = game:GetService("RunService")
local TextServ = game:GetService("TextService")
local HttpServ = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local CFG_FOLDER = "Lunex.lol"
local CFG_SUB = CFG_FOLDER .. "/Configs"
local THM_SUB = CFG_FOLDER .. "/Themes"

local function ensureFoldersExist()
    if makefolder and isfolder then
        if not isfolder(CFG_FOLDER) then pcall(makefolder, CFG_FOLDER) end
        if not isfolder(CFG_SUB) then pcall(makefolder, CFG_SUB) end
        if not isfolder(THM_SUB) then pcall(makefolder, THM_SUB) end
    end
end

local function shallowCopy(tbl)
    local c = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            c[k] = shallowCopy(v)
        else
            c[k] = v
        end
    end
    return c
end

local function dupeTable(t)
    local c = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            c[k] = dupeTable(v)
        else
            c[k] = v
        end
    end
    return c
end

local function getGuiParent()
    local ok, hui = pcall(function() return gethui and gethui() end)
    if ok and hui then return hui end
    local ok2, core = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and core then return core end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local PRESET_THEMES = {
    Default = {
        Accent        = Color3.fromRGB(200, 68, 240),
        AccentDark    = Color3.fromRGB(160, 45, 200),
        TextActive    = Color3.fromRGB(255, 255, 255),
        TextInactive  = Color3.fromRGB(136, 136, 136),
        OuterBorder   = Color3.fromRGB(31, 31, 31),
        InnerBorder   = Color3.fromRGB(31, 31, 31),
        PanelFill     = Color3.fromRGB(0, 0, 0),
        ContentOuter  = Color3.fromRGB(31, 31, 31),
        ContentInner  = Color3.fromRGB(0, 0, 0),
        ContentFill   = Color3.fromRGB(0, 0, 0),
        ChildFill     = Color3.fromRGB(0, 0, 0),
        ComboInner    = Color3.fromRGB(20, 20, 20),
        ComboFill     = Color3.fromRGB(0, 0, 0),
        ComboSelected = Color3.fromRGB(200, 68, 240),
        HeaderTop     = Color3.fromRGB(18, 18, 18),
        HeaderBottom  = Color3.fromRGB(0, 0, 0),
        TabTop        = Color3.fromRGB(31, 31, 31),
        TabMid        = Color3.fromRGB(15, 15, 15),
        TabBottom     = Color3.fromRGB(0, 0, 0),
        TabInactive   = Color3.fromRGB(128, 128, 128),
        TabHover      = Color3.fromRGB(208, 208, 208),
    },
    ["Tokyo Night"] = {
        Accent        = Color3.fromRGB(187, 154, 247),
        AccentDark    = Color3.fromRGB(138, 99,  210),
        TextActive    = Color3.fromRGB(192, 202, 245),
        TextInactive  = Color3.fromRGB(86,  95,  137),
        OuterBorder   = Color3.fromRGB(10,  10,  18),
        InnerBorder   = Color3.fromRGB(36,  40,  59),
        PanelFill     = Color3.fromRGB(26,  27,  38),
        ContentOuter  = Color3.fromRGB(36,  40,  59),
        ContentInner  = Color3.fromRGB(15,  15,  24),
        ContentFill   = Color3.fromRGB(22,  22,  30),
        ChildFill     = Color3.fromRGB(18,  18,  26),
        ComboInner    = Color3.fromRGB(30,  32,  48),
        ComboFill     = Color3.fromRGB(24,  25,  38),
        ComboSelected = Color3.fromRGB(187, 154, 247),
        HeaderTop     = Color3.fromRGB(30,  32,  48),
        HeaderBottom  = Color3.fromRGB(22,  22,  30),
        TabTop        = Color3.fromRGB(40,  44,  66),
        TabMid        = Color3.fromRGB(30,  32,  48),
        TabBottom     = Color3.fromRGB(22,  22,  30),
        TabInactive   = Color3.fromRGB(100, 110, 150),
        TabHover      = Color3.fromRGB(160, 175, 220),
    },
    Crimson = {
        Accent        = Color3.fromRGB(255, 75,  75),
        AccentDark    = Color3.fromRGB(180, 40,  40),
        TextActive    = Color3.fromRGB(255, 240, 240),
        TextInactive  = Color3.fromRGB(140, 100, 100),
        OuterBorder   = Color3.fromRGB(10,  0,   0),
        InnerBorder   = Color3.fromRGB(40,  20,  20),
        PanelFill     = Color3.fromRGB(20,  12,  12),
        ContentOuter  = Color3.fromRGB(40,  20,  20),
        ContentInner  = Color3.fromRGB(10,  0,   0),
        ContentFill   = Color3.fromRGB(24,  15,  15),
        ChildFill     = Color3.fromRGB(16,  10,  10),
        ComboInner    = Color3.fromRGB(30,  18,  18),
        ComboFill     = Color3.fromRGB(22,  14,  14),
        ComboSelected = Color3.fromRGB(255, 75,  75),
        HeaderTop     = Color3.fromRGB(32,  18,  18),
        HeaderBottom  = Color3.fromRGB(18,  10,  10),
        TabTop        = Color3.fromRGB(42,  22,  22),
        TabMid        = Color3.fromRGB(30,  16,  16),
        TabBottom     = Color3.fromRGB(20,  12,  12),
        TabInactive   = Color3.fromRGB(130, 90,  90),
        TabHover      = Color3.fromRGB(200, 130, 130),
    },
    Emerald = {
        Accent        = Color3.fromRGB(80,  250, 123),
        AccentDark    = Color3.fromRGB(40,  180, 80),
        TextActive    = Color3.fromRGB(240, 255, 240),
        TextInactive  = Color3.fromRGB(100, 130, 110),
        OuterBorder   = Color3.fromRGB(0,   10,  0),
        InnerBorder   = Color3.fromRGB(20,  40,  25),
        PanelFill     = Color3.fromRGB(12,  20,  14),
        ContentOuter  = Color3.fromRGB(20,  40,  25),
        ContentInner  = Color3.fromRGB(0,   10,  0),
        ContentFill   = Color3.fromRGB(15,  24,  17),
        ChildFill     = Color3.fromRGB(10,  16,  12),
        ComboInner    = Color3.fromRGB(18,  30,  20),
        ComboFill     = Color3.fromRGB(14,  22,  16),
        ComboSelected = Color3.fromRGB(80,  250, 123),
        HeaderTop     = Color3.fromRGB(18,  32,  20),
        HeaderBottom  = Color3.fromRGB(10,  18,  12),
        TabTop        = Color3.fromRGB(22,  42,  26),
        TabMid        = Color3.fromRGB(16,  30,  20),
        TabBottom     = Color3.fromRGB(12,  20,  14),
        TabInactive   = Color3.fromRGB(90,  130, 100),
        TabHover      = Color3.fromRGB(130, 200, 150),
    }
}

local FONT       = Enum.Font.SourceSans
local FONT_BOLD  = Enum.Font.SourceSansBold
local FONT_FACE  = nil
local TEXT_SIZE  = 13
local STROKE_T   = 0.55

local Lib = {}
Lib.__index = Lib
Lib.Theme    = dupeTable(PRESET_THEMES.Default)
Lib.Presets  = PRESET_THEMES
Lib.Toggled  = true
Lib.ToggleKey= Enum.KeyCode.Insert
Lib.Flags    = {}
Lib.Controls = {}
Lib.Defaults = {}
Lib.UIExpansion = false

Lib.ThemeRegistry = {}
Lib.ThemeCallbacks = {}
Lib.ThemePickers = {}

function Lib:RegisterTheme(inst, prop, themeKey)
    if not inst then return end
    table.insert(Lib.ThemeRegistry, {inst, prop, themeKey})
    if Lib.Theme[themeKey] then inst[prop] = Lib.Theme[themeKey] end
end

function Lib:RegisterThemeCallback(fn)
    table.insert(Lib.ThemeCallbacks, fn)
    pcall(fn)
end

function Lib:RefreshTheme()
    for i = #Lib.ThemeRegistry, 1, -1 do
        local item = Lib.ThemeRegistry[i]
        local inst = item[1]
        local prop = item[2]
        local key  = item[3]
        if inst and inst.Parent then
            if Lib.Theme[key] then inst[prop] = Lib.Theme[key] end
        else
            table.remove(Lib.ThemeRegistry, i)
        end
    end
    for _, cb in ipairs(Lib.ThemeCallbacks) do
        pcall(cb)
    end
    if Lib.ThemePickers then
        for key, ctrl in pairs(Lib.ThemePickers) do
            if ctrl and ctrl.Set and Lib.Theme[key] then
                ctrl:Set(Lib.Theme[key], false)
            end
        end
    end
end

local function newInstance(class, props, parent)
    local o = Instance.new(class)
    if props then for k, v in pairs(props) do if k ~= "Parent" then o[k] = v end end end
    if parent then o.Parent = parent end
    return o
end

local function applyFont(label, bold)
    if FONT_FACE then label.FontFace = FONT_FACE else label.Font = bold and FONT_BOLD or FONT end
end

local function outlined(parent, text, colorOrKey, props)
    local bold = props and props.Bold
    local color = type(colorOrKey) == "string" and Lib.Theme[colorOrKey] or colorOrKey
    local l = newInstance("TextLabel", {
        BackgroundTransparency = 1,
        Text = text or "",
        TextColor3 = color or Lib.Theme.TextActive,
        TextSize = TEXT_SIZE,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextStrokeColor3 = Lib.Theme.OuterBorder,
        TextStrokeTransparency = STROKE_T,
        TextTruncate = Enum.TextTruncate.AtEnd,
        RichText = false,
        ZIndex = 5,
    }, parent)
    applyFont(l, bold)

    if type(colorOrKey) == "string" then
        Lib:RegisterTheme(l, "TextColor3", colorOrKey)
    end
    Lib:RegisterTheme(l, "TextStrokeColor3", "OuterBorder")

    if props then for k, v in pairs(props) do if k ~= "Bold" then l[k] = v end end end
    return l
end

local function framedBox(parent, outerC, innerC, fillC, props)
    local outerColor = type(outerC) == "string" and Lib.Theme[outerC] or outerC
    local innerColor = type(innerC) == "string" and Lib.Theme[innerC] or innerC
    local fillColor  = type(fillC) == "string" and Lib.Theme[fillC] or fillC

    local outer = newInstance("Frame", {
        BackgroundColor3 = outerColor,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
    }, parent)
    if type(outerC) == "string" then Lib:RegisterTheme(outer, "BackgroundColor3", outerC) end
    if props then for k, v in pairs(props) do outer[k] = v end end

    local inner = newInstance("Frame", {
        BackgroundColor3 = innerColor,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(1, 1),
        Size = UDim2.new(1, -2, 1, -2),
        ZIndex = (outer.ZIndex or 1),
    }, outer)
    if type(innerC) == "string" then Lib:RegisterTheme(inner, "BackgroundColor3", innerC) end

    local fill = newInstance("Frame", {
        Name = "Fill",
        BackgroundColor3 = fillColor,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(2, 2),
        Size = UDim2.new(1, -4, 1, -4),
        ZIndex = (outer.ZIndex or 1),
    }, outer)
    if type(fillC) == "string" then Lib:RegisterTheme(fill, "BackgroundColor3", fillC) end

    return outer, fill
end

local function vGradient(frame, topC, botC, transSeq)
    frame.BackgroundColor3 = Color3.new(1, 1, 1)
    local grad = newInstance("UIGradient", {
        Rotation = 90,
        Transparency = transSeq or NumberSequence.new(0),
    }, frame)

    local function updateGrad()
        local tColor = type(topC) == "string" and Lib.Theme[topC] or topC
        local bColor = type(botC) == "string" and Lib.Theme[botC] or botC
        grad.Color = ColorSequence.new(tColor, bColor)
    end

    Lib:RegisterThemeCallback(updateGrad)
    return grad
end

local function tween(inst, t, goal)
    return TweenServ:Create(inst, TweenInfo.new(t or 0.12, Enum.EasingStyle.Quad), goal)
end

local KEY_NAMES = {
    [Enum.UserInputType.MouseButton1] = "LM",
    [Enum.UserInputType.MouseButton2] = "RM",
    [Enum.UserInputType.MouseButton3] = "MM",
    [Enum.KeyCode.LeftShift]  = "Shift", [Enum.KeyCode.RightShift]  = "Shift",
    [Enum.KeyCode.LeftControl]= "Ctrl",  [Enum.KeyCode.RightControl]= "Ctrl",
    [Enum.KeyCode.LeftAlt]    = "Alt",   [Enum.KeyCode.RightAlt]    = "Alt",
    [Enum.KeyCode.Space]      = "Space", [Enum.KeyCode.Return]      = "Enter",
    [Enum.KeyCode.Tab]        = "Tab",   [Enum.KeyCode.Backspace]   = "Back",
    [Enum.KeyCode.CapsLock]   = "Caps",  [Enum.KeyCode.Escape]      = "Esc",
    [Enum.KeyCode.Insert]     = "Insert",[Enum.KeyCode.Delete]      = "Del",
    [Enum.KeyCode.Up]="Up",[Enum.KeyCode.Down]="Down",[Enum.KeyCode.Left]="Left",[Enum.KeyCode.Right]="Right",
}
local function keyName(key)
    if key == nil then return "-" end
    if KEY_NAMES[key] then return KEY_NAMES[key] end
    if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
        return key.Name
    end
    return "?"
end

local screenGui = newInstance("ScreenGui", {
    Name = "ui",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999,
}, getGuiParent())

local popupLayer = newInstance("Frame", {
    Name = "PopupLayer", BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1), ZIndex = 500,
}, screenGui)

local openPopups = {}

local function closeAllPopups()
    local current = openPopups
    openPopups = {}
    for _, fn in ipairs(current) do
        pcall(fn)
    end
end

local MIN_SIZE = Vector2.new(360, 360)
local MAX_SIZE = Vector2.new(800, 800)

local function syncTabGap(win)
    local tab = win.ActiveTab
    if not tab then return end
    local panelW = win.Canvas.Size.X.Offset - 20

    local tabLeftOffset = win.TabHost.Position.X.Offset - 10
    local gx = tabLeftOffset + (tab.Index - 1) * (win._tabW + win._tabSp)
    local tw = win._tabW

    local function seg(f, x, w)
        f.Position = UDim2.fromOffset(x, f.Position.Y.Offset)
        f.Size = UDim2.fromOffset(math.max(0, w), 1)
    end
    seg(win._oT1, 0,           gx)
    seg(win._oT2, gx + tw,     panelW - (gx + tw))
    seg(win._iT1, 1,           gx)
    seg(win._iT2, gx + tw - 1, panelW - gx - tw)
end

local function updateTabPositions(win)
    local numTabs = #win.Tabs
    if numTabs == 0 then return end

    local panelW = win.Canvas.Size.X.Offset - 20
    local tabSp = win._tabSp or 2
    local tabW = 81

    local totalGaps = math.max(0, numTabs - 1) * tabSp
    local tabsTotal = numTabs * tabW + totalGaps

    win._tabW = tabW
    win._tabsTotal = tabsTotal

    win.TabHost.Size = UDim2.fromOffset(tabsTotal, win._tabH)
    win.TabHost.Position = UDim2.fromOffset(10 + math.floor((panelW - tabsTotal) / 2), 40 - win._tabH)

    for i, tab in ipairs(win.Tabs) do
        local x = (i - 1) * (tabW + tabSp)
        tab.Button.Position = UDim2.fromOffset(x, 0)
        tab.Button.Size = UDim2.fromOffset(tabW, win._tabH)
    end

    syncTabGap(win)
end

local function isTouchOrMouse(i)
    return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end

local function isMoveInput(i)
    return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch
end

local function serializeValue(val)
    if typeof(val) == "Color3" then
        return {__type = "Color3", r = val.R, g = val.G, b = val.B}
    elseif typeof(val) == "EnumItem" then
        return {__type = "EnumItem", enumType = tostring(val.EnumType), name = val.Name}
    end
    return val
end

local function deserializeValue(val)
    if type(val) == "table" and val.__type then
        if val.__type == "Color3" then
            return Color3.new(val.r, val.g, val.b)
        elseif val.__type == "EnumItem" then
            local enumGroup = Enum[val.enumType]
            if enumGroup and enumGroup[val.name] then
                return enumGroup[val.name]
            end
        end
    end
    return val
end

local function scanConfigFiles()
    local files = {}
    if not isfolder or not listfiles then return files end
    local path = CFG_SUB
    if not isfolder(path) then return files end
    local ok, all = pcall(listfiles, path)
    if not ok then return files end
    for _, f in ipairs(all) do
        local name = f:match("([^\\/]+)%.json$")
        if name and f:find(path, 1, true) and name ~= "configs_list" then
            table.insert(files, name)
        end
    end
    table.sort(files)
    return files
end

local function scanThemeFiles()
    local files = {}
    if not isfolder or not listfiles then return files end
    local path = THM_SUB
    if not isfolder(path) then return files end
    local ok, all = pcall(listfiles, path)
    if not ok then return files end
    for _, f in ipairs(all) do
        local name = f:match("([^\\/]+)_theme%.json$")
        if name then
            table.insert(files, name)
        end
    end
    table.sort(files)
    return files
end

function Lib:SaveConfig(filename)
    if not writefile then return end
    ensureFoldersExist()
    filename = filename or "default"
    local path = CFG_SUB .. "/" .. filename .. ".json"
    local rawData = {}
    for flag, val in pairs(Lib.Flags) do
        if type(val) == "table" and not val.__type then
            local tbl = {}
            for k, v in pairs(val) do tbl[k] = serializeValue(v) end
            rawData[flag] = tbl
        else
            rawData[flag] = serializeValue(val)
        end
    end
    pcall(writefile, path, HttpServ:JSONEncode(rawData))
end

function Lib:LoadConfig(filename)
    if not readfile or not isfile then return end
    filename = filename or "default"
    local path = CFG_SUB .. "/" .. filename .. ".json"
    if not isfile(path) then return end
    local ok, content = pcall(readfile, path)
    if not ok then return end
    local ok2, decoded = pcall(function() return HttpServ:JSONDecode(content) end)
    if not ok2 or type(decoded) ~= "table" then return end

    for flag, val in pairs(decoded) do
        local finalVal
        if type(val) == "table" and not val.__type then
            finalVal = {}
            for k, v in pairs(val) do finalVal[k] = deserializeValue(v) end
        else
            finalVal = deserializeValue(val)
        end

        Lib.Flags[flag] = finalVal
        if Lib.Controls[flag] and Lib.Controls[flag].Set then
            Lib.Controls[flag]:Set(finalVal, true)
        end
    end
    Lib:RefreshTheme()
end

function Lib:DeleteConfig(filename)
    if not delfile or not isfile then return end
    filename = filename or "default"
    local path = CFG_SUB .. "/" .. filename .. ".json"
    if isfile(path) then
        pcall(delfile, path)
    end
end

function Lib:SetAutoLoad(filename)
    if not writefile then return end
    ensureFoldersExist()
    filename = filename or "default"
    pcall(writefile, CFG_SUB .. "/autoload.json", HttpServ:JSONEncode({autoload = filename}))
end

function Lib:CheckAutoLoad()
    ensureFoldersExist()
    local path = CFG_SUB .. "/autoload.json"
    if not isfile or not readfile or not isfile(path) then return end
    local ok, content = pcall(readfile, path)
    if not ok then return end
    local ok2, decoded = pcall(function() return HttpServ:JSONDecode(content) end)
    if ok2 and type(decoded) == "table" and decoded.autoload then
        Lib:LoadConfig(decoded.autoload)
    end
end

function Lib:ResetToDefaults()
    for flag, defaultVal in pairs(Lib.Defaults) do
        Lib.Flags[flag] = shallowCopy(defaultVal)
        if Lib.Controls[flag] and Lib.Controls[flag].Set then
            Lib.Controls[flag]:Set(shallowCopy(defaultVal), true)
        end
    end
end

function Lib:SaveTheme(themeName)
    if not writefile then return end
    ensureFoldersExist()
    themeName = themeName or "custom_theme"
    local path = THM_SUB .. "/" .. themeName .. "_theme.json"
    local rawTheme = {}
    for k, v in pairs(Lib.Theme) do
        rawTheme[k] = serializeValue(v)
    end
    pcall(writefile, path, HttpServ:JSONEncode(rawTheme))
end

function Lib:LoadTheme(themeName)
    if not readfile or not isfile then return end
    themeName = themeName or "custom_theme"
    local path = THM_SUB .. "/" .. themeName .. "_theme.json"
    if not isfile(path) then return end
    local ok, content = pcall(readfile, path)
    if not ok then return end
    local ok2, decoded = pcall(function() return HttpServ:JSONDecode(content) end)
    if not ok2 or type(decoded) ~= "table" then return end

    for k, v in pairs(decoded) do
        Lib.Theme[k] = deserializeValue(v)
    end
    Lib:RefreshTheme()
end

function Lib:DeleteTheme(themeName)
    if not delfile or not isfile then return end
    themeName = themeName or "custom_theme"
    local path = THM_SUB .. "/" .. themeName .. "_theme.json"
    if isfile(path) then
        pcall(delfile, path)
    end
end

function Lib:SetPresetTheme(presetName)
    if PRESET_THEMES[presetName] then
        for k, v in pairs(PRESET_THEMES[presetName]) do
            Lib.Theme[k] = v
        end
        Lib:RefreshTheme()
    end
end

function Lib:ResetThemeToDefault()
    for k, v in pairs(PRESET_THEMES.Default) do
        Lib.Theme[k] = v
    end
    Lib:RefreshTheme()
end

local function addResizeHandles(canvas, onResize, windowRef)
    local T = 8
    local host = newInstance("Frame", {
        Name = "ResizeHost", BackgroundTransparency = 1, Active = false,
        Position = canvas.Position, Size = canvas.Size, ZIndex = 60,
    }, canvas.Parent)

    local function syncHost()
        host.Position = canvas.Position
        host.Size = canvas.Size
        host.Visible = canvas.Visible and (Lib.UIExpansion == true)
    end
    canvas:GetPropertyChangedSignal("Position"):Connect(syncHost)
    canvas:GetPropertyChangedSignal("Size"):Connect(syncHost)
    canvas:GetPropertyChangedSignal("Visible"):Connect(syncHost)
    Lib._UpdateResizeVisibility = syncHost
    syncHost()

    local edges = {
        {n="N",  p=UDim2.new(0,T,0,-T),    s=UDim2.new(1,-T*2,0,T*2), sx= 0, sy=-1},
        {n="S",  p=UDim2.new(0,T,1,-T),    s=UDim2.new(1,-T*2,0,T*2), sx= 0, sy= 1},
        {n="W",  p=UDim2.new(0,-T,0,T),    s=UDim2.new(0,T*2,1,-T*2), sx=-1, sy= 0},
        {n="E",  p=UDim2.new(1,-T,0,T),    s=UDim2.new(0,T*2,1,-T*2), sx= 1, sy= 0},
        {n="NW", p=UDim2.new(0,-T,0,-T),   s=UDim2.fromOffset(T*2,T*2), sx=-1, sy=-1},
        {n="NE", p=UDim2.new(1,-T,0,-T),   s=UDim2.fromOffset(T*2,T*2), sx= 1, sy=-1},
        {n="SW", p=UDim2.new(0,-T,1,-T),   s=UDim2.fromOffset(T*2,T*2), sx=-1, sy= 1},
        {n="SE", p=UDim2.new(1,-T,1,-T),   s=UDim2.fromOffset(T*2,T*2), sx= 1, sy= 1},
    }
    for _, e in ipairs(edges) do
        local h = newInstance("TextButton", {
            Name = "Resize" .. e.n, Text = "", AutoButtonColor = false,
            BackgroundTransparency = 1, Position = e.p, Size = e.s, ZIndex = 60,
        }, host)

        local active, startSize, startPos, startInput = false, nil, nil, nil
        h.InputBegan:Connect(function(i)
            if isTouchOrMouse(i) and Lib.UIExpansion then
                active = true
                startSize = Vector2.new(canvas.Size.X.Offset, canvas.Size.Y.Offset)
                startPos = canvas.Position
                startInput = Vector2.new(i.Position.X, i.Position.Y)
                closeAllPopups()
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if not active or not isMoveInput(i) or not Lib.UIExpansion then return end
            local curPos = Vector2.new(i.Position.X, i.Position.Y)
            local d = curPos - startInput

            local minW = windowRef and windowRef:GetMinWidth() or MIN_SIZE.X
            local w = math.clamp(startSize.X + e.sx * d.X, minW, MAX_SIZE.X)
            local ht = math.clamp(startSize.Y + e.sy * d.Y, MIN_SIZE.Y, MAX_SIZE.Y)
            local ox = (e.sx < 0) and (startSize.X - w) or 0
            local oy = (e.sy < 0) and (startSize.Y - ht) or 0
            canvas.Size = UDim2.fromOffset(w, ht)
            canvas.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + ox,
                startPos.Y.Scale, startPos.Y.Offset + oy)
            if onResize then onResize() end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if isTouchOrMouse(i) then active = false end
        end)
    end
end

function Lib:Window(opts)
    opts = opts or {}
    local size = opts.Size or Vector2.new(480, 450)

    local canvas = newInstance("CanvasGroup", {
        Name = "Window",
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.new(0.5, -math.floor(size.X/2), 0.5, -math.floor(size.Y/2)),
        Size = UDim2.fromOffset(size.X, size.Y),
        BackgroundTransparency = 1,
        GroupTransparency = 0,
        ZIndex = 10,
    }, screenGui)

    local wOuter = newInstance("Frame", {BackgroundColor3 = Lib.Theme.OuterBorder, BorderSizePixel = 0, Size = UDim2.fromScale(1,1), ZIndex = 1}, canvas)
    Lib:RegisterTheme(wOuter, "BackgroundColor3", "OuterBorder")

    local wInner = newInstance("Frame", {BackgroundColor3 = Lib.Theme.InnerBorder, BorderSizePixel = 0, Position = UDim2.fromOffset(1,1), Size = UDim2.new(1,-2,1,-2), ZIndex = 1}, wOuter)
    Lib:RegisterTheme(wInner, "BackgroundColor3", "InnerBorder")

    local wFill = newInstance("Frame", {BackgroundColor3 = Lib.Theme.PanelFill, BorderSizePixel = 0, Position = UDim2.fromOffset(2,2), Size = UDim2.new(1,-4,1,-4), ZIndex = 1}, wOuter)
    Lib:RegisterTheme(wFill, "BackgroundColor3", "PanelFill")

    local topBar = newInstance("Frame", {
        Name = "TopBar",
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(2, 2),
        Size = UDim2.new(1, -4, 0, 38),
        ZIndex = 2,
    }, wOuter)
    vGradient(topBar, "HeaderTop", "HeaderBottom")

    local titleLbl = outlined(canvas, "", "TextActive", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 4),
        Size = UDim2.fromOffset(250, 14),
        TextXAlignment = Enum.TextXAlignment.Center,
        RichText = true, Bold = true, ZIndex = 6, TextTruncate = Enum.TextTruncate.AtEnd,
    })

    Lib:RegisterThemeCallback(function()
        local accentHex = string.format("#%02X%02X%02X", math.floor(Lib.Theme.Accent.R*255), math.floor(Lib.Theme.Accent.G*255), math.floor(Lib.Theme.Accent.B*255))
        titleLbl.Text = string.format('%s<font color="%s">%s</font>',
            opts.TitleLeft or "remade by ", accentHex, opts.TitleRight or "angel")
    end)

    local panel = newInstance("Frame", {Name = "Panel", BackgroundTransparency = 1, Position = UDim2.fromOffset(10,40), Size = UDim2.new(1,-20,1,-50), ZIndex = 2}, canvas)
    local pFill = newInstance("Frame", {BackgroundColor3 = Lib.Theme.ContentFill, BorderSizePixel = 0, Position = UDim2.fromOffset(2,2), Size = UDim2.new(1,-4,1,-4), ZIndex = 2}, panel)
    Lib:RegisterTheme(pFill, "BackgroundColor3", "ContentFill")

    local f1 = newInstance("Frame", {BackgroundColor3 = Lib.Theme.ContentOuter, BorderSizePixel = 0, Position = UDim2.fromOffset(0,0), Size = UDim2.new(0,1,1,0), ZIndex = 2}, panel)
    Lib:RegisterTheme(f1, "BackgroundColor3", "ContentOuter")
    local f2 = newInstance("Frame", {BackgroundColor3 = Lib.Theme.ContentOuter, BorderSizePixel = 0, Position = UDim2.new(1,-1,0,0), Size = UDim2.new(0,1,1,0), ZIndex = 2}, panel)
    Lib:RegisterTheme(f2, "BackgroundColor3", "ContentOuter")
    local f3 = newInstance("Frame", {BackgroundColor3 = Lib.Theme.ContentOuter, BorderSizePixel = 0, Position = UDim2.new(0,0,1,-1), Size = UDim2.new(1,0,0,1), ZIndex = 2}, panel)
    Lib:RegisterTheme(f3, "BackgroundColor3", "ContentOuter")
    local oT1 = newInstance("Frame", {BackgroundColor3 = Lib.Theme.ContentOuter, BorderSizePixel = 0, Position = UDim2.fromOffset(0,0), Size = UDim2.new(1,0,0,1), ZIndex = 2}, panel)
    Lib:RegisterTheme(oT1, "BackgroundColor3", "ContentOuter")
    local oT2 = newInstance("Frame", {BackgroundColor3 = Lib.Theme.ContentOuter, BorderSizePixel = 0, Position = UDim2.fromOffset(0,0), Size = UDim2.fromOffset(0,1), ZIndex = 2}, panel)
    Lib:RegisterTheme(oT2, "BackgroundColor3", "ContentOuter")

    local b1 = newInstance("Frame", {BackgroundColor3 = Lib.Theme.ContentInner, BorderSizePixel = 0, Position = UDim2.fromOffset(1,1), Size = UDim2.new(0,1,1,-2), ZIndex = 2}, panel)
    Lib:RegisterTheme(b1, "BackgroundColor3", "ContentInner")
    local b2 = newInstance("Frame", {BackgroundColor3 = Lib.Theme.ContentInner, BorderSizePixel = 0, Position = UDim2.new(1,-2,0,1), Size = UDim2.new(0,1,1,-2), ZIndex = 2}, panel)
    Lib:RegisterTheme(b2, "BackgroundColor3", "ContentInner")
    local b3 = newInstance("Frame", {BackgroundColor3 = Lib.Theme.ContentInner, BorderSizePixel = 0, Position = UDim2.fromOffset(0,1,1,-2), Size = UDim2.new(1,-2,0,1), ZIndex = 2}, panel)
    Lib:RegisterTheme(b3, "BackgroundColor3", "ContentInner")
    local iT1 = newInstance("Frame", {BackgroundColor3 = Lib.Theme.ContentInner, BorderSizePixel = 0, Position = UDim2.fromOffset(1,1), Size = UDim2.new(1,-2,0,1), ZIndex = 2}, panel)
    Lib:RegisterTheme(iT1, "BackgroundColor3", "ContentInner")
    local iT2 = newInstance("Frame", {BackgroundColor3 = Lib.Theme.ContentInner, BorderSizePixel = 0, Position = UDim2.fromOffset(1,1), Size = UDim2.fromOffset(0,1), ZIndex = 2}, panel)
    Lib:RegisterTheme(iT2, "BackgroundColor3", "ContentInner")

    local TAB_W, TAB_H, TAB_SP = 81, 18, 2
    local tabsTotal = TAB_W * 4 + TAB_SP * 3
    local tabHost = newInstance("Frame", {
        Name = "Tabs", BackgroundTransparency = 1,
        Position = UDim2.fromOffset(10 + math.floor(((canvas.Size.X.Offset - 20) - tabsTotal) / 2), 40 - TAB_H),
        Size = UDim2.fromOffset(tabsTotal, TAB_H), ZIndex = 4,
    }, canvas)

    local pageHost = newInstance("Frame", {
        Name = "Pages", BackgroundTransparency = 1,
        Position = UDim2.fromOffset(18, 48), Size = UDim2.new(1,-36,1,-66),
        ZIndex = 3, ClipsDescendants = true,
    }, canvas)

    local dragZone = newInstance("TextButton", {
        Name = "DragZone",
        BackgroundTransparency = 1,
        Text = "",
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromScale(1, 1),
        ZIndex = 2,
        AutoButtonColor = false,
    }, canvas)

    do
        local dragging, startPos, startInput
        dragZone.InputBegan:Connect(function(i)
            if isTouchOrMouse(i) then
                dragging, startPos, startInput = true, canvas.Position, Vector2.new(i.Position.X, i.Position.Y)
                closeAllPopups()
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and isMoveInput(i) then
                local curPos = Vector2.new(i.Position.X, i.Position.Y)
                local d = curPos - startInput
                canvas.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if isTouchOrMouse(i) then dragging = false end
        end)
    end

    local window = setmetatable({
        Canvas = canvas, TabHost = tabHost, PageHost = pageHost,
        Tabs = {}, ActiveTab = nil, _tabW = TAB_W, _tabH = TAB_H, _tabSp = TAB_SP,
        _oT1 = oT1, _oT2 = oT2, _iT1 = iT1, _iT2 = iT2,
        _tabsTotal = tabsTotal,
    }, {__index = Lib._WindowMethods})

    function window:GetMinWidth()
        local numTabs = #self.Tabs
        if numTabs == 0 then return MIN_SIZE.X end
        local tabsTotal = numTabs * 81 + math.max(0, numTabs - 1) * (self._tabSp or 2)
        return math.max(MIN_SIZE.X, tabsTotal + 40)
    end

    addResizeHandles(canvas, function()
        updateTabPositions(window)
    end, window)

    return window
end

Lib._WindowMethods = {}

function Lib._WindowMethods:Tab(name)
    local win = self
    local idx = #win.Tabs + 1

    local btn = newInstance("TextButton", {
        Name = name, Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(win._tabW, win._tabH),
        ZIndex = 4,
    }, win.TabHost)

    local tOuter = newInstance("Frame", {BackgroundColor3 = Lib.Theme.ContentOuter, BorderSizePixel = 0, Position = UDim2.fromOffset(0,0), Size = UDim2.new(1,0,0,win._tabH), ZIndex = 4}, btn)
    Lib:RegisterTheme(tOuter, "BackgroundColor3", "ContentOuter")

    local tInner = newInstance("Frame", {BackgroundColor3 = Lib.Theme.ContentInner, BorderSizePixel = 0, Position = UDim2.fromOffset(1,1), Size = UDim2.new(1,-2,0,win._tabH-1), ZIndex = 4}, tOuter)
    Lib:RegisterTheme(tInner, "BackgroundColor3", "ContentInner")

    local tFill  = newInstance("Frame", {BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, Position = UDim2.fromOffset(2,2), Size = UDim2.new(1,-4,0,win._tabH-2), ZIndex = 4}, tOuter)

    local grad = newInstance("UIGradient", {Rotation = 90}, tFill)
    Lib:RegisterThemeCallback(function()
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Lib.Theme.TabTop),
            ColorSequenceKeypoint.new(0.50, Lib.Theme.TabMid),
            ColorSequenceKeypoint.new(1.00, Lib.Theme.TabBottom),
        })
    end)

    local label = outlined(btn, name, "TabInactive", {
        Size = UDim2.new(1,0,0,win._tabH), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 8,
    })

    local page = newInstance("Frame", {
        Name = name, BackgroundTransparency = 1, Visible = false, Size = UDim2.fromScale(1,1), ZIndex = 3, ClipsDescendants = false,
    }, win.PageHost)
    newInstance("UIPadding", {PaddingLeft = UDim.new(0,2), PaddingTop = UDim.new(0,2), PaddingRight = UDim.new(0,2), PaddingBottom = UDim.new(0,2)}, page)
    newInstance("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder}, page)

    local leftCol = newInstance("ScrollingFrame", {
        Name = "LeftCol", BackgroundTransparency = 1, Size = UDim2.new(0.5, -3, 1, 0),
        CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4, ScrollBarImageColor3 = Lib.Theme.Accent,
        LayoutOrder = 1, ZIndex = 3, BorderSizePixel = 0, ClipsDescendants = true,
    }, page)
    Lib:RegisterTheme(leftCol, "ScrollBarImageColor3", "Accent")
    newInstance("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder}, leftCol)

    local rightCol = newInstance("ScrollingFrame", {
        Name = "RightCol", BackgroundTransparency = 1, Size = UDim2.new(0.5, -3, 1, 0),
        CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4, ScrollBarImageColor3 = Lib.Theme.Accent,
        LayoutOrder = 2, ZIndex = 3, BorderSizePixel = 0, ClipsDescendants = true,
    }, page)
    Lib:RegisterTheme(rightCol, "ScrollBarImageColor3", "Accent")
    newInstance("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder}, rightCol)

    local tab = setmetatable({
        Window = win, Button = btn, Outer = tOuter, Inner = tInner, Fill = tFill,
        Grad = grad, Label = label, Page = page, LeftCol = leftCol, RightCol = rightCol, Index = idx, _groups = 0,
    }, {__index = Lib._TabMethods})
    win.Tabs[#win.Tabs + 1] = tab

    local function select()
        for _, t in ipairs(win.Tabs) do
            local on = (t == tab)
            t.Page.Visible = on
            tween(t.Label, 0.12, {TextColor3 = on and Lib.Theme.Accent or Lib.Theme.TabInactive}):Play()

            local oh = win._tabH + (on and 1 or 0)
            local ih = on and (win._tabH + 1) or (win._tabH - 1)
            local fh = on and win._tabH or (win._tabH - 2)
            t.Outer.Size = UDim2.new(1, 0,  0, oh)
            t.Inner.Size = UDim2.new(1, -2, 0, ih)
            t.Fill.Size  = UDim2.new(1, -4, 0, fh)

            local z = on and 6 or 4
            t.Outer.ZIndex, t.Inner.ZIndex, t.Fill.ZIndex = z, z, z
            t.Button.ZIndex = on and 7 or 4
        end

        win.ActiveTab = tab
        syncTabGap(win)
    end
    tab.Select = select

    Lib:RegisterThemeCallback(function()
        local on = (win.ActiveTab == tab)
        label.TextColor3 = on and Lib.Theme.Accent or Lib.Theme.TabInactive
    end)

    btn.MouseButton1Click:Connect(function() closeAllPopups(); select() end)
    btn.MouseEnter:Connect(function()
        if win.ActiveTab ~= tab then tween(label, 0.12, {TextColor3 = Lib.Theme.TabHover}):Play() end
    end)
    btn.MouseLeave:Connect(function()
        if win.ActiveTab ~= tab then tween(label, 0.12, {TextColor3 = Lib.Theme.TabInactive}):Play() end
    end)

    updateTabPositions(win)
    if #win.Tabs == 1 then select() end
    return tab
end

Lib._TabMethods = {}

function Lib._TabMethods:Group(title, side)
    local tab = self
    tab._groups = tab._groups + 1

    local HEADER_H = 19
    local parentCol
    if side == 1 or side == "left" then
        parentCol = tab.LeftCol
    elseif side == 2 or side == "right" then
        parentCol = tab.RightCol
    else
        parentCol = (tab._groups % 2 == 1) and tab.LeftCol or tab.RightCol
    end

    local col = newInstance("Frame", {
        Name = title, BackgroundColor3 = Lib.Theme.OuterBorder, BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, HEADER_H + 15), LayoutOrder = tab._groups, ZIndex = 3, Active = true,
    }, parentCol)
    Lib:RegisterTheme(col, "BackgroundColor3", "OuterBorder")

    local colInner = newInstance("Frame", {BackgroundColor3 = Lib.Theme.InnerBorder, BorderSizePixel = 0, Position = UDim2.fromOffset(1,1), Size = UDim2.new(1,-2,1,-2), ZIndex = 3}, col)
    Lib:RegisterTheme(colInner, "BackgroundColor3", "InnerBorder")

    local body = newInstance("Frame", {
        Name = "Body", BackgroundColor3 = Lib.Theme.ChildFill, BorderSizePixel = 0,
        Position = UDim2.fromOffset(2,2), Size = UDim2.new(1,-4,1,-4), ZIndex = 3, ClipsDescendants = false, Active = true,
    }, col)
    Lib:RegisterTheme(body, "BackgroundColor3", "ChildFill")

    local header = newInstance("Frame", {BackgroundColor3 = Lib.Theme.HeaderTop, BorderSizePixel = 0, Size = UDim2.new(1,0,0,HEADER_H), ZIndex = 3}, body)
    vGradient(header, "HeaderTop", "HeaderBottom")
    outlined(header, title, "TextActive", {Position = UDim2.fromOffset(6,0), Size = UDim2.new(1,-6,1,0), ZIndex = 4})

    local divider = newInstance("Frame", {BackgroundColor3 = Lib.Theme.InnerBorder, BorderSizePixel = 0, Position = UDim2.fromOffset(0,HEADER_H), Size = UDim2.new(1,0,0,1), ZIndex = 4}, body)
    Lib:RegisterTheme(divider, "BackgroundColor3", "InnerBorder")

    local content = newInstance("Frame", {
        Name = "Content", BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, HEADER_H + 1), Size = UDim2.new(1,0,0,0), ZIndex = 3,
    }, body)

    local padding = newInstance("UIPadding", {PaddingLeft = UDim.new(0,6), PaddingTop = UDim.new(0,5), PaddingRight = UDim.new(0,6), PaddingBottom = UDim.new(0,5)}, content)
    local contentList = newInstance("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0,4), SortOrder = Enum.SortOrder.LayoutOrder}, content)

    local function updateGroupSize()
        task.wait()
        local contentH = contentList.AbsoluteContentSize.Y
        local topPad = padding.PaddingTop.Offset
        local botPad = padding.PaddingBottom.Offset
        local totalH = HEADER_H + 1 + topPad + botPad + contentH

        content.Size = UDim2.new(1, 0, 0, totalH - (HEADER_H + 1))
        col.Size = UDim2.new(1, 0, 0, math.max(HEADER_H + 15, totalH))
    end

    contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateGroupSize)
    content.ChildAdded:Connect(function() task.defer(updateGroupSize) end)
    content.ChildRemoved:Connect(function() task.defer(updateGroupSize) end)
    task.defer(updateGroupSize)

    local group = setmetatable({Tab = tab, Content = content, _order = 0, _updateGroupSize = updateGroupSize}, {__index = Lib._GroupMethods})
    return group
end

Lib._GroupMethods = {}

local function nextRow(group, height)
    group._order = group._order + 1
    local row = newInstance("Frame", {
        BackgroundTransparency = 1, Size = UDim2.new(1,0,0,height),
        LayoutOrder = group._order, ZIndex = 3,
    }, group.Content)
    if group._updateGroupSize then
        task.defer(group._updateGroupSize)
    end
    return row
end

function Lib._GroupMethods:Checkbox(text, default, callback, extra, flag)
    extra = extra or {}
    local state = default and true or false
    local row = nextRow(self, 14)

    local boxBtn = newInstance("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.fromOffset(12,12), Position = UDim2.fromOffset(0,1), ZIndex = 3}, row)
    local _, fill = framedBox(boxBtn, "OuterBorder", "InnerBorder", "ChildFill", {ZIndex = 3})
    local accent = newInstance("Frame", {BackgroundColor3 = Lib.Theme.Accent, BorderSizePixel = 0, Size = UDim2.fromScale(1,1), BackgroundTransparency = state and 0 or 1, ZIndex = 3}, fill)
    vGradient(accent, "Accent", "AccentDark")

    local label = outlined(row, text, state and "TextActive" or "TextInactive", {Position = UDim2.fromOffset(19,0), Size = UDim2.new(1,-19,1,0), ZIndex = 3})

    Lib:RegisterThemeCallback(function()
        label.TextColor3 = state and Lib.Theme.TextActive or Lib.Theme.TextInactive
    end)

    local function set(v, fireCb)
        state = v and true or false
        if flag then Lib.Flags[flag] = state end
        tween(accent, 0.12, {BackgroundTransparency = state and 0 or 1}):Play()
        tween(label, 0.12, {TextColor3 = state and Lib.Theme.TextActive or Lib.Theme.TextInactive}):Play()
        if fireCb ~= false and callback then task.spawn(callback, state) end
    end

    boxBtn.MouseButton1Click:Connect(function() set(not state, true) end)
    boxBtn.MouseEnter:Connect(function() if not state then tween(fill,0.12,{BackgroundColor3 = Color3.fromRGB(39,40,57)}):Play() end end)
    boxBtn.MouseLeave:Connect(function() if not state then tween(fill,0.12,{BackgroundColor3 = Lib.Theme.ChildFill}):Play() end end)

    if extra.colors then
        local sx = 0
        for _, c in ipairs(extra.colors) do
            sx = sx + 14
            self:_swatch(row, c, UDim2.new(1, -sx, 0, 1), c.flag)
        end
    end

    local ctrl = {Set = function(_, v, f) set(v, f) end, Get = function() return state end}
    if flag then
        Lib.Flags[flag] = state
        Lib.Controls[flag] = ctrl
        Lib.Defaults[flag] = state
    end
    if callback and default ~= nil then task.spawn(callback, state) end
    return ctrl
end

function Lib._GroupMethods:_swatch(row, cfg, pos, flag)
    local color = cfg.default or Lib.Theme.Accent
    local btn = newInstance("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.fromOffset(12,12), Position = pos, ZIndex = 4}, row)
    local _, fill = framedBox(btn, "OuterBorder", "InnerBorder", color, {ZIndex = 4})

    local function set(c, fireCb)
        color = c
        fill.BackgroundColor3 = c
        if flag then Lib.Flags[flag] = c end
        if fireCb ~= false and cfg.callback then task.spawn(cfg.callback, c) end
    end

    btn.MouseButton1Click:Connect(function()
        closeAllPopups()
        local abs = btn.AbsolutePosition
        Lib._ColorPicker(popupLayer, abs + Vector2.new(0, 14), color, function(c)
            set(c, true)
        end)
    end)

    local ctrl = {Set = function(_, c, f) set(c, f) end, Get = function() return color end}
    if flag then
        Lib.Flags[flag] = color
        Lib.Controls[flag] = ctrl
        Lib.Defaults[flag] = color
    end
    return btn
end

function Lib._GroupMethods:ColorPicker(text, default, callback, flag)
    local color = default or Lib.Theme.Accent
    local row = nextRow(self, 14)
    outlined(row, text, "TextInactive", {Position = UDim2.fromOffset(0,0), Size = UDim2.new(1,-20,1,0), ZIndex = 3})

    local btn = newInstance("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.fromOffset(12,12), Position = UDim2.new(1,-12,0,1), ZIndex = 4}, row)
    local _, fill = framedBox(btn, "OuterBorder", "InnerBorder", color, {ZIndex = 4})

    local function set(c, fireCb)
        color = c
        fill.BackgroundColor3 = c
        if flag then Lib.Flags[flag] = c end
        if fireCb ~= false and callback then task.spawn(callback, c) end
    end

    btn.MouseButton1Click:Connect(function()
        closeAllPopups()
        local abs = btn.AbsolutePosition
        Lib._ColorPicker(popupLayer, abs + Vector2.new(0, 14), color, function(c)
            set(c, true)
        end)
    end)

    local ctrl = {Set = function(_, c, f) set(c, f) end, Get = function() return color end}
    if flag then
        Lib.Flags[flag] = color
        Lib.Controls[flag] = ctrl
        Lib.Defaults[flag] = color
    end
    return ctrl
end

function Lib._GroupMethods:Slider(text, o, callback, flag)
    o = o or {}
    local minv, maxv = o.min or 0, o.max or 1
    local decimals   = o.decimals ~= nil and o.decimals or 3
    local isInt      = o.int and true or false
    local suffix     = o.suffix or ""
    local value      = o.default or minv

    local row = nextRow(self, 28)
    local label = outlined(row, text, "TextInactive", {Position = UDim2.fromOffset(1,0), Size = UDim2.fromOffset(120,13), TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 3})
    local valLbl = outlined(row, "", "TextInactive", {Position = UDim2.new(1,-120,0,0), Size = UDim2.fromOffset(120,13), TextXAlignment = Enum.TextXAlignment.Right, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 3})

    local track = newInstance("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Position = UDim2.fromOffset(0,16), Size = UDim2.new(1,0,0,12), ZIndex = 3}, row)
    local _, tFill = framedBox(track, "OuterBorder", "InnerBorder", "ChildFill", {ZIndex = 3})
    local prog = newInstance("Frame", {BackgroundColor3 = Lib.Theme.Accent, BorderSizePixel = 0, Size = UDim2.fromScale(0,1), ZIndex = 3}, tFill)
    vGradient(prog, "Accent", "AccentDark")

    local function fmt(v)
        if isInt then return string.format("%d%s", v, suffix) end
        return string.format("%." .. decimals .. "f%s", v, suffix)
    end
    local function render()
        local t = (maxv > minv) and (value - minv) / (maxv - minv) or 0
        prog.Size = UDim2.fromScale(math.clamp(t, 0, 1), 1)
        valLbl.Text = fmt(value)
    end
    local function set(v, fireCb)
        v = math.clamp(v, minv, maxv)
        if isInt then v = math.floor(v + 0.5) end
        value = v; render()
        if flag then Lib.Flags[flag] = value end
        if fireCb ~= false and callback then task.spawn(callback, value) end
    end

    local dragging = false
    local function fromInput(i)
        local inputX = i.Position.X
        local rel = (inputX - tFill.AbsolutePosition.X) / tFill.AbsoluteSize.X
        set(minv + math.clamp(rel, 0, 1) * (maxv - minv), true)
    end

    track.InputBegan:Connect(function(i)
        if isTouchOrMouse(i) then dragging = true; fromInput(i) end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and isMoveInput(i) then fromInput(i) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if isTouchOrMouse(i) then dragging = false end
    end)
    track.MouseEnter:Connect(function() tween(label,0.12,{TextColor3=Lib.Theme.TextActive}):Play(); tween(valLbl,0.12,{TextColor3=Lib.Theme.TextActive}):Play() end)
    track.MouseLeave:Connect(function() if not dragging then tween(label,0.12,{TextColor3=Lib.Theme.TextInactive}):Play(); tween(valLbl,0.12,{TextColor3=Lib.Theme.TextInactive}):Play() end end)

    render()
    local ctrl = {Set = function(_, v, f) set(v, f) end, Get = function() return value end}
    if flag then
        Lib.Flags[flag] = value
        Lib.Controls[flag] = ctrl
        Lib.Defaults[flag] = value
    end
    if callback and o.default ~= nil then task.spawn(callback, value) end
    return ctrl
end

function Lib._GroupMethods:Keybind(text, default, callback, flag)
    local row = nextRow(self, 14)
    outlined(row, text, "TextInactive", {Position = UDim2.fromOffset(0,0), Size = UDim2.new(1,-38,1,0), ZIndex = 3})
    
    local box = newInstance("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,0,0,1), Size = UDim2.fromOffset(32,12), ZIndex = 4}, row)
    local _, bFill = framedBox(box, "OuterBorder", "InnerBorder", "ChildFill", {ZIndex = 4})
    local lbl = outlined(bFill, keyName(default), "TextInactive", {Size = UDim2.fromScale(1,1), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 5, TextSize = 11})
    
    local listening = false
    local key = default
    
    local function set(k, fireCb)
        key = k
        lbl.Text = keyName(k)
        if flag then Lib.Flags[flag] = key end
        if fireCb ~= false and callback then task.spawn(callback, k) end
    end
    
    box.MouseButton1Click:Connect(function()
        listening = true
        lbl.Text = "..."
        lbl.TextColor3 = Lib.Theme.Accent
        local conn
        conn = UserInputService.InputBegan:Connect(function(inp, gp)
            if not listening then return end
            local k
            if inp.UserInputType == Enum.UserInputType.Keyboard then
                if inp.KeyCode == Enum.KeyCode.Escape then k = nil else k = inp.KeyCode end
            elseif inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.MouseButton2 or inp.UserInputType == Enum.UserInputType.MouseButton3 or inp.UserInputType == Enum.UserInputType.Touch then
                k = inp.UserInputType
            else return end
            listening = false
            conn:Disconnect()
            set(k, true)
            lbl.TextColor3 = Lib.Theme.TextInactive
        end)
    end)
    
    local ctrl = {Set = function(_, k, f) set(k, f) end, Get = function() return key end}
    if flag then
        Lib.Flags[flag] = key
        Lib.Controls[flag] = ctrl
        Lib.Defaults[flag] = key
    end
    return ctrl
end

local function plusIcon(parent, colorKey)
    local host = newInstance("Frame", {
        Name = "Icon", BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -5, 0.5, 0),
        Size = UDim2.fromOffset(7, 7), ZIndex = 4,
    }, parent)
    local color = type(colorKey) == "string" and Lib.Theme[colorKey] or colorKey
    local hbar = newInstance("Frame", {BackgroundColor3 = color, BorderSizePixel = 0, Position = UDim2.fromOffset(0,3), Size = UDim2.fromOffset(7,1), ZIndex = 4}, host)
    local vbar = newInstance("Frame", {BackgroundColor3 = color, BorderSizePixel = 0, Position = UDim2.fromOffset(3,0), Size = UDim2.fromOffset(1,7), ZIndex = 4}, host)
    if type(colorKey) == "string" then
        Lib:RegisterTheme(hbar, "BackgroundColor3", colorKey)
        Lib:RegisterTheme(vbar, "BackgroundColor3", colorKey)
    end
    return {
        SetOpen = function(open) vbar.Visible = not open end,
        IsOpen  = function() return not vbar.Visible end,
    }
end

local function buildComboPopup(box, items, isMulti, getState, onPick)
    closeAllPopups()
    local ITEM_H = 16
    local targetH = #items * ITEM_H + 4

    local boxAbs = box.AbsolutePosition
    local sz = box.AbsoluteSize

    local blocker = newInstance("TextButton", {
        Name = "Blocker", BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
        Size = UDim2.fromScale(1, 1), ZIndex = 501,
    }, screenGui)
    blocker.MouseButton1Click:Connect(closeAllPopups)

    local pop = newInstance("Frame", {
        Name = "DropdownPopup",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(boxAbs.X, boxAbs.Y + sz.Y + 4),
        Size = UDim2.fromOffset(sz.X, targetH),
        ClipsDescendants = true,
        ZIndex = 502,
    }, screenGui)

    local _, pfill = framedBox(pop, "OuterBorder", "ComboInner", "ComboFill", {ZIndex = 502})
    pfill.Size = UDim2.new(1, -2, 1, -2)

    local mask = newInstance("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ClipsDescendants = true,
        ZIndex = 503,
    }, pfill)

    local itemsContainer = newInstance("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, -targetH),
        Size = UDim2.new(1, 0, 0, targetH),
        ZIndex = 503,
    }, mask)

    for i, it in ipairs(items) do
        local ib = newInstance("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Position = UDim2.fromOffset(0, (i-1)*ITEM_H), Size = UDim2.new(1,0,0,ITEM_H), ClipsDescendants = true, ZIndex = 504}, itemsContainer)
        local sel = getState(i)
        local il = outlined(ib, (sel and "> " or "") .. it, sel and "ComboSelected" or "TextInactive", {Position = UDim2.fromOffset(5,0), Size = UDim2.new(1,-7,1,0), ZIndex = 505})
        ib.MouseEnter:Connect(function() if not getState(i) then tween(il,0.1,{TextColor3=Lib.Theme.TextActive}):Play() end end)
        ib.MouseLeave:Connect(function() if not getState(i) then tween(il,0.1,{TextColor3=Lib.Theme.TextInactive}):Play() end end)
        ib.MouseButton1Click:Connect(function()
            onPick(i)
            if isMulti then
                local s = getState(i)
                il.Text = (s and "> " or "") .. it
                il.TextColor3 = s and Lib.Theme.ComboSelected or Lib.Theme.TextInactive
            else
                closeAllPopups()
            end
        end)
    end

    tween(itemsContainer, 0.15, {Position = UDim2.fromOffset(0, 0)}):Play()

    openPopups[#openPopups + 1] = function()
        blocker:Destroy()
        pop:Destroy()
    end
    return pop
end

function Lib._GroupMethods:Combo(text, items, default, callback, flag)
    local index = default or 1
    local row = nextRow(self, 34)
    outlined(row, text, "TextInactive", {Position = UDim2.fromOffset(1,0), Size = UDim2.fromOffset(120,13), TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 3})

    local box = newInstance("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Position = UDim2.fromOffset(0,16), Size = UDim2.new(1,0,0,18), ClipsDescendants = true, ZIndex = 3}, row)
    local _, bFill = framedBox(box, "OuterBorder", "ComboInner", "ComboFill", {ZIndex = 3})
    local preview = outlined(box, items[index] or "", "TextInactive", {Position = UDim2.fromOffset(5,1), Size = UDim2.new(1,-20,1,-2), TextSize = 12, ZIndex = 4})
    local icon = plusIcon(box, "Accent")

    local function set(i, fireCb)
        index = i
        preview.Text = items[index] or ""
        if flag then Lib.Flags[flag] = index end
        if fireCb ~= false and callback then task.spawn(callback, index, items[index]) end
    end

    box.MouseEnter:Connect(function() tween(preview,0.12,{TextColor3=Lib.Theme.TextActive}):Play() end)
    box.MouseLeave:Connect(function() tween(preview,0.12,{TextColor3=Lib.Theme.TextInactive}):Play() end)
    box.MouseButton1Click:Connect(function()
        if icon.IsOpen() then closeAllPopups(); icon.SetOpen(false); return end
        icon.SetOpen(true)
        buildComboPopup(box, items, false, function(i) return i == index end, function(i)
            set(i, true)
        end)
        openPopups[#openPopups + 1] = function() icon.SetOpen(false) end
    end)

    local ctrl = {
        Set = function(_, i, f) set(i, f) end,
        Get = function() return index, items[index] end,
        Refresh = function(_, newItems)
            items = newItems
            index = math.clamp(index, 1, #items)
            preview.Text = items[index] or ""
            if flag then Lib.Flags[flag] = index end
        end
    }
    if flag then
        Lib.Flags[flag] = index
        Lib.Controls[flag] = ctrl
        Lib.Defaults[flag] = index
    end
    if callback and default then task.spawn(callback, index, items[index]) end
    return ctrl
end

function Lib._GroupMethods:MultiCombo(text, items, defaults, callback, flag)
    local state = {}
    for i = 1, #items do state[i] = defaults and defaults[i] or false end
    local row = nextRow(self, 34)
    outlined(row, text, "TextInactive", {Position = UDim2.fromOffset(1,0), Size = UDim2.fromOffset(120,13), TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 3})

    local box = newInstance("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Position = UDim2.fromOffset(0,16), Size = UDim2.new(1,0,0,18), ClipsDescendants = true, ZIndex = 3}, row)
    local _, bFill = framedBox(box, "OuterBorder", "ComboInner", "ComboFill", {ZIndex = 3})
    local preview = outlined(box, "", "TextInactive", {Position = UDim2.fromOffset(5,1), Size = UDim2.new(1,-20,1,-2), TextSize = 12, ZIndex = 4})
    local icon = plusIcon(box, "Accent")

    local function refresh()
        local parts = {}
        for i, on in ipairs(state) do if on then parts[#parts+1] = items[i] end end
        preview.Text = (#parts == 0) and "none showing" or table.concat(parts, ", ")
    end
    refresh()

    local function set(st, fireCb)
        state = st
        refresh()
        if flag then Lib.Flags[flag] = shallowCopy(state) end
        if fireCb ~= false and callback then task.spawn(callback, shallowCopy(state)) end
    end

    box.MouseEnter:Connect(function() tween(preview,0.12,{TextColor3=Lib.Theme.TextActive}):Play() end)
    box.MouseLeave:Connect(function() tween(preview,0.12,{TextColor3=Lib.Theme.TextInactive}):Play() end)
    box.MouseButton1Click:Connect(function()
        if icon.IsOpen() then closeAllPopups(); icon.SetOpen(false); return end
        icon.SetOpen(true)
        buildComboPopup(box, items, true, function(i) return state[i] end, function(i)
            state[i] = not state[i]
            refresh()
            if flag then Lib.Flags[flag] = shallowCopy(state) end
            if callback then task.spawn(callback, shallowCopy(state)) end
        end)
        openPopups[#openPopups + 1] = function() icon.SetOpen(false) end
    end)

    local ctrl = {Set = function(_, st, f) set(st, f) end, Get = function() return shallowCopy(state) end}
    if flag then
        Lib.Flags[flag] = shallowCopy(state)
        Lib.Controls[flag] = ctrl
        Lib.Defaults[flag] = shallowCopy(state)
    end
    return ctrl
end

function Lib._GroupMethods:TextBox(text, default, callback, flag)
    local row = nextRow(self, 34)
    outlined(row, text, "TextInactive", {Position = UDim2.fromOffset(1,0), Size = UDim2.fromOffset(120,13), TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 3})
    local boxFrame = newInstance("Frame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(0,16), Size = UDim2.new(1,0,0,18), ZIndex = 3}, row)
    local _, bFill = framedBox(boxFrame, "OuterBorder", "ComboInner", "ComboFill", {ZIndex = 3})
    local tb = newInstance("TextBox", { BackgroundTransparency = 1, Text = default or "", TextColor3 = Lib.Theme.TextActive, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.fromOffset(5, 0), Size = UDim2.new(1, -10, 1, 0), ClearTextOnFocus = false, ZIndex = 4 }, bFill)
    applyFont(tb, false)
    Lib:RegisterTheme(tb, "TextColor3", "TextActive")
    local function set(str, fireCb)
        tb.Text = str or ""
        if flag then Lib.Flags[flag] = str end
        if fireCb ~= false and callback then task.spawn(callback, str) end
    end
    tb.FocusLost:Connect(function() set(tb.Text, true) end)
    local ctrl = {Set = function(_, str, f) set(str, f) end, Get = function() return tb.Text end}
    if flag then Lib.Flags[flag] = default or ""; Lib.Controls[flag] = ctrl; Lib.Defaults[flag] = default or "" end
    return ctrl
end

function Lib._GroupMethods:Button(text, callback)
    local row = nextRow(self, 20)
    local btn = newInstance("TextButton", { Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), ZIndex = 3 }, row)
    local _, fill = framedBox(btn, "OuterBorder", "InnerBorder", "ComboFill", {ZIndex = 3})
    outlined(btn, text, "TextActive", { Size = UDim2.fromScale(1,1), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 4 })
    btn.MouseButton1Click:Connect(function() if callback then task.spawn(callback) end end)
    btn.MouseEnter:Connect(function() tween(fill, 0.12, {BackgroundColor3 = Color3.fromRGB(35, 36, 45)}):Play() end)
    btn.MouseLeave:Connect(function() tween(fill, 0.12, {BackgroundColor3 = Lib.Theme.ComboFill}):Play() end)
end

function Lib._GroupMethods:Label(text)
    local row = nextRow(self, 14)
    outlined(row, text, "TextInactive", {Size = UDim2.fromScale(1,1), ZIndex = 3})
end

function Lib._ColorPicker(parent, pos, startColor, onChange)
    local h, s, v = Color3.toHSV(startColor)
    local W = 150
    local pop = newInstance("Frame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(pos.X - W + 12, pos.Y), Size = UDim2.fromOffset(W, 120), ZIndex = 510}, parent)
    local _, pf = framedBox(pop, "OuterBorder", "InnerBorder", "PanelFill", {ZIndex = 510})

    local sv = newInstance("ImageButton", {BackgroundColor3 = Color3.fromHSV(h,1,1), BorderSizePixel = 0, Position = UDim2.fromOffset(6,6), Size = UDim2.fromOffset(W-30, 100), ZIndex = 511, AutoButtonColor = false}, pf)
    local white = newInstance("Frame", {BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, Size = UDim2.fromScale(1,1), ZIndex = 511}, sv)
    newInstance("UIGradient", {Rotation = 0, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)})}, white)
    local blk = newInstance("Frame", {BackgroundColor3 = Color3.new(0,0,0), BorderSizePixel = 0, Size = UDim2.fromScale(1,1), ZIndex = 511}, sv)
    newInstance("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)})}, blk)

    local circle = newInstance("Frame", { Name = "Indicator", Size = UDim2.fromOffset(7, 7), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), Position = UDim2.fromScale(s, 1 - v), ZIndex = 514 }, sv)
    newInstance("UICorner", {CornerRadius = UDim.new(1, 0)}, circle)
    newInstance("UIStroke", {Color = Color3.new(0, 0, 0), Thickness = 1}, circle)

    local hue = newInstance("ImageButton", {BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, Position = UDim2.new(1,-16,0,6), Size = UDim2.fromOffset(12,100), ZIndex = 511, AutoButtonColor = false}, pf)
    local hg = newInstance("UIGradient", {Rotation = 90}, hue)
    hg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(0.34, Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
        ColorSequenceKeypoint.new(0.84, Color3.fromRGB(255,0,255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,0,0)),
    })

    local function updateIndicator()
        circle.Position = UDim2.fromScale(math.clamp(s, 0, 1), math.clamp(1 - v, 0, 1))
    end
    local function push()
        updateIndicator()
        if onChange then onChange(Color3.fromHSV(h,s,v)) end
    end
    local function updateSV()
        sv.BackgroundColor3 = Color3.fromHSV(h,1,1)
        push()
    end

    local dragSV, dragHue = false, false
    local function handlePickerInput(i)
        local inputPos = Vector2.new(i.Position.X, i.Position.Y)
        if dragSV then
            s = math.clamp((inputPos.X - sv.AbsolutePosition.X)/sv.AbsoluteSize.X, 0, 1)
            v = 1 - math.clamp((inputPos.Y - sv.AbsolutePosition.Y)/sv.AbsoluteSize.Y, 0, 1)
            push()
        elseif dragHue then
            h = math.clamp((inputPos.Y - hue.AbsolutePosition.Y)/hue.AbsoluteSize.Y, 0, 1)
            updateSV()
        end
    end

    sv.InputBegan:Connect(function(i) if isTouchOrMouse(i) then dragSV = true; handlePickerInput(i) end end)
    hue.InputBegan:Connect(function(i) if isTouchOrMouse(i) then dragHue = true; handlePickerInput(i) end end)
    UserInputService.InputEnded:Connect(function(i) if isTouchOrMouse(i) then dragSV, dragHue = false, false end end)
    UserInputService.InputChanged:Connect(function(i) if isMoveInput(i) and (dragSV or dragHue) then handlePickerInput(i) end end)

    local blocker = newInstance("TextButton", { Name = "Blocker", BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Size = UDim2.fromScale(1, 1), ZIndex = 509 }, parent)
    blocker.MouseButton1Click:Connect(function() if not dragSV and not dragHue then closeAllPopups() end end)

    updateIndicator()
    openPopups[#openPopups+1] = function() blocker:Destroy(); pop:Destroy() end
end

function Lib:CreateConfigManager(tab, side)
    local group = tab:Group("Config Manager", side or "left")
    
    local configCombo
    local nameBox = group:TextBox("Config Name", "my_config", function(str) end, "_cfg_name")
    
    local function refreshDropdown()
        local list = scanConfigFiles()
        if #list == 0 then list = {"none"} end
        if configCombo and configCombo.Refresh then
            configCombo:Refresh(list)
            configCombo:Set(1, false)
        end
    end
    
    configCombo = group:Combo("Saved Configs", scanConfigFiles(), 1, function(idx, name)
        if name and name ~= "none" then
            nameBox:Set(name, false)
        end
    end, "_cfg_combo")
    
    group:Button("Save Config", function()
        local name = nameBox:Get()
        if name and name ~= "" then
            Lib:SaveConfig(name)
            refreshDropdown()
        end
    end)
    
    group:Button("Load Config", function()
        local _, name = configCombo:Get()
        if name and name ~= "none" then
            Lib:LoadConfig(name)
        end
    end)
    
    group:Button("Delete Config", function()
        local _, name = configCombo:Get()
        if name and name ~= "none" then
            Lib:DeleteConfig(name)
            refreshDropdown()
        end
    end)

    group:Button("Refresh", function()
        refreshDropdown()
    end)
    
    group:Button("Reset to Defaults", function()
        Lib:ResetToDefaults()
    end)
    
    refreshDropdown()
    return group
end

function Lib:CreateThemeManager(tab, side)
    local group = tab:Group("Theme Manager", side or "right")
    
    local themeCombo
    local nameBox = group:TextBox("Theme Name", "my_theme", function(str) end, "_theme_name")
    
    group:Combo("Preset Theme", {"Default", "Tokyo Night", "Crimson", "Emerald"}, 1, function(idx, name)
        Lib:SetPresetTheme(name)
    end, "_theme_preset")
    
    local function refreshDropdown()
        local list = scanThemeFiles()
        if #list == 0 then list = {"none"} end
        if themeCombo and themeCombo.Refresh then
            themeCombo:Refresh(list)
            themeCombo:Set(1, false)
        end
    end
    
    themeCombo = group:Combo("Saved Themes", scanThemeFiles(), 1, function(idx, name)
        if name and name ~= "none" then
            nameBox:Set(name, false)
        end
    end, "_theme_combo")
    
    group:Button("Save Theme", function()
        local name = nameBox:Get()
        if name and name ~= "" then
            Lib:SaveTheme(name)
            refreshDropdown()
        end
    end)
    
    group:Button("Load Theme", function()
        local _, name = themeCombo:Get()
        if name and name ~= "none" then
            Lib:LoadTheme(name)
        end
    end)
    
    group:Button("Delete Theme", function()
        local _, name = themeCombo:Get()
        if name and name ~= "none" then
            Lib:DeleteTheme(name)
            refreshDropdown()
        end
    end)

    group:Button("Refresh", function()
        refreshDropdown()
    end)
    
    group:Button("Reset Theme to Default", function()
        Lib:ResetThemeToDefault()
    end)
    
    refreshDropdown()
    return group
end

function Lib:CreateUICustomization(tab, side)
    local group = tab:Group("UI Customization", side or "left")

    group:Checkbox("UI Expansion (Resize)", Lib.UIExpansion, function(val)
        Lib.UIExpansion = val
        if Lib._UpdateResizeVisibility then
            Lib._UpdateResizeVisibility()
        end
    end, nil, "_ui_expansion")

    local leftText = Lib.WatermarkOptions.leftText or "Lunex UI"
    local rightText = Lib.WatermarkOptions.rightText or "v1.0"
    local leftColor = Lib.WatermarkOptions.leftColor or Lib.Theme.TextActive
    local rightColor = Lib.WatermarkOptions.rightColor or Lib.Theme.Accent

    group:Checkbox("Show Watermark", Lib.WatermarkVisible, function(val)
        Lib.WatermarkVisible = val
        Lib:_UpdateWatermark()
    end, nil, "_watermark_visible")

    group:TextBox("Left Text", leftText, function(str)
        Lib.WatermarkOptions.leftText = str
        Lib:_UpdateWatermark()
    end, "_watermark_left_text")

    group:ColorPicker("Left Color", leftColor, function(col)
        Lib.WatermarkOptions.leftColor = col
        Lib:_UpdateWatermark()
    end, "_watermark_left_color")

    group:TextBox("Right Text", rightText, function(str)
        Lib.WatermarkOptions.rightText = str
        Lib:_UpdateWatermark()
    end, "_watermark_right_text")

    group:ColorPicker("Right Color", rightColor, function(col)
        Lib.WatermarkOptions.rightColor = col
        Lib:_UpdateWatermark()
    end, "_watermark_right_color")

    group:Label("────────── Theme Colors ──────────")

    group:ColorPicker("Accent", Lib.Theme.Accent, function(col)
        Lib.Theme.Accent = col
        Lib.Theme.AccentDark = Color3.new(col.R*0.7, col.G*0.7, col.B*0.7)
        Lib:RefreshTheme()
    end, "_ui_accent")

    group:ColorPicker("Text Active", Lib.Theme.TextActive, function(col)
        Lib.Theme.TextActive = col
        Lib:RefreshTheme()
    end, "_ui_text_active")

    group:ColorPicker("Text Inactive", Lib.Theme.TextInactive, function(col)
        Lib.Theme.TextInactive = col
        Lib:RefreshTheme()
    end, "_ui_text_inactive")

    group:ColorPicker("Panel Background", Lib.Theme.PanelFill, function(col)
        Lib.Theme.PanelFill = col
        Lib:RefreshTheme()
    end, "_ui_panel_fill")

    group:ColorPicker("Content Background", Lib.Theme.ContentFill, function(col)
        Lib.Theme.ContentFill = col
        Lib:RefreshTheme()
    end, "_ui_content_fill")

    group:ColorPicker("Group Background", Lib.Theme.ChildFill, function(col)
        Lib.Theme.ChildFill = col
        Lib:RefreshTheme()
    end, "_ui_child_fill")

    group:ColorPicker("Header Top", Lib.Theme.HeaderTop, function(col)
        Lib.Theme.HeaderTop = col
        Lib:RefreshTheme()
    end, "_ui_header_top")

    group:ColorPicker("Header Bottom", Lib.Theme.HeaderBottom, function(col)
        Lib.Theme.HeaderBottom = col
        Lib:RefreshTheme()
    end, "_ui_header_bottom")

    group:ColorPicker("Outer Border", Lib.Theme.OuterBorder, function(col)
        Lib.Theme.OuterBorder = col
        Lib:RefreshTheme()
    end, "_ui_outer_border")

    group:ColorPicker("Inner Border", Lib.Theme.InnerBorder, function(col)
        Lib.Theme.InnerBorder = col
        Lib:RefreshTheme()
    end, "_ui_inner_border")

    group:ColorPicker("Tab Inactive", Lib.Theme.TabInactive, function(col)
        Lib.Theme.TabInactive = col
        Lib:RefreshTheme()
    end, "_ui_tab_inactive")

    group:ColorPicker("Tab Hover", Lib.Theme.TabHover, function(col)
        Lib.Theme.TabHover = col
        Lib:RefreshTheme()
    end, "_ui_tab_hover")

    return group
end

Lib.WatermarkVisible = false
Lib.WatermarkOptions = {}
Lib._WatermarkHost = nil

function Lib:_UpdateWatermark()
    local opts = Lib.WatermarkOptions or {}
    local leftColor = opts.leftColor or Lib.Theme.TextActive
    local rightColor = opts.rightColor or Lib.Theme.Accent
    local leftText = opts.leftText or "Lunex UI"
    local rightText = opts.rightText or "v1.0"
    local buildText = opts.buildText or "" .. os.date("%b %d %Y")

    if Lib._WatermarkHost then
        Lib._WatermarkHost:Destroy()
        Lib._WatermarkHost = nil
    end

    if not Lib.WatermarkVisible then return end

    local PAD, GAP, H = 8, 4, 21
    local parts = {
        {t = leftText,  color = leftColor},
        {t = rightText, color = rightColor},
        {t = buildText, color = Color3.fromRGB(100,100,100)},
    }
    local total = PAD * 2
    for i, p in ipairs(parts) do
        total = total + TextServ:GetTextSize(p.t, TEXT_SIZE, FONT, Vector2.new(10000, 100)).X
        if i < #parts then total = total + GAP end
    end
    local host = newInstance("Frame", { Name = "Watermark", BackgroundColor3 = Lib.Theme.OuterBorder, BorderSizePixel = 0, Position = UDim2.fromOffset(10, 55), Size = UDim2.fromOffset(math.ceil(total), H), ZIndex = 400 }, screenGui)
    Lib:RegisterTheme(host, "BackgroundColor3", "OuterBorder")
    local fInner = newInstance("Frame", {BackgroundColor3 = Lib.Theme.InnerBorder, BorderSizePixel = 0, Position = UDim2.fromOffset(1,1), Size = UDim2.new(1,-2,1,-2), ZIndex = 400}, host)
    Lib:RegisterTheme(fInner, "BackgroundColor3", "InnerBorder")
    local fill = newInstance("Frame", {BackgroundColor3 = Lib.Theme.PanelFill, BorderSizePixel = 0, Position = UDim2.fromOffset(2,2), Size = UDim2.new(1,-4,1,-4), ZIndex = 400}, host)
    Lib:RegisterTheme(fill, "BackgroundColor3", "PanelFill")
    vGradient(fill, "HeaderTop", "HeaderBottom")
    local strip = newInstance("Frame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(PAD - 2, 0), Size = UDim2.new(1,-(PAD-2),1,0), ZIndex = 401}, fill)
    newInstance("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0,GAP), SortOrder = Enum.SortOrder.LayoutOrder}, strip)
    for i, p in ipairs(parts) do
        local lbl = newInstance("TextLabel", {
            BackgroundTransparency = 1,
            Text = p.t,
            TextColor3 = p.color,
            TextSize = TEXT_SIZE,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            TextStrokeColor3 = Lib.Theme.OuterBorder,
            TextStrokeTransparency = STROKE_T,
            TextTruncate = Enum.TextTruncate.None,
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, H - 4),
            LayoutOrder = i,
            ZIndex = 401,
        }, strip)
        applyFont(lbl, false)
        Lib:RegisterTheme(lbl, "TextStrokeColor3", "OuterBorder")
    end
    local grab = newInstance("TextButton", { Name = "Drag", Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 402 }, host)
    local dragging, startPos, startInput = false, nil, nil
    grab.InputBegan:Connect(function(i)
        if isTouchOrMouse(i) then dragging, startPos, startInput = true, host.Position, Vector2.new(i.Position.X, i.Position.Y); closeAllPopups() end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and isMoveInput(i) then
            local curPos = Vector2.new(i.Position.X, i.Position.Y)
            local d = curPos - startInput
            host.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i) if isTouchOrMouse(i) then dragging = false end end)

    Lib._WatermarkHost = host
end

function Lib:CreateMobileToggle(onToggle)
    local host = newInstance("Frame", { Name = "MobileToggle", BackgroundColor3 = Lib.Theme.OuterBorder, BorderSizePixel = 0, Position = UDim2.new(0, 15, 0.4, 0), Size = UDim2.fromOffset(42, 42), ZIndex = 600 }, screenGui)
    Lib:RegisterTheme(host, "BackgroundColor3", "OuterBorder")
    local fInner = newInstance("Frame", {BackgroundColor3 = Lib.Theme.InnerBorder, BorderSizePixel = 0, Position = UDim2.fromOffset(1,1), Size = UDim2.new(1,-2,1,-2), ZIndex = 600}, host)
    Lib:RegisterTheme(fInner, "BackgroundColor3", "InnerBorder")
    local fill = newInstance("Frame", {BackgroundColor3 = Lib.Theme.PanelFill, BorderSizePixel = 0, Position = UDim2.fromOffset(2,2), Size = UDim2.new(1,-4,1,-4), ZIndex = 600}, host)
    Lib:RegisterTheme(fill, "BackgroundColor3", "PanelFill")
    local btn = newInstance("TextButton", { Name = "ToggleBtn", Text = "UI", TextColor3 = Lib.Theme.Accent, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 601, AutoButtonColor = false }, fill)
    applyFont(btn, true)
    Lib:RegisterTheme(btn, "TextColor3", "Accent")
    local dragging, startPos, startInput = false, nil, nil
    local moved = false
    btn.InputBegan:Connect(function(i)
        if isTouchOrMouse(i) then dragging, startPos, startInput = true, host.Position, Vector2.new(i.Position.X, i.Position.Y); moved = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and isMoveInput(i) then
            local curPos = Vector2.new(i.Position.X, i.Position.Y)
            local d = curPos - startInput
            if d.Magnitude > 5 then moved = true end
            host.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if isTouchOrMouse(i) then if dragging and not moved then if onToggle then onToggle() end end; dragging = false end
    end)
    return host
end

local function makeCursor()
    local S = 11; local C = math.floor(S/2)
    local gui = newInstance("ScreenGui", {
        Name = "cursor",
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 2147483647
    }, getGuiParent())
    local host = newInstance("Frame", {
        Name = "Cross",
        BackgroundTransparency = 1,
        Active = false,
        AnchorPoint = Vector2.new(0.5,0.5),
        Size = UDim2.fromOffset(S,S),
        Visible = false,
        ZIndex = 1
    }, gui)
    local function noInput(o)
        o.Active = false
        pcall(function() o.Interactable = false end)
    end
    noInput(host)
    local function bar(colorC,x,y,w,h,z)
        local color = type(colorC) == "string" and Lib.Theme[colorC] or colorC
        local f = newInstance("Frame", {
            BackgroundColor3 = color,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(x,y),
            Size = UDim2.fromOffset(w,h),
            ZIndex = z
        }, host)
        noInput(f)
        if type(colorC) == "string" then
            Lib:RegisterTheme(f, "BackgroundColor3", colorC)
        end
    end
    bar("OuterBorder",0,C-1,S,3,1)
    bar("OuterBorder",C-1,0,3,S,1)
    bar("TextActive",1,C,S-2,1,2)
    bar("TextActive",C,1,1,S-2,2)
    return host
end

Lib.CursorEnabled = not UserInputService.TouchEnabled
local cursor = makeCursor()
local cursorConns = {}

local function moveCursor()
    local m = UserInputService:GetMouseLocation()
    cursor.Position = UDim2.fromOffset(m.X, m.Y)
end

local function setCursorEnabled(on)
    on = on and Lib.CursorEnabled
    cursor.Visible = on
    if not UserInputService.TouchEnabled then
        UserInputService.MouseIconEnabled = not on
    end
    if on and #cursorConns == 0 then
        moveCursor()
        cursorConns[1] = RunServ.RenderStepped:Connect(moveCursor)
        cursorConns[2] = UserInputService.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement then
                moveCursor()
            end
        end)
    elseif not on and #cursorConns > 0 then
        for _, c in ipairs(cursorConns) do
            c:Disconnect()
        end
        table.clear(cursorConns)
    end
end

function Lib:BindToggle(window)
    local visible = true
    setCursorEnabled(true)
    local function toggleUI()
        visible = not visible
        closeAllPopups()
        setCursorEnabled(visible)
        if visible then
            window.Canvas.Visible = true
        end
        local tw = TweenServ:Create(window.Canvas, TweenInfo.new(0.30, Enum.EasingStyle.Cubic, visible and Enum.EasingDirection.Out or Enum.EasingDirection.In), {
            GroupTransparency = visible and 0 or 1
        })
        tw:Play()
        if not visible then
            tw.Completed:Connect(function()
                window.Canvas.Visible = false
            end)
        end
    end
    UserInputService.InputBegan:Connect(function(i, gp)
        if not gp and i.KeyCode == Lib.ToggleKey then
            toggleUI()
        end
    end)
    Lib:CreateMobileToggle(toggleUI)
end

return Lib
end)()

local Window = Lib:Window({
    TitleLeft = "Lunex",
    TitleRight = "Hub",
    Size = Vector2.new(620, 480)
})

local AimbotTab = Window:Tab("Aimbot")
local VisualsTab = Window:Tab("Visuals")
local MovementTab = Window:Tab("Movement")
local MiscTab = Window:Tab("Misc")
local SettingsTab = Window:Tab("Settings")

local AimbotGroup = AimbotTab:Group("Aimbot", "left")
local SilentGroup = AimbotTab:Group("Silent Aim", "right")
local HitboxGroup = AimbotTab:Group("Hitbox", "left")

local ESPGroup = VisualsTab:Group("Player ESP", "left")
local WorldGroup = VisualsTab:Group("World", "right")
local ChamsGroup = VisualsTab:Group("Chams", "left")

local FlyGroup = MovementTab:Group("Fly", "left")
local SpeedGroup = MovementTab:Group("Speed", "right")

local MiscGroup = MiscTab:Group("Misc", "left")
local GunGroup = MiscTab:Group("Gun Mods", "right")

local UiGroup = SettingsTab:Group("UI", "left")
local ConfigGroup = SettingsTab:Group("Config", "right")

AimbotGroup:Checkbox("Aimbot", false, function(state) end, nil, "aimbot_enabled")
AimbotGroup:Checkbox("Visibility Check", true, function(state) end, nil, "vis_check")
AimbotGroup:Combo("Aim Part", {"Head", "Torso", "HumanoidRootPart"}, 1, function(idx, name) end, "aim_part")
AimbotGroup:Slider("Smoothness", {min = 0, max = 1, decimals = 2, default = 0.15}, function(val) end, "aim_smooth")
AimbotGroup:Slider("FOV", {min = 10, max = 360, default = 90, suffix = "°"}, function(val) end, "aim_fov")

SilentGroup:Checkbox("Silent Aim", false, function(state) end, nil, "silent_enabled")
SilentGroup:Combo("Method", {"Prediction", "Memory", "Raycast"}, 2, function(idx, name) end, "silent_method")
SilentGroup:Slider("Chance", {min = 0, max = 100, int = true, suffix = "%", default = 100}, function(val) end, "silent_chance")

HitboxGroup:Checkbox("Expand Hitboxes", false, function(state) end, nil, "hitbox_expand")
HitboxGroup:Slider("Head Scale", {min = 0, max = 3, decimals = 1, default = 1.5}, function(val) end, "hitbox_head")
HitboxGroup:Slider("Torso Scale", {min = 0, max = 3, decimals = 1, default = 1.2}, function(val) end, "hitbox_torso")

ESPGroup:Checkbox("Box ESP", false, function(state) end, nil, "esp_box")
ESPGroup:Checkbox("Name ESP", false, function(state) end, nil, "esp_name")
ESPGroup:Checkbox("Distance ESP", false, function(state) end, nil, "esp_distance")
ESPGroup:Checkbox("Health Bar", false, function(state) end, nil, "esp_health")
ESPGroup:ColorPicker("Box Color", Color3.fromRGB(255, 255, 255), function(c) end, "esp_box_color")
ESPGroup:ColorPicker("Name Color", Color3.fromRGB(255, 255, 255), function(c) end, "esp_name_color")

WorldGroup:Checkbox("Day / Night", false, function(state) end, nil, "world_time")
WorldGroup:Slider("Time", {min = 0, max = 24, default = 12}, function(val) end, "world_time_val")
WorldGroup:Checkbox("Full Bright", false, function(state) end, nil, "fullbright")
WorldGroup:Slider("FOV Changer", {min = 30, max = 120, default = 70}, function(val) end, "fov_changer")

ChamsGroup:Checkbox("Enable Chams", false, function(state) end, nil, "chams_enabled")
ChamsGroup:ColorPicker("Visible Color", Color3.fromRGB(0, 255, 0), function(c) end, "chams_visible")
ChamsGroup:ColorPicker("Invisible Color", Color3.fromRGB(255, 0, 0), function(c) end, "chams_occluded")

FlyGroup:Checkbox("Fly", false, function(state) end, nil, "fly_enabled")
FlyGroup:Slider("Fly Speed", {min = 1, max = 10, default = 3}, function(val) end, "fly_speed")
FlyGroup:Keybind("Fly Key", Enum.KeyCode.F, function(k) end, "fly_key")

SpeedGroup:Checkbox("Speed", false, function(state) end, nil, "speed_enabled")
SpeedGroup:Slider("Walk Speed", {min = 16, max = 100, default = 30}, function(val) end, "ws_value")
SpeedGroup:Slider("Jump Power", {min = 50, max = 200, default = 75}, function(val) end, "jp_value")

MiscGroup:Checkbox("Anti AFK", true, function(state) end, nil, "anti_afk")
MiscGroup:Checkbox("Auto Rejoin", false, function(state) end, nil, "auto_rejoin")
MiscGroup:Button("Rejoin Server", function() end)
MiscGroup:Label("Premium Features")

GunGroup:Checkbox("No Recoil", false, function(state) end, nil, "no_recoil")
GunGroup:Checkbox("No Spread", false, function(state) end, nil, "no_spread")
GunGroup:Checkbox("Infinite Ammo", false, function(state) end, nil, "inf_ammo")
GunGroup:Slider("Fire Rate", {min = 1, max = 100, int = true, default = 10}, function(val) end, "fire_rate")

UiGroup:Checkbox("UI Expansion", false, function(state)
    Lib.UIExpansion = state
    if Lib._UpdateResizeVisibility then Lib._UpdateResizeVisibility() end
end, nil, "ui_expansion")
UiGroup:Keybind("Toggle UI", Enum.KeyCode.Insert, function(k) Lib.ToggleKey = k end, "ui_toggle_key")

ConfigGroup:TextBox("Config Name", "da_hood", function(txt) end, "config_name")
ConfigGroup:Button("Save Config", function()
    local name = Lib.Controls["config_name"]:Get()
    if name and name ~= "" then Lib:SaveConfig(name) end
end)
ConfigGroup:Button("Load Config", function()
    local name = Lib.Controls["config_name"]:Get()
    if name and name ~= "" then Lib:LoadConfig(name) end
end)
ConfigGroup:Button("Reset to Defaults", function()
    Lib:ResetToDefaults()
end)

Lib:BindToggle(Window)
