local Jackpot = 10000 -- Montant de départ pour le jackpot

-- Fonction pour augmenter le jackpot
function IncreaseJackpot(amount)
    Jackpot = Jackpot + amount * 0.05 -- 5 % des mises vont au jackpot
end

-- Fonction pour tenter de gagner le jackpot
function TryJackpotWin(playerId, betAmount)
    local chance = math.random(1, 10000) -- Un nombre de 1 à 10 000
    if chance == 1 then
        local winAmount = Jackpot
        AddBalance(playerId, winAmount)
        Jackpot = 10000 -- Réinitialiser le jackpot
        return winAmount, true
    else
        IncreaseJackpot(betAmount)
        return 0, false
    end
end

-- Appel de la fonction lors d'une mise
function PlaceBetWithJackpot(playerId, betAmount)
    RemoveBalance(playerId, betAmount)
    local winAmount, jackpotWon = TryJackpotWin(playerId, betAmount)
    if jackpotWon then
        TriggerEvent("chat:addMessage", { args = { "🎉 Félicitations ! Vous avez remporté le jackpot de " .. winAmount .. " $" } })
    end
end
