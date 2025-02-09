
-- RegisterCommand('annonce', function(source, args)
--     local authorized = false
--     if source ~= 0 then
--         local xPlayer = Framework.GetPlayerFromId(source)

--         if xPlayer.group == 'owner' then
--             authorized = true
--         end
--     else
--         authorized = true
--     end

--     if authorized then
--         if args ~= nil then
--             local message = table.concat(args, " ")
            
--             TriggerClientEvent('chat:addMessage', -1, { args = {'^1[Annonce Serveur]^0 ', message} })
--         end
--     end
-- end)