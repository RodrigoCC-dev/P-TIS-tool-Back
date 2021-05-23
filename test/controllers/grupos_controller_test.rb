require 'test_helper'

class GruposControllerTest < ActionDispatch::IntegrationTest

  # Revisión del servicio 'index' que entrega listado de grupos

  test "Debería obtener código '401' al tratar de obtener 'index' sin autenticación" do
    get grupos_url
    assert_response 401
  end

  test "Debería poder obtener listado de grupos como 'coordinador'" do
    get grupos_url, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end

  test "Debería poder obtener listado de grupos como 'profesor'" do
    get grupos_url, headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response :success
  end


  # Revisión del servicio de creación de grupos

  test "Debería obtener código '401' al postear 'create' sin autenticación" do
    post '/grupos', params: {grupo: {
      nombre: 'G01',
      proyecto: 'Sistema de conteo de votos',
      correlativo: 1,
    },
    estudiantes: [estudiantes(:one).id, estudiantes(:two).id]
    }
    assert_response 401
  end

  test "Debería poder crear grupos como usuario 'coordinador'" do
    assert_difference 'Grupo.count', 1 do
      post '/grupos', params: {grupo: {
        nombre: 'G01',
        proyecto: 'Sistema de conteo de votos',
        correlativo: 1,
      },
      estudiantes: [estudiantes(:one).id, estudiantes(:two).id]
      }, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    end
    assert_response :success
  end

  test "Debería poder crear grupos como usuario 'profesor'" do
    assert_difference 'Grupo.count', 1 do
      post '/grupos', params: {grupo: {
        nombre: 'G02',
        proyecto: 'Sistema de asistencia general',
        correlativo: 2
      },
      estudiantes: [estudiantes(:two).id, estudiantes(:uno).id]
      }, headers: authenticated_header(usuarios(:profesor), 'profe')
    end
    assert_response :success
  end

  test "Debería obtener código 422 al tratar crear grupos con información no válida como usuario 'coordinador'" do
    assert_difference 'Grupo.count', 0 do
      post '/grupos', params: {grupo: {
        nombre: 'A22',
        proyecto: 'Sistema de conteo de votos',
        correlativo: 0,
      },
      estudiantes: [estudiantes(:one).id, estudiantes(:two).id]
      }, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    end
    assert_response 422
  end

  test "Debería obtener código 422 al tratar crear grupos con información no válida como usuario 'profesor'" do
    assert_difference 'Grupo.count', 0 do
      post '/grupos', params: {grupo: {
        nombre: 'B33',
        proyecto: 'Sistema de asistencia general',
        correlativo: -2
      },
      estudiantes: [estudiantes(:two).id, estudiantes(:uno).id]
      }, headers: authenticated_header(usuarios(:profesor), 'profe')
    end
    assert_response 422
  end


  # Revision del funcionamiento del servicio 'show'

  test "Debería obtener código '401' al tratar de obtener integrantes de un grupo sin autenticación" do
    get grupos_url(id: grupos(:one).id)
    assert_response 401
  end

  test "Debería poder obtener los integrantes de un grupo" do
    get grupos_url(id: grupos(:one).id), headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end


  # Revisión del funcionamiento del servicio 'destroy'

  test "Debería obtener código '401' al tratar de borrar un grupo sin autenticación" do
    delete grupo_url(id: grupos(:one).id)
    assert_response 401
  end

  test "Debería poder borrar un grupo como coordinador" do
    @grupo = grupos(:two)
    delete grupo_url(id: @grupo.id), headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    @grupo.reload
    assert_equal @grupo.estudiantes.size, 0
    assert_equal @grupo.stakeholders.size, 0
    assert_equal @grupo.borrado, true
    assert_response :success
  end

  test "Debería poder borrar un grupo como profesor" do
    @grupo = grupos(:two)
    delete grupo_url(id: @grupo.id), headers: authenticated_header(usuarios(:profesor), 'profe')
    @grupo.reload
    assert_equal @grupo.estudiantes.size, 0
    assert_equal @grupo.stakeholders.size, 0
    assert_equal @grupo.borrado, true
    assert_response :success
  end


  # Revisión del funcionamiento del servicio 'update'

  test "Debería obtener código '401' al tratar de actualizar un grupo sin autenticación" do
    patch grupo_url(id: grupos(:one).id)
    assert_response 401
  end

  test "Debería poder actualizar un grupo como coordinador" do
    @grupo = grupos(:one)
    assert_difference 'Grupo.count', 0 do
      patch grupo_url(id: grupos(:one).id), params: {
        grupo: {
          nombre: 'G01',
          proyecto: 'Esto es una prueba',
          correlativo: 1
        },
        estudiantes: [
          estudiantes(:one).id,
          estudiantes(:two).id,
          estudiantes(:three).id
        ]
      }, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
      assert_response :success
    end
    @grupo.reload
    assert_equal @grupo.nombre, 'G01'
    assert_equal @grupo.proyecto, 'Esto es una prueba'
    assert_equal @grupo.correlativo, 1
    assert_equal @grupo.estudiantes.size, 3
  end

  test "Debería poder actualizar un grupo como profesor" do
    @grupo = grupos(:two)
    assert_difference 'Grupo.count', 0 do
      patch grupo_url(id: grupos(:two).id), params: {
        grupo: {
          nombre: 'G02',
          proyecto: 'Esto es una prueba',
          correlativo: 2
        },
        estudiantes: [
          estudiantes(:four).id,
          estudiantes(:uno).id,
          estudiantes(:dos).id
        ]
      }, headers: authenticated_header(usuarios(:profesor), 'profe')
      assert_response :success
    end
    @grupo.reload
    assert_equal @grupo.nombre, 'G02'
    assert_equal @grupo.proyecto, 'Esto es una prueba'
    assert_equal @grupo.correlativo, 2
    assert_equal @grupo.estudiantes.size, 3
  end

  test "Debería obtener un error al tratar de actualizar un grupo con datos inválidos como coordinador" do
    patch grupo_url(id: grupos(:one).id), params: {
      grupo: {
        nombre: 'MAB1345',
        proyecto: 'Esto será un error',
        correlativo: 1
      },
      estudiantes: [
        estudiantes(:one).id,
        estudiantes(:two).id,
        estudiantes(:three).id
      ]
    }, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response 422
  end

  test "Debería obtener un error al tratar de actualizar un grupo con datos inválidos como profesor" do
    patch grupo_url(id: grupos(:two).id), params: {
      grupo: {
        nombre: 'f9345as',
        proyecto: 'Esto es una prueba con error',
        correlativo: 2
      },
      estudiantes: [
        estudiantes(:four).id,
        estudiantes(:uno).id,
        estudiantes(:dos).id
      ]
    }, headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response 422
  end

  test "Debería recibir código '422' al tratar de actualizar un grupo como estudiante" do
    patch grupo_url(id: grupos(:one).id), params: {
      grupo: {
        nombre: 'G03',
        proyecto: 'Esto es una prueba que no resulta',
        correlativo: 3
      },
      estudiantes: [
        estudiantes(:one).id,
        estudiantes(:two).id,
        estudiantes(:three).id
      ]
    }, headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response 422
  end

  test "Debería recibir código '422' al tratar de actualizar un grupo como stakeholder" do
    patch grupo_url(id: grupos(:two).id), params: {
      grupo: {
        nombre: 'G04',
        proyecto: 'Esto es una prueba que no resulta',
        correlativo: 4
      },
      estudiantes: [
        estudiantes(:four).id,
        estudiantes(:uno).id,
        estudiantes(:dos).id
      ]
    }, headers: authenticated_header(usuarios(:stakeholder), 'cliente')
    assert_response 422
  end

  # Revisión de funcionamiento del servicio 'ultimo_grupo'

  test "Debería obtener código '401' al postear 'ultimo_grupo' sin autenticación" do
    post grupos_ultimo_grupo_url, params: {
      jornada: jornadas(:one).nombre
    }
    assert_response 401
  end

  test "Debería poder obtener último grupo como 'coordinador'" do
    post grupos_ultimo_grupo_url, params: {
      jornada: jornadas(:one).nombre
    }, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end

  test "Debería poder obtener último grupo como 'profesor'" do
    post grupos_ultimo_grupo_url, params: {
      jornada: jornadas(:two).nombre
    }, headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response :success
  end
end
