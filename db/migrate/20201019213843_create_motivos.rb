class CreateMotivos < ActiveRecord::Migration[6.0]
  def change
    create_table :motivos do |t|
      t.string :motivo
      t.string :identificador
      t.boolean :borrado, default: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
