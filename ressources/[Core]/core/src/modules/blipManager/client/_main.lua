

HD_Cls.createClass("BlipManager", function(cls)
    ---@class BlipManager: BaseObject
    local class = cls
    class.blips = {};
    class.zones = {};

    function class:Constructor(name, some_variable)
        class.name = name;
        class.some_variable = some_variable;
    end

    function class:addBlip(name, coords, sprite, color, label, scale, shortRange)
        local name = string.lower(name)
        if shortRange == nil then shortRange = true end
        if scale == nil then scale = 0.5 end

        class.blips[name] = AddBlipForCoord(coords)

        SetBlipSprite(class.blips[name], sprite)
        SetBlipColour(class.blips[name], color)
        SetBlipScale(class.blips[name], scale)
        SetBlipAsShortRange(class.blips[name], shortRange)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(label)
        EndTextCommandSetBlipName(class.blips[name])
    end

    function class:addBlipWithZone(name, coords, sprite, color, label, scale, alpha, shortRange)
        local name = string.lower(name)
        if shortRange == nil then shortRange = true end
        if scale == nil then scale = 0.5 end

        class.blips[name] = AddBlipForCoord(coords)

        SetBlipSprite(class.blips[name], sprite)
        SetBlipColour(class.blips[name], color)
        SetBlipScale(class.blips[name], scale)
        SetBlipAsShortRange(class.blips[name], shortRange)

        class.zones[name] = AddBlipForRadius(coords, 300.0)

        SetBlipSprite(class.zones[name], 1)
        SetBlipColour(class.zones[name], color)
        SetBlipAlpha(class.zones[name], alpha)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(label)
        EndTextCommandSetBlipName(class.blips[name])
    end

    function class:removeBlip(name)
        RemoveBlip(class.blips[name])
    end

    function class:removeZone(name)
        RemoveBlip(class.zones[name])
    end

    function class:setBlipSprite(name, id)
        SetBlipSprite(class.blips[name], id)
    end

    function class:setBlipScale(name, scale)
        SetBlipScale(class.blips[name], scale)
    end

    function class:setBlipColour(name, colour)
        SetBlipColour(class.blips[name], colour)
    end

    function class:setBlipAsShortRange(name, short)
        SetBlipAsShortRange(class.blips[name], short)
    end

    function class:setBlipTitle(name, title)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(title)
        EndTextCommandSetBlipName(class.blips[name])
    end

    function class:setBlipCoords(name, coords)
        SetBlipCoords(class.blips[name], coords)
    end

    return class
end)