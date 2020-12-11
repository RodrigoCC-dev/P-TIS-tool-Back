class ComentariosController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat
  include Funciones

  # Servicio que permite guardar los comentarios realizados a una minuta de reunión
  def create
    bitacora = BitacoraRevision.find(params[:id])
    if current_usuario.rol.rango == 3
      asistencia = bitacora.minuta.asistencias.find_by(id_estudiante: Estudiante.find_by(usuario_id: current_usuario.id).id)
    elsif current_usuario.rol.rango == 4
      asistencia = bitacora.minuta.asistencias.find_by(id_stakeholder: Stakeholder.find_by(usuario_id: current_usuario.id).id)
    end
    contador = 0
    params[:comentarios].each do |c|
      comentario = Comentario.new
      comentario.comentario = c[:comentario]
      comentario.asistencia_id = asistencia.id
      comentario.bitacora_revision_id = bitacora.id
      if c[:es_item]
        comentario.es_item = true
        comentario.id_item = c[:id_item]
      end
      if comentario.valid?
        comentario.save!
        nueva_actividad(bitacora.minuta_id, 'COM1')
        contador += 1
      end
    end
    if contador != params[:comentarios].size
      render json: ['error': 'Información de alguno de los comentarios no es válida'], status: :unprocessable_entity
    end
  end

end
