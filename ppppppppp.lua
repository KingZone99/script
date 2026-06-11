--[[ 
    ==================================================
    COPYRIGHT BY: ZoneXD
    PROJECT: UNDERGROUND LEVER & KEY FINDER PRO
    ==================================================
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- 1. AUTO CHAT COPYRIGHT
task.spawn(function()
    pcall(function()
        game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("ZoneXD Script Loaded! © ZoneXD")
    end)
end)

-- 2. NOCLIP SYSTEM
local NoclipEnabled = false
RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 3. GUI UTAMA
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ZoneXD_GUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 350)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

-- 4. FUNGSI TELEPORT WARNA
local function TeleportToColoredLever(colorName)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "Tuas" or obj.Name == "Lever") then
            local isMatch = false
            if colorName == "Merah" and obj.Color.R > 0.8 then isMatch = true
            elseif colorName == "Hijau" and obj.Color.G > 0.8 then isMatch = true
            elseif colorName == "Biru" and obj.Color.B > 0.8 then isMatch = true
            end
            
            if isMatch then
                char.HumanoidRootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
                break
            end
        end
    end
end

-- 5. BUTTON CREATOR (Agar terlihat lebih banyak dan teratur)
local function CreateButton(name, yPos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.MouseButton1Click:Connect(callback)
end

-- 6. ISI MENU
CreateButton("Noclip (Tembus Tembok)", 20, function() 
    NoclipEnabled = not NoclipEnabled 
end)

CreateButton("Teleport ke Tuas Merah", 70, function() TeleportToColoredLever("Merah") end)
CreateButton("Teleport ke Tuas Hijau", 120, function() TeleportToColoredLever("Hijau") end)
CreateButton("Teleport ke Tuas Biru", 170, function() TeleportToColoredLever("Biru") end)

-- Tombol Minimize
local MinBtn = Instance.new("TextButton", ScreenGui)
MinBtn.Text = "Minimize (M)"
MinBtn.Size = UDim2.new(0, 100, 0, 30)
MinBtn.Position = UDim2.new(0, 0, 0.9, 0)
MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- Footer Copyright
local Footer = Instance.new("TextLabel", MainFrame)
Footer.Size = UDim2.new(1, 0, 0, 30)
Footer.Position = UDim2.new(0, 0, 1, -30)
Footer.Text = "© Copyright by ZoneXD"
Footer.TextColor3 = Color3.new(0.7, 0.7, 0.7)
Footer.BackgroundTransparency = 1
