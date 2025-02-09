
local Sounds = {
	["Close"] = {"TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	["Open"] = {"NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	["Select"] = {"SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET"}
}

function DpClothing:SoundPlay(which)
	if not Config['dpclothing'].GUI.Sound then return end
	local Sound = Sounds[which]
	PlaySoundFrontend(-1, Sound[1], Sound[2])
end

function DpClothing:Distance(x1, y1, x2, y2)
	local dx = x1 - x2
	local dy = y1 - y2
	return math.sqrt(dx * dx + dy * dy)
end

function DpClothing:DisableControl()
	DisableControlAction(1, 1, true)
	DisableControlAction(1, 2, true)
	DisableControlAction(1, 18, true)
	DisableControlAction(1, 68, true)
	DisableControlAction(1, 69, true)
	DisableControlAction(1, 70, true)
	DisableControlAction(1, 91, true)
	DisableControlAction(1, 92, true)
	DisableControlAction(1, 24, true)
	DisableControlAction(1, 25, true)
	DisableControlAction(1, 14, true)
	DisableControlAction(1, 15, true)
	DisableControlAction(1, 16, true)
	DisableControlAction(1, 17, true)
	DisablePlayerFiring(PlayerId(), true)
	ShowCursorThisFrame()
end

function DpClothing:GetCursor()
	local sx, sy = GetActiveScreenResolution()
	local cx, cy = GetNuiCursorPosition()
	local cx, cy = (cx / sx) + 0.008, (cy / sy) + 0.027
	return cx, cy;
end

function DpClothing:DrawButton(b)
	local B = Config['dpclothing'].GUI.ButtonColor;
	local Rot = b.Rotate or 0.0;
	if b.Shadow then
		DrawSprite("dp_clothing", "circle", b.x, b.y, b.Size.Circle.x/0.80, b.Size.Circle.y/0.80, Rot, b.Colour.r, b.Colour.g, b.Colour.b, b.Alpha)
	end

	DrawSprite("dp_clothing", b.Sprite, b.x, b.y, b.Size.Sprite.x/0.68, b.Size.Sprite.y/0.68, b.Rotation, 255, 255, 255, b.Alpha)

	if IsDisabledControlJustPressed(1, 24) then
		local x,y = DpClothing:GetCursor()
		local dist = DpClothing:Distance(b.x+0.005, b.y+0.025, x, y)
		if dist < 0.025 then return true end
	elseif IsDisabledControlJustPressed(1, 25) and Config['dpclothing'].Debug then
		local x,y = DpClothing:GetCursor()
		local dist = DpClothing:Distance(b.x+0.005, b.y+0.025, x, y)
		if dist < 0.025 then
			DpClothing:DevTestVariants(DpClothing:FirstUpper(b.Sprite))
		end
	end
	return false;
end

function DpClothing:Check(ped)
	if IsPedInAnyVehicle(ped) then
		return false;
	elseif IsPedSwimmingUnderWater(ped) then
		return false;
	elseif IsPedRagdoll(ped) then
		return false;
	elseif IsHudComponentActive(19) then
		return false;
	end
	return true;
end

local DefaultButton = {x = 0.0254, y = 0.0445}
local DefaultCircle = {x = 0.0345 / 1.2, y = 0.06 / 1.2}
local Buttons = {}
local ExtraButtons = {}
local InfoButtonRot = 0.0;

function DpClothing:GenerateTheButtons()
	local x, y, rx, ry = Config['dpclothing'].GUI.Position.x, Config['dpclothing'].GUI.Position.y, 0.1, 0.175

	for k,v in pairs(Config['dpclothing'].Commands) do
		local i = v.Button;
		local Angle = i * math.pi / 7 local Ptx, Pty = x + rx * math.cos(Angle), y + ry * math.sin(Angle)
		Buttons[i] = {
			Command = k,
			Desc = v.Desc or "",
			Rotation = v.Rotation or 0.0,
			Size = {Sprite = DefaultButton},
			Sprite = v.Sprite,
			Text = v.Name,
			x = Ptx, y = Pty,
			Rotation = 0.0
		}
	end
	if Config['dpclothing'].ExtrasEnabled then
		for k,v in pairs(Config['dpclothing'].ExtraCommands) do
			local Enabled = v.Enabled if Enabled == nil then Enabled = true end

			ExtraButtons[k] = {
				Command = k,
				Desc = v.Desc or "",
				OffsetX = v.OffsetX, OffsetY = v.OffsetY,
				Size = { Circle = {x = DefaultCircle.x, y = DefaultCircle.y}, Sprite = {x = DefaultButton.x/1.35, y = DefaultButton.y/1.35}},
				Sprite = v.Sprite,
				SpriteFunc = v.SpriteFunc,
				Text = v.Name,
				Enabled = Enabled,
				Rotate = v.Rotate,
				Rotation = 0.0
			}
		end
	end
end

function DpClothing:PushedButton(button, extra, rotate, info)
	CreateThread(function()	
		DpClothing:SoundPlay("Select")

		local Button = nil;

		if extra then Button = ExtraButtons[button] elseif info then Button = InfoButton else Button = Buttons[button] end

		if rotate then
			for i = 1, 18 do
				if not info then 
					Button.Rotation = -i*20+0.0 
					Wait(1) 
				else 
					InfoButtonRot = -i*20+0.0 
					Wait(1) 
				end
			end 
			return
		end

		if not extra then
			Button.Size = {Sprite = {x = DefaultButton.x/1.1, y = DefaultButton.y/1.1}}
			Wait(100)
			Button.Size = {Sprite = {x = DefaultButton.x, y = DefaultButton.y}}
		else
			Button.Size = { Circle = {x = DefaultCircle.x, y = DefaultCircle.y}, Sprite = {x = DefaultButton.x/1.3/1.1, y = DefaultButton.y/1.3/1.1}}
			Wait(100)
			Button.Size = { Circle = {x = DefaultCircle.x, y = DefaultCircle.y}, Sprite = {x = DefaultButton.x/1.35, y = DefaultButton.y/1.35}}
		end
	end)
end

function DpClothing:HoveredButton()
	local x,y = DpClothing:GetCursor()

	for k,v in pairs(Buttons) do
		local dist = DpClothing:Distance(v.x+0.005, v.y+0.025, x, y)
		if dist < 0.025 then
			DpClothing:Text(Config['dpclothing'].GUI.Position.x, Config['dpclothing'].GUI.Position.y-0.10, 0.3, v.Text, false, false, true)
			DpClothing:Text(Config['dpclothing'].GUI.Position.x, Config['dpclothing'].GUI.Position.y-0.08, 0.22, v.Desc, {210,210,210}, false, true, {x = 0.1, y = 0.2})
		end
	end

	for k,v in pairs(ExtraButtons) do
		if v.Enabled then
			local dist = DpClothing:Distance(Config['dpclothing'].GUI.Position.x+v.OffsetX+0.005, Config['dpclothing'].GUI.Position.y+v.OffsetY+0.025, x, y)
			local ShouldDisplay = true;

			if v.SpriteFunc then
				local SpriteVar = v.SpriteFunc()

				if SpriteVar then
					ShouldDisplay = true;
				else
					ShouldDisplay = false;
				end
			end

			if ShouldDisplay then
				if dist < 0.025 then
					DpClothing:Text(Config['dpclothing'].GUI.Position.x, Config['dpclothing'].GUI.Position.y-0.10, 0.3, v.Text, false, false, true)
					DpClothing:Text(Config['dpclothing'].GUI.Position.x, Config['dpclothing'].GUI.Position.y-0.08, 0.22, v.Desc, {210,210,210}, false, true, {x = 0.1, y = 0.2})
				end
			end
		end
	end

	local dist = DpClothing:Distance(Config['dpclothing'].GUI.Position.x+0.005, Config['dpclothing'].GUI.Position.y+0.025, x, y)
	if dist < 0.015 then
		DpClothing:Text(Config['dpclothing'].GUI.Position.x, Config['dpclothing'].GUI.Position.y-0.09, 0.3, "Si le bouton est foncé, vous avez un objet enregistré.", false, false, true)
	end
end

function DpClothing:DrawGUI()
	DpClothing:DisableControl()
	DpClothing:HoveredButton()

	local x, y, rx, ry = Config['dpclothing'].GUI.Position.x, Config['dpclothing'].GUI.Position.y, 0.1, 0.175
	
	for k,v in pairs(Buttons) do
		local Colour 
		local Alpha

		if DpClothing.LastEquipped[DpClothing:FirstUpper(v.Sprite)] then
			Alpha = 180 Colour = {r=40,g=0,b=255,a=255}
		else 
			Alpha = 255 Colour = {r=80,g=0,b=255,a=255}
		end

		DrawSprite("dp_wheel", k.."", x, y, 0.4285, 0.7714, 0.0, Colour.r, Colour.g, Colour.b, Colour.a)

		local Button = DpClothing:DrawButton({
			Alpha = Alpha,
			Colour = Colour,
			Rotation = v.Rotation,
			Size = v.Size,
			Sprite = v.Sprite,
			Text = v.Text,
			x = v.x, y = v.y,
			Rotation = v.Rotation,
		})

		if Button and not Cooldown then
			if v.Sprite == "gloves" then
				if not DpClothing.LastEquipped["Shirt"] then
					DpClothing:PushedButton(k)
					ExecuteCommand(v.Command)  
				else
					DpClothing:Notify("Vous ne pouvez pas le faire sans votre chemise.")
				end
			else
				DpClothing:PushedButton(k)  
				ExecuteCommand(v.Command)  
			end
			
		end
	end

	for k,v in pairs(ExtraButtons) do
		if v.Enabled then
			local Colour 
			local Alpha

			if DpClothing.LastEquipped[DpClothing:FirstUpper(v.Sprite)] then
				Alpha = 180 Colour = {r=0,g=100,b=210,a=220}
			else 
				Alpha = 255 Colour = {r=0,g=0,b=0,a=255}
			end

			local sprite = v.Sprite

			if v.SpriteFunc then
				local SpriteVar = v.SpriteFunc()
				if SpriteVar then
					sprite = SpriteVar;
				else
					sprite = false;
				end
			end

			if sprite then
				local Button = DpClothing:DrawButton({
					Alpha = Alpha,
					Colour = Colour,
					Shadow = true,
					Size = v.Size,
					Sprite = sprite,
					Text = v.Text,
					x = x + v.OffsetX,
					y = y + v.OffsetY,
					Rotation = v.Rotation,
				})

				if Button and not Cooldown then
					DpClothing:PushedButton(k, true, v.Rotate) 
					ExecuteCommand(v.Command)  
				end
			end
		end
	end

	if Cooldown then DpClothing:Text(x, y+0.05, 0.28, "Patientez s'il vous plaît...", false, false, true) end
	local InfoButton = DpClothing:DrawButton({
		Alpha = 255,
		Colour = {r=0,g=0,b=0},
		Shadow = true,
		Size = {Circle = {x = 0.0345, y = 0.06}, Sprite = {x = 0.0234, y = 0.0425}},
		Sprite = "info",
		Text = "Info",
		x = x, y = y,
		Rotation = InfoButtonRot,
	})
	
	if InfoButton then 			
		DpClothing:PushedButton(k, true, true, true)
		DpClothing:Notify("Si le bouton est foncé, vous avez un objet enregistré.")
		for k,v in pairs(DpClothing.LastEquipped) do log(k.." : "..json.encode(v)) end
	end
end

DpClothing.MenuOpened = false;
local TextureDicts = {"dp_clothing", "dp_wheel"}

RegisterCommand('dpclothing:open', function()
	local plyPed = PlayerPedId() 
	if not DpClothing.MenuOpened then
		if DpClothing:Check(plyPed) then 
			DpClothing:SoundPlay("Open") 
			SetCursorLocation(Config['dpclothing'].GUI.Position.x, Config['dpclothing'].GUI.Position.y) 
			DpClothing.MenuOpened = true;
		end
	else
		if DpClothing:Check(plyPed) then 
			DpClothing:SoundPlay("Close") 
			DpClothing.MenuOpened = false;
		end
	end
end)

RegisterKeyMapping('dpclothing:open', "Ouvrir la roulette de vêtements", 'keyboard', 'Y')

CreateThread(function()
	for k,v in pairs(TextureDicts) do while not HasStreamedTextureDictLoaded(v) do Wait(100) RequestStreamedTextureDict(v, true) end end
	DpClothing:GenerateTheButtons()

	while true do
		wait = 1000;
		
		if DpClothing.MenuOpened then
			wait = 1; 
			DpClothing:DrawGUI() 
		end

		Wait(wait)
	end
end)