class TipoEstadosController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  # Servicio que entrga los tipos de estados de una minuta
  def index
    estados = TipoEstado.all
    render json: estados.as_json(json_data)
  end
end
