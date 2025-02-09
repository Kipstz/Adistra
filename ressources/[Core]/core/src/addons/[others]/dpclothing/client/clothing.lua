

local Drawables = {
	["Top"] = {
		Drawable = 11,
		Table = Variations.Jackets,
		Emote = {Dict = "missmic4", Anim = "michael_tux_fidget", Move = 51, Dur = 1500}
	},
	["Gloves"] = {
		Drawable = 3,
		Table = Variations.Gloves,
		Remember = true,
		Emote = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200}
	},
	["Shoes"] = {
		Drawable = 6,
		Table = {Standalone = true, Male = 166, Female = 35},
		Emote = {Dict = "random@domestic", Anim = "pickup_low", Move = 0, Dur = 1200}
	},
	["Neck"] = {
		Drawable = 7,
		Table = {Standalone = true, Male = 0, Female = 0 },
		Emote = {Dict = "clothingtie", Anim = "try_tie_positive_a", Move = 51, Dur = 2100}
	},
	["Vest"] = {
		Drawable = 9,
		Table = {Standalone = true, Male = 0, Female = 0 },
		Emote = {Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200}
	},
	["Bag"] = {
		Drawable = 5,
		Table = Variations.Bags,
		Emote = {Dict = "anim@heists@ornate_bank@grab_cash", Anim = "intro", Move = 51, Dur = 1600}
	},
	["Mask"] = {
		Drawable = 1,
		Table = {Standalone = true, Male = 0, Female = 0 },
		Emote = {Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 800}
	},
	["Hair"] = {
		Drawable = 2,
		Table = Variations.Hair,
		Remember = true,
		Emote = {Dict = "clothingtie", Anim = "check_out_a", Move = 51, Dur = 2000}
	},
}

local Extras = {
	["Shirt"] = {
		Drawable = 11,
		Table = {
			Standalone = true, Male = 15, Female = 74,
			Extra = { 
						{Drawable = 8, Id = 15, Tex = 0, Name = "Extra Undershirt"},
			 			{Drawable = 3, Id = 15, Tex = 0, Name = "Extra Gloves"},
			 			{Drawable = 10, Id = 0, Tex = 0, Name = "Extra Decals"},
			  		}
			},
		Emote = {Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200}
	},
	["Pants"] = {
		Drawable = 4,
		Table = {Standalone = true, Male = 146, Female = 15},
		Emote = {Dict = "re@construction", Anim = "out_of_breath", Move = 51, Dur = 1300}
	},
	["Bagoff"] = {
		Drawable = 5,
		Table = {Standalone = true, Male = 0, Female = 0},
		Emote = {Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200}
	},
}

local Props = {
	["Visor"] = {
		Prop = 0,
		Variants = Variations.Visor,
		Emote = {
			On = {Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 600},
			Off = {Dict = "missheist_agency2ahelmet", Anim = "take_off_helmet_stand", Move = 51, Dur = 1200}
		}
	},
	["Hat"] = {
		Prop = 0,
		Emote = {
			On = {Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 600},
			Off = {Dict = "missheist_agency2ahelmet", Anim = "take_off_helmet_stand", Move = 51, Dur = 1200}
		}
	},
	["Glasses"] = {
		Prop = 1,
		Emote = {
			On = {Dict = "clothingspecs", Anim = "take_off", Move = 51, Dur = 1400},
			Off = {Dict = "clothingspecs", Anim = "take_off", Move = 51, Dur = 1400}
		}
	},
	["Ear"] = {
		Prop = 2,
		Emote = {
			On = {Dict = "mp_cp_stolen_tut", Anim = "b_think", Move = 51, Dur = 900},
			Off = {Dict = "mp_cp_stolen_tut", Anim = "b_think", Move = 51, Dur = 900}
		}
	},
	["Watch"] = {
		Prop = 6,
		Emote = {
			On = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
			Off = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200}
		}
	},
	["Bracelet"] = {
		Prop = 7,
		Emote = {
			On = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
			Off = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200}
		}
	},
}

DpClothing.LastEquipped = {}
DpClothing.Cooldown = false

function DpClothing:PlayToggleEmote(e, cb)
	local plyPed = PlayerPedId()
	while not HasAnimDictLoaded(e.Dict) do RequestAnimDict(e.Dict) Wait(100) end
	if IsPedInAnyVehicle(plyPed) then e.Move = 51 end

	TaskPlayAnim(plyPed, e.Dict, e.Anim, 3.0, 3.0, e.Dur, e.Move, 0, false, false, false)

	local Pause = e.Dur-500 if Pause < 500 then Pause = 500 end
	DpClothing:IncurCooldown(Pause)
	Wait(Pause)
	cb()
