namespace :sirene do
  require "csv"

  desc "Import stock from SIRENE"
  task import_stock: :environment do
    ImportStockJob.perform_later
  end
end
