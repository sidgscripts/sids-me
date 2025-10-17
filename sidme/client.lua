RegisterCommand('me', function(source, args)
    local text = table.concat(args, " ")
    if text == "" then return end
    TriggerServerEvent('me:shareDisplay', text)
end)

RegisterNetEvent('me:shareDisplay')
AddEventHandler('me:shareDisplay', function(text, sourceId)
    local player = GetPlayerFromServerId(sourceId)
    if player == -1 then return end

    CreateThread(function()
        local displayTime = GetGameTimer() + Config.DisplayTime

        while GetGameTimer() < displayTime do
            Wait(0)

            local ped = GetPlayerPed(player)
            local pedCoords = GetEntityCoords(ped)
            local myCoords = GetEntityCoords(PlayerPedId())
            local dist = #(pedCoords - myCoords)

            if dist <= Config.ViewDistance then
                local message = text
                if Config.ShowID then
                    message = "["..sourceId.."] " .. text
                end
                DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 1.0, message)
            end
        end
    end)
end)

-- 🔧 Draw 3D text function
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px, py, pz) - vector3(x, y, z))
    local scale = (1 / dist) * 2 * (1 / GetGameplayCamFov()) * 100

    if onScreen then
        SetTextScale(Config.TextScale, Config.TextScale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(Config.TextColor.r, Config.TextColor.g, Config.TextColor.b, Config.TextColor.a)
        SetTextCentre(1)
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)

        if Config.ShowBox then
            local factor = (string.len(text)) / 250
            DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, Config.BoxColor.r, Config.BoxColor.g, Config.BoxColor.b, Config.BoxColor.a)
        end
    end
end
