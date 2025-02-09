
PersonalMenu = {}

RegisterCommand('OpenPersonal', function()
    if Framework ~= nil then
		if not IsPlayerDead(PlayerId()) then
			PersonalMenu.OpenMenu()
		else
			Framework.ShowNotification("~r~Vous ne pouvez pas ouvrir le menu personnel en étant mort !~s~")
		end
    end
end)

RegisterKeyMapping('OpenPersonal', "Ouvrir votre Menu Personnel", 'keyboard', "F5")

function startAnimAction(lib, anim)
	Framework.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
	end)
end

function SetVet(value, Ped)
    Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:getSkin', function(skina)
			if value == "haut" then
				startAnimAction("clothingtie", "try_tie_neutral_a")
				Citizen.Wait(1000)
				ClearPedTasks(Ped)

				if skin.torso_1 ~= skina.torso_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2, ['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2, ['arms'] = skin.arms})
				else
                    if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
					else
						TriggerEvent('skinchanger:loadClothes', skina,{['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
					end
				end
			elseif value == "bas" then
				if skin.pants_1 ~= skina.pants_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = skin.pants_1, ['pants_2'] = skin.pants_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 173, ['pants_2'] = 0})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 15, ['pants_2'] = 0})
					end
				end
			elseif value == "chaussures" then
				if skin.shoes_1 ~= skina.shoes_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 138, ['shoes_2'] = 0})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 35, ['shoes_2'] = 0})
					end
				end
			elseif value == "sac" then
				if skin.bags_1 ~= skina.bags_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = skin.bags_1, ['bags_2'] = skin.bags_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = 0, ['bags_2'] = 0})
				end
			elseif value == "gpb" then
				startAnimAction("clothingtie", "try_tie_neutral_a")
				Citizen.Wait(1000)
				ClearPedTasks(Ped)

				if skin.bproof_1 ~= skina.bproof_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = skin.bproof_1, ['bproof_2'] = skin.bproof_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = 0, ['bproof_2'] = 0})
				end
            elseif value == "tout" then

                if skin.torso_1 ~= skina.torso_1 and skin.pants_1 ~= skina.pants_1 and skin.shoes_1 ~= skina.shoes_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2, ['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2, ['arms'] = skin.arms, ['pants_1'] = skin.pants_1, ['pants_2'] = skin.pants_2, ['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2, ['bags_1'] = skin.bags_1, ['bags_2'] = skin.bags_2, ['bproof_1'] = skin.bproof_1, ['bproof_2'] = skin.bproof_2})
				else
                    if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15, ['pants_1'] = 173, ['pants_2'] = 0, ['shoes_1'] = 138, ['shoes_2'] = 0, ['bags_1'] = 0, ['bags_2'] = 0, ['bproof_1'] = 0, ['bproof_2'] = 0})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15, ['pants_1'] = 15, ['pants_2'] = 0, ['shoes_1'] = 35, ['shoes_2'] = 0, ['bags_1'] = 0, ['bags_2'] = 0, ['bproof_1'] = 0, ['bproof_2'] = 0})
					end
				end
			end
		end)
	end)
end

function SetAcc(value, Ped)
    Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:getSkin', function(skina)
			if value == "masque" then
				if skin.mask_1 ~= skina.mask_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['mask_1'] = skin.mask_1, ['mask_2'] = skin.mask_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['mask_1'] = 0, ['mask_2'] = 0})
				end
			elseif value == "chapeau" then
				if skin.helmet_1 ~= skina.helmet_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['helmet_1'] = skin.helmet_1, ['helmet_2'] = skin.helmet_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['helmet_1'] = 18, ['helmet_2'] = 0})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['helmet_1'] = 0, ['helmet_2'] = 0})
					end
				end
			elseif value == "lunettes" then
				if skin.glasses_1 ~= skina.glasses_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['glasses_1'] = skin.glasses_1, ['glasses_2'] = skin.glasses_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['glasses_1'] = 0, ['glasses_2'] = 0})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['glasses_1'] = 5, ['glasses_2'] = 0})
					end
				end
			end
		end)
	end)
end