end

function DpClothing:ResetClothing(anim)
	local plyPed = PlayerPedId()
	local e = Drawables.Top.Emote;

	if anim then TaskPlayAnim(plyPed, e.Dict, e.Anim, 3.0, 3.0, 3000, e.Move, 0, false, false, false) end

	for k,v in pairs(DpClothing.LastEquipped) do
		if v then
			if v.Drawable then SetPedComponentVariation(plyPed, v.Id, v.Drawable, v.Texture, 0)
			elseif v.Prop then ClearPedProp(plyPed, v.Id) SetPedPropIndex(plyPed, v.Id, v.Prop, v.Texture, true) end
		end
	end

	DpClothing.LastEquipped = {}
end

function DpClothing:ToggleClothing(which, extra)
	if Cooldown then return end
	local Toggle = Drawables[which] 
	if extra then Toggle = Extras[which] end
	local Ped = PlayerPedId()
	local Cur = {
		Drawable = GetPedDrawableVariation(Ped, Toggle.Drawable), 
		Id = Toggle.Drawable,
		Ped = Ped,
		Texture = GetPedTextureVariation(Ped, Toggle.Drawable),
	}
	local Gender = DpClothing:IsMpPed(Ped)
	if which ~= "Mask" then
		if not Gender then DpClothing:Notify("Ce modèle de caractère ne permet pas cette option") return false end
	end
	local Table = Toggle.Table[Gender]
	if not Toggle.Table.Standalone then
		for k,v in pairs(Table) do
			if not Toggle.Remember then
				if k == Cur.Drawable then
					DpClothing:PlayToggleEmote(Toggle.Emote, function() SetPedComponentVariation(Ped, Toggle.Drawable, v, Cur.Texture, 0) end) return true
				end
			else
				if not DpClothing.LastEquipped[which] then
					if k == Cur.Drawable then
						DpClothing:PlayToggleEmote(Toggle.Emote, function() DpClothing.LastEquipped[which] = Cur SetPedComponentVariation(Ped, Toggle.Drawable, v, Cur.Texture, 0) end) return true
					end
				else
					local Last = DpClothing.LastEquipped[which]
					DpClothing:PlayToggleEmote(Toggle.Emote, function() SetPedComponentVariation(Ped, Toggle.Drawable, Last.Drawable, Last.Texture, 0) DpClothing.LastEquipped[which] = false end) return true
				end
			end
		end
		DpClothing:Notify("Il ne semble pas y avoir de variantes pour cela.") return
	else
		if not DpClothing.LastEquipped[which] then
			if Cur.Drawable ~= Table then 
				DpClothing:PlayToggleEmote(Toggle.Emote, function()
					DpClothing.LastEquipped[which] = Cur
					SetPedComponentVariation(Ped, Toggle.Drawable, Table, 0, 0)
					if Toggle.Table.Extra then
						local Extras = Toggle.Table.Extra
						for k,v in pairs(Extras) do
							local ExtraCur = {Drawable = GetPedDrawableVariation(Ped, v.Drawable),  Texture = GetPedTextureVariation(Ped, v.Drawable), Id = v.Drawable}
							SetPedComponentVariation(Ped, v.Drawable, v.Id, v.Tex, 0)
							DpClothing.LastEquipped[v.Name] = ExtraCur
						end
					end
				end)
				return true
			end
		else
			local Last = DpClothing.LastEquipped[which]
			DpClothing:PlayToggleEmote(Toggle.Emote, function()
				SetPedComponentVariation(Ped, Toggle.Drawable, Last.Drawable, Last.Texture, 0)
				DpClothing.LastEquipped[which] = false
				if Toggle.Table.Extra then
					local Extras = Toggle.Table.Extra
					for k,v in pairs(Extras) do
						if DpClothing.LastEquipped[v.Name] then
							local Last = DpClothing.LastEquipped[v.Name]
							SetPedComponentVariation(Ped, Last.Id, Last.Drawable, Last.Texture, 0)
							DpClothing.LastEquipped[v.Name] = false
						end
					end
				end
			end)
			return true
		end
	end
	DpClothing:Notify("Vous portez déjà cela.") return false
end

