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
    put stakeholder_url(id: stakeholders(:one).id, params: {
      id: stakeholders(:one).id,
      stakeholder: {
        usuario: {
          nombre: 'Patricio',
          apellido_paterno: 'Gomez',
          apellido_materno: 'Hernandez',
          email: 'patricio.gomez@algo.com'
        },
        grupo_id: grupos(:one).id
      }
      })
    assert_response 401
  end

  test "Debería obtener código '422' al tratar de obtener 'update' como estudiante" do
    put stakeholder_url(id: stakeholders(:one).id, params: {
      id: stakeholders(:one).id,
      stakeholder: {
        usuario: {
          nombre: 'Patricio',
          apellido_paterno: 'Gomez',
          apellido_materno: 'Hernandez',
          email: 'patricio.gomez@algo.com'
        },
        grupo_id: grupos(:one).id
      }
      }), headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response 422
  end

  test "Debería obtener código '422' al tratar de actualizar con 'update' como stakeholder" do
    put stakeholder_url(id: stakeholders(:one).id, params: {
      id: stakeholders(:one).id,
      stakeholder: {
        usuario: {
          nombre: 'Patricio',
          apellido_paterno: 'Gomez',
          apellido_materno: 'Hernandez',
          email: 'patricio.gomez@algo.com'
        },
        grupo_id: grupos(:one).id
      }
      }), headers: authenticated_header(usuarios(:stakeholder), 'cliente')
    assert_response 422
  end

  test "Debería poder actualizar los datos de un stakeholder como coordinador" do
    @stakeholder = stakeholders(:one)
    assert_difference 'Stakeholder.count', 0 do
      put stakeholder_url(id: stakeholders(:one).id, params: {
        id: stakeholders(:one).id,
        stakeholder: {
          usuario_attributes: {
            nombre: 'Patricio',
            apellido_paterno: 'Gomez',
            apellido_materno: 'Hernandez',
            email: 'patricio.gomez@algo.com'
          },
          grupo_id: grupos(:one).id
        }
        }), headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
      assert_response :success
    end
    @stakeholder.reload
    assert_equal @stakeholder.usuario.nombre, 'Patricio'
    assert_equal @stakeholder.usuario.apellido_paterno, 'Gomez'
    assert_equal @stakeholder.usuario.apellido_materno, 'Hernandez'
    assert_equal @stakeholder.usuario.email, 'patricio.gomez@algo.com'
    assert_equal @stakeholder.iniciales, 'PGH'
  end

  test "Debería poder actualizar los datos de un stakeholder como profesor" do
    @stakeholder = stakeholders(:two)
    assert_difference 'Stakeholder.count', 0 do
      put stakeholder_url(id: stakeholders(:two).id, params: {
        id: stakeholders(:two).id,
        stakeholder: {
          usuario_attributes: {
            nombre: 'Nelson',
            apellido_paterno: 'Poblete',
            apellido_materno: 'Torres',
            email: 'nelson.poblete@algo.com'
          },
          grupo_id: 0
        }
        }), headers: authenticated_header(usuarios(:profesor), 'profe')
      assert_response :success
    end
    @stakeholder.reload
    assert_equal @stakeholder.usuario.nombre, 'Nelson'
    assert_equal @stakeholder.usuario.apellido_paterno, 'Poblete'
    assert_equal @stakeholder.usuario.apellido_materno, 'Torres'
    assert_equal @stakeholder.usuario.email, 'nelson.poblete@algo.com'
    assert_equal @stakeholder.iniciales, 'NPT'
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
