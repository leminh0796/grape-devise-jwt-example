module Authenticate
  extend ActiveSupport::Concern

  included do
    attr_accessor :temp_password
  end

  def set_new_authentication_token
    token, payload = Warden::JWTAuth::UserEncoder.new.call(self, self.class.name.downcase.to_s, nil)
    on_jwt_dispatch(token, payload)
    token
  end

  def generate_temp_password
    self.temp_password = Devise.friendly_token.first(6)
    assign_attributes(password: temp_password, password_confirmation: temp_password)
    set_reset_password_token
  end

  def must_update_password
    reset_password_token.present?
  end

  protected

  module ClassMethods
    def authorize(params)
      return Warden::JWTAuth::UserDecoder.new.call(params[:access_token], :user, nil) if params[:access_token]

      account = find_for_database_authentication(params.slice(*authentication_keys))

      return unless account&.valid_password?(params[:password])

      account
    end

    def authorize!(params)
      account = authorize(params)

      raise ApplicationError, I18n.t('devise.failure.invalid', authentication_keys: authentication_keys.first.to_s) unless account

      raise ApplicationError, 'The temparory password has been expired' if account.reset_password_token.present? && !account.reset_password_period_valid?

      token = account.set_new_authentication_token
      [account, token]
    end
  end
end
