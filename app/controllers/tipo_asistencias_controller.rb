class TipoAsistenciasController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  # Servicio que entrega los tipos de asistencia disponibles
  def index
    asistencias = TipoAsistencia.all
    render json: asistencias.as_json(json_data)
  end

end
