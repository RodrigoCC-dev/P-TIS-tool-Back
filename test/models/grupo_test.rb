require 'test_helper'

class GrupoTest < ActiveSupport::TestCase
  test "Grupo sin 'nombre' no se guarda" do
    grupo = Grupo.new(proyecto: 'Prueba', correlativo: 1)
    assert_not grupo.save
  end

  test "Grupo sin 'proyecto' no se guarda" do
    grupo = Grupo.new(nombre: 'G01', correlativo: 1)
    assert_not grupo.save
  end

  test "Grupo con 'nombre' sin formato válido no se guarda" do
    grupo = Grupo.new(nombre: 'BA46', proyecto: 'Prueba', correlativo: 1)
    assert_not grupo.save
  end

  test "Grupo con 'proyecto' sin formato válido no se guarda" do
    grupo = Grupo.new(nombre: 'G01', proyecto: 'Prueba @5#%&', correlativo: 1)
    assert_not grupo.save
  end

  test "Grupo con 'correlativo' menor a cero no se guarda" do
    grupo = Grupo.new(nombre: 'G01', proyecto: 'Prueba', correlativo: -2)
    assert_not grupo.save
  end

  test "Grupo con 'correlativo' no entero no se guarda" do
    grupo = Grupo.new(nombre: 'G01', proyecto: 'Prueba', correlativo: 2.5)
    assert_not grupo.save
  end

  test "Grupo con datos válidos se guarda" do
    grupo = Grupo.new(nombre: 'G01', proyecto: 'Prueba', correlativo: 1)
    assert grupo.save
  end
end
