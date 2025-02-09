

-- Enter Door
table.insert(Config.DoorList, {
	slides = false,
	lockpick = false,
	locked = true,
	maxDistance = 2.5,
	authorizedJobs = { ['hookah']=0 },
	audioRemote = false,
	doors = {
		{objHash = -1119680854, objHeading = 87.042518615723, objCoords = vector3(-431.705, -25.40208, 46.39152)},
		{objHash = -1119680854, objHeading = 267.04254150391, objCoords = vector3(-431.575, -22.80877, 46.39152)}
 },            
        -- oldMethod = true,
        -- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
        -- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
        -- autoLock = 1000
})

-- Staff Door
table.insert(Config.DoorList, {
	slides = false,
	locked = true,
	audioRemote = false,
	lockpick = false,
	fixText = false,
	objHeading = 357.11740112305,
	garage = false,
	maxDistance = 2.0,
	authorizedJobs = { ['hookah']=0 },
	objCoords = vector3(-444.3599, -29.66731, 41.01976),
	objHash = 634417522,            
        -- oldMethod = true,
        -- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
        -- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
        -- autoLock = 1000
})