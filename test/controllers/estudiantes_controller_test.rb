require 'test_helper'

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

  test "Debería obtener código '401' al tratar de obtener 'sin_grupo'" do
    get estudiantes_sin_grupo_url
    assert_response 401
  end

  # Revisión del funcionamiento de index

  def coodinador_header
    token = Knock::AuthToken.new(payload: {sub: usuarios(:one).id}).token
    {
      'Authorization': "Bearer #{token}"
    }
  end

  test "Debería obtener 'index' según secciones de un usuario" do
    get estudiantes_url, headers: coodinador_header
    assert_response :success
  end

end
