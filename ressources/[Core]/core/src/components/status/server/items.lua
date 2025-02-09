
-- Items Hunger / Thirst --
Framework.ITEMS:RegisterUsableItem('bread', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('bread', 1)

	TriggerClientEvent('status:add', source, 'hunger', 800000)
	TriggerClientEvent('status:onEat', source, 'prop_cs_burger_01')
	TriggerClientEvent('framework:showNotification', source, "Vous avez mangé ~b~1x ~g~pain")
end)

Framework.ITEMS:RegisterUsableItem('burger', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('burger', 1)

	TriggerClientEvent('status:add', source, 'hunger', 1000000)
	TriggerClientEvent('status:onEat', source, 'prop_cs_burger_01')
	TriggerClientEvent('framework:showNotification', source, "Vous avez mangé ~b~1x ~g~Burger")
end)

Framework.ITEMS:RegisterUsableItem('frites', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('frites', 1)

	TriggerClientEvent('status:add', source, 'hunger',  900000)
	TriggerClientEvent('status:onEat', source, 'prop_cs_plate_01')
	TriggerClientEvent('framework:showNotification', source, "Vous avez mangé ~b~1x ~g~Frites")
end)

Framework.ITEMS:RegisterUsableItem('cookies_adiscook', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('cookies_adiscook', 1)

	TriggerClientEvent('status:add', source, 'hunger',  900000)
	TriggerClientEvent('status:onEat', source, 'prop_cs_pebble_02')
	TriggerClientEvent('framework:showNotification', source, "Vous avez mangé ~b~1x ~g~Cookie AdisCook")
end)

Framework.ITEMS:RegisterUsableItem('cookies_adiscook_caramel', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('cookies_adiscook_caramel', 1)

	TriggerClientEvent('status:add', source, 'hunger',  900000)
	TriggerClientEvent('status:onEat', source, 'prop_cs_pebble_02')
	TriggerClientEvent('framework:showNotification', source, "Vous avez mangé ~b~1x ~g~Cookie AdisCook Caramel")
end)

Framework.ITEMS:RegisterUsableItem('cookies_choco', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('cookies_choco', 1)

	TriggerClientEvent('status:add', source, 'hunger',  900000)
	TriggerClientEvent('status:onEat', source, 'prop_cs_pebble_02')
	TriggerClientEvent('framework:showNotification', source, "Vous avez mangé ~b~1x ~g~Cookie Chocolat")
end)

Framework.ITEMS:RegisterUsableItem('cookies_choco_caramel', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('cookies_choco_caramel', 1)

	TriggerClientEvent('status:add', source, 'hunger',  900000)
	TriggerClientEvent('status:onEat', source, 'prop_cs_pebble_02')
	TriggerClientEvent('framework:showNotification', source, "Vous avez mangé ~b~1x ~g~Cookie Chocolat Caramel")
end)

Framework.ITEMS:RegisterUsableItem('pain_cuit', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('pain_cuit', 1)

	TriggerClientEvent('status:add', source, 'hunger',  900000)
	TriggerClientEvent('status:onEat', source, 'prop_cs_burger_01')
	TriggerClientEvent('framework:showNotification', source, "Vous avez mangé ~b~1x ~g~Pain Cuit")
end)

Framework.ITEMS:RegisterUsableItem('steak_cuit', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('steak_cuit', 1)

	TriggerClientEvent('status:add', source, 'hunger',  900000)
	TriggerClientEvent('status:onEat', source, 'prop_cs_burger_01')
	TriggerClientEvent('framework:showNotification', source, "Vous avez mangé ~b~1x ~g~Steak Cuit")
end)

Framework.ITEMS:RegisterUsableItem('water', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('water', 1)

	TriggerClientEvent('status:add', source, 'thirst', 800000)
	TriggerClientEvent('status:onDrink', source, 'prop_ld_flow_bottle')
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~eau")
end)

Framework.ITEMS:RegisterUsableItem('diabolomenthe', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('diabolomenthe', 1)

	TriggerClientEvent('status:add', source, 'thirst', 800000)
	TriggerClientEvent('status:onDrink', source, 'prop_ld_flow_bottle')
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~Diabolo-Menthe")
end)

Framework.ITEMS:RegisterUsableItem('jusdefruit', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('jusdefruit', 1)

	TriggerClientEvent('status:add', source, 'thirst', 100000)
	TriggerClientEvent('status:onEat', source, 'prop_cs_burger_01')
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~Jus de Fruit")
end)

Framework.ITEMS:RegisterUsableItem('eaugazifie', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('eaugazifie', 1)

	TriggerClientEvent('status:add', source, 'thirst', 600000)
	TriggerClientEvent('status:onDrink', source, 'prop_ld_flow_bottle')
	TriggerClientEvent('framework:showNotification', source, 'Vous avez utilisé x1 bouteille d\'eau gazifié')
end)

Framework.ITEMS:RegisterUsableItem('pepsi', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('pepsi', 1)

	TriggerClientEvent('status:add', source, 'thirst', 750000)
	TriggerClientEvent('status:onDrink', source, 'prop_ecola_can')
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~pepsi")
end)

