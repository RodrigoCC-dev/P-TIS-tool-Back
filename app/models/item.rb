class Item < ApplicationRecord
  belongs_to :bitacora_revision
  belongs_to :tipo_item
  has_and_belongs_to_many :responsables

  # Validaciones
  validates :descripcion, :correlativo, presence: true
  validates :correlativo, numericality: {only_integer: true, greater_than: 0}
  validates :resuelto_por, numericality: {only_integer: true, greater_than: 0}, allow_nil: true
  validates :borrado, inclusion: {in: [true, false]}
end
