class Asistencia < ApplicationRecord
  belongs_to :minuta
  belongs_to :tipo_asistencia
  has_many :comentarios
  has_many :respuestas
  has_one :responsable

  # Validaciones
  validates :id_estudiante, :id_stakeholder, numericality: {only_integer: true, greater_than: 0}
end
