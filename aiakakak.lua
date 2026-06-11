--[[ 
    ========================================================================
    COPYRIGHT BY: ZoneXD
    PROJECT NAME: ULTIMATE UNDERGROUND LEVER FINDER & PLAYER ESP (PRO VERSION)
    DEVELOPER: ZoneXD
    ========================================================================
]]

-- INI ENGINE UTAMA ROBLOX SERVICE
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- 1. FITUR CHAT OTOMATIS SAAT SKRIP DI-RUN
task.spawn(function()
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer("Script Loaded! Copyright by ZoneXD", "All")
    end)
    pcall(function()
        game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("Script Loaded! Copyright by ZoneXD")
    end)
end)

-- 2. KONFIGURASI GLOBAL (STATE MANAGEMENT)
local ZoneXD_Config = {
    NoclipActive = false,
    ESPLeverActive = true,
    ESPKeyActive = true,
    ActiveObjects = {}
}

-- 3. NOCLIP ENGINE (TEMBUS TEMBOK & TANAH)
RunService.Stepped:Connect(function()
    if ZoneXD_Config.NoclipActive then
        if LocalPlayer.Character then
            for _, bodyPart in pairs(LocalPlayer.Character:GetDescendants()) do
                if bodyPart:IsA("BasePart") then
                    bodyPart.CanCollide = false
                end
            end
        end
    end
end)

-- 4. ESP ENGINE UNTUK TUAS TERSEMBUNYI & KUNCI (TEMBUS PANDANG)
local function BuatSistemESP(objekGame, warnaESP, teksBahasa)
    if objekGame:FindFirstChild("ZoneXD_Adornment") then return end
    
    -- Membuat Box Chams Tembus Tanah
    local boxChams = Instance.new("BoxHandleAdornment")
    boxChams.Name = "ZoneXD_Adornment"
    boxChams.Adornee = objekGame
    boxChams.Size = objekGame.Size + Vector3.new(0.4, 0.4, 0.4)
    boxChams.AlwaysOnTop = true
    boxChams.Color3 = warnaESP
    boxChams.Transparency = 0.35
    boxChams.ZIndex = 10
    boxChams.Parent = objekGame
    
    -- Membuat Teks Melayang Dua Bahasa
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ZoneXD_Billboard"
    billboardGui.Size = UDim2.new(0, 150, 0, 30)
    billboardGui.AlwaysOnTop = true
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    
    local teksLabel = Instance.new("TextLabel")
    teksLabel.Size = UDim2.new(1, 0, 1, 0)
    teksLabel.BackgroundTransparency = 1
    teksLabel.Text = teksBahasa
    teksLabel.TextColor3 = warnaESP
    teksLabel.Font = Enum.Font.SourceSansBold
    teksLabel.TextSize = 14
    teksLabel.TextStrokeTransparency = 0
    teksLabel.Parent = billboardGui
    
    billboardGui.Parent = objekGame
end

-- SCANNING LOOP UNTUK UPDATE OBJEK MAP (Dibuat terjadwal biar gak lag)
task.spawn(function()
    while task.wait(1) do
        for _, objek di pairs(workspace:GetDescendants()) do
            if objek:IsA("BasePart") then
                local namaObjek = string.lower(objek.Name)
                
                -- Deteksi Objek Tuas
                if (namaObjek == "tuas" or namaObjek == "lever" or namaObjek == "switch") then
                    if ZoneXD_Config.ESPLeverActive then
                        -- Deteksi Warna bawaan part untuk membedakan ESP
                        if objek.Color.R > 0.8 then
                            BuatSistemESP(objek, Color3.fromRGB(255, 0, 0), "Lever / Tuas [Red]")
                        elseif objek.Color.G > 0.8 then
                            BuatSistemESP(objek, Color3.fromRGB(0, 255, 0), "Lever / Tuas [Green]")
                        elseif objek.Color.B > 0.8 then
                            BuatSistemESP(objek, Color3.fromRGB(0, 0, 255), "Lever / Tuas [Blue]")
                        else
                            BuatSistemESP(objek, Color3.fromRGB(255, 165, 0), "Lever / Tuas")
                        end
                    else
                        if objek:FindFirstChild("ZoneXD_Adornment") then objek.ZoneXD_Adornment:Destroy() end
                        if objek:FindFirstChild("ZoneXD_Billboard") then objek.ZoneXD_Billboard:Destroy() end
                    end
                    
                -- Deteksi Objek Kunci (Key)
                elseif (namaObjek == "key" or namaObjek == "kunci") then
                    if ZoneXD_Config.ESPKeyActive then
                        BuatSistemESP(objek, Color3.fromRGB(255, 255, 0), "Key / Kunci")
                    else
                        if objek:FindFirstChild("ZoneXD_Adornment") then objek.ZoneXD_Adornment:Destroy() end
                        if objek:FindFirstChild("ZoneXD_Billboard") then objek.ZoneXD_Billboard:Destroy() end
                    end
                end
            end
        end
    end
end)

-- 5. TELEPORTATION SYSTEM (BERDASARKAN WARNA TUAS)
local function TeleportKeTuasWarna(pilihanWarna)
    local karakter = LocalPlayer.Character
    if not karakter or not karakter:FindFirstChild("HumanoidRootPart") then return end
    
    local akarKarakter = karakter.HumanoidRootPart
    
    for _, objek di pairs(workspace:GetDescendants()) do
        if objek:IsA("BasePart") and (objek.Name == "Tuas" or objek.Name == "Lever" or objek.Name == "Switch") then
            local cekKecocokan = false
            
            if pilihanWarna == "Merah" and objek.Color.R > 0.8 then
                cekKecocokan = true
            elseif pilihanWarna == "Hijau" and objek.Color.G > 0.8 then
                cekKecocokan = true
            elseif pilihanWarna == "Biru" and objek.Color.B > 0.8 then
                cekKecocokan = true
            end
            
            if cekKecocokan then
                akarKarakter.CFrame = CFrame.new(objek.Position + Vector3.new(0, 3, 0))
                break
            end
        end
    end
