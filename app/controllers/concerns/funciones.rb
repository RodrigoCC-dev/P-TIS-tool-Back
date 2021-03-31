module Funciones
  extend ActiveSupport::Concern

  def obtener_iniciales(usuario)
    iniciales = ""
    iniciales += usuario.nombre.parameterize.chr.upcase
    iniciales += usuario.apellido_paterno.parameterize.chr.upcase
    iniciales += usuario.apellido_materno.parameterize.chr.upcase
    return iniciales
  end

  def bitacoras_json(bitacoras)
    lista = []
    bitacoras.each do |bit|
      h = {id: bit.id, motivo: bit.motivo_min, identificador: bit.motivo_ident, revision: bit.revision_min, fecha_emision: bit.fecha_emi,
        minuta: {
          id: bit.id_minuta, codigo: bit.codigo_min, correlativo: bit.correlativo_min, fecha_reunion: bit.fecha_min, tipo_minuta: bit.tipo_min, creada_por: bit.iniciales_est, creada_el: bit.creada_el
        },
        estado: {
          id: bit.id_estado, abreviacion: bit.abrev_estado, descripcion: bit.desc_estado, inicia_el: bit.cambia_estado_el
        }
      }
      lista << h
    end
    return lista
  end

  def nueva_actividad(minuta_id, identificador)
    Registro.create!(
      realizada_por: current_usuario.id,
      minuta_id: minuta_id,
      tipo_actividad_id: TipoActividad.find_by(identificador: identificador).id
    )
  end

  def to_boolean(obj)
    if obj.to_s.downcase == 'true'
      return true
    elsif obj.to_s.downcase == 'false'
      return false
    else
      return nil
    end
  end

  def calcular_revisores(bitacora_id)
    bitacora = BitacoraRevision.find(bitacora_id)
    revisores = 0
    if bitacora.motivo.identificador == 'ECI'
      revisores = bitacora.minuta.asistencias.where(id_stakeholder: nil).where.not(id_estudiante: nil).size - bitacora.minuta.asistencias.where(id_estudiante: bitacora.minuta.estudiante_id).size
    elsif bitacora.motivo.identificador == 'ERC' || bitacora.motivo.identificador == 'EAC'
      revisores = bitacora.minuta.asistencias.where(id_estudiante: nil).where.not(id_stakeholder: nil).size
    elsif bitacora.motivo.identificador == 'EF'
      if bitacora.minuta.tipo_minuta.tipo == 'Coordinacion'
        revisores = bitacora.minuta.asistencias.where(id_stakeholder: nil).where.not(id_estudiante: nil).size - bitacora.minuta.asistencias.where(id_estudiante: bitacora.minuta.estudiante_id).size
      elsif bitacora.minuta.tipo_minuta.tipo == 'Cliente'
        revisores = bitacora.minuta.asistencias.where(id_estudiante: nil).where.not(id_stakeholder: nil).size
      end
    end
    return revisores
  end

  def nueva_password(nombre)
    return nombre.parameterize.titleize.split(' ').join + '123'
  end
end
