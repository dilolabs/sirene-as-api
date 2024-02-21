module Api
  module V1
    class EtablissementsController < ApplicationController
      before_action :validate_siret, only: :show

      def show
        @etablissement = Etablissement.find_by(siret: params[:siret])
        render json: @etablissement.as_json(
          include: [
            unite_legale: {
              except: [
                :created_at,
                :id,
                :tsvector_nom_tsearch,
                :updated_at
              ]
            }
          ],
          except: [
            :created_at,
            :id,
            :unite_legale_id,
            :updated_at,
          ]
        )
      end

      private

      def validate_siret
        unless params[:siret]&.match?(/^\d{14}$/)
          render json: { error: "Le SIRET doit être composé de 14 chiffres" }, status: :bad_request
          return
        end
      end
    end
  end
end
