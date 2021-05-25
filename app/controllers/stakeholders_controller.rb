class StakeholdersController < ApplicationController
  before_action :authenticate_usuario
  before_action :semestre_actual, only: [:por_jornada]
  include JsonFormat
  include Funciones

  # Servicio que muestra los stakeholder ingresados en el sistema según las secciones asignadas al profesor
  def index
    stakeholders = Stakeholder.joins(:usuario).where('usuarios.borrado = ?', false)
    render json: stakeholders.as_json(
      { except: %i[created_at updated_at], :include => {
        :usuario => user_data
        }
      }
    )
  end

  # Servicio que permite crear un nuevo stakeholder en el sistema
  def create
    stakeholder = Stakeholder.new
    stakeholder.build_usuario
    stakeholder.usuario.assign_attributes(stakeholders_params[:usuario_attributes])
    stakeholder.assign_attributes(stakeholders_params)
    busqueda = Usuario.where(email: stakeholder.usuario.email, borrado: false)
    if busqueda.size == 0
      stakeholder.iniciales = obtener_iniciales(stakeholder.usuario)
      unless grupo_params[:id] == 0 && grupo_params[:id] == nil
        grupo = Grupo.find(grupo_params[:id])
        stakeholder.grupos << grupo
      end
      stakeholder.usuario.rol_id = Rol.find_by(rol: 'Stakeholder').id
      nueva_password = nueva_password(stakeholder.usuario.nombre)
      stakeholder.usuario.password = nueva_password
      stakeholder.usuario.password_confirmation = nueva_password
      if stakeholder.valid?
        stakeholder.save!
      else
        render json: ['Error': 'Información del stakeholder no es válida'], status: :unprocessable_entity
      end
    else
      render json: ['Error': 'Correo electrónico ya existe en el sistema'], status: :unprocessable_entity
    end
  end

  # Servicio que muestra la información de un stakeholder según su 'id' de usuario
  def show
    stakeholder = Stakeholder.find_by(usuario_id: params[:id])
    render json: stakeholder.as_json(
      {except: [:created_at, :update_at], :include => {
        :usuario => user_data,
        :grupos => json_data
        }
      }
    )
  end

  # Servicio que permite editar los datos de un stakeholder
  def update
    if current_usuario.rol.rango < 3
      stakeholder = Stakeholder.find(params[:id])
      unless stakeholder.nil?
        stakeholder.usuario.assign_attributes(stakeholders_params[:usuario_attributes])
        stakeholder.iniciales = obtener_iniciales(stakeholder.usuario)
        if stakeholder.valid?
          stakeholder.save!
        else
          render json: ['Error': 'Los datos del stakeholder no son válidos'], status: :unprocessable_entity
        end
      else
        render json: ['Error': 'No existe el stakeholder a editar'], status: :unprocessable_entity
      end
    else
      render json: ['Error': 'Servicio no disponible para este usuario'], status: :unprocessable_entity
    end
  end

  # Servicio que muestra los stakeholder ingresados en el sistema según las secciones asignadas al profesor
  def por_jornada
    if current_usuario.rol.rango == 1
      stakeholders = Stakeholder.joins(grupos: {estudiantes: [seccion: :jornada]}).joins(:usuario).joins(
        grupos: {estudiantes: [seccion: :semestre]}).where('semestres.id = ? AND usuarios.borrado = ?', @semestre_actual.id, false).select('
        stakeholders.id,
        usuarios.nombre AS nombre_stk,
        usuarios.apellido_paterno AS apellido1,
        usuarios.apellido_materno AS apellido2,
        usuarios.email AS correo_elec,
        secciones.codigo AS codigo_seccion,
        grupos.id AS id_grupo,
        grupos.nombre AS nombre_grupo,
        jornadas.nombre AS jornada')
    elsif current_usuario.rol.rango == 2
      stakeholders = Stakeholder.joins(grupos: {estudiantes: [seccion: :jornada]}).joins(:usuario).joins(
        grupos: {estudiantes: [seccion: :semestre]}).joins(grupos: {estudiantes: [seccion: :profesores]}).where(
          'semestres.id = ? AND usuarios.borrado = ? AND profesores.usuario_id = ?', @semestre_actual.id, false, current_usuario.id).select('
        stakeholders.id,
        usuarios.nombre AS nombre_stk,
        usuarios.apellido_paterno AS apellido1,
        usuarios.apellido_materno AS apellido2,
        usuarios.email AS correo_elec,
        secciones.codigo AS codigo_seccion,
        grupos.id AS id_grupo,
        grupos.nombre AS nombre_grupo,
        jornadas.nombre AS jornada')
    end
    grupos = Grupo.joins(estudiantes: {seccion: :jornada}).select('grupos.id, grupos.nombre AS nombre_grupo, grupos.proyecto AS proyecto_grupo, jornadas.nombre AS jornada')
    lista = []
    stakeholders.each do |s|
      unless lista.include?(s)
        lista << s
      end
    end
    lista_final = []
    lista.each do |l|
      aux = []
      l.grupos.each do |g|
        grupo = {
          id: g.id,
          nombre: g.nombre,
          jornada: grupos.find(g.id).jornada
        }
        aux << grupo
      end
      h = {id: l.id, nombre: l.nombre_stk, apellido_paterno: l.apellido1, apellido_materno: l.apellido2, email: l.correo_elec,
        grupos: aux
      }
      lista_final << h
    end
    render json: lista_final.as_json(json_data)
  end


  private
  def stakeholders_params
    params.require(:stakeholder).permit(:grupo_id, usuario_attributes: [:nombre, :apellido_paterno, :apellido_materno, :email])
  end

  def grupo_params
    params.require(:grupo).permit(:id)
  end

  def semestre_actual
    @semestre_actual = Semestre.where('activo = ? AND borrado = ?', true, false).last
  end

  def presente_en_lista?(lista, id)
    existe = false
    lista.each do |l|
      if l.id == id
        existe = true
      end
    end
    return existe
  end

end
