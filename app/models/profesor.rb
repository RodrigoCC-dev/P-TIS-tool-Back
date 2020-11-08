class Profesor < ApplicationRecord
  belongs_to :usuario
  has_and_belongs_to_many :secciones
end
