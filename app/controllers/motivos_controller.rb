class MotivosController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  # Servicio que entrega los motivos disponibles para la emisión de minutas
  def index
    motivos = Motivo.all
    render json: motivos.as_json(json_data)
  end

end
