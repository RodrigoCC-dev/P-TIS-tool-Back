require 'test_helper'

class RegistrosControllerTest < ActionDispatch::IntegrationTest

  # Revisión del servicio 'show'

  test "Debería obtener código 401 al tratar de obtener 'show' sin autenticación" do
    get registro_url(id: bitacora_revisiones(:one).id)
    assert_response 401
  end

  test "Debería poder obtener los registros de una minuta como 'coordinador'" do
    get registro_url(id: bitacora_revisiones(:one).id), headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end

  test "Debería poder obtener los registros de una minuta como 'profesor'" do
    get registro_url(id: bitacora_revisiones(:one).id), headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response :success
  end

  test "Debería poder obtener los registros de una minuta como 'estudiante'" do
    get registro_url(id: bitacora_revisiones(:one).id), headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response :success
  end

  test "Debería poder obtener los registros de una minuta como 'stakeholder'" do
    get registro_url(id: bitacora_revisiones(:one).id), headers: authenticated_header(usuarios(:stakeholder), 'cliente')
    assert_response :success
  end


  # Revisión del servicio 'actividades_minutas'

  test "Debería obtener código 401 al tratar de obtener 'actividades_minutas' sin autenticación" do
    get '/registros/grupo/' + grupos(:one).id.to_s
    assert_response 401
  end

  test "Debería poder obtener 'actividades_minutas' como coordinador" do
    get '/registros/grupo/' + grupos(:one).id.to_s, headers: authenticated_header(usuarios(:coordinador), 'coordinacion')
    assert_response :success
  end

  test "Debería poder obtener 'actividades_minutas' profesor" do
    get '/registros/grupo/' + grupos(:one).id.to_s, headers: authenticated_header(usuarios(:profesor), 'profe')
    assert_response :success
  end

  test "Debería obtener código 422 al tratar de obtener 'actividades_minutas' como estudiante" do
    get '/registros/grupo/' + grupos(:one).id.to_s, headers: authenticated_header(usuarios(:Pablo), 'pablo123')
    assert_response 422
  end

  test "Debería obtener código 422 al tratar de obtener 'actividades_minutas' como stakeholder" do
    get '/registros/grupo/' + grupos(:one).id.to_s, headers: authenticated_header(usuarios(:stakeholder), 'cliente')
    assert_response 422
  end
end
