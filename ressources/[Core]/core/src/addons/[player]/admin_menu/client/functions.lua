
AdminMenu.isfreecam, AdminMenu.isNoClip, AdminMenu.isShowNames, AdminMenu.isShowBlips, AdminMenu.isShowCoords = false, false, false, false
freecam = false
camera = nil
speed = 0.5
sensitivity = 8.0

local keys = {
   activate = 289, -- F2
   speedUp = 21,   -- SHIFT
   speedDown = 36, -- CTRL
   forward = 32,   -- W
   backward = 33,  -- S
   left = 34,      -- A
   right = 35,     -- D
   up = 55,        -- SPACE
   down = 44,      -- CTRL
   click = 24,     -- LMB
   delete = 47     -- G
}

local function CreateFreecam()
   local pos = GetGameplayCamCoord()
   local rot = GetGameplayCamRot(2)

   camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
   SetCamActive(camera, true)
   RenderScriptCams(true, false, 0, true, true)

   SetCamCoord(camera, pos)
   SetCamRot(camera, rot.x, rot.y, rot.z, 2)
   scaleform = AdminMenu.drawControls()
end

local function DestroyFreecam()
   if camera then
      SetCamActive(camera, false)
      RenderScriptCams(false, false, 0, true, true)
      DestroyCam(camera, true)
      camera = nil

      SetGameplayCamRelativeRotation(0.0, 0.0, 0.0)

      if scaleform then
        SetScaleformMovieAsNoLongerNeeded(scaleform)
        scaleform = nil
    end
   end
end

local function GetCameraDirectionVectors(rotation)
    local z = math.rad(rotation.z)
    local x = math.rad(rotation.x)
    local num = math.abs(math.cos(x))

    local forward = vector3(
        -math.sin(z) * num,
        math.cos(z) * num,
        math.sin(x)
    )

    local right = vector3(
        math.cos(z),
        math.sin(z),
        0.0
    )

    local up = vector3(
        -math.sin(z) * math.sin(x),
        math.cos(z) * math.sin(x),
        math.cos(x)
    )

    return forward, right, up
end

local function DrawCrosshair()
    local screenX = 0.5
    local screenY = 0.5
    
    local length = 0.01  
    local thickness = 0.002  
    local gap = 0.005  
    local r, g, b, a = 255, 255, 255, 255  
    
    DrawRect(screenX, screenY, thickness, thickness, r, g, b, a)
end

ENTITY_TYPE_PED = 1
ENTITY_TYPE_VEHICLE = 2
ENTITY_TYPE_OBJECT = 3

function IsValidEntityType(entity)
    if entity == 0 then return false end
    
    local entityType = GetEntityType(entity)
    return entityType == ENTITY_TYPE_PED or 
           entityType == ENTITY_TYPE_VEHICLE or 
           entityType == ENTITY_TYPE_OBJECT
end

local function PerformRaycast()
    local pos = GetCamCoord(camera)
    local rot = GetCamRot(camera, 2)
    local forward = GetCameraDirectionVectors(rot)
    
    local startPos = pos
    local endPos = pos + (forward * 100.0)
    
    local ray = StartExpensiveSynchronousShapeTestLosProbe(
        startPos.x, startPos.y, startPos.z,
        endPos.x, endPos.y, endPos.z,
        -1,
        4294967295,
        0
    )
    
    local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(ray)
    
    if hit == 1 and entityHit ~= 0 and IsValidEntityType(entityHit) then
        local entityType = GetEntityType(entityHit)
        local entityTypeStr = "Inconnu"
        
        if entityType == ENTITY_TYPE_PED then
            entityTypeStr = "Ped"
        elseif entityType == ENTITY_TYPE_VEHICLE then
            entityTypeStr = "Véhicule"
        elseif entityType == ENTITY_TYPE_OBJECT then
            entityTypeStr = "Objet"
        end
        
        local entityModel = GetEntityModel(entityHit)
        
        if DoesEntityExist(entityHit) then
            if lastSelectedEntity and DoesEntityExist(lastSelectedEntity) then
                SetEntityDrawOutline(lastSelectedEntity, false)
            end
            SetEntityDrawOutline(entityHit, true)
            lastSelectedEntity = entityHit
        end
        
        return entityHit
    end
    
    return nil
