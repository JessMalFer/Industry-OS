-- Este archivo reemplaza a main.lua y se ejecuta automaticamente al encender el ordenador

-- Ocultar el shell de CC: Tweaked y preparar la pantalla
term.clear()
term.setCursorPos(1, 1)
term.setCursorBlink(false)

-- Verificar e instalar Basalt si no esta disponible
if not fs.exists("basalt") then
    print("Basalt no esta instalado. Descargando...")
    shell.run("wget run https://raw.githubusercontent.com/Pyroxenium/Basalt/refs/heads/master/docs/install.lua source")
end

-- Cargar Basalt y dependencias básicas
local basalt = require("basalt")
local theme = require("theme")
local tr = require("translations")

-- Crear el frame principal
local mainFrame = basalt.createFrame()
mainFrame:setSize(term.getSize())
mainFrame:setBackground(theme.background)

-- Iniciar con el menú principal
local menuInitial = require("screens.menu_initial")
menuInitial.create(mainFrame, theme, nil, require("screens.menu_main"))

-- Iniciar Basalt
basalt.autoUpdate()
