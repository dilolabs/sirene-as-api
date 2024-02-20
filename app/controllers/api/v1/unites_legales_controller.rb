module Api
  module V1
    class UnitesLegalesController < ApplicationController
      before_action :validate_siren, only: :show

      def index
        @unites_legales = UniteLegale.full_text_search(params[:q]).limit(10)
        render json: @unites_legales.as_json(
          include: :etablissements,
        )
      end

      def show
        @unite_legale = UniteLegale.find_by(siren: params[:siren])
        render json: @unite_legale.as_json(
          include: :etablissements,
        )
      end

      private

      def validate_siren
        unless params[:siren]&.match?(/^\d{9}$/)
          render json: { error: "Le SIREN doit être composé de 9 chiffres" }, status: :bad_request
          return
        end
      end
    end
  end
end
