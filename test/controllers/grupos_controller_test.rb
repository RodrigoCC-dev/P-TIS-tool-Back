require 'test_helper'

class GruposControllerTest < ActionDispatch::IntegrationTest

  # Revisión del servicio 'index' que entrega listado de grupos

  test "Debería poder obtener listado de grupos como 'coordinador'" do
    get grupos_url, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end

  test "Debería poder obtener listado de grupos como 'profesor'" do
    get grupos_url, headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response :success
  end

  # Revisión del servicio de creación de grupos

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


  #
end
