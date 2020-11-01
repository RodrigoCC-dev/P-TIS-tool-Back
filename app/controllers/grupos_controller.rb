class GruposController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  def index
  end

  def create
    grupo = Grupo.new(grupo_params)
    if grupo.valid?
      grupo.save!
      estudiantes = Estudiante.where(params[:estudiantes])
      estudiantes.each do |e|
        e.grupo_id = grupo.id
      end
    else
      render json: ['error': 'Información del grupo no es válida'], status: :unprocessable_entity
    end
  end

  # Servicio que entrega el último grupo de estudiantes disponibles asociados a una jornada
  def ultimo_grupo
    grupo = Estudiante.joins(:grupo).joins(seccion: :jornada).where('grupos.borrado = ? AND grupos.nombre <> ? AND jornadas.nombre = ?', false, 'SG', params[:jornada]).select('
      grupos.id,
      grupos.nombre,
      grupos.correlativo
      ').last
    render json: grupo.as_json(json_data)
  end

  private
  def grupo_params
    params.require(:grupos).permit(:nombre, :proyecto, :correlativo)
  end

end
