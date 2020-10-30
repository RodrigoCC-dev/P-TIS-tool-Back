class EstudiantesController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  def index
    semestreActual = Semestre.where('activo = ? AND borrado = ?', true, false).last
    usuario = Usuario.find(current_usuario.id)
    if usuario.rol.rango == 1
      estudiantes = Estudiante.joins(:usuario).joins(seccion: :jornada).joins(seccion: :semestre).where(
        'semestres.id = ? AND usuarios.borrado = ?', semestreActual.id, false).select('
          estudiantes.id,
          usuarios.run AS run_est,
          usuarios.nombre AS nombre_est,
          usuarios.apellido_paterno AS apellido1,
          usuarios.apellido_materno AS apellido2,
          secciones.codigo AS codigo_seccion,
          jornadas.nombre AS jornada
          ')
    elsif usuario.rol.rango == 2
      estudiantes = Estudiante.joins(:usuario).joins(seccion: :profesores).joins(seccion: :jornada).joins(seccion: :semestre).where(
        'semestres.id = ? AND usuarios.borrado = ? AND profesores.usuario_id = ?', semestreActual.id, false, usuario.id).select('
          estudiantes.id,
          usuarios.run AS run_est,
          usuarios.nombre AS nombre_est,
          usuarios.apellido_paterno AS apellido1,
          usuarios.apellido_materno AS apellido2,
          secciones.codigo AS codigo_seccion,
          jornadas.nombre AS jornada
          ')
    end
    render json: estudiantes.as_json(json_data)
  end

  def create
    estudiante = Estudiante.new
    estudiante.build_usuario
    estudiante.usuario.assign_attributes(estudiantes_params[:usuario_attributes])
    estudiante.iniciales = obtener_iniciales(estudiante.usuario)
    grupo_por_defecto = Grupo.find_by(nombre: 'SG')
    estudiante.grupo_id = grupo_por_defecto.id
    rol_estudiante = Rol.find_by(rol: 'Estudiante')
    estudiante.usuario.rol_id = rol_estudiante.id
    estudiante.assign_attributes(estudiantes_params)
    estudiante.usuario.password = 'pass'
    estudiante.usuario.password_confirmation = 'pass'
    if estudiante.valid?
      estudiante.save!
    else
      render json: ['error': 'Información del estudiante no es válida'], status: :unprocessable_entity
    end
  end

  private
  def estudiantes_params
    params.require(:estudiante).permit(:seccion_id, usuario_attributes: [:nombre, :apellido_paterno, :apellido_materno, :run, :email])
  end

  def obtener_iniciales(usuario)
    iniciales = ""
    iniciales += usuario.nombre.chr.upcase
    iniciales += usuario.apellido_paterno.chr.upcase
    iniciales += usuario.apellido_materno.chr.upcase
    return iniciales
  end
end
