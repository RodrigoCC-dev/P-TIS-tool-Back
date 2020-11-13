require 'test_helper'
require 'net/http'

class EstudiantesControllerTest < ActionDispatch::IntegrationTest

  # Revisión de acceso a rutas sin autenticación

  test "Debería obtener código '401' al tratar de obtener 'index'" do
    get estudiantes_url
    assert_response 401
  end

  test "Debería obtener código '401' al tratar de postear 'create'" do
    post '/estudiantes', params: {estudiante: {
      seccion_id: secciones(:one),
      usuario_attributes: {
        nombre: 'Juan',
        apellido_paterno: 'Castro',
        apellido_materno: 'Mendez',
        run: '12345678-9',
        email: 'juan.castro@usach.cl',
        }
      }}
    assert_response 401
  end

  test "Debería obtener código '401' al tratar de obtener 'show'" do
    get estudiante_url(id: usuarios(:Pablo).id)
    assert_response 401
  end

  test "Debería obtener código '401' al tratar de obtener 'sin_grupo'" do
    get estudiantes_sin_grupo_url
    assert_response 401
  end


  # Revisión del funcionamiento de 'index'

  test "Debería obtener 'index' según usuario coodinador" do
    get estudiantes_url, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end

  test "Debería obtener 'index' con usuario profesor" do
    get estudiantes_url, headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response :success
  end


  # Revisión del funcionamiento de 'create'

  test "Debería poder crear un estudiante como coordinador" do
    assert_difference 'Estudiante.count', 1 do
      post '/estudiantes', params: {estudiante: {
        seccion_id: secciones(:one).id,
          usuario_attributes: {
            nombre: 'Matías',
            apellido_paterno: 'Carvajal',
            apellido_materno: 'Rodriguez',
            run: '10234567-8',
            email: 'matias.carvajal@usach.cl'
          }
        }
      }, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    end
    assert_response :success
  end

  test "Debería poder crear un estudiante como profesor" do
    assert_difference 'Estudiante.count', 1 do
      post '/estudiantes', params: {estudiante: {
        seccion_id: secciones(:one).id,
          usuario_attributes: {
            nombre: 'Anastasia',
            apellido_paterno: 'Soto',
            apellido_materno: 'Muñoz',
            run: '19543210-K',
            email: 'anastasia.soto@usach.cl'
          }
        }
      }, headers: authenticated_header(usuarios(:profesor), 'profe')
    end
    assert_response :success
  end


  # Revisión del funcionamiento del servicio 'show'

  test "Debería poder obtener la información de un estudiante" do
    get estudiante_url(id: usuarios(:Pablo).id), headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end

  # Revisión del funcionamiento del servicio 'sin_grupo'

  test "Debería obtener los estudiantes sin grupo como coordinador" do
    get estudiantes_sin_grupo_url, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end

  test "Debería obtener los estudiantes sin grupo como profesor" do
    get estudiantes_sin_grupo_url, headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response :success
  end
end
