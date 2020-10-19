class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :rol
      t.integer :rango
      t.bool :borrado
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
