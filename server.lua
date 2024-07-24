-- Definicja markerów mechanika
local mechanicMarkers = {
    { x = 1000, y = -1000, z = 12 },
    { x = 2000, y = 1000, z = 12 }
}

-- Ceny części pojazdu
local partPrices = {
    ["engine"] = 500,
    ["left_door"] = 200,
    ["right_door"] = 200,
    ["hood"] = 300,
    ["trunk"] = 250,
    ["front_bumper"] = 150,
    ["rear_bumper"] = 150
}

-- Funkcja tworząca markery mechanika
function createMechanicMarkers()
    for _, marker in ipairs(mechanicMarkers) do
        local x, y, z = marker.x, marker.y, marker.z
        createMarker(x, y, z, "cylinder", 3.0, 255, 0, 0, 150)
    end
end

addEventHandler("onResourceStart", resourceRoot, createMechanicMarkers)

-- Obsługa naprawy pojazdu
function repairVehicle(player, parts)
    local totalCost = 0
    for part, price in pairs(parts) do
        if partPrices[part] then
            totalCost = totalCost + partPrices[part]
        end
    end

    if getPlayerMoney(player) >= totalCost then
        takePlayerMoney(player, totalCost)
        outputChatBox("Naprawiłeś części za " .. totalCost .. "$!", player)
        -- Tutaj dodaj kod naprawiający części
        -- for part, _ in pairs(parts) do
        --     fixVehiclePart(player, part)
        -- end
    else
        outputChatBox("Nie masz wystarczająco pieniędzy!", player)
    end
end

addEvent("repairVehicle", true)
addEventHandler("repairVehicle", resourceRoot, repairVehicle)
