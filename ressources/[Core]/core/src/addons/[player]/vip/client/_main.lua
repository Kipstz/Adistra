
Vip = {}

RegisterNetEvent('vip:recupBonusMoney')
AddEventHandler('vip:recupBonusMoney', function(vip)
    Vip.ChecksIndexs.MoneyCheck = true;
end)

RegisterNetEvent('vip:recupBonusCoins')
AddEventHandler('vip:recupBonusCoins', function(vip)
    Vip.ChecksIndexs.CoinsCheck = true;
end)

RegisterCommand('vip', function()
    local vip = Vip:getVip()
    Wait(100)
    if vip then
        if not IsPlayerDead(PlayerId()) then
            Vip:OpenVIP(vip)
        else
            Framework.ShowNotification("~r~Vous ne pouvez pas ouvrir le menu VIP en étant mort !~s~")
        end
    else
       Framework.ShowNotification("~r~Vous n'êtes pas VIP !~s~")
    end
end)

-- RegisterKeyMapping('vip:open', "Ouvrir le VIP", 'keyboard', 'F1')