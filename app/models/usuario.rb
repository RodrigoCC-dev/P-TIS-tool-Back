require 'bcrypt'

class Usuario < ApplicationRecord
  has_secure_password
  include BCrypt

  belongs_to :rol
  has_one :estudiante
  has_one :stakeholder
  has_one :profesor
  before_save :downcase_fields

  # validaciones
  validates_uniqueness_of :email
  validates :nombre, :apellido_paterno, :apellido_materno, presence: true
  validates :nombre, :apellido_paterno, :apellido_materno,
    format: {with: /\A[a-zA-ZÀ-ÿ\u00f1\u00d1]+(\s*[a-zA-ZÀ-ÿ\u00f1\u00d1]*)*[a-zA-ZÀ-ÿ\u00f1\u00d1]+\z/, message: "Sólo se aceptan letras"}
  validates :run, format: {with: /(\d{7,8})-(\d|K)/}, presence: true, unless: :run_nil?
  validates :email,
    format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i},
    presence: true,
    uniqueness: {case_sensitive: false}

  private
  def downcase_fields
    self.nombre = self.nombre.titleize.strip
    self.apellido_paterno = self.apellido_paterno.titleize.strip
    self.apellido_materno = self.apellido_materno.titleize.strip
    self.email = self.email.downcase.strip
  end

  def run_nil?
    self.run.nil?
  end
end
