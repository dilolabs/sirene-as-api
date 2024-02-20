module Etablissement::Importable
  extend ActiveSupport::Concern

  require "csv"
  require "net/http"

  included do
    ZIP_SOURCE = "https://files.data.gouv.fr/insee-sirene/StockEtablissement_utf8.zip"
    ZIP_DESTINATION = Rails.root.join("storage", "StockEtablissement_utf8.zip")
    CSV_DESTINATION = Rails.root.join("storage", "StockEtablissement_utf8.csv")

    def self.import_stock
      download_stock
      unzip_stock
      insert_csv
    end

    def self.download_stock(source: Etablissement::Importable::ZIP_SOURCE, destination: Etablissement::Importable::ZIP_DESTINATION)
      Rails.logger.info "Downloading #{source} to #{destination}"

      uri = URI.parse(source)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.path)

      http.request(request) do |response|
        open(destination, "wb") do |file|
          response.read_body do |chunk|
            file.write(chunk)
          end
        end
      end

      Rails.logger.info "Downloaded #{source} to #{destination}"
    end

    def self.unzip_stock(source: Etablissement::Importable::ZIP_DESTINATION, destination: Etablissement::Importable::CSV_DESTINATION)
      Rails.logger.info "Unzipping #{source} to #{destination}"

      system("unzip -o #{source} -d storage")

      Rails.logger.info "Unzipped #{source} to #{destination}"
    end

    def self.insert_csv(source: Etablissement::Importable::CSV_DESTINATION)
      Rails.logger.info "Importing #{source}"

      CSV.foreach(source, headers: true, col_sep: ",") do |row|
        etablissement = Etablissement.find_by(siret: row["siret"])
        if etablissement
          etablissement.update!(row.to_h)
        else
          unite_legale = Etablissement.find_by(siren: row["siren"])
          next unless unite_legale
          unite_legale.etablissements.create!(row.to_h)
        end
      end

      Rails.logger.info "Imported #{source}"
    end
  end
end
