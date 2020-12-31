class RegistrosController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  # Servicio que entrega los registros de una minuta identificada por su id
  def show
    registros = Registro.joins(minuta: :bitacora_revisiones).joins('INNER JOIN usuarios ON registros.realizada_por = usuarios.id').joins(:tipo_actividad).select('
      registros.id,
      registros.realizada_por AS realizada,
      registros.minuta_id AS id_minuta,
      registros.created_at AS realizada_el,
      tipo_actividades.id AS tipo_actividad_id,
      tipo_actividades.actividad AS registro_act,
      tipo_actividades.descripcion AS registro_desc,
      tipo_actividades.identificador As registro_iden,
      usuarios.id AS usuario_id,
      usuarios.nombre AS nombre_usuario,
      usuarios.apellido_paterno AS apellido1,
      usuarios.apellido_materno AS apellido2
      ').where('bitacora_revisiones.id = ?', params[:id].to_i).order(created_at: 'desc')
    lista = []
    registros.each do |reg|
      h = {id: reg.id, realizada_por: reg.realizada, minuta_id: reg.id_minuta, created_at: reg.realizada_el,
        tipo_actividad: {id: reg.tipo_actividad_id, actividad: reg.registro_act, descripcion: reg.registro_desc, identificador: reg.registro_iden},
        usuario: {id: reg.usuario_id, nombre: reg.nombre_usuario, apellido_paterno: reg.apellido1, apellido_materno: reg.apellido2, iniciales: ''}
      }
      h[:usuario][:iniciales] = obtener_iniciales_hash(h[:usuario])
      lista << h
    end
    render json: lista.as_json()
  end

  private
  def obtener_iniciales_hash(usuario)
    iniciales = ''
    iniciales += usuario[:nombre].chr.upcase
    iniciales += usuario[:apellido_paterno].chr.upcase
    iniciales += usuario[:apellido_materno].chr.upcase
    return iniciales
  end
end
