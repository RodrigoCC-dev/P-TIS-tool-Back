require 'test_helper'

class TipoItemTest < ActiveSupport::TestCase
  test "TipoItem con tipo existente no se guarda" do
    tipo = TipoItem.new
    tipo.tipo = 'Logro'
    tipo.descripcion = 'Prueba de tipo único'
    assert_not tipo.save
  end

  test "TipoItem con tipo nuevo se guarda" do
    tipo = TipoItem.new
    tipo.tipo = 'Agenda'
    tipo.descripcion = 'Prueba de tipo único'
    assert tipo.save
  end
end