function DpClothing:ToggleProps(which)
	if Cooldown then return end
	local Prop = Props[which]
	local Ped = PlayerPedId()
	local Gender = DpClothing:IsMpPed(Ped)
	local Cur = {
		Id = Prop.Prop,
		Ped = Ped,
		Prop = GetPedPropIndex(Ped, Prop.Prop), 
		Texture = GetPedPropTextureIndex(Ped, Prop.Prop),
	}
	if not Prop.Variants then
		if Cur.Prop ~= -1 then
			DpClothing:PlayToggleEmote(Prop.Emote.Off, function() DpClothing.LastEquipped[which] = Cur ClearPedProp(Ped, Prop.Prop) end) return true
		else
			local Last = DpClothing.LastEquipped[which]
			if Last then
				DpClothing:PlayToggleEmote(Prop.Emote.On, function() SetPedPropIndex(Ped, Prop.Prop, Last.Prop, Last.Texture, true) end) DpClothing.LastEquipped[which] = false return true
			end
		end
		DpClothing:Notify("Vous ne semblez pas avoir de choses à enlever.") return false
	else
		local Gender = DpClothing:IsMpPed(Ped)
		if not Gender then DpClothing:Notify("Ce modèle de caractère ne permet pas cette option") return false end
		local Variations = Prop.Variants[Gender]
		for k,v in pairs(Variations) do
			if Cur.Prop == k then
				DpClothing:PlayToggleEmote(Prop.Emote.On, function() SetPedPropIndex(Ped, Prop.Prop, v, Cur.Texture, true) end) return true
			end
		end
		DpClothing:Notify("Il ne semble pas y avoir de variantes pour cela.") return false
	end
end

function DpClothing:DrawDev()
	local Entries = {}
	for k,v in DpClothing:PairsKeys(Drawables) do table.insert(Entries, { Name = k, Drawable = v.Drawable }) end
	for k,v in DpClothing:PairsKeys(Extras) do table.insert(Entries, { Name = k, Drawable = v.Drawable }) end
	for k,v in DpClothing:PairsKeys(Props) do table.insert(Entries, { Name = k, Prop = v.Prop }) end
	for k,v in pairs(Entries) do
		local Ped = PlayerPedId() local Cur
		if v.Drawable then
			Cur = { Id = GetPedDrawableVariation(Ped, v.Drawable),  Texture = GetPedTextureVariation(Ped, v.Drawable) }
		elseif v.Prop then
			Cur = { Id = GetPedPropIndex(Ped, v.Prop),  Texture = GetPedPropTextureIndex(Ped, v.Prop) }
		end
		DpClothing:Text(0.2, 0.8*k/18, 0.30, "~o~"..v.Name.."~w~ = \n     ("..Cur.Id.." , "..Cur.Texture..")", false, 1)
		DrawRect(0.23, 0.8*k/18+0.025, 0.07, 0.045, 0, 0, 0, 150)
	end
end

local TestThreadActive = nil;
function DpClothing:DevTestVariants(d)
	if not TestThreadActive then
		CreateThread(function()
			TestThreadActive = true
			local Ped = PlayerPedId()
			local Drawable = Drawables[d]
			local Prop = Props[d]
			local Gender = DpClothing:IsMpPed(Ped)
			if Drawable then
				if Drawable.Table then
					if type(Drawable.Table[Gender]) == "table" then
						for k,v in DpClothing:PairsKeys(Drawable.Table[Gender]) do
							DpClothing:Notify(d.." : ~o~"..k)
							DpClothing:SoundPlay("Open")
							SetPedComponentVariation(Ped, Drawable.Drawable, k, 0, 0)
							Wait(300)
							DpClothing:Notify(d.." : ~b~"..v)
							DpClothing:SoundPlay("Close")
							SetPedComponentVariation(Ped, Drawable.Drawable, v, 0, 0)
							Wait(300)
						end
					end
				end
			elseif Prop then
				if Prop.Variants then
					for k,v in DpClothing:PairsKeys(Prop.Variants[Gender]) do
						DpClothing:Notify(d.." : ~o~"..k)
						DpClothing:SoundPlay("Open")
						SetPedPropIndex(Ped, Prop.Prop, k, 0, true)
						Wait(300)
						DpClothing:Notify(d.." : ~b~"..v)
						DpClothing:SoundPlay("Close")
						SetPedPropIndex(Ped, Prop.Prop, v, 0, true)
						Wait(300)
						ClearPedProp(Ped, Prop.Prop)
						Wait(200)
					end
				end
			end
			TestThreadActive = false
		end)
	else
		DpClothing:Notify("Already testing variants.")
	end
end

for k,v in pairs(Config['dpclothing'].Commands) do
	RegisterCommand(k, v.Func)
	TriggerEvent("chat:addSuggestion", "/"..k, v.Desc)
end

if Config['dpclothing'].ExtrasEnabled then
	for k,v in pairs(Config['dpclothing'].ExtraCommands) do
		RegisterCommand(k, v.Func)
		TriggerEvent("chat:addSuggestion", "/"..k, v.Desc)
	end
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		DpClothing:ResetClothing()
	end
end)