class CreateBitacoraEstados < ActiveRecord::Migration[6.0]
  def change
    create_table :bitacora_estados do |t|
      t.boolean :activo
      t.references :minuta, null: false, foreign_key: true
      t.references :estado, null: false, foreign_key: true

      t.timestamps
    end
  end
end
