require 'test_helper'

class ConclusionTest < ActiveSupport::TestCase
  test "Conclusion sin 'descripcion' no se guarda" do
    conclusion = Conclusion.new(bitacora_revision_id: bitacora_revisiones(:one).id)
    assert_not conclusion.save
  end

  test "Conclusion con 'descripcion' se guarda" do
    conclusion = Conclusion.new(
      descripcion: 'Esta es una conclusion de prueba',
      bitacora_revision_id: bitacora_revisiones(:one).id
    )
    assert conclusion.save
  end
end
