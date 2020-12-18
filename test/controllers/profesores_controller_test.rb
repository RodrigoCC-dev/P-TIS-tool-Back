require 'test_helper'

class ProfesoresControllerTest < ActionDispatch::IntegrationTest

  # Revisión del funcionamiento del servicio index

  test "Debería obtener código 401 al tratar de obtener index sin autenticación" do
    get profesores_url
    assert_response 401
  end

  test "Debería obtener la lista de profesores en el sistema" do
    get profesores_url, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end


  # Revisión del funcionamiento del servicio create

  test "Debería obtener código 401 al tratar de crear un profesor sin autenticación" do
    assert_difference 'Profesor.count', 0 do
      post profesores_url(params: {
        usuario_attributes: {
          nombre: 'Manuel',
          apellido_paterno: 'Negrete',
          apellido_materno: 'Poblete',
          email: 'manuel.negrete@gmail.com'
        }
      })
    end
    assert_response 401
  end

  test "Debería poder crear un profesor" do
    assert_difference 'Profesor.count', 1 do
      post profesores_url(params: { profesor: {
        usuario_attributes: {
          nombre: 'Manuel',
          apellido_paterno: 'Negrete',
          apellido_materno: 'Poblete',
          email: 'manuel.negrete@gmail.com'
        }}
      }), headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    end
    assert_response :success
  end
end
