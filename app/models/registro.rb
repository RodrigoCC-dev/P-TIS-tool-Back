class Registro < ApplicationRecord
  belongs_to :minuta
  belongs_to :tipo_actividad
end
