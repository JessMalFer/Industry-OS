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

-- URLs base (reemplazar con tu repositorio)
local baseURL = "https://raw.githubusercontent.com/JessMalFer/Industry-OS/main/"

-- Archivos principales
local files = {
    ["startup.lua"] = baseURL .. "startup.lua",
    ["screens/menu_initial.lua"] = baseURL .. "screens/menu_initial.lua",
    ["screens/menu_users.lua"] = baseURL .. "screens/menu_users.lua",
    ["screens/menu_main.lua"] = baseURL .. "screens/menu_main.lua",
    -- ...resto de archivos...
}

print("Instalando SPACE OS...")
print("=====================")

-- Descargar Basalt si no existe
if not fs.exists("basalt") then
    print("Instalando Basalt...")
    shell.run("wget run https://raw.githubusercontent.com/Pyroxenium/Basalt/master/docs/install.lua source")
end

-- Crear directorios necesarios
fs.makeDir("screens")
fs.makeDir("components")

-- Descargar archivos
for path, url in pairs(files) do
    print("Descargando " .. path .. "...")
    if download(url, path) then
        print("✓ OK")
    else
        printError("× Error descargando " .. path)
        return
    end
end

print("\nInstalación completada!")
print("Reinicia el ordenador para iniciar SPACE OS")