end

local function UpdateCamera()
   if not camera then return end

   local currentSpeed = speed
   
   if IsDisabledControlPressed(0, keys.speedUp) then
      currentSpeed = speed * 2
   elseif IsDisabledControlPressed(0, keys.speedDown) then
      currentSpeed = speed * 0.5
   end

   local pos = GetCamCoord(camera)
   local rot = GetCamRot(camera, 2)
   
   local forward, right, up = GetCameraDirectionVectors(rot)

   if IsDisabledControlPressed(0, keys.forward) then
      pos = pos + forward * currentSpeed
   end
   if IsDisabledControlPressed(0, keys.backward) then
      pos = pos - forward * currentSpeed
   end

   if IsDisabledControlPressed(0, keys.left) then
      pos = pos - right * currentSpeed
   end
   if IsDisabledControlPressed(0, keys.right) then
      pos = pos + right * currentSpeed
   end

   if IsDisabledControlPressed(0, keys.up) then
      pos = pos + up * currentSpeed
   end
   if IsDisabledControlPressed(0, keys.down) then
      pos = pos - up * currentSpeed
   end

    if IsDisabledControlJustPressed(0, keys.delete) then
        local selectedEntity = PerformRaycast()
        if NetworkGetNetworkIdFromEntity(selectedEntity) ~= 0 then
            AdminMenu.openObjectMenu(selectedEntity)
        end
        if not selectedEntity and lastSelectedEntity and DoesEntityExist(lastSelectedEntity) then
            SetEntityDrawOutline(lastSelectedEntity, false)
            lastSelectedEntity = nil
        end
    end

    if IsDisabledControlJustPressed(0, keys.click) then
        local selectedEntity = PerformRaycast()
    
        if selectedEntity and lastSelectedEntity and DoesEntityExist(lastSelectedEntity) and GetEntityType(selectedEntity) == ENTITY_TYPE_PED and IsPedAPlayer(selectedEntity) then
            local playerID = NetworkGetPlayerIndexFromPed(selectedEntity)
            local serverID = GetPlayerServerId(playerID)
            AdminMenu.openPlayerMenu(serverID)
        end
    end

   SetCamCoord(camera, pos.x, pos.y, pos.z)

   local mouseX = GetDisabledControlNormal(1, 1) * sensitivity
   local mouseY = GetDisabledControlNormal(1, 2) * sensitivity

   rot = vector3(
       math.max(-89.0, math.min(89.0, rot.x - mouseY)),
       rot.y,
       rot.z - mouseX
   )
   
   SetCamRot(camera, rot.x, rot.y, rot.z, 2)
end

AddEventHandler('onResourceStop', function(resourceName)
   if GetCurrentResourceName() == resourceName then
      if freecam then
         DestroyFreecam()
         SetPlayerControl(PlayerId(), true, 0)
      end
   end
end)

NoClipSpeed = 0.5

AdminMenu.isStaff = function(src)
    for k,v in pairs(Config['AdminMenu'].groupsWL) do
        if AdminMenu.players[src] ~= nil and AdminMenu.players[src].group == v then
            return true
        end
    end

    return false
end

AdminMenu.getCamDirection = function()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()
    local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
    local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

    if len ~= 0 then
        coords = coords / len
    end

    return coords
end

AdminMenu.drawControls = function()
    local scaleform = RequestScaleformMovie("instructional_buttons")
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_CLEAR_SPACE")
    ScaleformMovieMethodAddParamInt(200)
    EndScaleformMovieMethod()


    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, keys.speedDown, true))
    ScaleformMovieMethodAddParamTextureNameString("Ralentir")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(1)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, keys.speedUp, true))
    ScaleformMovieMethodAddParamTextureNameString("Accélérer")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(2)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, keys.down, true))
    ScaleformMovieMethodAddParamTextureNameString("Descendre")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(3)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, keys.up, true))
    ScaleformMovieMethodAddParamTextureNameString("Monter")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(4)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, keys.click, true)) 
    ScaleformMovieMethodAddParamTextureNameString("Ouvrir menu joueur")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(5)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, keys.delete, true)) 
    ScaleformMovieMethodAddParamTextureNameString("Supprimer l'entité")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    ScaleformMovieMethodAddParamInt(0)
    EndScaleformMovieMethod()

    return scaleform
