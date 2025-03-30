class CreatePacientes < ActiveRecord::Migration[8.0]
  def change
    create_table :pacientes do |t|
      t.string :nombre
      t.string :apellido_paterno
      t.string :apellido_materno
      t.string :curp
      t.string :nivel_socioeconomico
      t.string :tipo_sanguineo
      t.string :discapacidad
      t.string :grupo_etnico
      t.string :religion
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :pacientes, :curp, unique: true
  end
end
