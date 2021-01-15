class RemoveGrupoIdToStakeholders < ActiveRecord::Migration[6.0]
  def change
    remove_reference :stakeholders, :grupo, null: false, foreign_key: true
  end
end
