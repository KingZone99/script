--[[ 
    AUTHOR & COPYRIGHT BY: ZoneXD
    PROJECT: UNDERGROUND LEVER FINDER & PLAYER ESP
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- 1. AUTO CHAT SYSTEM
task.spawn(function()
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer("Script Loaded! Copyright by ZoneXD", "All")
    end)
    -- Alternatif TextChatService (Roblox Baru)
    pcall(function()
        game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("Script Loaded! Copyright by ZoneXD")
    end)
end)

-- 2. MAIN SYSTEM CONFIG
local Config = {
    Tuas = false,
    Player = false
}
local ActiveObjects = {}

-- 3. GUI CREATION (MINIMALIS & TOGGLEABLE)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZoneXD_Ultimate"
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Main Frame Menu
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 240)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "  ZoneXD Menu"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Button M (Minimize di Menu Utama)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -30, 0, 2)
MinBtn.Text = "M"
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Parent = MainFrame

-- Kotak M Kecil (Saat Minimized)
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

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 8)
MiniCorner.Parent = MiniIcon

-- Fungsi Toggle Minimize
MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniIcon.Visible = true
end)

MiniIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniIcon.Visible = false
end)

-- Helper Fungsi Buat Tombol
local function CreateButton(text, pos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = pos
    btn.Text = text .. " : OFF"
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 5)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " : ON" or " : OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(50, 50, 50)
        callback(state)
    end)
end

-- 4. LOGIC TELEPORTASI KE TUAS
local function TeleportToLever()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    
    for _, v in pairs(workspace:GetDescendants()) do
        if (v.Name == "Tuas" or v.Name == "Lever" or v.Name == "Switch") and v:IsA("BasePart") then
            -- Teleport langsung ke atas koordinat tuas bawah tanah (+3 studs biar gak jepit)
            hrp.CFrame = CFrame.new(v.Position + Vector3.new(0, 3, 0))
            break
        end
    end
end

-- Pembuatan Tombol-Tombol UI
CreateButton("ESP Lever / Tuas", UDim2.new(0.05, 0, 0, 45), function(s) Config.Tuas = s end)
CreateButton("ESP Players / Pemain", UDim2.new(0.05, 0, 0, 90), function(s) Config.Player = s end)

-- Tombol Teleport Ke Tuas
local TPBtn = Instance.new("TextButton", MainFrame)
TPBtn.Size = UDim2.new(0.9, 0, 0, 35)
TPBtn.Position = UDim2.new(0.05, 0, 0, 135)
TPBtn.Text = "TP to Lever / Tuas"
TPBtn.Font = Enum.Font.SourceSansBold
TPBtn.TextSize = 13
TPBtn.BackgroundColor3 = Color3.fromRGB(0, 85, 180)
TPBtn.TextColor3 = Color3.new(1, 1, 1)
local TPCorner = Instance.new("UICorner", TPBtn)
TPCorner.CornerRadius = UDim.new(0, 5)
TPBtn.MouseButton1Click:Connect(TeleportToLever)

-- Footer Copyright
local Footer = Instance.new("TextLabel", MainFrame)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.Text = "Copyright by: ZoneXD"
Footer.Font = Enum.Font.SourceSansItalic
Footer.TextSize = 11
Footer.BackgroundTransparency = 1
Footer.TextColor3 = Color3.fromRGB(150, 150, 150)

-- 5. FUNCTIONAL ESP LOOP
RunService.RenderStepped:Connect(function()
    -- Logic ESP Tuas Tersembunyi (Box Tembus Pandang + Teks Bilingual)
    if Config.Tuas then
        for _, v in pairs(workspace:GetDescendants()) do
            if (v.Name == "Tuas" or v.Name == "Lever" or v.Name == "Switch") and v:IsA("BasePart") then
                if not v:FindFirstChild("ZoneXD_LeverESP") then
                    -- Box Chams (Tembus tanah/dinding)
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "ZoneXD_LeverESP"
                    box.Adornee = v
                    box.Size = v.Size + Vector3.new(0.2, 0.2, 0.2)
                    box.AlwaysOnTop = true
                    box.Color3 = Color3.fromRGB(255, 69, 0) -- Warna Oranye Menyala
                    box.Transparency = 0.4
                    box.ZIndex = 10
                    box.Parent = v
                    
                    -- Billboard Gui Tag Nama
                    local bgui = Instance.new("BillboardGui")
                    bgui.Name = "ZoneXD_LeverTag"
                    bgui.Size = UDim2.new(0, 150, 0, 30)
                    bgui.AlwaysOnTop = true
                    bgui.ExtentsOffset = Vector3.new(0, 2, 0)
                    
                    local tl = Instance.new("TextLabel", bgui)
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.Text = "Lever / Tuas"
                    tl.TextColor3 = Color3.fromRGB(255, 215, 0)
                    tl.Font = Enum.Font.SourceSansBold
                    tl.TextSize = 14
                    tl.TextStrokeTransparency = 0
                    
                    bgui.Parent = v
                end
            end
        end
    else
        -- Bersihkan ESP Tuas kalau di-OFF
        for _, v in pairs(workspace:GetDescendants()) do
            if v:FindFirstChild("ZoneXD_LeverESP") then v.ZoneXD_LeverESP:Destroy() end
            if v:FindFirstChild("ZoneXD_LeverTag") then v.ZoneXD_LeverTag:Destroy() end
        end
    end

    -- Logic ESP Player (Chams Highlight)
    if Config.Player then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if not p.Character:FindFirstChild("ZoneXD_PlayerESP") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ZoneXD_PlayerESP"
                    highlight.FillColor = Color3.fromRGB(0, 255, 255) -- Sian Menyala
                    highlight.OutlineColor = Color3.new(1, 1, 1)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = p.Character
                end
            end
        end
    else
        -- Bersihkan ESP Player kalau di-OFF
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ZoneXD_PlayerESP") then
                p.Character.ZoneXD_PlayerESP:Destroy()
            end
        end
    end
end)
