__Zone = {}
__Zone.cache = {
    ["Zones"] = {},
    ["closestZones"] = {}
};

---@param name string
---@param coords table
---@param radius number
---@param options table
---exemple:
---__Zone:create("LTD", vector3(25.987669, -1345.527832, 29.497017), 1.0, {
---    onEnter = function()
---        print("enter")
---    end,
---    onExit = function()
---        print("exit")
---    end,
---    onPress = function()
---        print("press")
---    end
---})
---@return table
function __Zone:create(name, coords, radius, options)
    if not __Zone.cache["Zones"][name] then
        __Zone.cache["Zones"][name] = {}
    end
    __Zone.cache["Zones"][name] = { name = name, coords = coords, radius = radius, options = options }
    return __Zone.cache["Zones"][name]
end

---@param name string
function __Zone:delete(name)
    if __Zone.cache["Zones"][name] then
        __Zone.cache["Zones"][name] = nil
    end
end

__While:addTick(1000, "ZoneManager", function()
    for k, v in pairs(__Zone.cache["Zones"]) do
        if #(GetEntityCoords(PlayerPedId()) - v.coords) < v.radius then
            if not __Zone.cache["closestZones"][k] then
                __Zone.cache["closestZones"][k] = v
                if v.options.onEnter then
                    v.options.onEnter()
                end
                if v.options.onPress then
                    __While:addTick(0, "ZoneManager:Press", function()
                        if IsControlJustPressed(0, 38) then
                            v.options.onPress()
                        end
                    end)
                end
            end
        else
            if __Zone.cache["closestZones"][k] then
                __Zone.cache["closestZones"][k] = nil
                if v.options.onExit then
                    v.options.onExit()
                end
                if v.options.onPress then
                    __While:removeTick("ZoneManager:Press")
                end
            end
        end
    end
end)

function __Zone:startDebugZone()
    __While:addTick(0, "DebugZone", function()
        for i, v in pairs(__Zone.cache["Zones"]) do
            DrawMarker(28, v.coords.x, v.coords.y, v.coords.z, 0, 0, 0, 0, 0, 0, v.radius + .0, v.radius + .0, v.radius + .0, 255, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0);
            __Blips:createRadius("Zone - " .. v.name, v.coords, v.radius)
        end
    end)
end
