local basalt = require("basalt")
local peripheralMenu = require("menu_periph") -- Importar el modulo de perifericos
local peripheralManager = require("periph") -- Importar el gestor de perifericos

local function create(mainFrame, theme)
    -- Cargar traducciones
    local tr = require("translations")

    -- Apagar el cursor parpadeante globalmente
    term.setCursorBlink(false)

    -- Realizar una deteccion de perifericos al abrir el menu principal
    peripheralManager.detect()

    -- Crear un monitor frame para contener todo
    local monitorFrame = mainFrame:addFrame()
        :setSize("parent.w", "parent.h")
        :setBackground(theme.monitorFrame) -- Usar color del tema para el fondo

    -- Crear el menu de perifericos utilizando el monitorFrame
    local peripheralMenuInstance = peripheralMenu.create(monitorFrame, theme)

    -- Crear el Menubar para las opciones del menu
    local menuBar = monitorFrame:addMenubar()
        :setPosition(1, 1) -- Pegado al borde superior
        :setSize("parent.w", 1) -- Altura fija
        :setBackground(theme.menubarBG)
        :setSelectionColor(theme.menubarSelectBG, theme.menubarSelectFG) -- Colores de seleccion del tema
        :setSpace(2) -- Espaciado entre los elementos del menu

    -- Agregar las opciones al Menubar
    menuBar:addItem(tr.menu_home, theme.menubarBG, theme.menubarFG)
    menuBar:addItem(tr.menu_peripherals, theme.menubarBG, theme.menubarFG)
    menuBar:addItem(tr.menu_energy, theme.menubarBG, theme.menubarFG)
    menuBar:addItem(tr.menu_gps, theme.menubarBG, theme.menubarFG)
    menuBar:addItem(tr.menu_shutdown, theme.shutdownFG, theme.menubarFG) -- Color rojo para apagar

    -- Variable para rastrear que opcion se ha seleccionado
    local lastSelectedOption = ""

    -- Manejar los clics con onClick
    menuBar:onClick(function(self, event, button, x, y)
        -- Obtener el texto del elemento seleccionado
        local selectedIndex = self:getItemIndex()
        if selectedIndex then
            local item = self:getItem(selectedIndex)
            if item and item.text then
                lastSelectedOption = item.text

                -- Ejecutar la accion correspondiente segun el texto
                if lastSelectedOption == tr.menu_peripherals then
                    peripheralManager.detect()
                    peripheralMenuInstance.toggleVisibility()
                elseif lastSelectedOption == tr.menu_gps then
                    local menuGPS = require("menu_gps").create(monitorFrame, theme) -- Pasar theme al modulo GPS
                    menuGPS.openGPSFrame(tr.gps_title, nil, nil, 40, 15)
                elseif lastSelectedOption == tr.menu_shutdown then
                    os.shutdown()
                end
            end
        end
    end)

    return { monitorFrame = monitorFrame }
end

return { create = create }