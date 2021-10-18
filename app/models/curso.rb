class Curso < ApplicationRecord
  has_many :secciones

  # validaciones
  validates :codigo, uniqueness: true
end
