
RegisterNetEvent('boutique:achat')
AddEventHandler('boutique:achat', function(item, categorie, addons)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);
    local myCoins = tonumber(xPlayer.getCoins())
    local message = "Tentative d'Achat (Invalide)"

    if xPlayer ~= nil and xPlayer['loadout'] ~= nil then
        if myCoins ~= nil then
            if myCoins >= tonumber(item.price) then
                if categorie == 'cars' then
                    MySQL.query("INSERT INTO character_vehicles (characterId, plate, vehicle, type, state, label) VALUES (?, ?, ?, ?, ?, ?) ", {xPlayer.characterId, addons.plate, json.encode(addons.vehicle), 'boutique', '1', item.label})
                    xPlayer.removeCoins(item.price)
            
                    Wait(1500)
                    
                    xPlayer.showNotification("~p~Boutique~s~, Nouvel Achat ! \nVehicule: ~r~"..item.label.." \n~w~Prix: ~g~"..item.price.." \n~w~Merci !")
                    message = ("Le joueur "..xPlayer.getName().." à acheter dans la boutique: \nCatégorie: Vehicules \nModel: "..item.label.."\nPrix: "..item.price)
                elseif categorie == 'armes_assaults' or 'armes_pistols' or 'armes_snipers' or 'armes_pompes' or 'armes_meles' then
                    if not xPlayer['loadout'].hasWeapon(item.weaponName) then
                        xPlayer['loadout'].addWeapon(item.weaponName, 250)
                        xPlayer.removeCoins(item.price)
                
                        xPlayer.showNotification("~p~Boutique~s~, Nouvel Achat ! \nArme: ~r~"..item.label.." \n~w~Prix: ~g~"..item.price.." \n~w~Merci !")
                        message = ("Le joueur "..xPlayer.getName().." à acheter dans la boutique: \nCatégorie: Armes \nModel: "..item.label.."\nPrix: "..item.price)
                    else
                        xPlayer.showNotification("~p~Boutique \n~r~Vous avez déjà cette Arme !")
                    end
                end
            else
                xPlayer.showNotification("~r~Vous n'avez pas asser de Coins !~s~")
            end
        else
            print("^1Erreur BOUTIQUE: COINS INVALIDE "..xPlayer.source.."^0")
        end
    else
        print("^1Erreur BOUTIQUE 2: xPlayer is nil "..xPlayer.source.."^0")
    end

    Wait(5000)

    exports['Logs']:createLog({EmbedMessage = (message), player_id = xPlayer.source, channel = 'boutique'})
end)

RegisterNetEvent('boutique:buyCaisse')
AddEventHandler('boutique:buyCaisse', function(price, caisse, veh)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);
    local myCoins = tonumber(xPlayer.getCoins())
    local message = "Tentative d'Achat Caisse (Invalide)"

    if xPlayer ~= nil and xPlayer['loadout'] ~= nil then
        if myCoins ~= nil then
            if myCoins >= price then
                if caisse.type == 'vehicle' then
                    xPlayer.removeCoins(tonumber(price))
                    MySQL.query("INSERT INTO character_vehicles (characterId, plate, vehicle, type, state) VALUES (?, ?, ?, ?, ?) ", {xPlayer.characterId, veh.plate, json.encode(veh), 'boutique', '1'})
                    xPlayer.showNotification("Vous avez gagner ~g~"..caisse.label.."~s~ !")
                    message = ("Le joueur "..xPlayer.getName().." à gagner dans une caisse: \nCatégorie: Vehicules \nModel: "..caisse.label.."\nPrix: "..price)
                elseif caisse.type == 'weapon' then
                    if not xPlayer['loadout'].hasWeapon(caisse.name) then
                        xPlayer.removeCoins(tonumber(price))
                        xPlayer['loadout'].addWeapon(caisse.name, 250)
                        xPlayer.showNotification("Vous avez gagner ~g~"..caisse.label.."~s~ !")
                        message = ("Le joueur "..xPlayer.getName().." à gagner dans une caisse: \nCatégorie: Armes \nModel: "..caisse.label.."\nPrix: "..price)
                    else
                        xPlayer.showNotification("~r~Vous avez déjà cette arme ! Les coins n'ont donc pas été débité.")
                    end
                elseif caisse.type == 'money' then
                    xPlayer.removeCoins(tonumber(price))
                    xPlayer['accounts'].addAccountMoney('bank', tonumber(caisse.name))
                    xPlayer.showNotification("Vous avez gagner ~g~"..caisse.label.."$~s !")
                    message = ("Le joueur "..xPlayer.getName().." à gagner dans une caisse: \nCatégorie: Argent \nSomme: "..caisse.label.."\nPrix: "..price)
                elseif caisse.type == 'coins' then
                    xPlayer.removeCoins(tonumber(price))
                    xPlayer.addCoins(tonumber(caisse.name))
                    xPlayer.showNotification("Vous avez gagner ~g~"..caisse.label.."Coins~s~ !")
                    message = ("Le joueur "..xPlayer.getName().." à gagner dans une caisse: \nCatégorie: Coins \nSomme: "..caisse.label.."\nPrix: "..price)
                end
            else
                xPlayer.showNotification("~r~Vous n'avez pas asser de Coins !~s~")
            end
        else
            print("^1Erreur BOUTIQUE: Coins Invalide "..xPlayer.source.."^0")
        end
    else
        print("^1Erreur BOUTIQUE: xPlayer is nil "..xPlayer.source.."^0")
    end

    Wait(5000)

    exports['Logs']:createLog({EmbedMessage = (message), player_id = xPlayer.source, channel = 'boutique'})
