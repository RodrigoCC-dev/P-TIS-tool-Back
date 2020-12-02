class Profesor < ApplicationRecord
  belongs_to :usuario
  has_and_belongs_to_many :secciones

  accepts_nested_attributes_for :usuario
  
end
