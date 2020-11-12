class Clasificacion < ApplicationRecord
  has_many :minutas

  # Validaciones
  validates :informativa, inclusion: {in: [true, false]}
  validates :avance, inclusion: {in: [true, false]}
  validates :coordinacion, inclusion: {in: [true, false]}
  validates :decision, inclusion: {in: [true, false]}
  validates :otro, inclusion: {in: [true, false]}

end
