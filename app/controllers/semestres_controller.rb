class SemestresController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  # Servicio que entrega la información del semestre actual
  def index
    semestre = Semestre.where('activo = ? AND borrado = ?', true, false).last
    render json: semestre.as_json(json_data)
  end
end
