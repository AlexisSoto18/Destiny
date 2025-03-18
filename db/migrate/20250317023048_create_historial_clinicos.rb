class CreateHistorialClinicos < ActiveRecord::Migration[8.0]
  def change
    create_table :historial_clinicos do |t|
      t.string :medico
      t.text :historial_clinico
      t.text :acciones_tomadas
      t.text :riesgos_identificados
      t.references :paciente, null: false, foreign_key: true

      t.timestamps
    end
  end
end
