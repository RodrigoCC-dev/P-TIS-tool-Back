require 'test_helper'

class RegistroTest < ActiveSupport::TestCase
  test "Registro sin 'realizada_por' no se guarda" do
    registro = Registro.new(
      minuta_id: minutas(:one).id,
      tipo_actividad_id: tipo_actividades(:one).id
    )
    assert_not registro.save
  end

  test "Registro con 'realizada_por' menor a '1' no se guarda" do
    registro = Registro.new(
      realizada_por: -1,
      minuta_id: minutas(:one).id,
      tipo_actividad_id: tipo_actividades(:one).id
    )
    assert_not registro.save
  end

  test "Registro con 'realizada_por' válido, se guarda" do
    registro = Registro.new(
      realizada_por: 263345,
      minuta_id: minutas(:one).id,
      tipo_actividad_id: tipo_actividades(:one).id
    )
    assert registro.save
  end
end
