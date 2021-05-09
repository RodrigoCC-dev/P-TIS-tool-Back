class RespuestasController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat
  include Funciones

  # Servicio que permite guardar las respuestas a los comentarios de una minuta
  def create
    bitacora = BitacoraRevision.find(params[:id])
    if current_usuario.rol.rango == 3
      asistencia = bitacora.minuta.asistencias.find_by(id_estudiante: Estudiante.find_by(usuario_id: current_usuario.id).id)
      es_estudiante = true
    elsif current_usuario.rol.rango == 4
      asistencia = bitacora.minuta.asistencias.find_by(id_stakeholder: Stakeholder.find_by(usuario_id: current_usuario.id).id)
      es_estudiante = false
    end
    params[:respuestas].each do |resp|
      if resp[:respuesta] != ''
        respuesta = Respuesta.new
        respuesta.respuesta = resp[:respuesta]
        respuesta.comentario_id = resp[:comentario_id]
        respuesta.asistencia_id = asistencia.id
        if respuesta.valid?
          respuesta.save!
          nueva_actividad(bitacora.minuta_id, 'RE1')
        end
      end
    end
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
    if es_estudiante && bitacora.motivo.identificador == 'ERC'
      EstudiantesMailer.respuestaAlCliente(bitacora).deliver_later
    end
  end

  # Servicio que entrega las respuestas de una minuta identificada por su bitacora_revision a través de su id
  def show
    respuestas = Comentario.where(bitacora_revision_id: params[:id].to_i)
    render json: respuestas.as_json(
      { except: %i[borrado created_at updated_at deleted_at], :include => {
        :respuestas => json_data
        }
      }
    )
  end
end
