class GruposController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  # Servicio que muestra el listado de grupos en el sistema y los estudiantes asignados
  def index
    grupos = Grupo.where('borrado = ? AND nombre <> ?', false, 'SG')
    estudiantes = Estudiante.joins(:grupo).joins(:usuario).joins(seccion: :jornada).where('grupos.borrado = ? AND grupos.nombre <> ?', false, 'SG').select('
      estudiantes.id,
      estudiantes.iniciales AS iniciales_est,
      usuarios.nombre AS nombre_est,
      usuarios.apellido_paterno AS apellido1,
      usuarios.apellido_materno AS apellido2,
      usuarios.run AS run_est,
      usuarios.email AS email_est,
      jornadas.nombre AS jornada,
      grupos.id AS id_grupo
    ')
    @grupos = []
    grupos.each do |g|
      est_asignados = asignados(g.id, estudiantes)
      lista_est = []
      est_asignados.each do |e|
        h = {id: e.id, iniciales: e.iniciales_est, usuario: {nombre: e.nombre_est, apellido_paterno: e.apellido1, apellido_materno: e.apellido2, run: e.run_est, email: e.email_est}}
        lista_est << h
      end
      stakeholders = Stakeholder.where(grupo_id: g.id)
      if est_asignados.size > 0
        jornada = est_asignados[0].jornada
      else
        jornada = ''
      end
      h = {id: g.id, nombre: g.nombre, proyecto: g.proyecto, correlativo: g.correlativo, jornada: jornada, estudiantes: lista_est, stakeholders: stakeholders.as_json(
        {except: %i[usuario_id grupo_id created_at deleted_at], :include => {:usuario => user_data}}
        )}
      @grupos << h
    end
    render json: @grupos.as_json
  end

  # Servicio para crear un nuevo grupo de estudiantes en el sistema
  def create
    grupo = Grupo.new(grupo_params)
    if grupo.valid?
      grupo.save!
      estudiantes = Estudiante.where(id: params[:estudiantes])
      estudiantes.each do |e|
        e.grupo_id = grupo.id
        e.save!
      end
    else
      render json: ['error': 'Información del grupo no es válida'], status: :unprocessable_entity
    end
  end

  # Servicio que entrega los estudiantes de un grupo en particular
  def show
    grupo = Grupo.find(params[:id])
    if grupo
      estudiantes = Estudiante.joins(:grupo).joins(:usuario).where('grupos.id = ?', grupo.id).select('
        estudiantes.id AS id_est,
        estudiantes.iniciales AS iniciales_est,
        usuarios.nombre AS nombre_est,
        usuarios.apellido_paterno AS apellido1,
        usuarios.apellido_materno AS apellido2')
      asignados = []
      estudiantes.each do |e|
        h = {id: e.id_est, iniciales: e.iniciales_est, nombre: e.nombre_est, apellido_paterno: e.apellido1, apellido_materno: e.apellido2}
        asignados << h
      end
      clientes = []
      grupo.stakeholders.each do |stk|
        h = {id: stk.id, iniciales: stk.iniciales, nombre: stk.usuario.nombre, apellido_paterno: stk.usuario.apellido_paterno, apellido_materno: stk.usuario.apellido_materno}
        clientes << h
      end
      datos = {id: grupo.id, nombre: grupo.nombre, proyecto: grupo.proyecto, correlativo: grupo.correlativo, estudiantes: asignados, stakeholders: clientes}
    else
      datos = []
    end
    render json: datos.as_json
  end

  # Servicio que entrega el último grupo de estudiantes disponibles asociados a una jornada
  def ultimo_grupo
    grupo = Estudiante.joins(:grupo).joins(seccion: :jornada).where('grupos.borrado = ? AND grupos.nombre <> ? AND jornadas.nombre = ?', false, 'SG', params[:jornada]).select('
      grupos.id,
      grupos.nombre,
      grupos.correlativo
      ').order('grupos.correlativo DESC').limit(1)
    render json: grupo[0].as_json(json_data)
  end

  private
  def grupo_params
    params.require(:grupo).permit(:nombre, :proyecto, :correlativo)
  end

  def asignados(grupo_id, estudiantes)
    lista = []
    estudiantes.each do |e|
      if e.id_grupo == grupo_id
        lista << e
      end
    end
    return lista
  end

end
