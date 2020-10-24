class CreateJornadas < ActiveRecord::Migration[6.0]
  def change
    create_table :jornadas do |t|
      t.string :nombre
      t.integer :identificador
      t.boolean :borrado, default:false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
