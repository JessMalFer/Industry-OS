-- Theme.lua - Tema coherente para SPACE OS
-- Define los colores y estilos utilizados en todo el sistema

local theme = {
    -- Colores base del sistema
    background = colors.black,          -- Fondo principal
    text = colors.white,                -- Texto general
    title = colors.yellow,              -- Títulos
    version = colors.lightGray,         -- Versión

    -- Elementos interactivos
    buttonBG = colors.lightGray,        -- Fondo de botones
    buttonFG = colors.white,            -- Texto de botones
    inputBG = colors.black,             -- Fondo de campos de entrada
    inputFG = colors.white,             -- Texto de campos de entrada
    dropdownBG = colors.lightGray,      -- Fondo de elementos dropdown
    dropdownFG = colors.black,          -- Texto de elementos dropdown

    -- Menús y barras
    menubarBG = colors.gray,            -- Fondo de barra de menú
    menubarFG = colors.white,           -- Texto de barra de menú
    menubarSelectBG = colors.lightGray, -- Fondo de selección de barra de menú
    menubarSelectFG = colors.black,     -- Texto de selección de barra de menú

    -- Bordes según especificaciones
    borderNormal = colors.white,        -- Borde estándar (botones, inputs, etc.)
    borderMovable = colors.lime,        -- Borde para ventanas emergentes (MovableFrames)

    -- Estados y mensajes
    success = colors.green,             -- Mensajes de éxito
    error = colors.red,                 -- Mensajes de error
    warning = colors.orange,            -- Mensajes de advertencia
    info = colors.lightBlue,            -- Mensajes informativos

    -- Estados específicos
    shutdownFG = colors.red,            -- Color para botón/texto de apagado
    online = colors.green,              -- Dispositivos conectados
    offline = colors.red,               -- Dispositivos desconectados

    -- Headers y contenedores
    headerBG = colors.gray,             -- Fondo de encabezados
    headerFG = colors.white,            -- Texto de encabezados
    monitorFrame = colors.black,        -- Fondo de MonitorFrame
    secondaryBG = colors.gray,          -- Fondo secundario para paneles
}

-- Compatibilidad con versión anterior
-- En caso de que algún archivo use las propiedades originales
theme.border = theme.borderNormal

return theme
