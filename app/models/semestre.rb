class Semestre < ApplicationRecord
  has_many :secciones
  before_validation :crear_identificador

  # Validaciones
  validates_uniqueness_of :identificador
  validates :identificador, format: {with: /(\d{1})-(\d{4})/}

  private
  def crear_identificador
    self.identificador = self.numero.to_s + '-' + self.agno.to_s
  end
end
