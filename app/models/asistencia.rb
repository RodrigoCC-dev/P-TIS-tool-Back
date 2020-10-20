class Asistencia < ApplicationRecord
  belongs_to :minuta
  belongs_to :tipo_asistencia
end
