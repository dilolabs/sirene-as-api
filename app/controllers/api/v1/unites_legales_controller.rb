module Api
  module V1
    class UnitesLegalesController < ApplicationController
      before_action :validate_siren, only: :show

      def index
        @unites_legales = UniteLegale.search(params[:q]).limit(10)
        render json: @unites_legales.as_json(
          except: [
            :created_at,
            :id,
            :tsvector_nom_tsearch,
            :updated_at
          ],
          include: [
            etablissements: {
              except: [
                :created_at,
                :id,
                :unite_legale_id,
                :updated_at,
              ]
            }
          ]
        )
      end

      def show
        @unite_legale = UniteLegale.find_by(siren: params[:siren])
        render json: @unite_legale.as_json(
          except: [
            :created_at,
            :id,
            :tsvector_nom_tsearch,
            :updated_at
          ],
          include: [
            etablissements: {
              except: [
                :created_at,
                :id,
                :unite_legale_id,
                :updated_at,
              ]
            }
          ]
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
