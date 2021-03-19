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

  # Servicio que entrega la suma de actividades realizadas por cada integrante de un grupo
  def actividades_minutas
    if current_usuario.rol.rango < 3
      grupo = Grupo.find(params[:grupo])
      registros = Registro.find_by_sql ['SELECT usuarios.id, usuarios.nombre, usuarios.apellido_paterno, usuarios.apellido_materno, tipo_actividades.actividad,
        tipo_actividades.identificador, COUNT(tipo_actividades.actividad) FROM registros INNER JOIN tipo_actividades ON registros.tipo_actividad_id = tipo_actividades.id
        INNER JOIN usuarios ON usuarios.id = registros.realizada_por INNER JOIN estudiantes ON estudiantes.usuario_id = usuarios.id INNER JOIN grupos ON grupos.id = estudiantes.grupo_id
        WHERE grupos.id = :grupo_id GROUP BY usuarios.id, tipo_actividades.actividad, tipo_actividades.identificador', {:grupo_id => grupo.id}]
      lista = []
      grupo.estudiantes.each do |est|
        minuta = 0
        objetivos = 0
        conclusiones = 0
        tema = 0
        items = 0
        comentarios = 0
        respuestas = 0
        registros.each do |reg|
          if reg.id == est.usuario_id
            case reg.identificador
            when 'M1', 'M2', 'M3', 'M4', 'M8', 'M9', 'M10'
              minuta += reg.count
            when 'O1', 'O2', 'O3'
              objetivos += reg.count
            when 'C1', 'C2', 'C3'
              conclusiones += reg.count
            when 'T1', 'T2'
              tema += reg.count
            when 'M5', 'R1', 'F1', 'M6', 'R2', 'F2', 'M7', 'R3', 'F3'
              items += reg.count
            when 'COM1', 'COM2', 'COM3'
              comentarios += reg.count
            when 'RE1', 'RE2', 'RE3'
              respuestas += reg.count
            end
          end
        end
        h = {id: est.id, iniciales: est.iniciales, usuario: {id: est.usuario.id, nombre: est.usuario.nombre, apellido_paterno: est.usuario.apellido_paterno, apellido_materno: est.usuario.apellido_materno,
          run: est.usuario.run, registros: {minutas: minuta, tema: tema, objetivos: objetivos, conclusiones: conclusiones, items: items, comentarios: comentarios, respuestas: respuestas}}}
        lista << h
      end
      render json: lista.as_json()
    else
      render json: ['Error': 'Este usuario no tiene permisos para este servicio'], status: :unprocessable_entity
    end
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
