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
    get estudiantes_asignacion_sin_grupo_url
    assert_response 401
  end

  test "Debería obtener código '401' al tratar de obtener 'eliminar' sin autenticación" do
    post estudiantes_eliminar_url(params: {eliminados: [estudiantes(:one).id, estudiantes(:two).id]})
    assert_response 401
  end

  test "Debería obtener código '401' al tratar de obtener 'desde_archivo' sin autenticación" do
    post estudiantes_archivo_nuevos_url, params: {archivo: "#{Rails.root}/test/templates/Nomina_curso_para_test.xls", seccion: secciones(:one).id}
    assert_response 401
  end

  test "Debería obtener código '401' al tratar de obtener 'plantilla' sin autenticación" do
    get estudiantes_archivo_plantilla_url
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

  test "Debería poder restablecer un estudiante eliminado como coordinador" do
    @usuario = usuarios(:two)
    assert_difference 'Estudiante.count', 0 do
      post '/estudiantes', params: {estudiante: {
        seccion_id: secciones(:two).id,
          usuario_attributes: {
            nombre: 'Mauricio',
            apellido_paterno: 'Venegas',
            apellido_materno: 'Maldonado',
            run: '22333444-5',
            email: 'mauricio.venegas@usach.cl'
          }
        }
      }, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    end
    @usuario.reload
    assert_equal @usuario.borrado, false
    assert_equal @usuario.nombre, 'Mauricio'
    assert_equal @usuario.apellido_paterno, 'Venegas'
    assert_equal @usuario.apellido_materno, 'Maldonado'
    assert_equal @usuario.email, 'mauricio.venegas@usach.cl'
    assert_response :success
  end

  test "Debería poder restablecer un estudiante eliminado como profesor" do
    @usuario = usuarios(:three)
    assert_difference 'Estudiante.count', 0 do
      post '/estudiantes', params: {estudiante: {
        seccion_id: secciones(:one).id,
          usuario_attributes: {
            nombre: 'Sergio',
            apellido_paterno: 'Gatica',
            apellido_materno: 'Valenzuela',
            run: '12345678-9',
            email: 'sergio.gatica@usach.cl'
          }
        }
      }, headers: authenticated_header(usuarios(:profesor), 'profe')
    end
    @usuario.reload
    assert_equal @usuario.borrado, false
    assert_equal @usuario.nombre, 'Sergio'
    assert_equal @usuario.apellido_paterno, 'Gatica'
    assert_equal @usuario.apellido_materno, 'Valenzuela'
    assert_equal @usuario.email, 'sergio.gatica@usach.cl'
    assert_response :success
  end

  # Revisión del funcionamiento del servicio 'show'

  test "Debería poder obtener la información de un estudiante" do
    get estudiante_url(id: usuarios(:Pablo).id), headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end


  # Revisión del funcionamiento del servicio 'sin_grupo'

  test "Debería obtener los estudiantes sin grupo como coordinador" do
    get estudiantes_asignacion_sin_grupo_url, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end

  test "Debería obtener los estudiantes sin grupo como profesor" do
    get estudiantes_asignacion_sin_grupo_url, headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response :success
  end


  # Revisión del funcionamiento del servicio 'eliminar'

  test "Debería poder eliminar un estudiante como coordinador" do
    @estudiante1 = estudiantes(:one)
    @fecha_est1 = estudiantes(:one).usuario.deleted_at
    @estudiante2 = estudiantes(:two)
    @fecha_est2 = estudiantes(:two).usuario.deleted_at
    post estudiantes_eliminar_url(params: {eliminados:
      [estudiantes(:one).id, estudiantes(:two).id]
      }), headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    @estudiante1.reload
    @estudiante2.reload
    assert_equal @estudiante1.usuario.borrado, true
    assert_not_equal @fecha_est1, @estudiante1.usuario.deleted_at
    assert_equal @estudiante1.grupo_id, grupos(:defecto).id
    assert_equal @estudiante2.usuario.borrado, true
    assert_not_equal @fecha_est2, @estudiante2.usuario.deleted_at
    assert_equal @estudiante2.grupo_id, grupos(:defecto).id
    assert_response :success
  end


  # Revisión del funcionamiento del servicio 'desde_archivo'

  test "Debería poder crear estudiantes desde un archivo Excel como coordinador" do
    assert_difference 'Estudiante.count', 2 do
      assert_difference 'Usuario.count', 2 do
        post estudiantes_archivo_nuevos_url, params: {
          archivo: fixture_file_upload('files/Nomina_curso_para_test.xls', 'application/vnd.ms-excel'),
          seccion: secciones(:one).id},
          headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
      end
    end
    @estudiante1 = Estudiante.find_by(usuario_id: Usuario.find_by(run: '13876543-1').id)
    @estudiante2 = Estudiante.find_by(usuario_id: Usuario.find_by(run: '16978974-7').id)
    assert_equal 'pedro.parada@usach.cl', @estudiante1.usuario.email
    assert_equal 'yolanda.meneses@usach.cl', @estudiante2.usuario.email
    assert_response :success
  end

  test "Debería poder crear estudiantes desde un archivo Excel como profesor" do
    assert_difference 'Estudiante.count', 2 do
      assert_difference 'Usuario.count', 2 do
        post estudiantes_archivo_nuevos_url, params: {
          archivo: fixture_file_upload('files/Nomina_curso_para_test.xls', 'application/vnd.ms-excel'),
          seccion: secciones(:one).id},
          headers: authenticated_header(usuarios(:profesor), 'profe')
      end
    end
    @estudiante1 = Estudiante.find_by(usuario_id: Usuario.find_by(run: '13876543-1').id)
    @estudiante2 = Estudiante.find_by(usuario_id: Usuario.find_by(run: '16978974-7').id)
    assert_equal 'pedro.parada@usach.cl', @estudiante1.usuario.email
    assert_equal 'yolanda.meneses@usach.cl', @estudiante2.usuario.email
    assert_response :success
  end


  # Revisión del funcionamiento del servicio 'plantilla'

  test "Debería poder obtener el formato de la plantilla como coordinador" do
    get estudiantes_archivo_plantilla_url, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end

  test "Debería poder obtener el formato de la plantilla como profesor" do
    get estudiantes_archivo_plantilla_url, headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response :success
  end

end
