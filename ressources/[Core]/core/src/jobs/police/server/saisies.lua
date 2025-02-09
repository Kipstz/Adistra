
local WeaponsBoutique = {
	'WEAPON_KATANA', 
	'WEAPON_CARBINERIFLE2', 'WEAPON_CARBINERIFLE3', 'WEAPON_CARBINERIFLE4', 'WEAPON_CARBINERIFLE5', 'WEAPON_CARBINERIFLE6', 'WEAPON_CARBINERIFLE7', 
    'WEAPON_ANIMEM4', 
	'WEAPON_SCORPION', 
	'WEAPON_RGXOPERATOR',
	'WEAPON_SPECIALCARBINE2_MK2',
	'WEAPON_KNIFE2',
	'WEAPON_SPIKEDCLUB',
	'WEAPON_KATANA2',
	'WEAPON_JOSM4A4CH',
	'WEAPON_SPECIALCARBINE2', 'WEAPON_SPECIALCARBINE3',
	'WEAPON_MARKSMANRIFLE2',

	-- WEAPONS PACK --
	'WEAPON_A15RC',
	'WEAPON_NEVA',
	'WEAPON_IAR',
	'WEAPON_M133',
	'WEAPON_JRBAK',
	'WEAPON_FAMASU1',
	'WEAPON_GRAU',
	'WEAPON_AK47S',
	'WEAPON_SR47',
	'WEAPON_AK4K',
	'WEAPON_AKMKH',
	'WEAPON_BULLDOG',
	'WEAPON_CASR',
	'WEAPON_DRH',
	'WEAPON_FMR',
	'WEAPON_FN42',
	'WEAPON_GALILAR',
	'WEAPON_M16A3',
	'WEAPON_SLR15',
	'WEAPON_ARC15',
	'WEAPON_ARS',
	'WEAPON_HOWA_2',
	'WEAPON_MZA',
	'WEAPON_SAFAK',
	'WEAPON_SAR',
	'WEAPON_SFAK',
	'WEAPON_ARMA1',
	'WEAPON_G36',
	'WEAPON_LR300',
	'WEAPON_M416P',
	'WEAPON_NANITE',
	'WEAPON_SF2',
	'WEAPON_SFRIFLE',
	'WEAPON_CFS',
	'WEAPON_AK47',
	'WEAPON_AUG',
	'WEAPON_SUNDA',
	'WEAPON_G3_2',
	'WEAPON_GROZA',
	'WEAPON_ACR',
	'WEAPON_ACWR',
	'WEAPON_ANARCHY',
	'WEAPON_FAR',
	'WEAPON_GK47',
	'WEAPON_TAR21',
	'WEAPON_AKPU',
	'WEAPON_AN94_2',
	'WEAPON_ART64',
	'WEAPON_GYS',
	'WEAPON_SM237',
	'WEAPON_SS2_2',
	'WEAPON_SCARSC',
	'WEAPON_VA030',
	'WEAPON_AR121',
	'WEAPON_LGWII',
	'WEAPON_AR727',
	'WEAPON_ANR15',
	'WEAPON_DKS501',
	'WEAPON_SCIFW',
	'WEAPON_SSR56',
	'WEAPON_AKBG',
	'WEAPON_ANM4',
	'WEAPON_GVANDAL',
	'WEAPON_L85',
	'WEAPON_LIMPID',
	'WEAPON_TRUVELO',
	'WEAPON_SB4S',
	'WEAPON_H2SMG',
	'WEAPON_HFSMG',
	'WEAPON_MS32',
	'WEAPON_SARB',
	'WEAPON_UE4',
	'WEAPON_UZI',
	'WEAPON_IDW',
	'WEAPON_HEAVYSMG',
	'WEAPON_SMG9',
	'WEAPON_R99',
	'WEAPON_SB181',
	'WEAPON_UMP45',
	'WEAPON_SMG1311',
	'WEAPON_AUTOSMG',
	'WEAPON_MX4',
	'WEAPON_PASMG',
	'WEAPON_FN502',
	'WEAPON_HFAP',
	'WEAPON_KNR',
	'WEAPON_CZ75',
	'WEAPON_PL14',
	'WEAPON_AWP',
	'WEAPON_DITDG',
	'WEAPON_M82',
	'WEAPON_M90S',
	'WEAPON_DCS',
	'WEAPON_OWSHOTGUN',
	'WEAPON_BENELLIM4',
	'WEAPON_BOOK',
	'WEAPON_BRICK',
	'WEAPON_ENERGYKNIFE',
	'WEAPON_HIGHBOOT',
	'WEAPON_KARAMBIT',
	
	'WEAPON_PISTOLWHITE',
	'WEAPON_PISTOLBLACK',
	'WEAPON_PISTOLPOKA',
	'WEAPON_PISTOLCALIBRE50',
	'WEAPON_KERTUS',
	'WEAPON_AWPMK02',
	'WEAPON_AKMK01',
	
	'WEAPON_VANDALEX',
	'WEAPON_MENACE',
}

