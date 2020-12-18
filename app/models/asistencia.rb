class Asistencia < ApplicationRecord
  belongs_to :minuta
  belongs_to :tipo_asistencia
  has_many :comentarios
  has_many :respuestas
  has_many :aprobaciones
  has_one :responsable

  # Validaciones
  validates :id_estudiante, presence: true, if: :id_stakeholder_nil?
  validates :id_stakeholder, presence: true, if: :id_estudiante_nil?
  validates :id_estudiante, :id_stakeholder, numericality: {only_integer: true, greater_than: 0}, allow_nil: true

  def id_stakeholder_nil?
    self.id_stakeholder.nil?
  end

  def id_estudiante_nil?
    self.id_estudiante.nil?
  end

end
