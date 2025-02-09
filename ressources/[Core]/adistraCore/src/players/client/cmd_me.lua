local pedDisplaying = {}
local pedDisplaying = {}

local function DrawText3D(coords, text, colorResult)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    local scale = 200 / (GetGameplayCamFov() * dist)
    SetTextColour(colorResult.r, colorResult.g, colorResult.b, colorResult.alpha)
    SetTextScale(0.0, 0.5 * scale)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

local function Display(ped, text, cmd)

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)
	
	if cmd == "me" then
        colorResult = { r = 255, g = 255, b = 255, alpha = 255 }
    elseif cmd == "do" then
        colorResult = { r = 111, g = 0, b = 163, alpha = 255 }
    elseif cmd == "it" then
        colorResult = { r = 102, g = 0, b = 51, alpha = 255 }
    elseif tonumber(cmd) ~= nil then
        local x = tonumber(cmd)
        local red = (255 + 1.47 * x) - (0.0402 * x ^ 2)
        local green = (4.77 * x) - (0.0222 * x ^ 2)
        green = math.ceil(green)
        if red > 255 then 
            red = 255 
        else
            red = math.ceil(red)
        end 
        colorResult = { r = red, g = green, b = 0, alpha = 255 }           
    end
	
    if dist <= 250 then --distance visuel /me
        pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1
        local display = true
        Citizen.CreateThread(function()
            Wait(5000) --Temps affichage
            display = false
        end)
        local offset = 0.8 + pedDisplaying[ped] * 0.1
        while display do
            if HasEntityClearLosToEntity(playerPed, ped, 17 ) then
                local x, y, z = table.unpack(GetEntityCoords(ped))
                z = z + offset
                DrawText3D(vector3(x, y, z), text, colorResult)
            end
            Wait(0)
        end
        pedDisplaying[ped] = pedDisplaying[ped] - 1
    end
end

local function GetAroundPlayers()
    local players = lib.getNearbyPlayers(GetEntityCoords(PlayerPedId()), 20, true)
    local data = {}
    for i = 1, #players do
        table.insert(data, GetPlayerServerId(players[i].id))
    end
    return data
end

RegisterNetEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text, serverId, cmd)
    local player = GetPlayerFromServerId(serverId)
    if player ~= -1 then
        local ped = GetPlayerPed(player)
        Display(ped, text, cmd)
    end
end)

RegisterCommand('me', function(source, args)
    local text =  '* La personne'
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end
    text = text .. ' *'
    TriggerServerEvent('3dme:shareDisplay', GetAroundPlayers(), text, "me")
end)