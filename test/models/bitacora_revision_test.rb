require 'test_helper'

class BitacoraRevisionTest < ActiveSupport::TestCase
  test "BitacoraRevision con 'revision' sin formato válido no se guarda" do
    bitacora = BitacoraRevision.new(
      revision: 'AB',
      motivo_id: motivos(:one).id,
      minuta_id: minutas(:one).id
    )
    assert_not bitacora.save
  end

  test "BitacoraRevision con 'revision' con formato válido se guarda" do
    bitacora = BitacoraRevision.new(
      revision: 'C',
      motivo_id: motivos(:one).id,
      minuta_id: minutas(:one).id
    )
    assert bitacora.save
  end
end
