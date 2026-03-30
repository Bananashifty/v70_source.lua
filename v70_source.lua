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

-- VARIABLES ESP
local ESP_Enabled = false

-- FONCTION ESP (BOX + TRACERS)
local function CreateESP(Player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(255, 255, 0)
    Box.Thickness = 1
    Box.Filled = false

    RunService.RenderStepped:Connect(function()
        if ESP_Enabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player ~= LocalPlayer then
            local RootPart = Player.Character.HumanoidRootPart
            local Vector, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(RootPart.Position)

            if OnScreen then
                Box.Size = Vector2.new(2000 / Vector.Z, 3500 / Vector.Z)
                Box.Position = Vector2.new(Vector.X - Box.Size.X / 2, Vector.Y - Box.Size.Y / 2)
                Box.Visible = true
            else
                Box.Visible = false
            end
        else
            Box.Visible = false
        end
    end)
end

-- LANCER L'ESP POUR CHAQUE JOUEUR
for _, player in pairs(Players:GetPlayers()) do
    CreateESP(player)
end
Players.PlayerAdded:Connect(CreateESP)

-- TABS
local MainTab = Window:CreateTab("Combat", 4483362458)
local VisualTab = Window:CreateTab("Visuals", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- COMBAT FUNCTIONS
MainTab:CreateSection("Movement & Kill")

MainTab:CreateButton({
   Name = "Teleport to Random Enemy",
   Callback = function()
       local AllPlayers = Players:GetPlayers()
       local RandomPlayer = AllPlayers[math.random(1, #AllPlayers)]
       
       if RandomPlayer ~= LocalPlayer and RandomPlayer.Character and RandomPlayer.Character:FindFirstChild("HumanoidRootPart") then
           LocalPlayer.Character.HumanoidRootPart.CFrame = RandomPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
           Rayfield:Notify({Title = "TP Success", Content = "Teleported to " .. RandomPlayer.Name, Duration = 2})
       end
   end,
})

MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(Value)
       LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- VISUAL FUNCTIONS
VisualTab:CreateToggle({
   Name = "Enable ESP Boxes",
   CurrentValue = false,
   Flag = "ESP_Toggle",
   Callback = function(Value)
       ESP_Enabled = Value
   end,
})

-- MISC
MiscTab:CreateButton({
   Name = "Join Discord",
   Callback = function()
       setclipboard("https://discord.gg/votre-lien")
   end,
})
