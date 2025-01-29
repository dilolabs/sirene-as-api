class AddCoordonneeLambertEtablissementToEtablissements < ActiveRecord::Migration[8.0]
  def change
    add_column :etablissements, :coordonneeLambertAbscisseEtablissement, :string
    add_column :etablissements, :coordonneeLambertOrdonneeEtablissement, :string
  end
end
