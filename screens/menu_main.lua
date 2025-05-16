local basalt = require("basalt")
local peripheralMenu = require("screens.menu_periph")
local peripheralManager = require("periph")
local Flexbox = require("components.flexbox")

local function create(mainFrame, theme)
    local tr = require("translations")
    term.setCursorBlink(false)
    peripheralManager.detect()

    -- Crear un monitor frame para contener todo
    local monitorFrame = mainFrame:addFrame()
        :setSize("parent.w", "parent.h")
        :setBackground(theme.monitorFrame)

    -- Crear el Flexbox con botones
    local menuFlex = Flexbox.create(monitorFrame, {
        gap = 1,
        y = 1,
        background = theme.background,
        buttonBG = theme.buttonBG,
        buttonFG = theme.buttonFG,
        border = theme.borderNormal
    })

    -- Agregar botones al Flexbox
    menuFlex.addButton(tr.menu_home)
    menuFlex.addButton(tr.menu_peripherals)
    menuFlex.addButton(tr.menu_energy)
    menuFlex.addButton(tr.menu_gps)
    menuFlex.addButton(tr.menu_shutdown)

    -- Frame contenedor (ajustado para estar debajo del Flexbox)
    local contentFrame = monitorFrame:addFrame()
        :setPosition(1, 4)  -- Posición ajustada
        :setSize("parent.w", "parent.h-3")  -- Tamaño ajustado
        :setBackground(theme.background)

    -- Frame scrolleable como hijo
    local objects = {}
    local scrollFrame = contentFrame:addFrame()
        :setSize("parent.w", 30) -- Altura mayor que el contenedor para probar el scroll
        :setBackground(theme.background)
        :onScroll(function(self, event, dir)
            local yOffset = select(2, self:getOffset())
            local maxScroll = 0
            for _, v in pairs(objects) do
                local y = v:getY()
                local h = v:getHeight()
                maxScroll = y + h > maxScroll and y + h or maxScroll
            end
            local visibleHeight = contentFrame:getHeight()
            if (yOffset + dir >= 0) and (yOffset + dir <= maxScroll - visibleHeight) then
                self:setOffset(0, yOffset + dir)
            end
        end)

    -- Importar componentes
    local ProgressBar = require("components.progressbar")
    local ProgressBar2 = require("components.progressbar2")

    -- Añadir referencia para limpiar barras previas
    local activeBars = {}

    local function clearActiveBars()
        for _, bar in ipairs(activeBars) do
            if bar and bar.remove then bar:remove() end
        end
        activeBars = {}
    end

    -- Función para crear botones y añadirlos a la tabla de objetos
    local function createTestButton(text, y, onClick)
        local btn = scrollFrame:addButton()
            :setText(text)
            :setSize(20, 3)
            :setPosition(3, y)
            :setBackground(theme.buttonBG)
            :setForeground(theme.buttonFG)
            :setBorder(theme.borderNormal)
        table.insert(objects, btn)
        if onClick then
            btn:onClick(function()
                clearActiveBars()
                onClick(btn)
            end)
        end
        return btn
    end

    -- Función para mostrar/ocultar botones de prueba
    local testButtonsVisible = false
    local testButtons = {}

    local function toggleTestButtons(show)
        if show and not testButtonsVisible then
            testButtons.progressbar = createTestButton("ProgressBar", 2, function(btn)
                local bx, by = btn:getPosition()
                local bw, bh = btn:getSize()
                local bar = ProgressBar(scrollFrame, bx + bw + 1, by, 30)
                table.insert(activeBars, bar)
            end)
            testButtons.progressbar2 = createTestButton("ProgressBar2", 6, function(btn)
                local bx, by = btn:getPosition()
                local bw, bh = btn:getSize()
                local bar = ProgressBar2(scrollFrame, bx + bw + 1, by, 30)
                table.insert(activeBars, bar)
            end)
            testButtons.sidebar = createTestButton("Sidebar", 10)
            testButtons.graphic = createTestButton("Graphic", 14)
            testButtonsVisible = true
        elseif not show and testButtonsVisible then
            for _, button in pairs(testButtons) do
                button:remove()
            end
            for i = #objects, 1, -1 do
                if not objects[i] or objects[i].isRemoved and objects[i]:isRemoved() then
                    table.remove(objects, i)
                end
            end
            clearActiveBars()
            testButtons = {}
            testButtonsVisible = false
        end
    end

    -- Variables para controlar menus activos
    local activeMenu = nil
    local peripheralMenuInstance = peripheralMenu.create(monitorFrame, theme)

    -- Función para limpiar el estado actual
    local function clearCurrentState()
        -- Ocultar botones de prueba
        toggleTestButtons(false)

        -- Ocultar menú de periféricos si está visible
        if activeMenu == "peripherals" then
            peripheralMenuInstance.toggleVisibility()
        end

        activeMenu = nil
    end

    -- Manejar clics del menubar
    menuFlex.onClick(function(button, index)
        local item = menuFlex.getItem(index)
        if item then
            local buttonText = item.text

            -- Primero limpiamos el estado actual
            clearCurrentState()

            -- Luego manejamos el nuevo click
            if buttonText == tr.menu_home then
                toggleTestButtons(true)
                activeMenu = "home"
            elseif buttonText == tr.menu_peripherals then
                peripheralManager.detect()
                peripheralMenuInstance.toggleVisibility()
                activeMenu = "peripherals"
            elseif buttonText == tr.menu_gps then
                local menuGPS = require("screens.menu_gps").create(monitorFrame, theme)
                menuGPS.openGPSFrame(tr.gps_title, nil, nil, 40, 15)
                activeMenu = "gps"
            elseif buttonText == tr.menu_energy then
                -- TODO: Implementar menú de energía
                activeMenu = "energy"
            elseif buttonText == tr.menu_shutdown then
                os.shutdown()
            end
        end
    end)

    return { monitorFrame = monitorFrame }
end

return { create = create }
