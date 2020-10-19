class CreateMotivos < ActiveRecord::Migration[6.0]
  def change
    create_table :motivos do |t|
      t.string :motivo
      t.bool :borrado, default: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
