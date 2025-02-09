local deck = {2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11} -- 11 représente l'As

function DrawCard()
    return deck[math.random(#deck)]
end

function CalculateHandValue(hand)
    local value = 0
    local aces = 0

    for _, card in ipairs(hand) do
        value = value + card
        if card == 11 then aces = aces + 1 end
    end

    -- Ajustement pour les As
    while value > 21 and aces > 0 do
        value = value - 10
        aces = aces - 1
    end

    return value
end

function PlayBlackjack(playerId, betAmount)
    if not RemoveBalance(playerId, betAmount) then
        return "Solde insuffisant", 0
    end

    local playerHand = {DrawCard(), DrawCard()}
    local dealerHand = {DrawCard(), DrawCard()}

    local playerValue = CalculateHandValue(playerHand)
    local dealerValue = CalculateHandValue(dealerHand)

    -- Le joueur peut tirer une carte ou rester
    while playerValue < 21 do
        -- Attendre une action du joueur
        local action = GetPlayerAction() -- Fonction fictive à définir pour obtenir l'action (ex. "hit" pour tirer une carte, "stand" pour rester)

        if action == "hit" then
            table.insert(playerHand, DrawCard())
            playerValue = CalculateHandValue(playerHand)
        elseif action == "stand" then
            break
        end
    end

    -- Tour du croupier
    while dealerValue < 17 do
        table.insert(dealerHand, DrawCard())
        dealerValue = CalculateHandValue(dealerHand)
    end

    -- Déterminer le résultat
    if playerValue > 21 then
        return "Perdu", 0 -- Le joueur perd
    elseif dealerValue > 21 or playerValue > dealerValue then
        local winAmount = betAmount * 2
        AddBalance(playerId, winAmount)
        return "Gagné", winAmount
    elseif playerValue == dealerValue then
        AddBalance(playerId, betAmount)
        return "Égalité", betAmount
    else
        return "Perdu", 0
    end
end
