TriggerEvent('framework:init', function(obj) Framework = obj end)
local activeAFKPlayers = {}

local function GenerateSecurityToken()
    local token = tostring(math.random(1000000, 9999999))
    return token
end

RegisterServerEvent("afkFarm:RequestToken")
AddEventHandler("afkFarm:RequestToken", function()
    local token = GenerateSecurityToken()
    activeAFKPlayers[source] = {token = token, lastCheckin = os.time()}
    TriggerClientEvent("afkFarm:ReceiveToken", source, token)
end)

RegisterServerEvent("afkFarm:AFKMode")
AddEventHandler("afkFarm:AFKMode", function(mode, token, returnCoords)
    local source = source
    if not activeAFKPlayers[source] or activeAFKPlayers[source].token ~= token then
        DropPlayer(source, "Invalid security token")
        return
    end

    if mode == "enter" then
        local playerCoords = GetEntityCoords(GetPlayerPed(source))
        FreezeEntityPosition(GetPlayerPed(source), true)
        activeAFKPlayers[source].returnCoords = returnCoords
        startFarming(source)
    elseif mode == "exit" then
        FreezeEntityPosition(GetPlayerPed(source), false)
        stopFarming(source)
        print("json.encode(activeAFKPlayers))")
        activeAFKPlayers[source] = nil
    end
end)

RegisterServerEvent("afkFarm:Checkin")
AddEventHandler("afkFarm:Checkin", function(token)
    local source = source
    if not activeAFKPlayers[source] or activeAFKPlayers[source].token ~= token then
        DropPlayer(source, "Invalid security token")
        return
    end
    activeAFKPlayers[source].lastCheckin = os.time()
end)

function startFarming(source)
    local xPlayer = Framework.GetPlayerFromId(source)
    local lastRewardTime = os.time()

    print(json.encode(activeAFKPlayers))
    activeAFKPlayers[source].farmingThread = CreateThread(function()
        while activeAFKPlayers[source] do
            local currentTime = os.time()
            local timeSinceLastReward = currentTime - lastRewardTime
            print("timeSinceLastReward: " .. timeSinceLastReward)
            if timeSinceLastReward >= 3600 then  --@TODO remettre en 3600
                if currentTime - activeAFKPlayers[source].lastCheckin > 10 then
                    TriggerClientEvent("afkFarm:ForceEndAFK", source)
                    activeAFKPlayers[source] = nil
                    break
                else
                    exports['Logs']:createLog({
                        EmbedMessage = "A reçu ses récompenses (5 coins, 10 000$)",
                        player_id = source,
                        channel = 'afk-rewards'
                    })

                    xPlayer.accounts.addAccountMoney('money', 10000)
                    xPlayer.addCoins(5)

                    lastRewardTime = os.time()
                end
            end

            Wait(60000) --@TODO remettre en 60000
        end
    end)
end

function stopFarming(source)
    if activeAFKPlayers[source] and activeAFKPlayers[source].farmingThread then
        Citizen.KillThread(activeAFKPlayers[source].farmingThread)
    end
end

AddEventHandler('playerDropped', function(reason)
    if activeAFKPlayers[source] then
        stopFarming(source)
        activeAFKPlayers[source] = nil
    end
end)