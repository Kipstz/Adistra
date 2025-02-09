
Config['rob_vangelico'] = {
	AirVent = {-635.94, -213.95, 53.54}, -- First step
	AirVentDist = 15, -- Distance to show the ['air_vent'] text
	GasTime = 3, -- Time before removing the gas, in minutes
	RobTime = 10, -- How many minutes the thief has to rob the jewels before the robbery gets cancelled
	MinPolice = 0, -- Min amount of Cops online to trigger the robbery
	PoliceJobName = {'police', 'sheriff', 'fib', 'swat'},
	RewardMoney = false, -- Give money?
	Account = 'black_money',
	Money = 1000, -- Money per stand
	RewardItem = true, -- Reward item?
	Cooldown = 2400, -- 40 minutes
	WeaponsWL = true, -- Needs specific weapon to smash the glass?
	
	Weapons = { -- If player is using one of this weapons it will be able to smash the stands
		-1074790547, -- assault rifle
		961495388, -- assault rifle mk2
		-2084633992, --carabine
		1627465347, --gusenberg
		-2067956739, -- crowbar
		-1786099057 -- bat
	},
	
	Items = {
		{item = 'collier', amount = 1},
		{item = 'bague', amount = 1},
		{item = 'bijoux', amount = 1}
	},
	
	Lang = {
		['blip'] = 'Bijouterie',
		['air_vent'] = 'Inspecter',
		['plant_gas'] = 'Appuyez sur ~r~[E]~w~ pour poser la bombe',
		['started'] = 'Le braquage de Bijouterie à Commencé !',
		['police'] = 'Alarme déclencher à la Bijouterie !',
		['break'] = 'Appuyez sur ~r~[E]~w~ pour briser le verre',
		['needs_weapon'] = 'Tu as besoin de quelque chose pour briser le verre',
		['stole'] = 'Vous avez volé ',
		['cooldown'] = 'La Bijouterie a récemment été cambriolé, réessayez plus tard',
		['not_cops'] = "Il n'y a pas asser de flics !"
	}
}