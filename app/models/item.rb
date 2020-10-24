class Item < ApplicationRecord
  belongs_to :bitacora_revision
  belongs_to :tipo_item
  has_and_belongs_to_many :responsables
end
