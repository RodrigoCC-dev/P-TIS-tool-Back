require 'test_helper'

class StakeholdersControllerTest < ActionDispatch::IntegrationTest

  # Revisión del funcionamiento del servicio 'create'

  test "Debería obtener código '401' al tratar de postear 'create'" do
    post '/stakeholders', params: {stakeholder: {
      grupo_id: grupos(:one).id,
      usuario_attributes: {
        nombre: 'Edgardo',
        apellido_paterno: 'Venegas',
        apellido_materno: 'Contreras',
        email: 'edgardo.venegas@algo.com'
      }
    }}
    assert_response 401
  end

  test "Debería poder crear un nuevo stakeholder como coodinador" do
    assert_difference 'Stakeholder.count', 1 do
      post '/stakeholders', params: {stakeholder: {
        grupo_id: grupos(:one).id,
        usuario_attributes: {
          nombre: 'Edgardo',
          apellido_paterno: 'Venegas',
          apellido_materno: 'Contreras',
          email: 'edgardo.venegas@algo.com'
          }
        }
      }, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    end
    assert_response :success
  end

  test "Debería poder crear un nuevo stakeholder como profesor" do
    assert_difference 'Stakeholder.count', 1 do
      post '/stakeholders', params: {stakeholder: {
        grupo_id: grupos(:one).id,
        usuario_attributes: {
          nombre: 'Margarita',
          apellido_paterno: 'Gonzalez',
          apellido_materno: 'Soto',
          email: 'margarita.gonzales@algo.com'
          }
        }
      }, headers: authenticated_header(usuarios(:profesor), 'profe')
    end
    assert_response :success
  end

end
