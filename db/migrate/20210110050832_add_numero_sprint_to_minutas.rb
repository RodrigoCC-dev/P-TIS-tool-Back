class AddNumeroSprintToMinutas < ActiveRecord::Migration[6.0]
  def change
    add_column :minutas, :numero_sprint, :integer, default: 0
  end
end
