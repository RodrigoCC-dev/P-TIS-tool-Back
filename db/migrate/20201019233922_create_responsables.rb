class CreateResponsables < ActiveRecord::Migration[6.0]
  def change
    create_table :responsables do |t|
      t.references :asistencia, null: false, foreign_key: true

      t.timestamps
    end
  end
end
