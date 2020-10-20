class CreateRespuestas < ActiveRecord::Migration[6.0]
  def change
    create_table :respuestas do |t|
      t.text :respuesta
      t.boolean :borrado
      t.datetime :deleted_at
      t.references :comentario, null: false, foreign_key: true
      t.references :asistencia, null: false, foreign_key: true

      t.timestamps
    end
  end
end
