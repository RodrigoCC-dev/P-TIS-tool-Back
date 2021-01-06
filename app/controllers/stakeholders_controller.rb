class StakeholdersController < ApplicationController
  before_action :authenticate_usuario
  before_action :semestre_actual, only: [:index]
  include JsonFormat
  include Funciones

  # Servicio que muestra los stakeholder ingresados en el sistema según las secciones asignadas al profesor
  def index
    if current_usuario.rol.rango == 1
      stakeholders = Stakeholder.joins("INNER JOIN grupos_stakeholders ON grupos_stakeholders.stakeholder_id = stakeholders.id INNER JOIN grupos ON grupos.id = grupos_stakeholders.grupo_id
        INNER JOIN estudiantes ON estudiantes.grupo_id = grupos.id INNER JOIN secciones ON secciones.id = estudiantes.seccion_id
        INNER JOIN semestres ON semestres.id = secciones.semestre_id INNER JOIN usuarios ON usuarios.id = stakeholders.usuario_id
        INNER JOIN jornadas ON jornadas.id = secciones.jornada_id").where('
        semestres.id = ? AND usuarios.borrado = ?', @semestre_actual.id, false).select('
        stakeholders.id,
        usuarios.nombre AS nombre_stk,
        usuarios.apellido_paterno AS apellido1,
        usuarios.apellido_materno AS apellido2,
        secciones.codigo AS codigo_seccion,
        grupos.id AS id_grupo,
        grupos.nombre AS nombre_grupo,
        jornadas.nombre AS jornada')
    elsif current_usuario.rol.rango == 2
      stakeholders = Stakeholder.joins("INNER JOIN grupos_stakeholders ON grupos_stakeholders.stakeholder_id = stakeholders.id INNER JOIN grupos ON grupos.id = grupos_stakeholders.grupo_id
        INNER JOIN estudiantes ON estudiantes.grupo_id = grupos.id INNER JOIN secciones ON secciones.id = estudiantes.seccion_id
        INNER JOIN profesores_secciones ON profesores_secciones.seccion_id = secciones.id INNER JOIN profesores ON profesores.id = profesores_secciones.profesor_id
        INNER JOIN semestres ON semestres.id = secciones.semestre_id INNER JOIN usuarios ON usuarios.id = stakeholders.usuario_id
        INNER JOIN jornadas ON jornadas.id = secciones.jornada_id").where('
        semestres.id = ? AND usuarios.borrado = ? AND profesores.usuario_id = ?', @semestre_actual.id, false, current_usuario.id).select('
        stakeholders.id,
        usuarios.nombre AS nombre_stk,
        usuarios.apellido_paterno AS apellido1,
        usuarios.apellido_materno AS apellido2,
        secciones.codigo AS codigo_seccion,
        grupos.id AS id_grupo,
        grupos.nombre AS nombre_grupo,
        jornadas.nombre AS jornada')
    end
    lista = []
    stakeholders.each do |s|
      unless presente_en_lista?(lista, s.id)
        lista << s
      end
    end
    lista_final = []
    lista.each do |l|
      h = {id: l.id, nombre: l.nombre_stk, apellido_paterno: l.apellido1, apellido_materno: l.apellido2,
        grupo: {
          id: l.id_grupo,
          nombre: l.nombre_grupo
        },
        jornada: l.jornada
      }
      lista_final << h
    end
    render json: lista_final.as_json(json_data)
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

  # Servicio que permite editar la asignación de stakeholders a un grupo identificado por su 'id'
  def update
    grupo = Grupo.find(params[:id])
    stakeholders = Stakeholder.where(id: params[:stakeholders])
    unless stakeholders.size == 0
      grupo.stakeholders.clear
      grupo.stakeholders << stakeholders
      grupo.save
    else
      render json: ['Error': 'No se han agregado stakeholders al grupo seleccionado'], status: :unprocessable_entity
    end
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
