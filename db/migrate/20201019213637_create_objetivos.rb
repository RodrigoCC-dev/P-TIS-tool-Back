class CreateObjetivos < ActiveRecord::Migration[6.0]
  def change
    create_table :objetivos do |t|
      t.text :descripcion
      t.boolean :borrado, default:false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
