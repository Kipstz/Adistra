
PacificHeist = {}

PacificHeist.PlaySound = false;
PacificHeist.program = 0;
PacificHeist.scaleform = nil;
PacificHeist.lives = 5;
PacificHeist.ClickReturn = nil;
PacificHeist.SorF = false;
PacificHeist.Hacking = false;
PacificHeist.Ipfinished = false;
PacificHeist.UsingComputer = false;
PacificHeist.text = '';
PacificHeist.RouletteWords = {
    "UTK4EVER",
    "ABSOLUTE",
    "ISTANBUL",
    "DOCTRINE",
    "IMPERIUS",
    "DELIRIUM",
    "MAETHRIL"
}

CreateThread(function()
    PacificHeist.scaleform = PacificHeist:Initialize("HACKING_PC")

    while true do
        wait = 1500;

        if PacificHeist.UsingComputer then
            wait = 1;

            DrawScaleformMovieFullscreen(PacificHeist.scaleform, 255, 255, 255, 255, 0)
            PushScaleformMovieFunction(PacificHeist.scaleform, "SET_CURSOR")
            PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 239))
            PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 240))
            PopScaleformMovieFunctionVoid()

            if IsDisabledControlJustPressed(0,24) and not PacificHeist.SorF then
                PushScaleformMovieFunction(PacificHeist.scaleform, "SET_INPUT_EVENT_SELECT")
                PacificHeist.ClickReturn = PopScaleformMovieFunction()
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 176) and PacificHeist.Hacking then
                PushScaleformMovieFunction(PacificHeist.scaleform, "SET_INPUT_EVENT_SELECT")
                PacificHeist.ClickReturn = PopScaleformMovieFunction()
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 25) and not PacificHeist.Hacking and not PacificHeist.SorF then
                PushScaleformMovieFunction(PacificHeist.scaleform, "SET_INPUT_EVENT_BACK")
                PopScaleformMovieFunctionVoid()
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 172) and PacificHeist.Hacking then
                PushScaleformMovieFunction(PacificHeist.scaleform, "SET_INPUT_EVENT")
                PushScaleformMovieFunctionParameterInt(8)
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 173) and PacificHeist.Hacking then
                PushScaleformMovieFunction(PacificHeist.scaleform, "SET_INPUT_EVENT")
                PushScaleformMovieFunctionParameterInt(9)
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 174) and PacificHeist.Hacking then
                PushScaleformMovieFunction(PacificHeist.scaleform, "SET_INPUT_EVENT")
                PushScaleformMovieFunctionParameterInt(10)
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 175) and PacificHeist.Hacking then
                PushScaleformMovieFunction(PacificHeist.scaleform, "SET_INPUT_EVENT")
                PushScaleformMovieFunctionParameterInt(11)
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            end
        end

        Wait(wait)
    end
end)

