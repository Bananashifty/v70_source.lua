-- [[ BANANA RIVALS V72 - SILENT EXECUTION (TP-ONLY AUTOSHOOT) ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- CONFIGS
_G.Aimbot = true
_G.MagicHit = true
_G.EnableSpeed = true
_G.AuraESP = true
_G.ShowFOV = true
_G.Noclip = true
_G.Fly = false
_G.SpeedPower = 2.8
_G.FOV = 180
_G.Sensitivity = 1.0
local HoldingClick = false

-- 1. CERCLE FOV
local Circle = Drawing.new("Circle")
Circle.Thickness = 1.5
Circle.Color = Color3.fromRGB(255, 255, 255)
Circle.Visible = true

-- 2. LOGIQUE PHYSIQUE
RunService.Stepped:Connect(function()
    if _G.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

local function HandleFly()
    if _G.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        task.spawn(function()
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            bv.Velocity = Vector3.new(0, 0, 0)
            while _G.Fly do
                bv.Velocity = Camera.CFrame.LookVector * (_G.SpeedPower * 20)
                task.wait()
            end
            bv:Destroy()
        end)
    end
end

-- 3. LA MACRO T (TP + SEUL MOMENT OÙ ÇA TIRE TOUT SEUL)
local function DoSilentKill()
    pcall(function()
        local target = nil
        local distMin = math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local d = (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < distMin then distMin = d target = v end
            end
        end
        
        if target and LocalPlayer.Character then
            -- TP pile sur lui
            LocalPlayer.Character:PivotTo(target.Character.HumanoidRootPart.CFrame)
            -- Lock tête
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            
            -- AUTOSHOOT UNIQUE (Uniquement ici !)
            task.wait(0.06) 
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.02)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end)
end

-- 4. INTERFACE
local Gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 220, 0, 560)
Main.Position = UDim2.new(0.05, 0, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true

local function CreateToggle(txt, y, globalVar, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    local function Update()
        btn.BackgroundColor3 = _G[globalVar] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        btn.Text = txt .. (_G[globalVar] and " : ON" or " : OFF")
    end
    btn.MouseButton1Click:Connect(function() _G[globalVar] = not _G[globalVar] Update() if callback then callback() end end)
    Update()
end

local function CreateAdjuster(txt, y, globalVar, step)
    local label = Instance.new("TextLabel", Main)
    label.Size = UDim2.new(0, 100, 0, 30)
    label.Position = UDim2.new(0, 10, 0, y)
    label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSansBold
    local function Update() label.Text = txt .. " : " .. string.format("%.1f", _G[globalVar]) end
    local p = Instance.new("TextButton", Main)
    p.Size = UDim2.new(0, 45, 0, 30) p.Position = UDim2.new(0, 115, 0, y) p.Text = "+"
    p.BackgroundColor3 = Color3.fromRGB(50, 50, 50) p.TextColor3 = Color3.new(1, 1, 1)
    p.MouseButton1Click:Connect(function() _G[globalVar] = _G[globalVar] + step Update() end)
    local m = Instance.new("TextButton", Main)
    m.Size = UDim2.new(0, 45, 0, 30) m.Position = UDim2.new(0, 165, 0, y) m.Text = "-"
    m.BackgroundColor3 = Color3.fromRGB(50, 50, 50) m.TextColor3 = Color3.new(1, 1, 1)
    m.MouseButton1Click:Connect(function() _G[globalVar] = math.max(0, _G[globalVar] - step) Update() end)
    Update()
end

CreateToggle("AIMBOT (CLIC DROIT)", 40, "Aimbot")
CreateToggle("MAGIC HIT REG", 75, "MagicHit")
CreateToggle("AURA ESP", 110, "AuraESP")
CreateToggle("SPEED HACK", 145, "EnableSpeed")
CreateToggle("NOCLIP (ANTI-MUR)", 180, "Noclip")
CreateToggle("FLY MODE (F)", 215, "Fly", HandleFly)
CreateToggle("VISIBILITÉ FOV", 250, "ShowFOV")
CreateAdjuster("FOV SIZE", 290, "FOV", 20)
CreateAdjuster("SPEED MULTI", 325, "SpeedPower", 0.2)

local bKill = Instance.new("TextButton", Main)
bKill.Size = UDim2.new(0, 200, 0, 45)
bKill.Position = UDim2.new(0, 10, 0, 380)
bKill.Text = "TP + AUTO-SHOT (T)"
bKill.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
bKill.TextColor3 = Color3.new(0, 0, 0)
bKill.Font = Enum.Font.SourceSansBold
bKill.MouseButton1Click:Connect(DoSilentKill)

local bExit = Instance.new("TextButton", Main)
bExit.Size = UDim2.new(0, 200, 0, 35)
bExit.Position = UDim2.new(0, 10, 0, 435)
bExit.Text = "QUITTER"
bExit.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
bExit.TextColor3 = Color3.new(1, 1, 1)
bExit.MouseButton1Click:Connect(function() Gui:Destroy() Circle:Remove() end)

-- 5. RUNTIME (AIMBOT MANUEL)
RunService.RenderStepped:Connect(function()
    Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    Circle.Radius = _G.FOV Circle.Visible = _G.ShowFOV
    
    if _G.EnableSpeed and not _G.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then
            LocalPlayer.Character.HumanoidRootPart.CFrame += (hum.MoveDirection * (_G.SpeedPower / 10))
        end
    end

    -- ICI : Aimbot SANS autoshoot
    if _G.Aimbot and HoldingClick then
        local t = nil local d = _G.FOV
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local p, on = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if on then
                    local mag = (Vector2.new(p.X, p.Y) - Circle.Position).Magnitude
                    if mag < d then d = mag t = v end
                end
            end
        end
        if t then
            local p = Camera:WorldToViewportPoint(t.Character.Head.Position)
            mousemoverel((p.X - Circle.Position.X) * _G.Sensitivity, (p.Y - Circle.Position.Y) * _G.Sensitivity)
        end
    end
end)

-- 6. ESP
task.spawn(function()
    while task.wait(0.5) do
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hl = plr.Character:FindFirstChild("B_Aura")
                if _G.AuraESP then
                    if not hl then
                        hl = Instance.new("Highlight", plr.Character)
                        hl.Name = "B_Aura" hl.FillColor = Color3.new(1, 0, 0)
                    end
                else if hl then hl:Destroy() end end
            end
        end
    end
end)

-- INPUTS
UserInputService.InputBegan:Connect(function(i, p)
    if p then return end
    if i.KeyCode == Enum.KeyCode.T then DoSilentKill() end
    if i.KeyCode == Enum.KeyCode.N then _G.Noclip = not _G.Noclip end
    if i.KeyCode == Enum.KeyCode.F then _G.Fly = not _G.Fly HandleFly() end
    if i.UserInputType == Enum.UserInputType.MouseButton2 then HoldingClick = true end
end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then HoldingClick = false end end)
