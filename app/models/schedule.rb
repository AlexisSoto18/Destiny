class Schedule < ApplicationRecord
  belongs_to :paciente
  validates :titulo, :descripcion, :fecha_hora, presence: true
  validates :fecha_hora, uniqueness: { message: "Ya existe una cita en esta fecha y hora." }
end
