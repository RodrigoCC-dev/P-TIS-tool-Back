class ProfesoresController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  # Servicio que entrega el listado de profesores en el sistema
  def index
    profesores = Profesor.all
    render json: profesores.as_json(
      { except: %i[created_at updated_at], :include => {
        :secciones => { except: %i[created_at updated_at borrado deleted_at], :include => {
          :jornada => json_data
          }
        },
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
      render json: ['error': 'Información del profesor no es válida'], status: :unprocessable_entity
    end
  end

  # Servicio que permite editar un profesor en el sistema
  def update
    if current_usuario.rol.rango == 1
      profesor = Profesor.find(params[:id])
      secciones = Seccion.where(id: params[:secciones])
      unless profesor.nil?
        unless secciones.size == 0
          profesor.usuario.assign_attributes(profesor_params[:usuario_attributes])
          if profesor.valid?
            profesor.save!
            profesor.secciones.clear
            profesor.secciones << secciones
            profesor.save!
          else
            render json: ['Error': 'Información del profesor no es válida'], status: :unprocessable_entity
          end
        else
          render json: ['Error': 'No hay jornada asignada al profesor'], status: :unprocessable_entity
        end
      else
        render json: ['Error': 'No existe el profesor a editar'], status: :unprocessable_entity
      end
    else
      render json: ['Error': 'Servicio no disponible para este usuario'], status: :unprocessable_entity
    end
  end

  private
  def profesor_params
    params.require(:profesor).permit(usuario_attributes: [:nombre, :apellido_paterno, :apellido_materno, :email])
  end
end
