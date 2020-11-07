require 'test_helper'

class UsuariosControllerTest < ActionDispatch::IntegrationTest

  # Revisión del servicio 'user'

  test "Debería poder obtener la información del usuario 'coordinador'" do
    get login_user_url, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end

  test "Debería poder obtener la información del usuario 'profesor'" do
    get login_user_url, headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response :success
  end
end
