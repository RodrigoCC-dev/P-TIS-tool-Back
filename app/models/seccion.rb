class Seccion < ApplicationRecord
  belongs_to :jornada
  belongs_to :semestre
  belongs_to :curso
  has_and_belongs_to_many :profesores
  has_many :estudiantes
end
