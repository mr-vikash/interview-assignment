module Api
  module V1
    class BaseController < ApplicationController
      include Rails.application.routes.url_helpers

      rescue_from ActiveRecord::RecordNotFound do
        render json: {
          success: false,
          message: "Resource not found"
        }, status: :not_found
      end

      rescue_from ActionController::ParameterMissing do |e|
        render json: {
          success: false,
          message: e.message
        }, status: :bad_request
      end

      private

      def default_url_options
        Rails.application.config.action_mailer.default_url_options || {
          host: "localhost",
          port: 3000
        }
      end
    end
  end
end