class ProfesoresController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  # Servicio que entrega el listado de profesores en el sistema
  def index
    profesores = Profesor.all
    render json: profesores.as_json(
      { except: %i[created_at updated_at], :include => {
        :secciones => json_data,
        :usuario => user_data
        }
      }
    )
  end

  def create
  end
end
