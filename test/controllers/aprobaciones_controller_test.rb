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
    put aprobacion_url(id: bitacora_revisiones(:three).id)
    assert_response 401
  end
end
