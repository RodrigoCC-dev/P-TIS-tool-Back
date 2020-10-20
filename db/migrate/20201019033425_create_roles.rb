class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :rol
      t.integer :rango
      t.boolean :borrado
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
