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

      CSV.open(source, headers: true, col_sep: ",").each_slice(10000) do |rows|
        etablissements_to_create = []
        etablissements_to_update = []

        rows.each do |row|
          row_hash = row.to_h

          existing_etablissement = Etablissement.find_by(siret: row_hash["siret"])
          if existing_etablissement
            etablissements_to_update << row_hash.merge(id: existing_etablissement.id, unite_legale_id: existing_etablissement.unite_legale_id)
          else
            unite_legale = UniteLegale.find_by(siren: row_hash["siren"])
            next unless unite_legale
            etablissements_to_create << row_hash.merge(unite_legale_id: unite_legale.id)
          end
        end

        if etablissements_to_create.any?
          etablissements_to_create.in_groups_of(1000, false) do |group|
            Etablissement.insert_all(group)
          end
        end

        if etablissements_to_update.any?
          etablissements_to_update.in_groups_of(1000, false) do |group|
            Etablissement.upsert_all(group, unique_by: :id)
          end
        end
      end

      Rails.logger.info "Imported #{source}"
    end
  end
end
