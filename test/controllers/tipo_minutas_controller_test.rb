require 'test_helper'

class TipoMinutasControllerTest < ActionDispatch::IntegrationTest

  # Revisión del servicio 'index' que entrega los tipos de minutas en el sistema

  test "Debería obtener código '401' al tratar de obtener tipos de minuta sin autenticación" do
    get tipo_minutas_url
    assert_response 401
  end

  test "Debería poder obtener los tipos de minutas en el sistema" do
    get tipo_minutas_url, headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end
end
