local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🍌 BANANA HUB V72 | RIVALS (GOD MODE)",
   LoadingTitle = "Banana Hub Loading...",
   LoadingSubtitle = "High Performance Script",
   ConfigurationSaving = { Enabled = true, Folder = "BananaHub" }
})

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- VARIABLES DE CONTROLE
local ESP_Enabled = false
local Aimbot_Enabled = false
local FOV_Visible = true
local FOV_Radius = 150
local WalkSpeed_Value = 16

-- CERCLE FOV POUR AIMBOT
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 60
FOVCircle.Radius = FOV_Radius
FOVCircle.Filled = false
FOVCircle.Visible = FOV_Visible
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

-- FONCTION POUR TROUVER LE PLUS PROCHE
local function GetClosestPlayer()
    local target = nil
    local shortestDistance = math.huge

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if distance < shortestDistance and distance < FOV_Radius then
                    target = p
                    shortestDistance = distance
                end
            end
        end
    end
    return target
end

-- BOUCLE AIMBOT & SPEED
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle
    FOVCircle.Radius = FOV_Radius
    FOVCircle.Visible = FOV_Visible
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)

    -- Aimbot logic
    if Aimbot_Enabled then
        local target = GetClosestPlayer()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end

    -- Speed Hack (Force)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeed_Value
    end
end)

-- FONCTION ESP AURA (HIGHLIGHT)
local function CreateAura(Player)
    local function Apply()
        if Player ~= LocalPlayer and Player.Character then
            local Highlight = Player.Character:FindFirstChild("BananaAura") or Instance.new("Highlight")
            Highlight.Name = "BananaAura"
            Highlight.Parent = Player.Character
            Highlight.FillColor = Color3.fromRGB(255, 255, 0)
            Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            Highlight.Enabled = ESP_Enabled
        end
    end
    Player.CharacterAdded:Connect(Apply)
    Apply()
end

for _, p in pairs(Players:GetPlayers()) do CreateAura(p) end
Players.PlayerAdded:Connect(CreateAura)

-- TABS
local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualTab = Window:CreateTab("Visuals", 4483362458)

-- --- COMBAT TAB ---
CombatTab:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Callback = function(Value) Aimbot_Enabled = Value end,
})

CombatTab:CreateSlider({
   Name = "Aimbot FOV Size",
   Range = {50, 800},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(v) FOV_Radius = v end,
})

CombatTab:CreateSlider({
   Name = "WalkSpeed (Force)",
   Range = {16, 250},
   Increment = 5,
   CurrentValue = 16,
   Callback = function(v) WalkSpeed_Value = v end,
})

CombatTab:CreateButton({
   Name = "TP behind Closest Enemy",
   Callback = function()
       local target = GetClosestPlayer()
       if target then
           LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
           Rayfield:Notify({Title = "TP Success", Content = "Teleported to " .. target.Name})
       else
           Rayfield:Notify({Title = "Error", Content = "No enemy in FOV range"})
       end
   end,
})

-- --- VISUALS TAB ---
VisualTab:CreateToggle({
   Name = "Enable ESP Aura (Highlight)",
   CurrentValue = false,
   Callback = function(Value) 
       ESP_Enabled = Value 
       -- Force update for existing players
       for _, p in pairs(Players:GetPlayers()) do
           if p.Character and p.Character:FindFirstChild("BananaAura") then
               p.Character.BananaAura.Enabled = Value
           end
       end
   end,
})

VisualTab:CreateToggle({
   Name = "Show FOV Circle",
   CurrentValue = true,
   Callback = function(Value) FOV_Visible = Value end,
})
