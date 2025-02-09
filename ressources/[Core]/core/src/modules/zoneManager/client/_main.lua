
HD_Cls.createClass("ZoneManager", function(cls)
    local class = cls

    class.zones = {}
    class.zoneIndex = 0

    function class:createZone(coords, radiusVisible, radiusCanPress, data)
        class.zoneIndex = class.zoneIndex + 1

        local zone = {
            id               = class.zoneIndex,
            isInZone         = false,
            coords           = coords,
            radiusVisible    = radiusVisible,
            radiusCanPress   = radiusCanPress,
            onPress          = data.onPress,
            onEnter          = data.onEnter,
            onEnterPressZone = data.onEnterPressZone,
            onUpdate         = data.onUpdate,
            onExit           = data.onExit,
            onExitPressZone  = data.onExitPressZone,
            players          = {},
        }

        class.zones["zone"..class.zoneIndex] = zone
        class.closestZones = {}
        return "zone"..class.zoneIndex
    end

    function class:createZoneWithMarker(coords, radiusVisible, radiusCanPress, data)
        data = {
            onPress = data.onPress,
            onEnter = function(zone)
                TickManager:addTick('marker_zone'..zone.id, function()
                    VisualManager:DrawMarker(zone.coords)
                    VisualManager:DrawText3D(zone.coords, "Appuyez sur [~p~E~s~] pour intéragir.")
                end)
            end,
            onEnterPressZone = function(zone)
                TickManager:addTick('onPressZone'..zone.id, function()
                    if IsControlJustPressed(0, zone.onPress.control) then
                        zone.onPress.action(zone)
                    end
                end)
            end,
            onExit = function(zone)
                TickManager:removeTick('marker_zone'..zone.id)
                class:deleteZone(zone.id)
            end,
            onExitPressZone = function(zone)
                TickManager:removeTick('onPressZone'..zone.id)
                class:deleteZone(zone.id)
            end
        }
        return class:createZone(coords, radiusVisible, radiusCanPress, data)
    end

    function class:createZoneWithoutMarker(coords, radiusVisible, radiusCanPress, data)
        data = {
            onPress = data.onPress,
            onEnter = function(zone)
                VisualManager:helpNotify("Appuyez sur [~p~E~s~] pour intéragir.")
            end,
            onEnterPressZone = function(zone)
                TickManager:addTick('onPressZone'..zone.id, function()
                    if IsControlJustPressed(0, zone.onPress.control) then
                        zone.onPress.action(zone)
                    end
                end)
            end,
            onExit = function(zone)
                class:deleteZone(zone.id)
            end,
            onExitPressZone = function(zone)
                TickManager:removeTick('onPressZone'..zone.id)
                class:deleteZone(zone.id)
            end
        }
        class:createZone(coords, radiusVisible, radiusCanPress, data)
    end

    function class:tickAnalyze()
        CreateThread(function()
            while true do
                wait = 750;
                class.closestZones = {}

                local plyPed = PlayerPedId();
                local myCoords = GetEntityCoords(plyPed);

                for k,zone in pairs(class.zones) do
                    local dist = Vdist(myCoords, zone.coords);
                    if dist <= zone.radiusVisible then
                        wait = 5;
                        if not zone.isInZone then
                            zone.isInZone = true
                            if zone.onEnter then
                                zone.onEnter(zone)
                            end
                        end
                        if zone.isInZone and dist <= zone.radiusCanPress then
                            if zone.onEnterPressZone then
                                zone.onEnterPressZone(zone)
                            end
                        end
                        if zone.isInZone and dist >= zone.radiusCanPress then
                            if zone.onExitPressZone then
                                zone.onExitPressZone(zone)
                            end
                        end
                        if zone.onUpdate then
                            zone.onUpdate(zone)
                        end
                    elseif dist >= zone.radiusVisible then
                        if zone.isInZone then
                            zone.isInZone = false;
                            if zone.onExit then
                                zone.onExit(zone)
                                zone.onExitPressZone(zone)
                            end
                        end
                    elseif dist >= zone.radiusCanPress then
                        if zone.isInZone then
                            if zone.onExitPressZone then
                                zone.onExitPressZone(zone)
                            end
                        end
                    end
                end

                Wait(wait)
            end
        end)
    end

    class:tickAnalyze()

    function class:getZone(id)
        return class.zones[id]
    end

    function class:setZone(id,zone)
        class.zones[id] = zone
    end

    function class:deleteZone(id)
        class.zones[id] = nil;
    end

    function class:deleteZonePermanently(id, zoneId)
        class.zones[id] = nil;
        TickManager:removeTick('marker_zone'..zoneId)
        TickManager:removeTick('onPressZone'..zoneId)
    end

    return class
end)