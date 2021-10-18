require 'test_helper'

class TipoAprobacionTest < ActiveSupport::TestCase
  test "TipoAprobacion con rango existente no se guarda" do
    tipo = TipoAprobacion.new
    tipo.identificador = 'PG'
    tipo.descripcion = 'Prueba de guardado'
    tipo.rango = 1
    assert_not tipo.save
  end

  test "TipoAprobacion con nuevo rango se guarda" do
    tipo = TipoAprobacion.new
    tipo.identificador = 'PG'
    tipo.descripcion = 'Prueba de guardado'
    tipo.rango = 5
    assert tipo.save
  end
end