end

AdminMenu.freecam = function(bool)
    if bool ~= nil then
        AdminMenu.isfreecam = bool
    else
        AdminMenu.isfreecam = not AdminMenu.isfreecam
    end

    if not AdminMenu.isStaffMode then
        Framework.ShowNotification("~r~[Staff] ~s~Vous devez avoir le staff mode activé pour faire cela !")

        return
    end

    local plyPed = PlayerPedId()

    if IsPedInAnyVehicle(plyPed) then
        Framework.ShowNotification("~r~[Staff] ~s~Vous ne pouvez pas vous mettre en noclip dans un véhicule !")
        return
    else
        NoClipEntity = plyPed
    end

    if AdminMenu.isfreecam then
        SetEntityInvincible(NoClipEntity, true)
        FreezeEntityPosition(NoClipEntity, true)
        SetEntityVisible(PlayerPedId(), false)
        CreateFreecam()
        CreateThread(function()
            while AdminMenu.isfreecam do
                Wait(1)

                if not AdminMenu.isStaffMode then AdminMenu.isfreecam = false; end
                DrawCrosshair()
                UpdateCamera()
                if scaleform then
                    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
                end
            end
            FreezeEntityPosition(NoClipEntity, false)
            SetEntityVisible(NoClipEntity, 1, 0)
            SetEntityCollision(NoClipEntity, 1, 1)
            SetEntityInvincible(NoClipEntity, false)
        end)
    else
        local camCoords = GetCamCoord(camera)
        local tpCoords, groundZ = GetGroundZFor_3dCoord(camCoords.x, camCoords.y, camCoords.z, true)
        DestroyFreecam()
        SetEntityCoordsNoOffset(NoClipEntity, camCoords.x, camCoords.y, groundZ, false, false, false)
        PlaceObjectOnGroundProperly(NoClipEntity)
        SetEntityInvincible(NoClipEntity, false)
    end
end

AdminMenu.NoClip = function(bool)
    if bool ~= nil then
        AdminMenu.isNoClip = bool
    else
        AdminMenu.isNoClip = not AdminMenu.isNoClip
    end

    if not AdminMenu.isStaffMode then
        Framework.ShowNotification("~r~[Staff] ~s~Vous devez avoir le staff mode activé pour faire cela !")

        return
    end

    local plyPed = PlayerPedId()

    if IsPedInAnyVehicle(plyPed) then
        NoClipEntity = GetVehiclePedIsIn(plyPed)
    else
        NoClipEntity = plyPed
    end

    if AdminMenu.isNoClip then
        SetEntityInvincible(NoClipEntity, true)

        CreateThread(function()
            while AdminMenu.isNoClip do
                Wait(1)

                if not AdminMenu.isStaffMode then AdminMenu.isNoClip = false; end

                local pCoords = GetEntityCoords(plyPed, false)
                local camCoords = AdminMenu.getCamDirection()

                SetEntityVelocity(NoClipEntity, 0.01, 0.01, 0.01)
                SetEntityCollision(NoClipEntity, 0, 1)
                FreezeEntityPosition(NoClipEntity, true)

                if IsControlPressed(0, 32) then
                    pCoords = pCoords + (NoClipSpeed * camCoords)
                end

                if IsControlPressed(0, 269) then
                    pCoords = pCoords - (NoClipSpeed * camCoords)
                end

                if IsDisabledControlJustPressed(1, 15) then
                    NoClipSpeed = NoClipSpeed + 0.3
                end
                if IsDisabledControlJustPressed(1, 14) then
                    NoClipSpeed = NoClipSpeed - 0.3

                    if NoClipSpeed < 0 then
                        NoClipSpeed = 0
                    end
                end
                
                SetEntityCoordsNoOffset(NoClipEntity, pCoords, true, true, true)
                SetEntityVisible(NoClipEntity, 0, 0)

            end

            FreezeEntityPosition(NoClipEntity, false)
            SetEntityVisible(NoClipEntity, 1, 0)
            SetEntityCollision(NoClipEntity, 1, 1)
            SetEntityInvincible(NoClipEntity, false)
        end)
    else
        SetEntityInvincible(NoClipEntity, false)
    end
