class CreateAprobaciones < ActiveRecord::Migration[6.0]
  def change
    create_table :aprobaciones do |t|
      t.references :bitacora_revision, null: false, foreign_key: true
      t.references :asistencia, null: false, foreign_key: true
      t.references :tipo_aprobacion, null: false, foreign_key: true

      t.timestamps
    end
  end
end
