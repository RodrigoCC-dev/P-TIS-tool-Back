class TipoAsistencia < ApplicationRecord
  has_many :asistencias

  # validaciones
  validates :tipo, uniqueness: true
end
