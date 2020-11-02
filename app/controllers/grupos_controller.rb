class GruposController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  # Servicio que muestra el listado de grupos en el sistema
  def index
    grupos = Grupo.where('borrado = ? AND nombre <> ?', false, 'SG')
    estudiantes = Estudiante.joins(:grupo).joins(:usuario).joins(seccion: :jornada).where('grupos.borrado = ? AND grupos.nombre <> ?', false, 'SG').select('
      estudiantes.id,
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
      if est_asignados.size > 0
        jornada = est_asignados[0].jornada
      else
        jornada = ''
      end
      h = {id: g.id, nombre: g.nombre, proyecto: g.proyecto, correlativo: g.correlativo, jornada: jornada, estudiantes: est_asignados}
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

  # Servicio que entrega el último grupo de estudiantes disponibles asociados a una jornada
  def ultimo_grupo
    grupo = Estudiante.joins(:grupo).joins(seccion: :jornada).where('grupos.borrado = ? AND grupos.nombre <> ? AND jornadas.nombre = ?', false, 'SG', params[:jornada]).select('
      grupos.id,
      grupos.nombre,
      grupos.correlativo
      ').last
    render json: grupo.as_json(json_data)
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
