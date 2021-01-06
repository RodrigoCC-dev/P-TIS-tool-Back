class Stakeholder < ApplicationRecord
  belongs_to :usuario
  has_and_belongs_to_many :grupos

  accepts_nested_attributes_for :usuario

  # Validaciones
  validates :iniciales, presence: true
end
