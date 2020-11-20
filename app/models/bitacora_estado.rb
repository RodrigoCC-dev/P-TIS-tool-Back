class BitacoraEstado < ApplicationRecord
  belongs_to :minuta
  belongs_to :tipo_estado

  # Validaciones
  validates :activo, :revisado, inclusion: {in: [true, false]}
end
