
function PacificHeist:GetInfo()
    Framework.TriggerServerCallback("heist_pacific:GetData", function(output)
        self.info = output
        self:HandleInfo()
    end)
end

function PacificHeist:HandleInfo()
    local canAccess = true;
    for k,v in pairs(Config['heist_pacific'].PoliceJobs) do
        if Framework.PlayerData.jobs['job'].name == v then
            canAccess = false;
        end
    end

    if canAccess then
        if self.info.stage == 0 then
            CreateThread(function()
                while true do
                    wait = 1500;

                    local plyPed = PlayerPedId()
                    local myCoords = GetEntityCoords(plyPed)
                    local dist =  Vdist(myCoords, Config['heist_pacific'].loudstart.x, Config['heist_pacific'].loudstart.y, Config['heist_pacific'].loudstart.z)

                    if dist < 6 then
                        wait = 1;
                        Framework.ShowHelpNotification(Config['heist_pacific'].text.loudstart)
                        if dist <= 1 and IsControlJustReleased(0,38) then
                            Framework.TriggerServerCallback("heist_pacific:startevent", function(output)
                                if output == true then
                                    Config['heist_pacific'].initiator = true
                                    self.info.stage = 1
                                    self.info.style = 1
                                    Config['heist_pacific'].currentplant = 0
                                    self:Plant()
                                elseif output ~= true then
                                    Framework.ShowNotification(output)
                                end
                            end, 1)
                        end
                    end
                        
                    local dist2 = Vdist(myCoords, Config['heist_pacific'].silentstart.x, Config['heist_pacific'].silentstart.y, Config['heist_pacific'].silentstart.z)

                    if dist2 < 6 then
                        wait = 1;
                        Framework.ShowHelpNotification(Config['heist_pacific'].text.silentstart)
                        
                        if dist2 <= 1 and  IsControlJustReleased(0,38) then
                            Framework.TriggerServerCallback("heist_pacific:startevent", function(output)
                                if output == true then
                                    Config['heist_pacific'].initiator = true
                                    self.info.stage = 1
                                    self.info.style = 2
                                    Config['heist_pacific'].currentpick = 0
                                    self:Lockpick()
                                elseif output ~= true then
                                    Framework.ShowNotification(output)
                                end
                            end, 2)
                        end
                    end

                    if Config['heist_pacific'].stage0break then
                        Config['heist_pacific'].stage0break = false;
                        break
                    end
                    Wait(wait)
                end
            end)
        elseif self.info.stage == 1 then
            if Config['heist_pacific'].initiator then
                if self.info.style == 1 then
                    CreateThread(function()
                        while true do
                            wait = 1500;

                            local plyPed = PlayerPedId()
                            local myCoords = GetEntityCoords(plyPed)

                            if not Config['heist_pacific'].checks.hack1 then
                                local dist = Vdist(myCoords, Config['heist_pacific'].hack1.x, Config['heist_pacific'].hack1.y, Config['heist_pacific'].hack1.z)

                                if dist < 4 then
                                    wait = 1;
                                    Framework.ShowHelpNotification(Config['heist_pacific'].text.usehack)
                                    if dist <= 1 and IsControlJustReleased(0, 38) then
                                        Framework.TriggerServerCallback("heist_pacific:checkItem", function(output)
                                            if output then
                                                Config['heist_pacific'].checks.hack1 = true
                                                Config['heist_pacific'].currenthack = 0
                                                self:Hack()
                                            elseif not output then
                                                Framework.ShowNotification("Vous n'avez pas d'ordinateur.")
                                            end
                                        end, "laptop_h")
                                    end
                                end
                            end
                            if Config['heist_pacific'].checks.hack1 and not Config['heist_pacific'].checks.hack2 then
                                local dist = Vdist(myCoords, Config['heist_pacific'].hack2.x, Config['heist_pacific'].hack2.y, Config['heist_pacific'].hack2.z)

                                if dist < 4 then
                                    wait = 1;
                                    Framework.ShowHelpNotification(Config['heist_pacific'].text.usehack)
                                    if dist <= 1 and IsControlJustReleased(0, 38) then
                                        Framework.TriggerServerCallback("heist_pacific:checkItem", function(output)
                                            if output then
                                                Config['heist_pacific'].checks.hack2 = true
                                                self.info.stage = 2
                                                Config['heist_pacific'].currenthack = 1
                                                self:Hack()
                                            elseif not output then
                                                Framework.ShowNotification("Vous n'avez pas d'ordinateur.")
                                            end
                                        end, "laptop_h")
                                    end
                                end
                            end
                            if Config['heist_pacific'].stage1break then
                                Config['heist_pacific'].stage1break = false
                                break
                            end
                            Wait(wait)
                        end
                    end)
                elseif self.info.style == 2 then
                    CreateThread(function()
                        while true do
                            wait = 1500;
                            
                            local plyPed = PlayerPedId()
                            local myCoords = GetEntityCoords(plyPed)

                            if not Config['heist_pacific'].checks.id1 then
                                local dist = Vdist(myCoords, Config['heist_pacific'].card1.x, Config['heist_pacific'].card1.y, Config['heist_pacific'].card1.z)

                                if dist < 4 then
                                    wait = 1;
                                    Framework.ShowHelpNotification(Config['heist_pacific'].text.usecard)
                                    if dist <= 1 and IsControlJustReleased(0, 38) then
                                        Framework.TriggerServerCallback("heist_pacific:checkItem", function(output)
                                        if output then
                                            Config['heist_pacific'].checks.id1 = true
                                            Config['heist_pacific'].currentid = 1
                                            self:IdCard()
                                        elseif not output then
                                            Framework.ShowNotification("Vous n'avez pas de carte d'identification.")
                                        end
                                        end, "id_card")
                                    end
                                end
                            end
                            if not Config['heist_pacific'].searchinfo.found then
                                for i = 1, #Config['heist_pacific'].searchlocations, 1 do
                                    if not Config['heist_pacific'].searchlocations[i].status then
                                        if GetDistanceBetweenCoords(coords, Config['heist_pacific'].searchlocations[i].coords.x, Config['heist_pacific'].searchlocations[i].coords.y, Config['heist_pacific'].searchlocations[i].coords.z, true) <= 2.2 then
                                            wait = 1;
                                            Framework.ShowHelpNotification(Config['heist_pacific'].text.usesearch)
                                            if IsControlJustReleased(0, 38) then
                                                PacificHeist:Search(Config['heist_pacific'].searchlocations[i])
                                                Citizen.Wait(1000)
                                            end
                                        end
                                    end
                                end
                            end
                            if Config['heist_pacific'].checks.id1 and not Config['heist_pacific'].checks.id2 then
                                local dist = Vdist(myCoords, Config['heist_pacific'].card2.x, Config['heist_pacific'].card2.y, Config['heist_pacific'].card2.z)

                                if dist < 4 then
                                    wait = 1;
                                    Framework.ShowHelpNotification(Config['heist_pacific'].text.usecard)
                                    if dist <= 1 and IsControlJustReleased(0, 38) then
                                        Framework.TriggerServerCallback("heist_pacific:checkItem", function(output)
                                        if output then
                                            exports["ac"]:ExecuteServerEvent("heist_pacific:removeitem", "id_card")
                                            Config['heist_pacific'].checks.id2 = true
                                            Config['heist_pacific'].currentid = 2
                                            self:IdCard()
                                        elseif not output then
                                            Framework.ShowNotification("Vous n'avez pas de carte d'identification.")
                                        end
                                        end, "id_card")
                                    end
                                end
                            end
                            if Config['heist_pacific'].stage1break then
                                Config['heist_pacific'].stage1break = false
                                break
                            end
                            Wait(wait)
                        end
                    end)
                end
            end
        elseif self.info.stage == 2 then
            if Config['heist_pacific'].initiator then
                if self.info.style == 1 then
                    CreateThread(function()
                        while true do
                            wait = 1500;
                            
                            local plyPed = PlayerPedId()
                            local myCoords = GetEntityCoords(plyPed)

                            if not Config['heist_pacific'].checks.thermal1 then
                                local dist = Vdist(myCoords, Config['heist_pacific'].thermal1.x, Config['heist_pacific'].thermal1.y, Config['heist_pacific'].thermal1.z)

                                if dist <= 4 then
                                    wait = 1;
                                    Framework.ShowHelpNotification(Config['heist_pacific'].text.usethermal)
                                    if dist <= 1 and IsControlJustReleased(0, 38) then
                                        Framework.TriggerServerCallback("heist_pacific:checkItem", function(output)
                                            if output then
                                                exports["ac"]:ExecuteServerEvent("heist_pacific:removeitem", "thermal_charge")
                                                Config['heist_pacific'].checks.thermal1 = true
                                                Config['heist_pacific'].currentplant = 1
                                                self:Plant()
                                            elseif not output then
                                                Framework.ShowNotification("Vous n'avez pas de charges thermique.")
                                            end
                                        end, "thermal_charge")
                                    end
                                end
                            end
                            if Config['heist_pacific'].checks.thermal1 and not Config['heist_pacific'].checks.thermal2 then
                                local dist = Vdist(myCoords, Config['heist_pacific'].thermal2.x, Config['heist_pacific'].thermal2.y, Config['heist_pacific'].thermal2.z)

                                if dist <= 4 then
                                    wait = 1;
                                    Framework.ShowHelpNotification(Config['heist_pacific'].text.usethermal)
                                    if dist <= 1 and IsControlJustReleased(0, 38) then
                                        Framework.TriggerServerCallback("heist_pacific:checkItem", function(output)
                                            if output then
                                                exports["ac"]:ExecuteServerEvent("heist_pacific:removeitem", "thermal_charge")
                                                Config['heist_pacific'].checks.thermal2 = true
                                                Config['heist_pacific'].currentplant = 2
                                                self:Plant()
                                            elseif not output then
                                                Framework.ShowNotification("Vous n'avez pas de charges thermique.")
                                            end
                                        end, "thermal_charge")
                                    end
                                end
                            end
                            if Config['heist_pacific'].stage2break then
                                Config['heist_pacific'].stage2break = false
                                break
                            end
                            Wait(wait)
                        end
                    end)
                elseif self.info.style == 2 then
                    if Config['heist_pacific'].initiator then
                        CreateThread(function()
                            while true do
                                wait = 1500;
                            
                                local plyPed = PlayerPedId()
                                local myCoords = GetEntityCoords(plyPed)

                                if not Config['heist_pacific'].checks.lockpick1 then
                                    local dist = Vdist(myCoords, Config['heist_pacific'].lockpick1.x, Config['heist_pacific'].lockpick1.y, Config['heist_pacific'].lockpick1.z)

                                    if dist < 4 then
                                        wait = 1;
                                        Framework.ShowHelpNotification(Config['heist_pacific'].text.uselockpick)
                                        if dist <= 1 and IsControlJustReleased(0, 38) then
                                            Framework.TriggerServerCallback("heist_pacific:checkItem", function(output)
                                                if output then
                                                    exports["ac"]:ExecuteServerEvent("heist_pacific:removeitem", "lockpick")
                                                    Config['heist_pacific'].checks.lockpick1 = true
                                                    Config['heist_pacific'].currentpick = 1
                                                    self:Lockpick()
                                                elseif not output then
                                                    Framework.ShowNotification("Vous n'avez pas de lockpicks.")
                                                end
                                            end, "lockpick")
                                        end
                                    end
                                end
                                if not Config['heist_pacific'].checks.lockpick2 then
                                    local dist = Vdist(myCoords, Config['heist_pacific'].lockpick2.x, Config['heist_pacific'].lockpick2.y, Config['heist_pacific'].lockpick2.z)

                                    if dist < 4 then
                                        wait = 1;
                                        Framework.ShowHelpNotification(Config['heist_pacific'].text.uselockpick)
                                        if dist <= 1 and IsControlJustReleased(0, 38) then
                                            Framework.TriggerServerCallback("heist_pacific:checkItem", function(output)
                                                if output then
                                                    exports["ac"]:ExecuteServerEvent("heist_pacific:removeitem", "lockpick")
                                                    Config['heist_pacific'].checks.lockpick2 = true
                                                    Config['heist_pacific'].currentpick = 2
                                                    self:Lockpick()
                                                elseif not output then
                                                    Framework.ShowNotification("Vous n'avez pas de lockpicks.")
                                                end
                                            end, "lockpick")
                                        end
                                    end
                                end
                                if Config['heist_pacific'].stage2break then
                                    Config['heist_pacific'].stage2break = false
                                    break
                                end
                                Wait(wait)
                            end
                        end)
                    end
                end
            end
        end
    end
