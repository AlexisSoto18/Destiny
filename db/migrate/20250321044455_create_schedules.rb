class CreateSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :schedules do |t|
      t.string :titulo
      t.string :descripcion
      t.datetime :fecha_hora
      t.references :paciente, null: false, foreign_key: true

      t.timestamps
    end
  end
end
