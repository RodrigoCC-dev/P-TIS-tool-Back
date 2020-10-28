class UsuariosController < ApplicationController
  before_action :authenticate_usuario

  def user
    render json: current_usuario.as_json(
      { except: %i[created_at updated_at password_digest borrado deleted_at], :include => {
        :rol => json_data
        }
      }
    )
  end

  def json_user
    { except: %i[created_at updated_at password_digest], :include => {:rol => {except: %i[created_at updated_at]} } }
  end

  def json_data
    { except: %i[created_at updated_at borrado deleted_at] }
  end
end
