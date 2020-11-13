require 'test_helper'

class TemaTest < ActiveSupport::TestCase
  test "Tema sin 'tema' no se guarda" do
    tema = Tema.new(bitacora_revision_id: bitacora_revisiones(:one).id)
    assert_not tema.save
  end

  test "Tema con 'tema' se guarda" do
    tema = Tema.new(
      tema: 'Esta es una prueba del modelo',
      bitacora_revision_id: bitacora_revisiones(:one).id)
    assert tema.save
  end
end
