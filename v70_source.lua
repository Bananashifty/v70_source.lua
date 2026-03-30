-- [[ CONFIGURATION ]] --
local CorrectKey = "BANANA_V70_SECRET" -- TA CLÉ ICI
local LootLabsLink = "https://loot-link.com/s?kc5LObQK"
local RawScriptURL = "METS_TON_LIEN_RAW_GITHUB_ICI" -- LE LIEN VERS v70_source.lua

-- [[ INTERFACE DU KEY SYSTEM ]] --
local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local KeyBox = Instance.new("TextBox")
local CheckBtn = Instance.new("TextButton")
local GetKeyBtn = Instance.new("TextButton")
local Status = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui
Main.Name = "BananaKeySystem"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Position = UDim2.new(0.5, -150, 0.5, -100)
Main.Size = UDim2.new(0, 300, 0, 200)
Main.Active = true
Main.Draggable = true

Title.Parent = Main
Title.Text = "BANANA HUB V70 🍌"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22

KeyBox.Parent = Main
KeyBox.PlaceholderText = "Paste Key..."
KeyBox.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyBox.Size = UDim2.new(0.8, 0, 0, 35)
KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)

CheckBtn.Parent = Main
CheckBtn.Text = "VERIFY"
CheckBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
CheckBtn.Size = UDim2.new(0.35, 0, 0, 35)
CheckBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CheckBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

GetKeyBtn.Parent = Main
GetKeyBtn.Text = "GET KEY"
GetKeyBtn.Position = UDim2.new(0.55, 0, 0.6, 0)
GetKeyBtn.Size = UDim2.new(0.35, 0, 0, 35)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

Status.Parent = Main
Status.Text = "System Status: Online"
Status.Position = UDim2.new(0, 0, 0.85, 0)
Status.Size = UDim2.new(1, 0, 0, 20)
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.BackgroundTransparency = 1

-- [[ LOGIQUE ]] --
GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard(LootLabsLink)
    Status.Text = "Link copied! Paste in browser."
end)

CheckBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then
        Status.Text = "✅ KEY VALID! LOADING..."
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        -- On attend un peu pour l'effet "pro"
        task.wait(1)
        
        -- On détruit l'interface de clé
        ScreenGui:Destroy()
        
        -- ON TÉLÉCHARGE ET ON LANCE LE VRAI SCRIPT
        local success, err = pcall(function()
            loadstring(game:HttpGet(RawScriptURL))()
        end)
        
        if not success then
            warn("Erreur lors du chargement du V70: " .. tostring(err))
        end
    else
        Status.Text = "❌ INVALID KEY!"
        Status.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)
