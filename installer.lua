-- Instalador de SPACE OS
-- Versión: 1.0.0

-- URLs y archivos necesarios
local baseURL = "https://raw.githubusercontent.com/JessMalFer/Industry-OS/main/"
local files = {
    ["startup.lua"] = "startup.lua",
    ["theme.lua"] = "theme.lua",
    ["translations.lua"] = "translations.lua",
    ["periph.lua"] = "periph.lua",
    ["components/modal_window.lua"] = "components/modal_window.lua",
    ["screens/menu_gps.lua"] = "screens/menu_gps.lua",
    ["screens/menu_initial.lua"] = "screens/menu_initial.lua",
    ["screens/menu_main.lua"] = "screens/menu_main.lua",
    ["screens/menu_periph.lua"] = "screens/menu_periph.lua",
    ["screens/menu_users.lua"] = "screens/menu_users.lua"
}

-- Función para descargar archivos
local function download(url, file)
    print("Descargando " .. file .. "...")
    local response = http.get(url)
    if response then
        local handle = fs.open(file, "w")
        handle.write(response.readAll())
        handle.close()
        response.close()
        print("✓ " .. file)
        return true
    end
    printError("× Error descargando " .. file)
    return false
end

-- Crear directorios necesarios
print("=== Instalando SPACE OS ===")
print("Creando directorios...")
fs.makeDir("components")
fs.makeDir("screens")

-- Instalar Basalt primero
if not fs.exists("basalt") then
    print("\nInstalando Basalt...")
    shell.run("wget run https://raw.githubusercontent.com/Pyroxenium/Basalt/master/docs/install.lua source")
end

-- Descargar archivos del proyecto
print("\nDescargando archivos...")
local allSuccess = true
for path, filename in pairs(files) do
    if not download(baseURL .. filename, path) then
        allSuccess = false
        break
    end
end

if allSuccess then
    print("\n¡Instalación completada!")
    print("Reinicia el ordenador para iniciar SPACE OS")
else
    printError("\nLa instalación no se completó correctamente")
    print("Por favor, verifica tu conexión e inténtalo de nuevo")
end
