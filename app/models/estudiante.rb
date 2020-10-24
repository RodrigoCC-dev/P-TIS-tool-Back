class Estudiante < ApplicationRecord
  belongs_to :usuario
  belongs_to :seccion
  belongs_to :grupo
end
