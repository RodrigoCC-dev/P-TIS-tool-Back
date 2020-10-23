class BitacoraEstado < ApplicationRecord
  belongs_to :minuta
  belongs_to :tipo_estado
end
