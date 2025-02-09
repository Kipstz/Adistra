function PlayRoulette(playerId, betAmount, betType, betValue)
    if not RemoveBalance(playerId, betAmount) then 
        return "Solde insuffisant", 0
    end

    local winningNumber = math.random(0, 36)
    local color = winningNumber % 2 == 0 and "rouge" or "noir"

    local winAmount = 0
    if betType == "number" and betValue == winningNumber then 
        winAmount = betAmount * 35
    elseif betType == "color" and betValue == color then
        winAmount = betAmount * 2
    end 

    if winAmount > 0 then 
        AddBalance(playerId, winAmount)
        return "Gagné", winAmount
    else 
        return "Perdu", 0
    end 
end 