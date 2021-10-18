class TipoAprobacion < ApplicationRecord
  has_many :aprobaciones

  # Validaciones
  validates :rango, uniqueness: true
end
