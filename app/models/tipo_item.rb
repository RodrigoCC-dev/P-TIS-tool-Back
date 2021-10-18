class TipoItem < ApplicationRecord
  has_many :items

  # validaciones
  validates :tipo, uniqueness: true
end
