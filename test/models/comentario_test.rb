require 'test_helper'

class ComentarioTest < ActiveSupport::TestCase
  test "Comentario sin 'comentario' no se guarda" do
    comentario = Comentario.new(
      es_item: false,
      id_item: nil,
      bitacora_revision_id: bitacora_revisiones(:one).id,
      asistencia_id: asistencias(:Pablo).id
    )
    assert_not comentario.save
  end

  test "Comentario con 'es_item' en 'nil' no se guarda" do
    comentario = Comentario.new(
      comentario: 'Este es un comentario de prueba',
      es_item: nil,
      id_item: nil,
      bitacora_revision_id: bitacora_revisiones(:one).id,
      asistencia_id: asistencias(:Pablo).id
    )
    assert_not comentario.save
  end

  test "Comentario con 'id_item' menor a cero no se guarda" do
    comentario = Comentario.new(
      comentario: 'Este es un comentario de prueba',
      es_item: false,
      id_item: -1,
      bitacora_revision_id: bitacora_revisiones(:one).id,
      asistencia_id: asistencias(:Pablo).id
    )
    assert_not comentario.save
  end

  test "Comentario con 'borrado' en 'nil' no se guarda" do
    comentario = Comentario.new(
      comentario: 'Este es un comentario de prueba',
      es_item: nil,
      id_item: nil,
      bitacora_revision_id: bitacora_revisiones(:one).id,
      asistencia_id: asistencias(:Pablo).id,
      borrado: nil
    )
    assert_not comentario.save
  end

  test "Comentario con valores válidos se guarda" do
    comentario = Comentario.new(
      comentario: 'Este es un comentario de prueba',
      es_item: false,
      id_item: nil,
      bitacora_revision_id: bitacora_revisiones(:one).id,
      asistencia_id: asistencias(:Pablo).id
    )
    assert comentario.save
  end

  test "Comentario con valores 'es_item' y 'id_item' válidos se guarda" do
    comentario = Comentario.new(
      comentario: 'Este es un comentario de prueba',
      es_item: true,
      id_item: items(:one).id,
      bitacora_revision_id: bitacora_revisiones(:one).id,
      asistencia_id: asistencias(:Pablo).id
    )
    assert comentario.save
  end
end
