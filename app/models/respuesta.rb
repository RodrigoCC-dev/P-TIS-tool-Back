class Respuesta < ApplicationRecord
  belongs_to :comentario
  belongs_to :asistencia

  # Validaciones
  validates :respuesta, presence: true
  validates :borrado, inclusion: {in: [true, false]}
end
