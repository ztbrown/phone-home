module Api
  module V1
    class ApiController < ApplicationController
      prepend_before_filter :get_auth_token
      before_filter :skip_trackable
      skip_before_filter :verify_authenticity_token

      rescue_from CanCan::AccessDenied do |exception|
        render json: { error: exception.message }, status: 401
      end

      rescue_from ActiveRecord::RecordNotFound do |exception|
        render json: { error: exception.message }, status: 404
      end

      rescue_from ActiveRecord::RecordInvalid do |exception|
        render json: { error: exception.message }, status: 400
      end

      private

      def skip_trackable
        request.env['devise.skip_trackable'] = true
        request.session_options[:skip] = true
      end

      def get_auth_token
        if request.headers['X-Auth-Token'].present?
          params[:auth_token] = request.headers['X-Auth-Token']
        end
      end
    end
  end
end