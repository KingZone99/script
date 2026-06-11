--[[ 
    ========================================================================
    COPYRIGHT BY: ZoneXD
    PROJECT NAME: ZONE-XAD EXTREME MAP TESTER TOOL (MAX ULTRA VERSION)
    DEVELOPER: ZoneXD
    FEATURES: ALL SWITCHABLE / FULLY TOGGLEABLE CONFIGURATIONS
    ========================================================================
]]

-- SERVICES ROBLOX UTAMA
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

-- 1. SISTEM NOTIFIKASI & CHAT OTOMATIS SAAT EKSEKUSI
task.spawn(function()
    pcall(function()
        ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer("Extreme Script Loaded! Copyright by ZoneXD", "All")
    end)
    pcall(function()
        TextChatService.TextChannels.RBXGeneral:SendAsync("Extreme Script Loaded! Copyright by ZoneXD")
    end)
end)

-- 2. MASTER GLOBAL CONFIGURATION (Semua Fitur Bisa Di-Mati/Hidupkan)
local ZoneXD_Master = {
    Noclip = false,
    ESPLever = true,
    ESPKey = true,
    AutoFarmLever = false,
    AutoFarmKey = false
}

-- 3. INTERNALS ENGINE - CLEANER SYSTEM (Mencegah Lag Dan Penumpukan Memori)
local function BersihkanESP(namaTag)
    for _, objek di pairs(workspace:GetDescendants()) do
        if objek:IsA("BasePart") then
            local adalek = objek:FindFirstChild(namaTag)
            if adalek then adalek:Destroy() end
            
            local adateks = objek:FindFirstChild(namaTag .. "_Text")
            if adateks then adateks:Destroy() end
        end
    end
end

-- 4. HIGH-PERFORMANCE NOCLIP ENGINE
RunService.Stepped:Connect(function()
    if ZoneXD_Master.Noclip then
        if LocalPlayer.Character then
            for _, bagianTubuh di pairs(LocalPlayer.Character:GetDescendants()) do
                if bagianTubuh:IsA("BasePart") then
                    bagianTubuh.CanCollide = false
                end
            end
        end
    end
end)

-- 5. ADVANCED SYSTEM ESP (BOX TEMBUS TANAH + BILINGUAL TAG)
local function PasangRenderESP(targetPart, warnaRender, teksLabel, namaTag)
    if targetPart:FindFirstChild(namaTag) then return end
    
    -- Rendering Box Chams (Always On Top)
    local visualBox = Instance.new("BoxHandleAdornment")
    visualBox.Name = namaTag
    visualBox.Adornee = targetPart
    visualBox.Size = targetPart.Size + Vector3.new(0.35, 0.35, 0.35)
    visualBox.AlwaysOnTop = true
    visualBox.Color3 = warnaRender
    visualBox.Transparency = 0.4
    visualBox.ZIndex = 11
    visualBox.Parent = targetPart
    
    -- Rendering Billboard Teks di Atas Objek
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = namaTag .. "_Text"
    billboardGui.Size = UDim2.new(0, 140, 0, 30)
    billboardGui.AlwaysOnTop = true
    billboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = teksLabel
    textLabel.TextColor3 = warnaRender
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 13
    textLabel.TextStrokeTransparency = 0
    textLabel.Parent = billboardGui
    
    billboardGui.Parent = targetPart
end

-- 6. BACKGROUND MONITORING SCHEDULER (Sistem Scan Terjadwal Anti-Lag)
task.spawn(function()
    while task.wait(1) do
        for _, objek di pairs(workspace:GetDescendants()) do
            if objek:IsA("BasePart") then
                local namaKecil = string.lower(objek.Name)
                
                -- Handler Filter ESP Tuas
                if (namaKecil == "tuas" or namaKecil == "lever" or namaKecil == "switch") then
                    if ZoneXD_Master.ESPLever then
                        if objek.Color.R > 0.8 then
                            PasangRenderESP(objek, Color3.fromRGB(255, 0, 0), "Lever [Merah]", "ZoneXD_Lever")
                        elseif objek.Color.G > 0.8 then
                            PasangRenderESP(objek, Color3.fromRGB(0, 255, 0), "Lever [Hijau]", "ZoneXD_Lever")
                        elseif objek.Color.B > 0.8 then
                            PasangRenderESP(objek, Color3.fromRGB(0, 0, 255), "Lever [Biru]", "ZoneXD_Lever")
                        else
                            PasangRenderESP(objek, Color3.fromRGB(255, 140, 0), "Lever / Tuas", "ZoneXD_Lever")
                        end
                    end
                    
                -- Handler Filter ESP Kunci
                elseif (namaKecil == "key" or namaKecil == "kunci") then
                    if ZoneXD_Master.ESPKey then
                        PasangRenderESP(objek, Color3.fromRGB(255, 255, 0), "Key / Kunci", "ZoneXD_Key")
                    end
                end
            end
        end
    end
end)

