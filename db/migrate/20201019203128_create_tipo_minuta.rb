class CreateTipoMinutas < ActiveRecord::Migration[6.0]
  def change
    create_table :tipo_minutas do |t|
      t.string :tipo
      t.string :descripcion
      t.bool :borrado, default: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
