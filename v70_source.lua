-- [[ BANANA HUB V70 - LOADER DIRECT ]] --
local RawURL = "https://raw.githubusercontent.com/Bananashifty/v70_source.lua/main/v70_source.lua"

print("--- BANANA HUB V70 ---")
print("Tentative de chargement direct...")

-- Fonction de chargement sécurisée
local success, code = pcall(function()
    return game:HttpGet(RawURL)
end)

if success and code ~= "" and code ~= nil then
    print("✅ Code récupéré avec succès !")
    
    local func, err = loadstring(code)
    if func then
        print("🚀 Lancement du script...")
        func() -- EXÉCUTE TON V70 ROUGE
    else
        warn("❌ Erreur de syntaxe dans le fichier GitHub : " .. tostring(err))
    end
else
    warn("❌ Impossible de lire le fichier sur GitHub.")
    warn("Vérifie que ton dépôt est bien PUBLIC et que le lien est correct.")
end
