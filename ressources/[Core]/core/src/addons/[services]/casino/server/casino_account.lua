local PlayersBalance = {}

-- Fonction d'initialisation du solde du joueur
function InitializePlayerBalance(playerId)
    if PlayersBalance[playerId] == nil then
        PlayersBalance[playerId] = Config.InitialBalance
    end
end

-- Fonction pour vérifier le solde du joueur
function GetPlayerBalance(playerId)
    return PlayersBalance[playerId] or 0
end

-- Fonction pour ajouter des gains
function AddBalance(playerId, amount)
    PlayersBalance[playerId] = (PlayersBalance[playerId] or 0) + amount
end

-- Fonction pour déduire des pertes
function RemoveBalance(playerId, amount)
    if (PlayersBalance[playerId] or 0) >= amount then
        PlayersBalance[playerId] = PlayersBalance[playerId] - amount
        return true
    else
        return false -- Solde insuffisant
    end
end
