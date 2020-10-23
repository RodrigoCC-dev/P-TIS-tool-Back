class Grupo < ApplicationRecord
  has_many :estudiantes
  has_many :stakeholders
end
