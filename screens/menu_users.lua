local function createUserMenu(mainFrame, theme, usuarios, guardarUsuarios, menuInitial)
  -- Cargar traducciones
  local tr = require("translations")

  local userMenu = mainFrame:addScrollableFrame()
  userMenu:setPosition(1, 1)
  userMenu:setSize("parent.w", "parent.h")
  userMenu:setBackground(theme.background)

  -- Deshabilitar el cursor parpadeante
  term.setCursorBlink(false)

  -- Titulo reducido
  local smallTitle = userMenu:addLabel()
  smallTitle:setText(tr.title)
  smallTitle:setForeground(theme.title)
  smallTitle:setPosition(math.floor(mainFrame:getSize() / 2 - 4), 2)

  -- Etiquetas y campos de entrada
  local usernameLabel = userMenu:addLabel()
  usernameLabel:setText(tr.lbl_username)
  usernameLabel:setForeground(theme.text)
  usernameLabel:setPosition(3, 6)

  local usernameInput = userMenu:addInput()
  usernameInput:setSize(20, 1)
  usernameInput:setPosition(3, 7)
  usernameInput:setBackground(theme.inputBG)
  usernameInput:setForeground(theme.inputFG)
  usernameInput:setBorder(theme.borderNormal, "bottom") -- Borde inferior del tema

  local passwordLabel = userMenu:addLabel()
  passwordLabel:setText(tr.lbl_password)
  passwordLabel:setForeground(theme.text)
  passwordLabel:setPosition(3, 9)

  local passwordInput = userMenu:addInput()
  passwordInput:setSize(20, 1)
  passwordInput:setPosition(3, 10)
  passwordInput:setBackground(theme.inputBG)
  passwordInput:setForeground(theme.inputFG)
  passwordInput:setBorder(theme.borderNormal, "bottom") -- Borde inferior del tema

  -- Mensaje de error
  local errorMessage = userMenu:addLabel()
  errorMessage:setText("")
  errorMessage:setForeground(theme.error)
  errorMessage:setPosition(3, 12)

  -- Boton para crear usuario
  local createButton = userMenu:addButton()
  createButton:setText(tr.btn_create_user)
  createButton:setSize(20, 3)
  createButton:setPosition(3, 14)
  createButton:setBackground(theme.buttonBG)
  createButton:setForeground(theme.buttonFG)
  createButton:setBorder(theme.borderNormal) -- Borde del tema
  createButton:onClick(function()
      local username = usernameInput:getValue()
      local password = passwordInput:getValue()

      if username == "" or password == "" then
          errorMessage:setText(tr.msg_missing_fields)
      else
          -- Verificar si el usuario ya existe
          local usuarioExiste = false
          for _, usuario in ipairs(usuarios) do
              if usuario.nombre == username then
                  usuarioExiste = true
                  break
              end
          end

          if usuarioExiste then
              errorMessage:setText(tr.msg_user_exists)
          else
              table.insert(usuarios, {nombre = username, contrasena = password})
              guardarUsuarios()
              userMenu:remove()
              local menuMain = require("screens.menu_main")
              menuMain.create(mainFrame, theme)
          end
      end
  end)

  -- Boton para volver
  local returnButton = userMenu:addButton()
  returnButton:setText(tr.btn_back)
  returnButton:setSize(20, 3)
  returnButton:setPosition(3, 18)
  returnButton:setBackground(theme.buttonBG)
  returnButton:setForeground(theme.buttonFG)
  returnButton:setBorder(theme.borderNormal) -- Borde del tema
  returnButton:onClick(function()
      userMenu:remove()
      menuInitial(mainFrame, theme, nil, require("screens.menu_main"), usuarios, guardarUsuarios)
  end)
end

local function createLoginMenu(mainFrame, theme, usuarios, guardarUsuarios, menuInitial)
  -- Cargar traducciones
  local tr = require("translations")

  local loginMenu = mainFrame:addScrollableFrame()
  loginMenu:setPosition(1, 1)
  loginMenu:setSize("parent.w", "parent.h")
  loginMenu:setBackground(theme.background)

  -- Deshabilitar el cursor parpadeante
  term.setCursorBlink(false)

  -- Titulo reducido
  local smallTitle = loginMenu:addLabel()
  smallTitle:setText(tr.title)
  smallTitle:setForeground(theme.title)
  smallTitle:setPosition(math.floor(mainFrame:getSize() / 2 - 4), 2)

  -- Etiquetas y campos de entrada
  local usernameLabel = loginMenu:addLabel()
  usernameLabel:setText(tr.lbl_username)
  usernameLabel:setForeground(theme.text)
  usernameLabel:setPosition(3, 6)

  local usernameInput = loginMenu:addInput()
  usernameInput:setSize(20, 1)
  usernameInput:setPosition(3, 7)
  usernameInput:setBackground(theme.inputBG)
  usernameInput:setForeground(theme.inputFG)
  usernameInput:setBorder(theme.borderNormal, "bottom") -- Borde inferior del tema

  local passwordLabel = loginMenu:addLabel()
  passwordLabel:setText(tr.lbl_password)
  passwordLabel:setForeground(theme.text)
  passwordLabel:setPosition(3, 9)

  local passwordInput = loginMenu:addInput()
  passwordInput:setSize(20, 1)
  passwordInput:setPosition(3, 10)
  passwordInput:setBackground(theme.inputBG)
  passwordInput:setForeground(theme.inputFG)
  passwordInput:setBorder(theme.borderNormal, "bottom") -- Borde inferior del tema

  -- Mensaje de error
  local errorMessage = loginMenu:addLabel()
  errorMessage:setText("")
  errorMessage:setForeground(theme.error)
  errorMessage:setPosition(3, 12)

  -- Boton para iniciar sesion
  local loginButton = loginMenu:addButton()
  loginButton:setText(tr.btn_login)
  loginButton:setSize(20, 3)
  loginButton:setPosition(3, 14)
  loginButton:setBackground(theme.buttonBG)
  loginButton:setForeground(theme.buttonFG)
  loginButton:setBorder(theme.borderNormal) -- Borde del tema
  loginButton:onClick(function()
      local username = usernameInput:getValue()
      local password = passwordInput:getValue()
      local usuarioEncontrado = false

      for _, usuario in ipairs(usuarios) do
          if usuario.nombre == username then
              if usuario.contrasena == password then
                  usuarioEncontrado = true
              else
                  errorMessage:setText(tr.msg_invalid_credentials)
              end
              break
          end
      end

      if usuarioEncontrado then
          -- Mensaje de exito
          local successMessage = loginMenu:addLabel()
          successMessage:setText(tr.msg_login_success)
          successMessage:setForeground(theme.success)
          successMessage:setPosition(3, 12)

          -- Pequena pausa para mostrar el mensaje
          os.sleep(1)

          loginMenu:remove()
          local menuMain = require("screens.menu_main")
          menuMain.create(mainFrame, theme)
      else
          errorMessage:setText(tr.msg_invalid_credentials)
      end
  end)

  -- Boton para volver
  local returnButton = loginMenu:addButton()
  returnButton:setText(tr.btn_back)
  returnButton:setSize(20, 3)
  returnButton:setPosition(3, 18)
  returnButton:setBackground(theme.buttonBG)
  returnButton:setForeground(theme.buttonFG)
  returnButton:setBorder(theme.borderNormal) -- Borde del tema
  returnButton:onClick(function()
      loginMenu:remove()
      menuInitial(mainFrame, theme, nil, require("screens.menu_main"), usuarios, guardarUsuarios)
  end)
end

return {
    createUserMenu = createUserMenu,
    createLoginMenu = createLoginMenu
}
