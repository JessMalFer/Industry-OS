-- translations.lua
-- Archivo centralizado de traducciones para SPACE OS
-- Facilita la traduccion a otros idiomas en el futuro

local translations = {
  -- Textos generales
  title = "SPACE OS",
  version = "v1.0",

  -- Botones principales
  btn_login = "INICIAR SESION",
  btn_create_user = "CREAR USUARIO",
  btn_settings = "CONFIGURACION",
  btn_back = "VOLVER",
  btn_update = "ACTUALIZAR",
  btn_stop = "DETENER",
  btn_save = "GUARDAR",
  btn_delete = "ELIMINAR",
  btn_close = "CERRAR",

  -- Etiquetas del login/registro
  lbl_username = "Nombre de usuario:",
  lbl_password = "Clave:",

  -- Mensajes
  msg_missing_fields = "Faltan campos por completar",
  msg_user_exists = "El usuario ya existe",
  msg_invalid_credentials = "Usuario o clave incorrecta",
  msg_login_success = "Inicio de sesion exitoso",

  -- Menu principal
  menu_home = "Inicio",
  menu_peripherals = "Perifericos",
  menu_energy = "Energia",
  menu_gps = "GPS",
  menu_shutdown = "Apagar",

  -- Perifericos
  periph_title = "PERIFERICOS DETECTADOS",
  periph_monitors = "Monitores",
  periph_modems = "Modems",
  periph_energy = "Energia",
  periph_modems_connected = "Hay modems conectados",
  periph_no_modems = "No se detectaron modems",
  periph_manage_monitor = "Gestion de Monitores",
  periph_manage_modem = "Gestion de Modems",
  periph_manage_energy = "Gestion de Energia",
  periph_tech_id = "ID Tecnico:",  -- Nueva traducción
  periph_name = "Nombre:",
  periph_type = "Tipo:",
  periph_id = "ID:",
  periph_status = "Estado:",
  periph_status_connected = "Conectado",
  periph_status_disconnected = "Desconectado",
  periph_name_placeholder = "Introduce un nombre personalizado",  -- Nueva traducción
  periph_id_placeholder = "Introduce un ID personalizado",
  periph_delete_confirm = "¿Eliminar este periferico?",
  periph_delete_success = "Periferico eliminado",
  periph_name_updated = "Nombre actualizado",  -- Nueva traducción
  periph_id_updated = "ID actualizado",
  periph_select = "Seleccionar periferico",
  periph_none = "Ningun periferico disponible",
  periph_vendor = "Proveedor:",
  periph_voidpower = "VoidPower",
  periph_type_monitor = "Monitor",
  periph_type_modem = "Modem",
  periph_type_glassscreen = "GlassScreen",
  periph_updating = "Actualizando perifericos...",
  periph_custom_id = "ID:",
  
  -- GPS
  gps_title = "GPS Tracker",
  gps_info = "Informacion del GPS...",
  gps_detecting_modems = "Detectando modems inalambricos...",
  gps_no_modems = "No hay modems inalambricos detectados.",
  gps_modem_detected = "Modem detectado: ",
  gps_searching = "Buscando conexion GPS...",
  gps_found = "GPS encontrado: ",
  gps_not_found = "No se encontro senal GPS.",
  gps_position = "Posicion del ordenador: ",
  gps_connection_stopped = "Conexion GPS detenida.",

  -- Sistema
  sys_error_login_function = "Error: La funcion 'createLoginMenu' no esta definida en menuUsers.",
  sys_error_user_function = "Error: La funcion 'createUserMenu' no esta definida en menuUsers.",
}

return translations