end)

RegisterNetEvent('boutique:giveConsolation')
AddEventHandler('boutique:giveConsolation', function(coins)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    xPlayer.removeCoins(tonumber(coins/2))
    xPlayer.showNotification("Vous n'avez rien gagner ! Voici ~p~"..(coins/2).." Coins~s~ en guise de consolation !")
    exports['Logs']:createLog({EmbedMessage = "Le joueur "..xPlayer.getName().." à n'a rien gagner dans une caisse: il a reçu "..(coins/2).." coins en guise de compensation !", player_id = xPlayer.source, channel = 'boutique'})
end)

Framework.RegisterCommand('givecoins', { 'owner' }, function(xPlayer, args, showError)
    if not xPlayer then
        args.playerId.addCoins(args.coins)

        exports['Logs']:createLog({EmbedMessage = ("GIVE de **%s** Coins à:"):format(args.coins), player_id = args.playerId.source, channel = 'adminCommands'})
    else
        xPlayer.showNotification("~r~Cette commande ne peut être exécuter uniquement depuis la console !")
    end
end, true, {help = "Give des Coins", validate = true, arguments = {
	{name = 'playerId', help = "ID du Joueur", type = 'player'},
    {name = 'coins', help = "Nombre de Coins", type = 'number'}
}})

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        Wait(5000)
        local xPlayers = Framework.GetExtendedPlayers()

        for _, xPlayer in pairs(xPlayers) do
            TriggerClientEvent('boutique:update', xPlayer.source, xPlayer)
        end
    end
end)

local CASE_TYPES = {
    {type = 'money', chance = 0.65},
    {type = 'weapon', chance = 0.15},
    {type = 'coins', chance = 0.20}
}

local REWARDS = {
    money = {
        {name = '20000', label = '20,000', price = '0', weight = 50},
        {name = '40000', label = '40,000', price = '0', weight = 30},
        {name = '60000', label = '60,000', price = '0', weight = 20}
    },
    weapon = {
        {name = 'WEAPON_KERTUS', label = 'pistolet kertus', price = '0', weight = 10},
        {name = 'WEAPON_PISTOLPOKA', label = 'Pistolet poka', price = '0', weight = 10},
        {name = 'WEAPON_CZ75', label = 'CZ75', price = '2000', weight = 10},
        {name = 'WEAPON_SCORPION', label = 'Revolver Scorpion', price = '2000', weight = 10},
        {name = 'WEAPON_FN502', label = 'FN502', price = '2000', weight = 10},
        {name = 'WEAPON_HFAP', label = 'HFAP', price = '2000', weight = 10},
        {name = 'WEAPON_KNR', label = 'KNR', price = '2000', weight = 10},
        {name = 'WEAPON_PL14', label = 'PL14', price = '2000', weight = 10},
        {name = 'WEAPON_PISTOLWHITE', label = 'Pistolet White', price = '2000', weight = 5},
        {name = 'WEAPON_PISTOLBLACK', label = 'Pistolet Black', price = '2000', weight = 5},
        {name = 'WEAPON_PISTOLCALIBRE50', label = 'Pistolet Custom 50', price = '2000', weight = 5},
        {name = 'WEAPON_KERTUS', label = 'Kertus', price = '2000', weight = 5}
    },
    coins = {
        {name = '25', label = '25', price = '0', weight = 50},
        {name = '50', label = '50', price = '0', weight = 35},
        {name = '75', label = '75', price = '0', weight = 15}
    }
}

