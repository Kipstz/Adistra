fx_version 'bodacious'
games { 'gta5' }

client_scripts {
    'config.lua',
    'client/*.lua'
}

server_scripts {
    'config.lua',
    'server/*.lua',
}

escrow_ignore {
    "client/*",
    "server/*",
	"config.lua",
}

lua54 'yes'
dependency '/assetpacks'