require 'test_helper'

class AsistenciaTest < ActiveSupport::TestCase
  test "Asistencia con 'id_estudiante' menor a 'cero' no se guarda" do
    asistencia = Asistencia.new(
      id_estudiante: -2,
      minuta_id: minutas(:one).id,
      tipo_asistencia_id: tipo_asistencias(:one).id
    )
    assert_not asistencia.save
  end

  test "Asistencia con 'id_stakeholder' menor a 'cero' no se guarda" do
    asistencia = Asistencia.new(
      id_stakeholder: -2,
      minuta_id: minutas(:one).id,
      tipo_asistencia_id: tipo_asistencias(:one).id
    )
    assert_not asistencia.save
  end

  test "Asistencia con 'id_estudiante' nil se guarda" do
    asistencia = Asistencia.new(
      id_stakeholder: 5,
      minuta_id: minutas(:one).id,
      tipo_asistencia_id: tipo_asistencias(:one).id
    )
    assert asistencia.save
  end

  test "Asistencia con 'id_stakeholder' nil se guarda" do
    asistencia = Asistencia.new(
      id_estudiante: 5,
      minuta_id: minutas(:one).id,
      tipo_asistencia_id: tipo_asistencias(:one).id
    )
    assert asistencia.save
  end

  test "Asistencia sin 'id_estudiante' ni 'id_stakeholder' no se guarda" do
    asistencia = Asistencia.new(
      minuta_id: minutas(:one).id,
      tipo_asistencia_id: tipo_asistencias(:one).id
    )
    assert_not asistencia.save
  end
end
