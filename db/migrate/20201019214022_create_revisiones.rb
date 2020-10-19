class CreateRevisiones < ActiveRecord::Migration[6.0]
  def change
    create_table :revisiones do |t|
      t.string :revision
      t.references :motivo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
