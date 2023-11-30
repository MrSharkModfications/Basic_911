RegisterCommand('call911', function(source, args, rawCommand)
    local playerPed = GetPlayerPed(-1)
    local pos = GetEntityCoords(playerPed)

    local message = table.concat(args, ' ', 1)

    TriggerServerEvent('send911', pos.x, pos.y, pos.z, message)
end, false)
