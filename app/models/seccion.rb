class Seccion < ApplicationRecord
  belongs_to :jornada
  belongs_to :semestre
  belongs_to :curso
end