end

function PacificHeist:Initialize(scaleform)
    local scaleform = RequestScaleformMovieInteractive(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do Wait(100) end

    local CAT = 'hack';
    local CurrentSlot = 0;
    while HasAdditionalTextLoaded(CurrentSlot) and not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
        Wait(100)
        CurrentSlot = CurrentSlot + 1
    end

    if not HasThisAdditionalTextLoaded(CAT, CurrentSlot) then
        ClearAdditionalText(CurrentSlot, true)
        RequestAdditionalText(CAT, CurrentSlot)
        while not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do Wait(100) end
    end

    PushScaleformMovieFunction(scaleform, "SET_LABELS")
    PacificHeist:ScaleformLabel("H_ICON_1")
    PacificHeist:ScaleformLabel("H_ICON_2")
    PacificHeist:ScaleformLabel("H_ICON_3")
    PacificHeist:ScaleformLabel("H_ICON_4")
    PacificHeist:ScaleformLabel("H_ICON_5")
    PacificHeist:ScaleformLabel("H_ICON_6")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND")
    PushScaleformMovieFunctionParameterInt(1)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "ADD_PROGRAM")
    PushScaleformMovieFunctionParameterFloat(1.0)
    PushScaleformMovieFunctionParameterFloat(4.0)
    PushScaleformMovieFunctionParameterString("My Computer")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "ADD_PROGRAM")
    PushScaleformMovieFunctionParameterFloat(6.0)
    PushScaleformMovieFunctionParameterFloat(6.0)
    PushScaleformMovieFunctionParameterString("Power Off")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_LIVES")
    PushScaleformMovieFunctionParameterInt(PacificHeist.lives)
    PushScaleformMovieFunctionParameterInt(5)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(math.random(150,255))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(1)
    PushScaleformMovieFunctionParameterInt(math.random(160,255))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(2)
    PushScaleformMovieFunctionParameterInt(math.random(170,255))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(3)
    PushScaleformMovieFunctionParameterInt(math.random(190,255))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(4)
    PushScaleformMovieFunctionParameterInt(math.random(200,255))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(5)
    PushScaleformMovieFunctionParameterInt(math.random(210,255))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(6)
    PushScaleformMovieFunctionParameterInt(math.random(220,255))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(7)
    PushScaleformMovieFunctionParameterInt(255)
    PopScaleformMovieFunctionVoid()
    return scaleform
