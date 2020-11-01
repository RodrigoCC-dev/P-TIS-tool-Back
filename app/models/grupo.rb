class Grupo < ApplicationRecord
  has_many :estudiantes
  has_many :stakeholders

  # Validaciones
  validates :nombre, :proyecto, presence: true
  validates :nombre, format: {with: /\AG(\d{2})/}
  validates :proyecto,
    format: {with: /\A[a-zA-ZÀ-ÿ\u00f1\u00d1]+(\s*[a-zA-ZÀ-ÿ\u00f1\u00d1]*)*[a-zA-ZÀ-ÿ\u00f1\u00d1]+\z/, message: "Sólo se aceptan letras"}
  validates :correlativo, numericality: {only_integer: true, greater_than: 0}

end
