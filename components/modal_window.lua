local function create(mainFrame, theme, tr)
    local function createModal(title, width, height, x, y)
        local modal = mainFrame:addMovableFrame()
            :setSize(width or 40, height or 15)
            :setPosition(x or math.random(2, 12), y or math.random(2, 8))
            :setBackground(theme.background)
            :setBorder(theme.borderMovable)

        -- Header
        local header = modal:addFrame()
            :setSize("parent.w", 1)
            :setPosition(1, 1)
            :setBackground(theme.headerBG)

        -- Title
        header:addLabel()
            :setSize("parent.w-10", 1)
            :setBackground(theme.headerBG)
            :setForeground(theme.headerFG)
            :setText(title)

        -- Close button
        header:addButton()
            :setSize(1, 1)
            :setText("X")
            :setBackground(theme.headerBG)
            :setForeground(theme.error)
            :setPosition("parent.w-1", 1)
            :onClick(function()
                modal:remove()
            end)

        return {
            frame = modal,
            header = header,
            remove = function()
                modal:remove()
            end
        }
    end

    return { create = createModal }
end

return { create = create }
