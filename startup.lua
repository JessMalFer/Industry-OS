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

-- Cargar Basalt
local basalt = require("basalt")

-- Cargar tema y traducciones
local theme = require("theme")
local tr = require("translations")

-- Crear el frame principal de Basalt
local mainFrame = basalt.createFrame()
mainFrame:setSize(term.getSize())
mainFrame:setBackground(theme.background)

-- Crear pantalla de carga
local loadingScreen = require("components.loading_screen").create(mainFrame, theme, tr)
loadingScreen:setStatus("Iniciando sistema...")
loadingScreen:setProgress(0)

-- Verificar e instalar Basalt si no está disponible
if not fs.exists("basalt") then
    loadingScreen:setStatus("Instalando Basalt...")
    shell.run("wget run https://raw.githubusercontent.com/Pyroxenium/Basalt/refs/heads/master/docs/install.lua source")
end
loadingScreen:setProgress(20)

-- Detectar el monitor y la GlassScreen sin redirigir la terminal
local monitor = peripheral.find("monitor")
local glassScreen = peripheral.find("GlassScreen")
if monitor then
    print("Monitor detectado. Se actualizara paralelamente.")
end
if glassScreen then
    print("GlassScreen detectada. Se actualizara paralelamente.")
end

-- Inicializar y cargar el gestor de perifericos
local peripheralManager = require("periph")
loadingScreen:setStatus("Detectando periféricos...")
peripheralManager.detect() -- Realizar una deteccion inicial
loadingScreen:setProgress(40)

-- Crear un hilo para la deteccion de perifericos
local periphThread = mainFrame:addThread()
periphThread:start(function()
    print("Iniciando deteccion de perifericos en segundo plano...")
    while true do
        peripheralManager.detect()
        os.sleep(5) -- Detectar perifericos cada 5 segundos
    end
end)

-- Cargar los módulos con las rutas correctas
loadingScreen:setStatus("Cargando módulos...")
local menuInitial = require("screens.menu_initial")
local menuUsers = require("screens.menu_users")
local menuMain = require("screens.menu_main")
loadingScreen:setProgress(60)

-- Tamano de pantalla
local screenW, screenH = term.getSize()
local margin = 1

-- Archivo para guardar usuarios
local usuariosFile = "usuarios.txt"

-- Tabla para almacenar usuarios
local usuarios = {}

-- Funcion para cargar usuarios desde el archivo
local function cargarUsuarios()
    if fs.exists(usuariosFile) then
        local file = fs.open(usuariosFile, "r")
        local contenido = file.readAll()
        file.close()
        if contenido ~= "" then
            usuarios = textutils.unserialize(contenido) or {}
        end
    end
end

-- Funcion para guardar usuarios en el archivo
local function guardarUsuarios()
    local file = fs.open(usuariosFile, "w")
    file.write(textutils.serialize(usuarios))
    file.close()
end

-- Inicializar programa
loadingScreen:setStatus("Cargando datos de usuarios...")
cargarUsuarios()
loadingScreen:setProgress(80)

-- Aplicar tema global si es compatible con la version de Basalt
-- Si no funciona setTheme, se aplican estilos directamente a cada componente
if mainFrame.setTheme then
    mainFrame:setTheme({
        FrameBG = theme.background,
        FrameFG = theme.text,
        ButtonBG = theme.buttonBG,
        ButtonFG = theme.buttonFG,
        InputBG = theme.inputBG,
        InputFG = theme.inputFG
    })
end

-- Inicializar interfaz
loadingScreen:setStatus("Inicializando interfaz...")
loadingScreen:setProgress(100)

-- Pequeña pausa para mostrar que se completó
os.sleep(1)
loadingScreen:remove()

-- Mostrar el menu inicial
menuInitial.create(mainFrame, theme, menuUsers, menuMain, usuarios, guardarUsuarios)

-- Ejecutar Basalt
basalt.autoUpdate()
