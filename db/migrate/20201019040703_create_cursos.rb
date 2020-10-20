class CreateCursos < ActiveRecord::Migration[6.0]
  def change
    create_table :cursos do |t|
      t.string :nombre
      t.string :codigo
      t.boolean :borrado, default:false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