end

-- 6. TAMPILAN USER INTERFACE (GUI) - DESIGNED BY ZONEXD
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZoneXD_Ultimate_GUI"
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Frame Utama Menu
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 360)
MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Judul Menu Atas
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, 0, 0, 35)
TitleText.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TitleText.Text = "  ZoneXD Project Pro"
TitleText.TextColor3 = Color3.new(1, 1, 1)
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleText

-- Tombol Minimize Menjadi Kotak M Kecil
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(1, -32, 0, 5)
MinimizeButton.Text = "M"
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.Parent = MainFrame

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeButton

-- Kotak M Kecil di Layar (Saat Kondisi Hilang)
local MiniIcon = Instance.new("TextButton")
MiniIcon.Size = UDim2.new(0, 42, 0, 42)
MiniIcon.Position = UDim2.new(0.02, 0, 0.15, 0)
MiniIcon.Text = "M"
MiniIcon.Font = Enum.Font.SourceSansBold
MiniIcon.TextSize = 20
MiniIcon.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
MiniIcon.TextColor3 = Color3.new(1, 1, 1)
MiniIcon.Visible = false
MiniIcon.Parent = ScreenGui

local MiniIconCorner = Instance.new("UICorner")
MiniIconCorner.CornerRadius = UDim.new(0, 10)
MiniIconCorner.Parent = MiniIcon

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniIcon.Visible = true
end)

MiniIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniIcon.Visible = false
end)

-- Pembuatan Desain Tombol Menu Secara Terstruktur
local function BuatTombolMenu(teksTampilan, koordinatY, warnaDasar, aksiKlik)
    local buttonInstance = Instance.new("TextButton", MainFrame)
    buttonInstance.Size = UDim2.new(0.9, 0, 0, 35)
    buttonInstance.Position = UDim2.new(0.05, 0, 0, koordinatY)
    buttonInstance.Text = teksTampilan
    buttonInstance.Font = Enum.Font.SourceSansBold
    buttonInstance.TextSize = 13
    buttonInstance.BackgroundColor3 = warnaDasar
    buttonInstance.TextColor3 = Color3.new(1, 1, 1)
    
    local buttonCorner = Instance.new("UICorner", buttonInstance)
    buttonCorner.CornerRadius = UDim.new(0, 6)
    
    buttonInstance.MouseButton1Click:Connect(aksiKlik)
    return buttonInstance
end

-- ISI SELURUH TOMBOL UTAMA SCRIPT
local NoclipBtn = BuatTombolMenu("Noclip (Tembus Tembok): OFF", 50, Color3.fromRGB(60, 60, 60), function()
    ZoneXD_Config.NoclipActive = not ZoneXD_Config.NoclipActive
    if ZoneXD_Config.NoclipActive then
        NoclipBtn.Text = "Noclip (Tembus Tembok): ON"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 0)
    else
        NoclipBtn.Text = "Noclip (Tembus Tembok): OFF"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

local ESPLeverBtn = BuatTombolMenu("ESP Tuas / Lever: ON", 95, Color3.fromRGB(0, 130, 0), function()
    ZoneXD_Config.ESPLeverActive = not ZoneXD_Config.ESPLeverActive
    ESPLeverBtn.Text = "ESP Tuas / Lever: " .. (ZoneXD_Config.ESPLeverActive and "ON" or "OFF")
    ESPLeverBtn.BackgroundColor3 = ZoneXD_Config.ESPLeverActive and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(60, 60, 60)
end)

local ESPKeyBtn = BuatTombolMenu("ESP Kunci / Key: ON", 140, Color3.fromRGB(0, 130, 0), function()
    ZoneXD_Config.ESPKeyActive = not ZoneXD_Config.ESPKeyActive
    ESPKeyBtn.Text = "ESP Kunci / Key: " .. (ZoneXD_Config.ESPKeyActive and "ON" or "OFF")
    ESPKeyBtn.BackgroundColor3 = ZoneXD_Config.ESPKeyActive and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(60, 60, 60)
end)

BuatTombolMenu("Teleport: Tuas MERAH", 185, Color3.fromRGB(150, 0, 0), function()
    TeleportKeTuasWarna("Merah")
end)

BuatTombolMenu("Teleport: Tuas HIJAU", 230, Color3.fromRGB(0, 110, 0), function()
    TeleportKeTuasWarna("Hijau")
end)

BuatTombolMenu("Teleport: Tuas BIRU", 275, Color3.fromRGB(0, 0, 150), function()
    TeleportKeTuasWarna("Biru")
end)

-- 7. KOTAK VISUAL COPYRIGHT (BAGIAN BAWAH UI)
local CopyrightFooter = Instance.new("TextLabel")
CopyrightFooter.Size = UDim2.new(1, 0, 0, 25)
CopyrightFooter.Position = UDim2.new(0, 0, 1, -28)
CopyrightFooter.Text = "Copyright by: ZoneXD"
CopyrightFooter.Font = Enum.Font.SourceSansBoldItalic
CopyrightFooter.TextSize = 12
CopyrightFooter.BackgroundTransparency = 1
CopyrightFooter.TextColor3 = Color3.fromRGB(160, 160, 160)
CopyrightFooter.Parent = MainFrame
