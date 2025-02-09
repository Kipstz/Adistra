__Ped = {}
__Ped.cache = {}

---@class Ped : __Ped
---@param modelHash number
---@param coords table
---@param heading number
function __Ped:create(modelHash, coords, heading)
    local ped = CreatePed(4, modelHash, coords.x, coords.y, coords.z, heading, false, true)
    SetEntityInvincible(ped, true) -- Activer le Godmode par défaut
    table.insert(__Ped.cache, ped)
    return ped
end

---@param ped number
function __Ped:delete(ped)
    if ped then
        DeletePed(ped)
        for i, p in ipairs(__Ped.cache) do
            if p == ped then
                table.remove(__Ped.cache, i)
                break
            end
        end
    end
end

---@param ped number
---@param freeze boolean
function __Ped:setFreeze(ped, freeze)
    if ped then
        FreezeEntityPosition(ped, freeze)
    end
end

---@param ped number
---@param godmode boolean
function __Ped:setGodmode(ped, godmode)
    if ped then
        SetEntityInvincible(ped, godmode)
    end
end

---@param ped number
---@param weaponHash number
function __Ped:giveWeapon(ped, weaponHash)
    if ped then
        GiveWeaponToPed(ped, weaponHash, 1000, true, true)
        SetPedInfiniteAmmo(ped, true, weaponHash)
    end
end

---@param ped number
---@param animationDict string
---@param animationName string
function __Ped:playAnimation(ped, animationDict, animationName)
    if ped then
        RequestAnimDict(animationDict)
        while not HasAnimDictLoaded(animationDict) do
            Wait(0)
        end
        TaskPlayAnim(ped, animationDict, animationName, 8.0, -8.0, -1, 1, 0, false, false, false)
    end
end

---@param ped number
---@param destinationCoords table
---@param speed number
function __Ped:goToDestination(ped, destinationCoords, speed)
    if ped then
        TaskGoStraightToCoord(ped, destinationCoords.x, destinationCoords.y, destinationCoords.z, speed, -1, 0.0, 0.0)
    end
end

---@param ped number
---@param title string
function __Ped:setTitle(ped, title)
    if ped then
        Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, title) -- SetEntityScript
        Citizen.InvokeNative(0x63B02FADFE3A2F1B, ped, title, true) -- SetEntityScript
    end
end

-- Ajoutez d'autres fonctions selon vos besoins

return __Ped
