class Minuta < ApplicationRecord
  belongs_to :estudiante
  belongs_to :tipo_minuta
  belongs_to :clasificacion
  has_many :asistencias
  has_many :comentarios
  has_many :registros
  has_many :bitacora_estados
  has_many :bitacora_revisiones

  # validaciones

end
