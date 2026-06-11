-- ============================================================
--   MAP ESP SCRIPT - by tele apiszx
--   Fitur: Color ESP, Tree ESP, Lever ESP, Teleport
--   Bahasa: Indonesia / English (Bilingual)
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============================================================
-- KONFIGURASI WARNA / COLOR CONFIG
-- ============================================================
local COLOR_LIST = {
    { nameID = "Merah",    nameEN = "Red",    color = Color3.fromRGB(255, 0, 0),      hex = BrickColor.new("Bright red")        },
    { nameID = "Hijau",    nameEN = "Green",  color = Color3.fromRGB(0, 255, 0),      hex = BrickColor.new("Bright green")      },
    { nameID = "Biru",     nameEN = "Blue",   color = Color3.fromRGB(0, 0, 255),      hex = BrickColor.new("Bright blue")       },
    { nameID = "Kuning",   nameEN = "Yellow", color = Color3.fromRGB(255, 255, 0),    hex = BrickColor.new("Bright yellow")     },
    { nameID = "Ungu",     nameEN = "Purple", color = Color3.fromRGB(128, 0, 128),    hex = BrickColor.new("Bright violet")     },
    { nameID = "Oranye",   nameEN = "Orange", color = Color3.fromRGB(255, 165, 0),    hex = BrickColor.new("Bright orange")     },
    { nameID = "Pink",     nameEN = "Pink",   color = Color3.fromRGB(255, 105, 180),  hex = BrickColor.new("Hot pink")          },
    { nameID = "Cyan",     nameEN = "Cyan",   color = Color3.fromRGB(0, 255, 255),    hex = BrickColor.new("Cyan")              },
    { nameID = "Putih",    nameEN = "White",  color = Color3.fromRGB(255, 255, 255),  hex = BrickColor.new("White")             },
    { nameID = "Hitam",    nameEN = "Black",  color = Color3.fromRGB(0, 0, 0),        hex = BrickColor.new("Black")             },
}

local TREE_NAMES  = {"Tree", "Pohon", "Oak", "Spruce", "Birch", "Bush", "Plant", "Leaf"}
local LEVER_NAMES = {"Lever", "Tuas", "Switch", "Button", "Handle", "Valve", "Knob", "Trigger"}

-- ============================================================
-- STATE
-- ============================================================
local espState = {
    colorESP   = true,
    treeESP    = true,
    leverESP   = true,
}
local highlightObjects = {}
local espConnections   = {}

-- ============================================================
-- UI SETUP
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name          = "MapESP_GUI"
screenGui.ResetOnSpawn  = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent        = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name            = "MainFrame"
mainFrame.Size            = UDim2.new(0, 320, 0, 500)
mainFrame.Position        = UDim2.new(0, 10, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent          = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color     = Color3.fromRGB(80, 80, 200)
stroke.Thickness = 1.5
stroke.Parent    = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size            = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 60)
titleBar.BorderSizePixel = 0
titleBar.Parent          = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

-- Title text
local titleLabel = Instance.new("TextLabel")
titleLabel.Size            = UDim2.new(1, -60, 1, 0)
titleLabel.Position        = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text            = "🗺️ MAP ESP — tele apiszx"
titleLabel.TextColor3      = Color3.fromRGB(180, 180, 255)
titleLabel.TextSize        = 13
titleLabel.Font            = Enum.Font.GothamBold
titleLabel.TextXAlignment  = Enum.TextXAlignment.Left
titleLabel.Parent          = titleBar

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Size            = UDim2.new(0, 26, 0, 22)
minBtn.Position        = UDim2.new(1, -32, 0, 7)
minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
minBtn.Text            = "–"
minBtn.TextColor3      = Color3.fromRGB(200, 200, 255)
minBtn.TextSize        = 14
minBtn.Font            = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
minBtn.Parent          = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 5)
minCorner.Parent = minBtn

-- Scroll Frame (content)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name            = "Content"
scrollFrame.Size            = UDim2.new(1, 0, 1, -38)
scrollFrame.Position        = UDim2.new(0, 0, 0, 38)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 200)
scrollFrame.CanvasSize      = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent          = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder   = Enum.SortOrder.LayoutOrder
listLayout.Padding     = UDim.new(0, 4)
listLayout.Parent      = scrollFrame

