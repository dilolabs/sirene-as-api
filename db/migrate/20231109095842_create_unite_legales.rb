class CreateUniteLegales < ActiveRecord::Migration[7.1]
  def change
    create_table :unite_legales, id: :uuid do |t|
      t.string :activitePrincipaleUniteLegale
      t.integer :anneeCategorieEntreprise
      t.integer :anneeEffectifsUniteLegale
      t.string :caractereEmployeurUniteLegale
      t.string :categorieEntreprise
      t.integer :categorieJuridiqueUniteLegale
      t.string :changementEtatAdministratifUniteLegale
      t.date :dateCreationUniteLegale
      t.date :dateDebut
      t.datetime :dateDernierTraitementUniteLegale
      t.string :denominationUniteLegale
      t.string :denominationUsuelle1UniteLegale
      t.string :denominationUsuelle2UniteLegale
      t.string :denominationUsuelle3UniteLegale
      t.string :economieSocialeSolidaireUniteLegale
      t.string :etatAdministratifUniteLegale
      t.string :identifiantAssociationUniteLegale
      t.string :nicSiegeUniteLegale
      t.integer :nombrePeriodesUniteLegale
      t.string :nomenclatureActivitePrincipaleUniteLegale
      t.string :nomUniteLegale
      t.string :nomUsageUniteLegale
      t.string :prenom1UniteLegale
      t.string :prenom2UniteLegale
      t.string :prenom3UniteLegale
      t.string :prenom4UniteLegale
      t.string :prenomUsuelUniteLegale
      t.string :pseudonymeUniteLegale
      t.string :sexeUniteLegale
      t.string :sigleUniteLegale
      t.string :siren
      t.string :societeMissionUniteLegale
      t.string :statutDiffusionUniteLegale
      t.string :trancheEffectifsUniteLegale
      t.string :unitePurgeeUniteLegale

      t.timestamps

      t.index :siren, unique: true
    end
  end
end
