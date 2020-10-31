class UsuariosController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  def user
    render json: current_usuario.as_json(
      { except: %i[created_at updated_at password_digest borrado deleted_at], :include => {
        :rol => json_data
        }
      }
    )
  end

  private
  def json_user
    { except: %i[created_at updated_at password_digest], :include => {:rol => {except: %i[created_at updated_at]} } }
  end

end
