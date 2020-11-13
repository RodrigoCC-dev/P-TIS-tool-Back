class Tema < ApplicationRecord
  belongs_to :bitacora_revision

  # Validaciones
  validates :tema, presence: true
end
