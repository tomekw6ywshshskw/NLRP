local lightsOn = false -- Przechowuje stan świateł
local lightTimer = nil -- Timer do migania świateł
local lightState = false -- Stan migania (włączone/wyłączone)

-- Funkcja do migania świateł na dachu
function toggleGarbageTruckLights()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle and getElementModel(vehicle) == 586 then -- Sprawdzanie, czy pojazd to śmieciarka
        if lightsOn then
            -- Wyłącz migające światła
            if lightTimer then
                killTimer(lightTimer)
                lightTimer = nil
            end
            -- Wyłącz efekt świetlny (tutaj możesz dostosować według potrzeby)
            setVehicleHeadLightColor(vehicle, 0, 0, 0) -- Wyłącz światła
            lightsOn = false
        else
            -- Włącz migające światła
            lightTimer = setTimer(function()
                lightState = not lightState
                if lightState then
                    setVehicleHeadLightColor(vehicle, 255, 165, 0) -- Kolor pomarańczowy RGB
                else
                    setVehicleHeadLightColor(vehicle, 0, 0, 0) -- Wyłącz światła
                end
            end, 500, 0) -- Miganie co 500 ms
            lightsOn = true
        end
    end
end

-- Przypisanie funkcji do klawisza
function bindToggleLightsKey()
    bindKey("l", "down", toggleGarbageTruckLights) -- 'l' to klawisz, który wywoła funkcję
end

-- Wywołanie funkcji bindToggleLightsKey po załadowaniu skryptu
addEventHandler("onClientResourceStart", resourceRoot, bindToggleLightsKey)
