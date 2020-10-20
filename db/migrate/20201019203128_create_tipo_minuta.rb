class CreateTipoMinutas < ActiveRecord::Migration[6.0]
  def change
    create_table :tipo_minutas do |t|
      t.string :tipo
      t.string :descripcion
      t.boolean :borrado, default: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
