class MinutasController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  def create
  end

  # Servicio que entrega el número correlativo siguiente para la nueva minuta del grupo
  def correlativo
    ultima = Minuta.joins(estudiante: :grupo).where('grupos.id = ? AND minutas.borrado = ?', params[:id], false).last
    if ultima.nil?
      correlativo = 1
    else
      correlativo = ultima.correlativo + 1
    end
    render json: correlativo.as_json
  end

end
