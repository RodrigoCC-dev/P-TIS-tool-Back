class CreateGrupos < ActiveRecord::Migration[6.0]
  def change
    create_table :grupos do |t|
      t.string :nombre
      t.string :proyecto
      t.bool :borrado
      t.datetime :delete_at

      t.timestamps
    end
  end
end
