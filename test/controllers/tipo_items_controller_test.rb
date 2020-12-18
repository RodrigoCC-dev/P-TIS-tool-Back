require 'test_helper'

class TipoItemsControllerTest < ActionDispatch::IntegrationTest

  # Revision del servicio 'index' que entrega los tipos de items

  test "Debería obtener código '401' al tratar de obtener tipos de items sin autenticación" do
    get tipo_items_url
    assert_response 401
  end

  test "Debería poder obtener los tipos de items" do
    get tipo_items_url, headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end
end
