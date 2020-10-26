class UsuariosController < ApplicationController
  before_action :authenticate_user

  def user
    render json: current_user.as_json(
      :include => :rol
    )
  end
end
