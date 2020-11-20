require 'test_helper'

class MotivosControllerTest < ActionDispatch::IntegrationTest

  # Revisión del servicion 'index' que entrega los motivos disponibles

  test "Debería obtener código '401' al tratar de obtener motivos sin autenticación" do
    get motivos_url
    assert_response 401
  end

  test "Debería poder obtener los motivos de emisión como 'estudiante'" do
    get motivos_url, headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end
end
