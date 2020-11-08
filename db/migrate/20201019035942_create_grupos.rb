class CreateGrupos < ActiveRecord::Migration[6.0]
  def change
    create_table :grupos do |t|
      t.string :nombre
      t.string :proyecto
      t.integer :correlativo
      t.boolean :borrado, default:false
      t.datetime :delete_at

      t.timestamps
    end
  end
end