end

CreateThread(function()
    while true do
        Wait(1000)
        if AdminMenu.isfreecam and AdminMenu.isStaffMode and camera ~= nil then
            local camCoords = GetCamCoord(camera)
            if camCoords.x ~= 0 then
                print(camCoords, camera)
                SetEntityCoords(PlayerPedId(), camCoords)
            end
        end
    end
end)

local gamerTagId = {}

AdminMenu.show_Names = function(bool)
    if bool ~= nil then
        AdminMenu.isShowNames = bool
    else
        AdminMenu.isShowNames = not AdminMenu.isShowNames
    end

    if AdminMenu.isShowNames then
        CreateThread(function()
            while AdminMenu.isShowNames do
                local plyPed = PlayerPedId()
                if not AdminMenu.isStaffMode then AdminMenu.isShowNames = false; end

                for _, player in pairs(GetActivePlayers()) do
                        local ped = GetPlayerPed(player)
                        local pedID = GetPlayerServerId(player)
                        if #(GetEntityCoords(plyPed, false) - GetEntityCoords(ped, false)) < 7500.0 then
                            local playerPed = PlayerPedId()
                            gamerTagId[player] = CreateFakeMpGamerTag(ped, "", 0, 0, "", 0)
                            if AdminMenu.players[pedID] == nil then
                                test = ("<FONT color='#FF0000'> UUID: loading... | ID: %s | %s - loading..."):format(pedID, GetPlayerName(player))
                            else

                                if AdminMenu.players[pedID].group == "owner" then
                                    test = ("<FONT color='#FF0000'> UUID: %s | ID: %s | %s - %s"):format(AdminMenu.players[pedID].characterId, pedID, GetPlayerName(player), AdminMenu.players[pedID].group)
                                elseif AdminMenu.players[pedID].group == "superadmin" then
                                    test = ("<FONT color='#FF9100'> UUID: %s | ID: %s | %s - %s"):format(AdminMenu.players[pedID].characterId, pedID, GetPlayerName(player), AdminMenu.players[pedID].group)
                                elseif AdminMenu.players[pedID].group == "gamemaster" then
                                    test = ("<FONT color='#5f8aff'> UUID: %s | ID: %s | %s - %s"):format(AdminMenu.players[pedID].characterId, pedID, GetPlayerName(player), AdminMenu.players[pedID].group)
                                elseif AdminMenu.players[pedID].group == "main-team" then
                                    test = ("<FONT color='#c500ff'> UUID: %s | ID: %s | %s - %s"):format(AdminMenu.players[pedID].characterId, pedID, GetPlayerName(player), AdminMenu.players[pedID].group)
                                elseif AdminMenu.players[pedID].group == "gi" then
                                    test = ("<FONT color='#000000'> UUID: %s | ID: %s | %s - %s"):format(AdminMenu.players[pedID].characterId, pedID, GetPlayerName(player), AdminMenu.players[pedID].group)
                                elseif AdminMenu.players[pedID].group == "gl" then
                                    test = ("<FONT color='#109F00'> UUID: %s | ID: %s | %s - %s"):format(AdminMenu.players[pedID].characterId, pedID, GetPlayerName(player), AdminMenu.players[pedID].group)
                                elseif AdminMenu.players[pedID].group == "admin" then
                                    test = ("<FONT color='#FFE600'> UUID: %s | ID: %s | %s - %s"):format(AdminMenu.players[pedID].characterId, pedID, GetPlayerName(player), AdminMenu.players[pedID].group)
                                elseif AdminMenu.players[pedID].group == "cm" then
                                    test = ("<FONT color='#6600FF'> UUID: %s | ID: %s | %s - %s"):format(AdminMenu.players[pedID].characterId, pedID, GetPlayerName(player), AdminMenu.players[pedID].group)
                                elseif AdminMenu.players[pedID].group == "mod" then
                                    test = ("<FONT color='#004DFF'> UUID: %s | ID: %s | %s - %s"):format(AdminMenu.players[pedID].characterId, pedID, GetPlayerName(player), AdminMenu.players[pedID].group)
                                else
                                    test = ("<FONT color='#FFFFFF'> UUID: %s | ID: %s | %s - %s"):format(AdminMenu.players[pedID].characterId, pedID, GetPlayerName(player), AdminMenu.players[pedID].group)
                                end
                            end
                            SetMpGamerTagVisibility(gamerTagId[player], 2, 1)
                            SetMpGamerTagAlpha(gamerTagId[player], 2, 255)
                            SetMpGamerTagHealthBarColor(gamerTagId[player], 129)
                            SetMpGamerTagName(gamerTagId[player], test)
                            SetMpGamerTagVisibility(gamerTagId[player], 4, NetworkIsPlayerTalking(player))
                            SetMpGamerTagColour(gamerTagId[player], 4, 211)
                            SetMpGamerTagAlpha(gamerTagId[player], 4, 255)

                        else
                            RemoveMpGamerTag(gamerTagId[player])
                            gamerTagId[player] = nil
                        end
                end
                Wait(100)
            end

            for k,v in pairs(gamerTagId) do
                RemoveMpGamerTag(v)
            end

            gamerTagId = {}
        end)
    end
