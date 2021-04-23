class AprobacionesController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat
  include Funciones

  #Servicio que entrega las aprobaciones de una minuta de reunión según su bitacora_revisiones.id
  def show
    bitacora = BitacoraRevision.find(params[:id].to_i)
    render json: bitacora.aprobaciones.as_json(
      { except: %i[created_at updated_at], :include => {
        :tipo_aprobacion => json_data
        }
      }
    )
  end

  # Servicio que permite actualizar una aprobación de una minuta de reunión
  def update
    bitacora = BitacoraRevision.find(params[:id].to_i)
    if current_usuario.rol.rango > 2 && current_usuario.rol.rango < 5
      if current_usuario.rol.rango == 3
        estudiante = Estudiante.find_by(usuario_id: current_usuario.id)
        asistencia = Asistencia.where(minuta_id: bitacora.minuta_id, id_estudiante: estudiante.id).first
        es_estudiante = true
      elsif current_usuario.rol.rango == 4
        stakeholder = Stakeholder.find_by(usuario_id: current_usuario.id)
        asistencia = Asistencia.where(minuta_id: bitacora.minuta_id, id_stakeholder: stakeholder.id).first
        es_estudiante = false
      end
      aprobacion = Aprobacion.where(bitacora_revision_id: bitacora.id, asistencia_id: asistencia.id).first
      unless aprobacion.nil?
        aprobacion.tipo_aprobacion_id = params[:tipo_aprobacion_id].to_i
        if aprobacion.valid?
          aprobacion.save!
          revisores = calcular_revisores(bitacora.id)
          revisiones = bitacora.aprobaciones.size
          if revisiones == revisores
            bitacora.minuta.bitacora_estados.where(activo: true).each do |bit|
              bit.activo = false
              bit.save
            end
            bitacora_estado = BitacoraEstado.new
            bitacora_estado.minuta_id = bitacora.minuta_id
            bitacora_estado.tipo_estado_id = TipoEstado.find_by(abreviacion: 'CER').id
            if bitacora_estado.valid?
              bitacora_estado.save
            end
          end
          unless es_estudiante
            StakeholdersMailer.aprobacionMinuta(bitacora, current_usuario).deliver_later
          end
        else
          render json: ['error': 'No se ha podido actualizar el estado de aprobación'], status: :unprocessable_entity
        end
      else
        render json: ['error': 'No se ha aprobado la minuta previamente por este usuario'], status: :unprocessable_entity
      end
    else
      render json: ['error': 'Servicio no permitido para este usuario'], status: :unprocessable_entity
    end
  end
end
