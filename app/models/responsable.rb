class Responsable < ApplicationRecord
  belongs_to :asistencia
  has_and_belongs_to_many :items
end
