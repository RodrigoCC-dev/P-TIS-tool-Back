require 'test_helper'

class JornadasControllerTest < ActionDispatch::IntegrationTest

  # Revisión del funcionamiento del servicio 'index'

  test "Debería obtener código '401' al tratar de obtener 'index' sin autenticación" do
    get jornadas_url
    assert_response 401
  end

  test "Debería obtener las jornadas como usuario coordiandor" do
    get jornadas_url, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end

  test "Debería obtener las jornadas como usuario profesor" do
    get jornadas_url, headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response :success
  end
end
