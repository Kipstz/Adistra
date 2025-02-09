Framework = nil

CreateThread(function()
	while Framework == nil do
		TriggerEvent('framework:init', function(obj) Framework = obj end)
		Wait(100)
	end
end)

TunningSystem = {}

TunningSystem.nomidaberto = nil;
TunningSystem.vehSelected = nil;
TunningSystem.priceCustom = 0;
TunningSystem.TunningDefaults = {}
TunningSystem.menuActual = nil;

TunningSystem.myjob = nil;

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(xPlayer)
	while xPlayer.jobs['job'] == nil do
        Wait(10)
    end

	TunningSystem.myjob = xPlayer.jobs['job']
	
	Wait(100)

	for k,v in pairs(Config['tunningsystem'].localisations) do
		if v.blipmap then
			if v.blipeveryone or (TunningSystem.myjob.name == v.job or v.job == nil) then
				blips[i] = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)

				SetBlipAsShortRange(blips[i], true)
				SetBlipSprite(blips[i], v.blipsprite)
				SetBlipScale(blips[i], 0.9)
				SetBlipColour(blips[i],17)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(v.name)
				EndTextCommandSetBlipName(blips[i])
			end
		end
	end
end)

RegisterNetEvent('TunningSytem:update')
AddEventHandler('TunningSytem:update', function(xPlayer)
	while xPlayer.jobs['job'] == nil do
        Wait(10)
    end

	TunningSystem.myjob = xPlayer.jobs['job']
	
	Wait(100)

	for k,v in pairs(Config['tunningsystem'].localisations) do
		if v.blipmap then
			if v.blipeveryone or (TunningSystem.myjob.name == v.job or v.job == nil) then
				blips[i] = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)

				SetBlipAsShortRange(blips[i], true)
				SetBlipSprite(blips[i], v.blipsprite)
				SetBlipScale(blips[i], 0.9)
				SetBlipColour(blips[i],17)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(v.name)
				EndTextCommandSetBlipName(blips[i])
			end
		end
	end
end)

RegisterNetEvent('framework:setJob')
AddEventHandler('framework:setJob', function(job)
	TunningSystem.myjob = job

	for k,v in pairs(Config['tunningsystem'].localisations) do
		if v.blipmap then
			if v.blipeveryone or (TunningSystem.myjob.name == v.job or v.job == nil) then
				blips[i] = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)

				SetBlipAsShortRange(blips[i], true)
				SetBlipSprite(blips[i], v.blipsprite)
				SetBlipScale(blips[i], 0.9)
				SetBlipColour(blips[i],17)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(v.name)
				EndTextCommandSetBlipName(blips[i])
			else
				local j = blips[i];

				RemoveBlip(j)

				blips[i] = nil;
			end
		end
	end
end)

RegisterNetEvent('TunningSystem:used')
AddEventHandler('TunningSystem:used', function(id,bool)
	Config['tunningsystem'].localisations[id].used = bool
end)

CreateThread(function()
	SetNuiFocus(false,false)

	while TunningSystem.myjob == nil do
		Wait(100)
	end

	while true do 
		wait = 1500

		local plyPed = PlayerPedId()
		local myCoords = GetEntityCoords(plyPed)

		if IsPedInAnyVehicle(plyPed, false) then
			if TunningSystem.nomidaberto == nil then
				for k,v in pairs(Config['tunningsystem'].localisations) do
					if (TunningSystem.myjob.name == v.job or v.job == nil) and not v.used then
						local dist = Vdist(myCoords, v.coords)
						
						if dist <= 5 then
							wait = 1
	
							TunningSystem:DrawText3D(v.coords.x, v.coords.y, v.coords.z, "~r~E~w~ - Customiser le Véhicule")

							if IsControlJustReleased(0, 38) then
								local veh = GetVehiclePedIsIn(plyPed)

								if DoesEntityExist(veh) and dist < 3.5 then
									Framework.TriggerServerCallback("TunningSystem:used", function(cb)
										if cb then
											while not Config['tunningsystem'].localisations[k].used do Wait(10) end

											TunningSystem.vehSelected = veh;
											TunningSystem.priceCustom = 0;
											TunningSystem.nomidaberto = k;

											SetVehicleEngineOn(veh, true, true, false)
											FreezeEntityPosition(veh, true)
											SetVehicleModKit(veh, 0)

											local modsAvaible = TunningSystem:getModsAvailable(veh)

											SetNuiFocus(true, true)
											focuson = true
											gameplaycam = GetRenderingCam()
											cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",true,2)

											SendNUIMessage({
												action = "updateTotal",
												text = "Total: "..TunningSystem.priceCustom.."$",
											})

											SendNUIMessage({
												action = "openMenu",
												menuTable = modsAvaible,
											})

											SendNUIMessage({
												action = "showFreeUpButton",
											})

											CreateThread(function()
												while TunningSystem.nomidaberto do
													Wait(2000)

													local vehCoords = GetEntityCoords(veh)
													local myCoords = GetEntityCoords(PlayerPedId())
													local distVeh = Vdist(vehCoords, v.coords)
													local distMe = Vdist(myCoords, v.coords)

													if not DoesEntityExist(veh) or distVeh > 10.0 or distMe >= 10.0 then
														TunningSystem:cancel(veh)
														break
													end
												end
											end)
										end
									end, k, NetworkGetNetworkIdFromEntity(veh))
								end
							end
						end
					end
				end
			end
		end

		Wait(wait)
	end
end)

