class Profesor < ApplicationRecord
  belongs_to :usuario
  belongs_to :seccion
end
