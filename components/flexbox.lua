local basalt = require("basalt")

local Flexbox = {}

function Flexbox.create(parent, options)
    options = options or {}
    local gap = options.gap or 1
    local y = options.y or 1

    -- Crear contenedor principal con scroll horizontal
    local container = parent:addFrame()
        :setPosition(1, y)
        :setSize("parent.w", 3)
        :setBackground(options.background or colors.black)

    local buttons = {}
    local objects = {}
    local clickHandler = nil

    -- Evento de scroll personalizado
    container:onScroll(function(self, event, dir)
        local maxScroll = 0
        for _, v in pairs(objects) do
            local x = v:getX()
            local w = v:getWidth()
            maxScroll = x + w > maxScroll and x + w or maxScroll
        end
        local xOffset = self:getOffset()
        if (xOffset + dir >= 0) and (xOffset + dir <= maxScroll - self:getWidth()) then
            self:setOffset(xOffset + dir, 0)
        end
    end)

    local currentX = 1
    local function addButton(text)
        local index = #buttons + 1
        local button = container:addButton()
            :setText(text)
            :setPosition(currentX, 1)
            :setSize(#text + 4, 3)
            :setBackground(options.buttonBG)
            :setForeground(options.buttonFG)
            :setBorder(options.border)

        -- Añadir el manejador de click directamente al botón
        button:onClick(function()
            if clickHandler then
                clickHandler(button, index)
            end
        end)

        table.insert(objects, button)
        buttons[index] = {text = text, button = button}
        currentX = currentX + #text + 4 + gap
        return button
    end

    return {
        addButton = addButton,
        onClick = function(handler)
            clickHandler = handler
        end,
        getItem = function(index)
            return buttons[index]
        end
    }
end

return Flexbox