local padding = Instance.new("UIPadding")
padding.PaddingLeft  = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)
padding.PaddingTop   = UDim.new(0, 6)
padding.Parent       = scrollFrame

-- ============================================================
-- HELPER FUNCTIONS
-- ============================================================
local function makeSection(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size            = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundColor3 = Color3.fromRGB(30, 30, 70)
    lbl.Text            = text
    lbl.TextColor3      = Color3.fromRGB(140, 140, 255)
    lbl.TextSize        = 11
    lbl.Font            = Enum.Font.GothamBold
    lbl.TextXAlignment  = Enum.TextXAlignment.Left
    lbl.BorderSizePixel = 0
    lbl.Parent          = scrollFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = lbl

    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, 8)
    p.Parent = lbl

    return lbl
end

local function makeToggleRow(labelText, defaultOn, onToggle)
    local row = Instance.new("Frame")
    row.Size            = UDim2.new(1, 0, 0, 30)
    row.BackgroundTransparency = 1
    row.Parent          = scrollFrame

    local lbl = Instance.new("TextLabel")
    lbl.Size            = UDim2.new(1, -60, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text            = labelText
    lbl.TextColor3      = Color3.fromRGB(220, 220, 255)
    lbl.TextSize        = 12
    lbl.Font            = Enum.Font.Gotham
    lbl.TextXAlignment  = Enum.TextXAlignment.Left
    lbl.Parent          = row

    local toggle = Instance.new("TextButton")
    toggle.Size            = UDim2.new(0, 52, 0, 22)
    toggle.Position        = UDim2.new(1, -54, 0.5, -11)
    toggle.BackgroundColor3 = defaultOn and Color3.fromRGB(40, 180, 80) or Color3.fromRGB(150, 40, 40)
    toggle.Text            = defaultOn and "ON" or "OFF"
    toggle.TextColor3      = Color3.fromRGB(255, 255, 255)
    toggle.TextSize        = 11
    toggle.Font            = Enum.Font.GothamBold
    toggle.BorderSizePixel = 0
    toggle.Parent          = row

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 5)
    tc.Parent = toggle

    local state = defaultOn
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = state and "ON" or "OFF"
        toggle.BackgroundColor3 = state and Color3.fromRGB(40, 180, 80) or Color3.fromRGB(150, 40, 40)
        onToggle(state)
    end)

    return row
end

local function makeTeleportBtn(nameID, nameEN, targetColor, espColor)
    local btn = Instance.new("TextButton")
    btn.Size            = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
    btn.Text            = string.format("⟶  %s / %s", nameID, nameEN)
    btn.TextColor3      = espColor or Color3.fromRGB(220, 220, 255)
    btn.TextSize        = 12
    btn.Font            = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.Parent          = scrollFrame

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 5)
    bc.Parent = btn

    local bs = Instance.new("UIStroke")
    bs.Color     = espColor or Color3.fromRGB(60, 60, 120)
    bs.Thickness = 1
    bs.Parent    = btn

    btn.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- Find nearest part with matching color
        local best, bestDist = nil, math.huge
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(char) then
                local r1 = math.abs(obj.Color.R - targetColor.R)
                local g1 = math.abs(obj.Color.G - targetColor.G)
                local b1 = math.abs(obj.Color.B - targetColor.B)
                if (r1 + g1 + b1) < 0.3 then
                    local dist = (obj.Position - hrp.Position).Magnitude
                    if dist < bestDist then
                        best, bestDist = obj, dist
                    end
                end
            end
        end

        if best then
            hrp.CFrame = CFrame.new(best.Position + Vector3.new(0, 5, 0))
            -- Notif
            local notif = Instance.new("TextLabel")
            notif.Size            = UDim2.new(0, 260, 0, 32)
            notif.Position        = UDim2.new(0.5, -130, 0, 60)
            notif.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
            notif.Text            = "✅ Teleport ke " .. nameID .. " / " .. nameEN
            notif.TextColor3      = Color3.fromRGB(100, 255, 100)
            notif.TextSize        = 12
            notif.Font            = Enum.Font.GothamBold
            notif.BorderSizePixel = 0
            notif.Parent          = screenGui
            local nc = Instance.new("UICorner")
            nc.CornerRadius = UDim.new(0, 6)
            nc.Parent = notif
            task.delay(2, function() notif:Destroy() end)
        else
            local notif = Instance.new("TextLabel")
            notif.Size            = UDim2.new(0, 260, 0, 32)
            notif.Position        = UDim2.new(0.5, -130, 0, 60)
            notif.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
            notif.Text            = "❌ Warna tidak ditemukan / Color not found"
            notif.TextColor3      = Color3.fromRGB(255, 100, 100)
            notif.TextSize        = 11
            notif.Font            = Enum.Font.GothamBold
            notif.BorderSizePixel = 0
            notif.Parent          = screenGui
            local nc = Instance.new("UICorner")
            nc.CornerRadius = UDim.new(0, 6)
            nc.Parent = notif
            task.delay(2, function() notif:Destroy() end)
        end
    end)

    return btn
