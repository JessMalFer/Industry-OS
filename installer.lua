-- Instalador de SPACE OS
-- Descarga todos los archivos necesarios desde GitHub

local function download(url, file)
    local content = http.get(url)
    if content then
        local handle = fs.open(file, "w")
        handle.write(content.readAll())
        handle.close()
        content.close()
        return true
    end
    return false
end

-- Crear directorios
fs.makeDir("components")
fs.makeDir("screens")

-- URLs base (reemplazar con tu repositorio)
local baseURL = "https://raw.githubusercontent.com/TU_USUARIO/space-os/main/"

-- Archivos principales
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

print("Instalando SPACE OS...")
print("=====================")

-- Descargar Basalt si no existe
if not fs.exists("basalt") then
    print("Instalando Basalt...")
    shell.run("wget run https://raw.githubusercontent.com/Pyroxenium/Basalt/master/docs/install.lua source")
end

-- Descargar archivos
for _, file in ipairs(files) do
    print("Descargando " .. file .. "...")
    if download(baseURL .. file, file) then
        print("OK")
    else
        print("Error descargando " .. file)
        return
    end
end

print("\nInstalación completada!")
print("Reinicia el ordenador para iniciar SPACE OS")