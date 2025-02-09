Boutique = {}
Boutique.myCoins = 0;

RegisterCommand('boutique:open', function()
    local plyPed = PlayerPedId()
    if not IsPedInAnyVehicle(plyPed) then
        if Framework ~= nil then
            if ZoneSafe.isInZone or Framework.PlayerData.jobs['job'].name == 'usarmy' or Framework.PlayerData.jobs['job'].name == 'police' or Framework.PlayerData.jobs['job'].name == 'sheriff' or Framework.PlayerData.jobs['job'].name == 'sheriffpaleto' or Framework.PlayerData.jobs['job'].name == 'gouvernement' or Framework.PlayerData.jobs['job'].name == 'hookah' or Framework.PlayerData.jobs['job'].name == 'bahama' or Framework.PlayerData.jobs['job'].name == '77club' or Framework.PlayerData.jobs['job'].name == 'unicorn' then
                if not IsPlayerDead(PlayerId()) then
                    Boutique:OpenBoutique()
                else
                    Framework.ShowNotification("~r~Vous ne pouvez pas acceder à la boutique en étant mort !")
                end
            else
                Framework.ShowNotification("~r~Vous devez être en Zone Safe pour acceder à la boutique !")
            end
        end
    else
        Framework.ShowNotification("~r~Vous ne pouvez pas acceder à la boutique dans un véhicule !")
    end
end)

RegisterKeyMapping('boutique:open', "Ouvrir la boutique", 'keyboard', 'F1')

RegisterNetEvent('boutique:update')
AddEventHandler('boutique:update', function(xPlayer)
    Boutique.myCoins = Framework.PlayerData.coins
end)

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function()
    Boutique.myCoins = Framework.PlayerData.coins
end)

RegisterNetEvent('framework:setCoins')
AddEventHandler('framework:setCoins', function(coins)
	Framework.PlayerData.coins = coins;
    Boutique.myCoins = coins;
end)