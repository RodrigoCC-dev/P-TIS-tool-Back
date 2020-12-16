require 'test_helper'

class UsuariosControllerTest < ActionDispatch::IntegrationTest

  # Revisión del servicio 'user'

  test "Debería obtener código '401' al tratar de obtener info usuario sin autenticación" do
    get login_user_url
    assert_response 401
  end

  test "Debería poder obtener la información del usuario 'coordinador'" do
    get login_user_url, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end

  test "Debería poder obtener la información del usuario 'profesor'" do
    get login_user_url, headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response :success
  end


  # Revision del servicio update

  test "Debería obtener código '401' al tratar de actualizar la clave de acceso sin autenticación" do
    patch usuario_url(id: usuarios(:one).id), params: {
      password: 'abc',
      usuario: {
        password: 'abc',
        password_confirmation: 'abc'
      }
    }
    assert_response 401
  end

  test "Debería obtener código '422' al tratar de actualizar clave de acceso con usuario distinto" do
    patch usuario_url(id: usuarios(:two).id), params: {
      password: 'MyString',
      usuario: {
        password: 'abc',
        password_confirmation: 'abc'
      }
    }, headers: authenticated_header(usuarios(:one), 'MyString')
    assert_response 422
  end

  test "Debería obtener código '422' al tratar de actualizar clave de acceso con clave actual erronea" do
    patch usuario_url(id: usuarios(:one).id), params: {
      password: 'Prueba',
      usuario: {
        password: 'abc',
        password_confirmation: 'abc'
      }
    }, headers: authenticated_header(usuarios(:one), 'MyString')
    assert_response 422
  end

  test "Debería poder actualizar la clave de acceso de mi usuario" do
    patch usuario_url(id: usuarios(:one).id), params: {
      password: 'MyString',
      usuario: {
        password: 'abc',
        password_confirmation: 'abc'
      }
    }, headers: authenticated_header(usuarios(:one), 'MyString')
    assert_response :success
  end
end
