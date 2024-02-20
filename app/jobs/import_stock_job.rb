class ImportStockJob < ApplicationJob
  queue_as :default

  def perform
    UniteLegale.import_stock
    Etablissement.import_stock
  end
end
