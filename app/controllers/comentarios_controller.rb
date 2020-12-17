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
      if to_boolean(c[:es_item])
        comentario.es_item = true
        comentario.id_item = c[:id_item]
      end
      if comentario.valid?
        comentario.save!
        nueva_actividad(bitacora.minuta_id, 'COM1')
        contador += 1
      end
    end
    aprobacion = Aprobacion.new
    aprobacion.bitacora_revision_id = bitacora.id
    aprobacion.asistencia_id = asistencia.id
    aprobacion.tipo_aprobacion_id = params[:tipo_aprobacion_id]
    if aprobacion.valid?
      aprobacion.save!
    end
    if bitacora.motivo.identificador == 'ECI'
      revisores = bitacora.minuta.asistencias.where(id_stakeholder: nil).size - bitacora.minuta.asistencias.where(id_estudiante: bitacora.minuta.estudiante_id).size
    elsif bitacora.motivo.identificador == 'ERC'
      revisores = bitacora.minuta.asistencias.where(id_estudiante: nil).size
    end
    revisiones = bitacora.aprobaciones.size
    if revisiones == revisores
      aprobadas_con_com = bitacora.aprobaciones.joins(:tipo_aprobacion).where('tipo_aprobaciones.identificador = ?', 'AC')
      rechazadas_con_com = bitacora.aprobaciones.joins(:tipo_aprobacion).where('tipo_aprobaciones.identificador = ?', 'RC')
      bitacora.minuta.bitacora_estados.where(activo: true).each do |bit|
        bit.activo = false
        bit.save
      end
      bitacora_estado = BitacoraEstado.new
      bitacora_estado.minuta_id = bitacora.minuta_id
      if aprobadas_con_com > 0 || rechazadas_con_com > 0
        if bitacora.motivo.identificador == 'ECI'
          bitacora_estado.tipo_estado_id = TipoEstado.find_by(abreviacion: 'CIG')
        elsif bitacora.motivo.identificador == 'ERC'
          bitacora_estado.tipo_estado_id = TipoEstado.find_by(abreviacion: 'CSK')
        end
      else
        bitacora_estado.tipo_estado_id = TipoEstado.find_by(abreviacion: 'CER')
      end
      if bitacora_estado.valid?
        bitacora_estado.save!
      end
    end
    if contador != params[:comentarios].size
      render json: ['error': 'Información de alguno de los comentarios no es válida'], status: :unprocessable_entity
    end
  end

end
