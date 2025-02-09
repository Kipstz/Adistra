local Components = {
	{label = "Sexe",					    	name = 'sex',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = "Visage",					        name = 'face',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = "Couleur de Peau",					name = 'skin',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = "Cheveux",					        name = 'hair_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = "Cheveux 2",					    name = 'hair_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof = 'hair_1'},
	{label = "Couleur de Cheveux",			    name = 'hair_color_1',		value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = "Couleur de Cheveux 2",			name = 'hair_color_2',		value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = "Tshirt",				            name = 'tshirt_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = "Tshirt 2",				        name = 'tshirt_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof = 'tshirt_1'},
	{label = "Torse",					        name = 'torso_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = "Torse 2",					        name = 'torso_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof = 'torso_1'},
	{label = "Calques",				            name = 'decals_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = "Calques 2",				        name = 'decals_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof = 'decals_1'},
	{label = "Gants",					        name = 'arms',				value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = "Gants 2",					        name = 'arms_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = "Pantalon",					    name = 'pants_1',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.5},
	{label = "Pantalon 2",					    name = 'pants_2',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.5,	textureof = 'pants_1'},
	{label = "Chaussures",					    name = 'shoes_1',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.8},
	{label = "Chaussures 2",					name = 'shoes_2',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.8,	textureof = 'shoes_1'},
	{label = "Masque",					        name = 'mask_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = "Masque 2",				    	name = 'mask_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof = 'mask_1'},
	{label = "Gilet par Balle",			    	name = 'bproof_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = "Gilet par Balle 2",				name = 'bproof_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof = 'bproof_1'},
	{label = "Chaine",					        name = 'chain_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = "Chaine 2",				    	name = 'chain_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof = 'chain_1'},
	{label = "Casque 1",				        name = 'helmet_1',			value = -1,		min = -1,	zoomOffset = 0.6,		camOffset = 0.65,	componentId	= 0},
	{label = "Casque 2",				        name = 'helmet_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof = 'helmet_1'},
	{label = "Lunettes",			        	name = 'glasses_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = "Lunettes 2",				        name = 'glasses_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof = 'glasses_1'},
	{label = "Montre",				            name = 'watches_1',			value = -1,		min = -1,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = "Montre 2",			         	name = 'watches_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof = 'watches_1'},
	{label = "Bracelets",			        	name = 'bracelets_1',		value = -1,		min = -1,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = "Bracelets 2",			         	name = 'bracelets_2',		value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof = 'bracelets_1'},
	{label = "Sac",					        	name = 'bags_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = "Couleur du Sac",			     	name = 'bags_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof = 'bags_1'},
	{label = "Couleur des Yeux",				name = 'eye_color',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Taille des Sourcils",		     	name = 'eyebrows_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Type des Sourcils",			    name = 'eyebrows_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Couleur des Sourcils",			name = 'eyebrows_3',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Couleur des Sourcils 2",			name = 'eyebrows_4',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Type de Maquillage",				name = 'makeup_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Opacité du Maquillage",		    name = 'makeup_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Couleur du Maquillage",			name = 'makeup_3',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Couleur du Maquillage 2",			name = 'makeup_4',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Type de Lipstick",			    name = 'lipstick_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Opacité du Lipstick",		        name = 'lipstick_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Couleur du Lipstick",		        name = 'lipstick_3',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Couleur du Lipstick 2",		    name = 'lipstick_4',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Accessoires Oreilles",			name = 'ears_1',			value = -1,		min = -1,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Couleur des Accessoires",     	name = 'ears_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65,	textureof = 'ears_1'},
	{label = "Pilositée",				        name = 'chest_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = "Opacité Pilositée",			    name = 'chest_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = "Couleur Pilositée",				name = 'chest_3',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = "Imperfections",					name = 'bodyb_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = "Opacité Imperfections",		    name = 'bodyb_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = "Rides",				            name = 'age_1',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Opacité des Rides",		        name = 'age_2',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Boutons",				            name = 'blemishes_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Opacité des Boutons",		     	name = 'blemishes_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Rougeurs",				    	name = 'blush_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Opacité des Rougeurs",		    name = 'blush_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Couleur des Rougeurs",		    name = 'blush_3',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Teint",				            name = 'complexion_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Opacité Teint",		        	name = 'complexion_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Dommages UV",						name = 'sun_1',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Opacité des Dommages UV",			name = 'sun_2',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Taches de Rousseurs",				name = 'moles_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Opacité Rousseurs",				name = 'moles_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Type de Barbe",				    name = 'beard_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Taille de la Barbe",				name = 'beard_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Couleur de la Barbe",			    name = 'beard_3',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Couleur de la Barbe 2",			name = 'beard_4',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65}
}

SkinChanger.LastSex = -1
SkinChanger.LoadSkin = nil
SkinChanger.LoadClothes = nil
SkinChanger.Character = {}

for i = 1, #Components, 1 do
	SkinChanger.Character[Components[i].name] = Components[i].value or 0
end

function LoadDefaultModel(malePed, cb)
	local plyPed = PlayerPedId()
	local characterModel

	if malePed then
		characterModel = `mp_m_freemode_01`
	else
		characterModel = `mp_f_freemode_01`
	end

	Citizen.CreateThread(function()
		Framework.Streaming.RequestModel(characterModel, function()
			if IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
				SetPlayerModel(PlayerId(), characterModel)
				SetPedDefaultComponentVariation(plyPed)
			end

			SetModelAsNoLongerNeeded(characterModel)
			SetEntityVisible(PlayerPedId(), true)

			if cb then
				cb()
			end

			TriggerEvent('skinchanger:modelLoaded')
			Wait(2000)
			TriggerEvent('framework:restoreLoadout')
		end)
	end)
end

function GetMaxVals()
	local plyPed = PlayerPedId()

	local data = {
		sex = 1,
		face = 45,
		skin = 45,
		age_1 = GetNumHeadOverlayValues(3) - 1,
		age_2 = 10,
		beard_1 = GetNumHeadOverlayValues(1) - 1,
		beard_2 = 10,
		beard_3 = GetNumHairColors() - 1,
		beard_4 = GetNumHairColors() - 1,
		hair_1 = GetNumberOfPedDrawableVariations(plyPed, 2) - 1,
		hair_2 = GetNumberOfPedTextureVariations(plyPed, 2, SkinChanger.Character['hair_1']) - 1,
		hair_color_1 = GetNumHairColors() - 1,
		hair_color_2 = GetNumHairColors() - 1,
		eye_color = 31,
		eyebrows_1 = GetNumHeadOverlayValues(2) - 1,
		eyebrows_2 = 10,
		eyebrows_3 = GetNumHairColors() - 1,
		eyebrows_4 = GetNumHairColors() - 1,
		makeup_1 = GetNumHeadOverlayValues(4) - 1,
		makeup_2 = 10,
		makeup_3 = GetNumHairColors() - 1,
		makeup_4 = GetNumHairColors() - 1,
		lipstick_1 = GetNumHeadOverlayValues(8) - 1,
		lipstick_2 = 10,
		lipstick_3 = GetNumHairColors() - 1,
		lipstick_4 = GetNumHairColors() - 1,
		blemishes_1 = GetNumHeadOverlayValues(0) - 1,
		blemishes_2 = 10,
		blush_1 = GetNumHeadOverlayValues(5) - 1,
		blush_2 = 10,
		blush_3 = GetNumHairColors() - 1,
		complexion_1 = GetNumHeadOverlayValues(6) - 1,
		complexion_2 = 10,
		sun_1 = GetNumHeadOverlayValues(7) - 1,
		sun_2 = 10,
		moles_1 = GetNumHeadOverlayValues(9) - 1,
		moles_2 = 10,
		chest_1 = GetNumHeadOverlayValues(10) - 1,
		chest_2 = 10,
		chest_3 = GetNumHairColors() - 1,
		bodyb_1 = GetNumHeadOverlayValues(11) - 1,
		bodyb_2 = 10,
		ears_1 = GetNumberOfPedPropDrawableVariations(plyPed, 1) - 1,
		ears_2 = GetNumberOfPedPropTextureVariations(plyPed, 1, SkinChanger.Character['ears_1']) - 1,
		tshirt_1 = GetNumberOfPedDrawableVariations(plyPed, 8) - 1,
		tshirt_2 = GetNumberOfPedTextureVariations(plyPed, 8, SkinChanger.Character['tshirt_1']) - 1,
		torso_1 = GetNumberOfPedDrawableVariations(plyPed, 11) - 1,
		torso_2 = GetNumberOfPedTextureVariations(plyPed, 11, SkinChanger.Character['torso_1']) - 1,
		decals_1 = GetNumberOfPedDrawableVariations(plyPed, 10) - 1,
		decals_2 = GetNumberOfPedTextureVariations(plyPed, 10, SkinChanger.Character['decals_1']) - 1,
		arms = GetNumberOfPedDrawableVariations(plyPed, 3) - 1,
		arms_2 = 10,
		pants_1 = GetNumberOfPedDrawableVariations(plyPed, 4) - 1,
		pants_2 = GetNumberOfPedTextureVariations(plyPed, 4, SkinChanger.Character['pants_1']) - 1,
		shoes_1 = GetNumberOfPedDrawableVariations(plyPed, 6) - 1,
		shoes_2 = GetNumberOfPedTextureVariations(plyPed, 6, SkinChanger.Character['shoes_1']) - 1,
		mask_1 = GetNumberOfPedDrawableVariations(plyPed, 1) - 1,
		mask_2 = GetNumberOfPedTextureVariations(plyPed, 1, SkinChanger.Character['mask_1']) - 1,
		bproof_1 = GetNumberOfPedDrawableVariations(plyPed, 9) - 1,
		bproof_2 = GetNumberOfPedTextureVariations(plyPed, 9, SkinChanger.Character['bproof_1']) - 1,
		chain_1 = GetNumberOfPedDrawableVariations(plyPed, 7) - 1,
		chain_2 = GetNumberOfPedTextureVariations(plyPed, 7, SkinChanger.Character['chain_1']) - 1,
		bags_1 = GetNumberOfPedDrawableVariations(plyPed, 5) - 1,
		bags_2 = GetNumberOfPedTextureVariations(plyPed, 5, SkinChanger.Character['bags_1']) - 1,
		helmet_1 = GetNumberOfPedPropDrawableVariations(plyPed, 0) - 1,
		helmet_2 = GetNumberOfPedPropTextureVariations(plyPed, 0, SkinChanger.Character['helmet_1']) - 1,
		glasses_1 = GetNumberOfPedPropDrawableVariations(plyPed, 1) - 1,
		glasses_2 = GetNumberOfPedPropTextureVariations(plyPed, 1, SkinChanger.Character['glasses_1'] - 1),
		watches_1 = GetNumberOfPedPropDrawableVariations(plyPed, 6) - 1,
		watches_2 = GetNumberOfPedPropTextureVariations(plyPed, 6, SkinChanger.Character['watches_1']) - 1,
		bracelets_1 = GetNumberOfPedPropDrawableVariations(plyPed, 7) - 1,
		bracelets_2 = GetNumberOfPedPropTextureVariations(plyPed, 7, SkinChanger.Character['bracelets_1']) - 1
	}

	return data
end

function ApplySkin(skin, clothes)
	local plyPed = PlayerPedId()
	-- local notTouch = {
	-- 	'sex', 'face', 'skin', 'age_1', 'age_2', 'eye_color', 'beard_1', 'beard_2', 'beard_3', 'beard_4', 'hair_1', 'hair_2', 
	-- 	'hair_color_1', 'hair_color_2', 'eyebrows_1', 'eyebrows_2', 'eyebrows_3', 'eyebrows_4', 'makeup_1', 'makeup_2', 
	-- 	'makeup_3', 'makeup_4', 'lipstick_1', 'lipstick_2', 'lipstick_3', 'lipstick_4', 'blemishes_1', 'blemishes_2', 'blush_1', 
	-- 	'blush_2', 'blush_3', 'complexion_1', 'complexion_2', 'sun_1', 'sun_2', 'moles_1', 'moles_2', 'chest_1', 'chest_2', 
	-- 	'chest_3', 'bodyb_1', 'bodyb_2',
	-- }

	for k, v in pairs(skin) do
		SkinChanger.Character[k] = v
	end

	if clothes ~= nil then
		for k, v in pairs(clothes) do
			if
				k ~= 'sex' and
				k ~= 'face' and
				k ~= 'skin' and
				k ~= 'age_1' and
				k ~= 'age_2' and
				k ~= 'eye_color' and
				k ~= 'beard_1' and
				k ~= 'beard_2' and
				k ~= 'beard_3' and
				k ~= 'beard_4' and
				k ~= 'hair_1' and
				k ~= 'hair_2' and
				k ~= 'hair_color_1' and
				k ~= 'hair_color_2' and
				k ~= 'eyebrows_1' and
				k ~= 'eyebrows_2' and
				k ~= 'eyebrows_3' and
				k ~= 'eyebrows_4' and
				k ~= 'makeup_1' and
				k ~= 'makeup_2' and
				k ~= 'makeup_3' and
				k ~= 'makeup_4' and
				k ~= 'lipstick_1' and
				k ~= 'lipstick_2' and
				k ~= 'lipstick_3' and
				k ~= 'lipstick_4' and
				k ~= 'blemishes_1' and
				k ~= 'blemishes_2' and
				k ~= 'blush_1' and
				k ~= 'blush_2' and
				k ~= 'blush_3' and
				k ~= 'complexion_1' and
				k ~= 'complexion_2' and
				k ~= 'sun_1' and
				k ~= 'sun_2' and
				k ~= 'moles_1' and
				k ~= 'moles_2' and
				k ~= 'chest_1' and
				k ~= 'chest_2' and
				k ~= 'chest_3' and
				k ~= 'bodyb_1' and
				k ~= 'bodyb_2'
			then
				SkinChanger.Character[k] = v
			end
		end
	end

	SetPedHeadBlendData(plyPed, SkinChanger.Character['face'], SkinChanger.Character['face'], SkinChanger.Character['face'], SkinChanger.Character['skin'], SkinChanger.Character['skin'], SkinChanger.Character['skin'], 1.0, 1.0, 1.0, true)

	SetPedHairColor(plyPed, SkinChanger.Character['hair_color_1'], SkinChanger.Character['hair_color_2']) -- Hair Color
	SetPedHeadOverlay(plyPed, 3, SkinChanger.Character['age_1'], (SkinChanger.Character['age_2'] / 10) + 0.0) -- Age + opacity
	SetPedHeadOverlay(plyPed, 1, SkinChanger.Character['beard_1'], (SkinChanger.Character['beard_2'] / 10) + 0.0) -- Beard + opacity
	SetPedEyeColor(plyPed, SkinChanger.Character['eye_color'], 0, 1) -- Eyes color
	SetPedHeadOverlay(plyPed, 2, SkinChanger.Character['eyebrows_1'], (SkinChanger.Character['eyebrows_2'] / 10) + 0.0) -- Eyebrows + opacity
	SetPedHeadOverlay(plyPed, 4, SkinChanger.Character['makeup_1'], (SkinChanger.Character['makeup_2'] / 10) + 0.0) -- Makeup + opacity
	SetPedHeadOverlay(plyPed, 8, SkinChanger.Character['lipstick_1'], (SkinChanger.Character['lipstick_2'] / 10) + 0.0) -- Lipstick + opacity
	SetPedComponentVariation(plyPed, 2, SkinChanger.Character['hair_1'], SkinChanger.Character['hair_2'], 2) -- Hair
	SetPedHeadOverlayColor(plyPed, 1, 1,	SkinChanger.Character['beard_3'], SkinChanger.Character['beard_4']) -- Beard Color
	SetPedHeadOverlayColor(plyPed, 2, 1,	SkinChanger.Character['eyebrows_3'], SkinChanger.Character['eyebrows_4']) -- Eyebrows Color
	SetPedHeadOverlayColor(plyPed, 4, 1,	SkinChanger.Character['makeup_3'], SkinChanger.Character['makeup_4']) -- Makeup Color
	SetPedHeadOverlayColor(plyPed, 8, 1,	SkinChanger.Character['lipstick_3'], SkinChanger.Character['lipstick_4']) -- Lipstick Color
	SetPedHeadOverlay(plyPed, 5, SkinChanger.Character['blush_1'], (SkinChanger.Character['blush_2'] / 10) + 0.0) -- Blush + opacity
	SetPedHeadOverlayColor(plyPed, 5, 2,	SkinChanger.Character['blush_3']) -- Blush Color
	SetPedHeadOverlay(plyPed, 6, SkinChanger.Character['complexion_1'], (SkinChanger.Character['complexion_2'] / 10) + 0.0) -- Complexion + opacity
	SetPedHeadOverlay(plyPed, 7, SkinChanger.Character['sun_1'], (SkinChanger.Character['sun_2'] / 10) + 0.0) -- Sun Damage + opacity
	SetPedHeadOverlay(plyPed, 9, SkinChanger.Character['moles_1'], (SkinChanger.Character['moles_2'] / 10) + 0.0) -- Moles/Freckles + opacity
	SetPedHeadOverlay(plyPed, 10, SkinChanger.Character['chest_1'], (SkinChanger.Character['chest_2'] / 10) + 0.0) -- Chest Hair + opacity
	SetPedHeadOverlayColor(plyPed, 10, 1, SkinChanger.Character['chest_3']) -- Torso Color
	SetPedHeadOverlay(plyPed, 11, SkinChanger.Character['bodyb_1'], (SkinChanger.Character['bodyb_2'] / 10) + 0.0) -- Body Blemishes + opacity

	if SkinChanger.Character['ears_1'] == -1 then
		ClearPedProp(plyPed, 2)
	else
		SetPedPropIndex(plyPed, 2, SkinChanger.Character['ears_1'], SkinChanger.Character['ears_2'], 2) -- Ears Accessories
	end

	SetPedComponentVariation(plyPed, 8, SkinChanger.Character['tshirt_1'], SkinChanger.Character['tshirt_2'], 2) -- Tshirt
	SetPedComponentVariation(plyPed, 11, SkinChanger.Character['torso_1'], SkinChanger.Character['torso_2'], 2) -- torso parts
	SetPedComponentVariation(plyPed, 3, SkinChanger.Character['arms'], SkinChanger.Character['arms_2'], 2) -- Arms
	SetPedComponentVariation(plyPed, 10, SkinChanger.Character['decals_1'], SkinChanger.Character['decals_2'], 2) -- decals
	SetPedComponentVariation(plyPed, 4, SkinChanger.Character['pants_1'], SkinChanger.Character['pants_2'], 2) -- pants
	SetPedComponentVariation(plyPed, 6, SkinChanger.Character['shoes_1'], SkinChanger.Character['shoes_2'], 2) -- shoes
	SetPedComponentVariation(plyPed, 1, SkinChanger.Character['mask_1'], SkinChanger.Character['mask_2'], 2) -- mask
	SetPedComponentVariation(plyPed, 9, SkinChanger.Character['bproof_1'], SkinChanger.Character['bproof_2'], 2) -- bulletproof
	SetPedComponentVariation(plyPed, 7, SkinChanger.Character['chain_1'], SkinChanger.Character['chain_2'], 2) -- chain
	SetPedComponentVariation(plyPed, 5, SkinChanger.Character['bags_1'], SkinChanger.Character['bags_2'], 2) -- Bag

	if SkinChanger.Character['helmet_1'] == -1 then
		ClearPedProp(plyPed, 0)
	else
		SetPedPropIndex(plyPed, 0, SkinChanger.Character['helmet_1'], SkinChanger.Character['helmet_2'], 2) -- Helmet
	end

	if SkinChanger.Character['glasses_1'] == -1 then
		ClearPedProp(plyPed, 1)
	else
		SetPedPropIndex(plyPed, 1, SkinChanger.Character['glasses_1'], SkinChanger.Character['glasses_2'], 2) -- Glasses
	end

	if SkinChanger.Character['watches_1'] == -1 then
		ClearPedProp(plyPed, 6)
	else
		SetPedPropIndex(plyPed, 6, SkinChanger.Character['watches_1'], SkinChanger.Character['watches_2'], 2) -- Watches
	end

	if SkinChanger.Character['bracelets_1'] == -1 then
		ClearPedProp(plyPed,	7)
	else
		SetPedPropIndex(plyPed, 7, SkinChanger.Character['bracelets_1'], SkinChanger.Character['bracelets_2'], 2) -- Bracelets
	end

	-- if SkinChanger.Character['bproof_1'] == 0 then
	-- 	SetPedArmour(plyPed, 0)
	-- else
	-- 	SetPedArmour(plyPed, 100)
	-- end
end

AddEventHandler('skinchanger:loadDefaultModel', function(loadMale, cb)
	LoadDefaultModel(loadMale, cb)
end)

AddEventHandler('skinchanger:getData', function(cb)
	local components = json.decode(json.encode(Components))

	for k, v in pairs(SkinChanger.Character) do
		for i = 1, #components, 1 do
			if k == components[i].name then
				components[i].value = v
			end
		end
	end

	cb(components, GetMaxVals())
end)

AddEventHandler('skinchanger:change', function(key, val)
	SkinChanger.Character[key] = val

	if key == 'sex' then
		TriggerEvent('skinchanger:loadSkin', SkinChanger.Character)
	else
		ApplySkin(SkinChanger.Character)
	end
end)

AddEventHandler('skinchanger:getSkin', function(cb)
	cb(SkinChanger.Character)
end)

AddEventHandler('skinchanger:modelLoaded', function()
	ClearPedProp(PlayerPedId(), 0)

	if SkinChanger.LoadSkin ~= nil then
		ApplySkin(SkinChanger.LoadSkin)

		SkinChanger.LoadSkin = nil
	end

	if SkinChanger.LoadClothes ~= nil then
		ApplySkin(SkinChanger.LoadClothes.playerSkin, SkinChanger.LoadClothes.clothesSkin)
		SkinChanger.LoadClothes = nil
	end
end)

RegisterNetEvent('skinchanger:loadSkin')
AddEventHandler('skinchanger:loadSkin', function(skin, cb)
	if skin['sex'] ~= SkinChanger.LastSex then
		SkinChanger.LoadSkin = skin

		if skin['sex'] == 0 then
			TriggerEvent('skinchanger:loadDefaultModel', true, cb)
		else
			TriggerEvent('skinchanger:loadDefaultModel', false, cb)
		end
	else
		ApplySkin(skin)

		if cb then
			cb()
		end
	end

	SkinChanger.LastSex = skin['sex']
end)

RegisterNetEvent('skinchanger:loadClothes')
AddEventHandler('skinchanger:loadClothes', function(playerSkin, clothesSkin)
	if playerSkin['sex'] ~= SkinChanger.LastSex then
		SkinChanger.LoadClothes = {
			playerSkin = playerSkin,
			clothesSkin = clothesSkin
		}

		if playerSkin['sex'] == 0 then
			TriggerEvent('skinchanger:loadDefaultModel', true)
		else
			TriggerEvent('skinchanger:loadDefaultModel', false)
		end
	else
		ApplySkin(playerSkin, clothesSkin)
	end

	SkinChanger.LastSex = playerSkin['sex']
end)

RegisterNetEvent('skinchanger:reloadSkinPlayer')
AddEventHandler('skinchanger:reloadSkinPlayer', function()
	Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin) 
	end)
end)