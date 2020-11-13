class MinutasController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  # Servicio que crea una minuta en el sistema
  def create
    bitacora = BitacoraRevision.new
    bitacora.build_minuta(minuta_params)
    bitacora.minuta.build_clasificacion(clasificacion_params)
    bitacora.build_tema
    bitacora.tema.tema = params[:tema].to_s
    bitacora.assign_attributes(revision_params)
    tipo_estado = TipoEstado.find(params[:tipo_estado])
    if tipo_estado.abreviacion.eql?('EMI')
      bitacora.emitida = true
    end
    if bitacora.valid?
      bitacora.save!
      nueva_actividad = Registro.create!(
        realizada_por: current_usuario.id,
        minuta_id: bitacora.minuta_id,
        tipo_actividad_id: TipoActividad.find_by(identificador: 'M1').id
      )
      nueva_actividad = Registro.create!(
        realizada_por: current_usuario.id,
        minuta_id: bitacora.minuta_id,
        tipo_actividad_id: TipoActividad.find_by(identificador: 'M2').id
      )
      nueva_actividad = Registro.create!(
        realizada_por: current_usuario.id,
        minuta_id: bitacora.minuta_id,
        tipo_actividad_id: TipoActividad.find_by(identificador: 'T1').id
      )
      nueva_actividad = Registro.create!(
        realizada_por: current_usuario.id,
        minuta_id: bitacora.minuta_id,
        tipo_actividad_id: TipoActividad.find_by(identificador: 'M4').id
      )
      params[:objetivos].each do |obj|
        objetivo = Objetivo.new
        objetivo.descripcion = obj
        objetivo.bitacora_revision_id = bitacora.id
        if objetivo.valid?
          objetivo.save!
          nueva_actividad = Registro.create!(
            realizada_por: current_usuario.id,
            minuta_id: bitacora.minuta_id,
            tipo_actividad_id: TipoActividad.find_by(identificador: 'O1').id
          )
        end
      end
      params[:conclusiones].each do |con|
        conclusion = Conclusion.new
        conclusion.descripcion = con
        conclusion.bitacora_revision_id = bitacora.id
        if conclusion.valid?
          conclusion.save!
          nueva_actividad = Registro.create!(
            realizada_por: current_usuario.id,
            minuta_id: bitacora.minuta_id,
            tipo_actividad_id: TipoActividad.find_by(identificador: 'C1').id
          )
        end
      end
      params[:asistencia].each do |a|
        asistencia = Asistencia.new
        asistencia.minuta_id = bitacora.minuta.id
        unless a[:estudiante] == ''
          asistencia.id_estudiante = a[:estudiante]
        end
        asistencia.tipo_asistencia_id = a[:asistencia]
        if asistencia.valid?
          asistencia.save!
        end
      end
      nueva_actividad = Registro.create!(
        realizada_por: current_usuario.id,
        minuta_id: bitacora.minuta_id,
        tipo_actividad_id: TipoActividad.find_by(identificador: 'M3').id
      )
      asistencias = Asistencia.where('minuta_id = ?', bitacora.minuta.id)
      params[:items].each do |i|
        item = Item.new
        item.descripcion = i[:descripcion]
        item.correlativo = i[:correlativo]
        item.bitacora_revision_id = bitacora.id
        item.tipo_item_id = i[:tipo_item_id]
        unless i[:fecha] == ''
          item.fecha = i[:fecha]
        end
        i[:responsables].each do |resp|
          unless (resp.nil? || resp == '' || resp.to_i == 0)
            responsable = Responsable.new
            responsable.asistencia_id = asistencias.find_by(id_estudiante: resp).id
            if responsable.valid?
              responsable.save!
              item.responsables << responsable
              nueva_actividad = Registro.create!(
                realizada_por: current_usuario.id,
                minuta_id: bitacora.minuta_id,
                tipo_actividad_id: TipoActividad.find_by(identificador: 'R1').id
              )
            end
          end
        end
        if item.valid?
          item.save!
          nueva_actividad = Registro.create!(
            realizada_por: current_usuario.id,
            minuta_id: bitacora.minuta_id,
            tipo_actividad_id: TipoActividad.find_by(identificador: 'M5').id
          )
          unless i[:fecha] == ''
            nueva_actividad = Registro.create!(
              realizada_por: current_usuario.id,
              minuta_id: bitacora.minuta_id,
              tipo_actividad_id: TipoActividad.find_by(identificador: 'F1').id
            )
          end
        end
      end
      bitacora_estado = BitacoraEstado.new
      bitacora_estado.minuta_id = bitacora.minuta.id
      bitacora_estado.tipo_estado_id = tipo_estado.id
      if bitacora_estado.valid?
        bitacora_estado.save!
      end
    else
      render json: ['error': 'Información de la minuta no es válida'], status: :unprocessable_entity
    end
  end

  # Servicio que entrega el número correlativo siguiente para la nueva minuta del grupo
  def correlativo
    ultima = Minuta.joins(estudiante: :grupo).where('grupos.id = ? AND minutas.borrado = ?', params[:id], false).last
    if ultima.nil?
      correlativo = 1
    else
      correlativo = ultima.correlativo + 1
    end
    render json: correlativo.as_json
  end

  private
  def minuta_params
    params.require(:minuta).permit(:estudiante_id, :correlativo, :codigo, :fecha_reunion, :h_inicio, :h_termino, :tipo_minuta_id)
  end

  def clasificacion_params
    params.require(:clasificacion).permit(:informativa, :avance, :coordinacion, :decision, :otro)
  end

  def revision_params
    params.require(:bitacora_revision).permit(:revision, :motivo_id)
  end

end
