local InteractionPoints = {
    { type = "blackjack", x = 932.0, y = 45.5, z = 80.0 },
    { type = "slot_machine", x = 930.5, y = 45.0, z = 80.0 }
}

function IsPlayerNearInteraction(playerPos, point)
    local dist = #(playerPos - vector3(point.x, point.y, point.z))
    return dist < 1.5
end

Citizen.CreateThread(function()
    while true do
        local playerPos = GetEntityCoords(PlayerPedId())
        
        for _, point in ipairs(InteractionPoints) do
            if IsPlayerNearInteraction(playerPos, point) then
                DrawText3D(point.x, point.y, point.z, "Appuyez sur E pour jouer à " .. point.type)
                
                if IsControlJustPressed(1, 38) then 
                    if point.type == "blackjack" then
                        StartGameAnimation(PlayerPedId(), "blackjack")
                        PlayBlackjack(PlayerId(), 100) 
                    elseif point.type == "slot_machine" then
                        StartGameAnimation(PlayerPedId(), "slot_machine")
                        PlaySlotMachine(PlayerId(), 50) 
                    end
                end
            end
        end
        
        Wait(0)
    end
end)
