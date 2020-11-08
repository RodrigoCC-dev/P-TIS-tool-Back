class JornadasController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  # Servicio que entrega las jornadas de estudio según secciones asociadas a un profesor o al Coordinador
  def index
    if current_usuario.rol.rango == 1
      jornadas = Jornada.where('borrado = ?', false)
    elsif current_usuario.rol.rango == 2
      jornadas = Profesor.joins(secciones: :jornada).where('profesores.usuario_id = ? AND jornadas.borrado = ?', current_usuario.id, false).select('jornadas.*')
    end
    render json: jornadas.as_json(json_data)
  end
end
