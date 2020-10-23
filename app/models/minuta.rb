class Minuta < ApplicationRecord
  belongs_to :estudiante
  belongs_to :tipo_minuta
  belongs_to :clasificacion
  has_many :asistencias
  has_many :comentarios

  # validaciones

end