Framework.ITEMS:RegisterUsableItem('7up', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('7up', 1)

	TriggerClientEvent('status:add', source, 'thirst', 750000)
	TriggerClientEvent('status:onDrink', source, 'prop_ld_can_01')
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~7up")
end)

Framework.ITEMS:RegisterUsableItem('coca', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('coca', 1)

	TriggerClientEvent('status:add', source, 'thirst', 750000)
	TriggerClientEvent('status:onDrink', source, 'prop_ecola_can')
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~coca")
end)

Framework.ITEMS:RegisterUsableItem('fanta', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('fanta', 1)

	TriggerClientEvent('status:add', source, 'thirst', 750000)
	TriggerClientEvent('status:onDrink', source, 'prop_orang_can_01')
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~fanta")
end)

Framework.ITEMS:RegisterUsableItem('grenadine', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('grenadine', 1)

	TriggerClientEvent('status:add', source, 'thirst', 750000)
	TriggerClientEvent('status:onDrink', source, 'prop_orang_can_01')
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~Grenadine")
end)

Framework.ITEMS:RegisterUsableItem('sprite', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('sprite', 1)

	TriggerClientEvent('status:add', source, 'thirst', 750000)
	TriggerClientEvent('status:onDrink', source, 'prop_ld_can_01')
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~sprite")
end)

Framework.ITEMS:RegisterUsableItem('orangina', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('orangina', 1)

	TriggerClientEvent('status:add', source, 'thirst', 750000)
	TriggerClientEvent('status:onDrink', source, 'prop_orang_can_01')
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~orangina")
end)

Framework.ITEMS:RegisterUsableItem('cocktail', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('cocktail', 1)

	TriggerClientEvent('status:add', source, 'thirst', 400000)
	TriggerClientEvent('status:onDrink', source, 'prop_cocktail')
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~cocktail")
end)

