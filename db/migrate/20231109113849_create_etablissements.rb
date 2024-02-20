class CreateEtablissements < ActiveRecord::Migration[7.1]
  def change
    create_table :etablissements, id: :uuid do |t|
      t.belongs_to :unite_legale, null: false, foreign_key: true, type: :uuid
      t.string :activitePrincipaleEtablissement
      t.string :activitePrincipaleRegistreMetiersEtablissement
      t.integer :anneeEffectifsEtablissement
      t.string :caractereEmployeurEtablissement
      t.string :codeCedex2Etablissement
      t.string :codeCedexEtablissement
      t.string :codeCommune2Etablissement
      t.string :codeCommuneEtablissement
      t.string :codePaysEtranger2Etablissement
      t.string :codePaysEtrangerEtablissement
      t.string :codePostal2Etablissement
      t.string :codePostalEtablissement
      t.string :complementAdresse2Etablissement
      t.string :complementAdresseEtablissement
      t.date :dateCreationEtablissement
      t.date :dateDebut
      t.datetime :dateDernierTraitementEtablissement
      t.string :denominationUsuelleEtablissement
      t.string :distributionSpeciale2Etablissement
      t.string :distributionSpecialeEtablissement
      t.string :enseigne1Etablissement
      t.string :enseigne2Etablissement
      t.string :enseigne3Etablissement
      t.string :etablissementSiege
      t.string :etatAdministratifEtablissement
      t.string :indiceRepetition2Etablissement
      t.string :indiceRepetitionEtablissement
      t.string :libelleCedex2Etablissement
      t.string :libelleCedexEtablissement
      t.string :libelleCommune2Etablissement
      t.string :libelleCommuneEtablissement
      t.string :libelleCommuneEtranger2Etablissement
      t.string :libelleCommuneEtrangerEtablissement
      t.string :libellePaysEtranger2Etablissement
      t.string :libellePaysEtrangerEtablissement
      t.string :libelleVoie2Etablissement
      t.string :libelleVoieEtablissement
      t.string :nic
      t.integer :nombrePeriodesEtablissement
      t.string :nomenclatureActivitePrincipaleEtablissement
      t.string :numeroVoie2Etablissement
      t.string :numeroVoieEtablissement
      t.string :siren
      t.string :siret
      t.string :statutDiffusionEtablissement
      t.string :trancheEffectifsEtablissement
      t.string :typeVoie2Etablissement
      t.string :typeVoieEtablissement

      t.timestamps
    end
  end
end
