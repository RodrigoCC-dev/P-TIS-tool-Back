class BitacoraRevision < ApplicationRecord
  belongs_to :motivo
  belongs_to :minuta
  has_one :tema
  has_many :items
  has_many :conclusiones
  has_many :objetivos
end