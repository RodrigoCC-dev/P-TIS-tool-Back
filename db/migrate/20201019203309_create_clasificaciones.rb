class CreateClasificaciones < ActiveRecord::Migration[6.0]
  def change
    create_table :clasificaciones do |t|
      t.bool :informativa, default: false
      t.bool :avance, default: false
      t.bool :coordinacion, default: false
      t.bool :decision, default: false
      t.bool :otro, default: false

      t.timestamps
    end
  end
end
