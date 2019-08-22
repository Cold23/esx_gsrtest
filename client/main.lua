ESX = nil
local hasShot = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('ger:mythicProgBar')
AddEventHandler('ger:mythicProgBar', function(Source,identifier)
    TriggerEvent("mythic_progbar:client:progress",  {
                name = "gsrtest",
                duration = 5000,
                label = "Testing",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                        disableMovement = true,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                },
                animation = {
                    animDict = "missheistdockssetup1clipboard@idle_a",
                    anim = "idle_a",
                    flags = 51,
                },
                prop = {
                    model = "prop_notepad_01",
                    bone = 18905,
                    coords = { x = 0.10, y = 0.02, z = 0.05 },
                    rotation = { x = 0.0, y = 0.0, z = 0.0 },
                },
            }, function(status)
                if not status then
                    TriggerServerEvent('gsr:doServerCheck',Source,identifier)
                end
            end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        ped = GetPlayerPed(-1)
        if IsPedShooting(ped) then
            TriggerServerEvent('GSR:SetGSR', timer)
            hasShot = true
            Citizen.Wait(Config.gsrUpdate)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(2000)
        if Config.waterClean and hasShot then
            ped = GetPlayerPed(-1)
            if IsEntityInWater(ped) then
                TriggerEvent("chat:addMessage",{
                template = '<div style="padding: 0.5vw; margin: 0vw; background-color: rgba(214, 0, 0, 0.7); border-radius: 3px;" ></i> {0} <br> {1}</div>',
                args = { "[GSR]", "You begin cleaning off the Gunshot Residue... stay in the water"}
                })
                Citizen.Wait(Config.waterCleanTime)
                if IsEntityInWater(ped) then
                    hasShot = false
                    TriggerServerEvent('GSR:Remove')
                    TriggerEvent("chat:addMessage",{
                        template = '<div style="padding: 0.5vw; margin: 0vw; background-color: rgba(214, 0, 0, 0.7); border-radius: 3px;" ></i> {0} <br> {1}</div>',
                        args = { "[GSR]", "You washed off all the Gunshot Residue in the water"}
                    })
                else
                    TriggerEvent("chat:addMessage",{
                        template = '<div style="padding: 0.5vw; margin: 0vw; background-color: rgba(214, 0, 0, 0.7); border-radius: 3px;" ></i> {0} <br> {1}</div>',
                        args = { "[GSR]", "You left the water too early and did not wash off the gunshot residue."}
                    })
                end
            end
        end
    end
end)

function status()
    if hasShot then
        ESX.TriggerServerCallback('GSR:Status', function(cb)
            if not cb then
                hasShot = false
            end
        end)
    end
end

function updateStatus()
    status()
    SetTimeout(Config.gsrUpdateStatus, updateStatus)
end

updateStatus()
