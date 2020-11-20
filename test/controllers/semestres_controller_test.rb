require 'test_helper'

class SemestresControllerTest < ActionDispatch::IntegrationTest

  # Revisión del servicio 'index' que entrega la información del semestre actual

  test "Debería obtener código '401' al tratar de obtener semestre sin autenticación" do
    get semestres_url
    assert_response 401
  end

  test "Debería poder obtener la información del semestre actual" do
    get semestres_url, headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end
end
