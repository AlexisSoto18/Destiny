class CreateDireccions < ActiveRecord::Migration[8.0]
  def change
    create_table :direccions do |t|
      t.string :correo_electronico
      t.string :telefono_emergencia
      t.string :telefono_principal
      t.string :estado
      t.string :municipio
      t.string :localidad
      t.string :calle
      t.string :code_postal
      t.references :paciente, null: false, foreign_key: true

      t.timestamps
    end
  end
end
