require 'test_helper'

class RespuestasControllerTest < ActionDispatch::IntegrationTest

  # Revisión del funcionamiento del servicio create

  test "Debería obtener código 401 al tratar de crear una respuesta sin autenticación" do
    assert_difference 'Respuesta.count', 0 do
      post respuestas_url(params: {
        id: bitacora_revisiones(:one).id,
        respuestas: [{
          comentario_id: comentarios(:one).id,
          respuesta: 'respuesta de prueba'
        }]
        })
    end
    assert_response 401
  end

  test "Debería poder crear una respuesta como estudiante" do
    assert_difference 'BitacoraEstado.count', 1 do
      assert_difference 'Registro.count', 1 do
        assert_difference 'Respuesta.count', 1 do
          post respuestas_url(params: {
            id: bitacora_revisiones(:one).id,
            respuestas: [{
              comentario_id: comentarios(:one).id,
              respuesta: 'respuesta de prueba'
            }]
            }), headers: authenticated_header(usuarios(:Pablo), 'pablo123')
        end
      end
    end
    assert_response :success
  end

  test "Debería poder crear una respuesta como stakeholder" do
    assert_difference 'BitacoraEstado.count', 1 do
      assert_difference 'Registro.count', 1 do
        assert_difference 'Respuesta.count', 1 do
          post respuestas_url(params: {
            id: bitacora_revisiones(:one).id,
            respuestas: [{
              comentario_id: comentarios(:one).id,
              respuesta: 'respuesta de prueba'
            }]
            }), headers: authenticated_header(usuarios(:stakeholder), 'cliente')
        end
      end
    end
    assert_response :success
  end

  test "Debería poder cambiar estado de minuta al crear una respuesta vacía como estudiante" do
    assert_difference 'BitacoraEstado.count', 1 do
      assert_difference 'Registro.count', 0 do
        assert_difference 'Respuesta.count', 0 do
          post respuestas_url(params: {
            id: bitacora_revisiones(:one).id,
            respuestas: [{
              comentario_id: comentarios(:one).id,
              respuesta: ''
            }]
            }), headers: authenticated_header(usuarios(:Pablo), 'pablo123')
        end
      end
    end
    assert_response :success
  end

  test "Debería poder cambiar estado de minuta al crear una respuesta vacía como stakeholder" do
    assert_difference 'BitacoraEstado.count', 1 do
      assert_difference 'Registro.count', 0 do
        assert_difference 'Respuesta.count', 0 do
          post respuestas_url(params: {
            id: bitacora_revisiones(:one).id,
            respuestas: [{
              comentario_id: comentarios(:one).id,
              respuesta: ''
            }]
            }), headers: authenticated_header(usuarios(:stakeholder), 'cliente')
        end
      end
    end
    assert_response :success
  end


  # Revisión del funcionamiento del servicio 'show'

  test "Debería obtener código 401 al tratar de obtener las respuestas sin autenticación" do
    get respuesta_url(id: bitacora_revisiones(:three).id)
    assert_response 401
  end

  test "Debería poder obtener las respuestas de una minuta comentada" do
    get respuesta_url(id: bitacora_revisiones(:three).id), headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end

end
