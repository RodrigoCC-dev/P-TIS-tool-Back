class CreateTipoAprobaciones < ActiveRecord::Migration[6.0]
  def change
    create_table :tipo_aprobaciones do |t|
      t.string :identificador
      t.string :descripcion
      t.boolean :borrado
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
