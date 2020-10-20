class CreateClasificaciones < ActiveRecord::Migration[6.0]
  def change
    create_table :clasificaciones do |t|
      t.boolean :informativa, default: false
      t.boolean :avance, default: false
      t.boolean :coordinacion, default: false
      t.boolean :decision, default: false
      t.boolean :otro, default: false

      t.timestamps
    end
  end
end
