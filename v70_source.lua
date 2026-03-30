local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🍌 BANANA HUB V72 | VERSION FINALE",
   LoadingTitle = "CHARGEMENT FORCE...",
   LoadingSubtitle = "Si tu vois ca, c'est la bonne version !",
   ConfigurationSaving = { Enabled = false }
})

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- VARS
local Aimbot_Enabled = false
local FOV_Radius = 150
local FOV_Visible = true
local WalkSpeed_Value = 16

-- FOV CIRCLE
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 60
FOVCircle.Radius = FOV_Radius
FOVCircle.Visible = FOV_Visible
FOVCircle.Color = Color3.fromRGB(255, 255, 0)

-- AIMBOT FUNCTION
local function GetClosest()
    local target = nil
    local dist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < dist and mag < FOV_Radius then
                    target = p
                    dist = mag
                end
            end
        end
    end
    return target
end

-- LOOP
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOVCircle.Radius = FOV_Radius
    FOVCircle.Visible = FOV_Visible

    if Aimbot_Enabled then
        local target = GetClosest()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeed_Value
    end
end)

-- TABS
local Main = Window:CreateTab("Main", 4483362458)

Main:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Callback = function(v) Aimbot_Enabled = v end,
})

Main:CreateSlider({
   Name = "Speed",
   Range = {16, 200},
   Increment = 5,
   CurrentValue = 16,
   Callback = function(v) WalkSpeed_Value = v end,
})

Main:CreateToggle({
    Name = "ESP Aura",
    CurrentValue = false,
    Callback = function(v)
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p ~= LocalPlayer then
                local h = p.Character:FindFirstChildOfClass("Highlight") or Instance.new("Highlight", p.Character)
                h.Enabled = v
                h.FillColor = Color3.fromRGB(255, 255, 0)
            end
        end
    end
})

Main:CreateButton({
    Name = "TP Closest Enemy",
    Callback = function()
        local target = GetClosest()
        if target then LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame end
    end
})

Rayfield:Notify({Title = "V72 LOADED", Content = "Le script est pret !", Duration = 5})
