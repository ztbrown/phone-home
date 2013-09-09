module Api
  module V1
    class TokensController < ApiController
      skip_before_filter :authenticate_user!, only: [:create]

      def create
        user = User.find_by_email(params[:email])

        if user.present? and user.valid_password?(params[:password])
          user.reset_authentication_token! unless user.authentication_token.present?

          render json: { auth_token: user.authentication_token }, status: 200
        else
          render json: { error: 'Invalid email or password' }, status: 401
        end
      end

      def destroy
        current_user.authentication_token = nil
        current_user.save

        render json: nil, status: 200
      end
    end
  end
end