class SeccionesController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  def index
    semestreActual = Semestre.where('activo = ? AND borrado = ?', true, false).last
    secciones = Seccion.where('semestre_id = ? AND borrado = ?', semestreActual.id, false)
    render json: secciones.as_json(
      {except: %i[jornada_id semestre_id curso_id borrado deleted_at created_at updated_at],
        :include => {
          :curso => json_data,
          :jornada => json_data,
          :semestre => json_data
        }
      }
    )
  end

end
