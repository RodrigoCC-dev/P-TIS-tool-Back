class MinutasController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat
  include Funciones

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
      bitacora.fecha_emision = Time.now
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
        objetivo.descripcion = obj[:descripcion]
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
        conclusion.descripcion = con[:descripcion]
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
          unless (resp.nil? || resp == '' || resp[:id] == 0)
            responsable = Responsable.new
            if resp[:tipo] == 'est'
              responsable.asistencia_id = asistencias.find_by(id_estudiante: resp[:id]).id
            elsif resp[:tipo] == 'stk'
              responsable.asistencia_id = asistencias.find_by(id_stakeholder: resp[:id]).id
            end
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

  # Servicio que entrega la información de una minuta a partir del 'id' de su bitácora de revisión
  def show
    bitacora = BitacoraRevision.joins(minuta: {estudiante: :grupo}).joins(minuta: :tipo_minuta).joins(minuta: :clasificacion).joins(:motivo).joins(:tema).select('
      bitacora_revisiones.id AS id_bitacora,
      bitacora_revisiones.revision AS rev_min,
      motivos.motivo AS motivo_min,
      temas.tema AS tema_min,
      minutas.id AS id_minuta,
      minutas.codigo AS codigo_min,
      minutas.correlativo AS correlativo_min,
      minutas.fecha_reunion AS fecha_min,
      minutas.h_inicio AS hora_ini,
      minutas.h_termino AS hora_ter,
      minutas.created_at AS creada_el,
      estudiantes.iniciales AS iniciales_est,
      tipo_minutas.tipo AS tipo_min,
      clasificaciones.informativa AS informativa_min,
      clasificaciones.avance AS avance_min,
      clasificaciones.coordinacion AS coordinacion_min,
      clasificaciones.decision AS decision_min,
      clasificaciones.otro AS otro_min
      ').find(params[:id])
    asistencia = Asistencia.joins(:tipo_asistencia).select('
      asistencias.id,
      asistencias.id_estudiante AS id_est,
      asistencias.id_stakeholder AS id_stake,
      tipo_asistencias.tipo AS tipo_abrev,
      tipo_asistencias.descripcion AS tipo_desc
      ').where('minuta_id = ?', bitacora.id_minuta)
    lista_asistencia = []
    asistencia.each do |asis|
      unless asis.id_est.nil?
        participante = Estudiante.find(asis.id_est)
      else
        unless asis.id_stake.nil?
          participante = Stakeholder.find(asis.id_stake)
        else
          participante = nil
        end
      end
      unless participante.nil?
        a = {id: asis.id, iniciales: participante.iniciales, tipo: asis.tipo_abrev, descripcion: asis.tipo_desc}
      end
      lista_asistencia << a
    end
    objetivos = Objetivo.where(bitacora_revision_id: bitacora.id_bitacora)
    objetivos_json = objetivos.as_json(json_data)
    conclusiones = Conclusion.where(bitacora_revision_id: bitacora.id_bitacora)
    conclusiones_json = conclusiones.as_json(json_data)
    items = Item.joins(:tipo_item).select('
      items.id,
      tipo_items.tipo AS item_tipo,
      items.correlativo AS corr_item,
      items.descripcion AS cuerpo_item,
      items.fecha AS fecha_item').where(bitacora_revision_id: bitacora.id_bitacora)
    lista_items = []
    items.each do |i|
      responsables = i.responsables.as_json(json_data)
      item = {id: i.id, tipo: i.item_tipo, correlativo: i.corr_item, descripcion: i.cuerpo_item, fecha: i.fecha_item, responsables: responsables}
      lista_items << item
    end
    h = {
      id: bitacora.id_bitacora, revision: bitacora.rev_min, motivo: bitacora.motivo_min,
      minuta: {
        id: bitacora.id_minuta, codigo: bitacora.codigo_min, correlativo: bitacora.correlativo_min, tema: bitacora.tema_min, creada_por: bitacora.iniciales_est, creada_el: bitacora.creada_el, tipo: bitacora.tipo_min,
        fecha_reunion: bitacora.fecha_min, h_inicio: bitacora.hora_ini, h_termino: bitacora.hora_ter,
        clasificacion: {
          informativa: bitacora.informativa_min, avance: bitacora.avance_min, coordinacion: bitacora.coordinacion_min, decision: bitacora.decision_min, otro: bitacora.otro_min
        }, objetivos: objetivos_json, conclusiones: conclusiones_json, asistencia: lista_asistencia, items: lista_items
      }
    }
    render json: h.as_json
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

  # Servicio que entrega la lista de minutas emitidas por un grupo
  def por_grupo
    bitacoras = BitacoraRevision.joins(minuta: {estudiante: :grupo}).joins(minuta: :tipo_minuta).joins(:motivo).select('
      bitacora_revisiones.id AS id_bitacora,
      bitacora_revisiones.revision AS rev_min,
      motivos.motivo AS motivo_min,
      minutas.id AS id_minuta,
      minutas.codigo AS codigo_min,
      minutas.created_at AS creada_el,
      estudiantes.iniciales AS iniciales_est,
      tipo_minutas.tipo AS tipo_min
      ').where('grupos.id = ? AND minutas.borrado = ? AND bitacora_revisiones.emitida = ?', params[:id], false, true)
    minutas = []
    bitacoras.each do |bit|
      h = {
        id: bit.id_bitacora, revision: bit.rev_min, motivo: bit.motivo_min,
        minuta: {
          id: bit.id_minuta, codigo: bit.codigo_min, creada_por: bit.iniciales_est, creada_el: bit.creada_el, tipo: bit.tipo_min,
        }
      }
      minutas << h
    end
    render json: minutas.as_json
  end

  # Servicio que entrega el listado de minutas de un estudiante según sus estados de revisión
  def por_estados
    if current_usuario.rol.rango === 3
      bitacoras = BitacoraRevision.joins('INNER JOIN motivos ON motivos.id = bitacora_revisiones.motivo_id INNER JOIN minutas ON bitacora_revisiones.minuta_id = minutas.id
        INNER JOIN bitacora_estados ON bitacora_estados.minuta_id = minutas.id INNER JOIN tipo_estados ON tipo_estados.id = bitacora_estados.tipo_estado_id
        INNER JOIN tipo_minutas ON tipo_minutas.id = minutas.tipo_minuta_id INNER JOIN estudiantes ON estudiantes.id = minutas.estudiante_id').where('
        minutas.borrado = ? AND estudiantes.usuario_id = ? AND bitacora_revisiones.activa = ? AND tipo_minutas.tipo <> ?', false, current_usuario.id, true, 'Semanal').select('
          bitacora_revisiones.id,
          bitacora_revisiones.revision AS revision_min,
          bitacora_revisiones.fecha_emision AS fecha_emi,
          motivos.motivo AS motivo_min,
          tipo_minutas.tipo AS tipo_min,
          minutas.id AS id_minuta,
          minutas.codigo AS codigo_min,
          minutas.correlativo AS correlativo_min,
          minutas.fecha_reunion AS fecha_min,
          minutas.created_at AS creada_el,
          bitacora_estados.id AS id_estado,
          tipo_estados.abreviacion AS abrev_estado,
          tipo_estados.descripcion AS desc_estado,
          estudiantes.iniciales AS iniciales_est
        ')
      lista_bitacoras = bitacoras_json(bitacoras)
      render json: lista_bitacoras.as_json(json_data)
    else
      render json: ['error': 'No es un usuario autorizado para este servicio'], status: :unprocessable_entity
    end
  end

  # Servicio que entrega las minutas creadas por los integrantes del grupo para la revisión del estudiante
  def revision_grupo
    if current_usuario.rol.rango === 3
      estudiante = Estudiante.find_by(usuario_id: current_usuario.id)
      bitacoras = BitacoraRevision.joins('INNER JOIN motivos ON motivos.id = bitacora_revisiones.motivo_id INNER JOIN minutas ON bitacora_revisiones.minuta_id = minutas.id
        INNER JOIN bitacora_estados ON bitacora_estados.minuta_id = minutas.id INNER JOIN tipo_estados ON tipo_estados.id = bitacora_estados.tipo_estado_id
        INNER JOIN tipo_minutas ON tipo_minutas.id = minutas.tipo_minuta_id INNER JOIN estudiantes ON estudiantes.id = minutas.estudiante_id
        INNER JOIN grupos ON grupos.id = estudiantes.grupo_id').where('minutas.borrado = ? AND estudiantes.usuario_id <> ? AND bitacora_revisiones.activa = ? AND
        grupos.id = ? AND motivos.identificador = ? AND tipo_minutas.tipo <> ? AND bitacora_revisiones.emitida = ?', false, current_usuario.id, true, estudiante.grupo_id, 'ECI', 'Semanal', true).select('
          bitacora_revisiones.id,
          bitacora_revisiones.revision AS revision_min,
          bitacora_revisiones.fecha_emision AS fecha_emi,
          motivos.motivo AS motivo_min,
          tipo_minutas.tipo AS tipo_min,
          minutas.id AS id_minuta,
          minutas.codigo AS codigo_min,
          minutas.correlativo AS correlativo_min,
          minutas.fecha_reunion AS fecha_min,
          minutas.created_at AS creada_el,
          bitacora_estados.id AS id_estado,
          tipo_estados.abreviacion AS abrev_estado,
          tipo_estados.descripcion AS desc_estado,
          estudiantes.iniciales AS iniciales_est
        ')
      lista_bitacoras = bitacoras_json(bitacoras)
      render json: lista_bitacoras.as_json(json_data)
    else
      render json: ['error': 'No es un usuario autorizado para este servicio'], status: :unprocessable_entity
    end
  end

  # Servicio que entrega las minutas a revisar por un stakeholder
  def revision_cliente
    if current_usuario.rol.rango == 4
      stakeholder = Stakeholder.find_by(usuario_id: current_usuario.id)
      bitacoras = BitacoraRevision.joins('INNER JOIN motivos ON motivos.id = bitacora_revisiones.motivo_id INNER JOIN minutas ON bitacora_revisiones.minuta_id = minutas.id
        INNER JOIN bitacora_estados ON bitacora_estados.minuta_id = minutas.id INNER JOIN tipo_estados ON tipo_estados.id = bitacora_estados.tipo_estado_id
        INNER JOIN tipo_minutas ON tipo_minutas.id = minutas.tipo_minuta_id INNER JOIN estudiantes ON estudiantes.id = minutas.estudiante_id
        INNER JOIN grupos ON grupos.id = estudiantes.grupo_id').where('minutas.borrado = ? AND bitacora_revisiones.activa = ? AND grupos.id = ? AND motivos.identificador <> ?
        AND tipo_estados.abreviacion = ? AND tipo_estados.abreviacion = ? AND tipo_estados.abreviacion = ? AND tipo_estados.abreviacion = ? AND
        tipo_estados.abreviacion = ? AND tipo_minutas.tipo <> ? AND bitacora_revisiones.emitida = ?',
        false, true, stakeholder.grupo_id, 'ECI', 'RIG', 'RSK', 'CER', 'EMI', 'CSK', 'Semanal', true).select('
          bitacora_revisiones.id,
          bitacora_revisiones.revision AS revision_min,
          bitacora_revisiones.fecha_emision AS fecha_emi,
          motivos.motivo AS motivo_min,
          tipo_minutas.tipo AS tipo_min,
          minutas.id AS id_minuta,
          minutas.codigo AS codigo_min,
          minutas.correlativo AS correlativo_min,
          minutas.fecha_reunion AS fecha_min,
          minutas.created_at AS creada_el,
          bitacora_estados.id AS id_estado,
          tipo_estados.abreviacion AS abrev_estado,
          tipo_estados.descripcion AS desc_estado,
          estudiantes.iniciales AS iniciales_est
        ')
      lista_bitacoras = bitacoras_json(bitacoras)
      render json: lista_bitacoras.as_json(json_data)
    else
      render json: ['error': 'No es un usuario autorizado para este servicio'], status: :unprocessable_entity
    end
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
