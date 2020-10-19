class CreateMinutas < ActiveRecord::Migration[6.0]
  def change
    create_table :minutas do |t|
      t.integer :correlativo
      t.datetime :fecha_reunion
      t.time :h_inicio
      t.time :h_termino
      t.string :tema
      t.references :estudiante, null: false, foreign_key: true
      t.references :tipo_minuta, null: false, foreign_key: true
      t.references :clasificacion, null: false, foreign_key: true
      t.bool :borrado, default: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
