RegisterNetEvent('sendannounce:s', function(img, title, msg, time)
    TriggerClientEvent('sendannounce:c', -1, img, title, msg, time)
end)