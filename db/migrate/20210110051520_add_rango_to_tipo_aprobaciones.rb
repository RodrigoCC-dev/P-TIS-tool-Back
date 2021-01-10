class AddRangoToTipoAprobaciones < ActiveRecord::Migration[6.0]
  def change
    add_column :tipo_aprobaciones, :rango, :integer
  end
end
