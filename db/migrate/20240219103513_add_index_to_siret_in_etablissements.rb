class AddIndexToSiretInEtablissements < ActiveRecord::Migration[7.1]
  def change
    add_index :etablissements, :siret, unique: true
  end
end