end

function PacificHeist:Plant()
    Config['heist_pacific'].disableinput = true;

    local loc = {x,y,z,h}
    local ptfx
    local method
    local rotplus = 0
    local oldmodel
    local newmodel

    if Config['heist_pacific'].currentplant == 0 then
        Config['heist_pacific'].stage0break = true;
        loc.x = 257.40
        loc.y = 220.20
        loc.z = 106.35
        loc.h = 336.48
        ptfx = vector3(257.39, 221.20, 106.29)
        oldmodel = "hei_v_ilev_bk_gate_pris"
        newmodel = "hei_v_ilev_bk_gate_molten"
        method = 1
    elseif Config['heist_pacific'].currentplant == 1 then
        loc.x = 252.95
        loc.y = 220.70
        loc.z = 101.76
        loc.h = 160
        ptfx = vector3(252.985, 221.70, 101.72)
        oldmodel = "hei_v_ilev_bk_safegate_pris"
        newmodel = "hei_v_ilev_bk_safegate_molten"
        rotplus = 170.0
        method = 2
    elseif Config['heist_pacific'].currentplant == 2 then
        loc.x = 261.65
        loc.y = 215.60
        loc.z = 101.76
        loc.h = 252
        ptfx = vector3(261.68, 216.63, 101.75)
        oldmodel = "hei_v_ilev_bk_safegate_pris"
        newmodel = "hei_v_ilev_bk_safegate_molten"
        rotplus = 270.0
        method = 3
    end

    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Wait(50)
    end
    local ped = PlayerPedId()

    SetEntityHeading(ped, loc.h)
    Wait(100)
    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
    local bagscene = NetworkCreateSynchronisedScene(loc.x, loc.y, loc.z, rotx, roty, rotz + rotplus, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), loc.x, loc.y, loc.z,  true,  true, false)

    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    PacificHeist:Process(4500, Config['heist_pacific'].text.thermal)
    Wait(1500)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local bomba = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.2,  true,  true, true)

    SetEntityCollision(bomba, false, true)
    AttachEntityToEntity(bomba, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Wait(4000)
    PacificHeist:Process(12000, Config['heist_pacific'].text.burning)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 113, 0, 0)
    DetachEntity(bomba, 1, 1)
    FreezeEntityPosition(bomba, true)
    exports["ac"]:ExecuteServerEvent("heist_pacific:ptfx", method)
    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", ptfx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

    NetworkStopSynchronisedScene(bagscene)
    Config['heist_pacific'].disableinput = false
    if Config['heist_pacific'].currentplant == 0 then
        exports["ac"]:ExecuteServerEvent("heist_pacific:fixdoor", Config['heist_pacific'].doorchecks[1].h, vector3(Config['heist_pacific'].doorchecks[1].x, Config['heist_pacific'].doorchecks[1].y, Config['heist_pacific'].doorchecks[1].z), Config['heist_pacific'].doorchecks[1].he)
    elseif Config['heist_pacific'].currentplant == 1 then
        exports["ac"]:ExecuteServerEvent("heist_pacific:fixdoor", Config['heist_pacific'].doorchecks[4].h, vector3(Config['heist_pacific'].doorchecks[4].x, Config['heist_pacific'].doorchecks[4].y, Config['heist_pacific'].doorchecks[4].z), Config['heist_pacific'].doorchecks[4].he)
    elseif Config['heist_pacific'].currentplant == 2 then
        exports["ac"]:ExecuteServerEvent("heist_pacific:fixdoor", Config['heist_pacific'].doorchecks[5].h, vector3(Config['heist_pacific'].doorchecks[5].x, Config['heist_pacific'].doorchecks[5].y, Config['heist_pacific'].doorchecks[5].z), Config['heist_pacific'].doorchecks[5].he)
    end
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
    Citizen.Wait(2000)
    ClearPedTasks(ped)
    Citizen.Wait(2000)
    if Config['heist_pacific'].currentplant == 0 then
        exports["ac"]:ExecuteServerEvent("heist_pacific:alarm_s", 1)
    end
    DeleteObject(bomba)
    exports["ac"]:ExecuteServerEvent("heist_pacific:moltgate", loc.x, loc.y, loc.z, oldmodel, newmodel)
    Citizen.Wait(9000)
    Framework.ShowNotification(Config['heist_pacific'].text.melted)
    StopParticleFxLooped(effect, 0)
    if Config['heist_pacific'].currentplant == 0 then
        --TriggerServerEvent("heist_pacific:toggleDoor", newmodel, vector3(Config['heist_pacific'].loudstart.x, Config['heist_pacific'].loudstart.y, Config['heist_pacific'].loudstart.z), false)
        exports["ac"]:ExecuteServerEvent("heist_pacific:policeDoor", 1, false)
        self:HandleInfo()
    elseif Config['heist_pacific'].currentplant == 1 then
        --TriggerServerEvent("heist_pacific:toggleDoor", newmodel, vector3(Config['heist_pacific'].inside1.x, Config['heist_pacific'].inside1.y, Config['heist_pacific'].inside1.z), false)
        exports["ac"]:ExecuteServerEvent("heist_pacific:policeDoor", 4, false)
    elseif Config['heist_pacific'].currentplant == 2 then
        --TriggerServerEvent("heist_pacific:toggleDoor", newmodel, vector3(Config['heist_pacific'].inside2.x, Config['heist_pacific'].inside2.y, Config['heist_pacific'].inside2.z), false)
        exports["ac"]:ExecuteServerEvent("heist_pacific:policeDoor", 5, false)
    end
