class Minuta < ApplicationRecord
  belongs_to :estudiante
  belongs_to :tipo_minuta
  belongs_to :clasificacion
  has_many :asistencias
  has_many :registros
  has_many :bitacora_estados
  has_many :bitacora_revisiones

  accepts_nested_attributes_for :clasificacion

  # Validaciones
  validates :correlativo, :codigo, :fecha_reunion, :h_inicio, :h_termino, presence: true
  validates :correlativo, numericality: {only_integer: true, greater_than: 0}
  validates :codigo, format: {with: /\A(MINUTA_)+(G(\d{2})_)+(\d{2}_)+(\d{4})-(\d{1}_)+(\d{4})\z/}

end
