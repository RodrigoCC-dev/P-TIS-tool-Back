class GruposController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  def index
  end

  # Servicio que entrega los grupos de estudiantes disponibles asociados a una jornada
  def por_jornada
    grupo = Estudiante.joins(:grupo).joins(seccion: :jornada).where('grupos.borrado = ? AND grupos.nombre <> ? AND jornadas.nombre = ?', false, 'SG', params[:jornada]).select('
      grupos.id,
      grupos.nombre,
      grupos.correlativo
      ').last
    render json: grupo.as_json(json_data)
  end

end
