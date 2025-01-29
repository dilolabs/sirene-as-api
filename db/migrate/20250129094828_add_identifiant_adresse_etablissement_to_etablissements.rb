class AddIdentifiantAdresseEtablissementToEtablissements < ActiveRecord::Migration[8.0]
  def change
    add_column :etablissements, :identifiantAdresseEtablissement, :string
  end
end
