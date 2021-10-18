class TipoEstado < ApplicationRecord
  has_many :bitacora_estados

  # validaciones
  validates :abreviacion, uniqueness: true
end
