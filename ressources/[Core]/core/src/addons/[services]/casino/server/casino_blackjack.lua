function PlayBlackjack(playerId, betAmount)
    if not RemoveBalance(playerId, betAmount) then
        return "Solde insuffisant", 0
    end

    local playerHand = math.random(16, 21)
    local dealerHand = math.random(16, 21)

    if playerHand > dealerHand then
        local winAmount = betAmount * 2
        AddBalance(playerId, winAmount)
        return "Gagné", winAmount
    elseif playerHand == dealerHand then
        AddBalance(playerId, betAmount)
        return "Égalité", betAmount
    else
        return "Perdu", 0
    end
end
