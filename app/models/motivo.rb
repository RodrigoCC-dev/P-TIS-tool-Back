class Motivo < ApplicationRecord
  has_many :bitacora_revisiones

  # validaciones
  validates :identificador, uniqueness: true
end
