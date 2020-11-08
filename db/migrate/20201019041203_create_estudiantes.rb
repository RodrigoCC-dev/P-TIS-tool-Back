class CreateEstudiantes < ActiveRecord::Migration[6.0]
  def change
    create_table :estudiantes do |t|
      t.string :iniciales
      t.references :usuario, null: false, foreign_key: true
      t.references :seccion, null: false, foreign_key: true
      t.references :grupo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
