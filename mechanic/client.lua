local isRepairing = false
local mechanicMenu = nil

-- Load NativeUI library
Citizen.CreateThread(function()
    mechanicMenu = NativeUI.CreateMenu("Mechanic Menu", "Perform vehicle repairs")
    
    local repairItem = NativeUI.CreateItem("Repair Vehicle", "Repair the nearby vehicle.")
    mechanicMenu:AddItem(repairItem)
    
    mechanicMenu.OnItemSelect = function(sender, item, index)
        if item == repairItem then
            StartMechanicJob()
        end
    end
end)

-- Check for player proximity to vehicle
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 38) and not isRepairing then -- Change the control to your preferred key (Default: E)
            if IsNearbyVehicle() then
                mechanicMenu:Visible(not mechanicMenu:Visible())
            else
                Notification("No nearby vehicle found.")
            end
        end
    end
end)

-- Function to check if player is near a vehicle
function IsNearbyVehicle()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    return DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle)
end

-- Function to start the mechanic job
function StartMechanicJob()
    TriggerServerEvent("mechanic:startJob")
end

-- Event to start the repair process
RegisterNetEvent("mechanic:startRepair")
AddEventHandler("mechanic:startRepair", function()
    local playerPed = PlayerPedId()
    
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
    Notification("Repairing vehicle...")
    
    Citizen.Wait(45000) -- 45 seconds
    
    ClearPedTasks(playerPed)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, true, true)
    Notification("Vehicle repaired.")
    
    isRepairing = false
end)

-- Function to display a notification
function Notification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end