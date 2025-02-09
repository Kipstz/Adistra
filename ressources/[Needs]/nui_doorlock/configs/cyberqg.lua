

-- Garage Door
table.insert(Config.DoorList, {
	objHash = -1703306801,
	authorizedJobs = { ['carhub']=0 },
	objHeading = 260.0,
	slides = 6.0,
	fixText = true,
	maxDistance = 6.0,
	locked = true,
	lockpick = false,
	audioRemote = false,
	garage = true,
	objCoords = vector3(379.9088, 3583.384, 35.1454),            
        -- oldMethod = true,
        -- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
        -- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
        -- autoLock = 1000
})

-- Door
table.insert(Config.DoorList, {
	objHash = -1207991715,
	authorizedJobs = { ['carhub']=0 },
	objHeading = 350.0,
	slides = false,
	fixText = false,
	maxDistance = 2.0,
	locked = true,
	lockpick = false,
	audioRemote = false,
	garage = false,
	objCoords = vector3(388.0762, 3584.096, 33.46016),            
        -- oldMethod = true,
        -- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
        -- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
        -- autoLock = 1000
})

-- Cyber Enter
table.insert(Config.DoorList, {
	locked = true,
	objHeading = 350.0,
	garage = false,
	fixText = false,
	objCoords = vector3(388.0762, 3584.096, 33.46016),
	maxDistance = 2.0,
	slides = false,
	objHash = -1207991715,
	lockpick = false,
	audioRemote = false,
	authorizedJobs = { ['carhub']=0 },            
        -- oldMethod = true,
        -- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
        -- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
        -- autoLock = 1000
})