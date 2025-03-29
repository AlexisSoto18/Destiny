class Paciente < ApplicationRecord
  belongs_to :user

  has_one :direccion, dependent: :destroy
  has_many :sale, dependent: :destroy
  has_many :historial_clinicos, dependent: :destroy
  has_many :schedules, dependent: :destroy
  scope :search, ->(nombre) { where("CONCAT(nombre, ' ', apellido_paterno, ' ', apellido_materno) LIKE ?", "%#{nombre}%") }

  accepts_nested_attributes_for :direccion
end