CreateThread(function()
    while true do
        wait = 1500;

        if HasScaleformMovieLoaded(PacificHeist.scaleform) and PacificHeist.UsingComputer then
            wait = 1;

            Config['heist_pacific'].disableinput = true;
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)

            if IsScaleformMovieMethodReturnValueReady(PacificHeist.ClickReturn) then
                PacificHeist.program = GetScaleformMovieFunctionReturnInt(PacificHeist.ClickReturn)

                if PacificHeist.program == 82 and not PacificHeist.Hacking then
                    PacificHeist.lives = 5;

                    PushScaleformMovieFunction(PacificHeist.scaleform, "SET_LIVES")
                    PushScaleformMovieFunctionParameterInt(PacificHeist.lives)
                    PushScaleformMovieFunctionParameterInt(5)
                    PopScaleformMovieFunctionVoid()

                    PushScaleformMovieFunction(PacificHeist.scaleform, "OPEN_APP")
                    PushScaleformMovieFunctionParameterFloat(0.0)
                    PopScaleformMovieFunctionVoid()

                    PacificHeist.Hacking = true;
                    Framework.ShowNotification("Find the IP adress...")
                elseif PacificHeist.program == 83 and not PacificHeist.Hacking and PacificHeist.Ipfinished then
                    PushScaleformMovieFunction(PacificHeist.scaleform, "SET_LIVES")
                    PushScaleformMovieFunctionParameterInt(PacificHeist.lives)
                    PushScaleformMovieFunctionParameterInt(5)
                    PopScaleformMovieFunctionVoid()

                    PushScaleformMovieFunction(PacificHeist.scaleform, "OPEN_APP")
                    PushScaleformMovieFunctionParameterFloat(1.0)
                    PopScaleformMovieFunctionVoid()

                    PushScaleformMovieFunction(PacificHeist.scaleform, "SET_ROULETTE_WORD")
                    PushScaleformMovieFunctionParameterString(PacificHeist.RouletteWords[math.random(#PacificHeist.RouletteWords)])
                    PopScaleformMovieFunctionVoid()

                    PacificHeist.Hacking = true;
                    Framework.ShowNotification("Trouve le mot de passe...")
                elseif PacificHeist.Hacking and PacificHeist.program == 87 then
                    PacificHeist.lives = PacificHeist.lives - 1

                    PushScaleformMovieFunction(PacificHeist.scaleform, "SET_LIVES")
                    PushScaleformMovieFunctionParameterInt(PacificHeist.lives)
                    PushScaleformMovieFunctionParameterInt(5)
                    PopScaleformMovieFunctionVoid()
                    PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
                elseif PacificHeist.Hacking and PacificHeist.program == 84 then
                    PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
                    PushScaleformMovieFunction(PacificHeist.scaleform, "SET_IP_OUTCOME")
                    PushScaleformMovieFunctionParameterBool(true)
                    PacificHeist:ScaleformLabel(0x18EBB648)
                    PopScaleformMovieFunctionVoid()
                    PushScaleformMovieFunction(PacificHeist.scaleform, "CLOSE_APP")
                    PopScaleformMovieFunctionVoid()

                    PacificHeist.Hacking = false;
                    PacificHeist.Ipfinished = true;

                    Framework.ShowNotification("Lance BruteForce.exe")
                elseif PacificHeist.Hacking and PacificHeist.program == 85 then
                    PlaySoundFrontend(-1, "HACKING_FAILURE", "", false)
                    PushScaleformMovieFunction(PacificHeist.scaleform, "CLOSE_APP")
                    PopScaleformMovieFunctionVoid()

                    PacificHeist.Hacking = false;
                    PacificHeist.SorF = false;
                elseif PacificHeist.Hacking and PacificHeist.program == 86 then
                    PacificHeist.SorF = true;

                    PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
                    PushScaleformMovieFunction(PacificHeist.scaleform, "SET_ROULETTE_OUTCOME")
                    PushScaleformMovieFunctionParameterBool(true)
                    PacificHeist:ScaleformLabel("WINBRUTE")
                    PopScaleformMovieFunctionVoid()
                    Wait(1)
                    PushScaleformMovieFunction(PacificHeist.scaleform, "CLOSE_APP")
                    PopScaleformMovieFunctionVoid()

                    PacificHeist.Hacking = false;
                    PacificHeist.SorF = false;

                    SetScaleformMovieAsNoLongerNeeded(PacificHeist.scaleform)
                    DisableControlAction(0, 24, false)
                    DisableControlAction(0, 25, false)
                    FreezeEntityPosition(PlayerPedId(), false)
                    if Config['heist_pacific'].hackmethod == 1 then
                        --TriggerServerEvent("heist_pacific:toggleDoor", Config['heist_pacific'].hack1.type, vector3(Config['heist_pacific'].hack1.x, Config['heist_pacific'].hack1.y, Config['heist_pacific'].hack1.z), false, Config['heist_pacific'].hack1.h)
                        exports["ac"]:ExecuteServerEvent("heist_pacific:policeDoor", 3, false)

                        Framework.ShowNotification(Config['heist_pacific'].text.hacked)

                        PacificHeist.UsingComputer = false;
                        Config['heist_pacific'].disableinput = false;
                        Config['heist_pacific'].hackfinish = true;
                        PacificHeist.Ipfinished = false;
                    elseif Config['heist_pacific'].hackmethod == 2 then
                        PacificHeist:SpawnObj()

                        PacificHeist.UsingComputer = false;
                        PacificHeist.Ipfinished = false;

                        PacificHeist:Process(25000, "Hacking du système...")
                        TriggerEvent("heist_pacific:vaulttimer", 1)
                        exports["ac"]:ExecuteServerEvent("heist_pacific:openvault", 1)
                        Framework.ShowNotification(Config['heist_pacific'].text.hacked)

                        Config['heist_pacific'].disableinput = false;
                        Config['heist_pacific'].hackfinish = true;
                        Config['heist_pacific'].info.stage = 2;
                        Config['heist_pacific'].info.style = 1;
                        Config['heist_pacific'].stage1break = true;

                        PacificHeist:HandleInfo()
                    end
                elseif PacificHeist.program == 6 then
                    TriggerServerEvent("heist_pacific:upVar_s", "hacking_s", false)

                    PacificHeist.UsingComputer = false;
                    Config['heist_pacific'].hackfinish = true;
                    Config['heist_pacific'].disableinput = false;

                    SetScaleformMovieAsNoLongerNeeded(PacificHeist.scaleform)
                    DisableControlAction(0, 24, false)
                    DisableControlAction(0, 25, false)
                    FreezeEntityPosition(PlayerPedId(), false)
                end

                if PacificHeist.Hacking then
                    PushScaleformMovieFunction(PacificHeist.scaleform, "SHOW_LIVES")
                    PushScaleformMovieFunctionParameterBool(true)
                    PopScaleformMovieFunctionVoid()

                    if PacificHeist.lives <= 0 then
                        PacificHeist.SorF = true;

                        PlaySoundFrontend(-1, "HACKING_FAILURE", "", true)
                        PushScaleformMovieFunction(PacificHeist.scaleform, "SET_ROULETTE_OUTCOME")
                        PushScaleformMovieFunctionParameterBool(false)
                        PacificHeist:ScaleformLabel("LOSEBRUTE")
                        PopScaleformMovieFunctionVoid()
                        Wait(1000)
                        PushScaleformMovieFunction(PacificHeist.scaleform, "CLOSE_APP")
                        PopScaleformMovieFunctionVoid()
                        TriggerServerEvent("PacificHeist:upVar_s", "hacking_s", false)

                        Config['heist_pacific'].disableinput = false;
                        PacificHeist.Hacking = false;
                        PacificHeist.SorF = false;
                    end
                end
            end
        end

        Wait(wait)
    end
end)

CreateThread(function()
    while true do
        local enabled = false;

        Wait(1)

        if Config['heist_pacific'].disableinput then
            enabled = true;
            PacificHeist:DisableControl()
        end

        if not enabled then
            Wait(1000)
        end
    end
end)

CreateThread(function()
    if Config['heist_pacific'].enablextras then
        while true do
            wait = 1500;
            if Config['heist_pacific'].startloot then
                wait = 1;
                local coords = GetEntityCoords(PlayerPedId())

                if not Config['heist_pacific'].checks.grab1 then
                    local dst1 = GetDistanceBetweenCoords(coords, Config['heist_pacific'].cash1.x, Config['heist_pacific'].cash1.y, Config['heist_pacific'].cash1.z, true)

                    if dst1 <= 4 then
                        Framework.ShowHelpNotification(Config['heist_pacific'].text.lootcash)
                        if dst1 < 1 and IsControlJustReleased(0, 38) then
                            Config['heist_pacific'].checks.grab1 = true
                            exports["ac"]:ExecuteServerEvent("heist_pacific:updatecheck", "grab1", true)
                            PacificHeist:Loot(1)
                        end
                    end
                end
                if not Config['heist_pacific'].checks.grab2 then
                    local dst2 = GetDistanceBetweenCoords(coords, Config['heist_pacific'].cash2.x, Config['heist_pacific'].cash2.y, Config['heist_pacific'].cash2.z, true)

                    if dst2 <= 4 then
                        Framework.ShowHelpNotification(Config['heist_pacific'].text.lootcash)
                        if dst2 < 1 and IsControlJustReleased(0, 38) then
                            Config['heist_pacific'].checks.grab2 = true
                            exports["ac"]:ExecuteServerEvent("heist_pacific:updatecheck", "grab2", true)
                            PacificHeist:Loot(2)
                        end
                    end
                end
                if not Config['heist_pacific'].checks.grab3 then
                    local dst3 = GetDistanceBetweenCoords(coords, Config['heist_pacific'].cash3.x, Config['heist_pacific'].cash3.y, Config['heist_pacific'].cash3.z, true)

                    if dst3 <= 4 then
                        Framework.ShowHelpNotification(Config['heist_pacific'].text.lootcash)
                        if dst3 < 1 and IsControlJustReleased(0, 38) then
                            Config['heist_pacific'].checks.grab3 = true
                            exports["ac"]:ExecuteServerEvent("heist_pacific:updatecheck", "grab3", true)
                            PacificHeist:Loot(3)
                        end
                    end
                end
                if not Config['heist_pacific'].checks.grab4 then
                    local dst4 = GetDistanceBetweenCoords(coords, Config['heist_pacific'].gold.x, Config['heist_pacific'].gold.y, Config['heist_pacific'].gold.z, true)

                    if dst4 <= 4 then
                        Framework.ShowHelpNotification(Config['heist_pacific'].text.lootgold)
                        if dst4 < 1 and IsControlJustReleased(0, 38) then
                            Config['heist_pacific'].checks.grab4 = true
                            exports["ac"]:ExecuteServerEvent("heist_pacific:updatecheck", "grab4", true)
                            PacificHeist:Loot(4)
                        end
                    end
                end
                if not Config['heist_pacific'].checks.grab5 then
                    local dst5 = GetDistanceBetweenCoords(coords, Config['heist_pacific'].dia.x, Config['heist_pacific'].dia.y, Config['heist_pacific'].dia.z, true)

                    if dst5 <= 4 then
                        Framework.ShowHelpNotification(Config['heist_pacific'].text.lootdia)
                        if dst5 < 1 and IsControlJustReleased(0, 38) then
                            Config['heist_pacific'].checks.grab5 = true
                            exports["ac"]:ExecuteServerEvent("heist_pacific:updatecheck", "grab5", true)
                            PacificHeist:Loot(5)
                        end
                    end
                end
                if Config['heist_pacific'].stagelootbreak then return end
            end
            Wait(wait)
        end
    elseif not Config['heist_pacific'].enablextras then
        while true do
            wait = 1500;
            if Config['heist_pacific'].startloot then
                wait = 1;
                local coords = GetEntityCoords(PlayerPedId())

                if not Config['heist_pacific'].checks.grab1 then
                    local dst1 = GetDistanceBetweenCoords(coords, Config['heist_pacific'].cash1.x, Config['heist_pacific'].cash1.y, Config['heist_pacific'].cash1.z, true)

                    if dst1 <= 4 then
                        Framework.ShowHelpNotification(Config['heist_pacific'].text.lootcash)
                        if dst1 < 1 and IsControlJustReleased(0, 38) then
                            Config['heist_pacific'].checks.grab1 = true
                            exports["ac"]:ExecuteServerEvent("heist_pacific:updatecheck", "grab1", true)
                            PacificHeist:Loot(1)
                        end
                    end
                end
                if not Config['heist_pacific'].checks.grab2 then
                    local dst2 = GetDistanceBetweenCoords(coords, Config['heist_pacific'].cash2.x, Config['heist_pacific'].cash2.y, Config['heist_pacific'].cash2.z, true)

                    if dst2 <= 4 then
                        Framework.ShowHelpNotification(Config['heist_pacific'].text.lootcash)
                        if dst2 < 1 and IsControlJustReleased(0, 38) then
                            Config['heist_pacific'].checks.grab2 = true
                            exports["ac"]:ExecuteServerEvent("heist_pacific:updatecheck", "grab2", true)
                            PacificHeist:Loot(2)
                        end
                    end
                end
                if not Config['heist_pacific'].checks.grab3 then
                    local dst3 = GetDistanceBetweenCoords(coords, Config['heist_pacific'].cash3.x, Config['heist_pacific'].cash3.y, Config['heist_pacific'].cash3.z, true)

                    if dst3 <= 4 then
                        Framework.ShowHelpNotification(Config['heist_pacific'].text.lootcash)
                        if dst3 < 1 and IsControlJustReleased(0, 38) then
                            Config['heist_pacific'].checks.grab3 = true
                            exports["ac"]:ExecuteServerEvent("heist_pacific:updatecheck", "grab3", true)
                            PacificHeist:Loot(3)
                        end
                    end
                end
                if Config['heist_pacific'].stagelootbreak then
                    return
                end
            end
            Wait(wait)
        end
    end
end)

CreateThread(function()
    Framework.TriggerServerCallback("heist_pacific:GetDoors", function(result)
        Config['heist_pacific'].PoliceDoors = result;
    end)

    while Config['heist_pacific'].PoliceDoors == {} do Wait(1) end

    while true do
        for k, v in ipairs(Config['heist_pacific'].PoliceDoors) do
            if Config['heist_pacific'].PoliceDoors[k].obj == nil or not DoesEntityExist(Config['heist_pacific'].PoliceDoors[k].obj) then
                Config['heist_pacific'].PoliceDoors[k].obj = GetClosestObjectOfType(v.loc, 1.0, GetHashKey(v.model), false, false, false)
                Config['heist_pacific'].PoliceDoors[k].obj2 = GetClosestObjectOfType(v.loc, 1.0, GetHashKey(v.model2), false, false, false)
            end
        end
        Wait(1000)
    end
end)

CreateThread(function()
    while true do
        wait = 750;
        local coords = GetEntityCoords(PlayerPedId())
        local doortext = nil;
        local state = nil;

        for k, v in ipairs(Config['heist_pacific'].PoliceDoors) do
            local dst = GetDistanceBetweenCoords(coords, v.loc, true)

            if dst <= 50 then
                wait = 1;
                if v.locked then
                    FreezeEntityPosition(v.obj, true)
                    doortext = "[~r~E~w~] Déverouiller la porte"
                    state = false
                elseif not v.locked then
                    FreezeEntityPosition(v.obj, false)
                    doortext = "[~r~E~w~] Verouiller la porte"
                    state = true
                end
                for k,v in pairs(Config['heist_pacific'].PoliceJobs) do
                    if Framework.PlayerData.jobs['job'].name == v then
                        if dst <= 1.5 then
                            local x, y, z = table.unpack(v.loc)
    
                            Framework.ShowHelpNotification(doortext)
                            if IsControlJustReleased(0, 38)  then
                                exports["ac"]:ExecuteServerEvent("heist_pacific:policeDoor", k, state)
                            end
                        end
                    end
                end
            end
        end

        Wait(wait)
    end
end)

CreateThread(function() 
    while true do
        wait = 2500;
        if PacificHeist.PlaySound then 
            wait = 500;
            local lCoords = GetEntityCoords(GetPlayerPed(-1)) 
            local eCoords = vector3(257.10, 220.30, 106.28) 
            local distIs  = Vdist(lCoords.x, lCoords.y, lCoords.z, eCoords) 
            
            if(distIs <= 50) then 
                SendNUIMessage({transactionType = 'playSound'}) 
                Wait(28000) 
            else 
                SendNUIMessage({transactionType = 'stopSound'}) 
            end 
        end 
        Wait(wait)
    end 
end)

CreateThread(function() 
    while Framework.PlayerData.jobs == nil do Wait(100) end
    PacificHeist:GetInfo() 
end)

CreateThread(function()
    local blip = AddBlipForCoord(283.29, 224.58, 104.6)
    SetBlipSprite(blip, 134)
    SetBlipColour(blip, 1)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Braquage Pacific Standard")
    EndTextCommandSetBlipName(blip)
    
end)