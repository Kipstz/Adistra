

RegisterCommand('newdoor', function(playerId, args, rawCommand)
	TriggerClientEvent('nui_doorlock:newDoorSetup', playerId, args)
end, true)

RegisterServerEvent('nui_doorlock:newDoorCreate')
AddEventHandler('nui_doorlock:newDoorCreate', function(config, model, heading, coords, jobs, item, doorLocked, maxDistance, slides, garage, doubleDoor, doorname)
	local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    if DoorLock:isWL(xPlayer.identifier) then
        doorLocked = tostring(doorLocked)
        slides = tostring(slides)
        garage = tostring(garage)
    
        local newDoor = {}
    
        if jobs[1] then auth = tostring("['"..jobs[1].."']=0") end
        if jobs[2] then auth = auth..', '..tostring("['"..jobs[2].."']=0") end
        if jobs[3] then auth = auth..', '..tostring("['"..jobs[3].."']=0") end
        if jobs[4] then auth = auth..', '..tostring("['"..jobs[4].."']=0") end
    
        if auth then newDoor.authorizedJobs = { auth } end
        if item then newDoor.items = { item } end
    
        newDoor.locked = doorLocked;
        newDoor.maxDistance = maxDistance;
        newDoor.slides = slides;
    
        if not doubleDoor then
            newDoor.garage = garage;
            newDoor.objHash = model;
            newDoor.objHeading = heading;
            newDoor.objCoords = coords;
            newDoor.fixText = false;
        else
            newDoor.doors = {
                {objHash = model[1], objHeading = heading[1], objCoords = coords[1]},
                {objHash = model[2], objHeading = heading[2], objCoords = coords[2]}
            }
        end
    
        newDoor.audioRemote = false;
        newDoor.lockpick = false;
    
        local path = GetResourcePath(GetCurrentResourceName())
        if config ~= '' then
            path = path:gsub('//', '/')..'/configs/'..string.gsub(config, ".lua", "")..'.lua'
        else
            path = path:gsub('//', '/')..'/config.lua'
        end
    
        -- FILE --
    
        file = io.open(path, 'a+')
        if not doorname then label = '\n\n-- UNNAMED DOOR CREATED BY '..xPlayer.name..'\ntable.insert(Config.DoorList, {'
        else
            label = '\n\n-- '..doorname.. '\ntable.insert(Config.DoorList, {'
        end
        file:write(label)
        for k,v in pairs(newDoor) do
            if k == 'authorizedJobs' then
                local str =  ('\n	%s = { %s },'):format(k, auth)
                file:write(str)
            elseif k == 'doors' then
                local doorStr = {}
                for i=1, 2 do
                    table.insert(doorStr, ('	{objHash = %s, objHeading = %s, objCoords = %s}'):format(model[i], heading[i], coords[i]))
                end
                local str = ('\n	%s = {\n	%s,\n	%s\n },'):format(k, doorStr[1], doorStr[2])
                file:write(str)
            elseif k == 'items' then
                local str = ('\n	%s = { \'%s\' },'):format(k, item)
                file:write(str)
            else
                local str = ('\n	%s = %s,'):format(k, v)
                file:write(str)
            end
        end
        file:write([[
            
        -- oldMethod = true,
        -- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
        -- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
        -- autoLock = 1000]])
        file:write('\n})')
        file:close()
    
        ---------
    
        local doorID = #Config.DoorList + 1
        
        if jobs[4] then newDoor.authorizedJobs = { [jobs[1]] = 0, [jobs[2]] = 0, [jobs[3]] = 0, [jobs[4]] = 0 }
        elseif jobs[3] then newDoor.authorizedJobs = { [jobs[1]] = 0, [jobs[2]] = 0, [jobs[3]] = 0 }
        elseif jobs[2] then newDoor.authorizedJobs = { [jobs[1]] = 0, [jobs[2]] = 0 }
        elseif jobs[1] then newDoor.authorizedJobs = { [jobs[1]] = 0 } end
        if item then newDoor.Items = { item } end
    
        Config.DoorList[doorID] = newDoor;
        Config.DoorList[doorID].locked = doorLocked;
    
        TriggerClientEvent('nui_doorlock:newDoorAdded', -1, newDoor, doorID, doorLocked)
    end
end)