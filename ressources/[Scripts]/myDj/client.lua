Framework = nil

xSound = exports.xsound

CreateThread(function()
    while Framework == nil do
        TriggerEvent('framework:init', function(obj) Framework = obj end)
        Wait(1)
    end

    Wait(100)

    while Framework.PlayerData.jobs == nil do
        Framework.PlayerData = Framework.GetPlayerData()
        Wait(2000)
    end

    Framework.TriggerServerCallback('myDJ:receiveRunningSongs', function(DJPositions)
        if DJPositions ~= nil then
            for k, v in pairs(DJPositions) do
                if v.currentData ~= nil then
                    if v.currentData.titleFromPlaylist then
                        playTitleFromPlaylist(v.name, v.pos, v.range, v.currentData.currentLink, v.currentData.currentPlaylist)
                    else
                        playSong(v.name, v.pos, v.range, v.currentData.currentLink)
                        isMusicPaused = false
                    end

                    if xSound:soundExists(v.name) then
                        xSound:setTimeStamp(v.name, v.currentData.currentTime)
                        if not v.currentData.currentlyPlaying then
                            startStopSong(v.name)
                        end
                    end

                end
            end
        end

    end)
end)

RegisterNetEvent('framework:setJob')
AddEventHandler('framework:setJob', function(job)
	Framework.PlayerData.jobs['job'] = job
end)

local isNearDJ = false
local isAtDJ = false
local currentDJ = Config['myDj'].positions[1]
local isSongRunning = true
local isMusicPaused = false

CreateThread(function()
    while true do
        Wait(2500)

        local plyPed = PlayerPedId()
        local myCoords = GetEntityCoords(plyPed, true) 

        isAtDJ = false;
        isNearDJ = false;

        for k, v in pairs(Config['myDj'].positions) do
            if Framework == nil or v.requiredJob == nil or (Framework.PlayerData.jobs ~= nil and Framework.PlayerData.jobs['job'].name == v.requiredJob) then
                local dist = Vdist(myCoords, v.pos)

                if dist < 2.0 then
                    currentDJ = v;
                    isAtDJ = true;
                    isNearDJ = true;
                elseif dist < 25.0 then
                    isNearDJ = true;
                    currentDJ = v;
                end
            end
        end
    end
end)

-- local examplePlaylist = {
--     {link = "https://www.youtube.com/watch?v=6Dh-RL__uN4", name = "test2"},
--     {link = "https://www.youtube.com/watch?v=Z4lJdnRhyMs&list=LL&index=4", name = "google"},
-- }


-- Citizen.CreateThread(function()

--     Citizen.Wait(100)
--     local pos = GetEntityCoords(PlayerPedId())
--     --SetNuiFocus(true, true)
--     xSound:PlayUrlPos(currentDJ.name ,"https://www.youtube.com/watch?v=6Dh-RL__uN4", 1 , pos)
--     xSound:Distance(currentDJ.name, 100)
--     -- stopSong()
--     --startSongFromPlaylist(1, examplePlaylist)
-- end)
--]]
CreateThread(function()
    while true do
        wait = 1500;

        if isNearDJ then
            wait = 1;
            DrawMarker(27, currentDJ.pos, - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0*1.5, 1.0*1.5, 1.0, 136, 0, 136, 75, false, false, 2, false, false, false, false)
        end

        if isAtDJ then
            wait = 1;

            showInfobar("Appuyez ~g~E~s~, pour acceder aux platines")

            if IsControlJustReleased(0, 38) then
                SetNuiFocus(true, true)
                isDjOpen = true;
                SendNUIMessage({type = 'open'})
                Framework.TriggerServerCallback('myDJ:requestPlaylistsAndSongs', function(playlists, songs)
                    SendNUIMessage({type = 'getPlaylists', playlists = playlists, songs = songs})
                end)
            end
        end

        Wait(wait)
    end
end)

RegisterNetEvent('myDj:open')
AddEventHandler('myDj:open', function()
    SetNuiFocus(true, true)
    isDjOpen = true
    SendNUIMessage({type = 'open'})
    Framework.TriggerServerCallback('myDJ:requestPlaylistsAndSongs', function(playlists, songs)
        SendNUIMessage({type = 'getPlaylists', playlists = playlists, songs = songs})
    end)
end)

-- sync timestamps
CreateThread(function()
    while true do
        if currentDJ ~= nil then
            if xSound ~= nil and xSound:soundExists(currentDJ.name) then
                if xSound:isPlaying(currentDJ.name) then
                    SendNUIMessage({type = 'updateSeconds', maxDuration = xSound:getMaxDuration(currentDJ.name), secs = xSound:getTimeStamp(currentDJ.name)})
                end
            end
        end

        Wait(100)
    end
end)

