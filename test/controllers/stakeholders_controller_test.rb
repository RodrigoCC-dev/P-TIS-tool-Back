require 'test_helper'

class StakeholdersControllerTest < ActionDispatch::IntegrationTest

  # Revision del funcionamiento del servicio 'index'

  test "Debería obtener código '401' al tratra de obtener 'index' sin autenticación" do
    get stakeholders_url
    assert_response 401
  end

  test "Debería poder obtener los stakeholders como coordinador" do
    get stakeholders_url, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end

  test "Debería poder obtener los stakeholders como profesor" do
    get stakeholders_url, headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response :success
  end


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
