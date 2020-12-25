class RespuestasController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat
  include Funciones

  # Servicio que permite guardar las respuestas a los comentarios de una minuta
  def create
    bitacora = BitacoraRevision.find(params[:id])
    if current_usuario.rol.rango == 3
      asistencia = bitacora.minuta.asistencias.find_by(id_estudiante: Estudiante.find_by(usuario_id: current_usuario.id).id)
    elsif current_usuario.rol.rango == 4
      asistencia = bitacora.minuta.asistencias.find_by(id_stakeholder: Stakeholder.find_by(usuario_id: current_usuario.id).id)
    end
    contador = 0
    params[:respuestas].each do |resp|
      if resp[:respuesta] != ''
        respuesta = Respuesta.new
        respuesta.respuesta = resp[:respuesta]
        respuesta.comentario_id = resp[:comentario_id]
        respuesta.asistencia_id = asistencia.id
        if respuesta.valid?
          respuesta.save!
          contador += 1
          nueva_actividad(bitacora.minuta_id, 'RE1')
        end
      end
    end
    if contador > 0
      bitacora.minuta.bitacora_estados.where(activo: true).each do |bit|
        bit.activo = false
        bit.save
      end
      bitacora_estado = BitacoraEstado.new
      bitacora_estado.minuta_id = bitacora.minuta_id
      if current_usuario.rol.rango == 3
        bitacora_estado.tipo_estado_id = TipoEstado.find_by(abreviacion: 'RIG').id
      elsif current_usuario.rol.rango == 4
        bitacora_estado.tipo_estado_id = TipoEstado.find_by(abreviacion: 'RSK').id
      end
      if bitacora_estado.valid?
        bitacora_estado.save!
      end
    end
    if contador != params[:respuestas].size
      render json: ['error': 'Falta alguna de las respuestas a los comentarios'], status: :unprocessable_entity
    end
  end
end
