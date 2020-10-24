class AddBitacoraRevisionIdToObjetivos < ActiveRecord::Migration[6.0]
  def change
    add_reference :objetivos, :bitacora_revision, null: false, foreign_key: true
  end
end
