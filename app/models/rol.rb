class Rol < ApplicationRecord
  has_many :usuarios

  # validaciones
  validates :rango, uniqueness: true
end
