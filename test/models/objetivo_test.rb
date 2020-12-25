require 'test_helper'

class ObjetivoTest < ActiveSupport::TestCase
  test "Objetivo sin 'descripcion' no se guarda" do
    objetivo = Objetivo.new(bitacora_revision_id: bitacora_revisiones(:one).id)
    assert_not objetivo.save
  end

  test "Objetivo con 'descripcion' se guarda" do
    objetivo = Objetivo.new(
      descripcion: 'Este es un nuevo objetivo',
      bitacora_revision_id: bitacora_revisiones(:one).id
    )
    assert objetivo.save
  end

  test "Objetivo con 'borrado' en 'nil' no se guarda" do
    objetivo = Objetivo.new(
      descripcion: 'Este es un nuevo objetivo',
      bitacora_revision_id: bitacora_revisiones(:one).id,
      borrado: nil
    )
    assert_not objetivo.save
  end

  test "Objetivo con 'borrado' en 'false' se guarda" do
    objetivo = Objetivo.new(
      descripcion: 'Este es un nuevo objetivo',
      bitacora_revision_id: bitacora_revisiones(:one).id,
      borrado: false
    )
    assert objetivo.save
  end

  test "Objetivo con 'borrado' en 'true' se guarda" do
    objetivo = Objetivo.new(
      descripcion: 'Este es un nuevo objetivo',
      bitacora_revision_id: bitacora_revisiones(:one).id,
      borrado: true
    )
    assert objetivo.save
  end
end
