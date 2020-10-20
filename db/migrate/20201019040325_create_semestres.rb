class CreateSemestres < ActiveRecord::Migration[6.0]
  def change
    create_table :semestres do |t|
      t.integer :numero
      t.integer :agno
      t.boolean :activo, default: true
      t.datetime :inicio
      t.datetime :fin
      t.boolean :borrado, default: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
