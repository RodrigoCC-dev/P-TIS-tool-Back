class ProfesoresController < ApplicationController
  before_action :authenticate_usuario
  include JsonFormat

  # Servicio que entrega el listado de profesores en el sistema
  
end
