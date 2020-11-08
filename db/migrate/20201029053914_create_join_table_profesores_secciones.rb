class CreateJoinTableProfesoresSecciones < ActiveRecord::Migration[6.0]
  def change
    create_table :profesores_secciones, id: false do |t|
      t.references :profesor, null: false, foreign_key: true
      t.references :seccion, null: false, foreign_key: true
    end
  end
end
