class CreateEstados < ActiveRecord::Migration[6.0]
  def change
    create_table :estados do |t|
      t.boolean :revisado
      t.references :tipo_estado, null: false, foreign_key: true

      t.timestamps
    end
  end
end
