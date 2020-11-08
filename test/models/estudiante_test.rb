require 'test_helper'

class EstudianteTest < ActiveSupport::TestCase
  test "Estudiante sin iniciales no se guarda" do
    estudiante = Estudiante.new(usuario: usuarios(:one),
    grupo: grupos(:one), seccion: secciones(:one))
    assert_not estudiante.save
  end

  test "Estudiante con iniciales se guarda" do
    estudiante = Estudiante.new(iniciales: 'ABC',
    usuario: usuarios(:two),
    grupo: grupos(:two), seccion: secciones(:two))
    assert estudiante.save
  end
end
