class CreateProfesores < ActiveRecord::Migration[6.0]
  def change
    create_table :profesores do |t|
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
