
local bypassJob = Config["radar"].BypassJob and Config["radar"].BypassJob or {}

RegisterNetEvent("radar:sendBills")
AddEventHandler("radar:sendBills", function(playerSpeed, speedDif, speedLimit)

    local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)

    if not xPlayer then return end 

    local job = xPlayer['jobs'].job.name
    

    for i = 1, #bypassJob or 1 do
        if bypassJob[i] == job then
            xPlayer.showNotification("Vous avez été flashé mais l'amende n'a pas été envoyée car vous faites partie des services publics.")
            return
        end
    end

    local bank = xPlayer['accounts'].getAccount('bank').money

    if bank then 

        if speedDif < 20 then
            price = Config["radar"].priceL1
        elseif speedDif < 30 then
            price = Config["radar"].priceL2
        elseif speedDif < 50 then
            price = Config["radar"].priceL3
        else
            price = Config["radar"].priceL4
        end

        xPlayer['accounts'].removeAccountMoney('bank', price)
        xPlayer.showNotification("Excès de vitesse: ~r~"..playerSpeed.."~s~ Km/h ~c~au lieu de ~r~"..speedLimit.."~s~ Km/h.")
        xPlayer.showNotification("Votre compte en banque à été réduit de "..price.." ~g~$~s~ à cause de votre excès de vitesse.")
    end
end)