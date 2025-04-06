class CreateSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :schedules do |t|
      t.string :titulo
      t.string :descripcion
      t.datetime :fecha_hora
      t.references :paciente, null: false, foreign_key: true

      t.timestamps
    end
    add_index :schedules, :fecha_hora, unique: true
  end
end
