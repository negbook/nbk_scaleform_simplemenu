fx_version 'cerulean'
game 'gta5'
author 'negbook'

lua54 'yes'
files {
   'import'
}
client_scripts {
'NBK/tasksync.lua',
'NBK/tasksync_once.lua',
'NBK/tasksync_with_keycontainer.lua',
'NBK/NBMenuSimpleS.lua',
'client/draw.lua',
'client/main.lua'
}

server_scripts {
'versionchecker.lua',
--'example-sv.lua'
}


dependencies {
	'nbk_scaleform_draw2d'
}
