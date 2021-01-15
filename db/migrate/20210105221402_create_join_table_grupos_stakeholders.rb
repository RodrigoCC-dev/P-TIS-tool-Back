class CreateJoinTableGruposStakeholders < ActiveRecord::Migration[6.0]
  def change
    create_table :grupos_stakeholders, id: false do |t|
      t.references :stakeholder, null: false, foreign_key: true
      t.references :grupo, null: false, foreign_key: true
    end
  end
end
