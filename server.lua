RegisterServerEvent('afkkick', function()
 --    print('kick')
     DropPlayer(source, config.Lang[config.LangType]['kick_message'])
end)