-- 7. AUTOFARM CORE ENGINE (SISTEM TELEPORT OTOMATIS BERURUTAN)
task.spawn(function()
    while task.wait(0.5) do
        local karakter = LocalPlayer.Character
        if karakter and karakter:FindFirstChild("HumanoidRootPart") then
            local hrp = karakter.HumanoidRootPart
            
            -- Jika Auto Farm Tuas Aktif
            if ZoneXD_Master.AutoFarmLever then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (string.lower(v.Name) == "tuas" or string.lower(v.Name) == "lever") then
                        hrp.CFrame = CFrame.new(v.Position + Vector3.new(0, 2, 0))
                        task.wait(0.3) -- Jeda waktu eksekusi agar tidak bug tanah
                    end
                end
            end
            
            -- Jika Auto Farm Kunci Aktif
            if ZoneXD_Master.AutoFarmKey then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (string.lower(v.Name) == "key" or string.lower(v.Name) == "kunci") then
                        hrp.CFrame = CFrame.new(v.Position + Vector3.new(0, 2, 0))
                        task.wait(0.3)
                    end
                end
            end
        end
    end
end)

-- 8. MANUAL TARGET TELEPORTATION LOGIC
local function TeleportManualWarna(pilihWarna)
    local karakter = LocalPlayer.Character
    if not karakter or not karakter:FindFirstChild("HumanoidRootPart") then return end
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name == "Tuas" or v.Name == "Lever") then
            local valid = false
            if pilihWarna == "Merah" and v.Color.R > 0.8 then valid = true
            elseif pilihWarna == "Hijau" and v.Color.G > 0.8 then valid = true
            elseif pilihWarna == "Biru" and v.Color.B > 0.8 then valid = true
            end
            
            if valid then
                karakter.HumanoidRootPart.CFrame = CFrame.new(v.Position + Vector3.new(0, 3, 0))
                break
            end
        end
    end
end

-- 9. PREMIUM LOOKING USER INTERFACE DESIGN (BY ZONEXD)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZoneXD_Extreme_UI"
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Frame Panel Utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 230, 0, 440)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Header Panel
local HeaderBar = Instance.new("TextLabel")
HeaderBar.Size = UDim2.new(1, 0, 0, 35)
HeaderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
HeaderBar.Text = "  ZoneXD Ultimate Panel V2"
HeaderBar.TextColor3 = Color3.new(1, 1, 1)
HeaderBar.Font = Enum.Font.SourceSansBold
HeaderBar.TextSize = 14
HeaderBar.TextXAlignment = Enum.TextXAlignment.Left
HeaderBar.Parent = MainFrame

Instance.new("UICorner", HeaderBar).CornerRadius = UDim.new(0, 10)

-- SISTEM MINIMIZE (TOMBOL M UTAMA & MINI ICON)
local MinimizeBtn = Instance.new("TextButton", MainFrame)
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(1, -32, 0, 5)
MinimizeBtn.Text = "M"
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 5)

local MiniIcon = Instance.new("TextButton", ScreenGui)
MiniIcon.Size = UDim2.new(0, 42, 0, 42)
MiniIcon.Position = UDim2.new(0.02, 0, 0.15, 0)
MiniIcon.Text = "M"
MiniIcon.Font = Enum.Font.SourceSansBold
MiniIcon.TextSize = 20
MiniIcon.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
MiniIcon.TextColor3 = Color3.new(1, 1, 1)
MiniIcon.Visible = false
Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(0, 10)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniIcon.Visible = true
end)

MiniIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniIcon.Visible = false
end)