end

AdminMenu.show_Blips = function(bool)
    if bool ~= nil then
        AdminMenu.isShowBlips = bool
    else
        AdminMenu.isShowBlips = not AdminMenu.isShowBlips
    end
end

CreateThread(function()
    while true do
        wait = 15000

        if AdminMenu.isStaffMode then
            wait = 5000

            if AdminMenu.isShowBlips then
                wait = 1
                
                if not AdminMenu.isStaffMode then AdminMenu.isShowBlips = false; end

                for _, player in pairs(GetActivePlayers()) do
                    local found = false

                    if player ~= PlayerId() then
                        local ped = GetPlayerPed(player)
                        local blip = GetBlipFromEntity(ped)
                        
                        if not DoesBlipExist(blip) then
                            blip = AddBlipForEntity(ped)
                            SetBlipCategory(blip, 7)
                            SetBlipScale(blip,  0.85)
                            ShowHeadingIndicatorOnBlip(blip, true)
                            SetBlipSprite(blip, 1)
                            SetBlipColour(blip, 0)
                        end

                        SetBlipNameToPlayerName(blip, player)

                        local veh = GetVehiclePedIsIn(ped, false)
                        local blipSprite = GetBlipSprite(blip)

                        if IsEntityDead(ped) then
                            if blipSprite ~= 303 then
                                SetBlipSprite(blip, 303)
                                SetBlipColour(blip, 3)
                                ShowHeadingIndicatorOnBlip(blip, false)
                            end
                        elseif veh ~= nil then
                            if IsPedInAnyBoat(ped) then
                                if blipSprite ~= 427 then
                                    SetBlipSprite(blip, 427)
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip(blip, false)
                                end
                            elseif IsPedInAnyHeli(ped) then
                                if blipSprite ~= 43 then
                                    SetBlipSprite(blip, 43)
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip(blip, false)
                                end
                            elseif IsPedInAnyPlane(ped) then
                                if blipSprite ~= 423 then
                                    SetBlipSprite(blip, 423)
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip(blip, false)
                                end
                            elseif IsPedInAnyPoliceVehicle(ped) then
                                if blipSprite ~= 137 then
                                    SetBlipSprite(blip, 137)
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip(blip, false)
                                end
                            elseif IsPedInAnySub(ped) then
                                if blipSprite ~= 308 then
                                    SetBlipSprite(blip, 308)
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip(blip, false)
                                end
                            elseif IsPedInAnyVehicle(ped) then
                                if blipSprite ~= 225 then
                                    SetBlipSprite(blip, 225)
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip(blip, false)
                                end
                            else
                                if blipSprite ~= 1 then
                                    SetBlipSprite(blip, 1)
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip(blip, true)
                                end
                            end
                        else
                            if blipSprite ~= 1 then
                                SetBlipSprite(blip, 1)
                                SetBlipColour(blip, 0)
                                ShowHeadingIndicatorOnBlip(blip, true)
                            end
                        end
                        if veh then
                            SetBlipRotation(blip, math.ceil(GetEntityHeading(veh)))
                        else
                            SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
                        end
                    end
                end
            else
                for _, player in pairs(GetActivePlayers()) do
                    local blip = GetBlipFromEntity(GetPlayerPed(player))
                    if blip ~= nil then
                        RemoveBlip(blip)
                    end
                end
            end
        end

        Wait(wait)
    end
end)

