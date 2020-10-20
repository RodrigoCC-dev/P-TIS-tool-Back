class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :descripcion
      t.integer :correlativo
      t.boolean :resuelto
      t.bigint :resuelto_por
      t.datetime :resuelto_el
      t.boolean :borrado, default: false
      t.datetime :deleted_at
      t.references :bitacora_revision, null: false, foreign_key: true
      t.references :tipo_item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
