require 'test_helper'

class StakeholdersControllerTest < ActionDispatch::IntegrationTest

  # Revision del funcionamiento del servicio 'index'

  test "Debería obtener código '401' al tratar de obtener 'index' sin autenticación" do
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

  test "Debería poder obtener los stakeholders como estudiante" do
    get stakeholders_url, headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end

  test "Debería poder obtener los stakeholders como stakeholder" do
    get stakeholders_url, headers: authenticated_header(usuarios(:stakeholder), 'cliente')
    assert_response :success
  end

  # Revisión del funcionamiento del servicio 'create'

  test "Debería obtener código '401' al tratar de postear 'create'" do
    post '/stakeholders', params: {stakeholder: {
      usuario_attributes: {
        nombre: 'Edgardo',
        apellido_paterno: 'Venegas',
        apellido_materno: 'Contreras',
        email: 'edgardo.venegas@algo.com'
        }
      },
    grupo: {
      id: grupos(:one).id
    }}
    assert_response 401
  end

  test "Debería poder crear un nuevo stakeholder como coodinador" do
    assert_difference 'Stakeholder.count', 1 do
      post '/stakeholders', params: {stakeholder: {
        usuario_attributes: {
          nombre: 'Edgardo',
          apellido_paterno: 'Venegas',
          apellido_materno: 'Contreras',
          email: 'edgardo.venegas@algo.com'
          }
        },
        grupo: {
          id: grupos(:one).id
        }
      }, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    end
    assert_response :success
  end

  test "Debería poder crear un nuevo stakeholder como profesor" do
    assert_difference 'Stakeholder.count', 1 do
      post '/stakeholders', params: {stakeholder: {
        usuario_attributes: {
          nombre: 'Margarita',
          apellido_paterno: 'Gonzalez',
          apellido_materno: 'Soto',
          email: 'margarita.gonzales@algo.com'
          }
        },
        grupo: {
          id: grupos(:one).id
        }
      }, headers: authenticated_header(usuarios(:profesor), 'profe')
    end
    assert_response :success
  end


  # Revision del funcionamiento del servicio 'show'

  test "Debería obtener código '401' al tratar de obtener 'show' sin autenticación" do
    get stakeholder_url(id: usuarios(:stakeholder).id)
    assert_response 401
  end

  test "Debería poder obtener la información de un stakeholder" do
    get stakeholder_url(id: usuarios(:stakeholder).id), headers: authenticated_header(usuarios(:stakeholder), 'cliente')
    assert_response :success
  end


  # Revisión del funcionamiento del servicio 'update'

  test "Debería obtener código '401' al tratar de obtener 'update' sin autenticación" do
    put stakeholder_url(id: grupos(:one).id, params: {
      id: grupos(:one).id,
      stakeholders: [stakeholders(:two).id]
      })
    assert_response 401
  end

  test "Debería poder cambiar la asignación de stakeholders a un grupo como coordinador" do
    @stakeholder1 = stakeholders(:one)
    @stakeholder2 = stakeholders(:two)
    @grupo = grupos(:one)
    put stakeholder_url(id: grupos(:one).id, params: {
      id: grupos(:one).id,
      stakeholders: [stakeholders(:two).id, stakeholders(:Gabriela).id]
      }), headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    @stakeholder1.reload
    @stakeholder2.reload
    @grupo.reload
    assert_equal @grupo.stakeholders.size, 2
    assert @grupo.stakeholders.include?(stakeholders(:two))
    assert @grupo.stakeholders.include?(stakeholders(:Gabriela))
    assert_equal @stakeholder1.grupos, []
    assert_equal @stakeholder1.grupos.size, 0
    assert_equal @stakeholder2.grupos.size, 2
    assert @stakeholder2.grupos.include?(grupos(:two))
    assert @stakeholder2.grupos.include?(grupos(:one))
    assert_response :success
  end

  test "Debería obtener código 422 al tratar quitar la asignación de stakeholders a un grupo como coordinador" do
    @stakeholder = stakeholders(:two)
    @grupo = grupos(:two)
    put stakeholder_url(id: grupos(:two).id, params: {
      id: grupos(:two).id,
      stakeholders: []
      }), headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    @stakeholder.reload
    @grupo.reload
    assert_not_equal @grupo.stakeholders.size, 0
    assert @stakeholder.grupos.include?(grupos(:two))
    assert_equal @stakeholder.grupos.size, 1
    assert_response 422
  end

  test "Debería poder cambiar la asignación de stakeholders a un grupo como profesor" do
    @stakeholder1 = stakeholders(:one)
    @stakeholder2 = stakeholders(:two)
    @grupo = grupos(:one)
    put stakeholder_url(id: grupos(:one).id, params: {
      id: grupos(:one).id,
      stakeholders: [stakeholders(:two).id, stakeholders(:Gabriela).id]
      }), headers: authenticated_header(usuarios(:profesor), 'profe')
    @stakeholder1.reload
    @stakeholder2.reload
    @grupo.reload
    assert_equal @grupo.stakeholders.size, 2
    assert @grupo.stakeholders.include?(stakeholders(:two))
    assert @grupo.stakeholders.include?(stakeholders(:Gabriela))
    assert_equal @stakeholder1.grupos, []
    assert_equal @stakeholder1.grupos.size, 0
    assert_equal @stakeholder2.grupos.size, 2
    assert @stakeholder2.grupos.include?(grupos(:two))
    assert @stakeholder2.grupos.include?(grupos(:one))
    assert_response :success
  end

  test "Debería obtener código 422 al tratar quitar la asignación de stakeholders a un grupo como profesor" do
    @stakeholder = stakeholders(:two)
    @grupo = grupos(:two)
    put stakeholder_url(id: grupos(:two).id, params: {
      id: grupos(:two).id,
      stakeholders: []
      }), headers: authenticated_header(usuarios(:profesor), 'profe')
    @stakeholder.reload
    @grupo.reload
    assert_not_equal @grupo.stakeholders.size, 0
    assert @stakeholder.grupos.include?(grupos(:two))
    assert_equal @stakeholder.grupos.size, 1
    assert_response 422
  end


  # Revisión del funcionamiento del servicio 'por_jornada'

  test "Debería obtener código '401' al tratar de obtener 'por_jornada' sin autenticación" do
    get stakeholders_asignacion_grupos_url
    assert_response 401
  end

  test "Debería poder obtener los stakeholders asignados como coordinador" do
    get stakeholders_asignacion_grupos_url, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end

  test "Debería poder obtener los stakeholders asignados como profesor" do
    get stakeholders_asignacion_grupos_url, headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response :success
  end

end
