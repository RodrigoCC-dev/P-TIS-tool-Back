require 'test_helper'

class MinutaTest < ActiveSupport::TestCase
  test "Minuta sin 'correlativo' no se guarda" do
    minuta = Minuta.new(
      codigo: 'MINUTA_G01_01_2020-2_1112',
      fecha_reunion: '2020-11-12',
      h_inicio: '17:20',
      h_termino: '19:20',
      estudiante_id: estudiantes(:one).id,
      tipo_minuta_id: tipo_minutas(:one).id,
      clasificacion_id: clasificaciones(:one).id
    )
    assert_not minuta.save
  end

  test "Minuta sin 'fecha_reunion' no se guarda" do
    minuta = Minuta.new(
      correlativo: 1,
      codigo: 'MINUTA_G01_01_2020-2_1112',
      h_inicio: '17:20',
      h_termino: '19:20',
      estudiante_id: estudiantes(:one).id,
      tipo_minuta_id: tipo_minutas(:one).id,
      clasificacion_id: clasificaciones(:one).id
    )
    assert_not minuta.save
  end

  test "Minuta sin 'h_inicio' no se guarda" do
    minuta = Minuta.new(
      correlativo: 1,
      codigo: 'MINUTA_G01_01_2020-2_1112',
      fecha_reunion: '2020-11-12',
      h_termino: '19:20',
      estudiante_id: estudiantes(:one).id,
      tipo_minuta_id: tipo_minutas(:one).id,
      clasificacion_id: clasificaciones(:one).id
    )
    assert_not minuta.save
  end

  test "Minuta sin 'h_termino' no se guarda" do
    minuta = Minuta.new(
      correlativo: 1,
      codigo: 'MINUTA_G01_01_2020-2_1112',
      fecha_reunion: '2020-11-12',
      h_inicio: '17:20',
      estudiante_id: estudiantes(:one).id,
      tipo_minuta_id: tipo_minutas(:one).id,
      clasificacion_id: clasificaciones(:one).id
    )
    assert_not minuta.save
  end

  test "Minuta con 'correlativo' menor a cero no se guarda" do
    minuta = Minuta.new(
      correlativo: -2,
      codigo: 'MINUTA_G01_01_2020-2_1112',
      fecha_reunion: '2020-11-12',
      h_inicio: '17:20',
      h_termino: '19:20',
      estudiante_id: estudiantes(:one).id,
      tipo_minuta_id: tipo_minutas(:one).id,
      clasificacion_id: clasificaciones(:one).id
    )
    assert_not minuta.save
  end

  test "Minuta con 'código' no válido no se guarda" do
    minuta = Minuta.new(
      correlativo: 1,
      codigo: 'MIN_G1_1_2020-2_1112',
      fecha_reunion: '2020-11-12',
      h_inicio: '17:20',
      h_termino: '19:20',
      estudiante_id: estudiantes(:one).id,
      tipo_minuta_id: tipo_minutas(:one).id,
      clasificacion_id: clasificaciones(:one).id
    )
    assert_not minuta.save
  end

  test "Minuta con datos válidos se guarda" do
    minuta = Minuta.new(
      correlativo: 1,
      codigo: 'MINUTA_G01_01_2020-2_1112',
      fecha_reunion: '2020-11-12',
      h_inicio: '17:20',
      h_termino: '19:20',
      estudiante_id: estudiantes(:one).id,
      tipo_minuta_id: tipo_minutas(:one).id,
      clasificacion_id: clasificaciones(:one).id
    )
    assert minuta.save
  end
end