Framework.ITEMS:RegisterUsableItem('bonbons', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('bonbons', 1)

	TriggerClientEvent('status:add', source, 'hunger', 100000)
	TriggerClientEvent('status:onEat', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez mangé ~b~1x ~g~bonbons")
end)

Framework.ITEMS:RegisterUsableItem('burger', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('burger', 1)

	TriggerClientEvent('status:add', source, 'hunger', 800000)
	TriggerClientEvent('status:onEat', source, 'prop_cs_burger_01')
	TriggerClientEvent('framework:showNotification', source,"Vous avez mangé ~b~1x ~g~hamburger")
end)

Framework.ITEMS:RegisterUsableItem('bigmac', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('bigmac', 1)

	TriggerClientEvent('status:add', source, 'hunger', 600000)
	TriggerClientEvent('status:onEat', source, 'prop_cs_burger_01')
	TriggerClientEvent('framework:showNotification', source,"Vous avez mangé ~b~1x ~g~Big-Mac")
end)

Framework.ITEMS:RegisterUsableItem('soda', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('soda', 1)

	TriggerClientEvent('status:add', source, 'thirst', 750000)
	TriggerClientEvent('status:onEat', source, 'prop_orang_can_01')
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~soda")
end)

Framework.ITEMS:RegisterUsableItem('viande', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('viande', 1)

	TriggerClientEvent('status:add', source, 'hunger', 800000)
	TriggerClientEvent('status:onEat', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez mangé ~b~1x ~g~viande")
end)

Framework.ITEMS:RegisterUsableItem('pomme', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('pomme', 1)

	TriggerClientEvent('status:add', source, 'hunger', 50000)
	TriggerClientEvent('status:add', source, 'thirst', 20000)
	TriggerClientEvent('status:onEat', source, 'prop_cs_burger_01')
	TriggerClientEvent('framework:showNotification', source, "Vous avez mangé ~b~1x ~g~pomme")
end)

Framework.ITEMS:RegisterUsableItem('tarte_pomme', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('tarte_pomme', 1)

	TriggerClientEvent('status:add', source, 'hunger', 250000)
	TriggerClientEvent('status:onEat', source, 'prop_cs_burger_01')
	TriggerClientEvent('framework:showNotification', source, "Vous avez mangé ~b~1x ~g~Tarte au Pomme")
end)

Framework.ITEMS:RegisterUsableItem('orange', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('orange', 1)

	TriggerClientEvent('status:add', source, 'hunger', 20000)
	TriggerClientEvent('status:add', source, 'thirst', 25000)
	TriggerClientEvent('status:onEat', source, 'prop_cs_burger_01')
	TriggerClientEvent('framework:showNotification', source, "Vous avez mangé ~b~1x ~g~orange")
end)

-- BAHAMAS & UNICORN --

Framework.ITEMS:RegisterUsableItem('biere', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('biere', 1)

	TriggerClientEvent('status:add', source, 'drunk', 250000)
	TriggerClientEvent('status:onDrinkAlcohol', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~Bière")
end)

Framework.ITEMS:RegisterUsableItem('vodka', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('vodka', 1)

	TriggerClientEvent('status:add', source, 'drunk', 250000)
	TriggerClientEvent('status:onDrinkAlcohol', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~Vodka")
end)

Framework.ITEMS:RegisterUsableItem('champ', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('champ', 1)

	TriggerClientEvent('status:add', source, 'drunk', 250000)
	TriggerClientEvent('status:onDrinkAlcohol', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~Champagne")
end)

Framework.ITEMS:RegisterUsableItem('vodkacrazy', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('vodkacrazy', 1)

	TriggerClientEvent('status:add', source, 'drunk', 250000)
	TriggerClientEvent('status:onDrinkAlcohol', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~Vodka Crazy")
end)

Framework.ITEMS:RegisterUsableItem('whiskycoca', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('whiskycoca', 1)

	TriggerClientEvent('status:add', source, 'drunk', 250000)
	TriggerClientEvent('status:onDrinkAlcohol', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~Whisky-Coca")
end)

Framework.ITEMS:RegisterUsableItem('whisky', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('whisky', 1)

	TriggerClientEvent('status:add', source, 'drunk', 250000)
	TriggerClientEvent('status:onDrinkAlcohol', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~Whisky")
end)

Framework.ITEMS:RegisterUsableItem('mojito', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('mojito', 1)

	TriggerClientEvent('status:add', source, 'drunk', 250000)
	TriggerClientEvent('status:onDrinkAlcohol', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~Mojito")
end)

Framework.ITEMS:RegisterUsableItem('monaco', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('monaco', 1)

	TriggerClientEvent('status:add', source, 'drunk', 250000)
	TriggerClientEvent('status:onDrinkAlcohol', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez utilisé ~b~1x ~g~Monaco")
end)

Framework.ITEMS:RegisterUsableItem('gintonic', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('gintonic', 1)

	TriggerClientEvent('status:add', source, 'drunk', 250000)
	TriggerClientEvent('status:onDrinkAlcohol', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez utilisé ~b~1x ~g~Gin-Tonic")
end)

Framework.ITEMS:RegisterUsableItem('perroquet', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('perroquet', 1)

	TriggerClientEvent('status:add', source, 'drunk', 250000)
	TriggerClientEvent('status:onDrinkAlcohol', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~Perroquet")
end)

Framework.ITEMS:RegisterUsableItem('mauresque', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('mauresque', 1)

	TriggerClientEvent('status:add', source, 'drunk', 250000)
	TriggerClientEvent('status:onDrinkAlcohol', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~Mauresque")
end)

Framework.ITEMS:RegisterUsableItem('coubalibre', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('coubalibre', 1)

	TriggerClientEvent('status:add', source, 'drunk', 250000)
	TriggerClientEvent('status:onDrinkAlcohol', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~Coubalibre")
end)

Framework.ITEMS:RegisterUsableItem('punch', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('punch', 1)

	TriggerClientEvent('status:add', source, 'punch', 250000)
	TriggerClientEvent('status:onDrinkAlcohol', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~Punch")
end)

Framework.ITEMS:RegisterUsableItem('rhum', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('rhum', 1)

	TriggerClientEvent('status:add', source, 'drunk', 250000)
	TriggerClientEvent('status:onDrinkAlcohol', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~Rhum")
end)

Framework.ITEMS:RegisterUsableItem('rhumblanc', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('rhumblanc', 1)

	TriggerClientEvent('status:add', source, 'drunk', 250000)
	TriggerClientEvent('status:onDrinkAlcohol', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~Rhum-Blanc")
end)

Framework.ITEMS:RegisterUsableItem('ricard', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('ricard', 1)

	TriggerClientEvent('status:add', source, 'drunk', 250000)
	TriggerClientEvent('status:onDrinkAlcohol', source)
	TriggerClientEvent('framework:showNotification', source, "Vous avez bu ~b~1x ~g~Ricard")
end)


-- Items Drug --
Framework.ITEMS:RegisterUsableItem('adiskush_pooch', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('adiskush_pooch', 1)

	TriggerClientEvent('status:add', source, 'drug', 166000)
	TriggerClientEvent('status:onAdis', source)
	TriggerClientEvent('framework:showNotification', source, "Ta Fumé de la frappe !")
end)

Framework.ITEMS:RegisterUsableItem('adismongo_pooch', function(source)
	local xPlayer = Framework.GetPlayerFromId(source)
	xPlayer['inventory'].removeInventoryItem('adismongo_pooch', 1)

	TriggerClientEvent('status:add', source, 'drug', 166000)
	TriggerClientEvent('status:onAdis', source)
	TriggerClientEvent('framework:showNotification', source, "Ta Fumé de la frappe !")
end)

-- Commands --
Framework.RegisterCommand('heal', {'mod', 'cm', 'admin', 'gi', 'gl', 'main-team', 'gamemaster', 'superadmin', 'owner'}, function(xPlayer, args, showError)
	args.playerId.triggerEvent('status:healPlayer')
	
	args.playerId.showNotification("Vous avez été HEAL !")
end, true, {help = "Heal un Joueur", validate = true, arguments = {
	{name = 'playerId', help = "Id du Joueur", type = 'player'}
}})