AdminMenu.show_Coords = function()
    AdminMenu.isShowCoords = not AdminMenu.isShowCoords

    if AdminMenu.isStaffMode then
        CreateThread(function()
            while true do
                if AdminMenu.isShowCoords then
                    local plyPed = PlayerPedId()
                    local plyCoords = GetEntityCoords(plyPed, false)

                    Text('~r~X~s~: ' .. Framework.Math.Round(plyCoords.x, 2) .. '\n~o~Y~s~: ' .. Framework.Math.Round(plyCoords.y, 2) .. '\n~g~Z~s~: ' .. Framework.Math.Round(plyCoords.z, 2) .. '\n~r~H~s~: ' .. Framework.Math.Round(GetEntityPhysicsHeading(plyPed), 2))
                end

                Wait(1)
            end
        end)
    end
end

AdminMenu.tpm = function()

end

AdminMenu.ClosetVehWithDisplay = function()
    local myCoords = GetEntityCoords(PlayerPedId())
    local veh = Framework.Game.GetClosestVehicle(myCoords)
    local vCoords = GetEntityCoords(veh)
    DrawMarker(2, vCoords.x, vCoords.y, vCoords.z + 1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
end

AdminMenu.getPlyInv = function(player)
    AdminMenu.Items = {}
    AdminMenu.Weapons = {}
    AdminMenu.ArgentSale = {}
    AdminMenu.ArgentCash = {}
    AdminMenu.ArgentBank = {}
    
    Framework.TriggerServerCallback('admin_menu:getPlayerData', function(data)
        for k,v in pairs(data.accounts) do
            if v.name == 'money' and tonumber(v.money) > 0 then
                table.insert(AdminMenu.ArgentCash, {
                    label    = Framework.Math.Round(v.money),
                    value    = 'money',
                    itemType = 'item_cash',
                    amount   = v.money
                })
            elseif v.name == 'black_money' and tonumber(v.money) > 0 then
                table.insert(AdminMenu.ArgentSale, {
                    label    = Framework.Math.Round(v.money),
                    value    = 'black_money',
                    itemType = 'item_account',
                    amount   = v.money
                })
            elseif v.name == 'bank' and tonumber(v.money) > 0 then
                table.insert(AdminMenu.ArgentBank, {
                    value    = 'bank',
                    itemType = 'item_bank',
                    label    = Framework.Math.Round(v.money),
                    amount   = v.money
                })
            end
        end

        for k,v in pairs(data.inventory) do
            if v.count > 0 then
                table.insert(AdminMenu.Items, {
                    name     = v.name,
                    label    = v.label,
                    itemType = 'item_standard',
                    count    = v.count
                })
            end
        end

        for k,v in pairs(data.loadout) do
            table.insert(AdminMenu.Weapons, {
                name     = v.name,
                label    = v.label,
                itemType = 'item_weapon',
                ammo    = v.ammo
            })
        end

    end, player)
end

AdminMenu.msg = function(string)
    Framework.ShowNotification(string)
end