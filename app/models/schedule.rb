class Schedule < ApplicationRecord
  belongs_to :paciente
  validates :titulo, :descripcion, :fecha_hora, presence: true
end
