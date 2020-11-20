require 'test_helper'

class TipoEstadosControllerTest < ActionDispatch::IntegrationTest

  # Revisión del servicion 'index' que entrega los tipos de estados de una minuta

  test "Debería obtener código '401' al tratar de obtener los tipos de estados sin autenticación" do
    get tipo_estados_url
    assert_response 401
  end

  test "Debería poder obtener los tipos de estado de una minuta" do
    get tipo_estados_url, headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end
end
