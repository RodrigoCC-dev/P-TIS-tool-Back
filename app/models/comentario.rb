class Comentario < ApplicationRecord
  belongs_to :asistencia
  belongs_to :minuta
  has_many :respuestas
end
