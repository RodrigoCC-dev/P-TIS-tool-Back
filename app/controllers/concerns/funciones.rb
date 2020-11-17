module Funciones
  extend ActiveSupport::Concern

  def obtener_iniciales(usuario)
    iniciales = ""
    iniciales += usuario.nombre.chr.upcase
    iniciales += usuario.apellido_paterno.chr.upcase
    iniciales += usuario.apellido_materno.chr.upcase
    return iniciales
  end
  
end
