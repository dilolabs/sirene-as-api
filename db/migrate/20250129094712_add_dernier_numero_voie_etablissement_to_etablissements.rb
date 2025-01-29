class AddDernierNumeroVoieEtablissementToEtablissements < ActiveRecord::Migration[8.0]
  def change
    add_column :etablissements, :dernierNumeroVoieEtablissement, :string
    add_column :etablissements, :indiceRepetitionDernierNumeroVoieEtablissement, :string
  end
end