end

function PacificHeist:Lockpick()
    Config['heist_pacific'].disableinput = true
    local loc = {x, y, z, h}
    if Config['heist_pacific'].currentpick == 0 then
        loc.x = 236.22
        loc.y = 227.50
        loc.z = 105.00
        loc.h = 336.56
    elseif Config['heist_pacific'].currentpick == 1 then
        loc.x = 253.28
        loc.y = 221.25
        loc.z = 100.50
        loc.h = 155.11
    elseif Config['heist_pacific'].currentpick == 2 then
        loc.x = 260.91
        loc.y = 215.93
        loc.z = 100.50
        loc.h = 248.54
    end
    local ped = PlayerPedId()
    local animDict = "mp_arresting"

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        RequestAnimDict(animDict)
        Wait(10)
    end
    SetEntityCoords(ped, loc.x, loc.y, loc.z, 1, 0, 0, 1)
    SetEntityHeading(ped, loc.h)
    TaskPlayAnim(ped, animDict, "a_uncuff", 8.0, 8.0, 6000, 1, 1, 0, 0, 0)
    PacificHeist:Process(6000, Config['heist_pacific'].text.lockpick..": Stage 1")
    Citizen.Wait(6500)
    Framework.ShowNotification("Stage 1 "..Config['heist_pacific'].text.stage)
    SetEntityCoords(ped, loc.x, loc.y, loc.z, 1, 0, 0, 1)
    SetEntityHeading(ped, loc.h)
    TaskPlayAnim(ped, animDict, "a_uncuff", 8.0, 8.0, 6000, 1, 1, 0, 0, 0)
    PacificHeist:Process(6000, Config['heist_pacific'].text.lockpick..": Stage 2")
    Citizen.Wait(6500)
    Framework.ShowNotification("Stage 2 "..Config['heist_pacific'].text.stage)
    Framework.ShowNotification(Config['heist_pacific'].text.unlocked)
    Config['heist_pacific'].disableinput = false
    if Config['heist_pacific'].currentpick == 0 then
        Config['heist_pacific'].stage0break = true
        --TriggerServerEvent("heist_pacific:toggleDoor", Config['heist_pacific'].silentstart.type, vector3(Config['heist_pacific'].silentstart.x, Config['heist_pacific'].silentstart.y, Config['heist_pacific'].silentstart.z), false, Config['heist_pacific'].silentstart.h)
        exports["ac"]:ExecuteServerEvent("heist_pacific:policeDoor", 2, false)
        self:HandleInfo()
    elseif Config['heist_pacific'].currentpick == 1 then
        --TriggerServerEvent("heist_pacific:toggleDoor", Config['heist_pacific'].inside1.type, vector3(Config['heist_pacific'].inside1.x, Config['heist_pacific'].inside1.y, Config['heist_pacific'].inside1.z), false, Config['heist_pacific'].inside1.h)
        exports["ac"]:ExecuteServerEvent("heist_pacific:policeDoor", 4, false)
    elseif Config['heist_pacific'].currentpick == 2 then
        --TriggerServerEvent("heist_pacific:toggleDoor", Config['heist_pacific'].inside1.type, vector3(Config['heist_pacific'].inside2.x, Config['heist_pacific'].inside2.y, Config['heist_pacific'].inside2.z), false, Config['heist_pacific'].inside2.h)
        exports["ac"]:ExecuteServerEvent("heist_pacific:policeDoor", 5, false)
    end
