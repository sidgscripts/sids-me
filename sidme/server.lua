RegisterNetEvent('me:shareDisplay')
AddEventHandler('me:shareDisplay', function(text)
    local src = source
    TriggerClientEvent('me:shareDisplay', -1, text, src)
end)