function playSong(DJName, DJPos, DJRange, songlink)
    local options =
    {
        onPlayStart = function(event)
        end,
        onPlayEnd = function(event) 
        end,
    }   

    xSound:PlayUrlPos(DJName, songlink, 1, DJPos, false, options)
    xSound:Distance(DJName, DJRange)
    SendNUIMessage({type = 'updateSonginfos', link = songlink})
end

function startStopSong(DJName)
    if xSound:soundExists(DJName) and isMusicPaused then
        xSound:Resume(DJName) 
        isMusicPaused = false;
    elseif xSound:soundExists(DJName) and not isMusicPaused then
        xSound:Pause(DJName)
        isMusicPaused = true;
    end
end

function stopSong(DJName)
    xSound:Destroy(DJName) 
end

function rewindSong(DJName)
    if currentDJ ~= nil then
		if xSound:soundExists(DJName) then
			if xSound:isPlaying(DJName) then
				local currTimestamp = xSound:getTimeStamp(DJName)
				if currTimestamp - 10 < 0 then
					xSound:setTimeStamp(0)
				else
					xSound:setTimeStamp(DJName, currTimestamp - 10)
				end
				
			end
		end
	end
end

function forwardSong(DJName)
    if currentDJ ~= nil then
		if xSound:soundExists(DJName) then
			if xSound:isPlaying(DJName) then
				local currTimestamp = xSound:getTimeStamp(DJName)
				xSound:setTimeStamp(DJName, currTimestamp + 10)
			end
		end
	end
end

function volumeUp(DJName)
    if xSound:soundExists(DJName) then
        if currentDJ.volume + 0.1 >= 1 then
            currentDJ.volume = 1.0
            xSound:setVolume(DJName, 1.0)
        else
            currentDJ.volume = currentDJ.volume + 0.1
            xSound:setVolume(DJName, currentDJ.volume + 0.1)
        end
        
    end
end

function volumeDown(DJName)
    if xSound:soundExists(DJName) then
        local currentVolume = 1.0;

        for k,v in pairs(Config['myDj'].positions) do
            if v.name == DJName then
                currentVolume = v.volume
            end
        end

        if currentDJ.volume - 0.1 <= 0 then
            currentDJ.volume = 0.0
            xSound:setVolume(DJName, 0.0)
        else
            currentDJ.volume = currentDJ.volume - 0.1
            xSound:setVolume(DJName, currentDJ.volume - 0.1)
        end
    end
end

function playTitleFromPlaylist(DJName, DJPos, DJRange, link, playlistId)
    Framework.TriggerServerCallback('myDJ:requestPlaylistById', function(playlistSongs)
		if playlistSongs ~= nil then
			for k, v in pairs(playlistSongs) do
				if v.link == link then
					startSongFromPlaylist(DJName, DJPos, DJRange, k, playlistSongs)
				end
			end
		end
	end, playlistId)
end

function startSongFromPlaylist(DJName, DJPos, DJRange, startIndex, playlist)
    for i = startIndex, #playlist, 1 do
        local options =
        {
            onPlayStart = function(event)
                isSongRunning = true;
            end,
            onPlayEnd = function(event) 
                isSongRunning = false;
            end,
        }   
    
        xSound:PlayUrlPos(DJName, playlist[i].link, 1, DJPos, false, options)
        xSound:Distance(DJName, DJRange)

        while isSongRunning do Wait(100) end
    end
end

if Config.enableCommand then
    RegisterCommand('openDJ', function(source, args, rawCommand)
        SetNuiFocus(true, true)
        isDjOpen = true
        SendNUIMessage({type = 'open'})
        Framework.TriggerServerCallback('myDJ:requestPlaylistsAndSongs', function(playlists, songs)
            SendNUIMessage({type = 'getPlaylists', playlists = playlists, songs = songs})
        end)
    end, false)
end

RegisterNUICallback('close', function(data, cb) 
    SetNuiFocus(false, false)
    isDjOpen = false
end)

RegisterNetEvent('myDj:clientStartStop')
AddEventHandler('myDj:clientStartStop', function(DJName)
    startStopSong(DJName)
end)

RegisterNUICallback('togglePlaystate', function(data, cb)
    exports["ac"]:ExecuteServerEvent('myDj:syncStartStop', currentDJ.name)
end)

RegisterNetEvent('myDj:clientPlaySong')
AddEventHandler('myDj:clientPlaySong', function(DJName, DJPos, DJRange, link)
    for k,v in pairs(Config['myDj'].positions) do
        if v.name == DJName then
            playSong(DJName, DJPos, DJRange, link)
            isMusicPaused = false
        end
    end
end)

RegisterNUICallback('playNewSong', function(data, cb) 
    exports["ac"]:ExecuteServerEvent('myDj:syncPlaySong', currentDJ.name, currentDJ.pos, currentDJ.range, data.link)
end)

