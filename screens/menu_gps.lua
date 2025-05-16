local basalt = require("basalt")

local function create(mainFrame, theme)
    local tr = require("translations")
    local modalWindow = require("components.modal_window").create(mainFrame, theme, tr)
    
    local gpsThread = nil
    local gpsFrame = nil

    -- Funcion para detectar modems y buscar conexion GPS
    local function detectAndConnectGPS(frame)
        frame:addLabel()
            :setPosition(2, 4)
            :setText(tr.gps_detecting_modems)
            :setForeground(theme.info)

        -- Detectar modems inalambricos
        local modem = nil
        local modems = peripheral.find("modem")
        local modemType = nil

        if modems then
            if peripheral.find("modem", function(name, obj) return obj.isWireless() end) then
                modem = peripheral.find("modem", function(name, obj) return obj.isWireless() end)
                modemType = "Normal"
            elseif peripheral.find("ender_modem") then
                modem = peripheral.find("ender_modem")
                modemType = "Ender"
            end
        end

        local statusLabel = frame:addLabel()
        statusLabel:setPosition(2, 5)

        if not modem then
            statusLabel:setText(tr.gps_no_modems):setForeground(theme.offline)
            return
        else
            statusLabel:setText(tr.gps_modem_detected .. modemType):setForeground(theme.online)

            -- Activar modem si no esta activo
            if not modem.isOpen(65535) then
                modem.open(65535)
            end

            -- Buscar conexion GPS
            frame:addLabel()
                :setPosition(2, 6)
                :setText(tr.gps_searching)
                :setForeground(theme.info)

            local gpsLabel = frame:addLabel():setPosition(2, 7)

            while true do
                local position = gps.locate(5) -- Esperar hasta 5 segundos para obtener la posicion
                if position then
                    local x, y, z = gps.locate(5)
                    gpsLabel:setText(tr.gps_found .. "(" .. x .. ", " .. y .. ", " .. z .. ")")
                        :setForeground(theme.online)

                    -- Mostrar posicion del ordenador
                    frame:addLabel()
                        :setPosition(2, 8)
                        :setText(tr.gps_position .. "(" .. x .. ", " .. y .. ", " .. z .. ")")
                        :setForeground(theme.success)
                else
                    gpsLabel:setText(tr.gps_not_found):setForeground(theme.offline)
                end

                os.sleep(5) -- Esperar 5 segundos antes de intentar de nuevo
            end
        end
    end

    local function openGPSFrame(title, x, y, w, h)
        if gpsFrame then return end

        local modal = modalWindow.create(title or tr.gps_title, w or 40, h or 15, x, y)
        gpsFrame = modal.frame

        -- Añadir botón de detener al header
        modal.header:addButton()
            :setSize(10, 1)
            :setPosition("parent.w-10", 1)
            :setText(tr.btn_stop)
            :setBackground(theme.headerBG)
            :setForeground(theme.error)
            :onClick(function()
                if gpsThread then
                    gpsThread:stop()
                    gpsThread = nil
                    gpsFrame:addLabel()
                        :setPosition(2, 9)
                        :setText(tr.gps_connection_stopped)
                        :setForeground(theme.error)
                end
            end)

        -- Crear un hilo para ejecutar la deteccion y conexion en segundo plano
        gpsThread = gpsFrame:addThread()
        gpsThread:start(function()
            detectAndConnectGPS(gpsFrame)
        end)
    end

    return { openGPSFrame = openGPSFrame }
end

return { create = create }