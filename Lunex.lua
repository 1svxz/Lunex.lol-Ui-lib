-- ============================================================
-- LUNEX UI LIBRARY - COMPLETE FINAL VERSION
-- https://github.com/1svxz/Lunex.lol-Ui-lib
-- ============================================================

local UIS         = game:GetService("UserInputService")
local TweenService= game:GetService("TweenService")
local RunService  = game:GetService("RunService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local Players     = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local CONFIG_FOLDER = "Lunex.lol"

-- ================= HELPERS =================
local function ensureFolder()
    if makefolder and isfolder and not isfolder(CONFIG_FOLDER) then
        pcall(makefolder, CONFIG_FOLDER)
    end
end

local function cloneTable(tbl)
    local copy = {}
    for k,v in pairs(tbl) do
        if type(v) == "table" then
            copy[k] = cloneTable(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local function copyTable(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = copyTable(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local function guiParent()
    local ok, hui = pcall(function() return gethui and gethui() end)
    if ok and hui then return hui end
    local ok2, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and cg then return cg end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- ================= PRESET THEMES =================
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

-- ================= LIBRARY TABLE =================
local Library = {}
Library.__index = Library
Library.Theme    = copyTable(PRESET_THEMES.Default)
Library.Presets  = PRESET_THEMES
Library.Toggled  = true
Library.ToggleKey= Enum.KeyCode.Insert
Library.Flags    = {}
Library.Controls = {}
Library.Defaults = {}
Library.UIExpansion = false

Library.ThemeRegistry = {}
Library.ThemeCallbacks = {}
Library.ThemePickers = {}

-- ================= WATERMARK STATE =================
Library.WatermarkVisible = false
Library.WatermarkOptions = {}
Library._WatermarkHost = nil

-- ================= LIBRARY METHODS =================
function Library:RegisterTheme(inst, prop, themeKey)
    if not inst then return end
    table.insert(Library.ThemeRegistry, {Inst = inst, Prop = prop, Key = themeKey})
    if Library.Theme and Library.Theme[themeKey] then
        inst[prop] = Library.Theme[themeKey]
    end
end

function Library:RegisterThemeCallback(fn)
    table.insert(Library.ThemeCallbacks, fn)
    pcall(fn)
end

function Library:RefreshTheme()
    for i = #Library.ThemeRegistry, 1, -1 do
        local item = Library.ThemeRegistry[i]
        if item.Inst and item.Inst.Parent then
            if Library.Theme[item.Key] then
                item.Inst[item.Prop] = Library.Theme[item.Key]
            end
        else
            table.remove(Library.ThemeRegistry, i)
        end
    end
    for _, cb in ipairs(Library.ThemeCallbacks) do
        pcall(cb)
    end
    if Library.ThemePickers then
        for key, ctrl in pairs(Library.ThemePickers) do
            if ctrl and ctrl.Set and Library.Theme[key] then
                ctrl:Set(Library.Theme[key], false)
            end
        end
    end
    -- Refresh watermark if it exists and uses theme colors
    if Library._WatermarkHost and not Library.WatermarkOptions.leftColor and not Library.WatermarkOptions.rightColor then
        Library:_UpdateWatermark()
    end
end

-- ================= UI BUILDERS =================
local function new(class, props, parent)
    local o = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            if k ~= "Parent" then o[k] = v end
        end
    end
    if parent then o.Parent = parent end
    return o
end

local function applyFont(label, bold)
    if FONT_FACE then label.FontFace = FONT_FACE else label.Font = bold and FONT_BOLD or FONT end
end

local function outlined(parent, text, colorOrKey, props)
    local bold = props and props.Bold
    local color = type(colorOrKey) == "string" and Library.Theme[colorOrKey] or colorOrKey
    local l = new("TextLabel", {
        BackgroundTransparency = 1,
        Text                   = text or "",
        TextColor3             = color or Library.Theme.TextActive,
        TextSize               = TEXT_SIZE,
        TextXAlignment         = Enum.TextXAlignment.Left,
        TextYAlignment         = Enum.TextYAlignment.Center,
        TextStrokeColor3       = Library.Theme.OuterBorder,
        TextStrokeTransparency = STROKE_T,
        TextTruncate           = Enum.TextTruncate.AtEnd,
        RichText               = false,
        ZIndex                 = 5,
    }, parent)
    applyFont(l, bold)

    if type(colorOrKey) == "string" then
        Library:RegisterTheme(l, "TextColor3", colorOrKey)
    end
    Library:RegisterTheme(l, "TextStrokeColor3", "OuterBorder")

    if props then
        for k, v in pairs(props) do
            if k ~= "Bold" then l[k] = v end
        end
    end
    return l
end

local function framedBox(parent, outerC, innerC, fillC, props)
    local outerColor = type(outerC) == "string" and Library.Theme[outerC] or outerC
    local innerColor = type(innerC) == "string" and Library.Theme[innerC] or innerC
    local fillColor  = type(fillC) == "string" and Library.Theme[fillC] or fillC

    local outer = new("Frame", {
        BackgroundColor3    = outerColor,
        BorderSizePixel     = 0,
        Size                = UDim2.fromScale(1, 1),
    }, parent)
    if type(outerC) == "string" then Library:RegisterTheme(outer, "BackgroundColor3", outerC) end
    if props then for k, v in pairs(props) do outer[k] = v end end

    local inner = new("Frame", {
        BackgroundColor3 = innerColor,
        BorderSizePixel  = 0,
        Position         = UDim2.fromOffset(1, 1),
        Size             = UDim2.new(1, -2, 1, -2),
        ZIndex           = (outer.ZIndex or 1),
    }, outer)
    if type(innerC) == "string" then Library:RegisterTheme(inner, "BackgroundColor3", innerC) end

    local fill = new("Frame", {
        Name             = "Fill",
        BackgroundColor3 = fillColor,
        BorderSizePixel  = 0,
        Position         = UDim2.fromOffset(2, 2),
        Size             = UDim2.new(1, -4, 1, -4),
        ZIndex           = (outer.ZIndex or 1),
    }, outer)
    if type(fillC) == "string" then Library:RegisterTheme(fill, "BackgroundColor3", fillC) end

    return outer, fill
end

local function vGradient(frame, topC, botC, transSeq)
    frame.BackgroundColor3 = Color3.new(1, 1, 1)
    local grad = new("UIGradient", {
        Rotation = 90,
        Transparency = transSeq or NumberSequence.new(0),
    }, frame)

    local function updateGrad()
        local tColor = type(topC) == "string" and Library.Theme[topC] or topC
        local bColor = type(botC) == "string" and Library.Theme[botC] or botC
        grad.Color = ColorSequence.new(tColor, bColor)
    end

    Library:RegisterThemeCallback(updateGrad)
    return grad
end

local function tween(inst, t, goal)
    return TweenService:Create(inst, TweenInfo.new(t or 0.12, Enum.EasingStyle.Quad), goal)
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

-- ================= SCREEN GUI =================
local screenGui = new("ScreenGui", {
    Name            = "ui",
    IgnoreGuiInset  = true,
    ResetOnSpawn    = false,
    ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
    DisplayOrder    = 999,
}, guiParent())

local popupLayer = new("Frame", {
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

-- ================= TAB MANAGEMENT =================
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

-- ================= CONFIG HELPERS =================
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

local function getSavedConfigs()
    ensureFolder()
    local cfgs = {}
    if listfiles then
        local targetDir = (isfolder and isfolder(CONFIG_FOLDER)) and CONFIG_FOLDER or ""
        local ok, files = pcall(listfiles, targetDir)
        if ok and type(files) == "table" then
            for _, f in ipairs(files) do
                if f:sub(-5) == ".json" and not f:find("_theme%.json") and not f:find("autoload%.json") then
                    local name = f:match("([^\\/]+)%.json$")
                    if name and not table.find(cfgs, name) then
                        table.insert(cfgs, name)
                    end
                end
            end
        end
    end
    if #cfgs == 0 then table.insert(cfgs, "none") end
    return cfgs
end

local function getSavedThemes()
    ensureFolder()
    local themes = {}
    if listfiles then
        local targetDir = (isfolder and isfolder(CONFIG_FOLDER)) and CONFIG_FOLDER or ""
        local ok, files = pcall(listfiles, targetDir)
        if ok and type(files) == "table" then
            for _, f in ipairs(files) do
                if f:sub(-11) == "_theme.json" then
                    local name = f:match("([^\\/]+)_theme%.json$")
                    if name and not table.find(themes, name) then
                        table.insert(themes, name)
                    end
                end
            end
        end
    end
    if #themes == 0 then table.insert(themes, "none") end
    return themes
end

-- ================= CONFIG METHODS =================
function Library:GetSavedConfigs()
    return getSavedConfigs()
end

function Library:GetSavedThemes()
    return getSavedThemes()
end

function Library:SaveConfig(filename)
    if not writefile then return end
    ensureFolder()
    filename = filename or "default"
    local path = CONFIG_FOLDER .. "/" .. filename .. ".json"
    local rawData = {}
    for flag, val in pairs(Library.Flags) do
        if type(val) == "table" and not val.__type then
            local tbl = {}
            for k, v in pairs(val) do tbl[k] = serializeValue(v) end
            rawData[flag] = tbl
        else
            rawData[flag] = serializeValue(val)
        end
    end
    pcall(writefile, path, HttpService:JSONEncode(rawData))
end

function Library:LoadConfig(filename)
    if not readfile or not isfile then return end
    filename = filename or "default"
    local path = CONFIG_FOLDER .. "/" .. filename .. ".json"
    if not isfile(path) then return end
    local ok, content = pcall(readfile, path)
    if not ok then return end
    local ok2, decoded = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok2 or type(decoded) ~= "table" then return end

    for flag, val in pairs(decoded) do
        local finalVal
        if type(val) == "table" and not val.__type then
            finalVal = {}
            for k, v in pairs(val) do finalVal[k] = deserializeValue(v) end
        else
            finalVal = deserializeValue(val)
        end

        Library.Flags[flag] = finalVal
        if Library.Controls[flag] and Library.Controls[flag].Set then
            Library.Controls[flag]:Set(finalVal, true)
        end
    end
end

function Library:DeleteConfig(filename)
    if not delfile or not isfile then return end
    filename = filename or "default"
    local path = CONFIG_FOLDER .. "/" .. filename .. ".json"
    if isfile(path) then
        pcall(delfile, path)
    end
end

function Library:SetAutoLoad(filename)
    if not writefile then return end
    ensureFolder()
    filename = filename or "default"
    pcall(writefile, CONFIG_FOLDER .. "/autoload.json", HttpService:JSONEncode({autoload = filename}))
end

function Library:CheckAutoLoad()
    ensureFolder()
    local path = CONFIG_FOLDER .. "/autoload.json"
    if not isfile or not readfile or not isfile(path) then return end
    local ok, content = pcall(readfile, path)
    if not ok then return end
    local ok2, decoded = pcall(function() return HttpService:JSONDecode(content) end)
    if ok2 and type(decoded) == "table" and decoded.autoload then
        Library:LoadConfig(decoded.autoload)
    end
end

function Library:ResetToDefaults()
    for flag, defaultVal in pairs(Library.Defaults) do
        Library.Flags[flag] = cloneTable(defaultVal)
        if Library.Controls[flag] and Library.Controls[flag].Set then
            Library.Controls[flag]:Set(cloneTable(defaultVal), true)
        end
    end
end

-- ================= THEME METHODS =================
function Library:DeleteTheme(themeName)
    if not delfile or not isfile then return end
    themeName = themeName or "custom_theme"
    local path = CONFIG_FOLDER .. "/" .. themeName .. "_theme.json"
    if isfile(path) then
        pcall(delfile, path)
    end
end

function Library:SaveTheme(themeName)
    if not writefile then return end
    ensureFolder()
    themeName = themeName or "custom_theme"
    local rawTheme = {}
    for k, v in pairs(Library.Theme) do
        rawTheme[k] = serializeValue(v)
    end
    pcall(writefile, CONFIG_FOLDER .. "/" .. themeName .. "_theme.json", HttpService:JSONEncode(rawTheme))
end

function Library:LoadTheme(themeName)
    if not readfile or not isfile then return end
    themeName = themeName or "custom_theme"
    local path = CONFIG_FOLDER .. "/" .. themeName .. "_theme.json"
    if not isfile(path) then return end
    local ok, content = pcall(readfile, path)
    if not ok then return end
    local ok2, decoded = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok2 or type(decoded) ~= "table" then return end

    for k, v in pairs(decoded) do
        Library.Theme[k] = deserializeValue(v)
    end
    Library:RefreshTheme()
end

function Library:SetPresetTheme(presetName)
    if PRESET_THEMES[presetName] then
        for k, v in pairs(PRESET_THEMES[presetName]) do
            Library.Theme[k] = v
        end
        Library:RefreshTheme()
    end
end

function Library:ResetThemeToDefault()
    for k, v in pairs(PRESET_THEMES.Default) do
        Library.Theme[k] = v
    end
    Library:RefreshTheme()
end

-- ================= WATERMARK =================
function Library:_UpdateWatermark()
    local opts = Library.WatermarkOptions or {}
    local leftColor = opts.leftColor or Library.Theme.TextActive
    local rightColor = opts.rightColor or Library.Theme.Accent
    local leftText = opts.leftText or "Lunex UI"
    local rightText = opts.rightText or "v1.0"
    local buildText = opts.buildText or "build: " .. os.date("%b %d %Y")

    -- Destroy old watermark if exists
    if Library._WatermarkHost then
        Library._WatermarkHost:Destroy()
        Library._WatermarkHost = nil
    end

    if not Library.WatermarkVisible then return end

    local PAD, GAP, H = 8, 4, 21
    local parts = {
        {t = leftText,  color = leftColor},
        {t = rightText, color = rightColor},
        {t = buildText, color = Color3.fromRGB(100,100,100)},
    }
    local total = PAD * 2
    for i, p in ipairs(parts) do
        total = total + TextService:GetTextSize(p.t, TEXT_SIZE, FONT, Vector2.new(10000, 100)).X
        if i < #parts then total = total + GAP end
    end
    local host = new("Frame", { Name = "Watermark", BackgroundColor3 = Library.Theme.OuterBorder, BorderSizePixel = 0, Position = UDim2.fromOffset(10, 55), Size = UDim2.fromOffset(math.ceil(total), H), ZIndex = 400 }, screenGui)
    Library:RegisterTheme(host, "BackgroundColor3", "OuterBorder")
    local fInner = new("Frame", {BackgroundColor3 = Library.Theme.InnerBorder, BorderSizePixel = 0, Position = UDim2.fromOffset(1,1), Size = UDim2.new(1,-2,1,-2), ZIndex = 400}, host)
    Library:RegisterTheme(fInner, "BackgroundColor3", "InnerBorder")
    local fill = new("Frame", {BackgroundColor3 = Library.Theme.PanelFill, BorderSizePixel = 0, Position = UDim2.fromOffset(2,2), Size = UDim2.new(1,-4,1,-4), ZIndex = 400}, host)
    Library:RegisterTheme(fill, "BackgroundColor3", "PanelFill")
    vGradient(fill, "HeaderTop", "HeaderBottom")
    local strip = new("Frame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(PAD - 2, 0), Size = UDim2.new(1,-(PAD-2),1,0), ZIndex = 401}, fill)
    new("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0,GAP), SortOrder = Enum.SortOrder.LayoutOrder}, strip)
    for i, p in ipairs(parts) do
        -- We need to create TextLabel directly because outlined uses Theme colors and we want custom colors
        local lbl = new("TextLabel", {
            BackgroundTransparency = 1,
            Text = p.t,
            TextColor3 = p.color,
            TextSize = TEXT_SIZE,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            TextStrokeColor3 = Library.Theme.OuterBorder,
            TextStrokeTransparency = STROKE_T,
            TextTruncate = Enum.TextTruncate.None,
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, H - 4),
            LayoutOrder = i,
            ZIndex = 401,
        }, strip)
        applyFont(lbl, false)
        -- Register theme for stroke color
        Library:RegisterTheme(lbl, "TextStrokeColor3", "OuterBorder")
        -- If color is a theme key, register; but we are passing actual Color3, so not.
    end
    local grab = new("TextButton", { Name = "Drag", Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 402 }, host)
    local dragging, startPos, startInput = false, nil, nil
    grab.InputBegan:Connect(function(i)
        if isTouchOrMouse(i) then dragging, startPos, startInput = true, host.Position, Vector2.new(i.Position.X, i.Position.Y); closeAllPopups() end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and isMoveInput(i) then
            local curPos = Vector2.new(i.Position.X, i.Position.Y)
            local d = curPos - startInput
            host.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i) if isTouchOrMouse(i) then dragging = false end end)

    Library._WatermarkHost = host
end

function Library:CreateWatermark(opts)
    opts = opts or {}
    Library.WatermarkOptions = opts
    Library.WatermarkVisible = true
    Library:_UpdateWatermark()
end

-- ================= MOBILE TOGGLE =================
function Library:CreateMobileToggle(onToggle)
    local host = new("Frame", { Name = "MobileToggle", BackgroundColor3 = Library.Theme.OuterBorder, BorderSizePixel = 0, Position = UDim2.new(0, 15, 0.4, 0), Size = UDim2.fromOffset(42, 42), ZIndex = 600 }, screenGui)
    Library:RegisterTheme(host, "BackgroundColor3", "OuterBorder")
    local fInner = new("Frame", {BackgroundColor3 = Library.Theme.InnerBorder, BorderSizePixel = 0, Position = UDim2.fromOffset(1,1), Size = UDim2.new(1,-2,1,-2), ZIndex = 600}, host)
    Library:RegisterTheme(fInner, "BackgroundColor3", "InnerBorder")
    local fill = new("Frame", {BackgroundColor3 = Library.Theme.PanelFill, BorderSizePixel = 0, Position = UDim2.fromOffset(2,2), Size = UDim2.new(1,-4,1,-4), ZIndex = 600}, host)
    Library:RegisterTheme(fill, "BackgroundColor3", "PanelFill")
    local btn = new("TextButton", { Name = "ToggleBtn", Text = "UI", TextColor3 = Library.Theme.Accent, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 601, AutoButtonColor = false }, fill)
    applyFont(btn, true)
    Library:RegisterTheme(btn, "TextColor3", "Accent")
    local dragging, startPos, startInput = false, nil, nil
    local moved = false
    btn.InputBegan:Connect(function(i)
        if isTouchOrMouse(i) then dragging, startPos, startInput = true, host.Position, Vector2.new(i.Position.X, i.Position.Y); moved = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and isMoveInput(i) then
            local curPos = Vector2.new(i.Position.X, i.Position.Y)
            local d = curPos - startInput
            if d.Magnitude > 5 then moved = true end
            host.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if isTouchOrMouse(i) then if dragging and not moved then if onToggle then onToggle() end end; dragging = false end
    end)
    return host
end

-- ================= RESIZE HANDLES =================
local function addResizeHandles(canvas, onResize)
    local T = 8
    local host = new("Frame", {
        Name = "ResizeHost", BackgroundTransparency = 1, Active = false,
        Position = canvas.Position, Size = canvas.Size, ZIndex = 60,
    }, canvas.Parent)

    local function syncHost()
        host.Position = canvas.Position
        host.Size = canvas.Size
        host.Visible = canvas.Visible and (Library.UIExpansion == true)
    end
    canvas:GetPropertyChangedSignal("Position"):Connect(syncHost)
    canvas:GetPropertyChangedSignal("Size"):Connect(syncHost)
    canvas:GetPropertyChangedSignal("Visible"):Connect(syncHost)
    Library._UpdateResizeVisibility = syncHost
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
        local h = new("TextButton", {
            Name = "Resize" .. e.n, Text = "", AutoButtonColor = false,
            BackgroundTransparency = 1, Position = e.p, Size = e.s, ZIndex = 60,
        }, host)

        local active, startSize, startPos, startInput = false, nil, nil, nil
        h.InputBegan:Connect(function(i)
            if isTouchOrMouse(i) and Library.UIExpansion then
                active = true
                startSize = Vector2.new(canvas.Size.X.Offset, canvas.Size.Y.Offset)
                startPos = canvas.Position
                startInput = Vector2.new(i.Position.X, i.Position.Y)
                closeAllPopups()
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if not active or not isMoveInput(i) or not Library.UIExpansion then return end
            local curPos = Vector2.new(i.Position.X, i.Position.Y)
            local d = curPos - startInput
            local w = math.clamp(startSize.X + e.sx * d.X, MIN_SIZE.X, MAX_SIZE.X)
            local ht = math.clamp(startSize.Y + e.sy * d.Y, MIN_SIZE.Y, MAX_SIZE.Y)
            local ox = (e.sx < 0) and (startSize.X - w) or 0
            local oy = (e.sy < 0) and (startSize.Y - ht) or 0
            canvas.Size = UDim2.fromOffset(w, ht)
            canvas.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + ox,
                startPos.Y.Scale, startPos.Y.Offset + oy)
            if onResize then onResize() end
        end)
        UIS.InputEnded:Connect(function(i)
            if isTouchOrMouse(i) then active = false end
        end)
    end
end

-- ================= WINDOW =================
function Library:Window(opts)
    opts = opts or {}
    local size = opts.Size or Vector2.new(480, 450)

    local canvas = new("CanvasGroup", {
        Name              = "Window",
        AnchorPoint       = Vector2.new(0, 0),
        Position          = UDim2.new(0.5, -math.floor(size.X/2), 0.5, -math.floor(size.Y/2)),
        Size              = UDim2.fromOffset(size.X, size.Y),
        BackgroundTransparency = 1,
        GroupTransparency = 0,
        ZIndex            = 10,
    }, screenGui)

    local wOuter = new("Frame", {BackgroundColor3 = Library.Theme.OuterBorder, BorderSizePixel = 0, Size = UDim2.fromScale(1,1), ZIndex = 1}, canvas)
    Library:RegisterTheme(wOuter, "BackgroundColor3", "OuterBorder")

    local wInner = new("Frame", {BackgroundColor3 = Library.Theme.InnerBorder, BorderSizePixel = 0, Position = UDim2.fromOffset(1,1), Size = UDim2.new(1,-2,1,-2), ZIndex = 1}, wOuter)
    Library:RegisterTheme(wInner, "BackgroundColor3", "InnerBorder")

    local wFill = new("Frame", {BackgroundColor3 = Library.Theme.PanelFill, BorderSizePixel = 0, Position = UDim2.fromOffset(2,2), Size = UDim2.new(1,-4,1,-4), ZIndex = 1}, wOuter)
    Library:RegisterTheme(wFill, "BackgroundColor3", "PanelFill")

    local topBar = new("Frame", {
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

    Library:RegisterThemeCallback(function()
        local accentHex = string.format("#%02X%02X%02X", math.floor(Library.Theme.Accent.R*255), math.floor(Library.Theme.Accent.G*255), math.floor(Library.Theme.Accent.B*255))
        titleLbl.Text = string.format('%s<font color="%s">%s</font>',
            opts.TitleLeft or "remade by ", accentHex, opts.TitleRight or "angel")
    end)

    local panel = new("Frame", {Name = "Panel", BackgroundTransparency = 1, Position = UDim2.fromOffset(10,40), Size = UDim2.new(1,-20,1,-50), ZIndex = 2}, canvas)
    local pFill = new("Frame", {BackgroundColor3 = Library.Theme.ContentFill, BorderSizePixel = 0, Position = UDim2.fromOffset(2,2), Size = UDim2.new(1,-4,1,-4), ZIndex = 2}, panel)
    Library:RegisterTheme(pFill, "BackgroundColor3", "ContentFill")

    local f1 = new("Frame", {BackgroundColor3 = Library.Theme.ContentOuter, BorderSizePixel = 0, Position = UDim2.fromOffset(0,0), Size = UDim2.new(0,1,1,0), ZIndex = 2}, panel)
    Library:RegisterTheme(f1, "BackgroundColor3", "ContentOuter")
    local f2 = new("Frame", {BackgroundColor3 = Library.Theme.ContentOuter, BorderSizePixel = 0, Position = UDim2.new(1,-1,0,0), Size = UDim2.new(0,1,1,0), ZIndex = 2}, panel)
    Library:RegisterTheme(f2, "BackgroundColor3", "ContentOuter")
    local f3 = new("Frame", {BackgroundColor3 = Library.Theme.ContentOuter, BorderSizePixel = 0, Position = UDim2.new(0,0,1,-1), Size = UDim2.new(1,0,0,1), ZIndex = 2}, panel)
    Library:RegisterTheme(f3, "BackgroundColor3", "ContentOuter")
    local oT1 = new("Frame", {BackgroundColor3 = Library.Theme.ContentOuter, BorderSizePixel = 0, Position = UDim2.fromOffset(0,0), Size = UDim2.new(1,0,0,1), ZIndex = 2}, panel)
    Library:RegisterTheme(oT1, "BackgroundColor3", "ContentOuter")
    local oT2 = new("Frame", {BackgroundColor3 = Library.Theme.ContentOuter, BorderSizePixel = 0, Position = UDim2.fromOffset(0,0), Size = UDim2.fromOffset(0,1), ZIndex = 2}, panel)
    Library:RegisterTheme(oT2, "BackgroundColor3", "ContentOuter")

    local b1 = new("Frame", {BackgroundColor3 = Library.Theme.ContentInner, BorderSizePixel = 0, Position = UDim2.fromOffset(1,1), Size = UDim2.new(0,1,1,-2), ZIndex = 2}, panel)
    Library:RegisterTheme(b1, "BackgroundColor3", "ContentInner")
    local b2 = new("Frame", {BackgroundColor3 = Library.Theme.ContentInner, BorderSizePixel = 0, Position = UDim2.new(1,-2,0,1), Size = UDim2.new(0,1,1,-2), ZIndex = 2}, panel)
    Library:RegisterTheme(b2, "BackgroundColor3", "ContentInner")
    local b3 = new("Frame", {BackgroundColor3 = Library.Theme.ContentInner, BorderSizePixel = 0, Position = UDim2.fromOffset(0,1,1,-2), Size = UDim2.new(1,-2,0,1), ZIndex = 2}, panel)
    Library:RegisterTheme(b3, "BackgroundColor3", "ContentInner")
    local iT1 = new("Frame", {BackgroundColor3 = Library.Theme.ContentInner, BorderSizePixel = 0, Position = UDim2.fromOffset(1,1), Size = UDim2.new(1,-2,0,1), ZIndex = 2}, panel)
    Library:RegisterTheme(iT1, "BackgroundColor3", "ContentInner")
    local iT2 = new("Frame", {BackgroundColor3 = Library.Theme.ContentInner, BorderSizePixel = 0, Position = UDim2.fromOffset(1,1), Size = UDim2.fromOffset(0,1), ZIndex = 2}, panel)
    Library:RegisterTheme(iT2, "BackgroundColor3", "ContentInner")

    local TAB_W, TAB_H, TAB_SP = 81, 18, 2
    local tabsTotal = TAB_W * 4 + TAB_SP * 3
    local tabHost = new("Frame", {
        Name = "Tabs", BackgroundTransparency = 1,
        Position = UDim2.fromOffset(10 + math.floor(((canvas.Size.X.Offset - 20) - tabsTotal) / 2), 40 - TAB_H),
        Size = UDim2.fromOffset(tabsTotal, TAB_H), ZIndex = 4,
    }, canvas)

    local pageHost = new("Frame", {
        Name = "Pages", BackgroundTransparency = 1,
        Position = UDim2.fromOffset(18, 48), Size = UDim2.new(1,-36,1,-66),
        ZIndex = 3, ClipsDescendants = true,
    }, canvas)

    local dragZone = new("TextButton", {
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
        UIS.InputChanged:Connect(function(i)
            if dragging and isMoveInput(i) then
                local curPos = Vector2.new(i.Position.X, i.Position.Y)
                local d = curPos - startInput
                canvas.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if isTouchOrMouse(i) then dragging = false end
        end)
    end

    local window = setmetatable({
        Canvas = canvas, TabHost = tabHost, PageHost = pageHost,
        Tabs = {}, ActiveTab = nil, _tabW = TAB_W, _tabH = TAB_H, _tabSp = TAB_SP,
        _oT1 = oT1, _oT2 = oT2, _iT1 = iT1, _iT2 = iT2,
        _tabsTotal = tabsTotal,
    }, {__index = Library._WindowMethods})

    addResizeHandles(canvas, function()
        updateTabPositions(window)
    end)

    return window
end

-- ================= WINDOW METHODS =================
Library._WindowMethods = {}

function Library._WindowMethods:Tab(name)
    local win = self
    local idx = #win.Tabs + 1

    local btn = new("TextButton", {
        Name = name, Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(win._tabW, win._tabH),
        ZIndex = 4,
    }, win.TabHost)

    local tOuter = new("Frame", {BackgroundColor3 = Library.Theme.ContentOuter, BorderSizePixel = 0, Position = UDim2.fromOffset(0,0), Size = UDim2.new(1,0,0,win._tabH), ZIndex = 4}, btn)
    Library:RegisterTheme(tOuter, "BackgroundColor3", "ContentOuter")

    local tInner = new("Frame", {BackgroundColor3 = Library.Theme.ContentInner, BorderSizePixel = 0, Position = UDim2.fromOffset(1,1), Size = UDim2.new(1,-2,0,win._tabH-1), ZIndex = 4}, tOuter)
    Library:RegisterTheme(tInner, "BackgroundColor3", "ContentInner")

    local tFill  = new("Frame", {BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, Position = UDim2.fromOffset(2,2), Size = UDim2.new(1,-4,0,win._tabH-2), ZIndex = 4}, tOuter)

    local grad = new("UIGradient", {Rotation = 90}, tFill)
    Library:RegisterThemeCallback(function()
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Library.Theme.TabTop),
            ColorSequenceKeypoint.new(0.50, Library.Theme.TabMid),
            ColorSequenceKeypoint.new(1.00, Library.Theme.TabBottom),
        })
    end)

    local label = outlined(btn, name, "TabInactive", {
        Size = UDim2.new(1,0,0,win._tabH), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 8,
    })

    local page = new("Frame", {
        Name = name, BackgroundTransparency = 1, Visible = false, Size = UDim2.fromScale(1,1), ZIndex = 3, ClipsDescendants = false,
    }, win.PageHost)
    new("UIPadding", {PaddingLeft = UDim.new(0,2), PaddingTop = UDim.new(0,2), PaddingRight = UDim.new(0,2), PaddingBottom = UDim.new(0,2)}, page)
    new("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder}, page)

    local leftCol = new("ScrollingFrame", {
        Name = "LeftCol", BackgroundTransparency = 1, Size = UDim2.new(0.5, -3, 1, 0),
        CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4, ScrollBarImageColor3 = Library.Theme.Accent,
        LayoutOrder = 1, ZIndex = 3, BorderSizePixel = 0, ClipsDescendants = true,
    }, page)
    Library:RegisterTheme(leftCol, "ScrollBarImageColor3", "Accent")
    new("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder}, leftCol)

    local rightCol = new("ScrollingFrame", {
        Name = "RightCol", BackgroundTransparency = 1, Size = UDim2.new(0.5, -3, 1, 0),
        CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4, ScrollBarImageColor3 = Library.Theme.Accent,
        LayoutOrder = 2, ZIndex = 3, BorderSizePixel = 0, ClipsDescendants = true,
    }, page)
    Library:RegisterTheme(rightCol, "ScrollBarImageColor3", "Accent")
    new("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder}, rightCol)

    local tab = setmetatable({
        Window = win, Button = btn, Outer = tOuter, Inner = tInner, Fill = tFill,
        Grad = grad, Label = label, Page = page, LeftCol = leftCol, RightCol = rightCol, Index = idx, _groups = 0,
    }, {__index = Library._TabMethods})
    win.Tabs[#win.Tabs + 1] = tab

    local function select()
        for _, t in ipairs(win.Tabs) do
            local on = (t == tab)
            t.Page.Visible = on
            tween(t.Label, 0.12, {TextColor3 = on and Library.Theme.Accent or Library.Theme.TabInactive}):Play()

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

    Library:RegisterThemeCallback(function()
        local on = (win.ActiveTab == tab)
        label.TextColor3 = on and Library.Theme.Accent or Library.Theme.TabInactive
    end)

    btn.MouseButton1Click:Connect(function() closeAllPopups(); select() end)
    btn.MouseEnter:Connect(function()
        if win.ActiveTab ~= tab then tween(label, 0.12, {TextColor3 = Library.Theme.TabHover}):Play() end
    end)
    btn.MouseLeave:Connect(function()
        if win.ActiveTab ~= tab then tween(label, 0.12, {TextColor3 = Library.Theme.TabInactive}):Play() end
    end)

    updateTabPositions(win)
    if #win.Tabs == 1 then select() end
    return tab
end

-- ================= TAB METHODS =================
Library._TabMethods = {}

function Library._TabMethods:Group(title, side)
    local tab = self
    tab._groups += 1

    local HEADER_H = 19
    local parentCol
    if side == 1 or side == "left" then
        parentCol = tab.LeftCol
    elseif side == 2 or side == "right" then
        parentCol = tab.RightCol
    else
        parentCol = (tab._groups % 2 == 1) and tab.LeftCol or tab.RightCol
    end

    local col = new("Frame", {
        Name = title, BackgroundColor3 = Library.Theme.OuterBorder, BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, HEADER_H + 15), LayoutOrder = tab._groups, ZIndex = 3, Active = true,
    }, parentCol)
    Library:RegisterTheme(col, "BackgroundColor3", "OuterBorder")

    local colInner = new("Frame", {BackgroundColor3 = Library.Theme.InnerBorder, BorderSizePixel = 0, Position = UDim2.fromOffset(1,1), Size = UDim2.new(1,-2,1,-2), ZIndex = 3}, col)
    Library:RegisterTheme(colInner, "BackgroundColor3", "InnerBorder")

    local body = new("Frame", {
        Name = "Body", BackgroundColor3 = Library.Theme.ChildFill, BorderSizePixel = 0,
        Position = UDim2.fromOffset(2,2), Size = UDim2.new(1,-4,1,-4), ZIndex = 3, ClipsDescendants = false, Active = true,
    }, col)
    Library:RegisterTheme(body, "BackgroundColor3", "ChildFill")

    local header = new("Frame", {BackgroundColor3 = Library.Theme.HeaderTop, BorderSizePixel = 0, Size = UDim2.new(1,0,0,HEADER_H), ZIndex = 3}, body)
    vGradient(header, "HeaderTop", "HeaderBottom")
    outlined(header, title, "TextActive", {Position = UDim2.fromOffset(6,0), Size = UDim2.new(1,-6,1,0), ZIndex = 4})

    local divider = new("Frame", {BackgroundColor3 = Library.Theme.InnerBorder, BorderSizePixel = 0, Position = UDim2.fromOffset(0,HEADER_H), Size = UDim2.new(1,0,0,1), ZIndex = 4}, body)
    Library:RegisterTheme(divider, "BackgroundColor3", "InnerBorder")

    local content = new("Frame", {
        Name = "Content", BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, HEADER_H + 1), Size = UDim2.new(1,0,0,0), ZIndex = 3,
    }, body)

    local padding = new("UIPadding", {PaddingLeft = UDim.new(0,6), PaddingTop = UDim.new(0,5), PaddingRight = UDim.new(0,6), PaddingBottom = UDim.new(0,5)}, content)
    local contentList = new("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0,4), SortOrder = Enum.SortOrder.LayoutOrder}, content)

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

    local group = setmetatable({Tab = tab, Content = content, _order = 0, _updateGroupSize = updateGroupSize}, {__index = Library._GroupMethods})
    return group
end

-- ================= GROUP METHODS =================
Library._GroupMethods = {}

local function nextRow(group, height)
    group._order += 1
    local row = new("Frame", {
        BackgroundTransparency = 1, Size = UDim2.new(1,0,0,height),
        LayoutOrder = group._order, ZIndex = 3,
    }, group.Content)
    if group._updateGroupSize then
        task.defer(group._updateGroupSize)
    end
    return row
end

function Library._GroupMethods:Checkbox(text, default, callback, extra, flag)
    extra = extra or {}
    local state = default and true or false
    local row = nextRow(self, 14)

    local boxBtn = new("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.fromOffset(12,12), Position = UDim2.fromOffset(0,1), ZIndex = 3}, row)
    local _, fill = framedBox(boxBtn, "OuterBorder", "InnerBorder", "ChildFill", {ZIndex = 3})
    local accent = new("Frame", {BackgroundColor3 = Library.Theme.Accent, BorderSizePixel = 0, Size = UDim2.fromScale(1,1), BackgroundTransparency = state and 0 or 1, ZIndex = 3}, fill)
    vGradient(accent, "Accent", "AccentDark")

    local label = outlined(row, text, state and "TextActive" or "TextInactive", {Position = UDim2.fromOffset(19,0), Size = UDim2.new(1,-19,1,0), ZIndex = 3})

    Library:RegisterThemeCallback(function()
        label.TextColor3 = state and Library.Theme.TextActive or Library.Theme.TextInactive
    end)

    local function set(v, fireCb)
        state = v and true or false
        if flag then Library.Flags[flag] = state end
        tween(accent, 0.12, {BackgroundTransparency = state and 0 or 1}):Play()
        tween(label, 0.12, {TextColor3 = state and Library.Theme.TextActive or Library.Theme.TextInactive}):Play()
        if fireCb ~= false and callback then task.spawn(callback, state) end
    end

    boxBtn.MouseButton1Click:Connect(function() set(not state, true) end)
    boxBtn.MouseEnter:Connect(function() if not state then tween(fill,0.12,{BackgroundColor3 = Color3.fromRGB(39,40,57)}):Play() end end)
    boxBtn.MouseLeave:Connect(function() if not state then tween(fill,0.12,{BackgroundColor3 = Library.Theme.ChildFill}):Play() end end)

    if extra.colors then
        local sx = 0
        for _, c in ipairs(extra.colors) do
            sx += 14
            self:_swatch(row, c, UDim2.new(1, -sx, 0, 1), c.flag)
        end
    end

    local ctrl = {Set = function(_, v, f) set(v, f) end, Get = function() return state end}
    if flag then
        Library.Flags[flag] = state
        Library.Controls[flag] = ctrl
        Library.Defaults[flag] = state
    end
    if callback and default ~= nil then task.spawn(callback, state) end
    return ctrl
end

function Library._GroupMethods:_swatch(row, cfg, pos, flag)
    local color = cfg.default or Library.Theme.Accent
    local btn = new("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.fromOffset(12,12), Position = pos, ZIndex = 4}, row)
    local _, fill = framedBox(btn, "OuterBorder", "InnerBorder", color, {ZIndex = 4})

    local function set(c, fireCb)
        color = c
        fill.BackgroundColor3 = c
        if flag then Library.Flags[flag] = c end
        if fireCb ~= false and cfg.callback then task.spawn(cfg.callback, c) end
    end

    btn.MouseButton1Click:Connect(function()
        closeAllPopups()
        local abs = btn.AbsolutePosition
        Library._ColorPicker(popupLayer, abs + Vector2.new(0, 14), color, function(c)
            set(c, true)
        end)
    end)

    local ctrl = {Set = function(_, c, f) set(c, f) end, Get = function() return color end}
    if flag then
        Library.Flags[flag] = color
        Library.Controls[flag] = ctrl
        Library.Defaults[flag] = color
    end
    return btn
end

function Library._GroupMethods:ColorPicker(text, default, callback, flag)
    local color = default or Library.Theme.Accent
    local row = nextRow(self, 14)
    outlined(row, text, "TextInactive", {Position = UDim2.fromOffset(0,0), Size = UDim2.new(1,-20,1,0), ZIndex = 3})

    local btn = new("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.fromOffset(12,12), Position = UDim2.new(1,-12,0,1), ZIndex = 4}, row)
    local _, fill = framedBox(btn, "OuterBorder", "InnerBorder", color, {ZIndex = 4})

    local function set(c, fireCb)
        color = c
        fill.BackgroundColor3 = c
        if flag then Library.Flags[flag] = c end
        if fireCb ~= false and callback then task.spawn(callback, c) end
    end

    btn.MouseButton1Click:Connect(function()
        closeAllPopups()
        local abs = btn.AbsolutePosition
        Library._ColorPicker(popupLayer, abs + Vector2.new(0, 14), color, function(c)
            set(c, true)
        end)
    end)

    local ctrl = {Set = function(_, c, f) set(c, f) end, Get = function() return color end}
    if flag then
        Library.Flags[flag] = color
        Library.Controls[flag] = ctrl
        Library.Defaults[flag] = color
    end
    return ctrl
end

function Library._GroupMethods:Slider(text, o, callback, flag)
    o = o or {}
    local minv, maxv = o.min or 0, o.max or 1
    local decimals   = o.decimals ~= nil and o.decimals or 3
    local isInt      = o.int and true or false
    local suffix     = o.suffix or ""
    local value      = o.default or minv

    local row = nextRow(self, 28)
    local label = outlined(row, text, "TextInactive", {Position = UDim2.fromOffset(1,0), Size = UDim2.fromOffset(120,13), TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 3})
    local valLbl = outlined(row, "", "TextInactive", {Position = UDim2.new(1,-120,0,0), Size = UDim2.fromOffset(120,13), TextXAlignment = Enum.TextXAlignment.Right, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 3})

    local track = new("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Position = UDim2.fromOffset(0,16), Size = UDim2.new(1,0,0,12), ZIndex = 3}, row)
    local _, tFill = framedBox(track, "OuterBorder", "InnerBorder", "ChildFill", {ZIndex = 3})
    local prog = new("Frame", {BackgroundColor3 = Library.Theme.Accent, BorderSizePixel = 0, Size = UDim2.fromScale(0,1), ZIndex = 3}, tFill)
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
        if flag then Library.Flags[flag] = value end
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
    UIS.InputChanged:Connect(function(i)
        if dragging and isMoveInput(i) then fromInput(i) end
    end)
    UIS.InputEnded:Connect(function(i)
        if isTouchOrMouse(i) then dragging = false end
    end)
    track.MouseEnter:Connect(function() tween(label,0.12,{TextColor3=Library.Theme.TextActive}):Play(); tween(valLbl,0.12,{TextColor3=Library.Theme.TextActive}):Play() end)
    track.MouseLeave:Connect(function() if not dragging then tween(label,0.12,{TextColor3=Library.Theme.TextInactive}):Play(); tween(valLbl,0.12,{TextColor3=Library.Theme.TextInactive}):Play() end end)

    render()
    local ctrl = {Set = function(_, v, f) set(v, f) end, Get = function() return value end}
    if flag then
        Library.Flags[flag] = value
        Library.Controls[flag] = ctrl
        Library.Defaults[flag] = value
    end
    if callback and o.default ~= nil then task.spawn(callback, value) end
    return ctrl
end

-- ================= COMBO HELPERS =================
local function plusIcon(parent, colorKey)
    local host = new("Frame", {
        Name = "Icon", BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -5, 0.5, 0),
        Size = UDim2.fromOffset(7, 7), ZIndex = 4,
    }, parent)
    local color = type(colorKey) == "string" and Library.Theme[colorKey] or colorKey
    local hbar = new("Frame", {BackgroundColor3 = color, BorderSizePixel = 0, Position = UDim2.fromOffset(0,3), Size = UDim2.fromOffset(7,1), ZIndex = 4}, host)
    local vbar = new("Frame", {BackgroundColor3 = color, BorderSizePixel = 0, Position = UDim2.fromOffset(3,0), Size = UDim2.fromOffset(1,7), ZIndex = 4}, host)
    if type(colorKey) == "string" then
        Library:RegisterTheme(hbar, "BackgroundColor3", colorKey)
        Library:RegisterTheme(vbar, "BackgroundColor3", colorKey)
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

    local blocker = new("TextButton", {
        Name = "Blocker", BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
        Size = UDim2.fromScale(1, 1), ZIndex = 501,
    }, screenGui)
    blocker.MouseButton1Click:Connect(closeAllPopups)

    local pop = new("Frame", {
        Name = "DropdownPopup",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(boxAbs.X, boxAbs.Y + sz.Y + 4),
        Size = UDim2.fromOffset(sz.X, targetH),
        ClipsDescendants = true,
        ZIndex = 502,
    }, screenGui)

    local _, pfill = framedBox(pop, "OuterBorder", "ComboInner", "ComboFill", {ZIndex = 502})
    pfill.Size = UDim2.new(1, -2, 1, -2)

    local mask = new("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ClipsDescendants = true,
        ZIndex = 503,
    }, pfill)

    local itemsContainer = new("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, -targetH),
        Size = UDim2.new(1, 0, 0, targetH),
        ZIndex = 503,
    }, mask)

    for i, it in ipairs(items) do
        local ib = new("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Position = UDim2.fromOffset(0, (i-1)*ITEM_H), Size = UDim2.new(1,0,0,ITEM_H), ClipsDescendants = true, ZIndex = 504}, itemsContainer)
        local sel = getState(i)
        local il = outlined(ib, (sel and "> " or "") .. it, sel and "ComboSelected" or "TextInactive", {Position = UDim2.fromOffset(5,0), Size = UDim2.new(1,-7,1,0), ZIndex = 505})
        ib.MouseEnter:Connect(function() if not getState(i) then tween(il,0.1,{TextColor3=Library.Theme.TextActive}):Play() end end)
        ib.MouseLeave:Connect(function() if not getState(i) then tween(il,0.1,{TextColor3=Library.Theme.TextInactive}):Play() end end)
        ib.MouseButton1Click:Connect(function()
            onPick(i)
            if isMulti then
                local s = getState(i)
                il.Text = (s and "> " or "") .. it
                il.TextColor3 = s and Library.Theme.ComboSelected or Library.Theme.TextInactive
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

-- ================= COMBO METHODS =================
function Library._GroupMethods:Combo(text, items, default, callback, flag)
    local index = default or 1
    local row = nextRow(self, 34)
    outlined(row, text, "TextInactive", {Position = UDim2.fromOffset(1,0), Size = UDim2.fromOffset(120,13), TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 3})

    local box = new("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Position = UDim2.fromOffset(0,16), Size = UDim2.new(1,0,0,18), ClipsDescendants = true, ZIndex = 3}, row)
    local _, bFill = framedBox(box, "OuterBorder", "ComboInner", "ComboFill", {ZIndex = 3})
    local preview = outlined(box, items[index] or "", "TextInactive", {Position = UDim2.fromOffset(5,1), Size = UDim2.new(1,-20,1,-2), TextSize = 12, ZIndex = 4})
    local icon = plusIcon(box, "Accent")

    local function set(i, fireCb)
        index = i
        preview.Text = items[index] or ""
        if flag then Library.Flags[flag] = index end
        if fireCb ~= false and callback then task.spawn(callback, index, items[index]) end
    end

    box.MouseEnter:Connect(function() tween(preview,0.12,{TextColor3=Library.Theme.TextActive}):Play() end)
    box.MouseLeave:Connect(function() tween(preview,0.12,{TextColor3=Library.Theme.TextInactive}):Play() end)
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
            if flag then Library.Flags[flag] = index end
        end
    }
    if flag then
        Library.Flags[flag] = index
        Library.Controls[flag] = ctrl
        Library.Defaults[flag] = index
    end
    if callback and default then task.spawn(callback, index, items[index]) end
    return ctrl
end

function Library._GroupMethods:MultiCombo(text, items, defaults, callback, flag)
    local state = {}
    for i = 1, #items do state[i] = defaults and defaults[i] or false end
    local row = nextRow(self, 34)
    outlined(row, text, "TextInactive", {Position = UDim2.fromOffset(1,0), Size = UDim2.fromOffset(120,13), TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 3})

    local box = new("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Position = UDim2.fromOffset(0,16), Size = UDim2.new(1,0,0,18), ClipsDescendants = true, ZIndex = 3}, row)
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
        if flag then Library.Flags[flag] = cloneTable(state) end
        if fireCb ~= false and callback then task.spawn(callback, cloneTable(state)) end
    end

    box.MouseEnter:Connect(function() tween(preview,0.12,{TextColor3=Library.Theme.TextActive}):Play() end)
    box.MouseLeave:Connect(function() tween(preview,0.12,{TextColor3=Library.Theme.TextInactive}):Play() end)
    box.MouseButton1Click:Connect(function()
        if icon.IsOpen() then closeAllPopups(); icon.SetOpen(false); return end
        icon.SetOpen(true)
        buildComboPopup(box, items, true, function(i) return state[i] end, function(i)
            state[i] = not state[i]
            refresh()
            if flag then Library.Flags[flag] = cloneTable(state) end
            if callback then task.spawn(callback, cloneTable(state)) end
        end)
        openPopups[#openPopups + 1] = function() icon.SetOpen(false) end
    end)

    local ctrl = {Set = function(_, st, f) set(st, f) end, Get = function() return cloneTable(state) end}
    if flag then
        Library.Flags[flag] = cloneTable(state)
        Library.Controls[flag] = ctrl
        Library.Defaults[flag] = cloneTable(state)
    end
    return ctrl
end

-- ================= TEXTBOX =================
function Library._GroupMethods:TextBox(text, default, callback, flag)
    local row = nextRow(self, 34)
    outlined(row, text, "TextInactive", {Position = UDim2.fromOffset(1,0), Size = UDim2.fromOffset(120,13), TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 3})
    local boxFrame = new("Frame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(0,16), Size = UDim2.new(1,0,0,18), ZIndex = 3}, row)
    local _, bFill = framedBox(boxFrame, "OuterBorder", "ComboInner", "ComboFill", {ZIndex = 3})
    local tb = new("TextBox", { BackgroundTransparency = 1, Text = default or "", TextColor3 = Library.Theme.TextActive, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.fromOffset(5, 0), Size = UDim2.new(1, -10, 1, 0), ClearTextOnFocus = false, ZIndex = 4 }, bFill)
    applyFont(tb, false)
    Library:RegisterTheme(tb, "TextColor3", "TextActive")
    local function set(str, fireCb)
        tb.Text = str or ""
        if flag then Library.Flags[flag] = str end
        if fireCb ~= false and callback then task.spawn(callback, str) end
    end
    tb.FocusLost:Connect(function() set(tb.Text, true) end)
    local ctrl = {Set = function(_, str, f) set(str, f) end, Get = function() return tb.Text end}
    if flag then Library.Flags[flag] = default or ""; Library.Controls[flag] = ctrl; Library.Defaults[flag] = default or "" end
    return ctrl
end

-- ================= BUTTON =================
function Library._GroupMethods:Button(text, callback)
    local row = nextRow(self, 20)
    local btn = new("TextButton", { Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), ZIndex = 3 }, row)
    local _, fill = framedBox(btn, "OuterBorder", "InnerBorder", "ComboFill", {ZIndex = 3})
    outlined(btn, text, "TextActive", { Size = UDim2.fromScale(1,1), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 4 })
    btn.MouseButton1Click:Connect(function() if callback then task.spawn(callback) end end)
    btn.MouseEnter:Connect(function() tween(fill, 0.12, {BackgroundColor3 = Color3.fromRGB(35, 36, 45)}):Play() end)
    btn.MouseLeave:Connect(function() tween(fill, 0.12, {BackgroundColor3 = Library.Theme.ComboFill}):Play() end)
end

-- ================= KEYBIND HELPERS =================
local function buildKeyModePopup(parentBox, currentMode, onMode)
    closeAllPopups()
    local boxAbs = parentBox.AbsolutePosition
    local sz = parentBox.AbsoluteSize
    local modes = {"toggle", "hold", "always"}
    local targetH = #modes * 16
    local blocker = new("TextButton", { Name = "Blocker", BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Size = UDim2.fromScale(1, 1), ZIndex = 501 }, screenGui)
    blocker.MouseButton1Click:Connect(closeAllPopups)
    local pop = new("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(boxAbs.X - 20, boxAbs.Y + sz.Y + 2), Size = UDim2.fromOffset(60, targetH), ClipsDescendants = true, ZIndex = 502 }, screenGui)
    local _, pf = framedBox(pop, "OuterBorder", "ComboInner", "ComboFill", {ZIndex = 502})
    pf.Size = UDim2.new(1, -2, 1, -2)
    for i, m in ipairs(modes) do
        local mb = new("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Position = UDim2.fromOffset(0,(i-1)*16), Size = UDim2.fromOffset(60,16), ZIndex = 503}, pf)
        local ml = outlined(mb, m, (currentMode == i) and "Accent" or "TextInactive", {Size = UDim2.fromScale(1,1), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 504})
        mb.MouseButton1Click:Connect(function() onMode(i, m); closeAllPopups() end)
    end
    openPopups[#openPopups+1] = function() blocker:Destroy(); pop:Destroy() end
    return pop
end

local function makeKeybindBox(parent, key, mode, onKey, onMode, flag)
    local BOX_W, BOX_H = 32, 12
    local box = new("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,0,0,1), Size = UDim2.fromOffset(BOX_W, BOX_H), ZIndex = 4}, parent)
    local _, bFill = framedBox(box, "OuterBorder", "InnerBorder", "ChildFill", {ZIndex = 4})
    local lbl = outlined(bFill, keyName(key), "TextInactive", {Size = UDim2.fromScale(1,1), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 5, TextSize = 11})
    local listening = false
    local function set(k, fireCb)
        key = k
        lbl.Text = keyName(k)
        if flag then Library.Flags[flag] = key end
        if fireCb ~= false and onKey then onKey(k) end
    end
    box.MouseButton1Click:Connect(function()
        listening = true; lbl.Text = "..."; lbl.TextColor3 = Library.Theme.Accent
        local conn
        conn = UIS.InputBegan:Connect(function(inp, gp)
            if not listening then return end
            local k
            if inp.UserInputType == Enum.UserInputType.Keyboard then
                if inp.KeyCode == Enum.KeyCode.Escape then k = nil else k = inp.KeyCode end
            elseif inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.MouseButton2 or inp.UserInputType == Enum.UserInputType.MouseButton3 or inp.UserInputType == Enum.UserInputType.Touch then
                k = inp.UserInputType
            else return end
            listening = false; conn:Disconnect()
            set(k, true)
            lbl.TextColor3 = Library.Theme.TextInactive
        end)
    end)
    box.MouseButton2Click:Connect(function()
        buildKeyModePopup(bFill, mode, function(i, m)
            mode = i
            if onMode then onMode(i, m) end
        end)
    end)
    local ctrl = {Set = function(_, k, f) set(k, f) end, Get = function() return key, mode end}
    if flag then Library.Flags[flag] = key; Library.Controls[flag] = ctrl; Library.Defaults[flag] = key end
    return box, ctrl
end

-- ================= KEYBIND METHODS =================
function Library._GroupMethods:Keybind(text, default, callback, flag)
    local row = nextRow(self, 14)
    outlined(row, text, "TextInactive", {Position = UDim2.fromOffset(0,0), Size = UDim2.new(1,-38,1,0), ZIndex = 3})
    local _, ctrl = makeKeybindBox(row, default, 1, function(k) if callback then task.spawn(callback, k) end end, nil, flag)
    return ctrl
end

function Library._GroupMethods:CheckboxKeybind(text, default, key, callback, flag)
    local state = default and true or false
    local row = nextRow(self, 14)
    local boxBtn = new("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.fromOffset(12,12), Position = UDim2.fromOffset(0,1), ZIndex = 3}, row)
    local _, fill = framedBox(boxBtn, "OuterBorder", "InnerBorder", "ChildFill", {ZIndex = 3})
    local accent = new("Frame", {BackgroundColor3 = Library.Theme.Accent, BorderSizePixel = 0, Size = UDim2.fromScale(1,1), BackgroundTransparency = state and 0 or 1, ZIndex = 3}, fill)
    vGradient(accent, "Accent", "AccentDark")
    local label = outlined(row, text, state and "TextActive" or "TextInactive", {Position = UDim2.fromOffset(19,0), Size = UDim2.new(1,-60,1,0), ZIndex = 3})
    Library:RegisterThemeCallback(function()
        label.TextColor3 = state and Library.Theme.TextActive or Library.Theme.TextInactive
    end)
    local function set(v, fireCb)
        state = v and true or false
        if flag then Library.Flags[flag] = state end
        tween(accent,0.12,{BackgroundTransparency = state and 0 or 1}):Play()
        tween(label,0.12,{TextColor3 = state and Library.Theme.TextActive or Library.Theme.TextInactive}):Play()
        if fireCb ~= false and callback then task.spawn(callback, state) end
    end
    boxBtn.MouseButton1Click:Connect(function() set(not state, true) end)
    makeKeybindBox(row, key, 1, nil, nil, flag and (flag .. "_key"))
    local ctrl = {Set = function(_, v, f) set(v, f) end, Get = function() return state end}
    if flag then Library.Flags[flag] = state; Library.Controls[flag] = ctrl; Library.Defaults[flag] = state end
    return ctrl
end

-- ================= LABEL =================
function Library._GroupMethods:Label(text)
    local row = nextRow(self, 14)
    outlined(row, text, "TextInactive", {Size = UDim2.fromScale(1,1), ZIndex = 3})
end

-- ================= COLOR PICKER =================
function Library._ColorPicker(parent, pos, startColor, onChange)
    local h, s, v = Color3.toHSV(startColor)
    local W = 150
    local pop = new("Frame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(pos.X - W + 12, pos.Y), Size = UDim2.fromOffset(W, 120), ZIndex = 510}, parent)
    local _, pf = framedBox(pop, "OuterBorder", "InnerBorder", "PanelFill", {ZIndex = 510})

    local sv = new("ImageButton", {BackgroundColor3 = Color3.fromHSV(h,1,1), BorderSizePixel = 0, Position = UDim2.fromOffset(6,6), Size = UDim2.fromOffset(W-30, 100), ZIndex = 511, AutoButtonColor = false}, pf)
    local white = new("Frame", {BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, Size = UDim2.fromScale(1,1), ZIndex = 511}, sv)
    new("UIGradient", {Rotation = 0, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)})}, white)
    local blk = new("Frame", {BackgroundColor3 = Color3.new(0,0,0), BorderSizePixel = 0, Size = UDim2.fromScale(1,1), ZIndex = 511}, sv)
    new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)})}, blk)

    local circle = new("Frame", { Name = "Indicator", Size = UDim2.fromOffset(7, 7), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), Position = UDim2.fromScale(s, 1 - v), ZIndex = 514 }, sv)
    new("UICorner", {CornerRadius = UDim.new(1, 0)}, circle)
    new("UIStroke", {Color = Color3.new(0, 0, 0), Thickness = 1}, circle)

    local hue = new("ImageButton", {BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, Position = UDim2.new(1,-16,0,6), Size = UDim2.fromOffset(12,100), ZIndex = 511, AutoButtonColor = false}, pf)
    local hg = new("UIGradient", {Rotation = 90}, hue)
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
    UIS.InputEnded:Connect(function(i) if isTouchOrMouse(i) then dragSV, dragHue = false, false end end)
    UIS.InputChanged:Connect(function(i) if isMoveInput(i) and (dragSV or dragHue) then handlePickerInput(i) end end)

    local blocker = new("TextButton", { Name = "Blocker", BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Size = UDim2.fromScale(1, 1), ZIndex = 509 }, parent)
    blocker.MouseButton1Click:Connect(function() if not dragSV and not dragHue then closeAllPopups() end end)

    updateIndicator()
    openPopups[#openPopups+1] = function() blocker:Destroy(); pop:Destroy() end
end

-- ================= CURSOR =================
local function makeCursor()
    local S = 11; local C = math.floor(S/2)
    local gui = new("ScreenGui", {
        Name = "cursor",
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 2147483647
    }, guiParent())
    local host = new("Frame", {
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
        local color = type(colorC) == "string" and Library.Theme[colorC] or colorC
        local f = new("Frame", {
            BackgroundColor3 = color,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(x,y),
            Size = UDim2.fromOffset(w,h),
            ZIndex = z
        }, host)
        noInput(f)
        if type(colorC) == "string" then
            Library:RegisterTheme(f, "BackgroundColor3", colorC)
        end
    end
    bar("OuterBorder",0,C-1,S,3,1)
    bar("OuterBorder",C-1,0,3,S,1)
    bar("TextActive",1,C,S-2,1,2)
    bar("TextActive",C,1,1,S-2,2)
    return host
end

Library.CursorEnabled = not UIS.TouchEnabled
local cursor = makeCursor()
local cursorConns = {}

local function moveCursor()
    local m = UIS:GetMouseLocation()
    cursor.Position = UDim2.fromOffset(m.X, m.Y)
end

local function setCursorEnabled(on)
    on = on and Library.CursorEnabled
    cursor.Visible = on
    if not UIS.TouchEnabled then
        UIS.MouseIconEnabled = not on
    end
    if on and #cursorConns == 0 then
        moveCursor()
        cursorConns[1] = RunService.RenderStepped:Connect(moveCursor)
        cursorConns[2] = UIS.InputChanged:Connect(function(i)
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

-- ================= BIND TOGGLE =================
function Library:BindToggle(window)
    local visible = true
    setCursorEnabled(true)
    local function toggleUI()
        visible = not visible
        closeAllPopups()
        setCursorEnabled(visible)
        if visible then
            window.Canvas.Visible = true
        end
        local tw = TweenService:Create(window.Canvas, TweenInfo.new(0.30, Enum.EasingStyle.Cubic, visible and Enum.EasingDirection.Out or Enum.EasingDirection.In), {
            GroupTransparency = visible and 0 or 1
        })
        tw:Play()
        if not visible then
            tw.Completed:Connect(function()
                window.Canvas.Visible = false
            end)
        end
    end
    UIS.InputBegan:Connect(function(i, gp)
        if not gp and i.KeyCode == Library.ToggleKey then
            toggleUI()
        end
    end)
    Library:CreateMobileToggle(toggleUI)
end

-- ================= BUILT-IN CONFIG MANAGER =================
function Library:CreateConfigManager(tab, side)
    local group = tab:Group("Config Manager", side or "left")

    local cfgNameBox = group:TextBox("Config Name", "my_config", nil, "_cfg_name")

    local function refreshConfigs()
        local list = Library:GetSavedConfigs() or {"none"}
        if cfgCombo and cfgCombo.Refresh then
            cfgCombo:Refresh(list)
            cfgCombo:Set(1, false)
        end
    end

    local cfgCombo = group:Combo("Saved Configs", Library:GetSavedConfigs() or {"none"}, 1, function(idx, name)
        if name and name ~= "none" then cfgNameBox:Set(name) end
    end, "_cfg_selected")

    group:Button("Save Config", function()
        local name = cfgNameBox:Get()
        if name and name ~= "" then
            Library:SaveConfig(name)
            print("Saved config:", name)
            refreshConfigs()
        end
    end)

    group:Button("Load Config", function()
        local _, name = cfgCombo:Get()
        if name and name ~= "none" then
            Library:LoadConfig(name)
            print("Loaded config:", name)
        end
    end)

    group:Button("Delete Config", function()
        local _, name = cfgCombo:Get()
        if name and name ~= "none" then
            Library:DeleteConfig(name)
            print("Deleted config:", name)
            refreshConfigs()
        end
    end)

    group:Button("Set Auto Load", function()
        local name = cfgNameBox:Get()
        if name and name ~= "" and name ~= "none" then
            Library:SetAutoLoad(name)
            print("Auto-load set to:", name)
        end
    end)

    group:Button("Reset to Defaults", function()
        Library:ResetToDefaults()
        print("↻ Reset to defaults")
    end)

    return group
end

-- ================= BUILT-IN THEME MANAGER =================
function Library:CreateThemeManager(tab, side)
    local group = tab:Group("Theme Manager", side or "right")

    local themeNameBox = group:TextBox("Theme Name", "my_theme", nil, "_theme_name")

    group:Combo("Preset Theme", {"Default", "Tokyo Night", "Crimson", "Emerald"}, 1, function(idx, name)
        Library:SetPresetTheme(name)
        print("Theme:", name)
    end, "_theme_preset")

    local function refreshThemes()
        local list = Library:GetSavedThemes() or {"none"}
        if themeCombo and themeCombo.Refresh then
            themeCombo:Refresh(list)
            themeCombo:Set(1, false)
        end
    end

    local themeCombo = group:Combo("Saved Themes", Library:GetSavedThemes() or {"none"}, 1, function(idx, name)
        if name and name ~= "none" then themeNameBox:Set(name) end
    end, "_theme_saved")

    group:Button("Save Custom Theme", function()
        local name = themeNameBox:Get()
        if name and name ~= "" then
            Library:SaveTheme(name)
            print("Saved theme:", name)
            refreshThemes()
        end
    end)

    group:Button("Load Custom Theme", function()
        local _, name = themeCombo:Get()
        if name and name ~= "none" then
            Library:LoadTheme(name)
            print("Loaded theme:", name)
        end
    end)

    group:Button("Delete Custom Theme", function()
        local _, name = themeCombo:Get()
        if name and name ~= "none" then
            Library:DeleteTheme(name)
            print("Deleted theme:", name)
            refreshThemes()
        end
    end)

    group:Button("Reset Theme to Default", function()
        Library:ResetThemeToDefault()
        print("↻ Reset theme")
    end)

    return group
end

-- ================= BUILT-IN UI CUSTOMIZATION =================
function Library:CreateUICustomization(tab, side)
    local group = tab:Group("UI Customization", side or "left")

    -- UI Expansion
    group:Checkbox("UI Expansion (Resize)", Library.UIExpansion, function(val)
        Library.UIExpansion = val
        if Library._UpdateResizeVisibility then
            Library._UpdateResizeVisibility()
        end
    end, nil, "_ui_expansion")

    -- Watermark controls
    local leftText = Library.WatermarkOptions.leftText or "Lunex UI"
    local rightText = Library.WatermarkOptions.rightText or "v1.0"
    local leftColor = Library.WatermarkOptions.leftColor or Library.Theme.TextActive
    local rightColor = Library.WatermarkOptions.rightColor or Library.Theme.Accent

    group:Checkbox("Show Watermark", Library.WatermarkVisible, function(val)
        Library.WatermarkVisible = val
        Library:_UpdateWatermark()
    end, nil, "_watermark_visible")

    group:TextBox("Left Text", leftText, function(str)
        Library.WatermarkOptions.leftText = str
        Library:_UpdateWatermark()
    end, "_watermark_left_text")

    group:ColorPicker("Left Color", leftColor, function(col)
        Library.WatermarkOptions.leftColor = col
        Library:_UpdateWatermark()
    end, "_watermark_left_color")

    group:TextBox("Right Text", rightText, function(str)
        Library.WatermarkOptions.rightText = str
        Library:_UpdateWatermark()
    end, "_watermark_right_text")

    group:ColorPicker("Right Color", rightColor, function(col)
        Library.WatermarkOptions.rightColor = col
        Library:_UpdateWatermark()
    end, "_watermark_right_color")

    -- Separator
    group:Label("────────── Theme Colors ──────────")

    -- All theme color pickers
    group:ColorPicker("Accent", Library.Theme.Accent, function(col)
        Library.Theme.Accent = col
        Library.Theme.AccentDark = Color3.new(col.R*0.7, col.G*0.7, col.B*0.7)
        Library:RefreshTheme()
    end, "_ui_accent")

    group:ColorPicker("Text Active", Library.Theme.TextActive, function(col)
        Library.Theme.TextActive = col
        Library:RefreshTheme()
    end, "_ui_text_active")

    group:ColorPicker("Text Inactive", Library.Theme.TextInactive, function(col)
        Library.Theme.TextInactive = col
        Library:RefreshTheme()
    end, "_ui_text_inactive")

    group:ColorPicker("Panel Background", Library.Theme.PanelFill, function(col)
        Library.Theme.PanelFill = col
        Library:RefreshTheme()
    end, "_ui_panel_fill")

    group:ColorPicker("Content Background", Library.Theme.ContentFill, function(col)
        Library.Theme.ContentFill = col
        Library:RefreshTheme()
    end, "_ui_content_fill")

    group:ColorPicker("Group Background", Library.Theme.ChildFill, function(col)
        Library.Theme.ChildFill = col
        Library:RefreshTheme()
    end, "_ui_child_fill")

    group:ColorPicker("Header Top", Library.Theme.HeaderTop, function(col)
        Library.Theme.HeaderTop = col
        Library:RefreshTheme()
    end, "_ui_header_top")

    group:ColorPicker("Header Bottom", Library.Theme.HeaderBottom, function(col)
        Library.Theme.HeaderBottom = col
        Library:RefreshTheme()
    end, "_ui_header_bottom")

    group:ColorPicker("Outer Border", Library.Theme.OuterBorder, function(col)
        Library.Theme.OuterBorder = col
        Library:RefreshTheme()
    end, "_ui_outer_border")

    group:ColorPicker("Inner Border", Library.Theme.InnerBorder, function(col)
        Library.Theme.InnerBorder = col
        Library:RefreshTheme()
    end, "_ui_inner_border")

    group:ColorPicker("Tab Inactive", Library.Theme.TabInactive, function(col)
        Library.Theme.TabInactive = col
        Library:RefreshTheme()
    end, "_ui_tab_inactive")

    group:ColorPicker("Tab Hover", Library.Theme.TabHover, function(col)
        Library.Theme.TabHover = col
        Library:RefreshTheme()
    end, "_ui_tab_hover")

    return group
end

-- ================= RETURN =================
return Library
