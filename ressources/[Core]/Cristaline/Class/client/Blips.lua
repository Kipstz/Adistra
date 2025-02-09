__Blips = {}
__Blips.cache = {}

---@class Blips : __Blips
---@param name string
---@param coords table
---@param id number
---@param colour number
---@param title string
function __Blips:create(name, coords, id, colour, title)
    if not __Blips.cache[name] then
        __Blips.cache[name] = {}
    else
        __Blips:delete(name)
    end
    __Blips.cache[name] = AddBlipForCoord(coords)
    SetBlipSprite(__Blips.cache[name], id)
    SetBlipDisplay(__Blips.cache[name], 4)
    SetBlipScale(__Blips.cache[name], 0.6)
    SetBlipColour(__Blips.cache[name], colour)
    SetBlipAsShortRange(__Blips.cache[name], true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(title)
    EndTextCommandSetBlipName(__Blips.cache[name])
    return __Blips.cache[name]
end

---@param name string
---@param coords table
---@param radius number
function __Blips:createRadius(name, coords, radius)
    if not __Blips.cache[name] then
        __Blips.cache[name] = {}
    else
        __Blips:delete(name)
    end
    __Blips.cache[name] = AddBlipForRadius(coords.x, coords.y, coords.z, radius + 0.0)
    SetBlipSprite(__Blips.cache[name], 9)
    SetBlipColour(__Blips.cache[name], 1)
    SetBlipAlpha(__Blips.cache[name], 100)

    return __Blips.cache[name]
end

---@param name string
function __Blips:delete(name)
    if __Blips.cache[name] then
        RemoveBlip(__Blips.cache[name])
        __Blips.cache[name] = nil
    end
end

---@param name string
---@param id number
function __Blips:setSprite(name, id)
    if __Blips.cache[name] then
        SetBlipSprite(__Blips.cache[name], id)
    end
end

---@param name string
---@param colour number
function __Blips:setColor(name, colour)
    if __Blips.cache[name] then
        SetBlipColour(__Blips.cache[name], colour)
    end
end

---@param name string
---@param scale number
function __Blips:setScale(name, scale)
    if __Blips.cache[name] then
        SetBlipScale(__Blips.cache[name], scale)
    end
end

---@param name string
---@param title string
function __Blips:setTitle(name, title)
    if __Blips.cache[name] then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(title)
        EndTextCommandSetBlipName(__Blips.cache[name])
    end
end


