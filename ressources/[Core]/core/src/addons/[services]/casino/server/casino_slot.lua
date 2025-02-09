-- Fonction de jeu de la machine à sous
function PlaySlotMachine(playerId, betAmount)
    if RemoveBalance(playerId, betAmount) then
        local outcome = math.random(1, 100)
        local multiplier = 0

        -- Définir les chances de gains
        if outcome <= 50 then
            multiplier = 0 -- Perte
        elseif outcome <= 75 then
            multiplier = 1 -- Récupère sa mise
        elseif outcome <= 90 then
            multiplier = 2 -- Double la mise
        else
            multiplier = 5 -- Gros gain
        end

        local winAmount = betAmount * multiplier
        AddBalance(playerId, winAmount)
        return winAmount, multiplier
    else
        return 0, 0 -- Solde insuffisant
    end
end
