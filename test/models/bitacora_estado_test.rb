require 'test_helper'

class BitacoraEstadoTest < ActiveSupport::TestCase
  test "BitacoraEstado con 'activo' igual a 'nil' no se guarda" do
    bitacora = BitacoraEstado.new(
      activo: nil,
      revisado: true,
      minuta_id: minutas(:one).id,
      tipo_estado_id: tipo_estados(:one).id
    )
    assert_not bitacora.save
  end

  test "BitacoraEstado con 'revisado' igual a 'nil' no se guarda" do
    bitacora = BitacoraEstado.new(
      activo: true,
      revisado: nil,
      minuta_id: minutas(:one).id,
      tipo_estado_id: tipo_estados(:one).id
    )
    assert_not bitacora.save
  end

  test "BitacoraEstado con 'activo' y 'revisado' válidos se guarda" do
    bitacora = BitacoraEstado.new(
      activo: false,
      revisado: true,
      minuta_id: minutas(:one).id,
      tipo_estado_id: tipo_estados(:one).id
    )
    assert bitacora.save
  end
end
