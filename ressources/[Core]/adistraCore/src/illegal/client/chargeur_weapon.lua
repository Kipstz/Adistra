Framework = nil
TriggerEvent('framework:init', function(obj) Framework = obj end)

RegisterNetEvent("adistraCore.useClip")
AddEventHandler("adistraCore.useClip", function(item, itemLabel)
    local itemName = item
    local ammoCount = 25
    --4 for check any weapon
    if IsPedArmed(PlayerPedId(), 4) then
        local weaponHash = GetSelectedPedWeapon(PlayerPedId())

        if weaponHash then
            local weaponName = Framework.GetWeaponFromHash(weaponHash)

            TriggerServerEvent("adistraCore.deleteItem")
            TriggerServerEvent('framework:updateWeaponAmmo', weaponName, ammoCount)
            AddAmmoToPed(PlayerPedId(), weaponHash, ammoCount)
            Framework.ShowNotification("Vous avez ~g~utilisé~s~ 1x " ..itemLabel.."")
        else
            Framework.ShowNotification("~r~Action Impossible~s~ : Vous n'avez pas d'arme en main !")
        end
    else
        Framework.ShowNotification("~r~Action Impossible~s~ : Ce type de munition ne convient pas !")
    end
end)