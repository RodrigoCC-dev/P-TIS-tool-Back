class CreateTipoItems < ActiveRecord::Migration[6.0]
  def change
    create_table :tipo_items do |t|
      t.string :tipo
      t.string :descripcion
      t.boolean :borrado
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
