class ProfesoresController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  # Servicio que entrega el listado de profesores en el sistema
  def index
    profesores = Profesor.all
    render json: profesores.as_json(
      { except: %i[created_at updated_at], :include => {
        :secciones => json_data,
        :usuario => user_data
        }
      }
    )
  end

  # Servicio que permite agregar un nuevo profesor al sistema
  def create
    profesor = Profesor.new(profesor_params)
    profesor.usuario.password = 'secret'
    profesor.usuario.password_confirmation = 'secret'
    profesor.usuario.build_rol
    profesor.usuario.rol = Rol.find_by(rol: 'Profesor')
    if profesor.valid?
      profesor.save!
      secciones = Seccion.where(id: params[:secciones])
      profesor.secciones << secciones
      profesor.save!
    else
      render json: ['error': 'Informacion del profesor no es válida'], status: :unprocessable_entity
    end
  end

  private
  def profesor_params
    params.require(:profesor).permit(usuario_attributes: [:nombre, :apellido_paterno, :apellido_materno, :email])
  end
end
