class AddIdentificadorToSemestres < ActiveRecord::Migration[6.0]
  def change
    add_column :semestres, :identificador, :string, unique: true
  end
end
