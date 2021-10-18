class CreateTipoAsistencias < ActiveRecord::Migration[6.0]
  def change
    create_table :tipo_asistencias do |t|
      t.string :tipo, unique: true
      t.string :descripcion
      t.boolean :borrado, default: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
