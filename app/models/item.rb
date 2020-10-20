class Item < ApplicationRecord
  belongs_to :bitacora_revision
  belongs_to :tipo_item
end
