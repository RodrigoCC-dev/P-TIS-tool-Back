class StakeholdersController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat
  include Funciones

  # Servicio que permite crear un nuevo stakeholder en el sistema
  def create
    stakeholder = Stakeholder.new
    stakeholder.build_usuario
    stakeholder.usuario.assign_attributes(stakeholders_params[:usuario_attributes])
    stakeholder.iniciales = obtener_iniciales(stakeholder.usuario)
    stakeholder.assign_attributes(stakeholders_params)
    if stakeholder.grupo_id == 0
      grupo_por_defecto = Grupo.find_by(nombre: 'SG')
      stakeholder.grupo_id = grupo_por_defecto.id
    end
    rol_stakeholder = Rol.find_by(rol: 'Stakeholder')
    stakeholder.usuario.rol_id = rol_stakeholder.id
    nueva_password = stakeholder.usuario.nombre.titleize.split(' ').join
    stakeholder.usuario.password = nueva_password
    stakeholder.usuario.password_confirmation = nueva_password
    if stakeholder.valid?
      stakeholder.save!
    else
      render json: ['Error': 'Información del stakeholder no es válida'], status: :unprocessable_entity
    end
  end

  private
  def stakeholders_params
    params.require(:stakeholder).permit(:grupo_id, usuario_attributes: [:nombre, :apellido_paterno, :apellido_materno, :email])
  end
end
