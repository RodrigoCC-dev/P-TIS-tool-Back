class TipoMinuta < ApplicationRecord
  has_many :minutas

  # validaciones
  validates :tipo, uniqueness: true
end
