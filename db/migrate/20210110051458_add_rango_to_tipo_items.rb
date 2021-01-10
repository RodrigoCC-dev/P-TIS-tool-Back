class AddRangoToTipoItems < ActiveRecord::Migration[6.0]
  def change
    add_column :tipo_items, :rango, :integer
  end
end
