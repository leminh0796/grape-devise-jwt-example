class V1::Users < Grape::API
  resource :users do
    desc 'Register User',
         {
           headers: {
             'Accept-Language': { description: 'Language' }
           }
         }
    params do
      optional :email, type: String, desc: 'Email', documentation: { in: 'body' }
      optional :password, type: String, desc: 'Password'
      optional :password_confirmation, type: String, desc: 'Password confirmation'
    end
    post :sign_up do
      user = AccountService.new(declared_params, 'user').create_new_account
      raise ActiveRecord::RecordInvalid, user if user.errors.any?

      status 200
      extra_infos = { message: I18n.t('message.create_success', name: 'user') }
      present extra_infos
      present user, with: Entities::V1::User
    end

    desc 'Returns User & access_token if valid login'
    params do
      requires :email, type: String, desc: 'Email or Phone', documentation: { in: 'body' }
      requires :password, type: String, desc: 'Password'
    end
    post :sign_in do
      status 200
      user, token = User.authorize! declared_params
      user.update_tracked_fields!(request)
      extra_infos = { access_token: token }
      present extra_infos
      present user, with: Entities::V1::User
    end

    desc 'User signs out',
         {
           headers: {
             Authorization: {
               description: 'Authorization access token',
               required: true
             }
           }
         }
    delete :sign_out do
      user_authenticate!
      User.revoke_jwt(current_payload, current_user)
      status 204
    end
  end
end
