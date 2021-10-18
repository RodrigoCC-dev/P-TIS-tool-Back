require 'test_helper'

class TipoEstadoTest < ActiveSupport::TestCase
  test "TipoEstado con abreviacion existente no se guarda" do
    tipo = TipoEstado.new
    tipo.abreviacion = 'BOR'
    tipo.descripcion = 'Prueba de guardado'
    assert_not tipo.save
  end

  test "TipoEstado con abreviacion nueva se guarda" do
    tipo = TipoEstado.new
    tipo.abreviacion = 'PDG'
    tipo.descripcion = 'Prueba de guardado'
    assert tipo.save
  end
end
