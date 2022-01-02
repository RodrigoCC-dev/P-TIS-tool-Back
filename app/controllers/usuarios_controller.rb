class UsuariosController < ApplicationController
  before_action :authenticate_usuario, except: [:login, :inicio]
  include JsonFormat

  # Servicio que permite actualizar la clave de acceso de un usuario
  def update
    usuario = Usuario.find(params[:id])
    if usuario.id == current_usuario.id
      if !usuario.nil? && usuario.authenticate(params[:password])
        usuario.assign_attributes(new_password_params)
        if usuario.valid?
          usuario.save!
        end
      else
        render json: ['Error': 'La clave de acceso no corresponde al usuario'], status: :unprocessable_entity
      end
    else
      render json: ['Error': 'No es el usuario actual del sistema'], status: :unprocessable_entity
    end
  end

  # Servicio que entrega la información del usuario autenticado
  def user
    render json: current_usuario.as_json(
      { except: %i[created_at updated_at password_digest borrado deleted_at], :include => {
        :rol => json_data
        }
      }
    )
  end

  def login
    usuario = Usuario.find_by(email: params[:auth][:email])
    if usuario && usuario.authenticate(params[:auth][:password])
      token = encode_token({usuario_id: usuario.id})
      render json: {'jwt': token}
    else
      render json: {error: 'Usuario no autorizado o contraseña errónea'}, status: :unprocessable_entity
    end
  end

  # Servicio página de inicio para conseguir certificado SSL para HTTPS con Let's Encrypt
  def inicio
    render html: File.read(Rails.root.join('app','views','usuarios',"inicio.html.erb"))
  end

  private
  def json_user
    { except: %i[created_at updated_at password_digest], :include => {:rol => {except: %i[created_at updated_at]} } }
  end

  def new_password_params
    params.require(:usuario).permit(:password, :password_confirmation)
  end

end
