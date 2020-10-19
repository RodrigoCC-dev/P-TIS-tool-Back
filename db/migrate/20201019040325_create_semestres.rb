class CreateSemestres < ActiveRecord::Migration[6.0]
  def change
    create_table :semestres do |t|
      t.integer :numero
      t.integer :agno
      t.bool :activo
      t.datetime :inicio
      t.datetime :fin
      t.bool :borrado
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
