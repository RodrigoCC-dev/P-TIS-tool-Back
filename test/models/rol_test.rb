require 'test_helper'

class RolTest < ActiveSupport::TestCase
  test "Rol con rango existente no se guarda" do
    rol = Rol.new
    rol.rol = "Prueba"
    rol.rango = 3
    assert_not rol.save
  end

  test "Rol con nuevo rango se guarda" do
    rol = Rol.new
    rol.rol = "Prueba"
    rol.rango = 6
    assert rol.save
  end
end
