local function create(mainFrame, theme, menuUsers, menuMain, usuarios, guardarUsuarios)
  -- Cargar traducciones
  local tr = require("translations")

  local initialFrame = mainFrame:addScrollableFrame()
  initialFrame:setPosition(1, 1)
  initialFrame:setSize("parent.w", "parent.h")
  initialFrame:setBackground(theme.background)

  -- Configuracion para ocultar el cursor
  term.setCursorBlink(false)

  -- Titulo con tamano doble
  local titleLabel = initialFrame:addLabel()
  titleLabel:setText(tr.title)
  titleLabel:setForeground(theme.title)
  titleLabel:setSize("parent.w", 2) -- Doble tamano
  titleLabel:setPosition(math.floor(initialFrame:getSize() / 2 - 4), 2)

  -- Version justo debajo del titulo
  local versionLabel = initialFrame:addLabel()
  versionLabel:setText(tr.version)
  versionLabel:setForeground(theme.version)
  versionLabel:setPosition(math.floor(initialFrame:getSize() / 2 - 1), 4) -- Justo debajo del titulo

  -- Botones
  local buttonFrame = initialFrame:addFrame()
  buttonFrame:setSize(24, 24)
  buttonFrame:setPosition(math.floor(initialFrame:getSize() / 2 - 12), 8)
  buttonFrame:setBackground(theme.background)

  local function createButton(text, y, callback)
      local button = buttonFrame:addButton()
      button:setText(text)
      button:setSize(20, 3)
      button:setPosition(2, y)
      button:setBackground(theme.buttonBG)
      button:setForeground(theme.buttonFG)
      button:setBorder(theme.borderNormal) -- Usar borde del tema
      button:onClick(callback)
      return button
  end

  createButton(tr.btn_login, 1, function()
      initialFrame:remove()
      -- Verificar y llamar a la funcion correspondiente
      if menuUsers and menuUsers.createLoginMenu then
          menuUsers.createLoginMenu(mainFrame, theme, usuarios, guardarUsuarios, create)
      else
          error(tr.sys_error_login_function)
      end
  end)

  createButton(tr.btn_create_user, 7, function()
      initialFrame:remove()
      -- Verificar y llamar a la funcion correspondiente
      if menuUsers and menuUsers.createUserMenu then
          menuUsers.createUserMenu(mainFrame, theme, usuarios, guardarUsuarios, create)
      else
          error(tr.sys_error_user_function)
      end
  end)

  createButton(tr.btn_settings, 13, function()
      print("Configuracion no implementado.")
  end)
end

return { create = create }