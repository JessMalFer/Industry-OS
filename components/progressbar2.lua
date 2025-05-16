local basalt = require("basalt")

return function(parent, x, y, width)
    local bar = parent:addFrame()
        :setPosition(x, y)
        :setSize(width, 1)
        :setBackground(colors.gray)

    local panes = {}
    local phaseWidth = math.floor(width / 5)
    local colorPhases = {colors.red, colors.orange, colors.yellow, colors.lime, colors.green}

    -- Crear los 5 panes de colores
    for i = 1, 5 do
        panes[i] = bar:addPane()
            :setPosition(1 + (i-1)*phaseWidth, 1)
            :setSize(0, 1)
            :setBackground(colorPhases[i])
    end

    -- Timer simple de 10 segundos
    local timer = bar:addTimer()
    timer:setTime(1)
    local progress = 0
    timer:onCall(function()
        progress = progress + 1
        local percent = progress / 10

        for i = 1, 5 do
            if progress >= i * 2 then
                panes[i]:setSize(phaseWidth, 1)
            elseif progress > (i-1) * 2 then
                local partialWidth = math.floor(phaseWidth * ((progress - (i-1)*2) / 2))
                panes[i]:setSize(partialWidth, 1)
            end
        end

        if progress >= 10 then timer:stop() end
    end)
    timer:start()

    return bar
end