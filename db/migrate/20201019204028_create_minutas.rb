class CreateMinutas < ActiveRecord::Migration[6.0]
  def change
    create_table :minutas do |t|
      t.integer :correlativo
      t.string :codigo
      t.datetime :fecha_reunion
      t.time :h_inicio
      t.time :h_termino
      t.references :estudiante, null: false, foreign_key: true
      t.references :tipo_minuta, null: false, foreign_key: true
      t.references :clasificacion, null: false, foreign_key: true
      t.boolean :borrado, default: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
