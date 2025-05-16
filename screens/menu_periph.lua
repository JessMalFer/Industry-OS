local basalt = require("basalt")
local peripheralManager = require("periph")

local function create(monitorFrame, theme)
    local tr = require("translations")
    local isVisible = false
    local managementFrames = {}
    local popupFrame = nil

    -- Crear el frame principal
    local periphFrame = monitorFrame:addFrame()
        :setSize(monitorFrame:getWidth(), monitorFrame:getHeight() - 1)
        :setPosition(1, 3)
        :setBackground(theme.background)
        :hide()

    periphFrame:addLabel()
        :setPosition(3, 1)
        :setText(tr.periph_title)
        :setForeground(theme.title)

    -- Función para mostrar la información detallada del periférico
    local function updatePeripheralInfo(popupFrame, peripheralName)
        -- Limpiar elementos existentes (si los hay)
        if popupFrame.labelContainer then
            popupFrame.labelContainer:remove()
        end
        
        -- Crear un contenedor normal para los labels
        local labelContainer = popupFrame:addFrame()
            :setPosition(4, 8) 
            :setSize(popupFrame:getWidth()-8, popupFrame:getHeight()-10)
            :setBackground(theme.background)
        
        popupFrame.labelContainer = labelContainer
        
        -- Crear el scrollbar
        if popupFrame.scrollbar then
            popupFrame.scrollbar:remove()
        end
        
        local scrollbar = popupFrame:addScrollbar()
            :setPosition(popupFrame:getWidth()-3, 8)
            :setSize(1, popupFrame:getHeight()-10)
            :setBarType("vertical")
            :setBackground(theme.menubarBG)
            :setForeground(theme.success)
            :setSymbol("\127")
            
        popupFrame.scrollbar = scrollbar
        
        -- Obtener el periférico seleccionado
        local peripherals = peripheralManager.getPeripherals()
        local peripheral = peripherals[peripheralName]
        
        if not peripheral then
            labelContainer:addLabel()
                :setPosition(1, 1)
                :setText("Periférico no encontrado")
                :setForeground(theme.error)
            return
        end
        
        -- Mostrar información del periférico
        local yPos = 1
        
        -- ID técnico (antes era nombre)
        labelContainer:addLabel()
            :setPosition(1, yPos)
            :setText(tr.periph_tech_id)
            :setForeground(theme.text)
        
        labelContainer:addLabel()
            :setPosition(15, yPos)
            :setText(peripheral.name)
            :setForeground(theme.title)
        
        yPos = yPos + 2
        
        -- Nombre personalizado (antes era ID personalizado)
        labelContainer:addLabel()
            :setPosition(1, yPos)
            :setText(tr.periph_name)
            :setForeground(theme.text)
        
        local nameInput = labelContainer:addInput()
            :setPosition(15, yPos)
            :setSize(16, 1)
            :setBackground(theme.inputBG)
            :setForeground(theme.inputFG)
            :setDefaultText(tr.periph_name_placeholder)
            :setBorder(theme.borderNormal, "bottom")
        
        nameInput:setValue(peripheral.custom_id or peripheral.name)
        
        yPos = yPos + 2
        
        -- Tipo de periférico
        labelContainer:addLabel()
            :setPosition(1, yPos)
            :setText(tr.periph_type)
            :setForeground(theme.text)
        
        local tipoTraducido = peripheral.type == "monitor" and tr.periph_type_monitor
            or peripheral.type == "modem" and tr.periph_type_modem
            or peripheral.type == "glassScreen" and tr.periph_type_glassscreen
            or peripheral.type
        
        labelContainer:addLabel()
            :setPosition(15, yPos)
            :setText(tipoTraducido)
            :setForeground(theme.title)
        
        yPos = yPos + 2
        
        -- Estado del periférico
        labelContainer:addLabel()
            :setPosition(1, yPos)
            :setText(tr.periph_status)
            :setForeground(theme.text)
        
        local estadoColor = peripheral.estado == "Conectado" and theme.online or theme.offline
        
        labelContainer:addLabel()
            :setPosition(15, yPos)
            :setText(peripheral.estado)
            :setForeground(estadoColor)
        
        yPos = yPos + 2
        
        -- Vendor (si existe)
        if peripheral.vendor then
            labelContainer:addLabel()
                :setPosition(1, yPos)
                :setText(tr.periph_vendor)
                :setForeground(theme.text)
            
            labelContainer:addLabel()
                :setPosition(15, yPos)
                :setText(peripheral.vendor)
                :setForeground(theme.title)
            
            yPos = yPos + 2
        end
        
        yPos = yPos + 1
        
        -- Botones de acción
        -- Guardar nombre personalizado
        local saveButton = labelContainer:addButton()
            :setPosition(1, yPos)
            :setSize(12, 3)
            :setText(tr.btn_save)
            :setBackground(theme.buttonBG)
            :setForeground(theme.buttonFG)
            :setBorder(theme.borderNormal)
            :onClick(function()
                local newName = nameInput:getValue()
                if newName and newName ~= "" then
                    if peripheralManager.setPeripheralID(peripheralName, newName) then
                        local successMsg = labelContainer:addLabel()
                            :setPosition(14, yPos + 1)
                            :setText(tr.periph_name_updated)
                            :setForeground(theme.success)
                        
                        -- Ocultar mensaje después de 2 segundos
                        local timer = labelContainer:addTimer()
                        timer:setTime(2)
                        timer:start()
                        timer:onCall(function()
                            successMsg:remove()
                            timer:stop()
                        end)
                    end
                end
            end)
        
        -- Eliminar periférico
        local deleteButton = labelContainer:addButton()
            :setPosition(15, yPos)
            :setSize(12, 3)
            :setText(tr.btn_delete)
            :setBackground(theme.buttonBG)
            :setForeground(theme.error)
            :setBorder(theme.borderNormal)
            :onClick(function()
                if peripheralManager.removePeripheral(peripheralName) then
                    popupFrame:remove()
                    popupFrame = nil
                end
            end)
        
        -- Configurar el scrollbar basado en la altura total del contenido
        local _, visibleHeight = labelContainer:getSize()
        local totalHeight = yPos + 4 -- Dejamos un poco de espacio extra al final
        
        if totalHeight > visibleHeight then
            scrollbar:setScrollAmount(math.floor(totalHeight - visibleHeight))
            
            -- Conectar el scrollbar con el contenedor
            scrollbar:onChange(function(self)
                labelContainer:setOffset(0, self:getIndex() - 1)
            end)
            
            -- Permitir que la rueda del ratón controle el scrollbar
            labelContainer:onScroll(function(self, event, direction)
                local currentIndex = scrollbar:getIndex()
                local maxScroll = scrollbar:getScrollAmount()
                
                if direction < 0 then -- scroll hacia arriba
                    scrollbar:setIndex(math.max(1, currentIndex - 1))
                else -- scroll hacia abajo
                    scrollbar:setIndex(math.min(maxScroll, currentIndex + 1))
                end
            end)
        else
            -- Si no hay suficiente contenido, desactivar el scrollbar
            scrollbar:setScrollAmount(1)
            scrollbar:setIndex(1)
        end
    end

    -- Función para crear la ventana emergente de gestión
    local function createManagementFrame(tipo)
        if popupFrame then 
            popupFrame:remove()
            popupFrame = nil
        end

        -- Recopilar datos de periféricos
        local peripheralsRaw = peripheralManager.getPeripherals()
        print("Total de periféricos en el sistema: " .. table.maxn(peripheralsRaw))
        
        -- Filtrar periféricos usando la nueva función
        local filteredPeriph = peripheralManager.getPeripheralsByType(tipo)
        local filteredPeripherals = {}
        
        -- Convertir a una tabla de array para facilitar la ordenación
        for name, data in pairs(filteredPeriph) do
            table.insert(filteredPeripherals, {name = name, data = data})
        end
        
        -- Log de depuración
        print("Periféricos encontrados (" .. tipo .. "): " .. #filteredPeripherals)
        
        -- Debug: mostrar los nombres de los periféricos encontrados
        for i, periph in ipairs(filteredPeripherals) do
            print(i .. ": " .. periph.name .. " (" .. periph.data.type .. ")")
        end
        
        -- Ordenar los periféricos alfabéticamente por nombre personalizado
        table.sort(filteredPeripherals, function(a, b)
            local nameA = a.data.custom_id or a.name
            local nameB = b.data.custom_id or b.name
            return nameA < nameB
        end)
        
        -- Texto del título según el tipo
        local titulo = (
            tipo == "monitor" and tr.periph_manage_monitor or
            tipo == "modem" and tr.periph_manage_modem or
            tipo == "energy" and tr.periph_manage_energy or
            tr.periph_title
        )

        -- Crear ventana emergente
        popupFrame = monitorFrame:addMovableFrame()
            :setSize(45, 22)
            :setPosition(math.random(5, 15), math.random(5, 10))
            :setBackground(theme.background)
            :setBorder(theme.borderMovable)

        -- Cabecera
        local headerFrame = popupFrame:addFrame()
            :setSize(popupFrame:getWidth(), 1)
            :setPosition(1, 1)
            :setBackground(theme.headerBG)
            
        -- Título
        headerFrame:addLabel()
            :setSize(popupFrame:getWidth()-2, 1)
            :setBackground(theme.headerBG)
            :setForeground(theme.headerFG)
            :setText(titulo)
            
        -- Botón de cierre
        headerFrame:addButton()
            :setSize(1, 1)
            :setText("X")
            :setBackground(theme.headerBG)
            :setForeground(theme.error)
            :setPosition(popupFrame:getWidth()-1, 1)
            :onClick(function()
                popupFrame:remove()
                popupFrame = nil
            end)
        
        -- Frame para el dropdown (este no será scrollable)
        local dropdownFrame = popupFrame:addFrame()
            :setPosition(4, 3)
            :setSize(popupFrame:getWidth()-8, 4)
            :setBackground(theme.background)
        
        -- Mensaje sobre los periféricos encontrados
        local countLabel = dropdownFrame:addLabel()
            :setPosition(0, 1)
            :setForeground(theme.text)
        
        if #filteredPeripherals > 0 then
            countLabel:setText(tr.periph_select .. " (" .. #filteredPeripherals .. " disponibles)")
        else
            countLabel:setText(tr.periph_none)
        end
            
        -- Dropdown para seleccionar periférico
        local dropdown = dropdownFrame:addDropdown()
            :setPosition(0, 3)
            :setSize(dropdownFrame:getWidth(), 1)
        
        if #filteredPeripherals > 0 then
            dropdown:setDropdownSize(dropdownFrame:getWidth(), math.min(8, #filteredPeripherals))
                :setBackground(theme.dropdownBG)
                :setForeground(theme.dropdownFG)
                :setBorder(theme.borderNormal)
            
            -- Poblar el dropdown con los periféricos filtrados
            for i, periph in ipairs(filteredPeripherals) do
                local itemColor = periph.data.estado == "Conectado" and theme.online or theme.offline
                local displayText = (periph.data.custom_id or periph.name) .. " (" .. periph.data.type .. ")"
                dropdown:addItem(displayText, itemColor, nil, {periph.name})
                print("Añadido item " .. i .. " al dropdown: " .. displayText)
            end
            
            -- Seleccionar el primer periférico por defecto
            updatePeripheralInfo(popupFrame, filteredPeripherals[1].name)
            
            -- Evento para actualizar la información al seleccionar un periférico
                dropdown:onChange(function(self, selected)
                if selected and selected.args and selected.args[1] then
                    updatePeripheralInfo(popupFrame, selected.args[1])
                end
            end)
        else
            -- Si no hay periféricos, mostrar un dropdown deshabilitado
            dropdown:setDropdownSize(dropdownFrame:getWidth(), 1)
                :setBackground(theme.menubarBG)
                :setForeground(theme.text)
                :setBorder(theme.borderNormal)
                :addItem(tr.periph_none)
        end

        -- Hacer la ventana redimensionable con mejor manejo de cambio de tamaño
        local function makeResizeable(frame, minW, minH, maxW, maxH)
            minW = minW or 30
            minH = minH or 15
            maxW = maxW or 99
            maxH = maxH or 99
            
            local btn = frame:addButton()
                :setPosition(frame:getWidth()-1, frame:getHeight()-1)
                :setSize(1, 1)
                :setText("/")
                :setForeground(colors.blue)
                :setBackground(theme.background)
                :onDrag(function(self, event, btn, xOffset, yOffset)
                    local w, h = frame:getSize()
                    local wOff, hOff = w, h
                    
                    if (w+xOffset-1 >= minW) and (w+xOffset-1 <= maxW) then
                        wOff = w+xOffset-1
                    end
                    
                    if (h+yOffset-1 >= minH) and (h+yOffset-1 <= maxH) then
                        hOff = h+yOffset-1
                    end
                    
                    frame:setSize(wOff, hOff)
                    self:setPosition(frame:getWidth()-1, frame:getHeight()-1)
                    
                    -- Actualizar posiciones y tamaños cuando el frame cambia de tamaño
                    headerFrame:setSize(frame:getWidth(), 1)
                    
                    if frame.labelContainer then
                        frame.labelContainer:setSize(frame:getWidth()-8, frame:getHeight()-10)
                    end
                    
                    if frame.scrollbar then
                        frame.scrollbar:setPosition(frame:getWidth()-3, 8)
                        frame.scrollbar:setSize(1, frame:getHeight()-10)
                    end
                    
                    -- Recalcular dropdown
                    dropdownFrame:setSize(frame:getWidth()-8, 4)
                    dropdown:setSize(dropdownFrame:getWidth(), 1)
                    
                    if #filteredPeripherals > 0 then
                        dropdown:setDropdownSize(dropdownFrame:getWidth(), math.min(8, #filteredPeripherals))
                    
                        -- Actualizar la interfaz tras el redimensionamiento
                        if dropdown:getItemIndex() then
                            local selectedItem = dropdown:getItem(dropdown:getItemIndex())
                            if selectedItem and selectedItem.args and selectedItem.args[1] then
                                updatePeripheralInfo(frame, selectedItem.args[1])
                            end
                        end
                    end
                end)
        end
        
        makeResizeable(popupFrame, 45, 22, 80, 50)
    end
    
    -- Botones para gestionar cada tipo de periférico
    periphFrame:addButton()
        :setPosition(3, 3)
        :setSize(20, 3)
        :setText(tr.periph_monitors)
        :setBackground(theme.buttonBG)
        :setForeground(theme.buttonFG)
        :setBorder(theme.borderNormal)
        :onClick(function()
            createManagementFrame("monitor")
        end)

    periphFrame:addButton()
        :setPosition(3, 7)
        :setSize(20, 3)
        :setText(tr.periph_modems)
        :setBackground(theme.buttonBG)
        :setForeground(theme.buttonFG)
        :setBorder(theme.borderNormal)
        :onClick(function()
            createManagementFrame("modem")
        end)

    periphFrame:addButton()
        :setPosition(3, 11)
        :setSize(20, 3)
        :setText(tr.periph_energy)
        :setBackground(theme.buttonBG)
        :setForeground(theme.buttonFG)
        :setBorder(theme.borderNormal)
        :onClick(function()
            createManagementFrame("energy")
        end)

    -- Botón para actualizar manualmente
    periphFrame:addButton()
        :setPosition(3, 15)
        :setSize(20, 3)
        :setText(tr.btn_update)
        :setBackground(theme.buttonBG)
        :setForeground(theme.buttonFG)
        :setBorder(theme.borderNormal)
        :onClick(function()
            print("Actualizando periféricos...")
            peripheralManager.detect()
            if popupFrame then
                popupFrame:remove()
                popupFrame = nil
            end
        end)

    -- Función para mostrar/ocultar el menú de periféricos
    local function toggleVisibility()
        if isVisible then
            periphFrame:hide()
            isVisible = false
            
            if popupFrame then
                popupFrame:remove()
                popupFrame = nil
            end
            
            for name, frame in pairs(managementFrames) do 
                frame:remove() 
            end
            managementFrames = {}
        else
            -- La detección ya se realizó en startup.lua, no es necesario volver a hacerla aquí
            periphFrame:show()
            isVisible = true
        end
    end

    return {
        toggleVisibility = toggleVisibility
    }
end

return { create = create }
