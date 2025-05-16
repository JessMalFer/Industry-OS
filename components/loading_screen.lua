local function create(mainFrame, theme, tr)
    local loadingFrame = mainFrame:addFrame()
        :setPosition(1,1)
        :setSize("parent.w", "parent.h")
        :setBackground(theme.background)

    -- Panel con logo
    local logoPanel = loadingFrame:addPanel()
        :setPosition("parent.w/2-15", "parent.h/2-4")
        :setSize(30, 7)
        :setBackground(theme.background)
        :setText([[
     _____  ___   ___  ___ ___
    / ___/ / _ \ / _ \/ __| __|
    \__ \ | (_) | (_) \__ | _|
    |___/  \___/ \___/|___|___| OS
    ]])

    -- Barra de progreso
    local progressBar = loadingFrame:addProgressbar()
        :setPosition("parent.w/2-15", "parent.h/2+4")
        :setSize(30, 1)
        :setProgress(0)
        :setBackground(theme.background)
        :setProgressColor(theme.success)

    -- Texto de estado
    local statusLabel = loadingFrame:addLabel()
        :setPosition("parent.w/2-15", "parent.h/2+6")
        :setForeground(theme.text)
        :setText("")

    return {
        setProgress = function(progress)
            progressBar:setProgress(progress)
        end,
        setStatus = function(text)
            statusLabel:setText(text)
        end,
        hide = function()
            loadingFrame:hide()
        end,
        remove = function()
            loadingFrame:remove()
        end
    }
end

return { create = create }