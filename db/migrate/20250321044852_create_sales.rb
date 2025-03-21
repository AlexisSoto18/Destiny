class CreateSales < ActiveRecord::Migration[8.0]
  def change
    create_table :sales do |t|
      t.decimal :costo
      t.string :servicio
      t.references :paciente, null: false, foreign_key: true

      t.timestamps
    end
  end
end
