

function DpClothing:log(l)
	if l == nil then print("nil") return end
	if not Config['dpclothing'].Debug then return end
	if type(l) == "table" then print(json.encode(l)) elseif type(l) == "boolean" then print(l) else print(l.." | "..type(l)) end
end

function DpClothing:GetKey(str)
	local Key = Keys[string.upper(str)]
	if Key then return Key else return false end
end

function DpClothing:IncurCooldown(ms)
	CreateThread(function()
		Cooldown = true Wait(ms) Cooldown = false
	end)
end

function DpClothing:PairsKeys(t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0
	local iter = function ()
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]] end
	end
	return iter
end

function DpClothing:Text(x, y, scale, text, colour, align, force, w)
	local align = align or 0
	local colour = colour or Config['dpclothing'].GUI.TextColor
	SetTextFont(Config['dpclothing'].GUI.TextFont)
	SetTextJustification(align)
	SetTextScale(scale, scale)
	SetTextColour(colour[1], colour[2], colour[3], 255)
	if Config['dpclothing'].GUI.TextOutline then SetTextOutline() end	
	if w then SetTextWrap(w.x, w.y) end
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function DpClothing:FirstUpper(str)
	return (str:gsub("^%l", string.upper))
end

function DpClothing:Lang(what)
	local Dict = Locale[Config['dpclothing'].Language]
	if not Dict[what] then return Locale["en"][what] end
	return Dict[what]
end

function DpClothing:Notify(message) 
	SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0,1)
end

function DpClothing:IsMpPed(ped)
	local Male = GetHashKey("mp_m_freemode_01") local Female = GetHashKey("mp_f_freemode_01")
	local CurrentModel = GetEntityModel(ped)
	if CurrentModel == Male then return "Male" elseif CurrentModel == Female then return "Female" else return false end
end

RegisterNetEvent('dpc:EquipLast')
AddEventHandler('dpc:EquipLast', function()
	local plyPed = PlayerPedId()
	for k,v in pairs(DpClothing.LastEquipped) do
		if v then
			if v.Drawable then SetPedComponentVariation(plyPed, v.ID, v.Drawable, v.Texture, 0)
			elseif v.Prop then ClearPedProp(plyPed, v.ID) SetPedPropIndex(plyPed, v.ID, v.Prop, v.Texture, true) end
		end
	end
	DpClothing.LastEquipped = {}
end)

RegisterNetEvent('dpc:ResetClothing')
AddEventHandler('dpc:ResetClothing', function()
	DpClothing.LastEquipped = {}
end)

RegisterNetEvent('dpc:ToggleMenu')
AddEventHandler('dpc:ToggleMenu', function()
	DpClothing.MenuOpened = not DpClothing.MenuOpened;
	if DpClothing.MenuOpened then DpClothing:SoundPlay("Open") SetCursorLocation(Config['dpclothing'].GUI.Position.x, Config['dpclothing'].GUI.Position.y) else DpClothing:SoundPlay("Close") end
end)

RegisterNetEvent('dpc:Menu')
AddEventHandler('dpc:Menu', function(status)
	DpClothing.MenuOpened = status;
	if DpClothing.MenuOpened then DpClothing:SoundPlay("Open") else DpClothing:SoundPlay("Close") end
end)

