
local allEvents = {
    -- PERSONNAL MENU --
    ['personalmenu:Inventory'] = false,
    ['personalmenu:Inventory2'] = false,
    ['personalmenu:use'] = false,

    -- BOUTIQUE --
    ['boutique:achat'] = false,
    ['boutique:buyCaisse'] = false,
    ['boutique:giveConsolation'] = false,
    ['vip:recupBonusMoney'] = false,
    ['vip:recupBonusCoins'] = false,
    
    -- BANQUES --
    ['banques:deposit'] = false,
    ['banques:remove'] = false,
    
    -- PAY/BUY --
    ['shop_clothe:pay'] = false,
    ['shop_barber:pay'] = false,
    ['shop_armurerie:buy'] = false,
    ['shop_armurerie:buyPPA'] = false,
    ['shop_armurerie:buyChargeur'] = false,
    ['shop_accessories:buy'] = false,
    ['keys:buy_key'] = false,
    
    -- SKIN --
    ['skinchanger:save'] = false,
    ["shop_clothe:deleteOutfit"] = false,
    
    -- LÉGAL/FAMR --
    ['farm:startHarvest'] = false,
    ['farm:startTreatment'] = false,
    ['farm:startSell'] = false,
    ['farm:stopHarvest'] = false,
    ['farm:stopTreatment'] = false,
    ['farm:stopSell'] = false,

    ['jobcenter:startCraft'] = false,
    ['jobcenter:startHarvest'] = false,
    ['jobcenter:startTreatment'] = false,
    ['jobcenter:startSell'] = false,
    ['jobcenter:stopHarvest'] = false,
    ['jobcenter:stopTreatment'] = false,
    ['jobcenter:stopCraft'] = false,
    ['jobcenter:stopSell'] = false,
    ['jobcenter:newJob'] = false,
    
    ['VigneronJob:startHarvest'] = false,
    ['VigneronJob:startCraft'] = false,
    ['VigneronJob:startSell'] = false,
    ['VigneronJob:stopHarvest'] = false,
    ['VigneronJob:stopCraft'] = false,
    ['VigneronJob:stopSell'] = false,
    
    ['drugs:startCraft'] = false,
    ['drugs:startHarvest'] = false,
    ['drugs:startSell'] = false,
    ['drugs:stopHarvest'] = false,
    ['drugs:stopCraft'] = false,
    ['drugs:stopSell'] = false,
    
    -- ILLEGAL/BRAQUAGES --
    ['lester:buyItem'] = false,
    ['lester:sellItem'] = false,
    ['gofast:start'] = false,
    ['gofast:reward'] = false,
    ['cayo_vda:buyWeapon'] = false,

    ['rob_fleeca:rewardCash'] = false,
    ['rob_shop:pickUp'] = false,
    ['rob_vangelico:stand'] = false,

    ['heist_pacific:removeitem'] = false,
    ['heist_pacific:updatecheck'] = false,
    ['heist_pacific:policeDoor'] = false,
    ['heist_pacific:moltgate'] = false,
    ['heist_pacific:fixdoor'] = false,
    ['heist_pacific:openvault'] = false,
    ['heist_pacific:startloot'] = false,
    ['heist_pacific:rewardCash'] = false,
    ['heist_pacific:rewardGold'] = false,
    ['heist_pacific:rewardDia'] = false,
    ['heist_pacific:giveidcard'] = false,
    ['heist_pacific:ostimer'] = false,
    ['heist_pacific:gas'] = false,
    ['heist_pacific:ptfx'] = false,
    ['heist_pacific:alarm_s'] = false,

    -- GARAGES/VEHICULES
    ['garages:storeVehicle'] = false,
    ['garages:updateState'] = false,
    ['garages:renameVehicle'] = false,
    ['concess:buyVehicle'] = false,
    ['keys:givekey'] = false,
    ['keys:donner'] = false,
    ['keys:preter'] = false,
    ['assurances:newContrat'] = false,
    ['assurances:vehicleSpawn'] = false,
    ['vehicletrunk:deposit'] = false,
    ['vehicletrunk:remove'] = false,
    ['fuel:pay'] = false,
    ['fuel:buyCan'] = false,
    
    -- OTHERS --
    -- ['3dme:shareDisplay'] = true,
    
    -- ADMIN --
    ['admin_menu:setStaffState'] = false,
    ['admin_menu:msg'] = false,
    ['admin_menu:kick'] = false,
    ['admin_menu:takeReport'] = false,
    ['admin_menu:closeReport'] = false,
    ['admin_menu:revive'] = false,
    ['jail:unjail'] = false,
    ['jail:updateTime'] = false,
    
    -- JOBS --
    ['personalmenu:boss_recrute'] = false,
    ['personalmenu:boss_recrute2'] = false,
    ['factions:depositMoney'] = false,
    ['factions:removeMoney'] = false,
    ['factions:deposit'] = false,
    ['factions:remove'] = false,
    ['factions:promote2'] = false,
    ['factions:virer2'] = false,
    ['billing:sendBill'] = false,
    ['bossManagement:washMoney'] = false,
    ['bossManagement:depositMoney'] = false,
    ['bossManagement:removeMoney'] = false,
    ['bossManagement:promote'] = false,
    ['bossManagement:virer'] = false,
    
    -- ACTIONS PLAYERS ENTITIES ETC --
    ['IllegalMenu:Confiscate'] = false,
    ['IllegalMenu:Ligoter'] = false,
    ['IllegalMenu:Escorter'] = false,
    ['IllegalMenu:MettreSortirVeh'] = false,

    ['IllegalMenu:Confiscate'] = false,
    ['IllegalMenu:Ligoter'] = false,
    ['IllegalMenu:Escorter'] = false,
    ['IllegalMenu:MettreSortirVeh'] = false,
    ['GouvernementJob:Confiscate'] = false,
    ['GouvernementJob:Menoter'] = false,
    ['GouvernementJob:Escorter'] = false,
    ['GouvernementJob:MettreSortirVeh'] = false,
    ['UnicornJob:Confiscate'] = false,
    ['UnicornJob:Menoter'] = false,
    ['UnicornJob:Escorter'] = false,
    ['UnicornJob:MettreSortirVeh'] = false,
    ['UsArmyJob:Confiscate'] = false,
    ['UsArmyJob:Menoter'] = false,
    ['UsArmyJob:Escorter'] = false,
    ['UsArmyJob:MettreSortirVeh'] = false,
    ['AmbulanceJob:Heal'] = false,
    ['AmbulanceJob:MettreSortirVeh'] = false,
    ['CayoEmsJob:MettreSortirVeh'] = false,
    ['PoliceJob:Confiscate'] = false,
    ['PoliceJob:Menoter'] = false,
    ['PoliceJob:Escorter'] = false,
    ['PoliceJob:MettreSortirVeh'] = false,
    ['SheriffJob:Confiscate'] = false,
    ['SheriffJob:Menoter'] = false,
    ['SheriffJob:Escorter'] = false,
    ['SheriffJob:MettreSortirVeh'] = false,
    ['SheriffPaletoJob:Confiscate'] = false,
    ['SheriffPaletoJob:Menoter'] = false,
    ['SheriffPaletoJob:Escorter'] = false,
    ['SheriffPaletoJob:MettreSortirVeh'] = false,
    ['SwatJob:Confiscate'] = false,
    ['SwatJob:Menoter'] = false,
    ['SwatJob:Escorter'] = false,
    ['SwatJob:MettreSortirVeh'] = false,
    ['FibJob:Confiscate'] = false,
    ['FibJob:Menoter'] = false,
    ['FibJob:Escorter'] = false,
    ['FibJob:MettreSortirVeh'] = false,
    
    -- PROPERTY --
    ['property:depositMoney'] = false,
    ['property:depositMoney2'] = false,
    ['property:removeMoney'] = false,
    ['property:removeMoney2'] = false,
    ['property:depositCoffre'] = false,
    ['property:removeCoffre'] = false,

    -- COFFRES --
    ['coffres:deposit'] = false,
    ['coffres:remove'] = false,
    
    -- WEAPONS --
    ['UsArmyJob:AddWeapon'] = false,
    ['UsArmyJob:AddAllWeapons'] = false,
    ['UsArmyJob:RemoveAllWeapons'] = false,
    ['GouvernementJob:AddWeapon'] = false,
    ['GouvernementJob:AddAllWeapons'] = false,
    ['GouvernementJob:RemoveAllWeapons'] = false,
    ['UnicornJob:AddWeapon'] = false,
    ['UnicornJob:AddAllWeapons'] = false,
    ['UnicornJob:RemoveAllWeapons'] = false,
    ['PoliceJob:AddWeapon'] = false,
    ['PoliceJob:AddAllWeapons'] = false,
    ['PoliceJob:RemoveAllWeapons'] = false,
    ['SheriffJob:AddWeapon'] = false,
    ['SheriffJob:AddAllWeapons'] = false,
    ['SheriffJob:RemoveAllWeapons'] = false,
    ['SheriffPaletoJob:AddWeapon'] = false,
    ['SheriffPaletoJob:AddAllWeapons'] = false,
    ['SheriffPaletoJob:RemoveAllWeapons'] = false,
    ['SwatJob:AddWeapon'] = false,
    ['SwatJob:AddAllWeapons'] = false,
    ['SwatJob:RemoveAllWeapons'] = false,
    ['FibJob:AddWeapon'] = false,
    ['FibJob:AddAllWeapons'] = false,
    ['FibJob:RemoveAllWeapons'] = false,

    -- ANNONCES JOBS --
    ['bossManagement:annonce'] = false,
}

local fiveguard_resource = "ac"
AddEventHandler("fg:ExportsLoaded", function(fiveguard_res, res)
if res == "*" or res == GetCurrentResourceName() or res == 'hCore' then
    fiveguard_resource = fiveguard_res
    for event,cross_scripts in pairs(allEvents) do
        local retval, errorText = exports[fiveguard_res]:RegisterSafeEvent(event, {
            ban = true,
            log = true
        }, cross_scripts)
        if not retval then
            print("[fiveguard safe-events] "..errorText)
        end
    end
end
end)