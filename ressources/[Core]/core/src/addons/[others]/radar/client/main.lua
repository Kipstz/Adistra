


local isFlashed = false
local speed_flash = 0
local zones = Config["radar"].zones and Config["radar"].zones or {}

CreateThread(function()

    while true do 

        local timer = 1000

        for i = 1, #zones or 1 do

            local zone = zones[i]
            local coords = GetEntityCoords(PlayerPedId())
            local distance = #(vector3(zone.position.x, zone.position.y, zone.position.z) - coords)
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

            if distance <= zone.radius and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
                timer = 0
                local playerSpeed = GetEntitySpeed(PlayerPedId()) * 3.6
                local speedLimit = zones[i].speedlimit or 100
                local speedDif = playerSpeed - speedLimit

                if not isFlashed then
                    if playerSpeed > speedLimit then
                        speed_flash = (GetEntitySpeed(player) * 3.6) or 0
                        isFlashed = true
                        StartScreenEffect("SwitchShortMichaelIn", 400, false)
                        TriggerServerEvent("radar:sendBills", math.round(playerSpeed), math.round(speedDif), speedLimit)
                        SetTimeout(8000, function()
                            isFlashed = false
                        end)
                    end

                end
            end

        end
        Wait(timer)
    end
end)