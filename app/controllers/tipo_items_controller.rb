class TipoItemsController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  # Servicio que entrega el listado de tipos de items disponibles
  def index
    tipos = TipoItem.all
    render json: tipos.as_json(json_data)
  end

end
