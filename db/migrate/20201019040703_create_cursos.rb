class CreateCursos < ActiveRecord::Migration[6.0]
  def change
    create_table :cursos do |t|
      t.string :nombre
      t.string :codigo
      t.bool :borrado
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
