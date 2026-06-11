--[[ 
    ==================================================
    COPYRIGHT BY: ZoneXD
    PROJECT: UNDERGROUND LEVER & KEY FINDER (ANTI-LAG)
    ==================================================
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- 1. AUTO CHAT COPYRIGHT SYSTEM (Otomatis Ngetik Pas Run)
task.spawn(function()
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer("Script Loaded! Copyright by ZoneXD", "All")
    end)
    pcall(function()
        game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("Script Loaded! Copyright by ZoneXD")
    end)
end)

-- 2. CONFIGURATION STATE
local Toggles = {
    ESP_Lever = false,
    ESP_Key = false
}

-- 3. ESP ENGINE (Ringan & Tembus Tanah)
local function ApplyZoneESP(obj, color, labelText)
    if obj:FindFirstChild("ZoneXD_Box") then return end
    
    -- Box Chams (Selalu di atas / Tembus tanah)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ZoneXD_Box"
    box.Adornee = obj
    box.Size = obj.Size + Vector3.new(0.3, 0.3, 0.3)
    box.AlwaysOnTop = true
    box.Color3 = color
    box.Transparency = 0.4
    box.ZIndex = 10
    box.Parent = obj
    
    -- Tag Nama Melayang (Dua Bahasa)
    local gui = Instance.new("BillboardGui")
    gui.Name = "ZoneXD_Text"
    gui.Size = UDim2.new(0, 120, 0, 30)
    gui.AlwaysOnTop = true
    gui.StudsOffset = Vector3.new(0, 2, 0)
    
    local lbl = Instance.new("TextLabel", gui)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = color
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 14
    lbl.TextStrokeTransparency = 0
    
    gui.Parent = obj
end

-- SCANNER LOOP (Dioptimasi biar gak lag: Cek tiap 1.5 detik)
task.spawn(function()
    while task.wait(1.5) do
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                local nameLower = string.lower(v.Name)
                
                -- Deteksi Tuas
                if (nameLower == "tuas" or nameLower == "lever" or nameLower == "switch") then
                    if Toggles.ESP_Lever then
                        ApplyZoneESP(v, Color3.fromRGB(255, 120, 0), "Lever / Tuas")
                    else
                        if v:FindFirstChild("ZoneXD_Box") then v.ZoneXD_Box:Destroy() end
                        if v:FindFirstChild("ZoneXD_Text") then v.ZoneXD_Text:Destroy() end
                    end
                    
                -- Deteksi Kunci
                elseif (nameLower == "key" or nameLower == "kunci") then
                    if Toggles.ESP_Key then
                        ApplyZoneESP(v, Color3.fromRGB(255, 255, 0), "Key / Kunci")
                    else
                        if v:FindFirstChild("ZoneXD_Box") then v.ZoneXD_Box:Destroy() end
                        if v:FindFirstChild("ZoneXD_Text") then v.ZoneXD_Text:Destroy() end
                    end
                end
            end
        end
    end
end)

-- 4. GUI MENU (MINIMALIS & BISA DRAG + MINIMIZE)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZoneXD_MenuUI"
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 190, 0, 230)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

-- Title Bar
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "  ZoneXD Finder Pro"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner", Title)
TitleCorner.CornerRadius = UDim.new(0, 8)

-- Tombol M (Minimize di Menu Utama)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -30, 0, 2)
MinBtn.Text = "M"
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Parent = MainFrame

-- Kotak M Kecil (Saat Di-minimize)
local MiniIcon = Instance.new("TextButton")
MiniIcon.Size = UDim2.new(0, 40, 0, 40)
MiniIcon.Position = UDim2.new(0.02, 0, 0.1, 0)
MiniIcon.Text = "M"
MiniIcon.Font = Enum.Font.SourceSansBold
MiniIcon.TextSize = 18
MiniIcon.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
MiniIcon.TextColor3 = Color3.new(1, 1, 1)
MiniIcon.Visible = false
MiniIcon.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner", MiniIcon)
MiniCorner.CornerRadius = UDim.new(0, 8)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniIcon.Visible = true
end)

MiniIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniIcon.Visible = false
end)

-- Pembuat Tombol Toggle Ringan
local function CreateMenuToggle(text, yPos, configKey)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text .. " : OFF"
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 5)
    
    btn.MouseButton1Click:Connect(function()
        Toggles[configKey] = not Toggles[configKey]
        btn.Text = text .. (Toggles[configKey] and " : ON" or " : OFF")
        btn.BackgroundColor3 = Toggles[configKey] and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(50, 50, 50)
    end)
end

CreateMenuToggle("ESP Tuas / Lever", 45, "ESP_Lever")
CreateMenuToggle("ESP Kunci / Key", 90, "ESP_Key")

-- Tombol Teleport ke Tuas Terdekat
local TPBtn = Instance.new("TextButton", MainFrame)
TPBtn.Size = UDim2.new(0.9, 0, 0, 35)
TPBtn.Position = UDim2.new(0.05, 0, 0, 135)
TPBtn.Text = "TP Tuas Terdekat"
TPBtn.Font = Enum.Font.SourceSansBold
TPBtn.TextSize = 13
TPBtn.BackgroundColor3 = Color3.fromRGB(0, 90, 180)
TPBtn.TextColor3 = Color3.new(1, 1, 1)

local TPCorner = Instance.new("UICorner", TPBtn)
TPCorner.CornerRadius = UDim.new(0, 5)

TPBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local targetTuas = nil
    local maxDistance = math.huge
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (string.lower(v.Name) == "tuas" or string.lower(v.Name) == "lever" or string.lower(v.Name) == "switch") then
            local currentDist = (hrp.Position - v.Position).Magnitude
            if currentDist < maxDistance then
                maxDistance = currentDist
                targetTuas = v
            end
        end
    end
    
    if targetTuas then
        hrp.CFrame = CFrame.new(targetTuas.Position + Vector3.new(0, 3, 0))
    end
end)

-- 5. COPYRIGHT FOOTER VISUAL (Nempel di UI Bawah)
local Footer = Instance.new("TextLabel", MainFrame)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.Text = "Copyright by: ZoneXD"
Footer.Font = Enum.Font.SourceSansBoldItalic
Footer.TextSize = 12
Footer.BackgroundTransparency = 1
Footer.TextColor3 = Color3.fromRGB(180, 180, 180)
