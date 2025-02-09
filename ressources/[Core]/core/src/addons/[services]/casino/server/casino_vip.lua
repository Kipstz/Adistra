local VIPLevels = {
    { level = 1, threshold = 5000, reward = 100 }, -- Atteindre 5000 $ pour VIP niveau 1, récompense de 100 $
    { level = 2, threshold = 20000, reward = 500 },
    { level = 3, threshold = 50000, reward = 2000 }
}

local PlayerVIP = {}

-- Fonction pour ajouter au score VIP du joueur
function AddToVIPScore(playerId, amount)
    PlayerVIP[playerId] = (PlayerVIP[playerId] or 0) + amount
    CheckVIPLevel(playerId)
end

-- Vérifier et attribuer le niveau VIP
function CheckVIPLevel(playerId)
    local vipScore = PlayerVIP[playerId] or 0
    for _, vip in ipairs(VIPLevels) do
        if vipScore >= vip.threshold then
            AddBalance(playerId, vip.reward)
            TriggerEvent("chat:addMessage", { args = { "👑 Vous êtes maintenant VIP niveau " .. vip.level .. "! Récompense de " .. vip.reward .. " $" } })
        end
    end
end
