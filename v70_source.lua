-- [[ BANANA RIVALS V72 - V70 CLASSIC EDITION ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

_G.Aimbot = true
_G.AuraESP = true
_G.EnableSpeed = true
_G.ShowFOV = true
_G.Noclip = true
_G.Fly = false
_G.SpeedPower = 2.8
_G.FOV = 180
local HoldingClick = false

local Circle = Drawing.new("Circle")
Circle.Thickness = 1.5
Circle.Color = Color3.fromRGB(255, 255, 255)
Circle.Visible = true

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
        if target then
            LocalPlayer.Character:PivotTo(target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2))
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.02)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end)
end

local Gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 220, 0, 480)
Main.Position = UDim2.new(0.05, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true

local function CreateToggle(txt, y, globalVar)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    local function Update()
        btn.BackgroundColor3 = _G[globalVar] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        btn.Text = txt .. (_G[globalVar] and " : ON" or " : OFF")
    end
    btn.MouseButton1Click:Connect(function() _G[globalVar] = not _G[globalVar] Update() end)
    Update()
end

CreateToggle("AIMBOT (CLIC DROIT)", 40, "Aimbot")
CreateToggle("AURA ESP", 75, "AuraESP")
CreateToggle("SPEED HACK", 110, "EnableSpeed")
CreateToggle("NOCLIP", 145, "Noclip")
CreateToggle("VISIBILITE FOV", 180, "ShowFOV")

local bKill = Instance.new("TextButton", Main)
bKill.Size = UDim2.new(0, 200, 0, 45)
bKill.Position = UDim2.new(0, 10, 0, 230)
bKill.Text = "TP + AUTO-SHOT (T)"
bKill.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
bKill.MouseButton1Click:Connect(DoSilentKill)

RunService.RenderStepped:Connect(function()
    Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    Circle.Radius = _G.FOV Circle.Visible = _G.ShowFOV
    if _G.EnableSpeed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        if hum.MoveDirection.Magnitude > 0 then
            LocalPlayer.Character.HumanoidRootPart.CFrame += (hum.MoveDirection * (_G.SpeedPower / 10))
        end
    end
end)

UserInputService.InputBegan:Connect(function(i, p)
    if p then return end
    if i.KeyCode == Enum.KeyCode.T then DoSilentKill() end
    if i.UserInputType == Enum.UserInputType.MouseButton2 then HoldingClick = true end
end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then HoldingClick = false end end)
