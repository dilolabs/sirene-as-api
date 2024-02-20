# == Schema Information
#
# Table name: unite_legales
#
#  id                                        :uuid             not null, primary key
#  activitePrincipaleUniteLegale             :string
#  anneeCategorieEntreprise                  :integer
#  anneeEffectifsUniteLegale                 :integer
#  caractereEmployeurUniteLegale             :string
#  categorieEntreprise                       :string
#  categorieJuridiqueUniteLegale             :integer
#  changementEtatAdministratifUniteLegale    :string
#  dateCreationUniteLegale                   :date
#  dateDebut                                 :date
#  dateDernierTraitementUniteLegale          :datetime
#  denominationUniteLegale                   :string
#  denominationUsuelle1UniteLegale           :string
#  denominationUsuelle2UniteLegale           :string
#  denominationUsuelle3UniteLegale           :string
#  economieSocialeSolidaireUniteLegale       :string
#  etatAdministratifUniteLegale              :string
#  identifiantAssociationUniteLegale         :string
#  nicSiegeUniteLegale                       :string
#  nomUniteLegale                            :string
#  nomUsageUniteLegale                       :string
#  nombrePeriodesUniteLegale                 :integer
#  nomenclatureActivitePrincipaleUniteLegale :string
#  prenom1UniteLegale                        :string
#  prenom2UniteLegale                        :string
#  prenom3UniteLegale                        :string
#  prenom4UniteLegale                        :string
#  prenomUsuelUniteLegale                    :string
#  pseudonymeUniteLegale                     :string
#  sexeUniteLegale                           :string
#  sigleUniteLegale                          :string
#  siren                                     :string
#  societeMissionUniteLegale                 :string
#  statutDiffusionUniteLegale                :string
#  trancheEffectifsUniteLegale               :string
#  unitePurgeeUniteLegale                    :string
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#
# Indexes
#
#  index_unite_legales_on_siren  (siren) UNIQUE
#
class UniteLegale < ApplicationRecord
  include Importable
  include PgSearch::Model

  has_many :etablissements

  pg_search_scope :search_by_denomination, against: [:denominationUniteLegale, :nomUniteLegale, :prenom1UniteLegale, :prenom2UniteLegale, :prenom3UniteLegale, :prenom4UniteLegale, :prenomUsuelUniteLegale, :pseudonymeUniteLegale, :sigleUniteLegale], using: { tsearch: { prefix: true } }

  multisearchable against: [:denominationUniteLegale, :nomUniteLegale, :prenom1UniteLegale, :prenom2UniteLegale, :prenom3UniteLegale, :prenom4UniteLegale, :prenomUsuelUniteLegale, :pseudonymeUniteLegale, :sigleUniteLegale]

  scope :full_text_search, ->(query) {
    joins(:pg_search_document).merge(
      PgSearch.multisearch(query).where(searchable_type: klass.to_s)
    )
  }

  validates :siren, presence: true, uniqueness: true
end
