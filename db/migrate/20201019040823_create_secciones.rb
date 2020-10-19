class CreateSecciones < ActiveRecord::Migration[6.0]
  def change
    create_table :secciones do |t|
      t.string :codigo
      t.references :jornada, null: false, foreign_key: true
      t.references :semestre, null: false, foreign_key: true
      t.references :curso, null: false, foreign_key: true
      t.bool :borrado, default: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
