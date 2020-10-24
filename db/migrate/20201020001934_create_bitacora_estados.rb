class CreateBitacoraEstados < ActiveRecord::Migration[6.0]
  def change
    create_table :bitacora_estados do |t|
      t.boolean :activo, default: true
      t.boolean :revisado, default: false
      t.references :minuta, null: false, foreign_key: true
      t.references :tipo_estado, null: false, foreign_key: true

      t.timestamps
    end
  end
end