local function getRandomType()
    local random = math.random()
    local cumulativeChance = 0

    for _, typeData in ipairs(CASE_TYPES) do
        cumulativeChance = cumulativeChance + typeData.chance
        if random <= cumulativeChance then
            return typeData.type
        end
    end

    return CASE_TYPES[1].type
end

local function getAvailableWeapons(xPlayer)
    local availableWeapons = {}
    for _, weapon in ipairs(REWARDS.weapon) do
        if not xPlayer['loadout'].hasWeapon(weapon.name) then
            table.insert(availableWeapons, weapon)
        end
    end
    return availableWeapons
end

local function getRandomReward(rewardType, xPlayer)
    if rewardType == 'weapon' then
        local availableWeapons = getAvailableWeapons(xPlayer)
        if #availableWeapons == 0 then
            local newType = math.random() < 0.5 and 'money' or 'coins'
            return getRandomReward(newType, xPlayer), newType
        end

        local totalWeight = 0
        for _, weapon in ipairs(availableWeapons) do
            totalWeight = totalWeight + weapon.weight
        end

        local random = math.random() * totalWeight
        local currentWeight = 0

        for _, weapon in ipairs(availableWeapons) do
            currentWeight = currentWeight + weapon.weight
            if random <= currentWeight then
                return weapon, rewardType
            end
        end

        return availableWeapons[1], rewardType
    end

    local rewards = REWARDS[rewardType]
    local totalWeight = 0

    for _, reward in ipairs(rewards) do
        totalWeight = totalWeight + reward.weight
    end

    local random = math.random() * totalWeight
    local currentWeight = 0

    for _, reward in ipairs(rewards) do
        currentWeight = currentWeight + reward.weight
        if random <= currentWeight then
            return reward, rewardType
        end
    end

    return rewards[1], rewardType
end

Framework.ITEMS:RegisterUsableItem('caisse_adistra', function(src)
    local xPlayer = Framework.GetPlayerFromId(src)
    xPlayer['inventory'].removeInventoryItem('caisse_adistra', 1)

    local selectedType = getRandomType()
    local reward, finalType = getRandomReward(selectedType, xPlayer)

    local caisse = {
        type = finalType,
        name = reward.name,
        label = reward.label
    }
    local price = reward.price
    
    TriggerClientEvent('caisse:use', src)
    print("caisse:use - Type:", caisse.type, "Reward:", caisse.label)

    if caisse.type == 'weapon' then
        xPlayer['loadout'].addWeapon(caisse.name, 250)
        xPlayer.showNotification("Vous avez gagner ~g~"..caisse.label.."~s~ !")
    elseif caisse.type == 'money' then
        xPlayer['accounts'].addAccountMoney('bank', tonumber(caisse.name))
        xPlayer.showNotification("Vous avez gagner ~g~"..caisse.label.."$~s~ !")
    elseif caisse.type == 'coins' then
        xPlayer.addCoins(tonumber(caisse.name))
        xPlayer.showNotification("Vous avez gagner ~g~"..caisse.label.." Coins~s~ !")
    end
end)

RegisterCommand("giveallcase", function(source, args, rawCommand)
    if source == 0 then
        for k,v in pairs(Framework.GetExtendedPlayers()) do
            if v['inventory'] ~= nil then
                v['inventory'].addInventoryItem('caisse_adistra', 1)
            end
        end
    else
        DropPlayer(source, "Vous n'avez pas la permission d'utiliser cette commande.")
    end
end)