require 'test_helper'

class TipoAsistenciasControllerTest < ActionDispatch::IntegrationTest

  # Revisión del servicio 'index' que entrega los tipos de asistencia

  test "Debería obtener código '401' al trtar de obtener tipos de asisntecia sin autenticación" do
    get tipo_asistencias_url
    assert_response 401
  end

  test "Debería poder obtener los tipos de asistencia como 'usuario'" do
    get tipo_asistencias_url, headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end
end
