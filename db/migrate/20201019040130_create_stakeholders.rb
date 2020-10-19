class CreateStakeholders < ActiveRecord::Migration[6.0]
  def change
    create_table :stakeholders do |t|
      t.string :iniciales
      t.references :usuario, null: false, foreign_key: true
      t.references :grupo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
