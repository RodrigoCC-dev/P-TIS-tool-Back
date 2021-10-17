require 'test_helper'

class CursoTest < ActiveSupport::TestCase
  test "Curso con codigo existente no se guarda" do
    curso = Curso.new
    curso.nombre = "Prueba"
    curso.codigo = 12345
    assert_not curso.save
  end

  test "Curso con nuevo codigo se guarda" do
    curso = Curso.new
    curso.nombre = "Prueba"
    curso.codigo = 67890
    assert curso.save
  end
end
