class TipoActividad < ApplicationRecord
  has_many :registros

  # Validaciones
  validates :identificador, uniqueness: true
end
