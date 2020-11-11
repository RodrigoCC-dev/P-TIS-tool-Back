class BitacoraRevision < ApplicationRecord
  belongs_to :motivo
  belongs_to :minuta
  has_one :tema
  has_many :items
  has_many :conclusiones
  has_many :objetivos
  before_save :revision_mayuscula

  # Validaciones
  validates :revision, format: {with: /\A([A-Z0-9]{1})\z/}, precense: true

  private
  def revision_mayuscula
    self.revision = self.revision.to_s.upcase
  end
end
