
Config['dpclothing'] = {
	Language = "fr",
	ExtrasEnabled = true,
	GUI = {
		Position = {x = 0.65, y = 0.5},
		AllowInCars = false,
		AllowWhenRagdolled = false,
		Enabled = true,
		Sound = true,
		TextColor = {255,255,255},
		TextOutline = true,
		TextFont = 0,
		TextSize = 0.21,
		Toggle = false,
	}
}

Config['dpclothing'].Commands = {
	['veste'] = {
		Func = function() DpClothing:ToggleClothing("Top") end,
		Sprite = "top",
		Desc = "Enlevez/Remettre votre Veste",
		Button = 1,
		Name = "Veste"
	},
	['gants'] = {
		Func = function() DpClothing:ToggleClothing("Gloves") end,
		Sprite = "gloves",
		Desc = "Enlevez/Remettre vos Gants",
		Button = 2,
		Name = "Gants"
	},
	['visière'] = {
		Func = function() DpClothing:ToggleProps("Visor") end,
		Sprite = "visor",
		Desc = "Enlevez/Remettre votre Visière",
		Button = 3,
		Name = "Visière"
	},
	['sac'] = {
		Func = function() DpClothing:ToggleClothing("Bag") end,
		Sprite = "bag",
		Desc = "Ouvrez/Fermez votre Sac",
		Button = 8,
		Name = "Sac"
	},
	['chaussures'] = {
		Func = function() DpClothing:ToggleClothing("Shoes") end,
		Sprite = "shoes",
		Desc = "Enlevez/Remettre vos Chaussures",
		Button = 5,
		Name = "Chaussures"
	},
	['gilet'] = {
		Func = function() DpClothing:ToggleClothing("Vest") end,
		Sprite = "vest",
		Desc = "Enlevez/Remettre votre Tshirt",
		Button = 14,
		Name = "Tshirt"
	},
	['cheveux'] = {
		Func = function() DpClothing:ToggleClothing("Hair") end,
		Sprite = "hair",
		Desc = "Mettez vos cheveux en haut/en bas/en chignon/en queue de cheval.",
		Button = 7,
		Name = "Cheveux"
	},
	['chapeau'] = {
		Func = function() DpClothing:ToggleProps("Hat") end,
		Sprite = "hat",
		Desc = "Enlevez/Remettre votre Chapeau",
		Button = 4,
		Name = "Chapeau"
	},
	['lunettes'] = {
		Func = function() DpClothing:ToggleProps("Glasses") end,
		Sprite = "glasses",
		Desc = "Enlevez/Remettre vos lunettes",
		Button = 9,
		Name = "Lunettes"
	},
	['oreilles'] = {
		Func = function() DpClothing:ToggleProps("Ear") end,
		Sprite = "ear",
		Desc = "Enlevez/Remettre vos accessoires d'oreille",
		Button = 10,
		Name = "Accessoires d'oreilles"
	},
	['cou'] = {
		Func = function() DpClothing:ToggleClothing("Neck") end,
		Sprite = "neck",
		Desc = "Enlevez/Remettre votre Collier",
		Button = 11,
		Name = "Collier"
	},
	['montre'] = {
		Func = function() DpClothing:ToggleProps("Watch") end,
		Sprite = "watch",
		Desc = "Enlevez/Remettre votre Montre",
		Button = 12,
		Name = "Montre",
		Rotation = 5.0
	},
	['bracelet'] = {
		Func = function() DpClothing:ToggleProps("Bracelet") end,
		Sprite = "bracelet",
		Desc = "Enlevez/Remettre votre Bracelet",
		Button = 13,
		Name = "Bracelet"
	},
	['masque'] = {
		Func = function() DpClothing:ToggleClothing("Mask") end,
		Sprite = "mask",
		Desc = "Enlevez/Remettre votre Masque",
		Button = 6,
		Name = "Masque"
	}
}

local Bags = {
	[40] = true,
	[41] = true,
	[44] = true,
	[45] = true
}

Config['dpclothing'].ExtraCommands = {
	['pantalons'] = {
		Func = function() DpClothing:ToggleClothing("Pants", true) end,
		Sprite = "pants",
		Desc = "Pantalons",
		Name = "Pantalons",
		OffsetX = -0.04,
		OffsetY = 0.0,
	},
	['chemise'] = {
		Func = function() DpClothing:ToggleClothing("Shirt", true) end,
		Sprite = "shirt",
		Desc = "Tshirt",
		Name = "Tshirt",
		OffsetX = 0.04,
		OffsetY = 0.0,
	},
	['reset'] = {
		Func = function() if not DpClothing:ResetClothing(true) then DpClothing:Notify("Vous portez déjà cela.") end end,
		Sprite = "reset",
		Desc = "Tout revenir à la normale.",
		Name = "Retour",
		OffsetX = 0.12,
		OffsetY = 0.2,
		Rotate = true
	},
	["clothingexit"] = {
		Func = function() DpClothing.MenuOpened = false end,
		Sprite = "exit",
		Desc = "Terminer",
		Name = "Terminer",
		OffsetX = 0.12,
		OffsetY = -0.2,
		Enabled = Config['dpclothing'].GUI.Toggle
	},
	['sacoff'] = {
		Func = function() DpClothing:ToggleClothing("Bagoff", true) end,
		Sprite = "bagoff",
		SpriteFunc = function()
			local Bag = GetPedDrawableVariation(PlayerPedId(), 5)
			local BagOff = DpClothing.LastEquipped["Bagoff"]
			if DpClothing.LastEquipped["Bagoff"] then
				if Bags[BagOff.Drawable] then
					return "bagoff"
				else
					return "paraoff"
				end
			end
			if Bag ~= 0 then
				if Bags[Bag] then
					return "bagoff"
				else
					return "paraoff"
				end
			else
				return false
			end
		end,
		Desc = 'Sac',
		Name = 'Sac',
		OffsetX = -0.12,
		OffsetY = 0.2,
	},
}