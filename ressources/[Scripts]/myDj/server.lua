Framework = nil
TriggerEvent('framework:init', function(obj) Framework = obj end)

Framework.RegisterServerCallback('myDJ:requestPlaylistsAndSongs', function(source, cb)
    local playlists = {}
    local songs = {}

    MySQL.Async.fetchAll('SELECT * from playlists', {},
    function(result)
        playlists = result

        MySQL.Async.fetchAll('SELECT * from playlist_songs', {},
        function(result)
            songs = result
            cb(playlists, songs)
        end
        )
    end
    )
end)

Framework.RegisterServerCallback('myDJ:requestPlaylistById', function(source, cb, playlistId)
	MySQL.Async.fetchAll('SELECT * from playlist_songs WHERE playlist = @playlistId', {
		['@playlistId'] = playlistId,
	},
	function(result)
		cb(result)
	end
	)
end)

Framework.RegisterServerCallback('myDJ:requestPlaylists', function(source, cb)
    MySQL.Async.fetchAll('SELECT id, label from playlists', {},
    function(result)
        cb(result)
    end
    )
end)

Framework.RegisterServerCallback('myDJ:requestPlaylistSongs', function(source, cb, playlistId)
    MySQL.Async.fetchAll('SELECT * from playlist_songs WHERE playlist = @playlist', {
        ['@playlistId'] = playlistId,
    },
    function(result)
        cb(result)
    end
    )
end)

Framework.RegisterServerCallback('myDJ:receiveRunningSongs', function(source, cb)
    cb(Config['myDj'].positions)
end)

RegisterServerEvent('myDJ:addPlaylist')
AddEventHandler('myDJ:addPlaylist', function(label)
    MySQL.Async.execute('INSERT INTO playlists (label) VALUES (@label)', {
        ['@label'] = label,
    })
end)

RegisterServerEvent('myDJ:addSongToPlaylist')
AddEventHandler('myDJ:addSongToPlaylist', function(playlistId, videoLink)
    MySQL.Async.execute('INSERT INTO playlist_songs (playlist, link) VALUES (@playlist, @link)', {
        ['@playlist'] = playlistId,
        --['@label'] = label,
        ['@link'] = videoLink,
    })
end)

RegisterServerEvent('myDJ:removeSongFromPlaylist')
AddEventHandler('myDJ:removeSongFromPlaylist', function(songId, link)
    MySQL.Async.execute('DELETE FROM playlist_songs WHERE id = @id', {
        ['@id'] = songId,
    })
end)


RegisterServerEvent('myDJ:removePlaylist')
AddEventHandler('myDJ:removePlaylist', function(playlistId)
    MySQL.Async.execute('DELETE FROM playlists WHERE id = @id', {
        ['@id'] = playlistId,
    })
end)

-- SYNC

RegisterServerEvent('myDj:syncPlaySong')
AddEventHandler('myDj:syncPlaySong', function(currentDJ, DJPos, DJRange, link)
    if DJRange < 100 then 
        for k, v in pairs(Config['myDj'].positions) do
            if v.name == currentDJ then
                TriggerClientEvent('myDj:clientPlaySong', -1, currentDJ, DJPos, DJRange, link)
            end
        end
    
        for k, v in pairs(Config['myDj'].positions) do
            if v.name == currentDJ then
                Config['myDj'].positions[k].currentData = {
                    titleFromPlaylist = false,
                    currentlyPlaying = true,
                    currentLink = link,
                    currentTime = 0,
                }
    
                break
            end
        end
    else
        print("^1My DJ: Tentative de jouer un son avec une distance supérieur a 100M. (ID:"..source..")^0")
    end
end)

RegisterServerEvent('myDj:syncPlaySongFromPlaylist')
AddEventHandler('myDj:syncPlaySongFromPlaylist', function(currentDJ, DJPos, DJRange, link, playlistId)
    TriggerClientEvent('myDj:clientPlaySongFromPlaylist', -1, currentDJ, DJPos, DJRange, link, playlistId)
    for k, v in pairs(Config['myDj'].positions) do
        if v.name == currentDJ then
            Config['myDj'].positions[k].currentData = {
                titleFromPlaylist = true,
                currentPlaylist = playlistId,
                currentlyPlaying = true,
                currentLink = link,
                currentTime = 0,
            }

            break
        end
    end
end)

CreateThread(function()
    while true do
        Wait(100)
        for k, v in pairs(Config['myDj'].positions) do
            if v.currentData ~= nil and v.currentData.currentlyPlaying then
                v.currentData.currentTime = v.currentData.currentTime + 1
            end
        end
    end
end)

RegisterServerEvent('myDj:syncStartStop')
AddEventHandler('myDj:syncStartStop', function(currentDJ)
    TriggerClientEvent('myDj:clientStartStop', -1, currentDJ)

    for k, v in pairs(Config['myDj'].positions) do
        if v.name == currentDJ then
            if v.currentData ~= nil and v.currentData.currentlyPlaying then
                Config['myDj'].positions[k].currentData.currentlyPlaying = false
            elseif v.currentData ~= nil and not v.currentData.currentlyPlaying then
                Config['myDj'].positions[k].currentData.currentlyPlaying = true
            end 
            break
        end
    end
end)

RegisterServerEvent('myDj:syncForward')
AddEventHandler('myDj:syncForward', function(currentDJ)
    TriggerClientEvent('myDj:clientForward', -1, currentDJ)
end)

RegisterServerEvent('myDj:syncRewind')
AddEventHandler('myDj:syncRewind', function(currentDJ)
    TriggerClientEvent('myDj:clientRewind', -1, currentDJ)
end)

RegisterServerEvent('myDj:syncVolumeUp')
AddEventHandler('myDj:syncVolumeUp', function(currentDJ)
    TriggerClientEvent('myDj:clientVolumeUp', -1, currentDJ)
end)

RegisterServerEvent('myDj:syncVolumeDown')
AddEventHandler('myDj:syncVolumeDown', function(currentDJ)
    TriggerClientEvent('myDj:clientVolumeDown', -1, currentDJ)
end)

local allEvents = {
    ['myDj:syncStartStop'] = false,
    ['myDj:syncPlaySong'] = false,
    ['myDj:syncPlaySongFromPlaylist'] = false,
    ['myDj:syncRewind'] = false,
    ['myDj:syncForward'] = false,
    ['myDj:syncVolumeDown'] = false,
    ['myDj:syncVolumeUp'] = false,
    ['myDj:addPlaylist'] = false,
    ['myDj:addSongToPlaylist'] = false,
    ['myDj:removeSongFromPlaylist'] = false,
    ['myDj:removePlaylist'] = false,
}

local fiveguard_resource = "ac"
AddEventHandler("fg:ExportsLoaded", function(fiveguard_res, res)
    if res == "*" or res == GetCurrentResourceName() then
        fiveguard_resource = fiveguard_res
        for event,cross_scripts in pairs(allEvents) do
            local retval, errorText = exports[fiveguard_res]:RegisterSafeEvent(event, {
                ban = true,
                log = true
            }, cross_scripts)
            if not retval then
                print("[fiveguard safe-events] "..errorText)
            end
        end
    end
end)