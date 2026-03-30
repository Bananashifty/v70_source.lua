local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🍌 BANANA HUB V72 | RIVALS",
   LoadingTitle = "Banana Hub Loading...",
   LoadingSubtitle = "Best Cheat for Rivals",
   ConfigurationSaving = { Enabled = true, Folder = "BananaHub" }
})

local MainTab = Window:CreateTab("Combat", 4483362458)

MainTab:CreateSection("Main Cheats")

MainTab:CreateButton({
   Name = "Kill All (TP-Kill)",
   Callback = function()
       -- Ton code TP-Kill ici
       print("Kill All Activated")
   end,
})

MainTab:CreateSlider({
   Name = "Aimbot FOV",
   Range = {0, 500},
   Increment = 10,
   Suffix = "Degrees",
   CurrentValue = 100,
   Flag = "Slider1",
   Callback = function(Value)
       -- Ton code FOV ici
   end,
})

local VisualTab = Window:CreateTab("Visuals", 4483362458)

VisualTab:CreateToggle({
   Name = "Enable ESP (Boxes)",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
       -- Ton code ESP ici
   end,
})

local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateButton({
   Name = "Join Discord Support",
   Callback = function()
       setclipboard("https://discord.gg/votre-invite") -- Mets ton lien Discord ici
       Rayfield:Notify({
           Title = "Link Copied",
           Content = "Discord link has been copied to clipboard!",
           Duration = 5
       })
   end,
})

Rayfield:Notify({
   Title = "Banana Hub Loaded!",
   Content = "Enjoy cheating on Rivals!",
   Duration = 5,
   Image = 4483362458,
})
