class CreateTemas < ActiveRecord::Migration[6.0]
  def change
    create_table :temas do |t|
      t.string :tema
      t.references :bitacora_revision, null: false, foreign_key: true

      t.timestamps
    end
  end
end
