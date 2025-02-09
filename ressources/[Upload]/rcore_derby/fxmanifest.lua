fx_version 'adamant'
games { 'gta5' }

client_scripts {
    "utils/cam.lua",
    "client/*.lua",
}

server_script {
    "utils/server.lua",
    "server/*.lua",
}

shared_scripts {
    "locales/*.lua",
    "config.lua",
    "shared.lua",
    "object.lua",
}

escrow_ignore {
    "locales/*.lua",
    "config.lua",
    "shared.lua",
    "object.lua",
    "utils/server.lua",
    "server/*.lua",
    "utils/cam.lua",
    "client/*.lua",
}


dependencies {
    "ArenaAPI",
    "rcore_arenajoinhandler",
}

files {
    "html/*.*",
    "html/css/*.css",
    "html/scripts/*.js",
}

ui_page "html/index.html"

lua54 "yes"
dependency '/assetpacks'