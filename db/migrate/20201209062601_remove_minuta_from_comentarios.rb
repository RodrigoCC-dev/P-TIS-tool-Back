class RemoveMinutaFromComentarios < ActiveRecord::Migration[6.0]
  def change
    remove_reference :comentarios, :minuta, null: false, foreign_key: true
    add_reference :comentarios, :bitacora_revision, null: false, foreign_key: true
  end
end