RegisterNetEvent('myDj:clientPlaySongFromPlaylist')
AddEventHandler('myDj:clientPlaySongFromPlaylist', function(DJName, DJPos, DJRange, link, playlistId)
    playTitleFromPlaylist(DJName, DJPos, DJRange, link, playlistId)
end)

RegisterNUICallback('playSongFromPlaylist', function(data, cb)
	exports["ac"]:ExecuteServerEvent('myDj:syncPlaySongFromPlaylist', currentDJ.name, currentDJ.pos, currentDJ.range, data.link, data.playlistId)
end)

RegisterNetEvent('myDj:clientRewind')
AddEventHandler('myDj:clientRewind', function(DJName)
    rewindSong(DJName)
end)

RegisterNUICallback('rewind', function(data, cb)
    exports["ac"]:ExecuteServerEvent('myDj:syncRewind', currentDJ.name)
end)

RegisterNetEvent('myDj:clientForward')
AddEventHandler('myDj:clientForward', function(DJName)
    forwardSong(DJName)
end)

RegisterNUICallback('forward', function(data, cb)
	exports["ac"]:ExecuteServerEvent('myDj:syncForward', currentDJ.name)
end)

RegisterNetEvent('myDj:clientVolumeDown')
AddEventHandler('myDj:clientVolumeDown', function(DJName)
    volumeDown(DJName)
end)

RegisterNUICallback('down', function(data, cb)
    exports["ac"]:ExecuteServerEvent('myDj:syncVolumeDown', currentDJ.name)
    if currentDJ.volume <= 0.0 then
        ShowNotification('~g~Minimum volume reached!')
    end
end)

RegisterNetEvent('myDj:clientVolumeUp')
AddEventHandler('myDj:clientVolumeUp', function(DJName)
    volumeUp(DJName)
end)

RegisterNUICallback('up', function(data, cb)
    exports["ac"]:ExecuteServerEvent('myDj:syncVolumeUp', currentDJ.name)
    if currentDJ.volume >= 1.0 then
        ShowNotification('~g~Maximum volume reached!')
    end
end)

RegisterNUICallback('addPlayList', function(data, cb)
    exports["ac"]:ExecuteServerEvent('myDJ:addPlaylist', data.name)
end)

RegisterNUICallback('addSongToPlaylist', function(data, cb)
    exports["ac"]:ExecuteServerEvent('myDJ:addSongToPlaylist', data.id, tostring(data.link))

    Wait(100)
    Framework.TriggerServerCallback('myDJ:requestPlaylistsAndSongs', function(playlists, songs)
        SendNUIMessage({type = 'getPlaylists', playlists = playlists, songs = songs})
    end)
end)

RegisterNUICallback('deleteSong', function(data, cb)
	exports["ac"]:ExecuteServerEvent('myDJ:removeSongFromPlaylist', data.id)
end)

RegisterNUICallback('deletePlaylist', function(data, cb)
	exports["ac"]:ExecuteServerEvent('myDJ:removePlaylist', data.id)
end)

RegisterNUICallback('noSongtitle', function(data, cb)
	ShowNotification("~r~Ce titre n'existe pas !")
end)

function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end

function showInfobar(msg)
	CurrentActionMsg  = msg;
	SetTextComponentFormat('STRING')
	AddTextComponentString(CurrentActionMsg)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)

end

-- xSound = exports.xsound
-- Citizen.CreateThread(function()
--     local pos = GetEntityCoords(PlayerPedId())
--     xSound:PlayUrlPos("name","https://www.youtube.com/watch?v=6Dh-RL__uN4",1 , pos)
--     --some links will not work cause to copyright or author did not allow to play video from an iframe.
--     print('start playing')
--     --SetEntityCoords(PlayerPedId(), -1592.275, -3012.131, -78.0)
--     xSound:Distance("name",100)
    
--     Citizen.Wait(1000*30)
--     xSound:Destroy("name")
-- end)

-- Citizen.CreateThread(function()
--     Citizen.Wait(10)
--     SetNuiFocus(true, true)

--     local pos = GetEntityCoords(PlayerPedId())
      
-- end)   

-- xSound = exports.xsound
-- function startPlaylist(playlistSongs, startIndex)
    
--     local pos = GetEntityCoords(PlayerPedId())
    

--     local options =
--     {
--         onPlayStart = function(event) -- event argument returns getInfo(id)
--             print("oh yeah! PARTY!")
--         end,
--         onPlayEnd = function(event) 
--             print("oh... already end ? :( Song name ? pls")
--             print(event.url)
--         end,
--     }

--     xSound:PlayUrlPos("name", playlistSongs[i].link, 1, pos, false, options)

--     for i=startIndex, #playlistSongs, 1 do
--         print('Started song: ' .. playlistSongs[i].label)

--     end

-- end