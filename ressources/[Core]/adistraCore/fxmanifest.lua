shared_script '@ac/shared_fg-obfuscated.lua'
fx_version("cerulean")
game("gta5")
lua54("yes")
--HTML
ui_page 'html/index.html'
-- MySQL
server_script("@oxmysql/lib/MySQL.lua")
-- RageUI
client_scripts {
    'RageUI/RMenu.lua',
    'RageUI/menu/RageUI.lua',
    'RageUI/menu/Menu.lua',
    'RageUI/menu/MenuController.lua',
    'RageUI/components/*.lua',
    'RageUI/menu/elements/*.lua',
    'RageUI/menu/items/*.lua',
    'RageUI/menu/panels/*.lua',
    'RageUI/menu/windows/*.lua',
}
client_scripts {
    --Addons
    'src/**/client/*.lua',
}
server_scripts {
    -- Addons
    'src/**/server/*.lua',
}
shared_scripts {
    -- Config
    'src/**/config.lua',
    -- Lib OX
    '@ox_lib/init.lua',
}
files {
	'html/index.html',
	'html/assets/css/*.css',
	'html/assets/js/*.js',
	'html/assets/fonts/roboto/*.woff',
	'html/assets/fonts/roboto/*.woff2',
	'html/assets/fonts/justsignature/JustSignature.woff',
	'html/assets/images/*.png'
}