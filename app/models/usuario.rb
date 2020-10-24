require 'bcrypt'

class Usuario < ApplicationRecord
  has_secure_password
  include BCrypt

  belongs_to :rol
  has_one :estudiante
  has_one :stakeholder
  has_one :profesor

  # validaciones
  validates_uniqueness_of :correo_elec

end
