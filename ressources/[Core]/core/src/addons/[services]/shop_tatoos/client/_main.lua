
TatoosShop = {}

TatoosShop.myTattoos = {}

CreateThread(function()
    for k,v in pairs(Config['shop_tatoos'].localisations) do
        BlipManager:addBlip('tatoo_'..k, v.pos, 75, 1, "Tatoueur", 0.7, true)
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                TatoosShop:OpenMenu(k)
                TatoosShop:changeClothe()
            end}
        })
    end
end)

function TatoosShop:changeClothe()
    Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin, jobSkin)
        if skin.sex == 0 then
            for k,v in pairs(Config["shop_tatoos"]['clothes'].m) do
                TriggerEvent('skinchanger:change', k, v)
            end
        else
            for k,v in pairs(Config["shop_tatoos"]['clothes'].f) do
                TriggerEvent('skinchanger:change', k, v)
            end
        end
    end)
end

function TatoosShop:accessTattoo(sex, hashMale, hashFemale)
    if sex == 0 and hashMale == "" then 
        return false 
    elseif sex == 1 and hashFemale == "" then 
        return false 
    end
    return true
end

function TatoosShop:returnHash(sex, hashMale, hashFemale)
    if sex == 0 then 
        return hashMale 
    elseif sex == 1 then 
        return hashFemale 
    end
end

function TatoosShop:changeTattoo(collection, name)
    local plyPed = PlayerPedId()
    local collectionHash, nameHash = GetHashKey(collection), GetHashKey(name)

    ClearPedDecorations(plyPed)
    TatoosShop:reloadTattoos()
    ApplyPedOverlay(plyPed, collectionHash, nameHash) 
end

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(xPlayer)
    --Wait(5000)
	Framework.TriggerServerCallback('shop_tattoos:getPlayerTattoos', function(tattooList)
		if tattooList then
            local plyPed = PlayerPedId()

			ClearPedDecorations(plyPed)
			for k,v in pairs(tattooList) do
                local collectionHash, nameHash = GetHashKey(v.collection), GetHashKey(v.nameHash)
				SetPedDecoration(plyPed, collectionHash, nameHash)
			end

			TatoosShop.myTattoos = tattooList
		end
	end)
end)

function TatoosShop:reloadTattoos()
    local plyPed = PlayerPedId()

    if next(TatoosShop.myTattoos) then
        ClearPedDecorations(plyPed)
        for k,v in pairs(TatoosShop.myTattoos) do
            local collectionHash, nameHash = GetHashKey(v.collection), GetHashKey(v.nameHash)
            SetPedDecoration(plyPed, collectionHash, nameHash)
        end
    end
end