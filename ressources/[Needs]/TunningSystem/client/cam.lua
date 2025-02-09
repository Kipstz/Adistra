

function f(n)
	return (n + 0.00001)
end

function ResetCam()
	SetCamCoord(cam,GetGameplayCamCoords())
	SetCamRot(cam, GetGameplayCamRot(2), 2)

	RenderScriptCams( 0, 1, 1000, 0, 0)
	SetCamActive(gameplaycam, true)
	EnableGameplayCam(true)
	SetCamActive(cam, false)
end

function PointCamAtBone(bone,ox,oy,oz)
	SetCamActive(cam, true)
	local veh = TunningSystem.vehSelected
	local b = GetEntityBoneIndexByName(veh, bone)
	if b and b > -1 then
		local bx,by,bz = table.unpack(GetWorldPositionOfEntityBone(veh, b))
		local ox2,oy2,oz2 = table.unpack(GetOffsetFromEntityGivenWorldCoords(veh, bx, by, bz))
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(veh, ox2 + f(ox), oy2 + f(oy), oz2 +f(oz)))
		SetCamCoord(cam, x, y, z)
		PointCamAtCoord(cam,GetOffsetFromEntityInWorldCoords(veh, 0, oy2, oz2))
		RenderScriptCams( 1, 1, 1000, 0, 0)
	end
end

function camControl(c)
	Wait(50)
	if c == "Front Bumper" or c == "Grill" or c == "Vanity Plate" or c == "Aerial" then
		MoveVehCam('front',-0.6,1.5,0.4)
	elseif c == "color" or c == "Livery" or c == "Livery2" then
		MoveVehCam('middle',-2.6,2.5,1.4)
	elseif  c == "Rear Bumper" or c == "Exhaust" or c == "Fuel Tank" then
		MoveVehCam('back',-0.5,-1.5,0.2)
	elseif c == "Hood" then
		MoveVehCam('front-top',-0.5,1.3,1.0)
	elseif c == "Roof" or c == "Trim B" then
		MoveVehCam('middle',-2.2,2,1.5)
	elseif c == "Window" or c == "windtint" then
		MoveVehCam('middle',-2.0,2,0.5)
	elseif c == "HeadLight" or c == "Arch Cover" then
		MoveVehCam('front',-0.6,1.3,0.6)
	elseif c == "Plate Holder" or c == "Plaque" or c == "Trunk" or c == "Hydraulic" or c == "plate" then
		MoveVehCam('back',0,-1,0.2)
	elseif c == "Engine Block" or c == "Air Filter" or c == "Strut" then
		MoveVehCam('front',0.0,1.0,2.0)
	elseif c == "Skirt" then
		MoveVehCam('left',-1.8,-1.3,0.7)
	elseif c == "Spoiler" or c == "Left Fender" or c == "Right Fender" then
		MoveVehCam('back',1.5,-1.6,1.3)
	elseif c == "Tyres Back" or c == "smoke" then
		PointCamAtBone("wheel_lr",-1.4,0,0.3)
	elseif c == "Tyres Front" or c == "tyresoptions" then
		PointCamAtBone("wheel_lf",-1.4,0,0.3)
	elseif c == "neons" or c == "Suspension" or c == "Side Skirt" then
		PointCamAtBone("neon_l",-2.0,2.0,0.4)
	elseif c == "Interior" or c == "Ornaments" or c == "Dashboard" or c == "Seats" or c =="Roll Cage" or c == "Trim A" then
		MoveVehCam('back-top',0.0,5.0,0.7)
	elseif c == "Steering Wheel" or c == "Dial" or c == "Shifter Leaver" then
		MoveVehCam('back-top',0.0,4.0,0.7)
	elseif c == "close"	then
		SetCamCoord(cam,GetGameplayCamCoords())
		SetCamRot(cam, GetGameplayCamRot(2), 2)
		
		RenderScriptCams( 0, 1, 1000, 0, 0)
		SetCamActive(gameplaycam, true)
		EnableGameplayCam(true)
	end
end

function MoveVehCam(pos,x,y,z)
	if TunningSystem.vehSelected then
		SetCamActive(cam, true)
		local veh = TunningSystem.vehSelected
		local vx,vy,vz = table.unpack(GetEntityCoords(veh))
		local d = GetModelDimensions(GetEntityModel(veh))
		local length,width,height = d.y*-2, d.x*-2, d.z*-2
		local ox,oy,oz
		if pos == 'front' then
			ox,oy,oz= table.unpack(GetOffsetFromEntityInWorldCoords(veh, f(x), (length/2)+ f(y), f(z)))
		elseif pos == "front-top" then
			ox,oy,oz= table.unpack(GetOffsetFromEntityInWorldCoords(veh, f(x), (length/2) + f(y),(height) + f(z)))
		elseif pos == "back" then
			ox,oy,oz= table.unpack(GetOffsetFromEntityInWorldCoords(veh, f(x), -(length/2) + f(y),f(z)))
		elseif pos == "back-top" then
			ox,oy,oz= table.unpack(GetOffsetFromEntityInWorldCoords(veh, f(x), -(length/2) + f(y),(height/2) + f(z)))
		elseif pos == "left" then
			ox,oy,oz= table.unpack(GetOffsetFromEntityInWorldCoords(veh, -(width/2) + f(x), f(y), f(z)))
		elseif pos == "right" then
			ox,oy,oz= table.unpack(GetOffsetFromEntityInWorldCoords(veh, (width/2) + f(x), f(y), f(z)))
		elseif pos == "middle" then
			ox,oy,oz= table.unpack(GetOffsetFromEntityInWorldCoords(veh, f(x), f(y), (height/2) + f(z)))
		end
		SetCamCoord(cam, ox, oy, oz)
		PointCamAtCoord(cam,GetOffsetFromEntityInWorldCoords(veh, 0, 0, f(0)))
		RenderScriptCams( 1, 1, 1000, 0, 0)
		
	end
end