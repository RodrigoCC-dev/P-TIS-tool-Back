class CreateTipoActividades < ActiveRecord::Migration[6.0]
  def change
    create_table :tipo_actividades do |t|
      t.string :actividad
      t.string :descripcion
      t.boolean :borrado
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
