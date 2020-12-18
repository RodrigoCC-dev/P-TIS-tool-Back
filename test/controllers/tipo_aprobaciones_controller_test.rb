require 'test_helper'

class TipoAprobacionesControllerTest < ActionDispatch::IntegrationTest

  # Revision del servicio 'index' que entrega los tipos de aprobaciones

  test "Debería obtener código '401' al tratar de obtener tipos de aprobaciones sin autenticación" do
    get tipo_aprobaciones_url
    assert_response 401
  end

  test "Debería poder obtener los tipos de aprobaciones" do
    get tipo_aprobaciones_url, headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end
end
