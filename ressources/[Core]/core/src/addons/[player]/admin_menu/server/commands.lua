
Framework.RegisterCommand('repa', { 'superadmin', 'owner' }, function(xPlayer, args, showError)
    xPlayer.triggerEvent('admin_menu:fixVehicle')
end, true, {help = "Réparer son véhicule", validate = true,
})

Framework.RegisterCommand('wipe', { 'superadmin', 'owner' }, function(xPlayer, args, showError)
    local identifier = args.playerId.identifier;
    local characterId = args.playerId.characterId;

    if not xPlayer then
        DropPlayer(args.playerId.source, "Vous avez été wipe")

        MySQL.update.await('DELETE FROM `users` WHERE identifier = ?', {identifier})
        MySQL.update.await('DELETE FROM `characters` WHERE characterId = ?', {characterId})
        MySQL.update.await('DELETE FROM `character_accessories` WHERE characterId = ?', {characterId})
        MySQL.update.await('DELETE FROM `character_billings` WHERE characterId = ?', {characterId})
        MySQL.update.await('DELETE FROM `character_licenses` WHERE characterId = ?', {characterId})
        MySQL.update.await('DELETE FROM `character_outfits` WHERE characterId = ?', {characterId})
        -- MySQL.update.await('DELETE FROM `character_properties` WHERE characterId = ?', {characterId})
        MySQL.update.await('DELETE FROM `character_vehicles` WHERE characterId = ?', {characterId})
        MySQL.update.await('DELETE FROM `vehicle_keys` WHERE characterId = ?', {characterId})
        MySQL.update.await('DELETE FROM `phone_phones` WHERE owner_id = ?', {'license:'..identifier})
        MySQL.update.await('DELETE FROM `phone_backups` WHERE id = ?', {'license:'..identifier})
        exports['Logs']:createLog({EmbedMessage = ("**%s** à WIPE **%s**."):format("CONSOLE", args.playerId.getName()), player_id = args.playerId.source, channel = 'adminCommands'})
       
    end
end, true, {help = "Wipe un joueur", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'}
}})

-- Framework.RegisterCommand('wipeoff', { 'superadmin', 'owner' }, function(xPlayer, args, showError)
--     local identifier = args.identifier;
--     local characterId = MySQL.scalar.await('SELECT `characterId` FROM `users` WHERE `identifier` = ? LIMIT 1', {identifier})

--     MySQL.update.await('DELETE FROM `users` WHERE identifier = ?', {identifier})
--     MySQL.update.await('DELETE FROM `characters` WHERE characterId = ?', {characterId})
--     MySQL.update.await('DELETE FROM `character_accessories` WHERE characterId = ?', {characterId})
--     MySQL.update.await('DELETE FROM `character_billings` WHERE characterId = ?', {characterId})
--     MySQL.update.await('DELETE FROM `character_licenses` WHERE characterId = ?', {characterId})
--     MySQL.update.await('DELETE FROM `character_outfits` WHERE characterId = ?', {characterId})
--     MySQL.update.await('DELETE FROM `character_properties` WHERE characterId = ?', {characterId})
--     MySQL.update.await('DELETE FROM `character_vehicles` WHERE characterId = ?', {characterId})
--     MySQL.update.await('DELETE FROM `vehicle_keys` WHERE characterId = ?', {characterId})
--     MySQL.update.await('DELETE FROM `phone_phones` WHERE owner_id = ?', {'license:'..identifier})
--     MySQL.update.await('DELETE FROM `phone_backups` WHERE id = ?', {'license:'..identifier})

--     if xPlayer then
--         exports['Logs']:createLog({EmbedMessage = ("**%s** à WIPE **%s**."):format(xPlayer.getName(), args.identifier), player_id = xPlayer.source, player_2_id = args.playerId.source, channel = 'adminCommands'})
--     else
--         exports['Logs']:createLog({EmbedMessage = ("**%s** à WIPE **%s**."):format("CONSOLE", args.identifier), channel = 'adminCommands'})
--     end
-- end, true, {help = "Wipe un joueur hors ligne", validate = true, arguments = {
-- 	{name = 'identifier', help = "License du Joueur", type = 'string'}
-- }})

-- Framework.RegisterCommand('register', { 'mod', 'admin', 'superadmin', 'owner' }, function(xPlayer, args, showError)

-- end, true, {help = "Register un joueur (retour à la création personnage sans wipe)", validate = true, arguments = {
-- 	{name = 'playerId', help = "Id du Joueur", type = 'player'}
-- }})
