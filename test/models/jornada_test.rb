require 'test_helper'

class JornadaTest < ActiveSupport::TestCase
  test "Jornada con identificador existente no se guarda" do
    jornada = Jornada.new
    jornada.nombre = "Prueba"
    jornada.identificador = 1
    assert_not jornada.save
  end

  test "Jornada con nuevo identificador se guarda" do
    jornada = Jornada.new
    jornada.nombre = "Prueba"
    jornada.identificador = 3
    assert jornada.save
  end
end
