class CreateConclusiones < ActiveRecord::Migration[6.0]
  def change
    create_table :conclusiones do |t|
      t.text :descripcion
      t.references :bitacora_revision, null: false, foreign_key: true
      t.boolean :borrado, default:false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
