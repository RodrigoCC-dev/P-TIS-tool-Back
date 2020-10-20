class CreateRegistros < ActiveRecord::Migration[6.0]
  def change
    create_table :registros do |t|
      t.bigint :realizada_por
      t.references :minuta, null: false, foreign_key: true
      t.references :tipo_actividad, null: false, foreign_key: true

      t.timestamps
    end
  end
end
