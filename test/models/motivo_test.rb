require 'test_helper'

class MotivoTest < ActiveSupport::TestCase
  test "Motivo con identificador existente no se guarda" do
    motivo = Motivo.new
    motivo.motivo = 'Prueba de validacion'
    motivo.identificador = 'ECI'
    assert_not motivo.save
  end

  test "Motivo con identificador nuevo se guarda" do
    motivo = Motivo.new
    motivo.motivo = 'Prueba de validacion'
    motivo.identificador = 'PDV'
    assert motivo.save
  end
end
