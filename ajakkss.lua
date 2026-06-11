--[[ 
    ZONE-XD FIX: DEEP SCANNER & PRECISION TP
    Status: Fix Color Detection & Teleport Logic
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Fungsi Bantu: Cek Warna dengan Toleransi
local function IsColorMatch(color, target)
    -- Toleransi 0.3 supaya warna agak gelap/terang tetep kedeteksi
    return (math.abs(color.R - target.R) < 0.3) and 
           (math.abs(color.G - target.G) < 0.3) and 
           (math.abs(color.B - target.B) < 0.3)
end

-- Teleport Logic
local function TeleportKeWarna(colorName)
    local targetColor
    if colorName == "Red" then targetColor = Color3.fromRGB(255, 0, 0)
    elseif colorName == "Green" then targetColor = Color3.fromRGB(0, 255, 0)
    elseif colorName == "Blue" then targetColor = Color3.fromRGB(0, 0, 255)
    elseif colorName == "Purple" then targetColor = Color3.fromRGB(170, 0, 255) end

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (string.lower(v.Name):find("lever") or string.lower(v.Name):find("tuas") or string.lower(v.Name):find("switch")) then
            if IsColorMatch(v.Color, targetColor) then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position + Vector3.new(0, 3, 0))
                print("ZoneXD: Teleported to " .. colorName .. " Lever")
                return
            end
        end
    end
    warn("ZoneXD: Tuas " .. colorName .. " tidak ditemukan!")
end

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui); MainFrame.Size = UDim2.new(0, 200, 0, 250); MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0); MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30); MainFrame.Draggable = true; MainFrame.Active = true

local function AddBtn(text, y, color, func)
    local btn = Instance.new("TextButton", MainFrame); btn.Size = UDim2.new(0.9, 0, 0, 35); btn.Position = UDim2.new(0.05, 0, 0, y); btn.Text = text; btn.BackgroundColor3 = color; btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.SourceSansBold
    btn.MouseButton1Click:Connect(func)
end

AddBtn("TP MERAH", 20, Color3.fromRGB(200, 0, 0), function() TeleportKeWarna("Red") end)
AddBtn("TP HIJAU", 60, Color3.fromRGB(0, 200, 0), function() TeleportKeWarna("Green") end)
AddBtn("TP BIRU", 100, Color3.fromRGB(0, 0, 200), function() TeleportKeWarna("Blue") end)
AddBtn("TP UNGU", 140, Color3.fromRGB(150, 0, 200), function() TeleportKeWarna("Purple") end)
