require 'test_helper'

class EstudiantesMailerTest < ActionMailer::TestCase
  test "Notificación a los compañeros de grupo" do
    email = EstudiantesMailer.nuevaMinutaCoordinacion(bitacora_revisiones(:three))
    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ['minutas.reunion@informatica.usach.cl'], email.from
    assert_equal ['pablo.castro@usach.cl', 'maria.facunda@usach.cl'], email.to
    assert_equal 'Hay una nueva minuta de reunión que requiere tu revisión', email.subject
    assert_equal ActionMailer::Base.deliveries.last.body.to_s, email.body.to_s
  end

  test "Notificación al cliente de una nueva emisión" do
    email = EstudiantesMailer.revisionCliente(bitacora_revisiones(:three))
    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ['minutas.reunion@informatica.usach.cl'], email.from
    assert_equal ['gabriela.martinez@algo.com'], email.to
    assert_equal 'Se ha emitido una nueva minuta para su revisión', email.subject
    assert_equal ActionMailer::Base.deliveries.last.body.to_s, email.body.to_s
  end

  test "Notificación a los compañeros de emisión de minuta al cliente" do
    email = EstudiantesMailer.avisoAestudiantes(bitacora_revisiones(:three))
    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ['minutas.reunion@informatica.usach.cl'], email.from
    assert_equal ['pablo.castro@usach.cl', 'maria.facunda@usach.cl'], email.to
    assert_equal 'Se ha emitido una minuta para revisión del cliente', email.subject
    assert_equal ActionMailer::Base.deliveries.last.body.to_s, email.body.to_s
  end

  test "Notificación de respuestas a comentarios del cliente" do
    email = EstudiantesMailer.respuestaAlCliente(bitacora_revisiones(:three))
    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ['minutas.reunion@informatica.usach.cl'], email.from
    assert_equal ['gabriela.martinez@algo.com'], email.to
    assert_equal 'Se han respondido los comentarios realizados a la minuta MINUTA_G01_01_2020-2_0929_A', email.subject
    assert_equal ActionMailer::Base.deliveries.last.body.to_s, email.body.to_s
  end
end
