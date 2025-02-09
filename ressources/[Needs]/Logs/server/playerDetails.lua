local configLoadFile = LoadResourceFile(GetCurrentResourceName(), "./config/config.json")
local cfgFile = json.decode(configLoadFile)

CreateThread(function()
    while cfgFile == nil do
        Wait(1)
        configLoadFile = LoadResourceFile(GetCurrentResourceName(), "./config/config.json")
        cfgFile = json.decode(configLoadFile)
    end
end)

function GetPlayerDetails(src, channel)
    local xPlayer = Framework.GetPlayerFromId(src)

    local ids = ExtractIdentifiers(src)
	if cfgFile['postals'] and GetResourceKvpString("AdistraLogs:"..channel:lower()..":postal") ~= 'true' then
        postal = getPlayerLocation(src)
        _postal = postal
    else
        _postal = nil
    end

    if cfgFile['discordId'] and GetResourceKvpString("AdistraLogs:"..channel:lower()..":discordid") ~= 'true' then
        if ids.discord then
            _discordID = ids.discord:gsub("discord:", "")
        else
            _discordID = nil
        end
    end

    if GetConvar("steam_webApiKey", "false") ~= 'false' then
        if cfgFile['steamId'] and GetResourceKvpString("AdistraLogs:"..channel:lower()..":steamid") ~= 'true' then
            _steamID = ids.steam
        else
            _steamID = nil
        end

        if cfgFile['steamUrl'] and GetResourceKvpString("AdistraLogs:"..channel:lower()..":steamurl") ~= 'true' then
            if ids.steam then
                _steamURL ="\nhttps://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""),16)..""
            else
                _steamURL = nil
            end
        end
    else
        TriggerEvent('AdistraLogs:AdistraLogs:errorLog', 'You need to set a steam api key in your server.cfg for the steam identifiers to work!.')
    end

	if cfgFile['license'] and GetResourceKvpString("AdistraLogs:"..channel:lower()..":license") ~= 'true' then
        _license = ids.license
    else
        _license = nil
    end

    if cfgFile['license2'] and GetResourceKvpString("AdistraLogs:"..channel:lower()..":license2") ~= 'true' then
        _license2 = ids.license2
    else
        _license2 = nil
    end

    if cfgFile['ip'] and GetResourceKvpString("AdistraLogs:"..channel:lower()..":ip") ~= 'true' then
        _ip = ids.ip:gsub("ip:", "")
    else
        _ip = nil
    end

	if cfgFile['playerId'] and GetResourceKvpString("AdistraLogs:"..channel:lower()..":playerid") ~= 'true' then
        if channel == 'join' then
            _playerID = 'N/A'
        else
            _playerID = src
        end
    else
        _playerID = nil
    end

    if cfgFile['playerPing'] and GetResourceKvpString("AdistraLogs:"..channel:lower()..":playerping") ~= 'true' then
        _ping = GetPlayerPing(src)
    else
        _ping = nil
    end

    if cfgFile['playerHealth'] or cfgFile['playerArmor'] then
        local playerPed = GetPlayerPed(src)
        if cfgFile['playerHealth'] and GetResourceKvpString("AdistraLogs:"..channel:lower()..":playerhealth") ~= 'true' then
            local maxHealth = math.floor(GetEntityMaxHealth(playerPed) / 2)
            local health = math.floor(GetEntityHealth(playerPed) / 2)
            _hp = health
            _maxhp = maxHealth
        else
            _hp = nil
            _maxhp = nil
        end
        if cfgFile['playerArmor'] and GetResourceKvpString("AdistraLogs:"..channel:lower()..":playerarmor") ~= 'true' then
            local maxArmour = GetPlayerMaxArmour(src)
            local armour = GetPedArmour(playerPed)
            _armour = armour
            _maxarmour = maxArmour
        else
            _armour = nil
            _maxarmour = nil
        end
    end

    if cfgFile['accounts'] and xPlayer and xPlayer['accounts'] ~= nil then
        _money = xPlayer['accounts'].getMoney()
        _bank = xPlayer['accounts'].getAccount('bank').money
        _bmoney = xPlayer['accounts'].getAccount('black_money').money
    else
        _money = nil
        _bank = nil
        _bmoney = nil
    end

    return {
        ['id'] = _playerID, 
        ['postal'] = _postal, 
        ['ping'] = _ping,
        ['hp'] = {
            ['hp'] = _hp,
            ['max_hp'] = _maxhp,
            ['armour'] = _armour,
            ['max_armour'] = _maxarmour
        }, 
        ['discord'] = _discordID, 
        ['steam'] = {
            ['id'] = _steamID, 
            ['url'] = _steamURL
        }, 
        ['license'] = {
            [1] = _license, 
            [2] = _license2
        }, 
        ['ip'] = _ip,
        ['accounts'] = {
            ['money'] = _money,
            ['bank'] = _bank,
            ['black_money'] = _bmoney
        }
    }
end


function ExtractIdentifiers(src)
    local identifiers = {}

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam:") then
            identifiers['steam'] = id
        elseif string.find(id, "ip:") then
            identifiers['ip'] = id
        elseif string.find(id, "discord:") then
            identifiers['discord'] = id
        elseif string.find(id, "license:") then
            identifiers['license'] = id
        elseif string.find(id, "license2:") then
            identifiers['license2'] = id
        elseif string.find(id, "xbl:") then
            identifiers['xbl'] = id
        elseif string.find(id, "live:") then
            identifiers['live'] = id
        elseif string.find(id, "fivem:") then
            identifiers['fivem'] = id
        end
    end

    return identifiers
end

function getPlayerLocation(src)
    local raw = LoadResourceFile(GetCurrentResourceName(), "./json/postals.json")

    local postals = json.decode(raw)
    local nearest = nil

    local player = src
    local ped = GetPlayerPed(player)
    local playerCoords = GetEntityCoords(ped)

    local x, y = table.unpack(playerCoords)

	local ndm = -1
	local ni = -1
	for i, p in ipairs(postals) do
		local dm = (x - p.x) ^ 2 + (y - p.y) ^ 2
		if ndm == -1 or dm < ndm then
			ni = i
			ndm = dm
		end
	end

	if ni ~= -1 then
		local nd = math.sqrt(ndm)
		nearest = {i = ni, d = nd}
	end
	_nearest = postals[nearest.i].code
	return _nearest
end