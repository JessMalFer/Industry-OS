local peripheralManager = {}

-- Tabla para almacenar los datos de los periféricos
local peripherals = {}
local id_counter = 0

-- Función para detectar periféricos conectados
function peripheralManager.detect()
    -- Guardar los periféricos existentes para mantener sus propiedades personalizadas
    local existingPeripherals = {}
    for name, data in pairs(peripherals) do
        existingPeripherals[name] = {
            id = data.id,
            name = data.name,
            type = data.type,
            vendor = data.vendor or "",
            custom_id = data.custom_id -- Almacenar ID personalizado si existe
        }
    end
    
    -- Limpiar tabla y reiniciar contador solo si es necesario
    peripherals = {}
    
    -- Detectar todos los periféricos actuales
    for _, name in ipairs(peripheral.getNames()) do
        local type = peripheral.getType(name)
        
        -- Reconocer tipos específicos de periféricos
        if type == "glassScreen" or (peripheral.hasType and peripheral.hasType(name, "glassScreen")) then
            type = "glassScreen"
        end
        
        -- Identificar periféricos de energía de Mekanism más específicamente
        if type == "mekanism:machine" or (peripheral.hasType and peripheral.hasType(name, "mekanism:machine")) then
            -- Intentar obtener más detalles sobre el dispositivo de Mekanism
            local p = peripheral.wrap(name)
            if p then
                if p.getEnergy ~= nil or p.getMaxEnergy ~= nil then
                    -- Si tiene estos métodos, es un dispositivo relacionado con energía
                    if p.getInventoryName and p.getInventoryName() then
                        if string.find(p.getInventoryName():lower(), "energy") or 
                           string.find(p.getInventoryName():lower(), "induction") then
                            type = "energy_" .. (p.getInventoryName() or "device")
                        end
                    else
                        type = "energy_device"
                    end
                end
            end
        end
        
        -- Conservar o crear ID
        local periph_id = (existingPeripherals[name] and existingPeripherals[name].id) or id_counter + 1
        id_counter = math.max(id_counter, periph_id)
        
        -- Conservar o crear datos del periférico
        peripherals[name] = {
            id = periph_id,
            name = name,
            type = type,
            estado = "Conectado",
            vendor = (existingPeripherals[name] and existingPeripherals[name].vendor) or 
                     (type == "glassScreen" and "VoidPower" or "Vanilla"),
            custom_id = (existingPeripherals[name] and existingPeripherals[name].custom_id) or name
        }
        
        -- Debug
        print("Periférico detectado: " .. name .. " (Tipo: " .. type .. ") ID: " .. periph_id)
    end
    
    -- Marcar como desconectados los periféricos que ya no están presentes pero estaban antes
    for name, data in pairs(existingPeripherals) do
        if not peripherals[name] then
            peripherals[name] = {
                id = data.id,
                name = name,
                type = data.type,
                estado = "Desconectado",
                vendor = data.vendor,
                custom_id = data.custom_id
            }
            print("Periférico desconectado: " .. name)
        end
    end
    
    return peripherals
end

-- Función para obtener la tabla de periféricos
function peripheralManager.getPeripherals()
    return peripherals
end

-- Función para asignar un nombre personalizado a un periférico
function peripheralManager.setPeripheralID(name, custom_id)
    if peripherals[name] then
        peripherals[name].custom_id = custom_id
        print("Nombre personalizado establecido: " .. name .. " -> " .. custom_id)
        return true
    end
    return false
end

-- Función para eliminar un periférico de la tabla
function peripheralManager.removePeripheral(name)
    if peripherals[name] then
        peripherals[name] = nil
        print("Periférico eliminado: " .. name)
        return true
    end
    return false
end

-- Función para obtener un periférico por su nombre
function peripheralManager.getPeripheral(name)
    return peripherals[name]
end

-- Función para filtrar periféricos por tipo
function peripheralManager.getPeripheralsByType(type)
    local result = {}
    for name, data in pairs(peripherals) do
        if type == "monitor" and (data.type == "monitor" or data.type == "glassScreen") then
            result[name] = data
        elseif type == "modem" and (data.type == "modem" or data.type == "ender_modem") then
            result[name] = data
        elseif type == "energy" and (
            data.type == "energy" or 
            string.find(data.type or "", "battery") or 
            string.find(data.type or "", "generator") or
            string.find(data.type or "", "energy") or
            string.find(data.type or "", "induction")
        ) then
            result[name] = data
        elseif data.type == type then
            result[name] = data
        end
    end
    return result
end

-- Realizar una detección inicial al cargar el módulo
peripheralManager.detect()

return peripheralManager
