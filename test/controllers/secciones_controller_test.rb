require 'test_helper'

class SeccionesControllerTest < ActionDispatch::IntegrationTest

  # Revisión del servicio 'index'

  test "Debería poder obtener las secciones asignadas como 'coordinador'" do
    get secciones_url, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end

  test "Debería poder obtener las secciones asignadas como 'profesor'" do
    get secciones_url, headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response :success
  end
end
