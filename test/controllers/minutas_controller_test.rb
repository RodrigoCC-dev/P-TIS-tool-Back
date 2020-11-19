require 'test_helper'

class MinutasControllerTest < ActionDispatch::IntegrationTest

  # Revisión del funcionamiento del servicio 'create'

  test "Debería obtener código '401' al tratar de crear una minuta sin autenticación" do
    assert_difference 'Minuta.count', 0 do
      post minutas_url, params: {
        minuta: {
          estudiante_id: estudiantes(:Pablo).id,
          correlativo: 1,
          codigo: 'MINUTA_G01_05_2020-2_1112',
          fecha_reunion: '2020-11-12',
          h_inicio: '13:00',
          h_termino: '14:00',
          tipo_minuta_id: tipo_minutas(:one).id
        },
        clasificacion: {
          informativa: false,
          avance: false,
          coordinacion: true,
          decision: true,
          otro: false
        },
        tema: 'Minuta de prueba',
        objetivos: ['Este es el primer objetivo', 'Este es el segundo objetivo'],
        conclusiones: ['Esta es la primera conclusión', 'Esta es la segunda conclusion'],
        items: [{
          correlativo: 1,
          descripcion: 'Primer item',
          fecha: '',
          tipo_item_id: tipo_items(:one).id,
          responsables: [0]
          },
          {
            correlativo: 2,
            descripcion: 'Segundo item',
            fecha: '2020-12-05',
            tipo_item_id: tipo_items(:two).id,
            responsables: [asistencias(:Pablo).id]
          }
        ],
        bitacora_revision: {
          revision: 'A',
          motivo_id: motivos(:one).id
        },
        asistencia: [
          {estudiante: estudiantes(:one).id, asistencia: tipo_asistencias(:one).id},
          {estudiante: estudiantes(:two).id, asistencia: tipo_asistencias(:two).id}
        ],
        tipo_estado: tipo_estados(:one).id
      }
    end
  end

  test "Debería poder crear una minuta" do
    assert_difference 'BitacoraEstado.count', 1 do
      assert_difference 'Registro.count', 13 do
        assert_difference 'Asistencia.count', 2 do
          assert_difference 'Item.count', 2 do
            assert_difference 'Responsable.count', 1 do
              assert_difference 'Objetivo.count', 2 do
                assert_difference 'Conclusion.count', 2 do
                  assert_difference 'BitacoraRevision.count', 1 do
                    assert_difference 'Tema.count', 1 do
                      assert_difference 'Clasificacion.count', 1 do
                        assert_difference 'Minuta.count', 1 do
                          post minutas_url, params: {
                            minuta: {
                              estudiante_id: estudiantes(:Pablo).id,
                              correlativo: 1,
                              codigo: 'MINUTA_G01_05_2020-2_1112',
                              fecha_reunion: '2020-11-12',
                              h_inicio: '13:00',
                              h_termino: '14:00',
                              tipo_minuta_id: tipo_minutas(:one).id
                            },
                            clasificacion: {
                              informativa: false,
                              avance: false,
                              coordinacion: true,
                              decision: true,
                              otro: false
                            },
                            tema: 'Minuta de prueba',
                            objetivos: ['Este es el primer objetivo', 'Este es el segundo objetivo'],
                            conclusiones: ['Esta es la primera conclusión', 'Esta es la segunda conclusion'],
                            items: [{
                              correlativo: 1,
                              descripcion: 'Primer item',
                              fecha: '',
                              tipo_item_id: tipo_items(:one).id,
                              responsables: [0]
                              },
                              {
                                correlativo: 2,
                                descripcion: 'Segundo item',
                                fecha: '2020-12-05',
                                tipo_item_id: tipo_items(:two).id,
                                responsables: [estudiantes(:Pablo).id]
                              }
                            ],
                            bitacora_revision: {
                              revision: 'A',
                              motivo_id: motivos(:one).id
                            },
                            asistencia: [
                              {estudiante: estudiantes(:Pablo).id, asistencia: tipo_asistencias(:one).id},
                              {estudiante: estudiantes(:two).id, asistencia: tipo_asistencias(:two).id}
                            ],
                            tipo_estado: tipo_estados(:one).id
                          }, headers: authenticated_header(usuarios(:Pablo), 'pablo123')
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end


  # Revisión de funcionamiento del servicio 'show'

  test "Debería obtener código '401' al tratar de obtener 'show'" do
    get minuta_url(id: minutas(:one).id)
    assert_response 401
  end

  test "Debería poder obtener la minuta seleccionada" do
    get minuta_url(id: minutas(:one).id), headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end


  # Revisión de funcionamiento del servicio 'correlativo'

  test "Debería obtener código '401' al tratar de obtener correlativo sin autenticación" do
    get '/minutas/correlativo/' + grupos(:one).id.to_s
    assert_response 401
  end

  test "Debería obtener el número correlativo siguiente para el grupo" do
    get '/minutas/correlativo/' + grupos(:one).id.to_s,
      headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end


  # Revisión del funcionamiento del servicio 'por_grupo'

  test "Debería obtener código '401' al tratar de obtener las minutas de un grupo sin autenticación" do
    get '/minutas/grupo/' + grupos(:one).id.to_s
    assert_response 401
  end

  test "Debería obtener el listado de minutas de un grupo" do
    get '/minutas/grupo/' + grupos(:one).id.to_s,
      headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end


  # Revisión del funcionamiento del servicion 'por_estados'

  test "Debería obtener código '401' al tratar de obtener 'por_estados' sin autenticación" do
    get '/minutas/revision/estados'
    assert_response 401
  end

  test "Debería obtener código '422' al tratar de obtener 'por_estados' como coodinador" do
    get '/minutas/revision/estados', headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response 422
  end

  test "Debería obtener código '422' al tratar de obtener 'por_estados' como profesor" do
    get '/minutas/revision/estados', headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response 422
  end

  test "Debería obtener código '422' al tratar de obtener 'por_estados' como stakeholder" do
    get '/minutas/revision/estados', headers: authenticated_header(usuarios(:stakeholder), 'cliente')
    assert_response 422
  end

  test "Debería obener el listado de minutas de un estudiante" do
    get '/minutas/revision/estados', headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end


  # Revision del funcionamiento del servicio 'revision_grupo'

  test "Debería obtener código '401' al tratar de obtener 'revision_grupo' sin autenticación" do
    get '/minutas/revision/grupo'
    assert_response 401
  end

  test "Debería obtener código '422' al tratar de obtener 'revision_grupo' como coordinador" do
    get '/minutas/revision/grupo', headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response 422
  end

  test "Debería obtener código '422' al tratar de obtener 'revision_grupo' como profesor" do
    get '/minutas/revision/grupo', headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response 422
  end

  test "Debería obtener código '422' al tratar de obtener 'revision_grupo' como stakeholder" do
    get '/minutas/revision/grupo', headers: authenticated_header(usuarios(:stakeholder), 'cliente')
    assert_response 422
  end

  test "Debería obtener el listado de minutas a revisar por un estudiante" do
    get '/minutas/revision/grupo', headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end


  # Revisión del funcionamiento del servicio 'revision_cliente'

  test "Debería obtener código '401' al tratar de obtener 'revision_cliente' sin autenticación" do
    get '/minutas/revision/cliente'
    assert_response 401
  end

  test "Debería obtener código '422' al tratar de obtener 'revision_cliente' como 'estudiante'" do
    get '/minutas/revision/cliente', headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response 422
  end

  test "Debería obtener código '422' al tratar de obtener 'revision_cliente' como 'profeosr'" do
    get '/minutas/revision/cliente', headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response 422
  end

  test "Debería obtener código '422' al tratar de obtener 'revision_cliente' como 'coordinador'" do
    get '/minutas/revision/cliente', headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response 422
  end

  test "Debería obtener el listado de minutas a revisar por un stakeholder" do
    get '/minutas/revision/cliente', headers: authenticated_header(usuarios(:stakeholder), 'cliente')
    assert_response :success
  end
end
