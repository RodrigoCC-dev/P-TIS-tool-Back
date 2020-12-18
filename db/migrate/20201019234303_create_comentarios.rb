class CreateComentarios < ActiveRecord::Migration[6.0]
  def change
    create_table :comentarios do |t|
      t.text :comentario
      t.boolean :es_item, default: false
      t.bigint :id_item
      t.boolean :borrado, default: false
      t.datetime :deleted_at
      t.references :asistencia, null: false, foreign_key: true
      t.references :bitacora_revision, null: false, foreign_key: true

      t.timestamps
    end
  end
end
