class CreateBitacoraRevisiones < ActiveRecord::Migration[6.0]
  def change
    create_table :bitacora_revisiones do |t|
      t.references :revision, null: false, foreign_key: true
      t.references :minuta, null: false, foreign_key: true
      t.bool :emitida, default: false
      t.bool :activa, default: true

      t.timestamps
    end
  end
end
