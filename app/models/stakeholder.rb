class Stakeholder < ApplicationRecord
  belongs_to :usuario
  belongs_to :grupo

  accepts_nested_attributes_for :usuario

  # Validaciones
  validates :iniciales, presence: true
end
