class CreateUsuarios < ActiveRecord::Migration[6.0]
  def change
    create_table :usuarios do |t|
      t.string :nombre
      t.string :apellido_paterno
      t.string :apellido_materno
      t.string :run
      t.string :correo_elec
      t.string :password
      t.bool :borrado
      t.datetime :deleted_at
      t.references :rol, null: false, foreign_key: true

      t.timestamps
    end
  end
end
