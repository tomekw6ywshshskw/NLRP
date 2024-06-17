local screenW, screenH = guiGetScreenSize()

local deliveryPoints = {
    {1020, 1000, 10},
    {1050, 1030, 10},
    {1080, 1060, 10},
    {1100, 1090, 10},
    -- Dodaj więcej punktów dostawy w razie potrzeby
}
local pickupPoints = {
    {950, 950, 10},
    {970, 970, 10},
    {990, 990, 10},
    {1010, 1010, 10},
    -- Dodaj więcej punktów odbioru w razie potrzeby
}

local pickupText = nil

-- Eksporty do komunikacji z systemem pracy

function displayTruckerJob()
    triggerServerEvent("acceptJob", resourceRoot, 8)  -- Przypisanie pracy magazyniera (id = 8) przez system pracy
end
exports["job-system-trucker"] = { displayTruckerJob = displayTruckerJob }

-- Aktualizacja markerów
function updateMarkers(stage)
    if stage == "pickup" then
        if isElement(deliveryBlip) then
            destroyElement(deliveryBlip)
        end
        local randomPickup = pickupPoints[math.random(#pickupPoints)]
        pickupBlip = createBlip(randomPickup[1], randomPickup[2], randomPickup[3], 41)
        setElementInterior(pickupBlip, 1)
        setElementDimension(pickupBlip, 1)
        
        if isElement(pickupText) then
            destroyElement(pickupText)
        end
        pickupText = createElement("text")
        setElementPosition(pickupText, randomPickup[1], randomPickup[2], randomPickup[3] + 1)
        setElementData(pickupText, "text", "Odbieranie paczek")
        setElementInterior(pickupText, 1)
        setElementDimension(pickupText, 1)
    elseif stage == "delivery" then
        if isElement(pickupBlip) then
            destroyElement(pickupBlip)
        end
        if isElement(pickupText) then
            destroyElement(pickupText)
        end
        local randomDelivery = deliveryPoints[math.random(#deliveryPoints)]
        deliveryBlip = createBlip(randomDelivery[1], randomDelivery[2], randomDelivery[3], 41)
        setElementInterior(deliveryBlip, 1)
        setElementDimension(deliveryBlip, 1)
    elseif stage == "none" then
        if isElement(pickupBlip) then
            destroyElement(pickupBlip)
        end
        if isElement(deliveryBlip) then
            destroyElement(deliveryBlip)
        end
        if isElement(pickupText) then
            destroyElement(pickupText)
        end
    end
end
addEvent("updateMarkers", true)
addEventHandler("updateMarkers", resourceRoot, updateMarkers)

-- Dodanie paczki do rąk gracza
function attachPackage()
    local player = localPlayer
    if getElementData(player, "hasPackage") then
        if not getElementData(player, "packageObject") then
            local package = createObject(1550, 0, 0, 0)  -- Przykładowy model paczki
            attachElements(package, player, 0, 0, 0.5)
            setElementData(player, "packageObject", package)
        end
    else
        if getElementData(player, "packageObject") then
            local package = getElementData(player, "packageObject")
            destroyElement(package)
            setElementData(player, "packageObject", nil)
        end
    end
end
addEventHandler("onClientRender", root, attachPackage)

-- Wyświetlanie GUI dla pracy magazyniera
function showJobGUI()
    -- Tutaj możesz dodać GUI, które pokazuje szczegóły pracy magazyniera
    -- Na przykład:
    local width, height = 300, 200
    local x = screenW/2 - width/2
    local y = screenH/2 - height/2
    local wJob = guiCreateWindow(x, y, width, height, "Warehouse Job", false)
    
    local lblInfo = guiCreateLabel(0.1, 0.2, 0.8, 0.6, "You are now working as a Warehouse employee.", true, wJob)
    guiLabelSetHorizontalAlign(lblInfo, "center", true)
    
    local btnClose = guiCreateButton(0.4, 0.8, 0.2, 0.1, "Close", true, wJob)
    addEventHandler("onClientGUIClick", btnClose, function()
        destroyElement(wJob)
    end, false)
    
    showCursor(true)
end
addEvent("showJobGUI", true)
addEventHandler("showJobGUI", resourceRoot, showJobGUI)

