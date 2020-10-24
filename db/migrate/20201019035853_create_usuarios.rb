class CreateUsuarios < ActiveRecord::Migration[6.0]
  def change
    create_table :usuarios do |t|
      t.string :nombre
      t.string :apellido_paterno
      t.string :apellido_materno
      t.string :run, unique: true
      t.string :correo_elec, null: false, unique: true
      t.string :password_digest, null: false
      t.boolean :borrado, default: false
      t.datetime :deleted_at
      t.references :rol, null: false, foreign_key: true

      t.timestamps
    end
  end
end
