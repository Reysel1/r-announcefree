RegisterNetEvent('sendannounce:c', function(img, title, msg, time)
    SendNUIMessage({
        type = "open",
        data = {
            img = img,
            time = time,
            msg = msg,
            title = title
        }
    })
end)

RegisterCommand('anuncio', function()
    print(json.encode(CFG.ALL))
    if (not all()) then 
        QBCore.Functions.Notify('No autorizado')
    end
end)

function all()
    for k, v in pairs(CFG.ALL) do 
        local pdta = QBCore.Functions.GetPlayerData()
        if ( pdta.job.name == CFG.ALL[k].job ) then
            QBCore.UI.Menu.Open('default', GetCurrentResourceName(), 'announcemenu', {
                title = 'Menu de anuncio',
                align = "bottom-right", 
                elements = {
                    { label = 'Anuncio Default', value = 'default' },
                    { label = 'Anuncio abierto', value = 'abierto' },
                    { label = 'Anuncio cerrado', value = 'cerrado' },
                    { label = 'Cerrar menu', value = 'cerrar_m' }         
                }   
            }, function(data, menu)
                if (data.current.value == 'default') then 
                    menu.close()
                    TriggerServerEvent('sendannounce:s', CFG.ALL[k].img, pdta.job.label.." "..CFG.ALL[k].title, pdta.job.label.." "..CFG.ALL[k].msg, CFG.ALL[k].time)
                    QBCore.Functions.Notify('Enviaste un anuncio default')
                elseif (data.current.value == 'abierto') then 
                    menu.close()
                    TriggerServerEvent('sendannounce:s', CFG.ALL[k].img, pdta.job.label.." "..CFG.ALL[k].title_abierto, pdta.job.label.." "..CFG.ALL[k].msg_abierto, CFG.ALL[k].time)
                    QBCore.Functions.Notify('Anuncio enviado')
                elseif (data.current.value == 'cerrado') then 
                    menu.close()
                    TriggerServerEvent('sendannounce:s', CFG.ALL[k].img, pdta.job.label.." "..CFG.ALL[k].title_cerrado, pdta.job.label.." "..CFG.ALL[k].msg_cerrado, CFG.ALL[k].time)
                    QBCore.Functions.Notify('Anuncio enviado')        
                elseif (data.current.value == 'cerrar_m') then 
                    menu.close()
                    QBCore.Functions.Notify('Cerraste el menu correctamente')   
                end
            end, function(data, menu)
                menu.close()
            end)
            return true
        end
    end
    return false
end


