fx_version 'adamant'
games { 'gta5' }

client_scripts {
	"config.lua",
	"client/*.lua",
}

lua54 "yes"

escrow_ignore {
	"config.lua",
	"client/*.lua",
}
dependency '/assetpacks'