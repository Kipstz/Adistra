
function OutlawAlert:notify(alertType, sex, street1, street2)
    for k,v in pairs(Config['outlawalert'].jobs) do
		if Framework.PlayerData.jobs ~= nil and Framework.PlayerData.jobs['job'].name == v then
			if alertType == 'gunshot' then
                alert = ("~r~Coup de feu~s~")
				if street2 ~= nil then
					alert = ("~r~Coup de feu entre ~s~"..street1.."~r~ et ~s~"..street2.."~s~")
                elseif street1 ~= nil then
					alert = ("~r~Coup de feu à ~w~"..street1.."~s~")
				end
			end
			Framework.ShowNotification(alert)
		end
	end
end

function OutlawAlert:setPlace(coords)
	for k,v in pairs(Config['outlawalert'].jobs) do
		if Framework.PlayerData.jobs ~= nil and Framework.PlayerData.jobs['job'].name == v then
			local alpha = 250;
			local blip = AddBlipForCoord(coords)

			SetBlipSprite(blip,  1)
			SetBlipColour(blip,  1)
			SetBlipAlpha(blip,  alpha)
			SetBlipAsShortRange(blip,  1)

			while alpha ~= 0 do
				Wait(Config['outlawalert'].blipTime * 4)
				alpha = alpha - 1
				SetBlipAlpha(blip,  alpha)
				if alpha == 0 then
					SetBlipSprite(blip,  2)
					return
				end
			end
		end
	end
end