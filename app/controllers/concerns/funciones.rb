module Funciones
  extend ActiveSupport::Concern

  def obtener_iniciales(usuario)
    iniciales = ""
    iniciales += usuario.nombre.chr.upcase
    iniciales += usuario.apellido_paterno.chr.upcase
    iniciales += usuario.apellido_materno.chr.upcase
    return iniciales
  end

  def bitacoras_json(bitacoras)
    lista = []
    bitacoras.each do |bit|
      h = {id: bit.id, motivo: bit.motivo_min, revision: bit.revision_min,
        minuta: {
          id: bit.id_minuta, codigo: bit.codigo_min, correlativo: bit.correlativo_min, fecha_reunion: bit.fecha_min, tipo_minuta: bit.tipo_min, creada_por: bit.iniciales_est, creada_el: bit.creada_el
        },
        estado: {
          id: bit.id_estado, abreviacion: bit.abrev_estado, descripcion: bit.desc_estado
        }
      }
      lista << h
    end
    return lista
  end
end
