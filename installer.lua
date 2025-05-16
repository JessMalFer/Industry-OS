-- Instalador de SPACE OS desde GitHub

local baseURL = "https://raw.githubusercontent.com/JessMalFer/Industry-OS/main/"
local files = {
    "startup.lua",
    "theme.lua",
    "translations.lua",
    "periph.lua",
    "components/loading_screen.lua",
    "components/modal_window.lua",
    "screens/menu_gps.lua",
    "screens/menu_initial.lua",
    "screens/menu_users.lua"
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
        return true
    end
    return false
end

-- Crear directorios necesarios
print("Creando directorios...")
fs.makeDir("components")
fs.makeDir("screens")

-- Instalar Basalt si no existe
if not fs.exists("basalt") then
    print("Instalando Basalt...")
    shell.run("wget run https://raw.githubusercontent.com/Pyroxenium/Basalt/master/docs/install.lua source")
end

-- Descargar archivos del proyecto
print("Descargando archivos del proyecto...")
for _, file in ipairs(files) do
    if not download(baseURL .. file, file) then
        printError("Error descargando " .. file)
        return
    end
end

print("\n¡Instalación completada!")
print("Reinicia el ordenador para iniciar SPACE OS")