local WeaponisBoutique = function(weaponName)
	for k,v in pairs(WeaponsBoutique) do
		if v == weaponName then
			return true
		end
	end

	return false
end

Framework.RegisterServerCallback("PoliceJob:getSaisiePlayerData", function(src, cb, player)
    local src = src;
    local xPlayer = Framework.GetPlayerFromId(src)
    local playerData = {
        accounts = {},
        inventory = {},
        loadout = {}
    }

    for k,v in pairs(xPlayer['accounts'].accounts) do
        table.insert(playerData.accounts, {
            accountName = v.name,
            accountLabel = v.label,
            money = v.money
        })
    end

    for k,v in pairs(xPlayer['inventory'].inventory) do
        if v.count > 0 and not WeaponisBoutique(v.name) then
            table.insert(playerData.inventory, {
                itemName = v.name,
                itemLabel = v.label,
                itemCount = v.count
            })
        end
    end

    for k,v in pairs(xPlayer['loadout'].loadout) do
        if not WeaponisBoutique(v.name) then
            table.insert(playerData.loadout, {
                weaponName = v.name,
                weaponLabel = v.label,
                weaponAmmo = v.ammo
            })
        end
    end

    cb(playerData)
end)

RegisterNetEvent('PoliceJob:addSaisie')
AddEventHandler('PoliceJob:addSaisie', function(saisie)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
    local can = false;

    for k,v in pairs(saisie.items) do
        if tonumber(xPlayer['inventory'].getInventoryItem(v.itemName).count) >= tonumber(v.itemCount) then
            can = true;
            xPlayer['inventory'].removeInventoryItem(v.itemName, tonumber(v.itemCount))
        end
    end

    for k,v in pairs(saisie.weapons) do
        if xPlayer['loadout'].hasWeapon(v.weaponName) then
            can = true;
            xPlayer['loadout'].removeWeapon(v.weaponName)
        end
    end

    if can then
        local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/saisies.json") 
        Saisies = json.decode(loadFile)
    
        if next(Saisies) then
            for k,v in pairs(Saisies) do
                if v.appartenance == saisie.appartenance then
                    xPlayer.showNotification("~r~Une saisie à déjà cette appartenance !~s~")
                    return
                end
            end
        end

        table.insert(Saisies, {
            id = tonumber((#Saisies + 1)),
            appartenance = saisie.appartenance,
            motif = saisie.motif,
            items = saisie.items,
            weapons = saisie.weapons
        })

        SaveResourceFile(GetCurrentResourceName(), "./data/saisies.json", json.encode(Saisies, {indent=true}), -1)
        xPlayer.showNotification("~g~Vous avez ajouté une saisie !~s~")
    else
        xPlayer.showNotification("~r~Saisie Invalide")
    end
end)

Framework.RegisterServerCallback("PoliceJob:getAllSaisies", function(src, cb, player)
    local src = src;
    local xPlayer = Framework.GetPlayerFromId(src)

    local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/saisies.json") 
	Saisies = json.decode(loadFile)

    cb(Saisies)
end)

RegisterNetEvent('PoliceJob:editSaisie')
AddEventHandler('PoliceJob:editSaisie', function(saisie, playerData, playerData2)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
    local found, can = false, false;

    if playerData ~= nil then
        for k,v in pairs(playerData.items) do
            if tonumber(xPlayer['inventory'].getInventoryItem(v.itemName).count) >= tonumber(v.itemCount) then
                can = true;
                xPlayer['inventory'].removeInventoryItem(v.itemName, tonumber(v.itemCount))
            end
        end
    
        for k,v in pairs(playerData.weapons) do
            if xPlayer['loadout'].hasWeapon(v.weaponName) then
                can = true;
                xPlayer['loadout'].removeWeapon(v.weaponName)
            end
        end
        if not next(playerData.items) and not next(playerData.weapons) then can = true; end
    else
        can = true;
    end

    if playerData2 ~= nil then
        for k,v in pairs(playerData2.items) do
            if xPlayer['inventory'].canCarryItem(v.itemName, v.itemCount) then
                can = true;
                xPlayer['inventory'].addInventoryItem(v.itemName, tonumber(v.itemCount))
            end
        end
    
        for k,v in pairs(playerData2.weapons) do
            if not xPlayer['loadout'].hasWeapon(v.weaponName) then
                can = true;
                xPlayer['loadout'].addWeapon(v.weaponName, v.weaponAmmo)
            end
        end
        if not next(playerData.items) and not next(playerData.weapons) then can = true; end
    else
        can = true;
    end

    if can then
        local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/saisies.json") 
        Saisies = json.decode(loadFile)
    
        for k,v in pairs(Saisies) do
            if tonumber(v.id) == tonumber(saisie.id) then
                Saisies[k] = {
                    id = saisie.id,
                    appartenance = saisie.appartenance,
                    motif = saisie.motif,
                    items = saisie.items,
                    weapons = saisie.weapons
                }

                found = true;
            end
        end

        if not found then
            xPlayer.showNotification("~r~Saisie Invalide~s~")
        else
            xPlayer.showNotification("~g~Saisie modifié avec succès !~s~")
        end
        SaveResourceFile(GetCurrentResourceName(), "./data/saisies.json", json.encode(Saisies, {indent=true}), -1)
    else
        xPlayer.showNotification("~r~Saisie Invalide")
    end
end)

RegisterNetEvent('PoliceJob:removeSaisie')
AddEventHandler('PoliceJob:removeSaisie', function(saisie)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
    local found = false;
   
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/saisies.json") 
    Saisies = json.decode(loadFile)
    
    for k,v in pairs(Saisies) do
        if tonumber(v.id) == tonumber(saisie.id) then
            found = true;
            table.remove(Saisies, k) 
        end
    end

    if not found then
        xPlayer.showNotification("~r~Saisie Invalide~s~")
    else
        xPlayer.showNotification("~g~Saisie supprimée avec succès !~s~")
    end
    SaveResourceFile(GetCurrentResourceName(), "./data/saisies.json", json.encode(Saisies, {indent=true}), -1)
end)

RegisterNetEvent('PoliceJob:giveSaisie')
AddEventHandler('PoliceJob:giveSaisie', function(saisie)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
    local canNotifWeight, canNotifHas = false, false

    for k,v in pairs(saisie.items) do
        if xPlayer['inventory'].canCarryItem(v.itemName, v.itemCount) then
            xPlayer['inventory'].addInventoryItem(v.itemName, v.itemCount)
            table.remove(saisie.items, k)
        else
            canNotifWeight = true;
        end
    end

    if canNotifWeight then xPlayer.showNotification("~r~Vous n'avez pas la place de tout prendre !~s~") end

    for k,v in pairs(saisie.weapons) do
        if not xPlayer['loadout'].hasWeapon(v.weaponName) then
            xPlayer['loadout'].addWeapon(v.weaponName, v.weaponAmmo)
            table.remove(saisie.weapons, k)
        else
            canNotifHas = true;
        end
    end

    if canNotifHas then xPlayer.showNotification("~r~Vous avez déjà certaines armes !~s~") end

    local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/saisies.json") 
    Saisies = json.decode(loadFile)
    
    for k,v in pairs(Saisies) do
        if tonumber(v.id) == tonumber(saisie.id) then
            Saisies[k] = {
                id = saisie.id,
                appartenance = saisie.appartenance,
                motif = saisie.motif,
                items = saisie.items,
                weapons = saisie.weapons
            }

            found = true;
        end
    end

    if not found then
        xPlayer.showNotification("~r~Saisie Invalide~s~")
    else
        xPlayer.showNotification("~g~Saisie récupérée avec succès !~s~")
    end
    SaveResourceFile(GetCurrentResourceName(), "./data/saisies.json", json.encode(Saisies, {indent=true}), -1)
end)
