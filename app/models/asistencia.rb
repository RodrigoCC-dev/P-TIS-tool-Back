class Asistencia < ApplicationRecord
  belongs_to :minuta
  belongs_to :tipo_asistencia
  has_many :comentarios
  has_many :respuestas
  has_one :responsable
end
