local DailyReward = { base = 100, multiplier = 1.2 } -- La récompense augmente de 20 % chaque jour consécutif
local PlayerDailyReward = {}

-- Récompense quotidienne
function ClaimDailyReward(playerId)
    local lastClaimed = PlayerDailyReward[playerId] or 0
    local currentDay = os.date("*t").yday -- Numéro du jour dans l'année

    if currentDay ~= lastClaimed then
        local reward = DailyReward.base * DailyReward.multiplier ^ (currentDay - lastClaimed)
        AddBalance(playerId, reward)
        PlayerDailyReward[playerId] = currentDay
        TriggerEvent("chat:addMessage", { args = { "🎁 Récompense quotidienne de " .. reward .. " $ récupérée !" } })
    else
        TriggerEvent("chat:addMessage", { args = { "🕒 Vous avez déjà récupéré votre récompense aujourd'hui." } })
    end
end
