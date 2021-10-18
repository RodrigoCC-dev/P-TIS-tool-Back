require 'test_helper'

class TipoActividadTest < ActiveSupport::TestCase
  test "TipoActividad con identificador existente no se guarda" do
    tipo = TipoActividad.new
    tipo.actividad = "Prueba"
    tipo.descripcion = 'Prueba de guardado'
    tipo.identificador = 'T2'
    assert_not tipo.save
  end

  test "TipoActividad con nuevo identificador se guarda" do
    tipo = TipoActividad.new
    tipo.actividad = "Prueba"
    tipo.descripcion = 'Prueba de guardado'
    tipo.identificador = 'PG1'
    assert tipo.save
  end
end
