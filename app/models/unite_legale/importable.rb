module UniteLegale::Importable
  extend ActiveSupport::Concern

  require "csv"
  require "net/http"

  included do
    ZIP_SOURCE = "https://files.data.gouv.fr/insee-sirene/StockUniteLegale_utf8.zip"
    ZIP_DESTINATION = Rails.root.join("storage", "StockUniteLegale_utf8.zip")
    CSV_DESTINATION = Rails.root.join("storage", "StockUniteLegale_utf8.csv")

    def self.import_stock
      download_stock
      unzip_stock
      insert_csv
    end

    def self.download_stock(source: UniteLegale::Importable::ZIP_SOURCE, destination: UniteLegale::Importable::ZIP_DESTINATION)
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

    def self.unzip_stock(source: UniteLegale::Importable::ZIP_DESTINATION, destination: UniteLegale::Importable::CSV_DESTINATION)
      Rails.logger.info "Unzipping #{source} to #{destination}"

      system("unzip -o #{source} -d storage")

      Rails.logger.info "Unzipped #{source} to #{destination}"
    end

    def self.insert_csv(source: UniteLegale::Importable::CSV_DESTINATION)
      Rails.logger.info "Disabling triggers"
      ActiveRecord::Base.connection.execute("ALTER TABLE unite_legales DISABLE TRIGGER unite_legales_tsvector_nom_tsearch_update;")

      Rails.logger.info "Importing #{source}"
      if UniteLegale.any?
        CSV.foreach(source, headers: true, col_sep: ",") do |row|
          unite_legale = UniteLegale.find_by(siren: row["siren"])
          if unite_legale
            unite_legale.update!(row.to_h)
          else
            UniteLegale.create!(row.to_h)
          end
        end
      else
        CSV.open(source, headers: true, col_sep: ",").each_slice(1000) do |rows|
          UniteLegale.insert_all!(rows.map(&:to_h))
        end
      end
      Rails.logger.info "Imported #{source}"

      Rails.logger.info "Enabling triggers"
      ActiveRecord::Base.connection.execute("ALTER TABLE unite_legales ENABLE TRIGGER unite_legales_tsvector_nom_tsearch_update;")

      Rails.logger.info "Updating tsvector"
      ActiveRecord::Base.connection.execute <<-SQL
        UPDATE unite_legales SET tsvector_nom_tsearch = (
          setweight(to_tsvector('pg_catalog.french', coalesce("denominationUniteLegale", '')), 'A') ||
          setweight(to_tsvector('pg_catalog.french', coalesce("nomUniteLegale", '')), 'B')
        );
      SQL
      Rails.logger.info "Updated tsvector"
    end
  end
end
