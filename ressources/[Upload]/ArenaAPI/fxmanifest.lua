fx_version 'adamant'
games { 'gta5' }

client_scripts {
    "client/system/*.lua",
    "client/exports/*.lua",
    "client/*.lua",
}

server_script {
    "server/main.lua",
    "server/default_events.lua",
    "server/exports/*.lua",
    "server/module/*.lua",
    "server/system/*.lua",
}

shared_scripts {
    "config.lua",
}


lua54 "yes"

escrow_ignore {
    "config.lua",
    "client/system/*.lua",
    "client/exports/*.lua",
    "client/*.lua",
    "server/main.lua",
    "server/default_events.lua",
    "server/exports/*.lua",
    "server/module/*.lua",
    "server/system/*.lua",	
}

files {
    "html/*.html",
    "html/css/*.css",
    "html/scripts/*.js",
}

ui_page "html/index.html"
dependency '/assetpacks'