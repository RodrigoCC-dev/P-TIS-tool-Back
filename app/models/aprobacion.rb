class Aprobacion < ApplicationRecord
  belongs_to :bitacora_revision
  belongs_to :asistencia
  belongs_to :tipo_aprobacion
end
