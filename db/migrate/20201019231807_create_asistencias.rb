class CreateAsistencias < ActiveRecord::Migration[6.0]
  def change
    create_table :asistencias do |t|
      t.bigint :id_estudiante
      t.bigint :id_stakeholder
      t.references :minuta, null: false, foreign_key: true
      t.references :tipo_asistencia, null: false, foreign_key: true

      t.timestamps
    end
  end
end
