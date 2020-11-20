require 'test_helper'

class ClasificacionTest < ActiveSupport::TestCase
  test "Clasificacion con 'informativa' igual a 'nil' no se guarda" do
    clasificacion = Clasificacion.new(informativa: nil)
    assert_not clasificacion.save
  end

  test "Clasisificacion con 'avance' igual a 'nil' no se guarda" do
    clasificacion = Clasificacion.new(avance: nil)
    assert_not clasificacion.save
  end

  test "Clasificacion con 'coordinacion' igual a 'nil' no se guarda" do
    clasificacion = Clasificacion.new(coordinacion: nil)
    assert_not clasificacion.save
  end

  test "Clasificacion con 'decision' igual a 'nil' no se guarda" do
    clasificacion = Clasificacion.new(decision: nil)
    assert_not clasificacion.save
  end

  test "Clasificacion con 'otro' igual a 'nil' no se guarda" do
    clasificacion = Clasificacion.new(otro: nil)
    assert_not clasificacion.save
  end

  test "Clasificacion sin parámetros se guarda" do
    clasificacion = Clasificacion.new
    assert clasificacion.save
  end

  test "Clasificacion con parámetros válidos se guarda" do
    clasificacion = Clasificacion.new(
      informativa: true,
      avance: true,
      coordinacion: false,
      decision: false,
      otro: false
    )
    assert clasificacion.save
  end
end
