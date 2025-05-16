local basalt = require("basalt")
local peripheralManager = require("periph")
local PopupFrame = require("components.popup_frame")

local function create(monitorFrame, theme)
    local tr = require("translations")
    local isVisible = false
    local objects = {}
    local currentPopup = nil

    -- Frame principal con scroll personalizado
    local periphFrame = monitorFrame:addFrame()
        :setSize(monitorFrame:getWidth(), monitorFrame:getHeight() - 5)
        :setPosition(1, 5)
        :setBackground(theme.background)
        :hide()
        :onScroll(function(self, event, dir)
            local maxScroll = 0
            for _, v in pairs(objects) do
                local y = v:getY()
                local h = v:getHeight()
                maxScroll = y + h > maxScroll and y + h or maxScroll
            end
            local _, yOffset = self:getOffset()
            if (yOffset + dir >= 0) and (yOffset + dir <= maxScroll - self:getHeight()) then
                self:setOffset(0, yOffset + dir)
            end
        end)

    -- Título
    local title = periphFrame:addLabel()
        :setPosition(3, 1)
        :setText(tr.periph_title)
        :setForeground(theme.title)
    table.insert(objects, title)

    -- Función auxiliar para crear botones
    local function createButton(text, yPos, onClickHandler)
        local button = periphFrame:addButton()
            :setPosition(3, yPos)
            :setSize(20, 3)
            :setText(text)
            :setBackground(theme.buttonBG)
            :setForeground(theme.buttonFG)
            :setBorder(theme.borderNormal)
            :onClick(onClickHandler)
        table.insert(objects, button)
        return button
    end

    -- Botones para gestionar periféricos
    createButton(tr.periph_monitors, 3)
    createButton(tr.periph_modems, 8)
    createButton(tr.periph_energy, 13)
    createButton(tr.btn_update, 18, function()
        peripheralManager.detect()
    end)

    -- Calcular altura total del contenido
    local totalHeight = 0
    for _, obj in pairs(objects) do
        local y = obj:getY()
        local h = obj:getHeight()
        totalHeight = math.max(totalHeight, y + h)
    end

    -- Handler de visibilidad
    local function toggleVisibility()
        if isVisible then
            periphFrame:hide()
            if currentPopup then currentPopup.remove() end
            isVisible = false
        else
            periphFrame:show()
            isVisible = true
        end
    end

    return {
        toggleVisibility = toggleVisibility
    }
end

return { create = create }
