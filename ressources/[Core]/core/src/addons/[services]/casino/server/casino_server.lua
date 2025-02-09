-- Gestion des comptes et vérification des soldes
local PlayersBalance = {}

function InitializePlayerBalance(playerId) end
function AddBalance(playerId, amount) end
function RemoveBalance(playerId, amount) end

-- Calcul des gains de blackjack ou jackpot
RegisterNetEvent('casino:serverPlayBlackjack')
AddEventHandler('casino:serverPlayBlackjack', function(betAmount)
    local playerId = source -- Utiliser l'ID de l'appelant
    local result, winnings = PlayBlackjack(playerId, betAmount) -- Fonction côté serveur
    TriggerClientEvent('casino:clientShowResult', playerId, result, winnings)
end)

-- Calcul du jackpot
RegisterNetEvent('casino:tryJackpot')
AddEventHandler('casino:tryJackpot', function(betAmount)
    local playerId = source
    local winAmount, jackpotWon = TryJackpotWin(playerId, betAmount)
    if jackpotWon then
        TriggerClientEvent('casino:clientJackpotWon', playerId, winAmount)
    end
end)
