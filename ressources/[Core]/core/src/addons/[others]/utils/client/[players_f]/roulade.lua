--[[CreateThread(function()
    while true do 
        local wait = 1000;
        if IsPedArmed(PlayerPedId(), 4 or 2) and IsPlayerFreeAiming(PlayerId())  then 
            wait = 1;
            DisableControlAction(0, 22, true)
        end
        Wait(wait)
    end
end)]]