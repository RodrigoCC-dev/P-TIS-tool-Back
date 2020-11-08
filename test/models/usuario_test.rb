require 'test_helper'

class UsuarioTest < ActiveSupport::TestCase
  test "Usurio sin nombre y apellidos no se guarda" do
    usuario = Usuario.new
    assert_not usuario.save
  end

  test "Usuario sin run válido no se guarda" do
    usuario = Usuario.new(nombre: 'Matías',
      apellido_paterno: 'Carvajal',
      apellido_materno: 'Rodriguez',
      run: '12345-6',
      email: 'matias.carvajal@gmail.com',
      password: 'matias123',
      password_confirmation: 'matias123',
      rol: roles(:one))
    assert_not usuario.save
  end

  test "Usuario sin run se guarda" do
    usuario = Usuario.new(nombre: 'Anastasia',
      apellido_paterno: 'Soto',
      apellido_materno: 'Muñoz',
      email: 'anastasia.soto@usach.cl',
      password: 'anastasia123',
      password_confirmation: 'anastasia123',
      rol: roles(:one)
    )
    assert usuario.save
  end

  test "Usuario sin email válido no se guarda" do
    usuario = Usuario.new(nombre: 'Anastasia',
      apellido_paterno: 'Soto',
      apellido_materno: 'Muñoz',
      run: '12345678-5',
      email: 'anastasia½@gmasi.tast3.ñl5',
      password: 'anastasia123',
      password_confirmation: 'anastasia123',
      rol: roles(:one)
    )
    assert_not usuario.save
  end

  test "Usuario sin email no se guarda" do
    usuario = Usuario.new(nombre: 'Anastasia',
      apellido_paterno: 'Soto',
      apellido_materno: 'Muñoz',
      run: '12345678-5',
      password: 'anastasia123',
      password_confirmation: 'anastasia123',
      rol: roles(:one)
    )
    assert_not usuario.save
  end

  test "Usuario sin nombre válido no se guarda" do
    usuario = Usuario.new(nombre: 'Anasta%#sia',
      apellido_paterno: 'Soto',
      apellido_materno: 'Muñoz',
      run: '12345678-5',
      email: 'anastasia.soto@usach.cl',
      password: 'anastasia123',
      password_confirmation: 'anastasia123',
      rol: roles(:one)
    )
    assert_not usuario.save
  end

  test "Usuario sin apellido paterno válido no se guarda" do
    usuario = Usuario.new(nombre: 'Anastasia',
      apellido_paterno: '!Soto%#',
      apellido_materno: 'Muñoz',
      run: '12345678-5',
      email: 'anastasia.soto@usach.cl',
      password: 'anastasia123',
      password_confirmation: 'anastasia123',
      rol: roles(:one)
    )
    assert_not usuario.save
  end

  test "Usuario sin apellido materno válido no se guarda" do
    usuario = Usuario.new(nombre: 'Anastasia',
      apellido_paterno: 'Soto',
      apellido_materno: 'M%#uñoz&&',
      run: '12345678-5',
      email: 'anastasia.soto@usach.cl',
      password: 'anastasia123',
      password_confirmation: 'anastasia123',
      rol: roles(:one)
    )
    assert_not usuario.save
  end

  test "Usuario con todos los datos válidos se guarda" do
    usuario = Usuario.new(nombre: 'Anastasia',
      apellido_paterno: 'Soto',
      apellido_materno: 'Muñoz',
      run: '12345678-5',
      email: 'anastasia.soto@usach.cl',
      password: 'anastasia123',
      password_confirmation: 'anastasia123',
      rol: roles(:one)
    )
    assert usuario.save
  end

  test "Usuario con email repetido no se guarda" do
    usuario = Usuario.new(nombre: 'Matías',
      apellido_paterno: 'Carvajal',
      apellido_materno: 'Rodriguez',
      run: '12345678-9',
      email: 'pablo.castro@usach.cl',
      password: 'matias123',
      password_confirmation: 'matias123',
      rol: roles(:one))
    assert_not usuario.save
  end
end
