class AddBitacoraRevisionIdToConclusiones < ActiveRecord::Migration[6.0]
  def change
    add_reference :conclusiones, :bitacora_revision, null: false, foreign_key: true
  end
end
