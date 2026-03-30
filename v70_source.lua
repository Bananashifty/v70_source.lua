local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🍌 BANANA HUB V72 | RIVALS",
   LoadingTitle = "Banana Hub Loading...",
   LoadingSubtitle = "V70 Edition Updated",
   ConfigurationSaving = { Enabled = true, Folder = "BananaHub" }
})

-- SERVICES & VARS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local ESP_Enabled = false
local Aimbot_Enabled = false
local FOV_Radius = 150
local FOV_Visible = true
local WalkSpeed_Value = 16

-- FOV CIRCLE
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 60
FOVCircle.Radius = FOV_Radius
FOVCircle.Filled = false
FOVCircle.Visible = FOV_Visible
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

-- AIMBOT FUNCTION
local function GetClosestPlayer()
    local target = nil
    local dist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                local magnitude = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if magnitude < dist and magnitude < FOV_Radius then
                    target = p
                    dist = magnitude
                end
            end
        end
    end
    return target
end

-- MAIN LOOP (SPEED & AIMBOT)
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOVCircle.Radius = FOV_Radius
    FOVCircle.Visible = FOV_Visible

    if Aimbot_Enabled then
        local target = GetClosestPlayer()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeed_Value
    end
end)

-- TABS
local Combat = Window:CreateTab("Combat", 4483362458)
local Visuals = Window:CreateTab("Visuals", 4483362458)

Combat:CreateToggle({Name = "Enable Aimbot", CurrentValue = false, Callback = function(v) Aimbot_Enabled = v end})
Combat:CreateSlider({Name = "Aimbot FOV", Range = {50, 800}, Increment = 10, CurrentValue = 150, Callback = function(v) FOV_Radius = v end})
Combat:CreateSlider({Name = "WalkSpeed", Range = {16, 250}, Increment = 5, CurrentValue = 16, Callback = function(v) WalkSpeed_Value = v end})

Combat:CreateButton({
    Name = "TP behind Closest Enemy",
    Callback = function()
        local target = GetClosestPlayer()
        if target then LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3) end
    end
})

Visuals:CreateToggle({
    Name = "Enable Aura ESP",
    CurrentValue = false,
    Callback = function(v)
        ESP_Enabled = v
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p ~= LocalPlayer then
                local h = p.Character:FindFirstChildOfClass("Highlight") or Instance.new("Highlight", p.Character)
                h.Enabled = v
                h.FillColor = Color3.fromRGB(255, 255, 0)
            end
        end
    end
})
Visuals:CreateToggle({Name = "Show FOV Circle", CurrentValue = true, Callback = function(v) FOV_Visible = v end})