-- BUILDER TOMBOL INTERAKTIF (Untuk On/Off Otomatis)
local function BuatTombolAksi(namaLabel, posisiY, statusAwal, warnaDefault, fungsiKlik)
    local tombol = Instance.new("TextButton", MainFrame)
    tombol.Size = UDim2.new(0.9, 0, 0, 32)
    tombol.Position = UDim2.new(0.05, 0, 0, posisiY)
    tombol.Text = namaLabel .. (statusAwal and " : ON" or " : OFF")
    tombol.Font = Enum.Font.SourceSansBold
    tombol.TextSize = 13
    tombol.BackgroundColor3 = statusAwal and Color3.fromRGB(0, 130, 0) or warnaDefault
    tombol.TextColor3 = Color3.new(1, 1, 1)
    
    Instance.new("UICorner", tombol).CornerRadius = UDim.new(0, 5)
    
    local aktif = statusAwal
    tombol.MouseButton1Click:Connect(function()
        aktif = not aktif
        fungsiKlik(aktif)
        tombol.Text = namaLabel .. (aktif and " : ON" or " : OFF")
        tombol.BackgroundColor3 = aktif and Color3.fromRGB(0, 130, 0) or warnaDefault
    end)
    return tombol
end

-- MENYUSUN LIST TOMBOL FUNGSIONAL (BISA DI ON / OFF)
BuatTombolAksi("Noclip (Tembus Map)", 45, false, Color3.fromRGB(55, 55, 55), function(state)
    ZoneXD_Master.Noclip = state
end)

BuatTombolAksi("ESP All Lever / Tuas", 85, true, Color3.fromRGB(55, 55, 55), function(state)
    ZoneXD_Master.ESPLever = state
    if not state then BersihkanESP("ZoneXD_Lever") end
end)

BuatTombolAksi("ESP All Key / Kunci", 125, true, Color3.fromRGB(55, 55, 55), function(state)
    ZoneXD_Master.ESPKey = state
    if not state then BersihkanESP("ZoneXD_Key") end
end)

BuatTombolAksi("Auto Farm (Loop Lever)", 165, false, Color3.fromRGB(55, 55, 55), function(state)
    ZoneXD_Master.AutoFarmLever = state
end)

BuatTombolAksi("Auto Farm (Loop Key)", 205, false, Color3.fromRGB(55, 55, 55), function(state)
    ZoneXD_Master.AutoFarmKey = state
end)

-- SEPARATOR TOMBOL TELEPORTASI MANUAL BERDASARKAN WARNA
local function BuatTombolTPWarna(teksTP, koordinatY, warnaTombol, namaWarna)
    local btnTP = Instance.new("TextButton", MainFrame)
    btnTP.Size = UDim2.new(0.9, 0, 0, 32)
    btnTP.Position = UDim2.new(0.05, 0, 0, koordinatY)
    btnTP.Text = teksTP
    btnTP.Font = Enum.Font.SourceSansBold
    btnTP.TextSize = 13
    btnTP.BackgroundColor3 = warnaTombol
    btnTP.TextColor3 = Color3.new(1, 1, 1)
    
    Instance.new("UICorner", btnTP).CornerRadius = UDim.new(0, 5)
    btnTP.MouseButton1Click:Connect(function()
        TeleportManualWarna(namaWarna)
    end)
end

BuatTombolTPWarna("Teleport ke Tuas MERAH", 255, Color3.fromRGB(150, 0, 0), "Merah")
BuatTombolTPWarna("Teleport ke Tuas HIJAU", 295, Color3.fromRGB(0, 120, 0), "Hijau")
BuatTombolTPWarna("Teleport ke Tuas BIRU", 335, Color3.fromRGB(0, 0, 150), "Biru")

-- 10. VISUAL FOOTER COPYRIGHT (STAY DI PANEL BAWAH)
local PanelFooter = Instance.new("TextLabel", MainFrame)
PanelFooter.Size = UDim2.new(1, 0, 0, 25)
PanelFooter.Position = UDim2.new(0, 0, 1, -28)
PanelFooter.Text = "Copyright by: ZoneXD"
PanelFooter.Font = Enum.Font.SourceSansBoldItalic
PanelFooter.TextSize = 12
PanelFooter.BackgroundTransparency = 1
PanelFooter.TextColor3 = Color3.fromRGB(160, 160, 160)
