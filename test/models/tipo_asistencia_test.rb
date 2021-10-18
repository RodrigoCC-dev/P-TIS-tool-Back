require 'test_helper'

class TipoAsistenciaTest < ActiveSupport::TestCase
  test "TipoAsistencia con tipo existente no se guarda" do
    tipo = TipoAsistencia.new
    tipo.tipo = 'PRE'
    tipo.descripcion = "Prueba"
    assert_not tipo.save
  end

  test "TipoAsistencia con nuevo tipo se guarda" do
    tipo = TipoAsistencia.new
    tipo.tipo = 'AUS'
    tipo.descripcion = "Prueba"
    assert tipo.save
  end
end
