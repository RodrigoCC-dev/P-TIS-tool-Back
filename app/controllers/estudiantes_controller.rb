class EstudiantesController < ApplicationController
  before_action :authenticate_usuario
  before_action :semestre_actual, only: [:index, :sin_grupo]
  before_action :usuario_actual, only: [:index, :sin_grupo]
  include JsonFormat
  include Funciones

  # Servicio que muestra los estudiantes ingresados en el sistema según las secciones asignadas al profesor
  def index
    if @usuario.rol.rango == 1
      estudiantes = Estudiante.joins(:usuario).joins(seccion: :jornada).joins(seccion: :semestre).where(
        'semestres.id = ? AND usuarios.borrado = ?', @semestre_actual.id, false).select('
          estudiantes.id,
          usuarios.run AS run_est,
          usuarios.nombre AS nombre_est,
          usuarios.apellido_paterno AS apellido1,
          usuarios.apellido_materno AS apellido2,
          usuarios.email AS correo,
          secciones.codigo AS codigo_seccion,
          jornadas.nombre AS jornada
          ')
    elsif @usuario.rol.rango == 2
      estudiantes = Estudiante.joins(:usuario).joins(seccion: :profesores).joins(seccion: :jornada).joins(seccion: :semestre).where(
        'semestres.id = ? AND usuarios.borrado = ? AND profesores.usuario_id = ?', @semestre_actual.id, false, @usuario.id).select('
          estudiantes.id,
          usuarios.run AS run_est,
          usuarios.nombre AS nombre_est,
          usuarios.apellido_paterno AS apellido1,
          usuarios.apellido_materno AS apellido2,
          usuarios.email AS correo,
          secciones.codigo AS codigo_seccion,
          jornadas.nombre AS jornada
          ')
    end
    render json: estudiantes.as_json(json_data)
  end

  # Servicio que permite crear un estudiante en el sistema
  def create
    usuario = Usuario.find_by(run: estudiantes_params[:usuario_attributes][:run])
    if usuario.nil?
      estudiante = Estudiante.new
      estudiante.build_usuario
      estudiante.usuario.assign_attributes(estudiantes_params[:usuario_attributes])
      estudiante.iniciales = obtener_iniciales(estudiante.usuario)
      estudiante.grupo_id = Grupo.find_by(nombre: 'SG').id
      rol_estudiante = Rol.find_by(rol: 'Estudiante')
      estudiante.usuario.rol_id = rol_estudiante.id
      estudiante.assign_attributes(estudiantes_params)
      estudiante.usuario.password = nueva_password(estudiante.usuario.nombre)
      estudiante.usuario.password_confirmation = nueva_password(estudiante.usuario.nombre)
      if estudiante.valid?
        estudiante.save!
      else
        render json: ['error': 'Información del estudiante no es válida'], status: :unprocessable_entity
      end
    else
      unless usuario.estudiante.nil?
        usuario.borrado = false
        usuario.nombre = estudiantes_params[:usuario_attributes][:nombre]
        usuario.apellido_paterno = estudiantes_params[:usuario_attributes][:apellido_paterno]
        usuario.apellido_materno = estudiantes_params[:usuario_attributes][:apellido_materno]
        usuario.email = estudiantes_params[:usuario_attributes][:email]
        usuario.password = nueva_password(usuario.nombre)
        usuario.password_confirmation = nueva_password(usuario.nombre)
        usuario.estudiante.iniciales = obtener_iniciales(usuario)
        usuario.estudiante.assign_attributes(estudiantes_params)
        if usuario.valid?
          usuario.save
        else
          render json: ['error': 'Información del estudiante no es válida'], status: :unprocessable_entity
        end
      else
        render json: ['error': 'El usuario no es un estudiante'], status: :unprocessable_entity
      end
    end
  end

  # Servicio que muestra la información de un estudiante según su 'id' de usuario
  def show
    estudiante = Estudiante.find_by(usuario_id: params[:id])
    render json: estudiante.as_json(
      {except: [:created_at, :updated_at], :include => {
        :usuario => user_data
        }
      }
    )
  end

  # Servicio que permite actualizar la información de un estudiante
  def update
    estudiante = Estudiante.find(params[:id])
    unless estudiante.nil?
      estudiante.usuario.assign_attributes(estudiantes_params[:usuario_attributes])
      estudiante.iniciales = obtener_iniciales(estudiante.usuario)
      estudiante.seccion_id = estudiantes_params[:seccion_id]
      if estudiante.valid?
        estudiante.save!
      else
        render json: ['error': 'Los datos del estudiante no son válidos'], status: :unprocessable_entity
      end
    else
      render json: ['error': 'No existe el estudiante'], status: :unprocessable_entity
    end
  end

  # Servicio que entrega el listado de estudiantes sin asignación de grupo en el sistema, según las secciones asignadas al profesor
  def sin_grupo
    if @usuario.rol.rango == 1
      estudiantes = Estudiante.joins(:usuario).joins(seccion: :jornada).joins(seccion: :semestre).joins(:grupo).where(
        'semestres.id = ? AND usuarios.borrado = ? AND grupos.nombre = ?', @semestre_actual.id, false, 'SG').select('
          estudiantes.id,
          usuarios.run AS run_est,
          usuarios.nombre AS nombre_est,
          usuarios.apellido_paterno AS apellido1,
          usuarios.apellido_materno AS apellido2,
          secciones.codigo AS codigo_seccion,
          jornadas.nombre AS jornada
          ')
    elsif @usuario.rol.rango == 2
      estudiantes = Estudiante.joins(:usuario).joins(seccion: :profesores).joins(seccion: :jornada).joins(seccion: :semestre).joins(:grupo).where(
        'semestres.id = ? AND usuarios.borrado = ? AND profesores.usuario_id = ? AND grupos.nombre = ?', @semestre_actual.id, false, @usuario.id, 'SG').select('
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

  # Servicio que permite eliminar estudiantes del sistema mediante borrado lógico
  def eliminar
    if params[:eliminados].size > 0
      estudiantes = Estudiante.where(id: params[:eliminados])
      estudiantes.each do |e|
        e.usuario.borrado = true
        e.usuario.deleted_at = Time.now()
        e.grupo_id = Grupo.find_by(nombre: 'SG').id
        e.usuario.password = 'mDDpbBBmxMH7ff3'
        e.usuario.password_confirmation = 'mDDpbBBmxMH7ff3'
        e.save
      end
    end
  end

  # Servicio que permite crear nuevos estudiantes a partir de archivo Excel
  def desde_archivo
    file = params[:archivo]
    seccion = Seccion.find(params[:seccion])
    grupo_por_defecto = Grupo.find_by(nombre: 'SG')
    rol_estudiante = Rol.find_by(rango: 3)
    unless file.nil?
      tmp = file.tempfile
      tmp_file = File.join('tmp', file.original_filename)
      FileUtils.cp tmp.path, tmp_file
      begin
        excel_file = Roo::Spreadsheet.open(Rails.root.join(tmp_file), extension: :xlsx)
      rescue Zip::Error
        excel_file = Roo::Spreadsheet.open(tmp.path)
      end
    end
    excel_file.sheet(0)
    (9..excel_file.sheet(0).last_row).each do |num_row|
      valores = excel_file.sheet(0).row(num_row)
      run_est = valores[1].to_s.split('.').join
      usuario = Usuario.find_by(run: run_est)
      if usuario.nil?
        estudiante = Estudiante.new
        estudiante.build_usuario
        estudiante = asignar_datos_estudiante(estudiante, valores, rol_estudiante.id, seccion.id, grupo_por_defecto.id)
        if estudiante.valid?
          estudiante.save!
        end
      else
        if usuario.rol.rango == 3
          estudiante = Estudiante.find_by(usuario_id: usuario.id)
          estudiante = asignar_datos_estudiante(estudiante, valores, rol_estudiante.id, seccion.id, grupo_por_defecto.id)
          estudiante.usuario.borrado = false
          if estudiante.valid?
            estudiante.save!
          end
        end
      end
    end
    FileUtils.rm tmp.path
    FileUtils.rm tmp_file
    tmp.unlink
  end

  # Servicio que entrega la plantilla de ingreso de datos de estudiantes desde una nómina
  def plantilla
    send_file("#{Rails.root}/app/templates/Formato_nomina_curso.xls", {type: "application/vnd.ms-excel", disposition: 'attachment', encoding: 'binary'})
  end

  private
  def estudiantes_params
    params.require(:estudiante).permit(:seccion_id, usuario_attributes: [:nombre, :apellido_paterno, :apellido_materno, :run, :email])
  end

  def semestre_actual
    @semestre_actual = Semestre.where('activo = ? AND borrado = ?', true, false).last
  end

  def usuario_actual
    @usuario = Usuario.find(current_usuario.id)
  end

  def asignar_datos_estudiante(estudiante, valores, id_rol, id_seccion, id_grupo)
    run_est = valores[1].to_s.split('.').join
    estudiante.usuario.apellido_paterno = valores[2].to_s
    estudiante.usuario.apellido_materno = valores[3].to_s
    estudiante.usuario.nombre = valores[4].to_s
    estudiante.usuario.run = run_est
    estudiante.usuario.email = valores[7].to_s
    estudiante.usuario.rol_id = id_rol
    estudiante.usuario.password = nueva_password(estudiante.usuario.nombre)
    estudiante.usuario.password_confirmation = nueva_password(estudiante.usuario.nombre)
    estudiante.seccion_id = id_seccion
    estudiante.iniciales = obtener_iniciales(estudiante.usuario)
    estudiante.grupo_id = id_grupo
    return estudiante
  end
end
