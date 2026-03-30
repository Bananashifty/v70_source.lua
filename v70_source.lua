local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🍌 BANANA HUB V72 | RIVALS",
   LoadingTitle = "Banana Hub Loading...",
   LoadingSubtitle = "Best Cheat for Rivals",
   ConfigurationSaving = { Enabled = true, Folder = "BananaHub" }
})

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- VARIABLES DE CONTROLE
local ESP_Enabled = false
local WalkSpeed_Value = 16

-- FONCTION ESP (BOX + TRACERS)
local function CreateESP(Player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(255, 0, 0)
    Box.Thickness = 2
    Box.Filled = false

    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Color = Color3.fromRGB(255, 255, 255)
    Tracer.Thickness = 1

    local function Update()
        local Connection
        Connection = RunService.RenderStepped:Connect(function()
            if ESP_Enabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player ~= LocalPlayer then
                local RootPart = Player.Character.HumanoidRootPart
                local Position, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)

                if OnScreen then
                    -- Taille de la Box selon la distance
                    local SizeX = 2000 / Position.Z
                    local SizeY = 3000 / Position.Z
                    
                    Box.Size = Vector2.new(SizeX, SizeY)
                    Box.Position = Vector2.new(Position.X - SizeX / 2, Position.Y - SizeY / 2)
                    Box.Visible = true

                    -- Ligne vers le joueur
                    Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    Tracer.To = Vector2.new(Position.X, Position.Y)
                    Tracer.Visible = true
                else
                    Box.Visible = false
                    Tracer.Visible = false
                end
            else
                Box.Visible = false
                Tracer.Visible = false
                if not Player.Parent then Connection:Disconnect() end
            end
        end)
    end
    coroutine.wrap(Update)()
end

-- LANCER L'ESP
for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

-- TABS
local MainTab = Window:CreateTab("Combat", 4483362458)
local VisualTab = Window:CreateTab("Visuals", 4483362458)

-- COMBAT
MainTab:CreateSection("Movement")

MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v)
       WalkSpeed_Value = v
   end,
})

-- Boucle infinie pour la vitesse (plus stable)
task.spawn(function()
    while true do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeed_Value
        end
        task.wait(0.1)
    end
end)

MainTab:CreateButton({
   Name = "Teleport behind Random Enemy",
   Callback = function()
       local targets = {}
       for _, p in pairs(Players:GetPlayers()) do
           if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
               table.insert(targets, p)
           end
       end
       
       if #targets > 0 then
           local target = targets[math.random(1, #targets)]
           LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
           Rayfield:Notify({Title = "TP Success", Content = "Behind " .. target.Name, Duration = 2})
       end
   end,
})

-- VISUALS
VisualTab:CreateToggle({
   Name = "Enable ESP (Boxes & Lines)",
   CurrentValue = false,
   Flag = "ESP_Toggle",
   Callback = function(Value)
       ESP_Enabled = Value
   end,
})

Rayfield:Notify({Title = "Banana Hub", Content = "Cheat Source Updated!", Duration = 3})
