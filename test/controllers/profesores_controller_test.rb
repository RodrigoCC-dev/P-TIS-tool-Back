require 'test_helper'

class ProfesoresControllerTest < ActionDispatch::IntegrationTest

  # Revisión del funcionamiento del servicio index

  test "Debería obtener código 401 al tratar de obtener index sin autenticación" do
    get profesores_url
    assert_response 401
  end

  test "Debería obtener la lista de profesores en el sistema" do
    get profesores_url, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end


  # Revisión del funcionamiento del servicio create

  test "Debería obtener código 401 al tratar de crear un profesor sin autenticación" do
    assert_difference 'Profesor.count', 0 do
      post profesores_url(params: {
        usuario_attributes: {
          nombre: 'Manuel',
          apellido_paterno: 'Negrete',
          apellido_materno: 'Poblete',
          email: 'manuel.negrete@gmail.com'
        }
      })
    end
    assert_response 401
  end

  test "Debería poder crear un profesor" do
    assert_difference 'Profesor.count', 1 do
      post profesores_url(params: { profesor: {
        usuario_attributes: {
          nombre: 'Manuel',
          apellido_paterno: 'Negrete',
          apellido_materno: 'Poblete',
          email: 'manuel.negrete@gmail.com'
        }}
      }), headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    end
    assert_response :success
  end


  # Revision del funcionamiento del servicio 'update'

  test "Debería obtener código 401 al tratar de actualizar un profesor sin autenticación" do
    put profesor_url(id: profesores(:one).id, params: {
      profesor: {
        usuario_attributes: {
          nombre: 'Manuel',
          apellido_paterno: 'Negrete',
          apellido_materno: 'Poblete',
          email: 'manuel.negrete@gmail.com'
        }
      },
      secciones: [secciones(:one).id, secciones(:two).id]
    })
    assert_response 401
  end

  test "Debería poder actualizar un profesor como coordinador" do
    @profesor = profesores(:one)
    assert_difference 'Profesor.count', 0 do
      put profesor_url(id: profesores(:one).id, params: {
        profesor: {
          usuario_attributes: {
            nombre: 'Manuel',
            apellido_paterno: 'Negrete',
            apellido_materno: 'Poblete',
            email: 'manuel.negrete@gmail.com'
          }
        },
        secciones: [secciones(:one).id, secciones(:two).id]
      }), headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
      assert_response :success
    end
    @profesor.reload
    assert_equal @profesor.usuario.nombre, 'Manuel'
    assert_equal @profesor.usuario.apellido_paterno, 'Negrete'
    assert_equal @profesor.usuario.apellido_materno, 'Poblete'
    assert_equal @profesor.usuario.email, 'manuel.negrete@gmail.com'
    assert_equal @profesor.secciones.size, 2
    assert_equal @profesor.secciones.find(secciones(:one).id), secciones(:one)
    assert_equal @profesor.secciones.find(secciones(:two).id), secciones(:two)
  end

  test "Debería obtener código 422 al tratar de actualizar un profesor sin secciones asignadas como coordinador" do
    put profesor_url(id: profesores(:one).id, params: {
      profesor: {
        usuario_attributes: {
          nombre: 'Manuel',
          apellido_paterno: 'Negrete',
          apellido_materno: 'Poblete',
          email: 'manuel.negrete@gmail.com'
        }
      },
      secciones: []
    }), headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response 422
  end

  test "Debería obtener código 422 al tratar de actualizar un profesor con datos no válidos como coordinador" do
    put profesor_url(id: profesores(:one).id, params: {
      profesor: {
        usuario_attributes: {
          nombre: 'Manuel',
          apellido_paterno: 'Negrete#?',
          apellido_materno: 'Poblete',
          email: 'manuel.negrete@gmail@com'
        }
      },
      secciones: [secciones(:one).id, secciones(:two).id]
    }), headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response 422
  end

  test "Debería obtener código 422 al tratar de actualizar un profesor como profesor" do
    assert_difference 'Profesor.count', 0 do
      put profesor_url(id: profesores(:one).id, params: {
        profesor: {
          usuario_attributes: {
            nombre: 'Manuel',
            apellido_paterno: 'Negrete',
            apellido_materno: 'Poblete',
            email: 'manuel.negrete@gmail.com'
          }
        },
        secciones: [secciones(:one).id, secciones(:two).id]
      }), headers: authenticated_header(usuarios(:profesor), 'profe')
    end
    assert_response 422
  end

  test "Debería obtener código 422 al tratar de actualizar un profesor como estudiante" do
    assert_difference 'Profesor.count', 0 do
      put profesor_url(id: profesores(:one).id, params: {
        profesor: {
          usuario_attributes: {
            nombre: 'Manuel',
            apellido_paterno: 'Negrete',
            apellido_materno: 'Poblete',
            email: 'manuel.negrete@gmail.com'
          }
        },
        secciones: [secciones(:one).id, secciones(:two).id]
      }), headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    end
    assert_response 422
  end

  test "Debería obtener código 422 al tratar de actualizar un profesor como cliente" do
    assert_difference 'Profesor.count', 0 do
      put profesor_url(id: profesores(:one).id, params: {
        profesor: {
          usuario_attributes: {
            nombre: 'Manuel',
            apellido_paterno: 'Negrete',
            apellido_materno: 'Poblete',
            email: 'manuel.negrete@gmail.com'
          }
        },
        secciones: [secciones(:one).id, secciones(:two).id]
      }), headers: authenticated_header(usuarios(:stakeholder), 'cliente')
    end
    assert_response 422
  end
end