end

-- ============================================================
-- ESP HIGHLIGHT SYSTEM
-- ============================================================
local function clearESP()
    for _, h in pairs(highlightObjects) do
        if h and h.Parent then h:Destroy() end
    end
    highlightObjects = {}
end

local function addHighlight(obj, fillColor, outlineColor, tag)
    if not obj or not obj.Parent then return end
    local existing = obj:FindFirstChild("ESP_Highlight_"..tag)
    if existing then return end

    local h = Instance.new("SelectionBox")
    h.Name          = "ESP_Highlight_"..tag
    h.Adornee       = obj
    h.Color3        = outlineColor or fillColor
    h.LineThickness = 0.06
    h.SurfaceTransparency = 0.6
    h.SurfaceColor3 = fillColor
    h.Parent        = obj
    table.insert(highlightObjects, h)
end

local function isColorMatch(part, targetColor)
    local r = math.abs(part.Color.R - targetColor.R)
    local g = math.abs(part.Color.G - targetColor.G)
    local b = math.abs(part.Color.B - targetColor.B)
    return (r + g + b) < 0.3
end

local function nameContains(obj, list)
    local lower = obj.Name:lower()
    for _, keyword in ipairs(list) do
        if lower:find(keyword:lower()) then return true end
    end
    return false
end

local function runESP()
    clearESP()

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then

            -- Color ESP
            if espState.colorESP then
                for _, cd in ipairs(COLOR_LIST) do
                    if isColorMatch(obj, cd.color) then
                        addHighlight(obj, cd.color, Color3.fromRGB(255,255,255), "color_"..cd.nameEN)
                        break
                    end
                end
            end

            -- Tree ESP
            if espState.treeESP and nameContains(obj, TREE_NAMES) then
                addHighlight(obj, Color3.fromRGB(0, 200, 80), Color3.fromRGB(0, 255, 100), "tree")
            end

            -- Lever ESP
            if espState.leverESP and nameContains(obj, LEVER_NAMES) then
                addHighlight(obj, Color3.fromRGB(255, 200, 0), Color3.fromRGB(255, 255, 0), "lever")
            end
        end
    end
end

-- ============================================================
-- BUILD UI SECTIONS
-- ============================================================

-- === Section: ESP Toggle ===
makeSection("⚡ ESP Toggle")

makeToggleRow("🎨 Warna / Color ESP", true, function(state)
    espState.colorESP = state
    runESP()
end)

makeToggleRow("🌲 Pohon / Tree ESP", true, function(state)
    espState.treeESP = state
    runESP()
end)

makeToggleRow("🔧 Tuas / Lever ESP", true, function(state)
    espState.leverESP = state
    runESP()
end)

