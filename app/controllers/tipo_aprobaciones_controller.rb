class TipoAprobacionesController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  # Servicio que entrega los tipos de aprobaciones disponibles
  def index
    tipos = TipoAprobacion.all
    render json: tipos.as_json(json_data)
  end
end
