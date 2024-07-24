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


-- Serwer: montowanie obiektu koguta na dachu śmieciarki
addEventHandler("onResourceStart", resourceRoot,
    function()
        local kogutID = 2004  -- ID obiektu koguta
        local smieciarkaID = 408  -- ID śmieciarki

        -- Funkcja do zamontowania koguta na dachu śmieciarki
        function mountKogut()
            for _, gracz in ipairs(getElementsByType("player")) do
                local pojazd = getPedOccupiedVehicle(gracz)
                if pojazd and getElementModel(pojazd) == smieciarkaID then
                    local kogut = createObject(kogutID, 0, 0, 0, 0, 0, 0)
                    local px, py, pz = getElementPosition(pojazd)
                    attachElements(kogut, pojazd, 0, 0, 2)  
                    setElementPosition(kogut, px, py, pz + 3)  
                end
            end
        end

        -- Aktywuj funkcję przy każdym wejściu gracza do pojazdu
        addEventHandler("onPlayerVehicleEnter", root, mountKogut)
    end
)
