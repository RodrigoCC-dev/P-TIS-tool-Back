class Objetivo < ApplicationRecord
  belongs_to :bitacora_revision

  # Validaciones
  validates :descripcion, presence: true
end