end

function PacificHeist:Hack()
    Config['heist_pacific'].hackfinish = false;
    local loc = {x,y,z,h}

    if Config['heist_pacific'].currenthack == 0 then
        Config['heist_pacific'].hackmethod = 1
        loc.x = 262.65
        loc.y = 222.75
        loc.z = 105.90
        loc.h = 244.19
    elseif Config['heist_pacific'].currenthack == 1 then
        Config['heist_pacific'].hackmethod = 2
        loc.x = 253.34
        loc.y = 228.25
        loc.z = 101.39
        loc.h = 63.60
    end
    local animDict = "anim@heists@ornate_bank@hack"

    RequestAnimDict(animDict)
    RequestModel("hei_prop_hst_laptop")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestModel("hei_prop_heist_card_hack_02")
    while not HasAnimDictLoaded(animDict)
        or not HasModelLoaded("hei_prop_hst_laptop")
        or not HasModelLoaded("hei_p_m_bag_var22_arm_s")
        or not HasModelLoaded("hei_prop_heist_card_hack_02") do
        Wait(100)
    end
    local ped = PlayerPedId()
    local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))

    SetEntityHeading(ped, loc.h)
    local animPos = GetAnimInitialOffsetPosition(animDict, "hack_enter", loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)
    local animPos2 = GetAnimInitialOffsetPosition(animDict, "hack_loop", loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)
    local animPos3 = GetAnimInitialOffsetPosition(animDict, "hack_exit", loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)

    FreezeEntityPosition(ped, true)
    local netScene = NetworkCreateSynchronisedScene(animPos, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), targetPosition, 1, 1, 0)
    local laptop = CreateObject(GetHashKey("hei_prop_hst_laptop"), targetPosition, 1, 1, 0)
    local card = CreateObject(GetHashKey("hei_prop_heist_card_hack_02"), targetPosition, 1, 1, 0)

    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "hack_enter", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene, animDict, "hack_enter_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene, animDict, "hack_enter_laptop", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(card, netScene, animDict, "hack_enter_card", 4.0, -8.0, 1)

    local netScene2 = NetworkCreateSynchronisedScene(animPos2, targetRotation, 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, "hack_loop", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, "hack_loop_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene2, animDict, "hack_loop_laptop", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(card, netScene2, animDict, "hack_loop_card", 4.0, -8.0, 1)

    local netScene3 = NetworkCreateSynchronisedScene(animPos3, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene3, animDict, "hack_exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene3, animDict, "hack_exit_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene3, animDict, "hack_exit_laptop", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(card, netScene3, animDict, "hack_exit_card", 4.0, -8.0, 1)

    SetPedComponentVariation(ped, 5, 0, 0, 0)
    Wait(200)
    NetworkStartSynchronisedScene(netScene)
    Wait(6300)
    NetworkStartSynchronisedScene(netScene2)
    Wait(2000)
    PacificHeist:Brute()
    Framework.ShowNotification("Ouvrer l'ordinateur et navigué sur HackConnect.exe")
    while not Config['heist_pacific'].hackfinish do Wait(100) end
    Wait(1500)
    NetworkStartSynchronisedScene(netScene3)
    Wait(4600)
    NetworkStopSynchronisedScene(netScene3)
    DeleteObject(bag)
    DeleteObject(laptop)
    DeleteObject(card)
    FreezeEntityPosition(ped, false)
    SetPedComponentVariation(ped, 5, 113, 0, 0)
end

function PacificHeist:IdCard()
    Config['heist_pacific'].disableinput = true
    RequestModel("p_ld_id_card_01")
    while not HasModelLoaded("p_ld_id_card_01") do
        Citizen.Wait(1)
    end
    local ped = PlayerPedId()
    if Config['heist_pacific'].currentid == 1 then
        SetEntityCoords(ped, 261.89, 223.5, 105.30, 1, 0, 0, 1)
        SetEntityHeading(ped, 255.92)
    elseif Config['heist_pacific'].currentid == 2 then
        SetEntityCoords(ped, 253.39, 228.12, 100.75, 1, 0, 0, 1)
        SetEntityHeading(ped, 71.72)
    end
    Citizen.Wait(100)
    local pedco = GetEntityCoords(PlayerPedId())
    local IdProp = CreateObject(GetHashKey("p_ld_id_card_01"), pedco, true, true, false)
    local boneIndex = GetPedBoneIndex(PlayerPedId(), 28422)
    --local panel = Framework.Game.GetClosestObject(("hei_prop_hei_securitypanel"), pedco)
    local panel = GetClosestObjectOfType(pedco, 4.0, GetHashKey("hei_prop_hei_securitypanel"), false, false, false)

    AttachEntityToEntity(IdProp, ped, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_ATM", 0, true)
    PacificHeist:Process(2000, Config['heist_pacific'].text.card)
    Citizen.Wait(1500)
    AttachEntityToEntity(IdProp, panel, boneIndex, -0.09, -0.02, -0.08, 270.0, 0.0, 270.0, true, true, false, true, 1, true)
    FreezeEntityPosition(IdProp)
    Citizen.Wait(500)
    ClearPedTasksImmediately(ped)
    Citizen.Wait(1500)
    PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    if Config['heist_pacific'].currentid == 1 then
        Config['heist_pacific'].disableinput = false
        Framework.ShowNotification(Config['heist_pacific'].text.unlocked)
        --TriggerServerEvent("heist_pacific:toggleDoor", Config['heist_pacific'].hack1.type, vector3(Config['heist_pacific'].hack1.x, Config['heist_pacific'].hack1.y, Config['heist_pacific'].hack1.z), false, Config['heist_pacific'].hack1.h)
        exports["ac"]:ExecuteServerEvent("heist_pacific:policeDoor", 3, false)
    elseif Config['heist_pacific'].currentid == 2 then
        Config['heist_pacific'].stage1break = true
        Config['heist_pacific'].disableinput = false
        PacificHeist:Process(4000, Config['heist_pacific'].text.using)
        local count = 4
        repeat
            Citizen.Wait(1000)
            count = count - 1
        until count == 0
        Framework.ShowNotification(Config['heist_pacific'].text.used)
        PacificHeist:SpawnObj()
        exports["ac"]:ExecuteServerEvent("heist_pacific:openvault", 1)
        TriggerEvent("heist_pacific:vaulttimer", 2)
        exports["ac"]:ExecuteServerEvent("heist_pacific:alarm_s", 1)
        self.info.stage = 2
        self.info.style = 2
        self:HandleInfo()
    end
end

function PacificHeist:SpawnObj()
    if not Config['heist_pacific'].enablextras then
        RequestModel("hei_prop_hei_cash_trolly_01")
        Citizen.Wait(100)
        Trolley1 = CreateObject(269934519, 257.44, 215.07, 100.68, 1, 0, 0)
        Trolley2 = CreateObject(269934519, 262.34, 213.28, 100.68, 1, 0, 0)
        Trolley3 = CreateObject(269934519, 263.45, 216.05, 100.68, 1, 0, 0)
        local heading = GetEntityHeading(Trolley3)

        SetEntityHeading(Trolley3, heading + 150)
    elseif Config['heist_pacific'].enablextras then
        RequestModel("hei_prop_hei_cash_trolly_01")
        RequestModel("ch_prop_gold_trolly_01a")
        Citizen.Wait(100)
        Trolley1 = CreateObject(269934519, 257.44, 215.07, 100.68, 1, 0, 0)
        Trolley2 = CreateObject(269934519, 262.34, 213.28, 100.68, 1, 0, 0)
        Trolley3 = CreateObject(269934519, 263.45, 216.05, 100.68, 1, 0, 0)
        Trolley4 = CreateObject(2007413986, 266.02, 215.34, 100.68, 1, 0, 0)
        Trolley5 = CreateObject(881130828, 265.11, 212.05, 100.68, 1, 0, 0)
        local heading = GetEntityHeading(Trolley3)
        local heading2 = GetEntityHeading(Trolley4)

        SetEntityHeading(Trolley3, heading + 150)
        SetEntityHeading(Trolley4, heading2 + 150)
    end
    exports["ac"]:ExecuteServerEvent("heist_pacific:startloot")
end

function PacificHeist:Loot(currentgrab)
    Grab2clear = false
    Grab3clear = false
    Config['heist_pacific'].grabber = true
    Trolley = nil
    local ped = PlayerPedId()
    local model = "hei_prop_heist_cash_pile"

    if currentgrab == 1 then
        Trolley = GetClosestObjectOfType(257.44, 215.07, 100.68, 1.0, 269934519, false, false, false)
    elseif currentgrab == 2 then
        Trolley = GetClosestObjectOfType(262.34, 213.28, 100.68, 1.0, 269934519, false, false, false)
    elseif currentgrab == 3 then
        Trolley = GetClosestObjectOfType(263.45, 216.05, 100.68, 1.0, 269934519, false, false, false)
    elseif currentgrab == 4 then
        Trolley = GetClosestObjectOfType(266.02, 215.34, 100.68, 1.0, 2007413986, false, false, false)
        model = "ch_prop_gold_bar_01a"
    elseif currentgrab == 5 then
        Trolley = GetClosestObjectOfType(265.11, 212.05, 100.68, 1.0, 881130828, false, false, false)
        model = "ch_prop_vault_dimaondbox_01a"
    end
	local CashAppear = function()
	    local pedCoords = GetEntityCoords(ped)
        local grabmodel = GetHashKey(model)

        RequestModel(grabmodel)
        while not HasModelLoaded(grabmodel) do
            Citizen.Wait(100)
        end
	    local grabobj = CreateObject(grabmodel, pedCoords, true)

	    FreezeEntityPosition(grabobj, true)
	    SetEntityInvincible(grabobj, true)
	    SetEntityNoCollisionEntity(grabobj, ped)
	    SetEntityVisible(grabobj, false, false)
	    AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
	    local startedGrabbing = GetGameTimer()

	    Citizen.CreateThread(function()
		    while GetGameTimer() - startedGrabbing < 37000 do
			    Citizen.Wait(1)
			    DisableControlAction(0, 73, true)
			    if HasAnimEventFired(ped, GetHashKey("CASH_APPEAR")) then
				    if not IsEntityVisible(grabobj) then
					    SetEntityVisible(grabobj, true, false)
				    end
			    end
			    if HasAnimEventFired(ped, GetHashKey("RELEASE_CASH_DESTROY")) then
				    if IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, false, false)
                        if currentgrab < 4 then
                            exports["ac"]:ExecuteServerEvent("heist_pacific:rewardCash")
                        elseif currentgrab == 4 then
                            exports["ac"]:ExecuteServerEvent("heist_pacific:rewardGold")
                        elseif currentgrab == 5 then
                            exports["ac"]:ExecuteServerEvent("heist_pacific:rewardDia")
                        end
				    end
			    end
		    end
		    DeleteObject(grabobj)
	    end)
    end
    local emptyobj = 769923921

    if currentgrab == 4 or currentgrab == 5 then
        emptyobj = 2714348429
    end
	if IsEntityPlayingAnim(Trolley, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
		return
    end
    local baghash = GetHashKey("hei_p_m_bag_var22_arm_s")

    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(baghash)
    RequestModel(emptyobj)
    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and not HasModelLoaded(baghash) do
        Citizen.Wait(100)
    end
    while not NetworkHasControlOfEntity(Trolley) do
		Citizen.Wait(1)
		NetworkRequestControlOfEntity(Trolley)
	end
	GrabBag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), GetEntityCoords(PlayerPedId()), true, false, false)
    Grab1 = NetworkCreateSynchronisedScene(GetEntityCoords(Trolley), GetEntityRotation(Trolley), 2, false, false, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(ped, Grab1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(GrabBag, Grab1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
	NetworkStartSynchronisedScene(Grab1)
	Citizen.Wait(1500)
	CashAppear()
    if not Grab2clear then
        Grab2 = NetworkCreateSynchronisedScene(GetEntityCoords(Trolley), GetEntityRotation(Trolley), 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, Grab2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(GrabBag, Grab2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(Trolley, Grab2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
        NetworkStartSynchronisedScene(Grab2)
        Citizen.Wait(37000)
    end
    if not Grab3clear then
        Grab3 = NetworkCreateSynchronisedScene(GetEntityCoords(Trolley), GetEntityRotation(Trolley), 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, Grab3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(GrabBag, Grab3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
        NetworkStartSynchronisedScene(Grab3)
        NewTrolley = CreateObject(emptyobj, GetEntityCoords(Trolley) + vector3(0.0, 0.0, - 0.985), true, false, false)
        SetEntityRotation(NewTrolley, GetEntityRotation(Trolley))
        while not NetworkHasControlOfEntity(Trolley) do
            Citizen.Wait(1)
            NetworkRequestControlOfEntity(Trolley)
        end
        DeleteObject(Trolley)
        while DoesEntityExist(Trolley) do
            Citizen.Wait(1)
            DeleteObject(Trolley)
        end
        PlaceObjectOnGroundProperly(NewTrolley)
    end
	Citizen.Wait(1800)
	if DoesEntityExist(GrabBag) then
        DeleteEntity(GrabBag)
    end
    SetPedComponentVariation(ped, 5, 113, 0, 0)
	RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
	SetModelAsNoLongerNeeded(emptyobj)
	SetModelAsNoLongerNeeded(GetHashKey("hei_p_m_bag_var22_arm_s"))
end

function PacificHeist:Search(location)
    Config['heist_pacific'].disableinput = true
    RequestAnimDict('mp_arresting')
    while not HasAnimDictLoaded('mp_arresting') do
        Citizen.Wait(10)
    end
    PacificHeist:EnterAnim(vector3(location.coords.x, location.coords.y, location.coords.z))
    Citizen.Wait(1500)
    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
    PacificHeist:Process(15000, Config['heist_pacific'].text.search)
    Citizen.Wait(15000)
    if Config['heist_pacific'].searchinfo.random ~= 1 then
        location.status = true
        Framework.ShowNotification(Config['heist_pacific'].text.nothing)
        Config['heist_pacific'].searchinfo.random = math.random(1, Config['heist_pacific'].cur - 1)
        Config['heist_pacific'].cur = Config['heist_pacific'].cur - 1
    else
        Config['heist_pacific'].searchinfo.found = true
        Framework.ShowNotification(Config['heist_pacific'].text.found)
        exports["ac"]:ExecuteServerEvent("heist_pacific:giveidcard")
    end
    ClearPedTasks(PlayerPedId())
    Config['heist_pacific'].disableinput = false
end

function PacificHeist:Process(ms, text) 
    ProgressBars:startUI(ms, text) 
    Wait(ms) 
end

function PacificHeist:DrawText3D(x, y, z, text, scale) 
    local onScreen, _x, _y = World3dToScreen2d(x, y, z) 
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords()) 
    SetTextScale(scale, scale) 
    SetTextFont(4) 
    SetTextProportional(1) 
    SetTextEntry("STRING") 
    SetTextCentre(true) 
    SetTextColour(255, 255, 255, 215) 
    AddTextComponentString(text) 
    DrawText(_x, _y) 
    local factor = (string.len(text)) / 700 
    DrawRect(_x, _y + 0.0150, 0.095 + factor, 0.03, 41, 11, 41, 100) 
end

function PacificHeist:ShowVaultTimer() 
    SetTextFont(0) 
    SetTextProportional(0) 
    SetTextScale(0.42, 0.42) 
    SetTextDropShadow(0, 0, 0, 0,255) 
    SetTextEdge(1, 0, 0, 0, 255) 
    SetTextEntry("STRING") 
    AddTextComponentString("~r~"..Config['heist_pacific'].vaulttime.."~w~") 
    DrawText(0.682, 0.96) 
end

function PacificHeist:DisableControl() 
    DisableControlAction(0, 73, false) 
    DisableControlAction(0, 24, true) 
    DisableControlAction(0, 257, true) 
    DisableControlAction(0, 25, true) 
    DisableControlAction(0, 263, true) 
    DisableControlAction(0, 32, true) 
    DisableControlAction(0, 34, true) 
    DisableControlAction(0, 31, true) 
    DisableControlAction(0, 30, true) 
    DisableControlAction(0, 45, true) 
    DisableControlAction(0, 22, true) 
    DisableControlAction(0, 44, true) 
    DisableControlAction(0, 37, true) 
    DisableControlAction(0, 23, true) 
    DisableControlAction(0, 288, true) 
    DisableControlAction(0, 289, true) 
    DisableControlAction(0, 170, true) 
    DisableControlAction(0, 167, true) 
    DisableControlAction(0, 73, true) 
    DisableControlAction(2, 199, true) 
    DisableControlAction(0, 47, true) 
    DisableControlAction(0, 264, true) 
    DisableControlAction(0, 257, true) 
    DisableControlAction(0, 140, true) 
    DisableControlAction(0, 141, true) 
    DisableControlAction(0, 142, true) 
    DisableControlAction(0, 143, true) 
end

function PacificHeist:EnterAnim(coords) 
    TaskTurnPedToFaceCoord(PlayerPedId(), coords, 1000) 
end

function PacificHeist:Brute()
    PacificHeist.scaleform = PacificHeist:Initialize("HACKING_PC")
    PacificHeist.UsingComputer = true;
end
function PacificHeist:ScaleformLabel(label)
    BeginTextCommandScaleformString(label)
    EndTextCommandScaleformString()
end