class Comentario < ApplicationRecord
  belongs_to :asistencia
  belongs_to :minuta
end
