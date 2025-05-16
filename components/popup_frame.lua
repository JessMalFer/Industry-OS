local basalt = require("basalt")

return function(parent, theme, title, width, height, x, y)
    -- Valores por defecto
    width = width or 45
    height = height or 22
    x = x or math.random(5, 15)
    y = y or math.random(5, 10)

    -- Crear ventana emergente base
    local popupFrame = parent:addMovableFrame()
        :setSize(width, height)
        :setPosition(x, y)
        :setBackground(theme.background)
        :setBorder(theme.borderMovable)

    -- Cabecera
    local headerFrame = popupFrame:addFrame()
        :setSize(width, 1)
        :setPosition(1, 1)
        :setBackground(theme.headerBG)

    -- Título
    headerFrame:addLabel()
        :setSize(width-2, 1)
        :setBackground(theme.headerBG)
        :setForeground(theme.headerFG)
        :setText(title)

    -- Botón de cierre
    headerFrame:addButton()
        :setSize(1, 1)
        :setText("X")
        :setBackground(theme.headerBG)
        :setForeground(theme.error)
        :setPosition(width-1, 1)
        :onClick(function()
            popupFrame:remove()
        end)

    -- Área de contenido
    local contentFrame = popupFrame:addFrame()
        :setPosition(4, 3)
        :setSize(width-8, height-4)
        :setBackground(theme.background)

    -- Hacer la ventana redimensionable
    local function makeResizeable(frame, minW, minH, maxW, maxH)
        local btn = frame:addButton()
            :setPosition(frame:getWidth()-1, frame:getHeight()-1)
            :setSize(1, 1)
            :setText("/")
            :setForeground(colors.blue)
            :setBackground(theme.background)
            :onDrag(function(self, event, btn, xOffset, yOffset)
                local w, h = frame:getSize()
                local newW = math.min(math.max(w+xOffset-1, minW or 30), maxW or 80)
                local newH = math.min(math.max(h+yOffset-1, minH or 15), maxH or 50)

                frame:setSize(newW, newH)
                self:setPosition(newW-1, newH-1)
                headerFrame:setSize(newW, 1)
                contentFrame:setSize(newW-8, newH-4)
            end)
    end

    makeResizeable(popupFrame, 45, 22, 80, 50)

    -- Asegurar que el popup está visible
    popupFrame:show()

    -- Retornar frames relevantes para manipulación externa
    return {
        frame = popupFrame,
        content = contentFrame,
        header = headerFrame,
        remove = function()
            popupFrame:remove()
        end
    }
end