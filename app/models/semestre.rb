class Semestre < ApplicationRecord
  has_many :secciones
  before_create :crear_identificador

  # Validaciones
  validates :identificador, uniqueness: true
  validates :identificador, format: {with: /(\d{1})-(\d{4})/}

  private
  def crear_identificador
    self.identificador = self.numero + '-' + self.agno
  end
end
