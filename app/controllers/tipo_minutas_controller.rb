class TipoMinutasController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  # Servicio que entrega los tipos de minutas disponibles en el sistema
  def index
    minutas = TipoMinuta.all
    render json: minutas.as_json(json_data)
  end
end