-- Refresh Button
local refreshBtn = Instance.new("TextButton")
refreshBtn.Size            = UDim2.new(1, 0, 0, 28)
refreshBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 100)
refreshBtn.Text            = "🔄 Refresh ESP"
refreshBtn.TextColor3      = Color3.fromRGB(200, 200, 255)
refreshBtn.TextSize        = 12
refreshBtn.Font            = Enum.Font.GothamBold
refreshBtn.BorderSizePixel = 0
refreshBtn.Parent          = scrollFrame

local rbc = Instance.new("UICorner")
rbc.CornerRadius = UDim.new(0, 5)
rbc.Parent = refreshBtn

refreshBtn.MouseButton1Click:Connect(function()
    runESP()
end)

-- === Section: Teleport Warna ===
makeSection("🚀 Teleport ke Warna / Teleport to Color")

for _, cd in ipairs(COLOR_LIST) do
    makeTeleportBtn(cd.nameID, cd.nameEN, cd.color, cd.color)
end

-- === Section: Teleport Objek ===
makeSection("🌲 Teleport ke Objek / Teleport to Object")

-- Teleport to nearest Tree
local treeBtn = Instance.new("TextButton")
treeBtn.Size            = UDim2.new(1, 0, 0, 28)
treeBtn.BackgroundColor3 = Color3.fromRGB(10, 40, 20)
treeBtn.Text            = "⟶  Pohon / Tree"
treeBtn.TextColor3      = Color3.fromRGB(80, 255, 120)
treeBtn.TextSize        = 12
treeBtn.Font            = Enum.Font.Gotham
treeBtn.BorderSizePixel = 0
treeBtn.Parent          = scrollFrame

local tbc = Instance.new("UICorner")
tbc.CornerRadius = UDim.new(0, 5)
tbc.Parent = treeBtn

local tbStroke = Instance.new("UIStroke")
tbStroke.Color = Color3.fromRGB(0, 200, 80)
tbStroke.Thickness = 1
tbStroke.Parent = treeBtn

treeBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local best, bestDist = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and nameContains(obj, TREE_NAMES) then
            local dist = (obj.Position - hrp.Position).Magnitude
            if dist < bestDist then best, bestDist = obj, dist end
        end
    end
    if best then hrp.CFrame = CFrame.new(best.Position + Vector3.new(0, 5, 0)) end
end)

-- Teleport to nearest Lever
local levBtn = Instance.new("TextButton")
levBtn.Size            = UDim2.new(1, 0, 0, 28)
levBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 10)
levBtn.Text            = "⟶  Tuas / Lever"
levBtn.TextColor3      = Color3.fromRGB(255, 220, 60)
levBtn.TextSize        = 12
levBtn.Font            = Enum.Font.Gotham
levBtn.BorderSizePixel = 0
levBtn.Parent          = scrollFrame

local lbc = Instance.new("UICorner")
lbc.CornerRadius = UDim.new(0, 5)
lbc.Parent = levBtn

local lbStroke = Instance.new("UIStroke")
lbStroke.Color = Color3.fromRGB(255, 200, 0)
lbStroke.Thickness = 1
lbStroke.Parent = levBtn

levBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local best, bestDist = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and nameContains(obj, LEVER_NAMES) then
            local dist = (obj.Position - hrp.Position).Magnitude
            if dist < bestDist then best, bestDist = obj, dist end
        end
    end
    if best then hrp.CFrame = CFrame.new(best.Position + Vector3.new(0, 5, 0)) end
end)

-- ============================================================
-- AUTO UPDATE CANVAS SIZE
-- ============================================================
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
end)

-- ============================================================
-- DRAG SUPPORT
-- ============================================================
local dragging, dragInput, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos  = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ============================================================
-- MINIMIZE
-- ============================================================
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    scrollFrame.Visible = not minimized
    mainFrame.Size = minimized and UDim2.new(0, 320, 0, 38) or UDim2.new(0, 320, 0, 500)
    minBtn.Text = minimized and "+" or "–"
end)

-- ============================================================
-- INITIAL RUN + AUTO REFRESH
-- ============================================================
task.wait(1)
runESP()

-- Auto re-scan every 10 detik
task.spawn(function()
    while task.wait(10) do
        runESP()
    end
end)

print("✅ MAP ESP loaded — tele apiszx")
