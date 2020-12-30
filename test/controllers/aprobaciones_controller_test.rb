require 'test_helper'

class AprobacionesControllerTest < ActionDispatch::IntegrationTest

  #Revisión del funcionamiento del servicio 'show'

  test "Debería obtener código 401 al tratar de obtener 'show' sin autenticación" do
    get aprobacion_url(id: bitacora_revisiones(:three).id)
    assert_response 401
  end

  test "Debería poder obtener 'show' como estudiante" do
    get aprobacion_url(id: bitacora_revisiones(:three).id), headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end

  test "Debería poder obtener 'show' como profesor" do
    get aprobacion_url(id: bitacora_revisiones(:three).id), headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response :success
  end

  test "Debería poder obtener 'show' como coordinador" do
    get aprobacion_url(id: bitacora_revisiones(:three).id), headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end

  test "Debería poder obtener 'show' como stakeholder" do
    get aprobacion_url(id: bitacora_revisiones(:three).id), headers: authenticated_header(usuarios(:stakeholder), 'cliente')
    assert_response :success
  end


  # Revisión del funcionamiento del servicio 'update'

  test "Debería obtener código 401 al tratar de actualizar una aprobación sin autenticación" do
    put aprobacion_url(id: bitacora_revisiones(:three).id)
    assert_response 401
  end

  test "Debería poder actualizar una aprobación como estudiante" do
    @aprobacion = aprobaciones(:Pablo)
    assert_difference "BitacoraEstado.count", 0 do
      put aprobacion_url(id: bitacora_revisiones(:three).id, params: {
          id: bitacora_revisiones(:three).id,
          tipo_aprobacion_id: tipo_aprobaciones(:uno).id
        }
      ), headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    end
    @aprobacion.reload
    assert_equal @aprobacion.tipo_aprobacion_id, tipo_aprobaciones(:uno).id
    assert_response :success
  end

  test "Debería poder actualizar una aprobación como stakeholder" do
    @aprobacion = aprobaciones(:cliente)
    assert_difference "BitacoraEstado.count", 1 do
      put aprobacion_url(id: bitacora_revisiones(:four).id, params: {
          id: bitacora_revisiones(:four).id,
          tipo_aprobacion_id: tipo_aprobaciones(:dos).id
        }
      ), headers: authenticated_header(usuarios(:stakeholder), 'cliente')
    end
    @aprobacion.reload
    assert_equal @aprobacion.tipo_aprobacion_id, tipo_aprobaciones(:dos).id
    assert_response :success
  end

  test "Debería obtener código 422 al tratar de actualizar una aprobación como coordinador" do
    assert_difference "BitacoraEstado.count", 0 do
      put aprobacion_url(id: bitacora_revisiones(:three).id, params: {
          id: bitacora_revisiones(:three).id,
          tipo_aprobacion_id: tipo_aprobaciones(:dos).id
        }
      ), headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    end
    assert_response 422
  end

  test "Debería obtener código 422 al tratar de actualizar una aprobación como profesor" do
    assert_difference "BitacoraEstado.count", 0 do
      put aprobacion_url(id: bitacora_revisiones(:three).id, params: {
          id: bitacora_revisiones(:three).id,
          tipo_aprobacion_id: tipo_aprobaciones(:dos).id
        }
      ), headers: authenticated_header(usuarios(:profesor), 'profe')
    end
    assert_response 422
  end

  test "Debería obtener código 422 al tratar de actualizar como estudiante sin aprobación previa" do
    assert_difference "BitacoraEstado.count", 0 do
      put aprobacion_url(id: bitacora_revisiones(:three).id, params: {
          id: bitacora_revisiones(:three).id,
          tipo_aprobacion_id: tipo_aprobaciones(:uno).id
        }
      ), headers: authenticated_header(usuarios(:Maria), 'maria123')
    end
    assert_response 422
  end
end
