require 'test_helper'

class ProfesorTest < ActiveSupport::TestCase
  test "Profesor con datos de usuario y secciones se guarda" do
    profesor = Profesor.new(usuario: usuarios(:two),
    secciones: [secciones(:one), secciones(:two)])
    assert profesor.save
  end
end
