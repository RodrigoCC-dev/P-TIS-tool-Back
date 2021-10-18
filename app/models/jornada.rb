class Jornada < ApplicationRecord
  has_many :secciones

  # validaciones
  validates :identificador, uniqueness: true
end
