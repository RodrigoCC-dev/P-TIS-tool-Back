require 'test_helper'

class RespuestumTest < ActiveSupport::TestCase
  test "Respuesta sin 'respuesta' no se guarda" do
    respuesta = Respuesta.new(
      comentario_id: comentarios(:one).id,
      asistencia_id: asistencias(:one).id
    )
    assert_not respuesta.save
  end

  test "Respuesta con 'respuesta' se guarda" do
    respuesta = Respuesta.new(
      respuesta: 'respuesta de prueba',
      comentario_id: comentarios(:one).id,
      asistencia_id: asistencias(:one).id
    )
    assert respuesta.save
  end

  test "Respuesta con 'borrado' en 'nil' no se guarda" do
    respuesta = Respuesta.new(
      respuesta: 'respuesta de prueba',
      comentario_id: comentarios(:one).id,
      asistencia_id: asistencias(:one).id,
      borrado: nil
    )
    assert_not respuesta.save
  end

  test "Respuesta con 'borrado' en 'true' se guarda" do
    respuesta = Respuesta.new(
      respuesta: 'respuesta de prueba',
      comentario_id: comentarios(:one).id,
      asistencia_id: asistencias(:one).id,
      borrado: true
    )
    assert respuesta.save
  end

  test "Respuesta con 'borrado' en 'false' se guarda" do
    respuesta = Respuesta.new(
      respuesta: 'respuesta de prueba',
      comentario_id: comentarios(:one).id,
      asistencia_id: asistencias(:one).id,
      borrado: false
    )
    assert respuesta.save
  end
end