RegisterNUICallback("action", function(data)
	SetVehicleDoorsShut(TunningSystem.vehSelected, false)

	if data.action == "openSubMenu" then
		local tab = json.decode(data.type)

		TunningSystem.menuActual = tab.tipo;

		if tab.tipo == "HeadLight" then SetVehicleLights(TunningSystem.vehSelected, 2) end

		camControl(tab.tipo)
		PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	elseif data.action == "subMenuAction" then
		local tab = json.decode(data.type)

		TunningSystem.menuActual = tab.tipo;

		if TunningSystem.menuActual == "rodadefault" then
			TunningSystem:AddMoneyTyres(tab.index.mota, tab.index.roda, tab.index.tipo, GetVehicleMod(TunningSystem.vehSelected, tab.index.mota))
			SetVehicleWheelType(TunningSystem.vehSelected, Config['tunningsystem'].Wheels[tab.index.tipo])
			SetVehicleMod(TunningSystem.vehSelected, tab.index.mota, tab.index.roda, GetVehicleModVariation(TunningSystem.vehSelected, tab.index.mota))
		elseif TunningSystem.menuActual == "defaultneon" then
			TunningSystem:AddMoneyForRGB(tab.index, "NeonsRGBColor")

			local neonsligado = false;

			for i = 0, 3 do
				if IsVehicleNeonLightEnabled(TunningSystem.vehSelected,i) then
					neonsligado = true;
				end
			end

			TunningSystem:AddMoneyNotDefault(tab.ligado, Config['tunningsystem'].TunningPrices["neons"], tab.ligado, neonsligado)

			for i = 0, 3 do
				SetVehicleNeonLightEnabled(TunningSystem.vehSelected, i, tab.ligado)
			end

			SetVehicleNeonLightsColour(TunningSystem.vehSelected, tab.index.r, tab.index.g, tab.index.b)
		elseif TunningSystem.menuActual == "smokedefault" then
			ToggleVehicleMod(TunningSystem.vehSelected, 20, true)

			local aply = tab.index;

			if tab.index.r == 0 and tab.index.g == 0 and tab.index.b == 0 then aply.b = 1 end

			TunningSystem:AddMoneyForRGB(aply, "SmokeRGBColor")
			SetVehicleTyreSmokeColor(TunningSystem.vehSelected, aply.r, aply.g, aply.b)
		elseif TunningSystem.menuActual == "xenonfault" then
			local wut = false;

			if IsToggleModOn(TunningSystem.vehSelected, 22) then wut = true end

			TunningSystem:AddMoneyNotDefault(TunningSystem.TunningDefaults["headlight"].ligado, Config['tunningsystem'].TunningPrices["xenon"], tab.ligado, wut)
			ToggleVehicleMod(TunningSystem.vehSelected, 22, tab.ligado)

			if tab.index ~= 99 and tab.index ~= 98 then
				TunningSystem:AddMoneyNotDefault(TunningSystem.TunningDefaults["headlight"].nmr, Config['tunningsystem'].TunningPrices["xenoncolor"], tab.index, GetVehicleXenonLightsColour(TunningSystem.vehSelected))
				SetVehicleXenonLightsColour(TunningSystem.vehSelected, tab.index)
			end
		elseif TunningSystem.menuActual == "extrafault" then
			local cenas = TunningSystem.TunningDefaults["extra"];

			for id = 0, 20, 1 do
				if DoesExtraExist(TunningSystem.vehSelected, id) then
					if IsVehicleExtraTurnedOn(TunningSystem.vehSelected, id) then
						local jatava = IsVehicleExtraTurnedOn(TunningSystem.vehSelected, id)
						local wht = true;
						local wht2;

						if jatava then
							aplicar = 1;
							wht = nil;
							wht2 = true;
						end

						SetVehicleExtra(TunningSystem.vehSelected, id, 1)

						if jatava ~= IsVehicleExtraTurnedOn(TunningSystem.vehSelected, id) then
							TunningSystem:AddMoneyNotDefault(cenas[id], Config['tunningsystem'].TunningPrices["extra"], wht, wht2)
						end
					end
				end
			end

			for i = 1, #cenas do
				if DoesExtraExist(TunningSystem.vehSelected, i) then
					local aplicar = 1;

					if cenas[i] then aplicar = 0; end

					local jatava = IsVehicleExtraTurnedOn(TunningSystem.vehSelected, i)
					local wht = true;
					local wht2;

					if jatava then
						aplicar = 1;
						wht = nil;
						wht2 = true;
					end

					SetVehicleExtra(TunningSystem.vehSelected, i, aplicar)

					if jatava ~= IsVehicleExtraTurnedOn(TunningSystem.vehSelected, i) then
						TunningSystem:AddMoneyNotDefault(cenas[i], Config['tunningsystem'].TunningPrices["extra"], wht, wht2)
					end
				end
			end
		else
			TunningSystem:AplicarMod(tab.tipo, tab.index-2)
		end

		PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    elseif data.action == "opensubSubMenu" then  -- aqui é quando o gajo clica para que nivel quer tunar
		local tab = json.decode(data.type)

		TunningSystem.menuActual = tab.tipo;

		camControl(tab.tipo)
		PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    elseif data.action == "subSubMenuAction" then  -- aqui é quando o gajo clica para que nivel quer tunar
		local tab = json.decode(data.type)

		if tab.tipo == "cortipop" then
			local def = TunningSystem.TunningDefaults["corprinc"].tipao;
			local price = Config['tunningsystem'].TunningPrices["PrimaryColorType"];

			local ptp, colorp, nnn = GetVehicleModColor_1(TunningSystem.vehSelected)
			local rr, gg, bb = GetVehicleCustomPrimaryColour(TunningSystem.vehSelected)

			TunningSystem:AddMoneyNotDefault(def,price, tab.index, ptp)
			SetVehicleModColor_1(TunningSystem.vehSelected, tab.index, 0, 0)
			SetVehicleCustomPrimaryColour(TunningSystem.vehSelected, rr, gg, bb)
		elseif tab.tipo == "cortipos" then
			local pts, colors = GetVehicleModColor_2(TunningSystem.vehSelected)

			local def = TunningSystem.TunningDefaults["corsec"].tipao;
			local price = Config['tunningsystem'].TunningPrices["SecondaryColorType"];

			local rr, gg, bb = GetVehicleCustomSecondaryColour(TunningSystem.vehSelected)

			TunningSystem:AddMoneyNotDefault(def, price ,tab.index, pts)
			SetVehicleModColor_2(TunningSystem.vehSelected, tab.index, 0, 0)
			SetVehicleCustomSecondaryColour(TunningSystem.vehSelected, rr, gg, bb)
		elseif tab.tipo == "defaultprgb" then
			TunningSystem:AddMoneyForRGB(tab.index, "PrimaryRGBColor")
			SetVehicleCustomPrimaryColour(TunningSystem.vehSelected, tab.index.r, tab.index.g, tab.index.b)

			local def = TunningSystem.TunningDefaults["corprinc"].tipao;
			local price = Config['tunningsystem'].TunningPrices["PrimaryColorType"];

			local ptp, colorp, nnn = GetVehicleModColor_1(TunningSystem.vehSelected)

			TunningSystem:AddMoneyNotDefault(def,price,tab.index.tipao, ptp)
			SetVehicleModColor_1(TunningSystem.vehSelected, tab.index.tipao, tab.index.crl, 0)
		elseif tab.tipo == "defaultsrgb" then
			TunningSystem:AddMoneyForRGB(tab.index, "SecondaryRGBColor")
			SetVehicleCustomSecondaryColour(TunningSystem.vehSelected, tab.index.r, tab.index.g, tab.index.b)

			local def = TunningSystem.TunningDefaults["corsec"].tipao
			local price = Config['tunningsystem'].TunningPrices["SecondaryColorType"]

			local pts, colors, nnn = GetVehicleModColor_2(TunningSystem.vehSelected)

			TunningSystem:AddMoneyNotDefault(def, price, tab.index.tipao, pts)
			SetVehicleModColor_2(TunningSystem.vehSelected, tab.index.tipao, tab.index.crl, 0)
		elseif (tab.tipo == "sport" or tab.tipo == "muscle" or tab.tipo == "lowrider" or tab.tipo == "suv" or tab.tipo == "offroad" or tab.tipo == "tuner" or tab.tipo == "motorcycle" or tab.tipo == "highend" or tab.tipo == "bennys" or tab.tipo == "bespoke" or tab.tipo == "f1" or tab.tipo == "rua" or tab.tipo == "track") then
			TunningSystem:AddMoneyTyres(tab.moto, tab.index, tab.tipo, GetVehicleMod(TunningSystem.vehSelected, tab.moto))
			SetVehicleWheelType(TunningSystem.vehSelected, Config['tunningsystem'].Wheels[tab.tipo])
			SetVehicleMod(TunningSystem.vehSelected, 23, tab.index,GetVehicleModVariation(TunningSystem.vehSelected, tab.moto))
			SetVehicleMod(TunningSystem.vehSelected, 24, tab.index,GetVehicleModVariation(TunningSystem.vehSelected, tab.moto))
		elseif tab.tipo == "costum" then
			local rodai = GetVehicleMod(TunningSystem.vehSelected, 23)
			local costum = not GetVehicleModVariation(TunningSystem.vehSelected, 23)
			local whut = GetVehicleModVariation(TunningSystem.vehSelected, 23)

			TunningSystem:AddMoneyNotDefault(TunningSystem.TunningDefaults["tyreso"].costum, Config['tunningsystem'].TunningPrices["costum-wheel"], costum, whut)
			SetVehicleMod(TunningSystem.vehSelected, 23, rodai, costum)
		elseif tab.tipo == "bproof" then
			local costum = 1;

			if GetVehicleTyresCanBurst(TunningSystem.vehSelected) then
				costum = false;
			end

			TunningSystem:AddMoneyNotDefault(TunningSystem.TunningDefaults["tyreso"].bproof, Config['tunningsystem'].TunningPrices["bulletproof"], costum, GetVehicleTyresCanBurst(TunningSystem.vehSelected))
			SetVehicleTyresCanBurst(TunningSystem.vehSelected, costum)
		elseif tab.tipo == "drift" then
			local costum = GetDriftTyresEnabled(TunningSystem.vehSelected)
			TunningSystem:AddMoneyNotDefault(TunningSystem.TunningDefaults["tyreso"].drift, Config['tunningsystem'].TunningPrices["drift"], not costum, GetDriftTyresEnabled(TunningSystem.vehSelected))
			SetDriftTyresEnabled(TunningSystem.vehSelected, not costum)
		elseif tab.tipo == "xcolor" then
			TunningSystem:AddMoneyNotDefault(TunningSystem.TunningDefaults["headlight"].nmr, Config['tunningsystem'].TunningPrices["xenoncolor"], tab.index, GetVehicleXenonLightsColour(TunningSystem.vehSelected))
			SetVehicleXenonLightsColour(TunningSystem.vehSelected, tab.index)
		elseif TunningSystem.menuActual == "pearlescent" then
			local plrcolour, whcolour = GetVehicleExtraColours(TunningSystem.vehSelected)

			TunningSystem:AddMoneyDefault("pearltab", tab.index, plrcolour)
			SetVehicleExtraColours(TunningSystem.vehSelected, tab.index, whcolour)
		elseif TunningSystem.menuActual == "wheel-colour" then
			local plrcolour, whcolour = GetVehicleExtraColours(TunningSystem.vehSelected)
			TunningSystem:AddMoneyDefault("whlclrtab", tab.index, whcolour)
			SetVehicleExtraColours(TunningSystem.vehSelected, plrcolour, tab.index)
		elseif TunningSystem.menuActual == "dash-colour" then
			local antigito = GetVehicleDashboardColour(TunningSystem.vehSelected)

			TunningSystem:AddMoneyDefault("dshclrtab", tab.index, antigito)
			SetVehicleDashboardColour(TunningSystem.vehSelected, tab.index)
		elseif TunningSystem.menuActual == "int-colour" then
			local antigito = GetVehicleInteriorColour(TunningSystem.vehSelected)

			TunningSystem:AddMoneyDefault("intclrtab", tab.index, antigito)
			SetVehicleInteriorColour(TunningSystem.vehSelected, tab.index)
		end

		PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	elseif data.action == "backToMainMenu" then -- quando clicar no butao para voltar
		PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		camControl("close")

		TunningSystem.menuActual = nil;
    elseif data.action == "changeColor" then
		local cor = data.rgb;

		if TunningSystem.menuActual == "corrgbp" then
			TunningSystem:AddMoneyForRGB(cor, "PrimaryRGBColor")
			SetVehicleCustomPrimaryColour(TunningSystem.vehSelected, cor.r, cor.g, cor.b)
		elseif TunningSystem.menuActual == "corrgbs" then
			TunningSystem:AddMoneyForRGB(cor, "SecondaryRGBColor")
			SetVehicleCustomSecondaryColour(TunningSystem.vehSelected, cor.r, cor.g, cor.b)
		elseif TunningSystem.menuActual == "change-neons" then
			TunningSystem:AddMoneyForRGB(cor, "NeonsRGBColor")
			SetVehicleNeonLightsColour(TunningSystem.vehSelected, cor.r, cor.g, cor.b)
		elseif TunningSystem.menuActual == "smoke" then
			ToggleVehicleMod(TunningSystem.vehSelected, 20, true)

			local aply = cor;

			if cor.r == 0 and cor.g == 0 and cor.b == 0 then
				aply.b = 1
			end

			TunningSystem:AddMoneyForRGB(aply, "SmokeRGBColor")
			SetVehicleTyreSmokeColor(TunningSystem.vehSelected, aply.r, aply.g, aply.b)
		end
	elseif data.action == "cancel" then
		TunningSystem:cancelEverything(data)

		TunningSystem.TunningDefaults = {}

        FreezeEntityPosition(TunningSystem.vehSelected, false)

		SetNuiFocus(false, false)
		focuson = false
		PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		camControl("close")

		TriggerServerEvent("TunningSystem:used", TunningSystem.nomidaberto)
		TunningSystem.nomidaberto = nil;
		TunningSystem.menuActual = nil;
		TunningSystem.vehSelected = nil;
    elseif data.action == "finish" then
		if TunningSystem.priceCustom > 0 then
			Framework.TriggerServerCallback('TunningSystem:canPay', function(hasMoney)
				if hasMoney then
					TriggerServerEvent("TunningSystem:payModifications", TunningSystem.priceCustom, TunningSystem.nomidaberto, Framework.Game.GetVehicleProperties(TunningSystem.vehSelected))

					TunningSystem.TunningDefaults = {}

					FreezeEntityPosition(TunningSystem.vehSelected, false)
					SetNuiFocus(false, false)
					focuson = false;
					PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
					camControl("close")

					TunningSystem.nomidaberto = nil;
					TunningSystem.menuActual = nil;
					TunningSystem.vehSelected = nil;
				else
					TunningSystem:cancelEverything(data)

					TunningSystem.TunningDefaults = {}

					FreezeEntityPosition(TunningSystem.vehSelected,false)
					SetNuiFocus(false, false)
					focuson = false;
					PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
					camControl("close")

					TriggerServerEvent("TunningSystem:used", TunningSystem.nomidaberto)

					TunningSystem.nomidaberto = nil;
					TunningSystem.menuActual = nil;
					TunningSystem.vehSelected = nil;
				end
			end, {price = TunningSystem.priceCustom, nomidaberto = TunningSystem.nomidaberto})
		else
			TunningSystem:cancelEverything(data)

			TunningSystem.TunningDefaults = {}
			
			FreezeEntityPosition(TunningSystem.vehSelected,false)
			SetNuiFocus(false, false)
			focuson = false;
			PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
			camControl("close")

			TriggerServerEvent("TunningSystem:used", TunningSystem.nomidaberto)

			TunningSystem.nomidaberto = nil;
			TunningSystem.menuActual = nil;
			TunningSystem.vehSelected = nil;
		end
	elseif data.action == "kinda" then
		PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	elseif data.action == "camlivre" then
		if focuson then
			camControl("close")
			SetNuiFocus(false, false)
			SendNUIMessage({
				action = "hideFreeUpButton",
			})

			focuson = false;

			while TunningSystem.nomidaberto and not focuson do
				Wait(5)

				-- DisableControlAction(0,85,true)

				if IsControlJustReleased(0,34) and not focuson then
					focuson = true
					SendNUIMessage({
						action = "showFreeUpButton",
					})
					Wait(10)
					SetNuiFocus(true, true)
				end
			end
		end
	elseif data.action == "backTosubMainMenu" then
		PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	end
end)

RegisterNetEvent('TunningSystem:payAfter')
AddEventHandler('TunningSystem:payAfter', function(id, payed)
	if not payed then
		TunningSystem:cancelEverything()
	end

	TriggerServerEvent("TunningSystem:used", id)
	SetNuiFocus(false, false)
end)
