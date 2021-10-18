require 'test_helper'

class TipoMinutumTest < ActiveSupport::TestCase
  test "TipoMinuta con tipo existente no se guarda" do
    tipo = TipoMinuta.new
    tipo.tipo = "Coordinacion"
    tipo.descripcion = "Prueba"
    assert_not tipo.save
  end

  test "TipoMinuta con tipo nuevo se guarda" do
    tipo = TipoMinuta.new
    tipo.tipo = "Cliente"
    tipo.descripcion = "Prueba"
    assert tipo.save
  end
end
