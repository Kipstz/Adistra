

function TunningSystem:getModsAvailable(veh)
	local mods = {}
	TunningSystem.TunningDefaults = {}
	
	rodaatual = GetVehicleMod(veh, 23)
	rodaatual2 = GetVehicleMod(veh,24)
	SetVehicleMod(veh, 23, rodaatual, GetVehicleModVariation(veh, 23))
	SetVehicleMod(veh, 24, rodaatual2, GetVehicleModVariation(veh, 24))

	mods[#mods+1], corprinc, corsec, pearltab, whlclrtab, dshclrtab, intclrtab = GetColors()
	TunningSystem.TunningDefaults["corprinc"] = corprinc
	TunningSystem.TunningDefaults["corsec"] = corsec
	TunningSystem.TunningDefaults["pearltab"] = pearltab
	TunningSystem.TunningDefaults["whlclrtab"] = whlclrtab
	TunningSystem.TunningDefaults["dshclrtab"] = dshclrtab
	TunningSystem.TunningDefaults["intclrtab"] = intclrtab

	mods[#mods+1], neonstable = GetNeons()
	TunningSystem.TunningDefaults["neons"] = neonstable

	mods[#mods+1], smoketable = GetSmoke()
	TunningSystem.TunningDefaults["smoke"] = smoketable

	local windssting = GetVehicleWindowTint(veh)
	mods[#mods+1] = TunningSystem:AddToMenu("windtint", TunningSystem:AddToSubMenu("windtint", 6, false, windssting+1), windssting+1)
	TunningSystem.TunningDefaults["windtint"] = windssting+1

	mods[#mods+1] = TunningSystem:AddToMenu("plate", TunningSystem:AddToSubMenu("plate", 6, false, GetVehicleNumberPlateTextIndex(veh)+1), GetVehicleNumberPlateTextIndex(veh)+1)
	TunningSystem.TunningDefaults["plate"] = GetVehicleNumberPlateTextIndex(veh)+1

	mods[#mods+1] = TurboMenu()
	if IsToggleModOn(veh, 18) then
		TunningSystem.TunningDefaults["turbo"] = true;
	else
		TunningSystem.TunningDefaults["turbo"] = false;
	end

	mods[#mods+1], headlighttable = HeadLight()
	TunningSystem.TunningDefaults["headlight"] = headlighttable

	mods[#mods+1], tyrestable = GetTyres("Tyres Front")
	TunningSystem.TunningDefaults["tyres"] = tyrestable
	if GetVehicleClass(TunningSystem.vehSelected) == 8 then
		SetVehicleWheelType(TunningSystem.vehSelected,6)
		TunningSystem.TunningDefaults["tyresb"] = tyrestable2
	end

	mods[#mods+1], tyresotable = GetTyresOptions()
	TunningSystem.TunningDefaults["tyreso"] = tyresotable

	local extrasss, extratable = GetExtraOptions()
	if next(extrasss.subMenu,1) then
		mods[#mods+1] = extrasss
		TunningSystem.TunningDefaults["extra"] = extratable
	end

	local livery = true;

	for i=0,52 do
		for k,v in pairs(Config['tunningsystem'].TunningMods) do
			if v == i then
				if GetNumVehicleMods(veh, Config['tunningsystem'].TunningMods[k]) >= 1 and k ~= "Tyres Front" and k ~= "Tyres Back" and k ~= "Turbo" then
					local merdaselected = 999;
					local vehmod = GetVehicleMod(veh, Config['tunningsystem'].TunningMods[k])+1

					TunningSystem.TunningDefaults[k] = vehmod-1

					if vehmod >= 0 then merdaselected = vehmod end

					mods[#mods+1] = TunningSystem:AddToMenu(k, TunningSystem:AddToSubMenu(k, GetNumVehicleMods(veh, Config['tunningsystem'].TunningMods[k])+1, false, merdaselected+1), merdaselected+1)

					if k == "Livery" then livery = false; end
				end
			end
		end
	end

	if livery then
		livery = GetVehicleLiveryCount(veh)

		if livery > -1 then
			local merdaselected = 999;
			local vehmod = GetVehicleLivery(veh)

			TunningSystem.TunningDefaults["Livery2"] = vehmod;

			if vehmod >= 0 then merdaselected = vehmod end
			mods[#mods+1] = TunningSystem:AddToMenu("Livery", TunningSystem:AddToSubMenu("Livery2", livery, false, merdaselected+1), merdaselected+1)
		end
	end
	
	return mods;
end

function TunningSystem:cancelModel(veh)
	if DoesEntityExist(veh) then
		while not NetworkHasControlOfEntity(veh) do
			Wait(1)
			NetworkRequestControlOfEntity(veh)
		end

		TunningSystem:cancelEverything()
	end

	TunningSystem.TunningDefaults = {}

	FreezeEntityPosition(TunningSystem.vehSelected, false)

	SetNuiFocus(false, false)
	focuson = false
	camControl("close")

	TriggerServerEvent("TunningSystem:used", TunningSystem.nomidaberto)

	TunningSystem.nomidaberto = nil
	TunningSystem.menuActual = nil
	TunningSystem.vehSelected = nil

	SendNUIMessage({
		action = "close",
	})
end

function TunningSystem:cancelEverything(data)
	for k,v in pairs(TunningSystem.TunningDefaults) do
		local modindex = Config['tunningsystem'].TunningMods[k]
        local tunning = TunningSystem.TunningDefaults[k]

		if modindex then
			SetVehicleMod(TunningSystem.vehSelected, modindex, v, false)
		elseif k=="corprinc" then
			SetVehicleCustomPrimaryColour(TunningSystem.vehSelected, tunning.r, tunning.g, tunning.b)
			SetVehicleModColor_1(TunningSystem.vehSelected, tunning.tipao, tunning.crl, 0)
		elseif k=="corsec" then
			SetVehicleCustomSecondaryColour(TunningSystem.vehSelected, tunning.r, tunning.g, tunning.b)
			SetVehicleModColor_2(TunningSystem.vehSelected, tunning.tipao, tunning.crl, 0)
		elseif k=="pearltab" then
			local plrcolour, whcolour = GetVehicleExtraColours(TunningSystem.vehSelected)
			SetVehicleExtraColours(TunningSystem.vehSelected, tunning, whcolour)
		elseif k=="whlclrtab" then
			local plrcolour, whcolour = GetVehicleExtraColours(TunningSystem.vehSelected)
			SetVehicleExtraColours(TunningSystem.vehSelected, plrcolour, tunning)
		elseif k=="dshclrtab" then
			SetVehicleDashboardColour(TunningSystem.vehSelected, tunning)
		elseif k=="intclrtab" then
			SetVehicleInteriorColour(TunningSystem.vehSelected, tunning)
		elseif k=="neons" then
			for i = 0, 3 do
				SetVehicleNeonLightEnabled(TunningSystem.vehSelected, i, tunning.ligado)
			end
			SetVehicleNeonLightsColour(TunningSystem.vehSelected, tunning.r, tunning.g, tunning.b)
		elseif k=="smoke" then
			ToggleVehicleMod(TunningSystem.vehSelected, 20, true)
			SetVehicleTyreSmokeColor(TunningSystem.vehSelected, tunning.r, tunning.g, tunning.b)
			if tunning.r == 0 and tunning.g == 0 and tunning.b == 0 then
				SetVehicleTyreSmokeColor(TunningSystem.vehSelected, 0, 0, 1)
			end
		elseif k=="windtint" then
			SetVehicleWindowTint(TunningSystem.vehSelected, tunning-1)
		elseif k == "plate" then
			SetVehicleNumberPlateTextIndex(TunningSystem.vehSelected, tunning-1)
		elseif k == "turbo" then
			ToggleVehicleMod(TunningSystem.vehSelected, 18, tunning)
		elseif k == "headlight" then
			ToggleVehicleMod(TunningSystem.vehSelected, 22, tunning.ligado)
			if tunning.nmr ~= 99 then
				SetVehicleXenonLightsColour(TunningSystem.vehSelected, tunning.nmr)
			end
		elseif k == "tyres" then
			SetVehicleWheelType(TunningSystem.vehSelected, Config['tunningsystem'].Wheels[tunning.tipo])
			SetVehicleMod(TunningSystem.vehSelected, 23, tunning.rodadefault,GetVehicleModVariation(TunningSystem.vehSelected, 23))
		elseif k == "tyreso" then
			local rodai = GetVehicleMod(TunningSystem.vehSelected, 23)
			SetVehicleMod(TunningSystem.vehSelected, 23, rodai, tunning.costum)
			SetVehicleTyresCanBurst(TunningSystem.vehSelected, tunning.bproof)
			if GetGameBuildNumber() >= 2372 then SetDriftTyresEnabled(TunningSystem.vehSelected, tunning.drift) end
		elseif k == "tyresb" then
			SetVehicleWheelType(TunningSystem.vehSelected, Config['tunningsystem'].Wheels[tunning.tipo])
			SetVehicleMod(TunningSystem.vehSelected, 24, tunning.rodadefault, GetVehicleModVariation(TunningSystem.vehSelected,24))
		elseif k == "extra" then
			for id = 0, 20, 1 do
				if DoesExtraExist(TunningSystem.vehSelected, id) then 
                    if IsVehicleExtraTurnedOn(TunningSystem.vehSelected, id) then SetVehicleExtra(TunningSystem.vehSelected, id, 1) end
				end
			end
			for i = 1, #tunning do
				if DoesExtraExist(TunningSystem.vehSelected, i) then
					local aplicar = 1;
					if tunning[i] then aplicar = 0 end
					SetVehicleExtra(TunningSystem.vehSelected, i, aplicar)
				end
			end
		elseif k == "Livery2" then
			SetVehicleLivery(TunningSystem.vehSelected, v)
		end
	end
end


function TunningSystem:modelCancel(veh)
	if DoesEntityExist(veh) then
		while not NetworkHasControlOfEntity(veh) do
			Wait(1)
			NetworkRequestControlOfEntity(veh)
		end
		TunningSystem:cancelEverything()
	end
	TunningSystem.TunningDefaults = {}
	TunningSystem.priceCustom = 0;

	FreezeEntityPosition(TunningSystem.vehSelected, false)
	SetNuiFocus(false, false)
	focuson = false
	camControl("close")

	TriggerServerEvent("TunningSystem:used", TunningSystem.nomidaberto)
	TunningSystem.nomidaberto = nil;
	TunningSystem.vehSelected = nil;

	SendNUIMessage({
		action = "close",
	})
end

function TunningSystem:isWheelType(type, numeromod)
	local types = Config['tunningsystem'].Wheels[type]
	local bool = false;
	local wheel = 0;
	local num = 0;
	local wtype = GetVehicleWheelType(TunningSystem.vehSelected)

	if wtype == types then
		bool = true;
		if numeromod == 23 then wheel = rodaatual else wheel = rodaatual2 end
	end

	SetVehicleWheelType(TunningSystem.vehSelected,types)

	num = GetNumVehicleMods(TunningSystem.vehSelected,numeromod)

	SetVehicleWheelType(TunningSystem.vehSelected,wtype)

	return bool, wheel, num
end

function TunningSystem:AplicarMod(mod,index)
	local modindex = Config['tunningsystem'].TunningMods[mod]

	if modindex and mod ~= "Tyres Front" and mod ~= "Tyres Back" and mod ~= "Turbo" and mod ~= "Xenon" then
		local antigo = GetVehicleMod(TunningSystem.vehSelected,Config['tunningsystem'].TunningMods[mod])

		if modindex == 39 or modindex == 40 or modindex == 41 then
			SetVehicleDoorOpen(TunningSystem.vehSelected, 4, false, false)
		elseif modindex == 37 or modindex == 38 or modindex == 31 then
			SetVehicleDoorOpen(TunningSystem.vehSelected, 5, false, false)
			SetVehicleDoorOpen(TunningSystem.vehSelected, 0, false, false)
			SetVehicleDoorOpen(TunningSystem.vehSelected, 1, false, false)
		end

		SetVehicleMod(TunningSystem.vehSelected,modindex,index,false)

		if mod == "Horn" then
			StartVehicleHorn(TunningSystem.vehSelected, 5000, GetHashKey("HELDDDOWN"), false)

			CreateThread(function()
				local tempo = 0;

				while tempo <= 500 do
					tempo = tempo + 1
					SetControlNormal(0, 86, 1.0) 
					Wait(1)
				end
			end)
		end

		TunningSystem:AddMoneyDefault(mod, index, antigo)
	elseif mod == "neonsc" then
		index = index + 2
		local neonsligado = false;

		for i = 0, 3 do
			if IsVehicleNeonLightEnabled(TunningSystem.vehSelected,i) then
				neonsligado = true;
			end
		end

		local wht = false;

		if index >= 1 then
			wht = true;
		end

		TunningSystem:AddMoneyNotDefault(TunningSystem.TunningDefaults["neons"].ligado,Config['tunningsystem'].TunningPrices["neons"],wht,neonsligado)
		
		for i = 0, 3 do
			SetVehicleNeonLightEnabled(TunningSystem.vehSelected,i,index)
		end

		SendNUIMessage({
			action = "updateTotal",
			text = "Total: "..TunningSystem.priceCustom.."$",
		})

		if TunningSystem.priceCustom < 0 then
			TunningSystem:modelCancel(veh)
		end

		index = index-2
	elseif mod == "turbo" then
		local costum = true;
		local isTurbo = false;

		if IsToggleModOn(TunningSystem.vehSelected, 18) then 
			costum = false;
			isTurbo = true;
		end

		TunningSystem:AddMoneyNotDefault(TunningSystem.TunningDefaults["turbo"], Config['tunningsystem'].TunningPrices["turbo"], costum, isTurbo)
		ToggleVehicleMod(TunningSystem.vehSelected, 18, costum)
	elseif mod == "xenon" then
		local costum = true;
		local wut = false;

		if IsToggleModOn(TunningSystem.vehSelected,22) then
			wut = true;
			costum = false;
		end

		TunningSystem:AddMoneyNotDefault(TunningSystem.TunningDefaults["headlight"].ligado,Config['tunningsystem'].TunningPrices["xenon"],costum,wut)
		ToggleVehicleMod(TunningSystem.vehSelected,22,costum)
	elseif mod == "windtint" then
		local antigo = GetVehicleWindowTint(TunningSystem.vehSelected)
		TunningSystem:AddMoneyNotDefault(TunningSystem.TunningDefaults[mod]-2,Config['tunningsystem'].TunningPrices[mod],index,antigo-1)
		SetVehicleWindowTint(TunningSystem.vehSelected,index+1)
	elseif mod == "plate" then
		local antigo = GetVehicleNumberPlateTextIndex(TunningSystem.vehSelected)
		TunningSystem:AddMoneyNotDefault(TunningSystem.TunningDefaults[mod]-2,Config['tunningsystem'].TunningPrices[mod],index,antigo-1)
		SetVehicleNumberPlateTextIndex(TunningSystem.vehSelected, index+1)
	elseif mod == "extra" then
		index=index+2
		local jatava = IsVehicleExtraTurnedOn(TunningSystem.vehSelected, index)
		local aplicar = 0
		local wht = true
		local wht2
		if jatava then
			aplicar = 1
			wht = nil
			wht2 = true
		end
		SetVehicleExtra(TunningSystem.vehSelected,index,aplicar)
		if jatava ~= IsVehicleExtraTurnedOn(TunningSystem.vehSelected, index) then
			TunningSystem:AddMoneyNotDefault(TunningSystem.TunningDefaults["extra"][index],Config['tunningsystem'].TunningPrices["extra"],wht,wht2)
		end
	elseif mod == "Livery2" then
		local antigo = GetVehicleLivery(TunningSystem.vehSelected)
		SetVehicleLivery(TunningSystem.vehSelected,index+1)
		TunningSystem:AddMoneyDefault("Livery2",index+1,antigo)
	end
end

function TunningSystem:AddMoneyDefault(mod,index,antigo)
	if index == TunningSystem.TunningDefaults[mod] and index ~= antigo then
		TunningSystem.priceCustom = TunningSystem.priceCustom - (Config['tunningsystem'].TunningPrices[mod].base + (antigo+1) * Config['tunningsystem'].TunningPrices[mod].bylevel) * 1
	elseif antigo ~= index then
		if antigo ~= TunningSystem.TunningDefaults[mod] then
			TunningSystem.priceCustom = TunningSystem.priceCustom - (Config['tunningsystem'].TunningPrices[mod].base + (antigo+1) * Config['tunningsystem'].TunningPrices[mod].bylevel) * 1
			TunningSystem.priceCustom = TunningSystem.priceCustom + (Config['tunningsystem'].TunningPrices[mod].base + (index+1) * Config['tunningsystem'].TunningPrices[mod].bylevel) * 1
		else
			TunningSystem.priceCustom = TunningSystem.priceCustom + (Config['tunningsystem'].TunningPrices[mod].base + (index+1) * Config['tunningsystem'].TunningPrices[mod].bylevel) * 1
		end
	end
	SendNUIMessage({
		action = "updateTotal",
		text = "Total: "..TunningSystem.priceCustom.."$",
	})
	if TunningSystem.priceCustom < 0 then
		TunningSystem:modelCancel(veh)
	end
end

function TunningSystem:AddMoneyNotDefault(default,price,index,antigo,teste,teste2)
	local somar1 = 0
	local somar2 = 0
	if type(antigo) == "number" then
		somar1 = (antigo+1)
	end
	if type(index) == "number" then
		somar2 = (index+1)
	end
	if teste2 then
		somar1 = (teste2+1)
	end
	if teste then
		somar2 = (teste+1)
	end
	if index == default and index ~= antigo then
		TunningSystem.priceCustom = TunningSystem.priceCustom - (price.base + (somar1) * price.bylevel) * 1
	elseif antigo ~= index then
		if antigo ~= default then
			TunningSystem.priceCustom = TunningSystem.priceCustom - (price.base + (somar1) * price.bylevel) * 1
			TunningSystem.priceCustom = TunningSystem.priceCustom + (price.base + (somar2) * price.bylevel) * 1
		else
			TunningSystem.priceCustom = TunningSystem.priceCustom + (price.base + (somar2) * price.bylevel) * 1
		end
	end
	SendNUIMessage({
		action = "updateTotal",
		text = "Total: "..TunningSystem.priceCustom.."$",
	})
	if TunningSystem.priceCustom < 0 then
		TunningSystem:modelCancel(veh)
	end
end

function TunningSystem:AddMoneyForRGB(cor,tipo)
	local rantigo,gantigo,bantigo
	local cenas
	if tipo == "PrimaryRGBColor" then
		cenas = TunningSystem.TunningDefaults["corprinc"]
		rantigo,gantigo,bantigo = GetVehicleCustomPrimaryColour(TunningSystem.vehSelected)
	elseif tipo == "SecondaryRGBColor" then
		cenas = TunningSystem.TunningDefaults["corsec"]
		rantigo,gantigo,bantigo = GetVehicleCustomSecondaryColour(TunningSystem.vehSelected)
	elseif tipo == "NeonsRGBColor" then
		cenas = TunningSystem.TunningDefaults["neons"]
		rantigo,gantigo,bantigo = GetVehicleNeonLightsColour(TunningSystem.vehSelected)
	elseif tipo == "SmokeRGBColor" then
		cenas = TunningSystem.TunningDefaults["smoke"]
		rantigo,gantigo,bantigo = GetVehicleTyreSmokeColor(TunningSystem.vehSelected)
	end
	local if1 = (cenas.r == cor.r and cenas.g == cor.g and cenas.b == cor.b)
	local if2 = (rantigo ~= cor.r or gantigo ~= cor.g or bantigo ~= cor.b)
	local if3 = (rantigo ~= cenas.r or gantigo ~= cenas.g or bantigo ~= cenas.b)
	if if1 and if2 then
		TunningSystem.priceCustom = TunningSystem.priceCustom - (Config['tunningsystem'].TunningPrices[tipo].base) * 1
	elseif if2 then
		if if3 then
			TunningSystem.priceCustom = TunningSystem.priceCustom - (Config['tunningsystem'].TunningPrices[tipo].base) * 1
			TunningSystem.priceCustom = TunningSystem.priceCustom + (Config['tunningsystem'].TunningPrices[tipo].base) * 1
		else
			TunningSystem.priceCustom = TunningSystem.priceCustom + (Config['tunningsystem'].TunningPrices[tipo].base) * 1
		end
	end

	SendNUIMessage({
		action = "updateTotal",
		text = "Total: "..TunningSystem.priceCustom.."$",
	})
	if TunningSystem.priceCustom < 0 then
		TunningSystem:modelCancel(veh)
	end
end

function TunningSystem:AddMoneyTyres(mota,roda,tipo,antigonum)
	local default = TunningSystem.TunningDefaults["tyres"]
	if mota == 24 then
		default = TunningSystem.TunningDefaults["tyresb"]
	end
	local antigo
	for k in pairs(Config['tunningsystem'].Wheels) do
		local bool,wheel,num = TunningSystem:isWheelType(k,mota)
		if bool then
			antigo = {tipo=k,rodadefault=antigonum+1}
		end
	end
	local def = (default.tipo.." "..default.rodadefault+1)
	local index = tipo.." "..roda+1
	local ant = antigo.tipo.." "..antigo.rodadefault
	if index == def and index ~= ant then
		local price = Config['tunningsystem'].TunningPrices[antigo.tipo]
		TunningSystem.priceCustom = ((TunningSystem.priceCustom - (price.base + (antigo.rodadefault-1) *price.bylevel)) * 1)
	elseif index ~= ant then
		if ant ~= def then
			local price = Config['tunningsystem'].TunningPrices[antigo.tipo]
			TunningSystem.priceCustom = ((TunningSystem.priceCustom-(price.base+(antigo.rodadefault-1)*price.bylevel)) * 1)
			price = Config['tunningsystem'].TunningPrices[tipo]
			TunningSystem.priceCustom = ((TunningSystem.priceCustom+(price.base+(roda)*price.bylevel)) * 1)
		else
			local price = Config['tunningsystem'].TunningPrices[tipo]
			TunningSystem.priceCustom = ((TunningSystem.priceCustom+(price.base+(roda)*price.bylevel)) * 1)
		end
	end

	SendNUIMessage({
		action = "updateTotal",
		text = "Total: "..TunningSystem.priceCustom.."$"
	})

	if TunningSystem.priceCustom < 0 then
		TunningSystem:modelCancel(veh)
	end
end


function TunningSystem:DrawText3D(x, y, z, text,r,g,b,a)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
	if r and g and b and a then
		SetTextColour(r, g, b, a)
	else
		SetTextColour(255, 255, 255, 215)
	end
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function TunningSystem:getNameCLR(id)
	local name = '';
	for k,v in pairs(Config['tunningsystem'].ColoursExtra) do
		local extra = Config['tunningsystem'].ColoursExtra[k]
		if extra.id == id then
			name = extra.name;
		end
	end
	return name;
end