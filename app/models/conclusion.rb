class Conclusion < ApplicationRecord
  belongs_to :bitacora_revision

  # Validaciones

  validates :descripcion, precense: true
end
