require 'test_helper'

class ComentariosControllerTest < ActionDispatch::IntegrationTest

  # Revision del funcionamiento del servicio create

  test "Debería obtener código 401 al tratar de crear un comentario sin autenticación" do
    assert_difference 'Comentario.count', 0 do
      post comentarios_url(parmas: {
        id: bitacora_revisiones(:three).id,
        tipo_aprobacion_id: tipo_aprobaciones(:one).id,
        comentarios: [
          {
            comentario: 'Este es un comentario de prueba para un item',
            es_item: true,
            id_item: items(:one).id
          },
          {
            comentario: 'Este es un comentario general',
            es_item: false,
            id_item: 0
          }
        ]
      })
    end
    assert_response 401
  end

  test "Debería poder crear comentarios a una minuta como estudiante" do
    assert_difference 'BitacoraEstado.count', 0 do
      assert_difference 'Aprobacion.count', 1 do
        assert_difference 'Registro.count', 2 do
          assert_difference 'Comentario.count', 2 do
            post comentarios_url(params: {
              id: bitacora_revisiones(:three).id,
              tipo_aprobacion_id: tipo_aprobaciones(:one).id,
              comentarios: [
                {
                  comentario: 'Este es un comentario de prueba para un item',
                  es_item: true,
                  id_item: items(:one).id
                },
                {
                  comentario: 'Este es un comentario general',
                  es_item: false,
                  id_item: 0
                }
              ]
            }), headers: authenticated_header(usuarios(:Maria), 'maria123')
          end
        end
      end
    end
    assert_response :success
  end

  test "Debería poder crear comentarios a una minuta como stakeholder" do
    assert_difference 'BitacoraEstado.count', 1 do
      assert_difference 'Aprobacion.count', 1 do
        assert_difference 'Registro.count', 2 do
          assert_difference 'Comentario.count', 2 do
            post comentarios_url(params: {
              id: bitacora_revisiones(:four).id,
              tipo_aprobacion_id: tipo_aprobaciones(:one).id,
              comentarios: [
                {
                  comentario: 'Este es un comentario de prueba para un item',
                  es_item: true,
                  id_item: items(:one).id
                },
                {
                  comentario: 'Este es un comentario general',
                  es_item: false,
                  id_item: 0
                }
              ]
            }), headers: authenticated_header(usuarios(:stakeholder), 'cliente')
          end
        end
      end
    end
    assert_response :success
  end


  # Revisión del funcionamiento del servicio 'show'

  test "Debería obtener código 401 al tratar de obtener 'show' sin autenticación" do
    get comentario_url(id: bitacora_revisiones(:three).id)
    assert_response 401
  end

  test "Debería poder obtener los comentarios de una minuta como estudiante" do
    get comentario_url(id: bitacora_revisiones(:three).id), headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end

  test "Debería poder obtener los comentarios de una minuta como stakeholder" do
    get comentario_url(id: bitacora_revisiones(:three).id), headers: authenticated_header(usuarios(:stakeholder), 'cliente')
    assert_response :success
  end

  test "Debería poder obtener los comentarios de una minuta como profesor" do
    get comentario_url(id: bitacora_revisiones(:three).id), headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response :success
  end

  test "Debería poder obtener los comentarios de una minuta como coordinador" do
    get comentario_url(id: bitacora_revisiones(:three).id), headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end
end
