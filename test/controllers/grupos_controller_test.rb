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
      estudiantes: [estudiantes(:two).id, estudiantes(:Pablo).id]
      }, headers: authenticated_header(usuarios(:profesor), 'profe')
    end
    assert_response :success
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
