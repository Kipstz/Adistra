
AddEventHandler('instance:loaded', function()
	TriggerEvent('instance:registerType', 'property', function(instance)
		Property:enter(instance.data.property)
	end, function(instance)
		Property:exit(instance.data.property)
	end)
end)

RegisterNetEvent('instance:onCreate')
AddEventHandler('instance:onCreate', function(instance)
	if instance.type == 'property' then
		TriggerEvent('instance:enter', instance)
	end
end)

-- RegisterNetEvent('instance:onEnter')
-- AddEventHandler('instance:onEnter', function(instance)
-- 	if instance.type == 'property' then
-- 		local property = Property:getPropertybyId(instance.data.property)
-- 		local isHost   = GetPlayerFromServerId(instance.host) == PlayerId()
-- 		local isOwned  = false;

-- 		if property ~= nil then
-- 			if Property:isOwnedbyId(property) then isOwned = true; end
-- 		end

-- 		if isOwned or not isHost then
-- 			hasChest = true;
-- 		else
-- 			hasChest = false;
-- 		end
-- 	end
-- end)

RegisterNetEvent('instance:onPlayerLeft')
AddEventHandler('instance:onPlayerLeft', function(instance, player)
	if player == instance.host then TriggerEvent('instance:leave') end
end)