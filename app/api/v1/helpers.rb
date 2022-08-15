module V1
  module Helpers
    extend Grape::API::Helpers
    include Pagy::Backend

    def logger
      Base.logger
    end

    def current_user
      @user ||= User.authorize access_token_param
    end

    def current_payload
      return unless current_user

      @payload ||= Warden::JWTAuth::TokenDecoder.new.call(access_token_param[:access_token])
    end

    def user_authenticate!
      error!('401 Unauthorized', 401) unless current_user
    end

    def access_token_param
      if (match = headers['Authorization'].match(/^Bearer\s+([^,\s]+)/))
        access_token = match.captures.first
      end
      @access_token ||= access_token
      { access_token: @access_token }
    end

    def declared_params
      @declared_params ||= ActionController::Parameters.new(declared(params, include_missing: false)).permit!
    end

    def pagination_values(collection, option = {})
      pagy, data = pagy(collection, option)
      {
        data:,
        pagination: pagy
      }
    end

    def pagination_array(array)
      pagy, data = pagy_array array
      {
        data:,
        pagination: pagy
      }
    end

    params :only do
      optional :only, type: Array, desc: 'Use only to get only what you need!'
    end

    params :include do
      optional :include, type: String, desc: 'Option allow include addition data in response. Ex: total_unread'
    end

    params :pagination do
      optional :page, type: Integer, desc: 'Page number!'
    end
  end
end
