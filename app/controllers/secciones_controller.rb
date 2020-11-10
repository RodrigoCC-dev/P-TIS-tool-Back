class SeccionesController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  # Servicio que entrega las secciones asignadas a un profesor para el semestre activo
  def index
    semestre_actual = Semestre.where('activo = ? AND borrado = ?', true, false).last
    usuario = Usuario.find(current_usuario.id)
    if usuario.rol.rango == 1
      secciones = Seccion.where('semestre_id = ? AND borrado = ?', semestre_actual.id, false)
    elsif usuario.rol.rango == 2
      secciones = Seccion.joins(:profesores).where('profesores.usuario_id = ? AND semestre_id = ? AND borrado = ?', usuario.id, semestre_actual.id, false)
    end
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
