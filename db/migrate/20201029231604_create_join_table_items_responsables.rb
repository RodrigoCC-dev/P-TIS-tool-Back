class CreateJoinTableItemsResponsables < ActiveRecord::Migration[6.0]
  def change
    create_table :items_responsables, id: false do |t|
      t.references :item, null: false, foreign_key: true
      t.references :responsable, null: false, foreign_key: true
    end
  end
end
