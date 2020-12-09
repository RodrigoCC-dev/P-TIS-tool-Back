class Comentario < ApplicationRecord
  belongs_to :asistencia
  belongs_to :bitacora_revision
  has_many :respuestas

  # Validaciones
  validates :comentario, presence: true
  validates :es_item, inclusion: {in: [true, false]}
  validates :id_item, numericality: {only_integer: true, greater_than: 0}, allow_nil: true
  validates :borrado, inclusion: {in: [true, false]}
end
