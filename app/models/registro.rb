class Registro < ApplicationRecord
  belongs_to :minuta
  belongs_to :tipo_actividad

  # Validaciones
  validates :realizada_por, presence: true
  validates :realizada_por, numericality: {only_integer: true, greater_than: 0}

end
