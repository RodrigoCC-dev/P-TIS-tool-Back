class Comentario < ApplicationRecord
  belongs_to :asistencia
  belongs_to :bitacora_revision
  has_many :respuestas
end
