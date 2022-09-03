require 'test_helper'

class StakeholdersMailerTest < ActionMailer::TestCase
  test "Notificar comentarios a una minuta" do
    email = StakeholdersMailer.comentariosMinuta(bitacora_revisiones(:three), usuarios(:stakeholder))
    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ['minutas.reunion@informatica.usach.cl'], email.from
    assert_equal ['one@mystring.com'], email.to
    assert_equal 'Se ha realizado la revisión de una minuta de reunión', email.subject
    assert_equal ActionMailer::Base.deliveries.last.body.to_s, email.body.to_s
  end

  test "Notificar estado de aprobación de una minuta" do
    email = StakeholdersMailer.aprobacionMinuta(bitacora_revisiones(:three), usuarios(:stakeholder))
    assert_emails 1 do
      email.deliver_now
    end
    assert_equal ['minutas.reunion@informatica.usach.cl'], email.from
    assert_equal ['one@mystring.com'], email.to
    assert_equal 'Ha concluido la revisión de una minuta de reunión por parte del cliente', email.subject
    assert_equal ActionMailer::Base.deliveries.last.body.to_s, email.body.to_s
  end
end
