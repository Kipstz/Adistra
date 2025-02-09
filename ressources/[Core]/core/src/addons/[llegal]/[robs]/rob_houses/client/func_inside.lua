
function RobHouses:stop()
    RobHouses:tp(RobHouses.robbing.outsidePos)
    TriggerServerEvent('rob_houses:stop')
    Wait(2000)
    for k,v in pairs(RobHouses.zones) do
        local zoneId = (v):gsub("zone", "")
        ZoneManager:deleteZonePermanently("zone"..zoneId, zoneId)
    end
    RobHouses.inRobbing = false;
    RobHouses.zones = {}
    RobHouses.robbing = {}
end

function RobHouses:tp(coords)
    local plyPed = PlayerPedId()
    if coords ~= nil then
        while Vdist(GetEntityCoords(plyPed), coords) > 5 do
            SetEntityCoords(plyPed, coords)
    
            Wait(1)
        end
    end
end

function RobHouses:zoneExit(pos)
    RobHouses.zones['zoneExit'] = ZoneManager:createZoneWithMarker(pos, 5, 1.5, {
        onPress = {control = 38, action = function(zone)
            RobHouses:stop()
        end}
    })
end

function RobHouses:zoneLoot(int)
    for k,v in pairs(Config['rob_houses'].interieurs[int].loots) do
        RobHouses.zones[k] = ZoneManager:createZoneWithMarker(v, 5, 1.5, {
            onPress = {control = 38, action = function(zone)
                RobHouses:startLoot(zone.id, int)
            end}
        })
    end
end

function RobHouses:randomCatLoot(cats)
    local random = math.random(1, #cats)
    return random;
end

function RobHouses:startLoot(zoneId, int)
    ProgressBars:startUI(5000, "Fouille en cours...")
    Wait(5000)
    local cat = RobHouses:randomCatLoot(Config['rob_houses'].interieurs[int].items)
    ZoneManager:deleteZonePermanently("zone"..zoneId, zoneId)
    TriggerServerEvent('rob_houses:giveItem', int, cat)
end