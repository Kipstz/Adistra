
RegisterServerEvent('skinchanger:save')
AddEventHandler('skinchanger:save', function(skin)
	local src = source;
	local xPlayer = Framework.GetPlayerFromId(src)
	
	local defaultMaxWeight = Framework.GetConfig().MaxWeight
	local backpackModifier = Config['utils'].BackpackWeight[skin.bags_1]

	if backpackModifier then
		xPlayer['inventory'].setMaxWeight(defaultMaxWeight + backpackModifier)
	else
		xPlayer['inventory'].setMaxWeight(defaultMaxWeight)
	end

	xPlayer['skin'].setSkin(skin)
	MySQL.update.await('UPDATE characters SET skin = ? WHERE characterId = ?', {
        json.encode(skin), xPlayer.characterId
    })
end)

RegisterServerEvent('skinchanger:setWeight')
AddEventHandler('skinchanger:setWeight', function(bag)
	local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

	local defaultMaxWeight = Framework.GetConfig().MaxWeight
	local backpackModifier = Config['utils'].BackpackWeight[bag]

	if backpackModifier then
		xPlayer['inventory'].setMaxWeight(defaultMaxWeight + backpackModifier)
	else
		xPlayer['inventory'].setMaxWeight(defaultMaxWeight)
	end
end)

Framework.RegisterServerCallback('skinchanger:getPlayerSkin', function(src, cb)
	local xPlayer = Framework.GetPlayerFromId(src)

	local skin = MySQL.scalar.await('SELECT `skin` FROM `characters` WHERE `characterId` = ? LIMIT 1', {
		xPlayer.characterId
	})

	if skin then
		skin = json.decode(skin)
		cb(skin)
	end
end)

Framework.RegisterCommand('skin', {'mod', 'admin', 'gi', 'gl', 'main-team', 'gamemaster', 'superadmin', 'owner'}, function(xPlayer, args, showError)
	args.playerId.triggerEvent('skinchanger:openSaveableMenu')
end, true, {help = "Changer le skin d'un Joueur", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'}
}})