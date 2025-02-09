Framework = nil
TriggerEvent('framework:init', function(obj) Framework = obj end)

local carkillCauses = { 133987706, -1553120962 }

local function containsValue(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

RegisterCommand('carkill', function()
    local reason_dead = GetPedCauseOfDeath(GetPlayerPed(PlayerId()))

    if IsEntityDead(GetPlayerPed(PlayerId())) then
        if containsValue(carkillCauses, reason_dead) then
            TriggerEvent('AmbulanceJob:revive')
            Citizen.Wait(2500)
            Framework.ShowNotification('Si un abus de la commande est constaté, un admin peut sanctionner son usage.')
        else
            Framework.ShowNotification('Vous n\'avez pas été tué par un véhicule.')
        end
    else
        Framework.ShowNotification('Vous n\'êtes pas mort.')
    end
end)