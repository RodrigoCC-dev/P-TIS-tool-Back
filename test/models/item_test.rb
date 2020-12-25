require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test "Item sin 'descripcion' no se guarda" do
    item = Item.new(
      correlativo: 1,
      tipo_item_id: tipo_items(:one).id,
      bitacora_revision_id: bitacora_revisiones(:one).id
    )
    assert_not item.save
  end

  test "Item sin 'correlativo' no se guarda" do
    item = Item.new(
      descripcion: 'Esto es una prueba',
      tipo_item_id: tipo_items(:one).id,
      bitacora_revision_id: bitacora_revisiones(:one).id
    )
    assert_not item.save
  end

  test "Item con 'correlativo' menor o igual a 'cero' no se guarda" do
    item = Item.new(
      descripcion: 'Esto es una prueba',
      correlativo: -1,
      tipo_item_id: tipo_items(:one).id,
      bitacora_revision_id: bitacora_revisiones(:one).id
    )
    assert_not item.save
  end

  test "Item sin 'fecha', 'resuelto', 'resuelto_por' y 'resuelto_el' se guarda" do
    item = Item.new(
      descripcion: 'Esto es una prueba',
      correlativo: 2,
      tipo_item_id: tipo_items(:one).id,
      bitacora_revision_id: bitacora_revisiones(:one).id
    )
    assert item.save
  end

  test "Item con 'borrado' en 'nil' no se guarda" do
    item = Item.new(
      descripcion: 'Esto es una prueba',
      correlativo: 2,
      tipo_item_id: tipo_items(:one).id,
      bitacora_revision_id: bitacora_revisiones(:one).id,
      borrado: nil
    )
    assert_not item.save
  end

  test "Item con 'borrado' en 'true' se guarda" do
    item = Item.new(
      descripcion: 'Esto es una prueba',
      correlativo: 2,
      tipo_item_id: tipo_items(:one).id,
      bitacora_revision_id: bitacora_revisiones(:one).id,
      borrado: true
    )
    assert item.save
  end

  test "Item con 'borrado' en 'false' se guarda" do
    item = Item.new(
      descripcion: 'Esto es una prueba',
      correlativo: 2,
      tipo_item_id: tipo_items(:one).id,
      bitacora_revision_id: bitacora_revisiones(:one).id,
      borrado: false
    )
    assert item.save
  end
end
