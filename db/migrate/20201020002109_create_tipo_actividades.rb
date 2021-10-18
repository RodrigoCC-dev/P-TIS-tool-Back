class CreateTipoActividades < ActiveRecord::Migration[6.0]
  def change
    create_table :tipo_actividades do |t|
      t.string :actividad
      t.string :descripcion
      t.string :identificador, unique: true
      t.boolean :borrado, default: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
